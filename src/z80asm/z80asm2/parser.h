//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
#include "section.h"
#include <deque>
#include <string>

class CompilationUnit;
class TokenLine;

class Parser {
public:
    Parser(CompilationUnit* unit);
    void clear();
    bool parse(const TokenLine& line);

private:
    CompilationUnit* unit_ = nullptr;
    const TokenLine* line_ = nullptr;
    size_t i_ = 0; // point into line tokens
    std::deque<Expression> exprs_;

    void process_directive(Keyword keyword);

    void process_DEFB();
    void process_DB();
    void process_DEFM();
    void process_DM();
    void process_BYTE();

    void process_DEFW();
    void process_DW();
    void process_WORD();

    void process_define_list(int element_size, PatchRange range);
    void parse_expr_list();
    void expect_end();

    // tables of actions for directives
    using Action = void (Parser::*)();
    static const Action asm_directive_actions[];
};
