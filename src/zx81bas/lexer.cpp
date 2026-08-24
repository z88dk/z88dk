//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include "options.h"
#include "preproc.h"
#include "scan.h"
#include "utils.h"
#include <cstdlib>
#include <iostream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

std::string token_type_name(TokenType type) {
    static std::unordered_map<TokenType, std::string> token_type_names = {
#define X(str, tt) { TokenType::tt, str },
#include "tokens.def"
#undef X
    };

    auto it = token_type_names.find(type);
    if (it == token_type_names.end()) {
        return "Unknown";
    }
    else {
        return it->second;
    }
}

Keyword lookup_keyword(const std::string& text) {
    static std::unordered_map<std::string, Keyword> keywords = {
#define X(str, kw)   { str, Keyword::kw },
#include "keywords.def"
#undef X
    };

    auto it = keywords.find(str_toupper(text));
    if (it == keywords.end()) {
        return Keyword::None;
    }
    else {
        return it->second;
    }
}

std::string keyword_name(Keyword keyword) {
    static std::unordered_map<Keyword, std::string> keyword_names = {
#define X(str, kw) { Keyword::kw, str },
#include "keywords.def"
#undef X
    };

    auto it = keyword_names.find(keyword);
    if (it == keyword_names.end()) {
        return "Unknown";
    }
    else {
        return it->second;
    }
}

std::string to_string(const std::vector<Token>& tokens) {
    std::string out;
    for (const auto& token : tokens) {
        out += token.ws_before + token.text;
    }
    return out;
}

bool TokFile::tokenize(const std::vector<SrcLine>& src_lines) {
    lines.clear();
    SourceType source_type = SourceType::BASIC;
    bool ok = true;

    for (const auto& src_line : src_lines) {
        if (match_ASM(src_line.text, src_line.filename, src_line.line_num)) {
            source_type = SourceType::ASM;
            continue;
        }
        else if (match_BASIC(src_line.text, src_line.filename, src_line.line_num)) {
            source_type = SourceType::BASIC;
            continue;
        }

        TokLine tok_line;
        tok_line.source_type = source_type;
        tok_line.src_line = src_line;

        if (!tokenize_line(src_line.text, source_type,
                           src_line.filename, src_line.line_num,
                           tok_line.tokens)) {
            ok = false; // error already reported
        }


        lines.push_back(std::move(tok_line));
    }

#ifdef _DEBUG
    if (g_dump_step == 4) {
        std::cout << "Tokenized input:" << std::endl;
        DumpContext ctx(std::cout);
        dump(ctx);
        exit(EXIT_SUCCESS);
    }
#endif

    return ok && get_error_count() == 0;
}
