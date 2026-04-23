//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer_keywords.h"
#include "lexer.h"
#include "options.h"
#include "semantic_rewrite.h"
#include "string_interner.h"
#include "string_utils.h"
#include <string>
#include <vector>

void apply_identifier_ucase(std::vector<Token>& tokens) {
    if (!g_args.options.ucase_labels) {
        return;
    }

    for (Token& t : tokens) {
        if (t.type == TokenType::Identifier) {
            std::string s = g_strings.to_string(t.text_id);
            s = to_upper(s);
            t.text_id = g_strings.intern(s);
        }
    }
}

void apply_alt_registers(std::vector<Token>& tokens) {
    size_t i = 0;

    while (i + 1 < tokens.size()) {
        Token& t = tokens[i];
        Token& next = tokens[i + 1];

        // Only consider: <keyword> followed by Tick
        if (t.keyword != Keyword::None &&
                next.type == TokenType::Tick) {
            // Build candidate alternate name: e.g. "A" + "'" -> "A'"
            std::string base = g_strings.to_string(t.text_id);
            std::string alt = base + '\'';

            Keyword alt_kw = keyword_lookup(alt);

            if (alt_kw != Keyword::None) {
                // This register *does* have an alternate form
                t.text_id = g_strings.intern(alt);
                t.keyword = alt_kw;

                // Remove the Tick token
                tokens.erase(tokens.begin() + i + 1);

                // Do not advance i; continue scanning
                continue;
            }
        }

        ++i;
    }
}

void apply_dot_directive_merge(std::vector<Token>& tokens) {
    size_t i = 0;

    while (i + 1 < tokens.size()) {
        Token& dot = tokens[i];
        Token& next = tokens[i + 1];

        // Only .ASSUME is a dot-directive
        if (dot.type == TokenType::Dot &&
                next.keyword == Keyword::ASSUME) {
            // Merge into ".ASSUME"
            std::string merged = "." + g_strings.to_string(next.text_id);

            next.text_id = g_strings.intern(merged);
            next.keyword = Keyword::ASSUME; // already correct

            tokens.erase(tokens.begin() + i);
            continue;
        }

        ++i;
    }
}
