//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "parse.h"
#include "scan.h"
#include "z80asm_defs.h"
#include <cstdint>
#include <list>
#include <string>
#include <unordered_map>
using namespace std;

struct Section;
struct Instr;
struct Expr;

//-----------------------------------------------------------------------------

typedef uint8_t Byte;
typedef vector<Byte> Bytes;

//-----------------------------------------------------------------------------

struct ExprResult {
	int 	value{ 0 };					// result of expression evaluation
	ErrCode err_code{ ErrOk };			// error message during expression evaluation
	string	err_arg;					// argument for error message

    ExprResult(int value_ = 0, ErrCode err_code_ = ErrOk, const string& err_arg_ = "");
};

//-----------------------------------------------------------------------------

struct Expr {
    string text;                        // expression text
    vector<Token> rpn_tokens;			// rpn of expression tokens
    Location location;                  // source code location

    bool parse_if_expr(Lexer* lexer_);  // parse expression of IF, does not create symbols
    bool parse_expr(Lexer* lexer_);     // parse normal expression, creates symbols
    bool can_parse(Lexer* lexer_);      // check if expression can be parsed without advancing lexer

	ExprResult get_value() const;       // compute expression, error if result.err_code != ErrOk

private:
    Lexer* lexer{ nullptr };            // lexer with expression to be parsed
    bool checking_parse{ false };       // if true, checking on

    const Token& token();               // current token
    TkCode token_code();                // code of current token
    void consume_token();               // consume the current token and add it to text
    bool parse_expr();
    void parse_ternary_condition();
    void parse_logical_or();
    void parse_logical_and();
    void parse_binary_or();
    void parse_binary_and();
    void parse_condition();
    void parse_shift();
    void parse_addition();
    void parse_multiplication();
    void parse_power();
    void parse_unary();
    void parse_primary();
};

//-----------------------------------------------------------------------------

struct Symbol {
    string      name;                   // name of symbol
    sym_scope_t scope{ SCOPE_NONE };    // scope of symbol
    sym_type_t  type{ TYPE_UNDEFINED }; // type of symbol
    int         value{ 0 };             // current value of symbol
    Section*    section{ nullptr };     // weak pointer to symbol's section
    Expr*       expr{ nullptr };        // holds expression if computed
    Instr*      instr{ nullptr };       // weak pointer to instruction if ASMPC
    bool        is_touched{ false };    // if true, gets written to object file
    bool        is_global_def{ false }; // is defined by -D
    Location    location;               // source location where defined
    int         recurse_count{ 0 };     // check for recursive expressions

    Symbol(const string& name_, sym_scope_t scope_, sym_type_t type_, Section* section_);
	ExprResult get_value();				// compute value

private:
    ExprResult get_value1();
};

//-----------------------------------------------------------------------------

struct Symtab {
    unordered_map<string, Symbol*> symbols; // holds symbols

    Symtab();
    virtual ~Symtab();
    Symtab(const Symtab& other) = delete;
    Symtab& operator=(const Symtab& other) = delete;
    auto begin() { return symbols.begin(); }
    auto end() { return symbols.end(); }

    void clear();                           // delete all symbols
    bool insert(Symbol* symbol);            // false if already exists
    Symbol* find(const string& name);       // nullptr if not found
    Symbol* erase(const string& name);      // nullptr if not found
};

//-----------------------------------------------------------------------------

struct Patch {
    range_t range{ RANGE_UNDEFINED };       // type of patch
    Expr* expr;                             // holds the expresion from source
};

//-----------------------------------------------------------------------------

struct Instr {
    int addr{ 0 };                          // address computed during linking
    Bytes bytes;                            // bytes of the instruction with placeholders for patches
    list<Patch*> patches;                   // patches for each variable expression
    Symbol* label{ nullptr };               // weak pointer to label if any
    Location location;                      // location in source

    Instr();
    virtual ~Instr();
    Instr(const Instr& other) = delete;
    Instr& operator=(const Instr& other) = delete;
    void clear();
    void set_bytes(int opcode);             // decompose 0xfd213412 in 4 bytes
};

//-----------------------------------------------------------------------------

struct Section {
    string name;                            // name of section, may be ""
    list<Instr*> instrs;                    // list of assembled instructions

    Section(const string& name_);
    virtual ~Section();
    Section(const Section& other) = delete;
    Section& operator=(const Section& other) = delete;
    void clear();
    auto begin() { return instrs.begin(); }
    auto end() { return instrs.end(); }
};

//-----------------------------------------------------------------------------

struct Module {
    string name;                            // name based on filename, or given by directive
    list<Section*> sections;                // list of sections in this module
    unordered_map<string, Section*> section_by_name;    // index sections by name
    Section* cur_section{ nullptr };
    Symtab local_symbols;                   // local symbols

    Module(const string& name_);
    virtual ~Module();
    Module(const Module& other) = delete;
    Module& operator=(const Module& other) = delete;
    void clear();
    auto begin() { return sections.begin(); }
    auto end() { return sections.end(); }
    void select_section(const string& name);
};

//-----------------------------------------------------------------------------

struct Object {
    string name;                            // name based on filename
    list<Module*> modules;                  // list of modules in this object
    unordered_map<string, Module*> module_by_name;  // index modules by name
    Module* cur_module{ nullptr };          // current module

    Object(const string& name_);
    virtual ~Object();
    Object(const Object& other) = delete;
    Object& operator=(const Object& other) = delete;
    void clear();
    auto begin() { return modules.begin(); }
    auto end() { return modules.end(); }
    void select_module(const string& name);
};

//-----------------------------------------------------------------------------

struct Assembler {
    list<Object*> objects;                  // list of objects assembled
    Object* cur_object{ nullptr };          // current object
    Symtab defines;                         // -D and predefined constants
    Symtab global_symbols;                  // global symbols
    Parser parser;                          // parser
    Symbol* asmpc{ nullptr };               // asmpc of current statement
    int start_errors{ 0 };                  // errors at start of assembly

    Assembler();
    virtual ~Assembler();
    Assembler(const Assembler& other) = delete;
    Assembler& operator=(const Assembler& other) = delete;
    void clear();
    auto begin() { return objects.begin(); }
    auto end() { return objects.end(); }
    void add_object(Object* object);

    // labels
    static string autolabel();
    Symbol* add_asmpc_instr();
    Symbol* add_label(const string& name);

    // instructions
    Instr* add_instr();
    Instr* add_instr(int opcode);

    // symbol table
    Symbol* find_symbol(const string& name);            // search local/global symbols and defines
    Symbol* add_symbol(const string& name);             // nullptr if duplicate
    Symbol* use_symbol(const string& name);             // return pointer to new or existing symbol
	Symbol* add_define(const string& name, int value);
	void erase_define(const string& name);
	
    // assemble source file, add to list of object modules
    bool assemble(const string& filename);              // assemble one source file

private:
    Module* cur_module();                               // nullptr if none
    Symbol* find_local_symbol(const string& name);      // nullptr if not found
    Symbol* find_global_symbol(const string& name);     // nullptr if not found
    Symbol* find_global_define(const string& name);     // nullptr if not found
    bool got_errors() const;                            // check if errors occured
    void assemble1(const string& filename);             // worker of assemble()
    void check_relative_jumps();                        // change JR to JP if needed
    void patch_local_exprs();                           // patch values of expressions
    void check_undefined_symbols();                     // check for undefined symbols
    void write_obj_file(const string& filename);        // write object file
};

extern Assembler g_asm;

