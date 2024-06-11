//-----------------------------------------------------------------------------
// z80asm - symbol table
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "expr.h"
#include "object.h"
#include "symtab.h"
#include "utils.h"
#include "xassert.h"
using namespace std;

Symbol::Symbol(const string& name, sym_scope_t scope, sym_type_t type, Section* section, int value)
    : name_(name), scope_(scope), type_(type), value_(value), section_(section) {
}

Symbol::~Symbol() {
    if (expr_)
        delete expr_;
}

const string& Symbol::name() const {
    return name_;
}

sym_scope_t Symbol::scope() const {
    return scope_;
}

sym_type_t Symbol::type() const {
    return type_;
}

Section* Symbol::section() const {
    return section_;
}

Expr* Symbol::expr() const {
    return expr_;
}

Instr* Symbol::instr() const {
    return instr_;
}

bool Symbol::is_touched() const {
    return is_touched_;
}

bool Symbol::is_global_def() const {
    return is_global_def_;
}

void Symbol::set_scope(sym_scope_t scope) {
    scope_ = scope;
}

void Symbol::set_type(sym_type_t type) {
    type_ = type;
}

void Symbol::set_section(Section* section) {
    section_ = section;
}

void Symbol::set_value(int value) {
    value_ = value;
}

void Symbol::set_expr(Expr* expr) {
    expr_ = expr;
}

void Symbol::set_instr(Instr* instr) {
    instr_ = instr;
}

void Symbol::set_touched(bool f) {
    is_touched_ = f;
}

void Symbol::set_global_def(bool f) {
    is_global_def_ = f;
}

ExprResult Symbol::eval() {
    if (recurse_count_ != 0)
        return ExprResult(TYPE_UNDEFINED, 0, ErrExprRecursion);
    else {
        recurse_count_++;
        ExprResult result = eval1();
        recurse_count_--;
        return result;
    }
}

ExprResult Symbol::eval1() {
    if (type_ == TYPE_UNDEFINED)
        return ExprResult(TYPE_UNDEFINED, 0, ErrUndefinedSymbol, name_);
    else if (expr_)
        return expr_->eval();
    else if (instr_)
        return ExprResult(TYPE_ADDRESS, instr_->asmpc());
    else
        return ExprResult(type_, value_);
}

//-----------------------------------------------------------------------------

Symtab::Symtab() {
}

Symtab::~Symtab() {
    clear();
}

void Symtab::clear() {
    for (auto& symbol : symbols_)
        delete symbol;
    symbols_.clear();

    for (auto& symbol : deleted_)
        delete symbol;
    deleted_.clear();

    map_.clear();
}

bool Symtab::insert(Symbol* symbol) {
    string name = symbol->name();
    auto it = map_.find(name);
    if (it != map_.end()) {
        if (str_begins_with(name, "__CDBINFO__"))
            return true;	// ignore duplicates of these
        else {
            g_errors.error(ErrDuplicateDefinition, name);
            g_errors.push_location(symbol->location());
            g_errors.error(ErrDuplicateDefinition, name);
            g_errors.pop_location();
            return false;
        }
    }
    else {
        symbols_.push_back(symbol);
        map_[name] = symbol;
        return true;
    }
}

Symbol* Symtab::find(const string& name) {
    auto it = map_.find(name);
    if (it != map_.end())
        return it->second;
    else
        return nullptr;
}

void Symtab::erase(const string& name) {
    auto it = map_.find(name);
    if (it == map_.end())
        return;

    Symbol* symbol = it->second;
    symbols_.erase(std::remove(symbols_.begin(), symbols_.end(), symbol), symbols_.end());
    map_.erase(it);

    // set to zero and remove any instr/expr
    symbol->set_value(0);
    if (symbol->expr()) {
        delete symbol->expr();
        symbol->set_expr(nullptr);
    }
    if (symbol->instr())
        symbol->set_instr(nullptr);

    // save in deleted, in case any expression referes to it
    deleted_.push_back(symbol);
}


void Symtab::check_undefined_symbols() {
    for (auto& symbol : symbols_) {
        if (symbol->type() == TYPE_UNDEFINED &&
            symbol->scope() != SCOPE_EXTERN) {
            g_errors.push_location(symbol->location());
            g_errors.error(ErrUndefinedSymbol, symbol->name());
            g_errors.pop_location();
        }
    }
}
