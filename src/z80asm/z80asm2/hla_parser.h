//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "location.h"
#include <memory>
#include <vector>

namespace hla {

enum class RelOp { Eq, Ne, Lt, Le, Gt, Ge };

struct Operand {
    enum class Kind { Reg8, MemHL, MemAbs, Imm8 } kind;
    int imm = 0;
    Keyword reg; // "A","B",...
    int addr = 0;
};

struct Expr {
    virtual ~Expr() = default;
};

struct Compare : Expr {
    Operand lhs;
    RelOp op;
    Operand rhs;
};

struct Not : Expr {
    std::unique_ptr<Expr> e;
};

struct And : Expr {
    std::unique_ptr<Expr> l, r;
};

struct Or  : Expr {
    std::unique_ptr<Expr> l, r;
};

class Parser {
public:
    Parser(const TokensLine& line, unsigned i = 0);
    std::unique_ptr<Expr> parse_bool_expr();

private:
    const std::vector<Token>& tokens_;
    unsigned i_ = 0;

    const Token* peek(unsigned look = 0) const;
    bool match(TokenType type);
    bool match_keyword(Keyword kw);
    void expect(TokenType type, const char* msg);

    std::unique_ptr<Expr> parse_or();
    std::unique_ptr<Expr> parse_and();
    std::unique_ptr<Expr> parse_not();
    Operand parse_operand();
    std::unique_ptr<Expr> parse_rel();

};

} // namespace hla

