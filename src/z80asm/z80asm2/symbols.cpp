//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include "section.h"
#include "symbols.h"

//-----------------------------------------------------------------------------
// Symbol implementation
//-----------------------------------------------------------------------------

Symbol::Symbol(const std::string& name, const Location& location)
    : name_(name), location_(location) {
}

Symbol::Symbol(const std::string& name, const Location& location, int value,
               SymbolType type)
    : name_(name), value_(value), type_(type), location_(location) {
}

Symbol::Symbol(const std::string& name, const Location& location,
               Opcode* opcode, int offset, SymbolType type)
    : name_(name), type_(type), location_(location),
      opcode_(opcode), offset_(offset) {
}

const std::string& Symbol::name() const {
    return name_;
}

// set_name() removed - name is immutable (key in symbol table)

int Symbol::value() const {
    return value_;
}

void Symbol::set_value(int value) {
    value_ = value;
}

SymbolType Symbol::type() const {
    return type_;
}

void Symbol::set_type(SymbolType type) {
    type_ = type;
}

SymbolScope Symbol::scope() const {
    return scope_;
}

void Symbol::set_scope(SymbolScope scope) {
    scope_ = scope;
}

const Location& Symbol::location() const {
    return location_;
}

void Symbol::set_location(const Location& location) {
    location_ = location;
}

int Symbol::offset() const {
    return offset_;
}

void Symbol::set_offset(int offset) {
    offset_ = offset;
}

const Expression& Symbol::expression() const {
    return expression_;
}

void Symbol::set_expression(const Expression& expr) {
    expression_ = expr;
}

bool Symbol::has_expression() const {
    return !expression_.empty();
}

bool Symbol::is_undefined() const {
    return type_ == SymbolType::Undefined;
}

bool Symbol::is_constant() const {
    return type_ == SymbolType::Constant;
}

bool Symbol::is_address_relative() const {
    return type_ == SymbolType::AddressRelative;
}

bool Symbol::is_computed() const {
    return type_ == SymbolType::Computed;
}

bool Symbol::is_local() const {
    return scope_ == SymbolScope::Local;
}

bool Symbol::is_public() const {
    return scope_ == SymbolScope::Public ||
           (scope_ == SymbolScope::Global && is_defined());
}

bool Symbol::is_extern() const {
    return scope_ == SymbolScope::Extern ||
           (scope_ == SymbolScope::Global && !is_defined());
}

bool Symbol::is_global() const {
    return scope_ == SymbolScope::Global;
}

bool Symbol::is_exported() const {
    return is_public();
}

bool Symbol::is_imported() const {
    return is_extern();
}

bool Symbol::is_defined() const {
    return type_ != SymbolType::Undefined;
}

int Symbol::evaluate() const {
    // Check for recursive evaluation
    if (evaluating_) {
        throw RecursiveEvaluation(name_);
    }

    // Set evaluating flag
    evaluating_ = true;

    // Ensure flag is cleared on exit
    struct EvalGuard {
        bool& flag;
        EvalGuard(bool& f) : flag(f) {}
        ~EvalGuard() {
            flag = false;
        }
    } guard(evaluating_);

    // Handle each symbol type
    switch (type_) {
    case SymbolType::Undefined:
        throw UndefinedSymbol(name_);

    case SymbolType::Constant:
        return value_;

    case SymbolType::AddressRelative:
        if (!opcode_) {
            throw ExpressionError("Address-relative symbol without opcode: " + name_);
        }
        return opcode_->address() + offset_;

    case SymbolType::Computed:
        if (!has_expression()) {
            throw ExpressionError("Computed symbol without expression: " + name_);
        }
        return expression_.evaluate();

    default:
        throw ExpressionError("Unknown symbol type: " + name_);
    }
}

Opcode* Symbol::opcode() const {
    return opcode_;
}

void Symbol::set_opcode(Opcode* opcode) {
    opcode_ = opcode;
}

