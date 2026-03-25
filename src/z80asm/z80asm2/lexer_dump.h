//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string_view>

void dump_token(const Token& token);
void dump_tokens(const std::vector<Token>& tokens);

[[noreturn]] void dump_after_tokenization(const std::string_view filename);
