//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_driver.h"
#include "asm_expr.h"
#include "asm_layout.h"
#include "asm_symbols.h"
#include "diag.h"
#include "hla.h"
#include "ir.h"
#include "lexer_dump.h"
#include "lexer_tokens.h"
#include "obj_file.h"
#include "options.h"
#include "parser.h"
#include "pathnames.h"
#include "preproc.h"
#include "synth_expander.h"
#include <filesystem>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

static const uint MAX_PASSES = 100;

static bool split_modules_sections(Program& prog);
static ObjectFile build_object_file_from_program(const Program& prog);

void assemble_files(std::vector<std::string>& filenames,
                    std::string_view output_dir) {
    for (const std::string& filename : filenames) {
        if (is_o_filename(filename)) {
            if (g_args.options.verbose) {
                std::cout << "Skipping object file " << filename
                          << "..." << std::endl;
            }
        }
        else {
            assemble_file(filename, output_dir);
        }
    }
}

void assemble_file(std::string_view filename, std::string_view output_dir) {
    std::string o_filename = get_o_filename(filename, output_dir);

    if (g_args.options.verbose) {
        std::cout << "Assembling " << filename << "..." << std::endl;
    }

    // run tokenizer and cache tokens in SourceFile
    if (g_args.options.dump_after_tokenization) {
        dump_after_tokenization_and_exit(filename);
        // not reached
    }

    // run preprocessor and get final token stream
    Preproc preproc;
    preproc.set_const_symbols(g_args.options.global_defs);
    std::vector<LogicalLine> preprocessed_tokens = preproc.preprocess(filename);

    // generate -MD output, if requested
    if (g_args.options.generate_dependencies) {
        std::string d_filename = get_d_filename(filename, output_dir);
        preproc.output_dependencies(d_filename, o_filename);
    }

    // process High-Level-Assembly instructions
    std::vector<LogicalLine> hla_lines = hla_process(preprocessed_tokens);
    if (g_args.options.dump_after_hla_expansion) {
        dump_logical_lines_and_exit(hla_lines);
        // not reached
    }

    // process synthetic instructions and rewrite tokens
    // to their final form for the assembler
    SynthExpander synth_expander(hla_lines);
    std::vector<LogicalLine> asm_lines = synth_expander.expand();
    if (g_args.options.dump_after_synth_expansion) {
        dump_logical_lines_and_exit(asm_lines);
        // not reached
    }

    // generate -E output and terminate assembly, if requested
    if (g_args.options.preprocess_only) {
        std::string i_filename = get_i_filename(filename);
        output_preproc_output(i_filename, asm_lines);
        return;
    }

    // parse source code
    std::string prog_name = std::filesystem::path(filename).stem().generic_string();
    prog_name = make_ident(prog_name);
    Parser parser(asm_lines);
    std::unique_ptr<Program> prog = parser.parse(prog_name);

    if (g_args.options.dump_after_parse) {
        dump_ast_and_exit(prog);
        // not reached
    }

    // split into modules and sections
    if (!split_modules_sections(*prog)) {
        return; // error already reported
    }

    // collect symbols
    if (!collect_symbols(*prog)) {
        return; // error already reported
    }

    if (g_args.options.dump_after_symbol_collection) {
        dump_ast_and_exit(prog);
        // not reached
    }

    // fixpoint loop for layout and address resolution
    bool changed = true;
    uint pass = 0;
    while (changed) {
        changed = false;

        // safegard against infinite loops in case of errors that cause addresses to keep changing
        pass++;
        if (pass > MAX_PASSES) {
            g_diag.error(SourceLoc(), "Maximum number of passes exceeded");
            return; // error already reported
        }

        // compute layout and addresses
        if (!compute_layout(*prog, changed)) {
            return; // error already reported
        }

        // evaluate expressions
        if (!eval_exprs(*prog, changed, /*silent=*/true)) {
            return; // error already reported
        }

        // check if jumps must be converted to long jumps
        check_jumps(*prog, changed);
    }

    // final evaluation of expressions with error reporting
    if (!eval_exprs(*prog, changed, /*silent=*/false)) {
        return; // error already reported
    }

    // compute patches and emit range errors
    if (!apply_patches(*prog)) {
        return; // error already reported
    }

    if (g_args.options.dump_after_layout) {
        dump_ast_and_exit(prog);
        // not reached
    }

    // TODO: object file writer
    ObjectFile obj = build_object_file_from_program(*prog);
    if (!write_object_file(obj, o_filename)) {
        g_diag.error(SourceLoc(), "Failed to write object file");
        return; // error already reported
    }
}

