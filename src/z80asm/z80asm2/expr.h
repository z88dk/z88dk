//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_symbols.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <string>
#include <vector>
#include <string_view>
#include "lexer_keywords.h"

// integer power function
int int_pow(int base, int exp, const SourceLoc& loc);

//-----------------------------------------------------------------------------
// Semantic context for constant expression evaluation
//-----------------------------------------------------------------------------

struct ConstEvalSem {
    std::vector<int> stack;
    const ConstSymbols& sym;
    bool silent = false;
    bool undefined_is_zero = false;

    explicit ConstEvalSem(const ConstSymbols& s);
    int result() const;
    void literal_integer(const Token& tok);
    void literal_float(const Token& tok);
    bool literal_asmpc(const Token& tok);
    bool symbol(const Token& tok);
    void unary(TokenType op, const SourceLoc& loc);
    void binary(TokenType op, const SourceLoc& loc);
    void ternary(const SourceLoc& loc);
    void call_unary(Keyword, const SourceLoc&) {}
    void begin_group() {}
    void end_group() {}
    void error_expected_operand(const ParseLine& pline) const;
    void error_missing_lparen(const ParseLine& pline) const;
    void error_missing_rparen(const ParseLine& pline) const;
    void error_missing_rbracket(const ParseLine& pline) const;
    void error_missing_colon(const ParseLine& pline) const;

private:
    void push(int value);
    int pop();
};

//-----------------------------------------------------------------------------
// Semantic context for trie-recognizer expression spans
//-----------------------------------------------------------------------------

struct SpanSem {
    explicit SpanSem() {}
    int result() const;
    void literal_integer(const Token&) {}
    void literal_float(const Token&) {}
    bool literal_asmpc(const Token&);
    bool symbol(const Token&);
    void unary(TokenType, const SourceLoc&) {}
    void binary(TokenType, const SourceLoc&) {}
    void ternary(const SourceLoc&) {}
    void call_unary(Keyword, const SourceLoc&) {}
    void begin_group() {}
    void end_group() {}
    void error_expected_operand(const ParseLine&) const {}
    void error_missing_lparen(const ParseLine&) const {}
    void error_missing_rparen(const ParseLine&) const {}
    void error_missing_rbracket(const ParseLine&) const {}
    void error_missing_colon(const ParseLine&) const {}
};

//-----------------------------------------------------------------------------
// Semantic context for AST builder expression parsing
//-----------------------------------------------------------------------------

struct ASTSem;

//-----------------------------------------------------------------------------
// Pluggable expression parsing - Pratt parser
//-----------------------------------------------------------------------------

enum {
    BP_SENTINEL        = -1,
    BP_NONE            = 0,
    BP_LOGICAL_OR      = 10,
    BP_LOGICAL_XOR     = 20,
    BP_LOGICAL_AND     = 30,
    BP_BITWISE_OR      = 40,
    BP_BITWISE_XOR     = 50,
    BP_BITWISE_AND     = 60,
    BP_EQUALITY        = 70,
    BP_RELATIONAL      = 80,
    BP_SHIFT           = 90,
    BP_ADDITIVE        = 100,
    BP_MULTIPLICATIVE  = 110,
    BP_POWER           = 120,
    BP_UNARY           = 130,
    BP_PRIMARY         = 140,
};

struct OpInfo {
    int lbp;
    int rbp;
};

OpInfo infix_table(TokenType t, bool restricted);

