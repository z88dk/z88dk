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
#include "files.h"
#include "hla.h"
#include "ir.h"
#include "lexer_dump.h"
#include "lexer_tokens.h"
#include "obj_expr.h"
#include "obj_extern.h"
#include "obj_file.h"
#include "obj_module.h"
#include "obj_schema.h"
#include "obj_section.h"
#include "obj_symbol.h"
#include "obj_symbol_scope.h"
#include "options.h"
#include "parser.h"
#include "preproc.h"
#include "release_assert.h"
#include "strings.h"
#include "synth_expander.h"
#include <filesystem>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

static constexpr uint MAX_PASSES = 100;

static bool split_modules_sections(Program& prog);
#if 0
static ObjectLibrary build_object_library(const Program& prog);
#endif

void assemble_files(const std::vector<std::string>& filenames,
                    std::string_view output_dir) {
    for (auto& filename : filenames) {
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

    // write object library
#if 0
    ObjectLibrary obj_lib = build_object_library(*prog);
    if (!write_object_library(obj_lib, o_filename)) {
        g_diag.error(SourceLoc(), "Failed to write object file");
        return; // error already reported
    }

    if (g_args.options.dump_after_assembly) {
        dump_obj_lib_and_exit(obj_lib);
        // not reached
    }
#endif
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
            std::string mod_name = g_strings.string(prog.name_id) + "_" +
                                   g_strings.string(mod_stmt->name_id);
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

#if 0
static ObjModule build_object_module(const Program& prog,
                                     const Module& mod) {
    ObjModule obj_mod;

    // global information for the module
    obj_mod.modname.set_name(g_strings.view(mod.name_id));
    obj_mod.cpu_id = g_args.options.cpu_id;
    obj_mod.swap_ixiy = g_args.options.swap_ixiy;

    // symbol table
    for (const auto& [name_id, sym_info] : mod.symbols) {
        ObjSymbol obj_sym;
        obj_sym.set_name(g_strings.view(name_id));
        obj_sym.set_filename(g_strings.view(sym_info->loc.filename_id));
        obj_sym.line = sym_info->loc.line;

        // check scope
        auto it_decl = prog.declarations.find(name_id);
        if (it_decl != prog.declarations.end()) {
            const SymbolDeclare* decl = it_decl->second.get();
            if (decl->type == SymbolDeclareType::Public ||
                    decl->type == SymbolDeclareType::Global) {
                obj_sym.scope = ObjSymbolScope::Public;
            }
            else if (decl->type == SymbolDeclareType::Extern) {
                continue; // skip external symbols
            }
        }
        else {
            obj_sym.scope = ObjSymbolScope::Local;
        }

        switch (sym_info->def_type) {
        case SymbolInfo::DefType::Label:
            release_assert(sym_info->stmt != nullptr);
            release_assert(sym_info->stmt->section != nullptr);
            obj_sym.type = ObjSymbolType::AddressRelative;
            obj_sym.value = sym_info->stmt->address;
            obj_sym.set_section_name(g_strings.view(sym_info->stmt->section->name_id));

            obj_mod.symbols.push_back(std::move(obj_sym));
            break;

        case SymbolInfo::DefType::Defc:
            release_assert(sym_info->defc_expr != nullptr);
            release_assert(sym_info->defc_expr->value.section != nullptr);

            switch (sym_info->defc_expr->value.type) {
            case ExprType::Constant:
                obj_sym.type = ObjSymbolType::Constant;
                obj_sym.value = sym_info->defc_expr->value.const_value;
                obj_sym.set_section_name(g_strings.view(
                                             sym_info->defc_expr->value.section->name_id));
                break;

            case ExprType::AddressRelative:
                obj_sym.type = ObjSymbolType::AddressRelative;
                obj_sym.value = sym_info->defc_expr->value.offset;
                obj_sym.set_section_name(g_strings.view(
                                             sym_info->defc_expr->value.section->name_id));
                break;

            case ExprType::Computed: {
                obj_sym.type = ObjSymbolType::Computed;
                obj_sym.value = 0;
                obj_sym.set_section_name(g_strings.view(
                                             sym_info->defc_expr->value.section->name_id));

                // create expression to define symbol value at link time
                ObjExpr obj_expr;
                obj_expr.set_text(to_string(sym_info->defc_expr->tokens));
                obj_expr.range = ObjRangeType::Assignment;
                obj_expr.set_section_name(g_strings.view(
                                              sym_info->defc_expr->value.section->name_id));
                obj_expr.set_target_name(g_strings.view(sym_info->name_id));
                obj_expr.set_filename(g_strings.view(sym_info->defc_expr->loc.filename_id));
                obj_expr.line = sym_info->defc_expr->loc.line;
                obj_mod.exprs.push_back(std::move(obj_expr));
                break;
            }
            default:
                release_assert(0); // should not happen
            }

            obj_mod.symbols.push_back(std::move(obj_sym));
            break;

        case SymbolInfo::DefType::Undefined: {
            release_assert(sym_info->def_type == SymbolInfo::DefType::Undefined);

            ObjExtern extern_;
            extern_.set_name(g_strings.view(sym_info->name_id));
            obj_mod.externs.push_back(std::move(extern_));
            break;
        }
        default:
            release_assert(0); // should not happen
        }
    }

    // sections
    for (const auto& sec : mod.sections) {
        ObjSection obj_sec;
        obj_sec.set_name(g_strings.view(sec->name_id));
        if (sec->section_split) {
            obj_sec.base_address = OrgSectionSplit;
        }
        else if (sec->org_defined) {
            obj_sec.base_address = sec->base_address;
        }
        else {
            obj_sec.base_address = OrgNotDefined;
        }
        obj_sec.align = sec->align;

        // statements
        for (auto& stmt : sec->stmts) {
            if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                for (auto& patch : opc_stmt->patches) {
                    ObjExpr obj_expr;
                    obj_expr.set_text(to_string(patch->inner->tokens));

                    // patch range is determined by the patch type and size
                    switch (patch->type) {
                    case PatchType::None:
                        continue; // already patched, no further action needed

                    case PatchType::Unsigned:
                        if (patch->size == 1) {
                            obj_expr.range = ObjRangeType::ByteUnsigned;
                        }
                        else if (patch->size == 2) {
                            obj_expr.range = ObjRangeType::Word;
                        }
                        else if (patch->size == 3) {
                            obj_expr.range = ObjRangeType::Ptr24;
                        }
                        else if (patch->size == 4) {
                            obj_expr.range = ObjRangeType::DWord;
                        }
                        else {
                            release_assert(0); // should not happen
                        }
                        break;

                    case PatchType::Signed:
                        if (patch->size == 1) {
                            obj_expr.range = ObjRangeType::ByteSigned;
                        }
                        else if (patch->size == 2) {
                            obj_expr.range = ObjRangeType::Word;
                        }
                        else if (patch->size == 3) {
                            obj_expr.range = ObjRangeType::Ptr24;
                        }
                        else if (patch->size == 4) {
                            obj_expr.range = ObjRangeType::DWord;
                        }
                        else {
                            release_assert(0); // should not happen
                        }
                        break;

                    case PatchType::HighByte:
                        release_assert(patch->size == 1);
                        obj_expr.range = ObjRangeType::HighOffset;
                        break;

                    case PatchType::BigEndian:
                        release_assert(patch->size == 2);
                        obj_expr.range = ObjRangeType::WordBE;
                        break;

                    case PatchType::PCrelative:
                        if (patch->size == 1) {
                            obj_expr.range = ObjRangeType::JrOffset;
                        }
                        else if (patch->size == 2) {
                            obj_expr.range = ObjRangeType::JreOffset;
                        }
                        else {
                            release_assert(0); // should not happen
                        }
                        break;
                    }

                    obj_expr.asmpc = stmt->address;
                    obj_expr.patch_ptr = static_cast<uint>(obj_sec.bytes().size() +
                                                           patch->offset);
                    obj_expr.opcode_size = static_cast<uint>(opc_stmt->bytes.size());
                    obj_expr.set_section_name(g_strings.view(sec->name_id));
                    obj_expr.set_target_name(""); // not used for opcode patches
                    obj_expr.set_filename(g_strings.view(patch->loc.filename_id));
                    obj_expr.line = patch->loc.line;
                    obj_mod.exprs.push_back(std::move(obj_expr));
                }
                obj_sec.set_bytes(BytesView(opc_stmt->bytes.data(),
                                            opc_stmt->bytes.size()));
                continue;
            }

            if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                obj_sec.set_bytes(BytesView(org_stmt->bytes.data(),
                                            org_stmt->bytes.size()));
                continue;
            }

            if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                obj_sec.set_bytes(BytesView(align_stmt->bytes.data(),
                                            align_stmt->bytes.size()));
                continue;
            }

            if (auto defs_num_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                obj_sec.set_bytes(BytesView(defs_num_stmt->bytes.data(),
                                            defs_num_stmt->bytes.size()));
                continue;
            }

            if (auto defs_str_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                obj_sec.set_bytes(BytesView(defs_str_stmt->bytes.data(),
                                            defs_str_stmt->bytes.size()));
                continue;
            }
        }

        obj_mod.sections.push_back(std::move(obj_sec));
    }

    return obj_mod;
}
#endif

#if 0
ObjectLibrary build_object_library(const Program& prog) {
    ObjectLibrary obj_lib;
    for (auto& mod : prog.modules) {
        // convert the module
        auto obj_mod = build_object_module(prog, *mod);

        // get list of public symbols
        for (const auto& sym : obj_mod.symbols) {
            if (sym.scope == ObjSymbolScope::Public) {
                obj_lib.public_symbols.insert(g_strings.intern(sym.name()));
            }
        }

        obj_lib.modules.push_back(std::move(obj_mod));
    }

    return obj_lib;
}
#endif
