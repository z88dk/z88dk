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
    void begin_group() {}
    void end_group() {}
    void error_expected_operand(const ParseLine& pline) const;
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
    void begin_group() {}
    void end_group() {}
    void error_expected_operand(const ParseLine&) const {}
    void error_missing_rparen(const ParseLine&) const {}
    void error_missing_rbracket(const ParseLine&) const {}
    void error_missing_colon(const ParseLine&) const {}
};

//-----------------------------------------------------------------------------
// Semantic context for AST builder expression parsing
//-----------------------------------------------------------------------------

struct ASTSem;

//-----------------------------------------------------------------------------
// Pluggable expression parsing
//-----------------------------------------------------------------------------

template <typename Sem>
bool parse_expr_conditional(ParseLine& pline, Sem& sem);

template <typename Sem>
bool parse_expr_primary(ParseLine& pline, Sem& sem) {
    const Token& tok = pline.peek();
    if (tok.type == TokenType::EndOfLine) {
        sem.error_expected_operand(pline);
        return false;
    }

    switch (tok.type) {

    case TokenType::Integer:
        sem.literal_integer(tok);
        pline.advance();
        return true;

    case TokenType::Float:
        sem.literal_float(tok);
        pline.advance();
        return true;

    case TokenType::Identifier:
        if (sem.symbol(tok)) {
            pline.advance();
            return true;
        }
        return false;

    case TokenType::Dollar:
    case TokenType::ASMPC:
        if (sem.literal_asmpc(tok)) {
            pline.advance();
            return true;
        }
        return false;

    case TokenType::LeftParen:
        pline.advance();
        sem.begin_group();
        if (!parse_expr_conditional(pline, sem)) {
            return false;
        }
        if (pline.peek().type != TokenType::RightParen) {
            sem.error_missing_rparen(pline);
            return false;
        }
        pline.advance();
        sem.end_group();
        return true;

    case TokenType::LeftBracket:
        pline.advance();
        sem.begin_group();
        if (!parse_expr_conditional(pline, sem)) {
            return false;
        }
        if (pline.peek().type != TokenType::RightBracket) {
            sem.error_missing_rbracket(pline);
            return false;
        }
        pline.advance();
        sem.end_group();
        return true;

    default:
        sem.error_expected_operand(pline);
        return false;
    }
}

template <typename Sem>
bool parse_expr_unary(ParseLine& pline, Sem& sem) {
    const Token& tok = pline.peek();
    TokenType op = tok.type;
    if (op == TokenType::EndOfLine) {
        sem.error_expected_operand(pline);
        return false;
    }

    switch (op) {
    case TokenType::Plus:
    case TokenType::Minus:
    case TokenType::LogicalNot:
    case TokenType::BitwiseNot:
        pline.advance();
        if (parse_expr_unary(pline, sem)) {
            sem.unary(op, tok.loc);
            return true;
        }
        return false;   // error already output

    default:
        return parse_expr_primary(pline, sem);
    }
}

template <typename Sem>
bool parse_expr_power(ParseLine& pline, Sem& sem) {
    if (!parse_expr_unary(pline, sem)) {
        return false;
    }

    if (pline.peek().type == TokenType::Power) {
        pline.advance();
        Token expr_start_tok = pline.peek();
        if (!parse_expr_power(pline, sem)) {
            return false;
        }
        sem.binary(TokenType::Power, expr_start_tok.loc);
    }

    return true;
}

template <typename Sem>
bool parse_expr_multiplicative(ParseLine& pline, Sem& sem) {
    if (!parse_expr_power(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::Modulo: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_power(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;  // no more multiplicative operators
        }
    }
}

template <typename Sem>
bool parse_expr_additive(ParseLine& pline, Sem& sem) {
    if (!parse_expr_multiplicative(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::Plus:
        case TokenType::Minus: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_multiplicative(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;  // no more multiplicative operators
        }
    }
}

template <typename Sem>
bool parse_expr_shift(ParseLine& pline, Sem& sem) {
    if (!parse_expr_additive(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LeftShift:
        case TokenType::RightShift: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_additive(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;  // no more multiplicative operators
        }
    }
}

template <typename Sem>
bool parse_expr_relational(ParseLine& pline, Sem& sem) {
    if (!parse_expr_shift(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LT:
        case TokenType::LE:
        case TokenType::GT:
        case TokenType::GE: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_shift(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_equality(ParseLine& pline, Sem& sem) {
    if (!parse_expr_relational(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::EQ:
        case TokenType::NE: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_relational(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_bitwise_and(ParseLine& pline, Sem& sem) {
    if (!parse_expr_equality(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseAnd: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_equality(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_bitwise_xor(ParseLine& pline, Sem& sem) {
    if (!parse_expr_bitwise_and(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseXor: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_bitwise_and(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_bitwise_or(ParseLine& pline, Sem& sem) {
    if (!parse_expr_bitwise_xor(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseOr: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_bitwise_xor(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_logical_and(ParseLine& pline, Sem& sem) {
    if (!parse_expr_bitwise_or(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalAnd: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_bitwise_or(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_logical_xor(ParseLine& pline, Sem& sem) {
    if (!parse_expr_logical_and(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalXor: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_logical_and(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_logical_or(ParseLine& pline, Sem& sem) {
    if (!parse_expr_logical_xor(pline, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = pline.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalOr: {
            pline.advance();  // consume operator
            Token expr_start_tok = pline.peek();
            if (!parse_expr_logical_xor(pline, sem)) {
                return false;
            }
            sem.binary(op, expr_start_tok.loc);
            break;
        }
        default:
            return true;
        }
    }
}

template <typename Sem>
bool parse_expr_conditional(ParseLine& pline, Sem& sem) {
    // Parse the condition (logical-or level)
    if (!parse_expr_logical_or(pline, sem)) {
        return false;
    }

    // If no '?', this is just a logical-or expression
    if (pline.peek().type != TokenType::Question) {
        return true;
    }

    // Capture operator location BEFORE consuming
    Token op_tok = pline.peek();
    pline.advance(); // consume '?'

    // Parse true-branch (full expression, not conditional)
    if (!parse_expr_conditional(pline, sem)) {
        return false;
    }

    // Expect ':'
    if (pline.peek().type != TokenType::Colon) {
        sem.error_missing_colon(pline);
        return false;
    }
    pline.advance(); // consume ':'

    // Parse false-branch (conditional)
    if (!parse_expr_conditional(pline, sem)) {
        return false;
    }

    // Apply semantic action
    sem.ternary(op_tok.loc);
    return true;
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