template <typename Sem>
bool nud(ParseLine& pline, Sem& sem, bool restricted) {
    const Token& tok = pline.peek();

    if (tok.type == TokenType::EndOfLine) {
        sem.error_expected_operand(pline);
        return false;
    }

    // MEM(...) function - only in restricted mode
    if (restricted && tok.keyword == Keyword::MEM) {
        SourceLoc loc = tok.loc;
        pline.advance(); // consume MEM

        if (pline.peek().type != TokenType::LeftParen) {
            sem.error_missing_lparen(pline);
            return false;
        }
        pline.advance(); // consume '('

        if (!parse_expr_bp_dynamic(pline, sem, BP_NONE, restricted)) {
            return false;
        }

        if (pline.peek().type != TokenType::RightParen) {
            sem.error_missing_rparen(pline);
            return false;
        }
        pline.advance(); // consume ')'

        sem.call_unary(Keyword::MEM, loc);
        return true;
    }

    switch (tok.type) {

    case TokenType::Integer:
        pline.advance();
        sem.literal_integer(tok);
        return true;

    case TokenType::Float:
        pline.advance();
        sem.literal_float(tok);
        return true;

    case TokenType::Identifier:
        pline.advance();
        return sem.symbol(tok);

    case TokenType::Dollar:
    case TokenType::ASMPC:
        pline.advance();
        return sem.literal_asmpc(tok);

    // prefix unary
    case TokenType::Plus:
    case TokenType::Minus:
    case TokenType::LogicalNot:
    case TokenType::BitwiseNot:
        pline.advance();
        if (!parse_expr_bp_dynamic(pline, sem, BP_UNARY, restricted)) {
            return false;
        }
        sem.unary(tok.type, tok.loc);
        return true;

    case TokenType::LeftParen:
    case TokenType::LeftBracket: {
        pline.advance();
        TokenType close =
            (tok.type == TokenType::LeftParen)
            ? TokenType::RightParen
            : TokenType::RightBracket;

        sem.begin_group();

        if (!parse_expr_bp_dynamic(pline, sem, BP_NONE, restricted)) {
            return false;
        }

        if (pline.peek().type != close) {
            if (close == TokenType::RightParen) {
                sem.error_missing_rparen(pline);
            }
            else {
                sem.error_missing_rbracket(pline);
            }
            return false;
        }

        pline.advance();
        sem.end_group();
        return true;
    }

    default:
        sem.error_expected_operand(pline);
        return false;
    }
}

template <typename Sem>
bool led(ParseLine& pline, Sem& sem, Token op, bool restricted) {

    // ternary operator
    if (op.type == TokenType::Question) {

        // true branch
        if (!parse_expr_bp_dynamic(pline, sem, BP_NONE, restricted)) {
            return false;
        }

        if (pline.peek().type != TokenType::Colon) {
            sem.error_missing_colon(pline);
            return false;
        }

        pline.advance();

        // false branch
        if (!parse_expr_bp_dynamic(pline, sem, BP_NONE, restricted)) {
            return false;
        }

        sem.ternary(op.loc);
        return true;
    }

    // binary operators
    OpInfo info = infix_table(op.type, restricted);

    Token expr_start_tok = pline.peek();

    if (!parse_expr_bp_dynamic(pline, sem, info.rbp, restricted)) {
        return false;
    }

    sem.binary(op.type, expr_start_tok.loc);
    return true;
}

template <typename Sem>
bool parse_expr_bp_dynamic(ParseLine& pline, Sem& sem, int min_bp, bool restricted) {

    if (!nud(pline, sem, restricted)) {
        return false;
    }

    while (true) {
        Token op = pline.peek();
        OpInfo info = infix_table(op.type, restricted);

        if (info.lbp < min_bp) {
            break;
        }

        pline.advance();

        if (!led(pline, sem, op, restricted)) {
            return false;
        }
    }

    return true;
}

template <typename Sem>
bool parse_full_expr(ParseLine& pline, Sem& sem) {
    return parse_expr_bp_dynamic(pline, sem, BP_NONE, /*restricted=*/false);
}

template <typename Sem>
bool parse_restricted_expr(ParseLine& pline, Sem& sem) {
    return parse_expr_bp_dynamic(pline, sem, BP_NONE, /*restricted=*/true);
}

//-----------------------------------------------------------------------------
// Constant expression evaluation
//-----------------------------------------------------------------------------

// Evaluate a constant expression.
// Undefined identifiers cause the evaluation to fail.
bool eval_const_expr(std::string_view expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result,
                     bool silent);

bool eval_const_expr(ParseLine& pline,
                     const ConstSymbols& sym, int& result,
                     bool silent);

// Evaluate an IF condition expression.
// Undefined identifiers are silently treated as zero and the evaluation
// succeeds.
bool eval_if_condition(std::string_view expr, const SourceLoc& loc,
                       const ConstSymbols& sym, int& result,
                       bool silent);

bool eval_if_condition(ParseLine& pline,
                       const ConstSymbols& sym, int& result,
                       bool silent);

//-----------------------------------------------------------------------------
// Recognizer of expression spans
//-----------------------------------------------------------------------------

bool parse_expression_span(ParseLine& pline);
