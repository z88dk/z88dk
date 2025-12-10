//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "location.h"
#include <memory>
#include <stdexcept>
#include <string>

//-----------------------------------------------------------------------------
// Forward declarations
//-----------------------------------------------------------------------------

class Section;
class Module;
class Symbol;
class Opcode;

//-----------------------------------------------------------------------------
// Expression evaluation exceptions
//-----------------------------------------------------------------------------

// Base class for expression evaluation errors
class ExpressionError : public std::runtime_error {
public:
    explicit ExpressionError(const std::string& msg) : std::runtime_error(msg) {}
};

// Undefined symbol error
class UndefinedSymbol : public ExpressionError {
public:
    explicit UndefinedSymbol(const std::string& symbol_name)
        : ExpressionError("Undefined symbol: " + symbol_name),
          symbol_name_(symbol_name) {
    }

    const std::string& symbol_name() const {
        return symbol_name_;
    }

private:
    std::string symbol_name_;
};

// Division by zero error
class DivisionByZero : public ExpressionError {
public:
    DivisionByZero() : ExpressionError("Division by zero") {}
};

// Current location ($) used without context
class InvalidDollar : public ExpressionError {
public:
    InvalidDollar() :
        ExpressionError("Current location ($) not available in this context") {
    }
};

// Recursive evaluation error
class RecursiveEvaluation : public ExpressionError {
public:
    explicit RecursiveEvaluation(const std::string& symbol_name)
        : ExpressionError("Recursive evaluation: " + symbol_name),
          symbol_name_(symbol_name) {
    }

    const std::string& symbol_name() const {
        return symbol_name_;
    }

private:
    std::string symbol_name_;
};

//-----------------------------------------------------------------------------
// Expression operators
// All C operators except pointers/assignment, plus ** (power) and ^^ (logical XOR)
//-----------------------------------------------------------------------------
enum class ExprOp {
    // Terminals
    Integer,            // Integer literal
    Symbol,             // Symbol reference
    Dollar,             // Current location counter ($)

    // Unary operators
    UnaryPlus,          // +x
    UnaryMinus,         // -x
    LogicalNot,         // !x
    BitwiseNot,         // ~x

    // Arithmetic binary operators (precedence: high to low)
    Power,              // x ** y (right-associative, extension)
    Multiply,           // x * y
    Divide,             // x / y
    Modulo,             // x % y
    Add,                // x + y
    Subtract,           // x - y

    // Shift operators
    LeftShift,          // x << y
    RightShift,         // x >> y

    // Relational operators
    LessThan,           // x < y
    LessOrEqual,        // x <= y
    GreaterThan,        // x > y
    GreaterOrEqual,     // x >= y

    // Equality operators
    Equal,              // x == y
    NotEqual,           // x != y

    // Bitwise operators
    BitwiseAnd,         // x & y
    BitwiseXor,         // x ^ y
    BitwiseOr,          // x | y

    // Logical operators
    LogicalAnd,         // x && y
    LogicalOr,          // x || y
    LogicalXor,         // x ^^ y (extension)

    // Ternary operator
    Conditional         // x ? y : z
};

//-----------------------------------------------------------------------------
// ExprNode - abstract base class for expression tree nodes
//-----------------------------------------------------------------------------
class ExprNode {
public:
    virtual ~ExprNode() = default;

    // Get the operator type
    virtual ExprOp op() const = 0;

    // Evaluate the expression
    // Throws ExpressionError-derived exceptions on failure
    virtual int evaluate() const = 0;

    // Check if expression is constant (can be evaluated at assembly time)
    // Returns true if all leaf nodes are integers or constant/computed symbols
    virtual bool is_constant() const = 0;

    // Clone the node
    virtual std::unique_ptr<ExprNode> clone() const = 0;

    // Convert to string for debugging
    virtual std::string to_string() const = 0;
};

//-----------------------------------------------------------------------------
// Expression - container for expression tree with source location
//-----------------------------------------------------------------------------
class Expression {
public:
    Expression() = default;
    Expression(std::unique_ptr<ExprNode> root, const Location& location);

    // Copy/move operations
    Expression(const Expression& other);
    Expression& operator=(const Expression& other);
    Expression(Expression&&) = default;
    Expression& operator=(Expression&&) = default;

    // Parse an expression from a token line
    // Module and Section must be provided for symbol and $ resolution
    // If successful:
    //   - Updates this expression with the parsed tree, location, and tokens
    //   - Updates i to point to the first token after the expression
    //   - Returns true
    // If failed (syntax error):
    //   - Leaves i unchanged
    //   - Returns false (caller is responsible for error reporting)
    bool parse(const TokenLine& line, size_t& i,
               Module* module, Section* section);

    // Evaluate the expression, returns the result
    // throws ExpressionError-derived exceptions on failure
    int evaluate() const;

    // Check if expression is constant (can be evaluated at assembly time)
    // Returns true if all leaf nodes are integers or constant/computed symbols
    bool is_constant() const;

    // Get the root node
    const ExprNode* root() const;

    // Set the root node
    void set_root(std::unique_ptr<ExprNode> root);

    // Get the source location (immutable - set only at construction or parsing)
    const Location& location() const;

    // Get the original tokens (for object file output)
    const TokenLine& token_line() const;

    // Set the original tokens
    void set_tokens(const TokenLine& token_line);

    // Check if expression is empty
    bool empty() const;

    // Clear the expression
    void clear();

    // Convert to string for debugging
    std::string to_string() const;

private:
    std::unique_ptr<ExprNode> root_;
    // Immutable after construction/parsing
    Location location_;
    // Original tokens for object file output
    std::unique_ptr<TokenLine> token_line_;
};

//-----------------------------------------------------------------------------
// Factory functions for creating expression nodes
//-----------------------------------------------------------------------------

// Create an integer literal node
std::unique_ptr<ExprNode> make_integer(int value);

// Create a symbol reference node (always resolved to Symbol* during parsing)
std::unique_ptr<ExprNode> make_symbol(Symbol* symbol);

// Create a dollar (current location) node (always resolved during parsing)
std::unique_ptr<ExprNode> make_dollar(Opcode* opcode, Section* section);

// Create a unary operator node
std::unique_ptr<ExprNode> make_unary_op(ExprOp op,
                                        std::unique_ptr<ExprNode> operand);

// Create a binary operator node
std::unique_ptr<ExprNode> make_binary_op(ExprOp op,
        std::unique_ptr<ExprNode> left,
        std::unique_ptr<ExprNode> right);

// Create a ternary conditional node
std::unique_ptr<ExprNode> make_conditional(std::unique_ptr<ExprNode> condition,
        std::unique_ptr<ExprNode> true_expr,
        std::unique_ptr<ExprNode> false_expr);

