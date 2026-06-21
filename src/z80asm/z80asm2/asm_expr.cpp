//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_expr.h"
#include "diag.h"
#include "expr.h"
#include "ir.h"
#include <cassert>
#include <string>
#include <string_view>

static bool eval_expr(Expr* expr, bool& changed, bool silent);
static bool eval_const_expr(Expr* expr, bool& changed, bool silent);

bool get_const_expr_value(const Expr* expr, int& out_value,
                          std::string_view error_kw) {
    if (expr) {
        switch (expr->value.type) {
        case ExprType::Unknown:
            // not known yet, will be evaluated later
            return true;

        case ExprType::Constant:
            out_value = expr->value.const_value;
            return true;

        case ExprType::AddressRelative:
        case ExprType::Computed:
            g_diag.error(expr->loc,
                         std::string(error_kw) + " expression must be constant");
            return false;

        default:
            assert(0);
        }
    }

    return false;
}

bool get_const_expr_value(const Expr* expr, uint& out_value,
                          std::string_view error_kw) {
    int int_value = static_cast<int>(out_value);    // copy default value
    if (!get_const_expr_value(expr, int_value, error_kw)) {
        return false;
    }

    if (int_value < 0) {
        g_diag.error(expr->loc,
                     std::string(error_kw) + " cannot be negative");
        return false;
    }

    out_value = static_cast<uint>(int_value);
    return true;
}

