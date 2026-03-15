//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "source_loc.h"
#include <string>
#include <unordered_map>
#include "lexer.h"

struct ConstSymbol {
    const char* name;
    int value;
    SourceLoc loc;
};

struct ConstSymbols {
    std::unordered_map<const char*, ConstSymbol> symbols;

    void clear();
    void set(const std::string& name, int value, const SourceLoc& loc);
    const ConstSymbol* get(const std::string& name) const;
};

bool eval_const_expr_silent(const std::string& expr, const SourceLoc& loc,
                            const ConstSymbols& sym, int& result);
bool eval_const_expr(const std::string& expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result);

bool eval_const_expr_silent(const std::vector<Token>& tokens, size_t& pos,
                            const ConstSymbols& sym, int& result);
bool eval_const_expr(const std::vector<Token>& tokens, size_t& pos,
                     const ConstSymbols& sym, int& result);
