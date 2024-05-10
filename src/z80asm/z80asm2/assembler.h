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

    // command line options
    Options& options();

    // handle errors
    void push_location(const Location& location);
    void pop_location();
    const Location& location() const;
    void set_location(const Location& location);
    void clear_location();

    void set_source_line(const string& line);
    void set_expanded_line(const string& line);
    string source_line();
    string expanded_line();

    int error_count() const;
    int exit_code() const;

    void set_error_output(ostream& os);
    void error(ErrCode err_code, const string& argument = "");
    void error(ErrCode err_code, int argument);
    void warning(ErrCode err_code, const string& argument = "");
    void warning(ErrCode err_code, int argument);

    // labels
    static string autolabel();
    Symbol* add_asmpc_instr();
    Symbol* add_label(const string& name);
    Symbol* asmpc() const;

    // instructions
    Instr* add_instr();
    Instr* add_instr(int opcode);

    // symbol table
    Symbol* find_symbol(const string& name);            // search local/global symbols and defines
    Symbol* add_symbol(const string& name);             // nullptr if duplicate
    Symbol* use_symbol(const string& name);             // return pointer to new or existing symbol
    Symbol* add_define(const string& name, int value);
    void erase_define(const string& name);
    Symbol* declare_extern(const string& name);
    Symbol* declare_public(const string& name);
    Symbol* declare_global(const string& name);

private:
    Options options_;               // command line options
    Errors errors_;                 // handle errors
    vector<Location> locations_;    // location stack
    string filename_;               // source filename 
    Object* object_{ nullptr };     // object file being created
    Parser* parser_{ nullptr };     // parser of input
    Symtab defines_;                // -D and predefined constants
    Symtab global_symbols_;         // global symbols
    Symbol* asmpc_{ nullptr };      // asmpc of current statement
    int start_errors_{ 0 };         // errors at start of assembly

    Module* cur_module();           // nullptr if none
    Symbol* find_local_symbol(const string& name);      // nullptr if not found
    Symbol* find_global_symbol(const string& name);     // nullptr if not found
    Symbol* find_global_define(const string& name);     // nullptr if not found
    bool got_errors() const;        // check if errors occured
    void assemble1();               // worker of assemble()
    void check_relative_jumps();    // change JR to JP if needed
    void patch_local_exprs();       // patch values of expressions
    void check_undefined_symbols(); // check for undefined symbols
    void write_obj_file(const string& filename);    // write object file
};
