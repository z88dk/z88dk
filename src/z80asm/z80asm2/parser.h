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

    // byte lists
    void process_DEFB();
    void process_DB();
    void process_DEFM();
    void process_DM();
    void process_BYTE();

    // 2-byte lists
    void process_DEFW();
    void process_DW();
    void process_WORD();

    // 2-byte lists in big-endian order
    void process_DEFW_BE();
    void process_DW_BE();
    void process_DEFDB();
    void process_DDB();

    // 3-byte lists
    void process_DEFP();
    void process_DP();
    void process_PTR();

    // 4-byte lists
    void process_DEFQ();
    void process_DQ();
    void process_DWORD();

    // reserve space
    void process_DEFS();
    void process_DS();

    void process_define_list(int element_size, PatchRange range);
    void parse_expr_list();
    void expect_end();

    // tables of actions for directives
    using Action = void (Parser::*)();
    static const Action asm_directive_actions[];
};
