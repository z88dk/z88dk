//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_expr.h"
#include "diag.h"
#include "expr.h"
#include "ir.h"
#include "options.h"
#include "release_assert.h"
#include "string_utils.h"
#include <cstdint>
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
            release_assert(0);
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
        release_assert(asmpc_expr->stmt != nullptr);
        release_assert(asmpc_expr->stmt->section != nullptr);
        update_if_changed(asmpc_expr->value.type, ExprType::AddressRelative, changed);
        update_if_changed(asmpc_expr->value.section,
                          asmpc_expr->stmt->section, changed);
        update_if_changed(asmpc_expr->value.offset,
                          asmpc_expr->stmt->address, changed);
        return true;
    }

    if (auto sym_expr = dynamic_cast<ExprSymbol*>(expr)) {
        release_assert(sym_expr->symbol != nullptr);
        switch (sym_expr->symbol->def_type) {
        case SymbolInfo::DefType::Undefined: // extern
            update_if_changed(sym_expr->value.type, ExprType::Unknown, changed);
            break;

        case SymbolInfo::DefType::Label:
            release_assert(sym_expr->symbol->stmt != nullptr);
            update_if_changed(sym_expr->value.type, ExprType::AddressRelative, changed);
            update_if_changed(sym_expr->value.section,
                              sym_expr->symbol->stmt->section, changed);
            update_if_changed(sym_expr->value.offset,
                              sym_expr->symbol->stmt->address, changed);
            return true;

        case SymbolInfo::DefType::Defc:
            release_assert(sym_expr->symbol->defc_expr != nullptr);
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
                release_assert(0);
            }
            return true;

        default:
            release_assert(0);
        }

        return true;
    }

    if (auto llbl_expr = dynamic_cast<ExprLocalLabel*>(expr)) {
        release_assert(llbl_expr->symbol != nullptr);
        release_assert(llbl_expr->symbol->stmt != nullptr);
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

    release_assert(0);
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
        release_assert(0);
        return false;
    }
}

// Helper to check byte range (0-255) and issue warning if out of range
static void check_byte_range(int value, const SourceLoc& loc) {
    if (value < 0 || value > 255) {
        g_diag.warning(loc, "Integer range: " + int_to_hex(value));
    }
}

// Helper to check unsigned 8-bit range and issue warning if out of range
static void check_unsigned_8bit_range(int value, const SourceLoc& loc) {
    if (value < -128 || value > 255) {
        g_diag.warning(loc, "Integer range: " + int_to_hex(value));
    }
}

// Helper to check unsigned 16-bit range and issue warning if out of range
static void check_unsigned_16bit_range(int value, const SourceLoc& loc) {
    if (value < -32768 || value > 65535) {
        g_diag.warning(loc, "Integer range: " + int_to_hex(value));
    }
}

// Helper to check signed 8-bit range and issue warning if out of range
static void check_signed_8bit_range(int value, const SourceLoc& loc) {
    if (value < -128 || value > 127) {
        g_diag.warning(loc, "Integer range: " + int_to_hex(value));
    }
}

// Helper to check signed 16-bit range and issue warning if out of range
static void check_signed_16bit_range(int value, const SourceLoc& loc) {
    if (value < -32768 || value > 32767) {
        g_diag.warning(loc, "Integer range: " + int_to_hex(value));
    }
}

// Helper to check signed 8-bit range and issue error if out of range
static bool check_pcrel_8bit_range(int value, const SourceLoc& loc) {
    if (value < -128 || value > 127) {
        g_diag.error(loc, "Relative jump out of range: " + int_to_hex(value));
        return false;
    }
    return true;
}

// Helper to check signed 16-bit range and issue error if out of range
static bool check_pcrel_16bit_range(int value, const SourceLoc& loc) {
    if (value < -32768 || value > 32767) {
        g_diag.error(loc, "Relative jump out of range: " + int_to_hex(value));
        return false;
    }
    return true;
}

