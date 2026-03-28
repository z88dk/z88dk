//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_symbols.h"
#include "lexer.h"
#include "source_loc.h"
#include "string_interner.h"
#include <string>
#include <unordered_map>
#include <vector>

bool eval_const_expr(const std::string_view expr, const SourceLoc& loc,
                     const ConstSymbols& sym, int& result,
                     bool silent);

bool eval_const_expr(const std::vector<Token>& tokens, size_t& pos,
                     const ConstSymbols& sym, int& result,
                     bool silent);

// integer power function
int int_pow(int base, int exp, const SourceLoc& loc);
