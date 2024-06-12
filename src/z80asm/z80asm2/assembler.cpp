//-----------------------------------------------------------------------------
// z80asm - assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "common.h"
#include "ofiles.h"
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
    delete_objects();
    asmpc_ = nullptr;
}

void Assembler::assemble(const string& asm_filename) {
    if (g_options.verbose())
        cout << "Assembling '" << asm_filename << "'" << endl;

    // create object and parser
    add_object(asm_filename);

    // clear globals
    copy_defines();

    // assemble
    g_errors.push_location(Location(asm_filename));
    assemble1();
    g_errors.pop_location();

    if (g_options.verbose())
        cout << endl;
}

void Assembler::load_object(const string& o_filename) {
    if (g_options.verbose())
        cout << "Appending object file '" << o_filename << "'" << endl;

    // create object
    add_object(o_filename);

    // load object
    g_errors.push_location(Location(o_filename));
    load_object1();
    g_errors.pop_location();

    if (g_options.verbose())
        cout << endl;
}

void Assembler::add_object(const string& filename) {
    objects_.push_back(new Object(filename));
}

Object& Assembler::cur_object() {
    xassert(!objects_.empty());
    return *objects_.back();
}

void Assembler::delete_objects() {
    for (auto& object : objects_) 
        delete object;
    objects_.clear();
}

void Assembler::copy_defines() {
    for (auto& it : g_options.defines()) {
        string name = it.first;
        int value = it.second;

        Symbol* symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, &g_section(), value);
        symbol->set_global_def();

        g_local_symbols().insert(symbol);
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
    Symbol* label = define_symbol(name, instr->asmpc());
    if (label) {
        label->set_type(TYPE_ADDRESS);
        label->set_instr(instr);
        label->set_touched();
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
    return g_local_symbols().find(name);
}

Symbol* Assembler::define_symbol(const string& name, int value) {
    Expr* expr = new Expr(std::to_string(value));
    return add_equ(name, expr);
}

void Assembler::undefine_symbol(const string& name) {
    g_local_symbols().remove(name);
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
        bool ok = g_local_symbols().insert(symbol);
        xassert(ok);
        return symbol;
    }
    else if (symbol->type() == TYPE_UNDEFINED &&
        symbol->scope() != SCOPE_EXTERN) { // already declared

        symbol->set_location(g_errors.location());
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
        g_errors.error(ErrDuplicateDefinition, name);
        g_errors.push_location(symbol->location());
        g_errors.error(ErrDuplicateDefinition, name);
        g_errors.pop_location();
        return nullptr;
    }
}

Symbol* Assembler::use_symbol(const string& name) {
    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_UNDEFINED, &g_section());
        bool ok = g_local_symbols().insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Symbol* Assembler::declare_extern(const string& name) {
    return make_global(name, SCOPE_EXTERN);
}

Symbol* Assembler::declare_public(const string& name) {
    return make_global(name, SCOPE_PUBLIC);
}

Symbol* Assembler::declare_global(const string& name) {
    return make_global(name, SCOPE_GLOBAL);
}

Symbol* Assembler::make_global(const string& name, sym_scope_t new_scope) {
    // check if symbol exists
    Symbol* symbol = g_local_symbols().find(name);
    if (!symbol) {
        symbol = new Symbol(name, new_scope, TYPE_UNDEFINED, &g_section());
        bool ok = g_local_symbols().insert(symbol);
        xassert(ok);
    }
    else {
        sym_scope_t cur_scope = symbol->scope();
        if (new_scope == SCOPE_EXTERN && symbol->type() != TYPE_UNDEFINED) {
            g_errors.error(ErrSymbolRedeclaration, name);
            g_errors.push_location(symbol->location());
            g_errors.error(ErrSymbolRedeclaration, name);
            g_errors.pop_location();
        }
        else if (cur_scope != SCOPE_LOCAL && cur_scope != new_scope) {
            g_errors.error(ErrSymbolRedeclaration, name);
            g_errors.push_location(symbol->location());
            g_errors.error(ErrSymbolRedeclaration, name);
            g_errors.pop_location();
        }
        else
            symbol->set_scope(new_scope);
    }
	return symbol;
}

void Assembler::assemble1() {
    int start_errors = g_errors.count();

    // create parent directory of object file
    string o_filename = file_o_filename(cur_object().filename());
    string parent_dir = file_parent_path(o_filename);
    if (!file_is_directory(parent_dir)) {
        if (!file_create_directories(parent_dir)) {
            g_errors.error(ErrDirCreate, parent_dir);
            perror(parent_dir.c_str());
            return;
        }
    }

    cur_object().parse();
    if (start_errors != g_errors.count())
        return;

    cur_object().check_relative_jumps();
    if (start_errors != g_errors.count())
        return;

    cur_object().patch_local_exprs();
    if (start_errors != g_errors.count())
        return;

    cur_object().check_undefined_symbols();
    if (start_errors != g_errors.count())
        return;

    cur_object().write_obj_file(o_filename);
    if (start_errors != g_errors.count())
        return;
}

void Assembler::load_object1() {
    string o_filename = cur_object().filename();

    OFileReader ofile(o_filename);
    ofile.read();
}
