//-----------------------------------------------------------------------------
// z80asm - assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "common.h"
#include "object.h"
#include "parser.h"
#include "xassert.h"
#include <iomanip>
#include <iostream>
#include <sstream>
using namespace std;

Assembler::Assembler() {
}

Assembler::~Assembler() {
    clear();
}

void Assembler::clear() {
    options_.clear();
    errors_.clear();
    delete_object();
    asmpc_ = nullptr;
}

bool Assembler::assemble(const string& filename) {
    if (options_.verbose())
        cout << "Assembling '" << filename << "'" << endl;

    int start_errors = errors_.count();

    // create object and parser
    add_object(filename);

    // clear globals
    copy_defines();

    // assemble
    g_errors().push_location(Location(filename));
    assemble1();
    g_errors().pop_location();

    if (options_.verbose())
        cout << endl;

    delete_object();

    // exit true if no more errors
    return start_errors == errors_.count();
}

Options& Assembler::options() {
    return options_;
}

Errors& Assembler::errors() {
    return errors_;
}

void Assembler::add_object(const string& filename) {
    delete_object();
    object_ = new Object(filename);
}

Object& Assembler::object() {
    xassert(object_);
    return *object_;
}

void Assembler::delete_object() {
    if (object_) {
        delete object_;
        object_ = nullptr;
    }
}

void Assembler::copy_defines() {
    for (auto& it : options_.defines()) {
        string name = it.first;
        int value = it.second;

        Symbol* symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, &g_section(), value);
        symbol->set_global_def();

        g_symtab().insert(symbol);
    }
}

string Assembler::autolabel() {
    static int n = 0;
    ostringstream oss;
    oss << "z80asm$" << setw(5) << setfill('0') << n++;
    return oss.str();
}

Symbol* Assembler::add_asmpc_instr() {
    string asmpc_name = autolabel();
    asmpc_ = add_label(asmpc_name);
    return asmpc_;
}

Symbol* Assembler::add_label(const string& name) {
    Instr* instr = add_instr();
    Symbol* label = define_symbol(name);
    if (label) {
        label->set_type(TYPE_ADDRESS);
        instr->set_label(label);
        return label;
    }
    else
        return nullptr;
}

Symbol* Assembler::asmpc() const {
    xassert(asmpc_);
    return asmpc_;
}

Instr* Assembler::add_instr() {
    Instr* instr = g_section().add_instr();
    return instr;
}

Instr* Assembler::add_instr(int opcode) {
    Instr* instr = add_instr();
    instr->set_bytes(opcode);
    return instr;
}

Symbol* Assembler::find_symbol(const string& name) {
    return g_symtab().find(name);
}

Symbol* Assembler::define_symbol(const string& name, int value) {
    Expr* expr = new Expr(std::to_string(value));
    return add_equ(name, expr);
}

void Assembler::undefine_symbol(const string& name) {
    // check if already defined
    Symbol* symbol = g_symtab().erase(name);
    if (symbol) {
        // set to zero and remove any instr/expr
        symbol->set_value(0);
        if (symbol->expr()) {
            delete symbol->expr();
            symbol->set_expr(nullptr);
        }
        if (symbol->instr())
            symbol->set_instr(nullptr);

        // save in deleted, in case any expression referes to it
        g_symtab().push_deleted(symbol);
    }
}

Symbol* Assembler::add_equ(const string& name, Expr* expr) {
    ExprResult res = expr->eval();
    
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                              // new symbol
        symbol = new Symbol(name, SCOPE_LOCAL, res.type(), &g_section());
        if (res.type() == TYPE_CONSTANT) {
            symbol->set_value(res.value());
            delete expr;
        }
        else {
            symbol->set_expr(expr);
        }
        bool ok = g_symtab().insert(symbol);
        xassert(ok);
        return symbol;
    }
    else if (symbol->type() == TYPE_UNDEFINED) {// already declared
        if (symbol->scope() == SCOPE_EXTERN)
            symbol->set_scope(SCOPE_PUBLIC);

        symbol->set_location(errors_.location());
        symbol->set_section(&g_section());

        if (res.ok()) {
            symbol->set_type(TYPE_CONSTANT);
            symbol->set_value(res.value());
            delete expr;
        }
        else {
            symbol->set_type(TYPE_COMPUTED);
            symbol->set_expr(expr);
        }
        
        return symbol;
    }
    else {                                      // already defined
        delete expr;
        errors_.error(ErrDuplicateDefinition, name);
        return nullptr;
    }
}

Symbol* Assembler::use_symbol(const string& name) {
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_UNDEFINED, &g_section());
        bool ok = g_symtab().insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Symbol* Assembler::declare_extern(const string& name) {
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (symbol) {                               // already defined
        sym_scope_t scope = symbol->scope();
        if (scope != SCOPE_EXTERN)
            errors_.error(ErrSymbolRedeclaration, name);
    }
    else {                                      // new symbol
        symbol = new Symbol(name, SCOPE_EXTERN, TYPE_UNDEFINED, &g_section());
        bool ok = g_symtab().insert(symbol);
        xassert(ok);
    }
    return symbol;
}

Symbol* Assembler::declare_public(const string& name) {
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (symbol) {                               // already defined
        sym_scope_t scope = symbol->scope();
        if (scope == SCOPE_LOCAL)
            symbol->set_scope(SCOPE_PUBLIC);
        else if (scope != SCOPE_PUBLIC)
            errors_.error(ErrSymbolRedeclaration, name);
    }
    else {                                      // new symbol
        symbol = new Symbol(name, SCOPE_PUBLIC, TYPE_UNDEFINED, &g_section());
        bool ok = g_symtab().insert(symbol);
        xassert(ok);
    }
    return symbol;
}

Symbol* Assembler::declare_global(const string& name) {
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (symbol) {                               // already defined
        sym_scope_t scope = symbol->scope();
        if (scope == SCOPE_LOCAL)
            symbol->set_scope(SCOPE_GLOBAL);
        else if (scope != SCOPE_GLOBAL)
            errors_.error(ErrSymbolRedeclaration, name);
    }
    else {                                      // new symbol
        symbol = new Symbol(name, SCOPE_GLOBAL, TYPE_UNDEFINED, &g_section());
        bool ok = g_symtab().insert(symbol);
        xassert(ok);
    }
    return symbol;
}

void Assembler::assemble1() {
    int start_errors = errors_.count();

    // create parent directory of object file
    string o_filename = file_o_filename(object().filename());
    string parent_dir = file_parent_path(o_filename);
    if (!file_is_directory(parent_dir)) {
        if (!file_create_directories(parent_dir)) {
            errors_.error(ErrDirCreate, parent_dir);
            perror(parent_dir.c_str());
            return;
        }
    }

    object().parse();
    if (start_errors != errors_.count())
        return;

    object().check_relative_jumps();
    if (start_errors != errors_.count())
        return;

    object().patch_local_exprs();
    if (start_errors != errors_.count())
        return;

    object().check_undefined_symbols();
    if (start_errors != errors_.count())
        return;

    object().write_obj_file(o_filename);
    if (start_errors != errors_.count())
        return;
}
