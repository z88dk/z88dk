//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
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
    size_t i_ = 0; // point int line tokens
    std::deque<Expression> exprs_;
};
