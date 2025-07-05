//-----------------------------------------------------------------------------
// z80asm
// Symbol table
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <map>
using namespace std;

class Expr;
class Instr;
class Result;
class Section;
class Symtab;

enum class SymScope {
    //@@BEGIN: SymScope
    NONE = 0,
    LOCAL = 1,
    PUBLIC = 2,
    EXTERN = 3,
    GLOBAL = 4,
    //@@END
};

enum class SymType {
    //@@BEGIN: SymType
    UNDEFINED = 0,
    CONSTANT = 1,
    ADDRESS = 2,
    COMPUTED = 3,
    //@@END
};

class Symbol {
public:
    Symbol(const string& name);
    Symbol(const Symbol& other) = delete;
    virtual ~Symbol();
    Symbol& operator=(const Symbol& other) = delete;
    void clear();

    const string& name() const { return m_name; }
    const Location& location() const { return m_location; }
    const Section* section() const { return m_section; }
    SymScope sym_scope() const { return m_sym_scope; }
    SymType sym_type() const { return m_sym_type; }
    bool is_global_def() const { return m_is_global_def; } 
    int value() const;
    Instr* instr() { return m_instr; }
    const Expr& expr() const { return m_expr; }
    bool in_eval() const { return m_in_eval; }
    bool touched() const { return m_touched; }

    void set_sym_scope(SymScope sym_scope) { m_sym_scope = sym_scope; }
    void set_sym_type(SymType sym_type) { m_sym_type = sym_type; }
    void set_global_def(int value);
    void set_global_def(const Expr& expr);
    void set_constant(int value);
    void set_constant(const Expr& expr);
    void set_instr(Instr* instr);
    bool set_expr(const Expr& expr); // true if expression was resolved
    void set_in_eval(bool f = true) { m_in_eval = f; }
    void set_touched(bool f = true) { m_touched = f; }
    void update_definition();

private:
    const string m_name;        // symbol name
    Location m_location;        // location where defined
    Section* m_section{ nullptr };  // section where defined
    SymScope m_sym_scope{ SymScope::LOCAL };
    SymType m_sym_type{ SymType::UNDEFINED };
    bool m_is_global_def{ false }; // true if this is a global define
    int m_value{ 0 };           // constant
    Instr* m_instr{ nullptr };  // address
    Expr m_expr;                // expression
    bool m_in_eval{ false };    // detect recursive evaluation
    bool m_touched{ false };    // used by any expression
};

class Symtab {
public:
    Symtab() {}
    Symtab(const Symtab& other) = delete;
    virtual ~Symtab();
    Symtab& operator=(const Symtab& other) = delete;

    void clear();
    Symbol* get_symbol(const string& name); // nullptr if not found
    Symbol* add_symbol(const string& name);
    void remove_symbol(const string& name);

    Symbol* add_global_def(const string& name, int value = 1);
    Symbol* add_label(const string& name, Instr* instr);
    Symbol* add_equ(const string& name, const Expr& expr);
    Symbol* touch_symbol(const string& name, bool touched);
    Symbol* declare_extern(const string& name);
    Symbol* declare_public(const string& name);
    Symbol* declare_global(const string& name);

    void convert_global_to_extern_public();
    bool has_undefined_symbols() const;

    auto begin() { return m_table.begin(); }
    auto end() { return m_table.end(); }
    auto cbegin() const { return m_table.cbegin(); }
    auto cend() const { return m_table.cend(); }
    auto size() const { return m_table.size(); }
    bool empty() const { return m_table.empty(); }

private:
    map<string, Symbol*> m_table;
    vector<Symbol*> m_deleted;
};

extern Symtab* g_global_defines;
