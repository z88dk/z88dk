//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "opcodes_trie_token.h"
#include <cassert>
#include <vector>

TrieToken get_trie_token(CPU cpu_id) {
    auto it = cpu_to_trie_token_lu.find(cpu_id);
    if (it == cpu_to_trie_token_lu.end()) {
        assert(0);
    }
    return it->second;
}

TrieToken get_trie_token(TokenType tt) {
    auto it = token_type_to_trie_token_lu.find(tt);
    if (it == token_type_to_trie_token_lu.end()) {
        assert(0);
    }
    return it->second;
}

TrieToken get_trie_token(Keyword kw) {
    auto it = keyword_to_trie_token_lu.find(kw);
    if (it == keyword_to_trie_token_lu.end()) {
        assert(0);
    }
    return it->second;
}

std::vector<LogicalLine> synthetic_expand(const std::vector<LogicalLine>& lines) {
    return lines;
}
