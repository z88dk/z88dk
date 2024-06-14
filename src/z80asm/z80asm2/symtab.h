//-----------------------------------------------------------------------------
// z80asm - symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
#include "location.h"
#include "utils.h"
#include "z80asm_defs.h"
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class Assembler;
class Section;
class Instr;

//-----------------------------------------------------------------------------

class Symbol : public HasLocation {
public:
    Symbol(const string& name, sym_scope_t scope, sym_type_t type, int value = 0);
    virtual ~Symbol();
    Symbol(const Symbol& other) = delete;
    Symbol& operator=(const Symbol& other) = delete;

    const string& name() const;
    sym_scope_t scope() const;
    sym_type_t type() const;
    Section* section() const;
    Expr* expr() const;
    Instr* instr() const;

    bool is_touched() const;
    bool is_global_def() const;
    bool is_alias() const;

    void set_scope(sym_scope_t scope);
    void set_type(sym_type_t type);
    void set_section(Section* section);
    void set_value(int value);
    void set_expr(Expr* expr);
    void set_instr(Instr* instr);
    void set_touched(bool f = true);
    void set_global_def(bool f = true);
    void set_alias(Symbol* other);
    
    ExprResult eval();				    // compute value

private:
    string      name_;                  // name of symbol
    sym_scope_t scope_{ SCOPE_NONE };   // scope of symbol
    sym_type_t  type_{ TYPE_UNDEFINED };// type of symbol
    int         value_{ 0 };            // current value of symbol
    Section*    section_{ nullptr };    // weak pointer to symbol's section
    Expr*       expr_{ nullptr };       // holds expression if computed
    Instr*      instr_{ nullptr };      // weak pointer to instruction if ASMPC
    bool        is_touched_{ false };   // if true, gets written to object file
    bool        is_global_def_{ false };// is defined by -D
    int         recurse_count_{ 0 };    // check for recursive expressions
    Symbol*     alias_{ nullptr };      // this symbol has an alias in other module

    ExprResult eval1();
};

//-----------------------------------------------------------------------------

class Symtab {
public:
    Symtab();
    virtual ~Symtab();
    Symtab(const Symtab& other) = delete;
    Symtab& operator=(const Symtab& other) = delete;

    auto begin() { return symbols_.begin(); }
    auto end() { return symbols_.end(); }

    void clear();                           // delete all symbols
    bool insert(Symbol* symbol);            // false if already exists
    Symbol* find(const string& name);       // nullptr if not found
    void remove(const string& name);        // remove from symbols_, save a zero value in deleted_
    void remove_globals();                  // replace GLOBAL either by EXTERN or PUBLIC
    void check_undefined_symbols();
    void get_public_names(StringTable& st);

private:
    vector<Symbol*> symbols_;               // holds symbols in order created
    vector<Symbol*> deleted_;               // holds deleted symbols that may still be
                                            // referenced by expressions
    unordered_map<string, Symbol*> map_;    // map for quick searches
};