bool apply_patches(Program& prog) {
    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            for (auto& stmt : sec->stmts) {
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    for (auto& patch : opc_stmt->patches) {
                        if (patch->is_constant) {
                            // constant patch, expression must be constant
                            if (patch->inner->value.type != ExprType::Constant) {
                                g_diag.error(patch->loc,
                                             "Constant expression expected");
                                failed = true;
                            }
                            else {
                                if (!apply_patch(*stmt, opc_stmt->bytes, *patch)) {
                                    failed = true;
                                }
                            }
                        }
                        else if (patch->inner->value.type == ExprType::Constant) {
                            // constant expression
                            if (!apply_patch(*stmt, opc_stmt->bytes, *patch)) {
                                failed = true;
                            }
                        }
                        else if (patch->type == PatchType::PCrelative &&
                                 patch->inner->value.type == ExprType::AddressRelative &&
                                 opc_stmt->section == patch->inner->value.section) {
                            // short jump patch, expression must be address relative
                            if (!apply_patch(*stmt, opc_stmt->bytes, *patch)) {
                                failed = true;
                            }
                        }
                        else {
                            // non-constant expression must be handled by the linker
                        }
                    }
                    continue;
                }

                if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                    org_stmt->bytes.clear();
                    for (uint i = 0; i < org_stmt->padding_size; i++) {
                        org_stmt->bytes.push_back(g_args.options.filler_byte);
                    }
                    continue;
                }

                if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                    int filler_value = align_stmt->filler_expr->value.const_value;
                    check_byte_range(filler_value, align_stmt->filler_expr->loc);

                    align_stmt->bytes.clear();
                    for (uint i = 0; i < align_stmt->padding_size; i++) {
                        align_stmt->bytes.push_back(static_cast<uint8_t>(filler_value));
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                    int filler_value = defs_stmt->filler_expr->value.const_value;
                    check_byte_range(filler_value, defs_stmt->filler_expr->loc);

                    defs_stmt->bytes.clear();
                    for (uint i = 0; i < defs_stmt->padding_size; i++) {
                        defs_stmt->bytes.push_back(static_cast<uint8_t>(filler_value));
                    }
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                    defs_stmt->bytes.clear();
                    std::string str_value = g_strings.string(defs_stmt->string_id);
                    uint i;
                    for (i = 0; i < str_value.size() && i < defs_stmt->padding_size; i++) {
                        defs_stmt->bytes.push_back(static_cast<uint8_t>(str_value[i]));
                    }
                    for (; i < defs_stmt->padding_size; i++) {
                        defs_stmt->bytes.push_back(g_args.options.filler_byte);
                    }
                    continue;
                }
            }
        }
    }
    return !failed;
}

static bool check_range(int value, CheckRange validation) {
    switch (validation) {
    case CheckRange::Is_any:
        return true;
    case CheckRange::Is_0:
        if (value == 0) {
            return true;
        }
        break;
    case CheckRange::Is_0_1_2:
        if (value >= 0 && value <= 2) {
            return true;
        }
        break;
    case CheckRange::Is_0_1_2_3:
        if (value >= 0 && value <= 3) {
            return true;
        }
        break;
    case CheckRange::Is_0_1_2_3_4_5_6_7:
        if (value >= 0 && value <= 7) {
            return true;
        }
        break;
    case CheckRange::Is_1_2_3_4_5_6_7_0_8_10_18_20_28_30_38:
        if ((value >= 0 && value <= 8) || value == 0x10 || value == 0x18
                || value == 0x20 || value == 0x28 || value == 0x30 || value == 0x38) {
            return true;
        }
        break;
    case CheckRange::Is_2_3_4_5_7_10_18_20_28_38:
        if ((value >= 2 && value <= 5) || value == 7 || value == 0x10 || value == 0x18
                || value == 0x20 || value == 0x28 || value == 0x38) {
            return true;
        }
        break;
    case CheckRange::Is_1_2_4:
        if (value == 1 || value == 2 || value == 4) {
            return true;
        }
        break;
    case CheckRange::Is_1_2_4_8:
        if (value == 1 || value == 2 || value == 4 || value == 8) {
            return true;
        }
        break;
    case CheckRange::Is_40:
        if (value == 0x40) {
            return true;
        }
        break;
    case CheckRange::Is_8:
        if (value == 8) {
            return true;
        }
        break;
    default:
        release_assert(0);
        break;
    }
    return false;
}

static void apply_formula(std::vector<uint8_t>& bytes, int value,
                          ExprFormula formula, const std::vector<uint8_t>& coefs,
                          size_t offset, size_t size) {
    switch (formula) {
    case ExprFormula::None:
        // no patching needed
        break;

    case ExprFormula::ScaleBelowThreshold: {
        release_assert(size == 1);
        release_assert(offset < bytes.size());
        release_assert(coefs.size() == 1);

        // A+(%c<8?%c*8:%c), followed by A
        uint8_t A = coefs[0];
        bytes[offset] = static_cast<uint8_t>(A + (value < 8 ? value * 8 : value));
        break;
    }
    case ExprFormula::AddScaled: {
        release_assert(size == 1);
        release_assert(offset < bytes.size());
        release_assert(coefs.size() == 2);

        // A+B*%c, followed by A, B
        uint8_t A = coefs[0];
        uint8_t B = coefs[1];
        bytes[offset] = static_cast<uint8_t>(A + B * value);
        break;
    }
    case ExprFormula::SelectOrAdd: {
        release_assert(size == 1);
        release_assert(offset < bytes.size());
        release_assert(coefs.size() == 3);

        // %c==A?B:C+%c, followed by A, B, C
        uint8_t A = coefs[0];
        uint8_t B = coefs[1];
        uint8_t C = coefs[2];
        bytes[offset] = static_cast<uint8_t>(value == A ? B : C + value);
        break;
    }
    case ExprFormula::Select2: {
        release_assert(size == 1);
        release_assert(offset < bytes.size());
        release_assert(coefs.size() == 5);

        // %c==A?B:%c==C?D:E, followed by A, B, C, D, E
        uint8_t A = coefs[0];
        uint8_t B = coefs[1];
        uint8_t C = coefs[2];
        uint8_t D = coefs[3];
        uint8_t E = coefs[4];
        bytes[offset] = static_cast<uint8_t>(value == A ? B :
                                             value == C ? D : E);
        break;
    }
    case ExprFormula::Select3: {
        release_assert(size == 1);
        release_assert(offset < bytes.size());
        release_assert(coefs.size() == 7);

        // %c==A?B:%c==C?D:%c==E?F:G, followed by A, B, C, D, E, F, G
        uint8_t A = coefs[0];
        uint8_t B = coefs[1];
        uint8_t C = coefs[2];
        uint8_t D = coefs[3];
        uint8_t E = coefs[4];
        uint8_t F = coefs[5];
        uint8_t G = coefs[6];
        bytes[offset] = static_cast<uint8_t>(value == A ? B :
                                             value == C ? D :
                                             value == E ? F : G);
        break;
    }
    default:
        release_assert(0);
        break;
    }
}

