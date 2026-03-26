//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "lexer_dump.h"
#include "source.h"
#include "source_loc.h"
#include "string_utils.h"
#include <iostream>

// show debug-friendly representation of token
void dump_token(const Token& token) {
    static const std::string_view token_type_names[] = {
#define X(id, text) #id,
#include "lexer_tokens.def"
    };

    std::cout << token_type_names[static_cast<int>(token.type)] << "\t"
              << escape_string(g_strings.view(token.text_id)) << "\t"
              << token.loc.line << ":" << token.loc.column << "\t";

    if (token.keyword != Keyword::None) {
        std::cout << "keyword=" << keyword_to_string(token.keyword) << " ";
    }

    if (token.type == TokenType::Integer) {
        std::cout << "int_value=" << token.value.int_value << " ";
    }
    else if (token.type == TokenType::Float) {
        std::cout << "float_value=" << token.value.float_value << " ";
    }
    else if (token.type == TokenType::String) {
        std::cout << "str_value=" <<
                  escape_string(g_strings.view(token.value.str_value_id)) << " ";
    }

    std::cout << std::endl;
}

void dump_tokens(const std::vector<Token>& tokens) {
    StringInterner::Id cur_file_id = static_cast<StringInterner::Id>(-1);
    for (const Token& token : tokens) {
        if (token.loc.file_id != cur_file_id) {
            cur_file_id = token.loc.file_id;
            std::cout << "# file: " <<
                      g_strings.view(cur_file_id) << std::endl;
        }
        dump_token(token);
    }
}

[[noreturn]]
void dump_after_tokenization(const std::string_view filename) {
    // get_source_file will read and tokenize the file,
    // caching the tokens in SourceFile
    SourceFile* sf = get_source_file(filename, SourceLoc());
    if (!sf) {
        exit(EXIT_FAILURE);     // error already reported by get_source_file
    }

    // serialize tokens from all lines into a single vector for dumping
    std::vector<Token> tokens;
    for (auto& line_tokens : sf->lines_tokens) {
        tokens.insert(tokens.end(), line_tokens.begin(), line_tokens.end());
    }

    dump_tokens(tokens);
    exit(EXIT_SUCCESS);
}
