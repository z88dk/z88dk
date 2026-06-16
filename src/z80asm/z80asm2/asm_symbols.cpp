//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_symbols.h"
#include "diag.h"
#include "ir.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cassert>

static bool resolve_local_labels(Program& prog);
static bool collect_program_declarations(Program& prog);
static bool collect_module_defined_symbols(Program& prog);
static bool collect_module_used_symbols(Program& prog);
static bool collect_used_symbols_in_expr(Program& prog, Module& mod, Stmt* stmt,
        Expr* expr);
static bool compare_declarations_definitions(Program& prog);
static bool declare_symbol(Program& prog,
                           StringInterner::Id name_id, SymbolDeclareType type,
                           const SourceLoc& loc);
static SymbolInfo* define_label(Program& prog, Module& mod,
                                StringInterner::Id name_id,
                                LabelStmt& lbl_stmt);
static SymbolInfo* define_defc(Program& prog, Module& mod,
                               StringInterner::Id name_id,
                               DefcStmt& defc_stmt);
static SymbolInfo* define_used_symbol(Program& prog, Module& mod,
                                      StringInterner::Id name_id,
                                      const SourceLoc& loc);

bool collect_symbols(Program& prog) {
    bool failed = false;
    if (!resolve_local_labels(prog)) {
        failed = true;
    }
    if (!collect_program_declarations(prog)) {
        failed = true;
    }
    if (!collect_module_defined_symbols(prog)) {
        failed = true;
    }
    if (!collect_module_used_symbols(prog)) {
        failed = true;
    }
    if (!compare_declarations_definitions(prog)) {
        failed = true;
    }
    return !failed;
}

static bool resolve_local_labels(Program& prog) {
    (void)prog; // TODO
    return true;
}

bool collect_program_declarations(Program& prog) {
    // collect all global/public/extern declarations
    bool failed = false;
    for (auto& stmt : prog.stmts) {
        if (auto sym_decl_stmt = dynamic_cast<SymbolDeclareStmt*>(stmt.get())) {
            for (auto& name : sym_decl_stmt->names) {
                if (!declare_symbol(prog, name.id, sym_decl_stmt->type,
                                    name.loc)) {
                    failed = true;
                }
            }
        }
    }
    return !failed;
}

bool collect_module_defined_symbols(Program& prog) {
    // collect all label/defc definitions
    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            for (auto& stmt : sec->stmts) {
                if (auto label_stmt = dynamic_cast<LabelStmt*>(stmt)) {
                    SymbolInfo* sym = define_label(prog, *mod, label_stmt->name_id, *label_stmt);
                    if (sym) {
                        label_stmt->symbol = sym;
                    }
                    else {
                        failed = true;
                    }
                    continue;
                }

                if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt)) {
                    SymbolInfo* sym = define_defc(prog, *mod, defc_stmt->name_id, *defc_stmt);
                    if (sym) {
                        defc_stmt->symbol = sym;
                    }
                    else {
                        failed = true;
                    }
                    continue;
                }
            }
        }
    }
    return !failed;
}

bool collect_module_used_symbols(Program& prog) {
    // collect symbol references in statements and resolve them to symbol info
    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            for (auto& stmt : sec->stmts) {
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    for (auto& patch : opc_stmt->patches) {
                        if (!collect_used_symbols_in_expr(prog, *mod, opc_stmt, patch->inner.get())) {
                            failed = true;
                        }
                    }
                    continue;
                }

                if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, org_stmt, org_stmt->expr.get())) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, defc_stmt,
                                                      defc_stmt->expr.get())) {
                        failed = true;
                    }
                    continue;
                }

                if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, align_stmt,
                                                      align_stmt->align_expr.get())) {
                        failed = true;
                    }
                    if (!collect_used_symbols_in_expr(prog, *mod, align_stmt,
                                                      align_stmt->filler_expr.get())) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, defs_stmt,
                                                      defs_stmt->size_expr.get())) {
                        failed = true;
                    }
                    if (!collect_used_symbols_in_expr(prog, *mod, defs_stmt,
                                                      defs_stmt->filler_expr.get())) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, defs_stmt,
                                                      defs_stmt->size_expr.get())) {
                        failed = true;
                    }
                    continue;
                }

                if (auto phase_stmt = dynamic_cast<PhaseStmt*>(stmt)) {
                    if (!collect_used_symbols_in_expr(prog, *mod, phase_stmt,
                                                      phase_stmt->expr.get())) {
                        failed = true;
                    }
                    continue;
                }
            }
        }
    }
    return !failed;
}

