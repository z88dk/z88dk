//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include "strings.h"
#include <string>
#include <unordered_map>

struct ConstSymbol {
    StringInterner::Id name_id;   // interned string
    int value;
    SourceLoc loc;
};

struct ConstSymbols {
    std::unordered_map<StringInterner::Id, ConstSymbol> symbols;

    void clear();

    void set(StringInterner::Id name_id, int value, const SourceLoc& loc);
    const ConstSymbol* get(StringInterner::Id name_id) const;
    void erase(StringInterner::Id name_id);

    void set(const std::string& name, int value, const SourceLoc& loc);
    const ConstSymbol* get(const std::string& name) const;
    void erase(const std::string& name);
};

bool eval_const_expr_silent(const std::string& expr, const SourceLoc& loc,
                            const ConstSymbols& sym, int& result);
bool eval_const_expr(const std::string& expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result);

bool eval_const_expr_silent(const std::vector<Token>& tokens, uint32_t& pos,
                            const ConstSymbols& sym, int& result);
bool eval_const_expr(const std::vector<Token>& tokens, uint32_t& pos,
                     const ConstSymbols& sym, int& result);

// integer power function
int int_pow(int base, int exp, const SourceLoc& loc);
