//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include <string>
#include <vector>

bool tokenize_line(const std::string& text, SourceType source_type,
                   const std::string& filename, int line_num,
                   std::vector<Token>& tokens);
