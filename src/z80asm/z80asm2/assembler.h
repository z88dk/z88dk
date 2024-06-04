//-----------------------------------------------------------------------------
// z80asm - assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "location.h"
#include "object.h"
#include "options.h"
#include "symtab.h"
#include <iostream>
#include <string>
using namespace std;

class Parser;
class SourceReader;

class Assembler {
public:
    Assembler();
    virtual ~Assembler();
    Assembler(const Assembler& other) = delete;
    Assembler& operator=(const Assembler& other) = delete;
    void clear();

    // assemble source file
    bool assemble(const string& filename);              // assemble one source file

    // object file
    void add_object(const string& filename);
    Object& object();                                   // asserts object was added
    void delete_object();
    void copy_defines();            // copy defines to locals

    // labels
    static string autolabel();
    Symbol* add_asmpc_instr();
    Symbol* add_label(const string& name);
    Symbol* asmpc() const;

    // instructions
    Instr* add_instr();
    Instr* add_instr(int opcode);

    // symbol table
    Symbol* find_symbol(const string& name);            // search symbols
    Symbol* define_symbol(const string& name, int value = 0); // nullptr and error if duplicate
    void undefine_symbol(const string& name);           // undefine symbol
    Symbol* add_equ(const string& name, Expr* expr);
    Symbol* use_symbol(const string& name);             // return pointer to new or existing symbol
    Symbol* declare_extern(const string& name);
    Symbol* declare_public(const string& name);
    Symbol* declare_global(const string& name);

private:
    Object* object_;                // object file
    Symbol* asmpc_{ nullptr };      // asmpc of current statement

    void assemble1();               // worker of assemble()
    void check_relative_jumps();    // change JR to JP if needed
    void patch_local_exprs();       // patch values of expressions
    void check_undefined_symbols(); // check for undefined symbols
    void write_obj_file(const string& filename);    // write object file
};
