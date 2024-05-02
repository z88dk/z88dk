//-----------------------------------------------------------------------------
// z80asm - expressions
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "location.h"
#include "errors.h"
#include "scan.h"
#include "z80asm_defs.h"
using namespace std;

//-----------------------------------------------------------------------------

class ExprResult {
public:
    ExprResult(int value = 0, ErrCode err_code = ErrOk, const string& err_arg = "");

    int value() const;
    bool ok() const;
    ErrCode err_code() const;
    void error();

private:
    int     value_{ 0 };				// result of expression evaluation
    ErrCode err_code_{ ErrOk };			// error message during expression evaluation
    string	err_arg_;					// argument for error message
};

//-----------------------------------------------------------------------------

class Expr : public HasLocation {
public:
    Expr(const string& expr_text = "0");

    const string& text() const;

    bool parse_expr(Lexer* lexer);      // parse normal expression, creates symbols
    bool parse_if_expr(Lexer* lexer);   // parse expression of IF, does not create symbols

    ExprResult eval() const;            // evaluate expression

    bool in_parens() const;             // true if expression surrounded by ()

private:
    string text_;                       // expression text
    vector<Token> rpn_tokens_;			// rpn of expression tokens
    Lexer* lexer_{ nullptr };           // lexer with expression to be parsed
    bool parsing_if_{ false };          // if true, parsing IF

    const Token& token();               // current token
    TkCode token_code();                // code of current token
    void consume_token();               // consume the current token and add it to text
    bool parse_expr1(Lexer* lexer);
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

class Patch {
public:
    Patch(range_t range, Expr* expr);
    virtual ~Patch();
    Patch(const Patch& other) = delete;
    Patch& operator=(const Patch& other) = delete;

    int size() const;

private:
    range_t range_{ RANGE_UNDEFINED };  // type of patch
    Expr*   expr_;                      // holds the expresion from source
};
