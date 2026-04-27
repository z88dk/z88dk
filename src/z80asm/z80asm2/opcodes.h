//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "opcodes_trie_token.h"
#include <vector>

TrieToken get_trie_token(CPU cpu_id);
TrieToken get_trie_token(TokenType tt);
TrieToken get_trie_token(Keyword kw);

std::vector<LogicalLine> synthetic_expand(const std::vector<LogicalLine>& lines);
