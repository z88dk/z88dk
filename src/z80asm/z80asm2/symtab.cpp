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
using namespace std;

Symbol::Symbol(const string& name, sym_scope_t scope, sym_type_t type, Section* section, int value)
    : name_(name), scope_(scope), type_(type), value_(value), section_(section) {
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

bool Symbol::is_touched() const {
    return is_touched_;
}

bool Symbol::is_global_def() const {
    return is_global_def_;
}

void Symbol::set_type(sym_type_t type) {
    type_ = type;
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
        return ExprResult(0, ErrExprRecursion);
    else {
        recurse_count_++;
        ExprResult result = eval1();
        recurse_count_--;
        return result;
    }
}

ExprResult Symbol::eval1() {
    if (type_ == TYPE_UNDEFINED)
        return ExprResult(0, ErrUndefinedSymbol, name_);
    else if (expr_)
        return expr_->eval();
    else if (instr_)
        return instr_->asmpc();
    else
        return value_;
}

//-----------------------------------------------------------------------------

Symtab::Symtab() {
}

Symtab::~Symtab() {
    clear();
}

void Symtab::clear() {
    for (auto& it : symbols_)
        delete it.second;
    symbols_.clear();
}

bool Symtab::insert(Symbol* symbol) {
    auto it = symbols_.find(symbol->name());
    if (it != symbols_.end()) {
        if (str_begins_with(symbol->name(), "__CDBINFO__"))
            return true;	// ignore duplicates of these
        else {
            g_asm.error(ErrDuplicateDefinition, symbol->name());
            return false;
        }
    }
    else {
        symbols_[symbol->name()] = symbol;
        return true;
    }
}

Symbol* Symtab::find(const string& name) {
    auto it = symbols_.find(name);
    if (it != symbols_.end())
        return it->second;
    else
        return nullptr;
}

Symbol* Symtab::erase(const string& name) {
    auto it = symbols_.find(name);
    if (it != symbols_.end()) {
        Symbol* symbol = it->second;
        symbols_.erase(it);
        return symbol;
    }
    else
        return nullptr;
}
