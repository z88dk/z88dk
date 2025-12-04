//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "location.h"
#include "symbols.h"
#include <memory>
#include <vector>

class Module;
class Section;

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

// New: standalone Z80 flag test, e.g. Z, NZ, C, NC, PO, PE, P, M
struct FlagTest : Expr {
    Keyword cond; // one of Z, NZ, C, NC, PO, PE, P, M
};

class Parser {
public:
    Parser(const TokenLine& line, size_t i, Module* module, Section* section);
    std::unique_ptr<Expr> parse_bool_expr();

private:
    const std::vector<Token>& tokens_;
    size_t i_ = 0;
    Module* module_ = nullptr;
    Section* section_ = nullptr;

    const Token* peek(size_t look = 0) const;
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

