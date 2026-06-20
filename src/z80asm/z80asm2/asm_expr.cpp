//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_expr.h"
#include "diag.h"
#include "ir.h"
#include <cassert>
#include <string>
#include <string_view>

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