bool collect_used_symbols_in_expr(Program& prog, Module& mod,
                                  Stmt* stmt, Expr* expr) {
    if (auto asmpc_expr = dynamic_cast<ExprLiteralAsmpc*>(expr)) {
        asmpc_expr->stmt = stmt;
        return true;
    }

    if (auto sym_expr = dynamic_cast<ExprSymbol*>(expr)) {
        SymbolInfo* sym = define_used_symbol(prog, mod, sym_expr->name_id,
                                             sym_expr->loc);
        if (!sym) {
            return false; // error already reported
        }
        sym_expr->symbol = sym;
        return true;
    }

    if (auto lbl_expr = dynamic_cast<ExprLocalLabel*>(expr)) {
        SymbolInfo* sym = define_used_symbol(prog, mod, lbl_expr->name_id,
                                             lbl_expr->loc);
        if (!sym) {
            return false; // error already reported
        }
        lbl_expr->symbol = sym;
        return true;
    }

    if (auto un_expr = dynamic_cast<ExprUnary*>(expr)) {
        if (!collect_used_symbols_in_expr(prog, mod, stmt, un_expr->rhs.get())) {
            return false; // error already reported
        }
        return true;
    }

    if (auto bin_expr = dynamic_cast<ExprBinary*>(expr)) {
        bool failed = false;
        if (!collect_used_symbols_in_expr(prog, mod, stmt, bin_expr->lhs.get())) {
            failed = true; // error already reported
        }
        if (!collect_used_symbols_in_expr(prog, mod, stmt, bin_expr->rhs.get())) {
            failed = true; // error already reported
        }
        return !failed;
    }

    if (auto tern_expr = dynamic_cast<ExprTernary*>(expr)) {
        bool failed = false;
        if (!collect_used_symbols_in_expr(prog, mod, stmt, tern_expr->cond.get())) {
            failed = true; // error already reported
        }
        if (!collect_used_symbols_in_expr(prog, mod, stmt,
                                          tern_expr->then_expr.get())) {
            failed = true; // error already reported
        }
        if (!collect_used_symbols_in_expr(prog, mod, stmt,
                                          tern_expr->else_expr.get())) {
            failed = true; // error already reported
        }
        return !failed;
    }

    if (auto arg_expr = dynamic_cast<ExprCallUnary*>(expr)) {
        if (!collect_used_symbols_in_expr(prog, mod, stmt, arg_expr->arg.get())) {
            return false; // error already reported
        }
        return true;
    }

    return false;
}

static bool compare_declarations_definitions(Program& prog) {
    bool failed = false;

    // check if there is more than one definition for PUBLIC/GLOBAL symbols
    // check if are 0 definitions for PUBLIC symbols
    std::unordered_map<StringInterner::Id, std::vector<SourceLoc>> definitions;

    // collect all modules' symbol definitions
    for (auto& mod : prog.modules) {
        for (auto& [name_id, sym] : mod->symbols) {
            if (sym->type != SymbolInfo::SymbolType::Undefined) {
                definitions[name_id].push_back(sym->loc);
            }
        }
    }

    // check the declarations
    for (auto& [name_id, decl] : prog.declarations) {
        if (decl->type == SymbolDeclareType::Extern) {
            continue;
        }

        // search the definitions
        auto it = definitions.find(name_id);
        if (it == definitions.end()) { // 0 definitions
            if (decl->type == SymbolDeclareType::Public) {
                g_diag.error(decl->loc,
                             "Undefined symbol: " + g_strings.to_string(name_id));
                failed = true;
            }
            continue;
        }

        // at least 1 definition found, check if more than 1 for PUBLIC/GLOBAL
        if ((decl->type == SymbolDeclareType::Public ||
                decl->type == SymbolDeclareType::Global) &&
                it->second.size() > 1) { // more than 1 definition
            for (auto& loc : it->second) {
                g_diag.error(loc,
                             "Duplicate symbol: " + g_strings.to_string(name_id));
            }
            g_diag.note(decl->loc, "Declaration here");
            failed = true;
        }
    }

    return !failed;
}

