//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "string_interner.h"
#include <string>
#include <unordered_map>
#include <vector>
#include "const_expr.h"

std::vector<Token> preprocess(std::string_view filename,
                              const ConstSymbols& initial_symbols);