bool apply_patch(Stmt& stmt, std::vector<uint8_t>& bytes, Patch& patch) {
    bool failed = false;

    // get value to be patched
    int value = 0;
    if (patch.inner->value.type == ExprType::Constant) {
        value = patch.inner->value.const_value;
    }
    else if (patch.inner->value.type == ExprType::AddressRelative &&
             patch.type == PatchType::PCrelative) {
        // calculate relative offset for short jump
        int target = static_cast<int>(patch.inner->value.offset);
        int source = static_cast<int>(stmt.address + bytes.size());
        value = target - source;
    }
    else {
        release_assert(0);
    }

    // check range
    if (!check_range(value, patch.validation)) {
        g_diag.error(patch.inner->loc,
                     "Patch value out of range: " + int_to_hex(value));
        return false;
    }

    // apply formula if needed
    apply_formula(bytes, value, patch.formula, patch.coefs, patch.offset,
                  patch.size);

    // apply patch
    switch (patch.type) {
    case PatchType::None:
        // already patched, no further action needed
        break;

    case PatchType::Unsigned:
        release_assert(patch.size >= 1 && patch.size <= 4);

        if (patch.size == 1) {
            check_unsigned_8bit_range(value, patch.inner->loc);
        }
        else if (patch.size == 2) {
            check_unsigned_16bit_range(value, patch.inner->loc);
        }

        for (size_t i = 0; i < patch.size; ++i) {
            release_assert(patch.offset + i < bytes.size());
            bytes[patch.offset + i] = static_cast<uint8_t>((value >> (8 * i)) & 0xFF);
        }
        break;

    case PatchType::Signed:
        release_assert(patch.size >= 1 && patch.size <= 4);

        if (patch.size == 1) {
            check_signed_8bit_range(value, patch.inner->loc);
        }
        else if (patch.size == 2) {
            check_signed_16bit_range(value, patch.inner->loc);
        }

        for (size_t i = 0; i < patch.size; ++i) {
            release_assert(patch.offset + i < bytes.size());
            bytes[patch.offset + i] =
                static_cast<uint8_t>((value >> (8 * i)) & 0xFF);
        }
        break;

    case PatchType::HighByte:
        release_assert(patch.size == 1);
        release_assert(patch.offset < bytes.size());

        if ((value & 0xff00) != 0) {
            if ((value & 0xff00) != 0xff00) {
                g_diag.warning(patch.inner->loc,
                               "Integer range: " + int_to_hex(value));
            }
        }

        bytes[patch.offset] = static_cast<uint8_t>(value & 0xFF);
        break;

    case PatchType::BigEndian:
        release_assert(patch.size >= 1 && patch.size <= 4);

        if (patch.size == 1) {
            check_unsigned_8bit_range(value, patch.inner->loc);
        }
        else if (patch.size == 2) {
            check_unsigned_16bit_range(value, patch.inner->loc);
        }

        for (size_t i = 0; i < patch.size; ++i) {
            release_assert(patch.offset + patch.size - 1 - i < bytes.size());
            bytes[patch.offset + patch.size - 1 - i] =
                static_cast<uint8_t>((value >> (8 * i)) & 0xFF);
        }
        break;

    case PatchType::PCrelative:
        release_assert(patch.size >= 1 && patch.size <= 2);

        if (patch.size == 1) {
            if (!check_pcrel_8bit_range(value, patch.inner->loc)) {
                failed = true;
            }
        }
        else if (patch.size == 2) {
            if (!check_pcrel_16bit_range(value, patch.inner->loc)) {
                failed = true;
            }
        }

        for (size_t i = 0; i < patch.size; ++i) {
            release_assert(patch.offset + i < bytes.size());
            bytes[patch.offset + i] =
                static_cast<uint8_t>((value >> (8 * i)) & 0xFF);
        }
        break;

    default:
        release_assert(0);
    }

    // mark as patched
    patch.type = PatchType::None;

    return !failed;
}
