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
// Expression parse context
//-----------------------------------------------------------------------------

struct ExprParseContext {
    const std::vector<Token>& tokens;
    size_t& pos;

    ExprParseContext(const std::vector<Token>& toks, size_t& p);
    const Token& peek() const;
    void advance();
    bool eof() const;
    std::string prev_token_text() const;
};

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
    void error_expected_operand(ExprParseContext& ctx) const;
    void error_missing_rparen(ExprParseContext& ctx) const;
    void error_missing_rbracket(ExprParseContext& ctx) const;
    void error_missing_colon(ExprParseContext& ctx) const;

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
    void error_expected_operand(ExprParseContext&) const {}
    void error_missing_rparen(ExprParseContext&) const {}
    void error_missing_rbracket(ExprParseContext&) const {}
    void error_missing_colon(ExprParseContext&) const {}
};

//-----------------------------------------------------------------------------
// Semantic context for AST builder expression parsing
//-----------------------------------------------------------------------------

struct ASTSem;

//-----------------------------------------------------------------------------
// Pluggable expression parsing
//-----------------------------------------------------------------------------

template <typename Sem>
bool parse_expr_conditional(ExprParseContext& ctx, Sem& sem);

template <typename Sem>
bool parse_expr_primary(ExprParseContext& ctx, Sem& sem) {
    const Token& tok = ctx.peek();
    if (tok.type == TokenType::EndOfLine) {
        sem.error_expected_operand(ctx);
        return false;
    }

    switch (tok.type) {

    case TokenType::Integer:
        sem.literal_integer(tok);
        ctx.advance();
        return true;

    case TokenType::Float:
        sem.literal_float(tok);
        ctx.advance();
        return true;

    case TokenType::Identifier:
        if (sem.symbol(tok)) {
            ctx.advance();
            return true;
        }
        return false;

    case TokenType::Dollar:
    case TokenType::ASMPC:
        if (sem.literal_asmpc(tok)) {
            ctx.advance();
            return true;
        }
        return false;

    case TokenType::LeftParen:
        ctx.advance();
        sem.begin_group();
        if (!parse_expr_conditional(ctx, sem)) {
            return false;
        }
        if (ctx.peek().type != TokenType::RightParen) {
            sem.error_missing_rparen(ctx);
            return false;
        }
        ctx.advance();
        sem.end_group();
        return true;

    case TokenType::LeftBracket:
        ctx.advance();
        sem.begin_group();
        if (!parse_expr_conditional(ctx, sem)) {
            return false;
        }
        if (ctx.peek().type != TokenType::RightBracket) {
            sem.error_missing_rbracket(ctx);
            return false;
        }
        ctx.advance();
        sem.end_group();
        return true;

    default:
        sem.error_expected_operand(ctx);
        return false;
    }
}

template <typename Sem>
bool parse_expr_unary(ExprParseContext& ctx, Sem& sem) {
    const Token& tok = ctx.peek();
    TokenType op = tok.type;
    if (op == TokenType::EndOfLine) {
        sem.error_expected_operand(ctx);
        return false;
    }

    switch (op) {
    case TokenType::Plus:
    case TokenType::Minus:
    case TokenType::LogicalNot:
    case TokenType::BitwiseNot:
        ctx.advance();
        if (parse_expr_unary(ctx, sem)) {
            sem.unary(op, tok.loc);
            return true;
        }
        return false;   // error already output

    default:
        return parse_expr_primary(ctx, sem);
    }
}

template <typename Sem>
bool parse_expr_power(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_unary(ctx, sem)) {
        return false;
    }

    if (ctx.peek().type == TokenType::Power) {
        ctx.advance();
        Token expr_start_tok = ctx.peek();
        if (!parse_expr_power(ctx, sem)) {
            return false;
        }
        sem.binary(TokenType::Power, expr_start_tok.loc);
    }

    return true;
}

template <typename Sem>
bool parse_expr_multiplicative(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_power(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::Modulo: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_power(ctx, sem)) {
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
bool parse_expr_additive(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_multiplicative(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::Plus:
        case TokenType::Minus: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_multiplicative(ctx, sem)) {
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
bool parse_expr_shift(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_additive(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LeftShift:
        case TokenType::RightShift: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_additive(ctx, sem)) {
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
bool parse_expr_relational(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_shift(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LT:
        case TokenType::LE:
        case TokenType::GT:
        case TokenType::GE: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_shift(ctx, sem)) {
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
bool parse_expr_equality(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_relational(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::EQ:
        case TokenType::NE: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_relational(ctx, sem)) {
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
bool parse_expr_bitwise_and(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_equality(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseAnd: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_equality(ctx, sem)) {
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
bool parse_expr_bitwise_xor(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_bitwise_and(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseXor: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_bitwise_and(ctx, sem)) {
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
bool parse_expr_bitwise_or(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_bitwise_xor(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::BitwiseOr: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_bitwise_xor(ctx, sem)) {
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
bool parse_expr_logical_and(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_bitwise_or(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalAnd: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_bitwise_or(ctx, sem)) {
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
bool parse_expr_logical_xor(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_logical_and(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalXor: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_logical_and(ctx, sem)) {
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
bool parse_expr_logical_or(ExprParseContext& ctx, Sem& sem) {
    if (!parse_expr_logical_xor(ctx, sem)) {
        return false;
    }

    while (true) {
        const Token& tok = ctx.peek();
        TokenType op = tok.type;
        switch (op) {
        case TokenType::LogicalOr: {
            ctx.advance();  // consume operator
            Token expr_start_tok = ctx.peek();
            if (!parse_expr_logical_xor(ctx, sem)) {
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
bool parse_expr_conditional(ExprParseContext& ctx, Sem& sem) {
    // Parse the condition (logical-or level)
    if (!parse_expr_logical_or(ctx, sem)) {
        return false;
    }

    // If no '?', this is just a logical-or expression
    if (ctx.peek().type != TokenType::Question) {
        return true;
    }

    // Capture operator location BEFORE consuming
    Token op_tok = ctx.peek();
    ctx.advance(); // consume '?'

    // Parse true-branch (full expression, not conditional)
    if (!parse_expr_conditional(ctx, sem)) {
        return false;
    }

    // Expect ':'
    if (ctx.peek().type != TokenType::Colon) {
        sem.error_missing_colon(ctx);
        return false;
    }
    ctx.advance(); // consume ':'

    // Parse false-branch (conditional)
    if (!parse_expr_conditional(ctx, sem)) {
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

bool eval_const_expr(const std::vector<Token>& tokens, size_t& pos,
                     const ConstSymbols& sym, int& result,
                     bool silent);

// Evaluate an IF condition expression.
// Undefined identifiers are silently treated as zero and the evaluation
// succeeds.
bool eval_if_condition(std::string_view expr, const SourceLoc& loc,
                       const ConstSymbols& sym, int& result,
                       bool silent);

bool eval_if_condition(const std::vector<Token>& tokens, size_t& pos,
                       const ConstSymbols& sym, int& result,
                       bool silent);

//-----------------------------------------------------------------------------
// Recognizer of expression spans
//-----------------------------------------------------------------------------

bool parse_expression_span(ParseLine& pline);
