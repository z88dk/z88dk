//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
#include "location.h"
#include <string>

//-----------------------------------------------------------------------------
// Forward declarations
//-----------------------------------------------------------------------------
class Expression;
class Opcode;

//-----------------------------------------------------------------------------
// Symbol types
//-----------------------------------------------------------------------------
enum class SymbolType {
    Undefined,          // Symbol not yet defined (e.g., EXTERN, resolved at link time)
    Constant,           // Constant value (EQU/DEFC)
    AddressRelative,    // Address in code plus offset (labels)
    Computed            // Expression computed at link time
};

//-----------------------------------------------------------------------------
// Symbol scope
//-----------------------------------------------------------------------------
enum class SymbolScope {
    Local,              // Local to module (default)
    Public,             // Exported from module (PUBLIC directive)
    Extern,             // Imported from another module (EXTERN directive)
    Global              // PUBLIC if defined, EXTERN if undefined (GLOBAL directive)
};

//-----------------------------------------------------------------------------
// Symbol - represents an assembly symbol
//-----------------------------------------------------------------------------
class Symbol {
public:
    // All constructors require name and location (name first as primary identifier)
    Symbol(const std::string& name, const Location& location);
    Symbol(const std::string& name, const Location& location, int value,
           SymbolType type = SymbolType::Constant);

    // Constructor for labels (address-relative symbols)
    Symbol(const std::string& name, const Location& location,
           Opcode* opcode, int offset,
           SymbolType type = SymbolType::AddressRelative);

    // Symbol identification (name is immutable - it's the key in symbol table)
    const std::string& name() const;

    // Symbol value
    int value() const;
    void set_value(int value);

    // Symbol type
    SymbolType type() const;
    void set_type(SymbolType type);

    // Symbol scope
    SymbolScope scope() const;
    void set_scope(SymbolScope scope);

    // Source location
    const Location& location() const;
    void set_location(const Location& location);

    // Opcode (for address-relative symbols - used to compute final address)
    Opcode* opcode() const;
    void set_opcode(Opcode* opcode);

    // Offset (for address-relative symbols)
    int offset() const;
    void set_offset(int offset);

    // Expression (for computed symbols)
    const Expression& expression() const;
    void set_expression(const Expression& expr);
    bool has_expression() const;

    // Type checks
    bool is_undefined() const;
    bool is_constant() const;
    bool is_address_relative() const;
    bool is_computed() const;

    // Scope checks
    bool is_local() const;
    bool is_public() const;
    bool is_extern() const;
    bool is_global() const;

    // Effective scope (accounts for Global + defined/undefined)
    bool is_exported() const;  // PUBLIC or (GLOBAL && defined)
    bool is_imported() const;  // EXTERN or (GLOBAL && undefined)

    // Definition check
    bool is_defined() const;

    // Evaluate symbol value
    // Throws UndefinedSymbol if symbol is undefined
    // Throws RecursiveEvaluation if evaluation is recursive
    // Throws ExpressionError on other evaluation failures
    int evaluate() const;

private:
    std::string name_;
    int value_ = 0;                     // Value for constants and computed results
    SymbolType type_ = SymbolType::Undefined;
    SymbolScope scope_ = SymbolScope::Local;
    Location location_;
    Opcode* opcode_ =
        nullptr;          // Opcode for address-relative symbols (to compute address)
    int offset_ = 0;                    // Offset for address-relative symbols
    Expression expression_;             // Expression for computed symbols
    mutable bool evaluating_ =
        false;   // Flag to detect recursive evaluation (mutable for const evaluate)
};