static bool declare_symbol(Program& prog,
                           StringInterner::Id name_id, SymbolDeclareType type,
                           const SourceLoc& loc) {

    // Lambda to update saw_* flags
    auto update_flags = [](SymbolDeclare & decl, SymbolDeclareType type) {
        switch (type) {
        case SymbolDeclareType::Extern:
            decl.saw_extern = true;
            break;
        case SymbolDeclareType::Public:
            decl.saw_public = true;
            break;
        case SymbolDeclareType::Global:
            decl.saw_global = true;
            break;
        default:
            assert(0);
        }
    };

    // check if previously declared
    auto it = prog.declarations.find(name_id);
    if (it == prog.declarations.end()) {    // new entry
        auto decl = std::make_unique<SymbolDeclare>(name_id, type, loc);
        update_flags(*decl, type);
        prog.declarations[name_id] = std::move(decl);
        return true;
    }

    // symbol declared previously
    auto& old_decl = it->second;

    // ALWAYS update saw_* flags
    update_flags(*old_decl, type);

    // is this the same declaration as before?
    if (old_decl->type == type) {
        return true; // same type
    }

    // check new type against old type
    switch (type) {
    case SymbolDeclareType::Extern:
        if (old_decl->type == SymbolDeclareType::Public ||
                old_decl->type == SymbolDeclareType::Global) {
            return true; // ignore
        }
        break; // issue error

    case SymbolDeclareType::Public:
        if (old_decl->type == SymbolDeclareType::Extern) {
            old_decl->type = type; // upgrade
            return true;
        }
        if (old_decl->type == SymbolDeclareType::Global) {
            return true; // ignore
        }
        break; // issue error

    case SymbolDeclareType::Global:
        if (old_decl->type == SymbolDeclareType::Public ||
                old_decl->type == SymbolDeclareType::Extern) {
            return true; // ignore
        }
        break; // issue error

    default:
        assert(0);
    }

    // checks failed, error message
    g_diag.error(loc, "Symbol redeclaration: " + g_strings.to_string(name_id));
    g_diag.note(old_decl->loc, "Previous declaration");
    return false;
}

static bool can_define_symbol(Program& prog, Module& mod,
                              StringInterner::Id name_id, const SourceLoc& loc) {
    // Check previous declaration
    auto it_decl = prog.declarations.find(name_id);
    if (it_decl != prog.declarations.end()) {
        auto decl = it_decl->second.get();

        if (decl->saw_extern) {
            // EXTERN was seen before this definition -> allowed
            // but EXTERN after definition will be caught in compare_declarations_definitions()
        }

        if (decl->type == SymbolDeclareType::Extern) {
            // EXTERN seen before definition -> allowed
            // but EXTERN after definition will be caught in compare_declarations_definitions()
        }

        if (decl->type == SymbolDeclareType::Public) {
            // PUBLIC requires definition, so defining is allowed
        }

        if (decl->type == SymbolDeclareType::Global) {
            // GLOBAL becomes PUBLIC when defined
            decl->type = SymbolDeclareType::Public;
        }
    }

    // check if previously defined
    auto it_def = mod.symbols.find(name_id);
    if (it_def == mod.symbols.end()) {
        return true; // new symbol, can define
    }

    // Redefinition error
    auto& old_def = it_def->second;
    g_diag.error(loc, "Duplicate definition: " + g_strings.to_string(name_id));
    g_diag.note(old_def->loc, "Previous definition");
    return false;
}

static SymbolInfo* define_label(Program& prog, Module& mod,
                                StringInterner::Id name_id,
                                LabelStmt& lbl_stmt) {
    if (!can_define_symbol(prog, mod, name_id, lbl_stmt.loc)) {
        return nullptr;
    }

    // define symbol
    auto sym = std::make_unique<SymbolInfo>(name_id, SymbolInfo::SymbolType::Label,
                                            lbl_stmt.loc);
    sym->section = lbl_stmt.section;
    sym->stmt = &lbl_stmt;
    auto ret = sym.get();
    mod.symbols[name_id] = std::move(sym);
    return ret;
}

static SymbolInfo* define_defc(Program& prog, Module& mod,
                               StringInterner::Id name_id,
                               DefcStmt& defc_stmt) {
    if (!can_define_symbol(prog, mod, name_id, defc_stmt.loc)) {
        return nullptr;
    }

    // define symbol
    auto sym = std::make_unique<SymbolInfo>(name_id, SymbolInfo::SymbolType::Defc,
                                            defc_stmt.loc);
    sym->section = defc_stmt.section;
    sym->stmt = &defc_stmt;
    auto ret = sym.get();
    mod.symbols[name_id] = std::move(sym);
    return ret;
}

static SymbolInfo* define_used_symbol(Program& prog, Module& mod,
                                      StringInterner::Id name_id,
                                      const SourceLoc& loc) {
    // if symbol defined, return pointer
    auto it_def = mod.symbols.find(name_id);
    if (it_def != mod.symbols.end()) {
        return it_def->second.get();
    }

    // check if symbol declared as EXTERN, PUBLIC or GLOBAL
    auto it_decl = prog.declarations.find(name_id);
    if (it_decl != prog.declarations.end()) {
        auto decl = it_decl->second.get();

        if (decl->type == SymbolDeclareType::Public) {
            // should be defined
            g_diag.error(loc, "Undefined symbol: " +
                         g_strings.to_string(name_id));
            return nullptr;
        }

        // Extern or GLobal: create undefined symbol info
        auto sym = std::make_unique<SymbolInfo>(name_id,
                                                SymbolInfo::SymbolType::Undefined,
                                                loc);
        auto ret = sym.get();
        mod.symbols[name_id] = std::move(sym);
        return ret;
    }

    g_diag.error(loc, "Undefined symbol: " + g_strings.to_string(name_id));
    return nullptr;
}
