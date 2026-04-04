//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include "source_loc.h"
#include <string>
#include <string_view>
#include <vector>

std::string tokens_to_string(const std::vector<Token>& tokens);

struct SourceFile;          // forward declaration (no #include "file_mgr.h")
void tokenize(SourceFile& sf, std::string_view content);
std::vector<Token> tokenize_text(std::string_view text,
                                 const SourceLoc& loc);
