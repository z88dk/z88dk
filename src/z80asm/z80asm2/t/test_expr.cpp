//-----------------------------------------------------------------------------
// z80asm - expressions
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "expr.h"
#include "assembler.h"
#include "t/test.h"
#include <iostream>
#include <sstream>
using namespace std;

//-----------------------------------------------------------------------------

void test_empty_expr_result() {
    ExprResult res;
    ostringstream oss;
    g_errors.set_output(oss);

    IS(res.value(), 0);
    OK(res.ok());
    IS(res.err_code(), ErrOk);
    res.error();
    IS(oss.str(), "");

    g_errors.clear();
}

void test_ok_expr_result() {
    ExprResult res(TYPE_CONSTANT, 27);
    ostringstream oss;
    g_errors.set_output(oss);

    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 27);
    OK(res.ok());
    IS(res.err_code(), ErrOk);
    res.error();
    IS(oss.str(), "");

    g_errors.clear();
}

void test_error_expr_result() {
    ExprResult res(TYPE_UNDEFINED, 0, ErrIntRange, "256");
    ostringstream oss;
    g_errors.set_output(oss);

    IS(res.type(), TYPE_UNDEFINED);
    IS(res.value(), 0);
    NOK(res.ok());
    IS(res.err_code(), ErrIntRange);
    res.error();
    IS(oss.str(), "error: integer range: 256\n");

    g_errors.clear();
}

//-----------------------------------------------------------------------------

void test_empty_expr() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    ostringstream oss;
    g_errors.set_output(oss);
    Expr expr;

    IS(oss.str(), "");
    IS(expr.text(), "0");
    ExprResult res = expr.eval();
    IS(res.value(), 0);
    OK(res.ok());

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}
