//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// HLA boolean expression parser
//-----------------------------------------------------------------------------

#include "expr.h"
#include "hla_parser.h"
#include <cassert>
#include <stdexcept>
#include <string>
#include <utility>

namespace hla {

//---------------------- helpers ----------------------

// Map token type to RelOp
static bool token_to_relop(TokenType tt, RelOp& out) {
    switch (tt) {
    case TokenType::EQ:
        out = RelOp::Eq;
        return true;
    case TokenType::NE:
        out = RelOp::Ne;
        return true;
    case TokenType::LT:
        out = RelOp::Lt;
        return true;
    case TokenType::LE:
        out = RelOp::Le;
        return true;
    case TokenType::GT:
        out = RelOp::Gt;
        return true;
    case TokenType::GE:
        out = RelOp::Ge;
        return true;
    default:
        return false;
    }
}

// Invert relational operator when swapping operands (NOT negation):
//   x <  y  =>  y >  x
//   x <= y  =>  y >= x
//   x >  y  =>  y <  x
//   x >= y  =>  y <= x
//   x == y  =>  y == x
//   x != y  =>  y != x
static RelOp invert_relop_on_swap(RelOp op) {
    switch (op) {
    case RelOp::Lt:
        return RelOp::Gt;
    case RelOp::Le:
        return RelOp::Ge;
    case RelOp::Gt:
        return RelOp::Lt;
    case RelOp::Ge:
        return RelOp::Le;
    case RelOp::Eq:
        return RelOp::Eq;
    case RelOp::Ne:
        return RelOp::Ne;
    default:
        return op;
    }
}

// Evaluate a constant expression from tokens[i .. boundary)
// boundary is where relational/logical tokens begin (or end-of-line).
// On success, sets out_value and out_after to the index after the consumed expression.
static bool eval_const_expr_range(const std::vector<Token>& tokens,
                                  size_t i, size_t boundary,
                                  Module* module, Section* section,
                                  int& out_value, size_t& out_after) {
    if (i >= boundary) {
        return false;
    }

    TokenLine expr_line; // location not needed for evaluation
    expr_line.tokens().reserve(boundary - i);
    for (size_t k = i; k < boundary; ++k) {
        expr_line.tokens().push_back(tokens[k]);
    }

    Expression expr;
    size_t j = 0;
    if (!expr.parse(expr_line, j, module, section)) {
        return false;
    }

    // Accept only if we consumed the whole candidate range
    if (j < expr_line.tokens().size()) {
        return false;
    }

    // Evaluate expression only if constant
    if (!expr.is_constant()) {
        return false;
    }

    // should not throw here since is_constant() is true
    try {
        out_value = expr.evaluate();
    }
    catch (...) {
        assert(0);
    }
    out_value = expr.evaluate();

    out_after = boundary;
    return true;
}

// Find the boundary for an immediate/address constant expression starting at i_.
// Counts parentheses depth and stops at:
//  - a relational/logical operator when depth == 0
//  - a ')' when depth == 0 (caller handles consumption of ')' if needed)
static size_t find_expr_boundary(const std::vector<Token>& tokens,
                                 size_t start) {
    size_t k = start;
    int depth = 0;
    while (k < tokens.size()) {
        const Token& t = tokens[k];

        if (t.is(TokenType::LeftParen)) {
            ++depth;
            ++k;
            continue;
        }

        if (t.is(TokenType::RightParen)) {
            if (depth == 0) {
                // boundary: closing paren that ends the outer context
                break;
            }
            --depth;
            ++k;
            continue;
        }

        if (depth == 0) {
            if (t.is(TokenType::EQ) || t.is(TokenType::NE) ||
                    t.is(TokenType::LT) || t.is(TokenType::LE) ||
                    t.is(TokenType::GT) || t.is(TokenType::GE) ||
                    t.is(TokenType::LogicalAnd) || t.is(TokenType::LogicalOr)) {
                // boundary: relational/logical at top-level
                break;
            }
        }

        ++k;
    }
    return k;
}

// Detect if a '(' at index 'open_idx' starts a parenthesized boolean expression
// (contains a relational or logical operator at top-level before matching ')')
static bool is_paren_boolean_expr(const std::vector<Token>& tokens,
                                  size_t open_idx) {
    if (open_idx >= tokens.size() || !tokens[open_idx].is(TokenType::LeftParen)) {
        return false;
    }

    int depth = 0;
    bool saw_bool_op = false;
    for (size_t k = open_idx + 1; k < tokens.size(); ++k) {
        const Token& t = tokens[k];
        if (t.is(TokenType::LeftParen)) {
            ++depth;
        }
        else if (t.is(TokenType::RightParen)) {
            if (depth == 0) {
                // Reached matching ')'
                return saw_bool_op;
            }
            --depth;
        }
        else if (depth == 0) {
            // Top-level inside these parentheses
            if (t.is(TokenType::EQ) || t.is(TokenType::NE) ||
                    t.is(TokenType::LT) || t.is(TokenType::LE) ||
                    t.is(TokenType::GT) || t.is(TokenType::GE) ||
                    t.is(TokenType::LogicalAnd) || t.is(TokenType::LogicalOr)) {
                saw_bool_op = true;
            }
        }
    }
    return false; // no matching ')' found -> treat as non-boolean (handled elsewhere)
}

//---------------------- Parser impl ------------------

Parser::Parser(const TokenLine& line, size_t i, Module* module, Section* section)
    : tokens_(line.tokens()), i_(i), module_(module), section_(section) {}

std::unique_ptr<Expr> Parser::parse_bool_expr() {
    auto e = parse_or();
    if (!e) {
        throw std::runtime_error("HLA boolean expression: invalid syntax");
    }
    if (i_ < tokens_.size())
        throw std::runtime_error("HLA boolean expression: extra token after expression '"
                                 + tokens_[i_].text() + "'");
    return e;
}

const Token* Parser::peek(size_t look) const {
    size_t idx = i_ + look;
    if (idx >= tokens_.size()) {
        return nullptr;
    }
    return &tokens_[idx];
}

bool Parser::match(TokenType type) {
    const Token* t = peek();
    if (t && t->type() == type) {
        ++i_;
        return true;
    }
    return false;
}

bool Parser::match_keyword(Keyword kw) {
    const Token* t = peek();
    if (t && t->type() == TokenType::Identifier && t->keyword() == kw) {
        ++i_;
        return true;
    }
    return false;
}

void Parser::expect(TokenType type, const char* msg) {
    if (!match(type)) {
        throw std::runtime_error(std::string("HLA parse error: expected ") + msg);
    }
}

//---------------------- Grammar pieces ----------------------

std::unique_ptr<Expr> Parser::parse_or() {
    auto left = parse_and();
    while (match(TokenType::LogicalOr)) {
        auto right = parse_and();
        if (!right) {
            throw std::runtime_error("Expected right operand after ||");
        }
        auto node = std::make_unique<Or>();
        node->l = std::move(left);
        node->r = std::move(right);
        left = std::move(node);
    }
    return left;
}

std::unique_ptr<Expr> Parser::parse_and() {
    auto left = parse_not();
    while (match(TokenType::LogicalAnd)) {
        auto right = parse_not();
        if (!right) {
            throw std::runtime_error("Expected right operand after &&");
        }
        auto node = std::make_unique<And>();
        node->l = std::move(left);
        node->r = std::move(right);
        left = std::move(node);
    }
    return left;
}

// Parse NOT or parenthesized boolean expression or comparison or flag test
std::unique_ptr<Expr> Parser::parse_not() {
    if (match(TokenType::LogicalNot)) {
        auto inner = parse_not();
        if (!inner) {
            throw std::runtime_error("Expected expression after '!'");
        }
        auto node = std::make_unique<Not>();
        node->e = std::move(inner);
        return node;
    }

    // Parenthesized boolean ( (bool-expr) )
    const Token* t = peek();
    if (t && t->type() == TokenType::LeftParen &&
            is_paren_boolean_expr(tokens_, i_)) {
        ++i_; // consume '('
        auto inner = parse_or();
        expect(TokenType::RightParen, "')' after parenthesized boolean expression");
        return inner;
    }

    // Standalone flag condition:
    // Ambiguity: 'C' may be register C (comparison like C == 3) OR carry flag test.
    // Resolve by treating it as a flag test ONLY if the next token is NOT a relational operator.
    if (const Token* tf = peek(); tf && tf->type() == TokenType::Identifier) {
        Keyword kw = tf->keyword();
        bool is_flag_kw = false;
        switch (kw) {
        case Keyword::Z:
        case Keyword::NZ:
        case Keyword::C:
        case Keyword::NC:
        case Keyword::PO:
        case Keyword::PE:
        case Keyword::P:
        case Keyword::M:
            is_flag_kw = true;
            break;
        default:
            break;
        }

        if (is_flag_kw) {
            const Token* next = peek(1);
            bool next_is_rel =
                next &&
                (next->is(TokenType::EQ) || next->is(TokenType::NE) ||
                 next->is(TokenType::LT) || next->is(TokenType::LE) ||
                 next->is(TokenType::GT) || next->is(TokenType::GE));

            // If a relational operator follows, we defer to parse_rel() so that
            // the identifier is interpreted as a register operand (e.g. C == 3).
            if (!next_is_rel) {
                auto f = std::make_unique<FlagTest>();
                f->cond = kw;
                ++i_;
                return f;
            }
        }
    }

    // Comparison
    return parse_rel();
}

Operand Parser::parse_operand() {
    const Token* t = peek();
    if (!t) {
        throw std::runtime_error("Unexpected end of expression");
    }

    // (HL) or (addr-expr)
    if (match(TokenType::LeftParen)) {
        const Token* inner = peek();
        if (!inner) {
            throw std::runtime_error("Expected token after '('");
        }

        // (HL)
        if (inner->type() == TokenType::Identifier && inner->keyword() == Keyword::HL) {
            ++i_;
            expect(TokenType::RightParen, "')' after (HL");
            Operand op;
            op.kind = Operand::Kind::MemHL;
            return op;
        }

        // constant address expression
        size_t start = i_;
        size_t k = find_expr_boundary(tokens_, start);
        if (k >= tokens_.size() || !tokens_[k].is(TokenType::RightParen)) {
            throw std::runtime_error("Missing ')' after memory operand");
        }

        int addr = 0;
        size_t after = start;
        if (!eval_const_expr_range(tokens_, start, k, module_, section_, addr, after)) {
            throw std::runtime_error("Invalid constant address expression inside ()");
        }
        if (after != k) {
            throw std::runtime_error("Unexpected token in address expression before ')'");
        }
        i_ = k;
        expect(TokenType::RightParen, "')' after (addr-expression");
        Operand op;
        op.kind = Operand::Kind::MemAbs;
        op.addr = addr;
        return op;
    }

    // 8-bit register
    if (t->type() == TokenType::Identifier
            && keyword_is_register_8bit(t->keyword())) {
        Operand op;
        op.kind = Operand::Kind::Reg8;
        op.reg = t->keyword();
        ++i_;
        return op;
    }

    // Immediate constant expression
    if (t->type() == TokenType::Integer ||
            t->type() == TokenType::Plus ||
            t->type() == TokenType::Minus ||
            t->type() == TokenType::LeftParen
            || // allow leading '(' for arithmetic sub-expr
            (t->type() == TokenType::Identifier
             && !keyword_is_register_8bit(t->keyword()))) {

        size_t boundary = find_expr_boundary(tokens_, i_);
        int value = 0;
        size_t after = i_;
        if (!eval_const_expr_range(tokens_, i_, boundary, module_, section_, value, after)) {
            throw std::runtime_error("Invalid constant expression for operand");
        }
        i_ = after;

        Operand op;
        op.kind = Operand::Kind::Imm8;
        op.imm = value;
        return op;
    }

    throw std::runtime_error("Invalid operand in comparison");
}

std::unique_ptr<Expr> Parser::parse_rel() {
    Operand lhs = parse_operand();

    const Token* op_tok = peek();
    if (!op_tok) {
        throw std::runtime_error("Missing relational operator");
    }
    RelOp rop;
    if (!token_to_relop(op_tok->type(), rop)) {
        throw std::runtime_error("Expected relational operator after left operand");
    }
    ++i_; // consume operator

    Operand rhs = parse_operand();

    if (rhs.kind == Operand::Kind::Reg8 && rhs.reg == Keyword::A &&
            !(lhs.kind == Operand::Kind::Reg8 && lhs.reg == Keyword::A)) {
        std::swap(lhs, rhs);
        rop = invert_relop_on_swap(rop);
    }

    auto cmp = std::make_unique<Compare>();
    cmp->lhs = lhs;
    cmp->op = rop;
    cmp->rhs = rhs;
    return cmp;
}

} // namespace hla
