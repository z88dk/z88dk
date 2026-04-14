//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include <string_view>
#include <vector>

void dump_token(const Token& token);
void dump_tokens(const std::vector<Token>& tokens,
                 StringInterner::Id& cur_file_id);
void dump_logical_line(const LogicalLine& line,
                       StringInterner::Id& cur_file_id);
void dump_logical_lines(const std::vector<LogicalLine>& lines,
                        StringInterner::Id& cur_file_id);

[[noreturn]]
void dump_after_tokenization_and_exit(std::string_view filename);

[[noreturn]]
void dump_after_hla_and_exit(const std::vector<LogicalLine>& lines);

