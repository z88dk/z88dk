//-----------------------------------------------------------------------------
// z80asm - symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "symtab.h"
#include "t/test.h"
#include <iostream>
#include <sstream>
using namespace std;

//-----------------------------------------------------------------------------
// -DVAR
//-----------------------------------------------------------------------------

void test_symtab_define_symbol_command_line_1() {
    g_asm.clear();
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_LOCAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    OK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_line_10() {
    g_asm.clear();
    g_options.parse_option("-DVAR=10");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    OK(g_errors.count() == 0);

    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_LOCAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    OK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.value(), 10);

    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_line_duplicate_equal() {
    g_asm.clear();
    g_options.parse_option("-DVAR=10");
    g_options.parse_option("-DVAR=10");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_LOCAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    OK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.value(), 10);

    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_line_duplicate_different() {
    g_asm.clear();
    ostringstream oss;
    g_errors.set_output(oss);
    g_options.parse_option("-DVAR");
    g_options.parse_option("-DVAR=10");
    OK(g_errors.count());
    IS(oss.str(), "error: duplicate definition: VAR\n");

    g_errors.clear();
    g_options.clear();
    g_asm.clear();
}

void test_symtab_define_symbol_command_and_source_equ() {
    g_asm.clear();
    ostringstream oss;
    g_errors.set_output(oss);
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    Expr* expr = new Expr("1");
    g_asm.add_equ("VAR", expr);
    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: duplicate definition: VAR\n");

    g_errors.clear();
    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_and_source_label() {
    g_asm.clear();
    ostringstream oss;
    g_errors.set_output(oss);
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    g_asm.add_label("VAR");
    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: duplicate definition: VAR\n");

    g_errors.clear();
    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_and_source_public_use() {
    g_asm.clear();
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    g_asm.declare_public("VAR");
    OK(g_errors.count() == 0);

    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_PUBLIC);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    OK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_and_source_global_use() {
    g_asm.clear();
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    g_asm.declare_global("VAR");
    OK(g_errors.count() == 0);

    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_GLOBAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    OK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_symbol_command_and_source_extern_use() {
    g_asm.clear();
    ostringstream oss;
    g_errors.set_output(oss);
    g_options.parse_option("-DVAR");
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    g_asm.declare_extern("VAR");
    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: symbol redeclaration: VAR\n");

    g_errors.clear();
    g_options.clear();
    g_asm.delete_object();
    g_asm.clear();
}

//-----------------------------------------------------------------------------
// define VAR
//-----------------------------------------------------------------------------

void test_symtab_define_symbol() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));
    g_asm.define_symbol("VAR", 1);

    Symbol* symbol = g_asm.use_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_LOCAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    OK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_undefine() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);

    Symbol* symbol1 = g_asm.use_symbol("VAR");
    OK(symbol1);
    IS(symbol1->name(), "VAR");
    IS(symbol1->scope(), SCOPE_LOCAL);
    IS(symbol1->type(), TYPE_CONSTANT);
    IS(symbol1->section()->name(), "");
    OK(symbol1->is_touched());
    NOK(symbol1->is_global_def());

    ExprResult res1 = symbol1->eval();
    OK(res1.ok());
    IS(res1.type(), TYPE_CONSTANT);
    IS(res1.value(), 1);

    g_asm.undefine_symbol("VAR");

    Symbol* symbol2 = g_asm.use_symbol("VAR");
    OK(symbol2);
    IS(symbol2->name(), "VAR");
    IS(symbol2->scope(), SCOPE_LOCAL);
    IS(symbol2->type(), TYPE_UNDEFINED);
    IS(symbol2->section()->name(), "");
    OK(symbol2->is_touched());
    NOK(symbol2->is_global_def());

    ExprResult res2 = symbol2->eval();
    NOK(res2.ok());
    IS(res2.type(), TYPE_UNDEFINED);
    IS(res2.value(), 0);

    OK(symbol1);
    IS(symbol1->name(), "VAR");
    IS(symbol1->scope(), SCOPE_LOCAL);
    IS(symbol1->type(), TYPE_CONSTANT);
    IS(symbol1->section()->name(), "");
    OK(symbol1->is_touched());
    NOK(symbol1->is_global_def());

    res1 = symbol1->eval();
    OK(res1.ok());
    IS(res1.type(), TYPE_CONSTANT);
    IS(res1.value(), 0);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_undefine_define() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);

    Symbol* symbol1 = g_asm.find_symbol("VAR");
    OK(symbol1);
    IS(symbol1->name(), "VAR");
    IS(symbol1->scope(), SCOPE_LOCAL);
    IS(symbol1->type(), TYPE_CONSTANT);
    IS(symbol1->section()->name(), "");
    NOK(symbol1->is_touched());
    NOK(symbol1->is_global_def());

    ExprResult res1 = symbol1->eval();
    OK(res1.ok());
    IS(res1.type(), TYPE_CONSTANT);
    IS(res1.value(), 1);

    g_asm.undefine_symbol("VAR");

    Symbol* symbol2 = g_asm.find_symbol("VAR");
    NOK(symbol2);

    OK(symbol1);
    IS(symbol1->name(), "VAR");
    IS(symbol1->scope(), SCOPE_LOCAL);
    IS(symbol1->type(), TYPE_CONSTANT);
    IS(symbol1->section()->name(), "");
    NOK(symbol1->is_touched());
    NOK(symbol1->is_global_def());

    res1 = symbol1->eval();
    OK(res1.ok());
    IS(res1.type(), TYPE_CONSTANT);
    IS(res1.value(), 0);

    g_asm.define_symbol("VAR", 2);

    Symbol* symbol3 = g_asm.find_symbol("VAR");
    OK(symbol3);
    IS(symbol3->name(), "VAR");
    IS(symbol3->scope(), SCOPE_LOCAL);
    IS(symbol3->type(), TYPE_CONSTANT);
    IS(symbol3->section()->name(), "");
    NOK(symbol3->is_touched());
    NOK(symbol3->is_global_def());

    ExprResult res3 = symbol3->eval();
    OK(res3.ok());
    IS(res3.type(), TYPE_CONSTANT);
    IS(res3.value(), 2);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_equ() {
    ostringstream oss;
    g_asm.clear();
    g_errors.set_output(oss);
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    Expr* expr = new Expr("2");
    g_asm.add_equ("VAR", expr);

    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: duplicate definition: VAR\n");

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_label() {
    ostringstream oss;
    g_asm.clear();
    g_errors.set_output(oss);
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    g_asm.add_label("VAR");

    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: duplicate definition: VAR\n");

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_define() {
    ostringstream oss;
    g_asm.clear();
    g_errors.set_output(oss);
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    g_asm.define_symbol("VAR", 1);

    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: duplicate definition: VAR\n");

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_public() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    g_asm.declare_public("VAR");

    NOK(g_errors.count());

    Symbol* symbol = g_asm.find_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_PUBLIC);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    NOK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_public_and_define() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.declare_public("VAR");
    g_asm.define_symbol("VAR", 1);

    NOK(g_errors.count());

    Symbol* symbol = g_asm.find_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_PUBLIC);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    NOK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_global() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    g_asm.declare_global("VAR");

    NOK(g_errors.count());

    Symbol* symbol = g_asm.find_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_GLOBAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    NOK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_global_and_define() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.declare_global("VAR");
    g_asm.define_symbol("VAR", 1);

    NOK(g_errors.count());

    Symbol* symbol = g_asm.find_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_GLOBAL);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    NOK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_define_and_extern() {
    ostringstream oss;
    g_asm.clear();
    g_errors.set_output(oss);
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.define_symbol("VAR", 1);
    g_asm.declare_extern("VAR");

    OK(g_errors.count());
    IS(oss.str(), "test~.asm:21: error: symbol redeclaration: VAR\n");

    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

void test_symtab_extern_and_define() {
    ostringstream oss;
    g_asm.clear();
    g_errors.set_output(oss);
    g_asm.add_object("test~.asm");
    g_asm.copy_defines();
    g_errors.set_location(Location("test~.asm", 21));

    g_asm.declare_extern("VAR");
    g_asm.define_symbol("VAR", 1);  // no error, so that we can use an include file

    NOK(g_errors.count());

    Symbol* symbol = g_asm.find_symbol("VAR");
    OK(symbol);
    IS(symbol->name(), "VAR");
    IS(symbol->scope(), SCOPE_PUBLIC);
    IS(symbol->type(), TYPE_CONSTANT);
    IS(symbol->section()->name(), "");
    NOK(symbol->is_touched());
    NOK(symbol->is_global_def());

    ExprResult res = symbol->eval();
    OK(res.ok());
    IS(res.type(), TYPE_CONSTANT);
    IS(res.value(), 1);


    g_errors.clear();
    g_asm.delete_object();
    g_asm.clear();
}

