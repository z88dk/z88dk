//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc.h"
#include "lexer_dump.h"
#include <algorithm>
#include <vector>

void Preproc::dump_logical_line(const LogicalLine& line,
                                StringInterner::Id& cur_file_id) {
    dump_tokens(line.tokens, cur_file_id);
}

void Preproc::dump_macro(const Macro& macro,
                         StringInterner::Id& cur_file_id) {
    if (macro.is_multiline) {
        std::vector<Token> header_tokens;
        header_tokens.push_back(Token::identifier("MACRO", macro.loc));
        header_tokens.push_back(Token::identifier(g_strings.view(macro.name_id),
                                macro.loc));

        for (const auto& param_id : macro.params) {
            header_tokens.push_back(Token::identifier(g_strings.view(param_id),
                                    macro.loc));
        }

        dump_tokens(header_tokens, cur_file_id);

        for (const auto& line : macro.lines) {
            dump_logical_line(line, cur_file_id);
        }

        std::vector<Token> endm_tokens;
        endm_tokens.push_back(Token::identifier("ENDM", macro.loc));
        dump_tokens(endm_tokens, cur_file_id);
    }
    else {
        std::vector<Token> define_tokens;
        define_tokens.push_back(Token::identifier("DEFINE", macro.loc));
        define_tokens.push_back(Token::identifier(g_strings.view(macro.name_id),
                                macro.loc));
        if (macro.is_function_like) {
            define_tokens.push_back(Token::token(
                                        TokenType::LeftParen, "(", macro.loc));
            for (size_t i = 0; i < macro.params.size(); i++) {
                if (i > 0) {
                    define_tokens.push_back(Token::token(
                                                TokenType::Comma, ",", macro.loc));
                }
                define_tokens.push_back(Token::identifier(
                                            g_strings.view(macro.params[i]), macro.loc));
            }
            define_tokens.push_back(Token::token(
                                        TokenType::RightParen, ")", macro.loc));
        }
        define_tokens.push_back(Token::token(
                                    TokenType::EQ, "=", macro.loc));
        define_tokens.insert(define_tokens.end(),
                             macro.tokens.begin(), macro.tokens.end());
        dump_tokens(define_tokens, cur_file_id);
    }
}

void Preproc::dump_macros() {
    // Collect pointers to all macros
    std::vector<const Macro*> sorted;
    sorted.reserve(macros.size());
    for (const auto& kv : macros) {
        sorted.push_back(&kv.second);
    }

    // Sort alphabetically by name
    std::sort(sorted.begin(), sorted.end(),
    [](const Macro * a, const Macro * b) {
        return g_strings.view(a->name_id) <
               g_strings.view(b->name_id);
    });

    // Dump each macro
    for (const Macro* m : sorted) {
        // force a visual separator between macros
        StringInterner::Id cur_file_id = 0;

        dump_macro(*m, cur_file_id);
    }
}

void Preproc::dump_symbols() {
    const_symbols.dump_symbols();
}