bool eval_exprs(Program& prog, bool& changed, bool silent) {
    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {

            // section level ORG
            if (sec->org_stmt) {
                if (!eval_const_expr(sec->org_stmt->expr.get(), changed, silent)) {
                    failed = true;
                }
            }

            // section level ALIGN
            if (sec->align_stmt) {
                if (!eval_const_expr(sec->align_stmt->align_expr.get(), changed, silent)) {
                    failed = true;
                }
                if (!eval_const_expr(sec->align_stmt->filler_expr.get(), changed, silent)) {
                    failed = true;
                }
            }

            // section statements
            for (auto& stmt : sec->stmts) {
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    for (auto& patch : opc_stmt->patches) {
                        if (!eval_expr(patch->inner.get(), changed, silent)) {
                            failed = true;
                        }
                    }
                    continue;
                }

                if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                    if (!eval_const_expr(org_stmt->expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt)) {
                    if (!eval_expr(defc_stmt->expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }

                if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                    if (!eval_const_expr(align_stmt->align_expr.get(), changed, silent)) {
                        failed = true;
                    }
                    if (!eval_const_expr(align_stmt->filler_expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                    if (!eval_const_expr(defs_stmt->size_expr.get(), changed, silent)) {
                        failed = true;
                    }
                    if (!eval_const_expr(defs_stmt->filler_expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                    if (!eval_const_expr(defs_stmt->size_expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }

                if (auto phase_stmt = dynamic_cast<PhaseStmt*>(stmt)) {
                    if (!eval_const_expr(phase_stmt->expr.get(), changed, silent)) {
                        failed = true;
                    }
                    continue;
                }
            }
        }
    }

    return !failed;
}

template<typename T>
static void update_if_changed(T& target, const T& new_value, bool& changed) {
    if (target != new_value) {
        target = new_value;
        changed = true;
    }
}

static bool eval_expr(Expr* expr, bool& changed, bool silent) {
    if (auto int_expr = dynamic_cast<ExprLiteralInt*>(expr)) {
        update_if_changed(int_expr->value.type, ExprType::Constant, changed);
        update_if_changed(int_expr->value.const_value, int_expr->int_value, changed);
        return true;
    }

    if (auto float_expr = dynamic_cast<ExprLiteralFloat*>(expr)) {
        update_if_changed(float_expr->value.type, ExprType::Constant, changed);
        update_if_changed(float_expr->value.const_value,
                          static_cast<int>(float_expr->float_value), changed);
        return true;
    }

    if (auto asmpc_expr = dynamic_cast<ExprLiteralAsmpc*>(expr)) {
        assert(asmpc_expr->stmt != nullptr);
        assert(asmpc_expr->stmt->section != nullptr);
        update_if_changed(asmpc_expr->value.type, ExprType::AddressRelative, changed);
        update_if_changed(asmpc_expr->value.section,
                          asmpc_expr->stmt->section, changed);
        update_if_changed(asmpc_expr->value.offset,
                          asmpc_expr->stmt->address, changed);
        return true;
    }

    if (auto sym_expr = dynamic_cast<ExprSymbol*>(expr)) {
        assert(sym_expr->symbol != nullptr);
        switch (sym_expr->symbol->def_type) {
        case SymbolInfo::DefType::Undefined: // extern
            update_if_changed(sym_expr->value.type, ExprType::Unknown, changed);
            break;

        case SymbolInfo::DefType::Label:
            assert(sym_expr->symbol->stmt != nullptr);
            update_if_changed(sym_expr->value.type, ExprType::AddressRelative, changed);
            update_if_changed(sym_expr->value.section,
                              sym_expr->symbol->stmt->section, changed);
            update_if_changed(sym_expr->value.offset,
                              sym_expr->symbol->stmt->address, changed);
            return true;

        case SymbolInfo::DefType::Defc:
            assert(sym_expr->symbol->defc_expr != nullptr);
            switch (sym_expr->symbol->defc_expr->value.type) {
            case ExprType::Unknown:
                update_if_changed(sym_expr->value.type, ExprType::Unknown, changed);
                break;
            case ExprType::Constant:
                update_if_changed(sym_expr->value.type, ExprType::Constant, changed);
                update_if_changed(sym_expr->value.const_value,
                                  sym_expr->symbol->defc_expr->value.const_value, changed);
                break;
            case ExprType::AddressRelative:
                update_if_changed(sym_expr->value.type, ExprType::AddressRelative, changed);
                update_if_changed(sym_expr->value.section,
                                  sym_expr->symbol->defc_expr->value.section, changed);
                update_if_changed(sym_expr->value.offset,
                                  sym_expr->symbol->defc_expr->value.offset, changed);
                break;
            case ExprType::Computed:
                update_if_changed(sym_expr->value.type, ExprType::Computed, changed);
                update_if_changed(sym_expr->value.tokens,
                                  sym_expr->symbol->defc_expr->value.tokens, changed);
                break;
            default:
                assert(0);
            }
            return true;

        default:
            assert(0);
        }
    }

    if (auto llbl_expr = dynamic_cast<ExprLocalLabel*>(expr)) {
        assert(llbl_expr->symbol != nullptr);
        assert(llbl_expr->symbol->stmt != nullptr);
        update_if_changed(llbl_expr->value.type, ExprType::AddressRelative, changed);
        update_if_changed(llbl_expr->value.section,
                          llbl_expr->symbol->stmt->section, changed);
        update_if_changed(llbl_expr->value.offset,
                          llbl_expr->symbol->stmt->address, changed);
        return true;
    }

    if (auto un_expr = dynamic_cast<ExprUnary*>(expr)) {
        if (!eval_expr(un_expr->rhs.get(), changed, silent)) {
            return false; // error already reported
        }

        if (un_expr->rhs->value.type == ExprType::Unknown) {
            update_if_changed(un_expr->value.type, ExprType::Unknown, changed);
        }
        else if (un_expr->rhs->value.type == ExprType::Constant) {
            int result = int_unary(un_expr->op, un_expr->rhs->value.const_value,
                                   un_expr->loc, silent);
            update_if_changed(un_expr->value.type, ExprType::Constant, changed);
            update_if_changed(un_expr->value.const_value,
                              result, changed);
        }
        else {
            update_if_changed(un_expr->value.type, ExprType::Computed, changed);
        }

        return true;
    }

    if (auto bin_expr = dynamic_cast<ExprBinary*>(expr)) {
        if (!eval_expr(bin_expr->lhs.get(), changed, silent)) {
            return false; // error already reported
        }
        if (!eval_expr(bin_expr->rhs.get(), changed, silent)) {
            return false; // error already reported
        }

        if (bin_expr->lhs->value.type == ExprType::Unknown ||
                bin_expr->rhs->value.type == ExprType::Unknown) {
            update_if_changed(bin_expr->value.type, ExprType::Unknown, changed);
        }
        else if (bin_expr->lhs->value.type == ExprType::Constant &&
                 bin_expr->rhs->value.type == ExprType::Constant) {
            int result = int_binary(bin_expr->op,
                                    bin_expr->lhs->value.const_value,
                                    bin_expr->rhs->value.const_value,
                                    bin_expr->loc, silent);
            update_if_changed(bin_expr->value.type, ExprType::Constant, changed);
            update_if_changed(bin_expr->value.const_value,
                              result, changed);
        }
        else if (bin_expr->lhs->value.type == ExprType::AddressRelative &&
                 bin_expr->rhs->value.type == ExprType::Constant &&
                 (bin_expr->op == TokenType::Plus || bin_expr->op == TokenType::Minus)) {
            int result = int_binary(bin_expr->op,
                                    static_cast<int>(bin_expr->lhs->value.offset),
                                    bin_expr->rhs->value.const_value,
                                    bin_expr->loc, silent);
            update_if_changed(bin_expr->value.type, ExprType::AddressRelative, changed);
            update_if_changed(bin_expr->value.section,
                              bin_expr->lhs->value.section, changed);
            update_if_changed(bin_expr->value.offset,
                              static_cast<uint>(result), changed);
        }
        else if (bin_expr->lhs->value.type == ExprType::Constant &&
                 bin_expr->rhs->value.type == ExprType::AddressRelative &&
                 bin_expr->op == TokenType::Plus) {
            int result = int_binary(bin_expr->op,
                                    bin_expr->lhs->value.const_value,
                                    static_cast<int>(bin_expr->rhs->value.offset),
                                    bin_expr->loc, silent);
            update_if_changed(bin_expr->value.type, ExprType::AddressRelative, changed);
            update_if_changed(bin_expr->value.section,
                              bin_expr->rhs->value.section, changed);
            update_if_changed(bin_expr->value.offset,
                              static_cast<uint>(result), changed);
        }
        else if (bin_expr->lhs->value.type == ExprType::AddressRelative &&
                 bin_expr->rhs->value.type == ExprType::AddressRelative &&
                 bin_expr->op == TokenType::Minus &&
                 bin_expr->lhs->value.section == bin_expr->rhs->value.section) {
            int result = int_binary(bin_expr->op,
                                    static_cast<int>(bin_expr->lhs->value.offset),
                                    static_cast<int>(bin_expr->rhs->value.offset),
                                    bin_expr->loc, silent);
            update_if_changed(bin_expr->value.type, ExprType::Constant, changed);
            update_if_changed(bin_expr->value.const_value,
                              result, changed);
        }
        else {
            update_if_changed(bin_expr->value.type, ExprType::Computed, changed);
        }

        return true;
    }

    if (auto tern_expr = dynamic_cast<ExprTernary*>(expr)) {
        if (!eval_expr(tern_expr->cond.get(), changed, silent)) {
            return false; // error already reported
        }
        if (!eval_expr(tern_expr->then_expr.get(), changed, silent)) {
            return false; // error already reported
        }
        if (!eval_expr(tern_expr->else_expr.get(), changed, silent)) {
            return false; // error already reported
        }

        if (tern_expr->cond->value.type == ExprType::Unknown ||
                tern_expr->then_expr->value.type == ExprType::Unknown ||
                tern_expr->else_expr->value.type == ExprType::Unknown) {
            update_if_changed(tern_expr->value.type, ExprType::Unknown, changed);
        }
        else if (tern_expr->cond->value.type == ExprType::Constant &&
                 tern_expr->then_expr->value.type == ExprType::Constant &&
                 tern_expr->else_expr->value.type == ExprType::Constant) {
            int result = int_ternary(tern_expr->cond->value.const_value,
                                     tern_expr->then_expr->value.const_value,
                                     tern_expr->else_expr->value.const_value,
                                     tern_expr->loc, silent);
            update_if_changed(tern_expr->value.type, ExprType::Constant, changed);
            update_if_changed(tern_expr->value.const_value,
                              result, changed);
        }
        else {
            update_if_changed(tern_expr->value.type, ExprType::Computed, changed);
        }

        return true;
    }

    if (auto call_expr = dynamic_cast<ExprCallUnary*>(expr)) {
        if (!eval_expr(call_expr->arg.get(), changed, silent)) {
            return false; // error already reported
        }

        if (call_expr->arg->value.type == ExprType::Unknown) {
            update_if_changed(call_expr->value.type, ExprType::Unknown, changed);
        }
        else if (call_expr->arg->value.type == ExprType::Constant) {
            int result = int_call_unary(call_expr->keyword,
                                        call_expr->arg->value.const_value,
                                        call_expr->loc, silent);
            update_if_changed(call_expr->value.type, ExprType::Constant, changed);
            update_if_changed(call_expr->value.const_value,
                              result, changed);
        }
        else {
            update_if_changed(call_expr->value.type, ExprType::Computed, changed);
        }

        return true;
    }

    assert(0);
    return false;
}

static bool eval_const_expr(Expr* expr, bool& changed, bool silent) {
    if (!eval_expr(expr, changed, silent)) {
        return false; // error already reported
    }

    switch (expr->value.type) {
    case ExprType::Constant:
        return true;

    case ExprType::Unknown:
    case ExprType::AddressRelative:
    case ExprType::Computed:
        g_diag.error(expr->loc,
                     "Constant expression expected");
        return false;

    default:
        assert(0);
        return false;
    }
}

bool verify_expr_ranges(Program& prog) {
    (void)prog;  // unused for now
    return true;
}