static bool split_modules_sections(Program& prog) {
    // create initial module and initial section
    Module* cur_module = prog.set_module(prog.name_id);
    Section* cur_section = cur_module->set_section(g_strings.intern(
                               DEFAULT_SECTION));

    // collect all module and section definitions
    bool failed = false;
    for (auto& stmt : prog.stmts) {
        if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt.get())) {
            opc_stmt->section = cur_section;
            cur_section->stmts.push_back(opc_stmt);
            cur_section->has_opcodes = true;
            continue;
        }

        if (auto lbl_stmt = dynamic_cast<LabelStmt*>(stmt.get())) {
            lbl_stmt->section = cur_section;
            cur_section->stmts.push_back(lbl_stmt);
            cur_section->has_opcodes = true;
            continue;
        }

        if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt.get())) {
            if (cur_section->has_opcodes) {
                // ORG as space allocator
                cur_section->stmts.push_back(org_stmt);
                cur_section->has_opcodes = true;
            }
            else {
                // ORG as section start address
                if (cur_section->org_stmt) {
                    g_diag.warning(org_stmt->loc, "ORG redefined");
                    g_diag.note(cur_section->org_stmt->loc, "Previous definition");
                }
                cur_section->org_stmt = org_stmt;
            }
            continue;
        }

        if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt.get())) {
            defc_stmt->section = cur_section;
            cur_section->stmts.push_back(defc_stmt);
            continue;
        }

        if (auto mod_stmt = dynamic_cast<ModuleStmt*>(stmt.get())) {
            std::string mod_name = g_strings.to_string(prog.name_id) + "_" +
                                   g_strings.to_string(mod_stmt->name_id);
            cur_module = prog.set_module(g_strings.intern(mod_name));
            cur_section = cur_module->cur_section;
            continue;
        }

        if (auto sec_stmt = dynamic_cast<SectionStmt*>(stmt.get())) {
            cur_section = cur_module->set_section(sec_stmt->name_id);
            continue;
        }

        if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt.get())) {
            if (cur_section->has_opcodes) {
                // ALIGN as space allocator
                cur_section->stmts.push_back(align_stmt);
                cur_section->has_opcodes = true;
            }
            else {
                // ALIGN as section start address constraint
                if (cur_section->align_stmt) {
                    g_diag.warning(align_stmt->loc, "ALIGN redefined");
                    g_diag.note(cur_section->align_stmt->loc, "Previous definition");
                }
                cur_section->align_stmt = align_stmt;
            }
            continue;
        }

        if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt.get())) {
            defs_stmt->section = cur_section;
            cur_section->stmts.push_back(defs_stmt);
            cur_section->has_opcodes = true;
            continue;
        }

        if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt.get())) {
            defs_stmt->section = cur_section;
            cur_section->stmts.push_back(defs_stmt);
            cur_section->has_opcodes = true;
            continue;
        }

        if (auto phase_stmt = dynamic_cast<PhaseStmt*>(stmt.get())) {
            phase_stmt->section = cur_section;
            cur_section->stmts.push_back(phase_stmt);
            cur_section->has_opcodes = true;
            continue;
        }

        if (auto dephase_stmt = dynamic_cast<DephaseStmt*>(stmt.get())) {
            dephase_stmt->section = cur_section;
            cur_section->stmts.push_back(dephase_stmt);
            cur_section->has_opcodes = true;
            continue;
        }
    }

    return !failed;
}

ObjectFile build_object_file_from_program(const Program& prog) {
    (void)prog; // suppress unused parameter warning
    return ObjectFile();
}
