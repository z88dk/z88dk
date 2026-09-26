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

#ifdef _DEBUG
void Token::dump(DumpContext ctx) const {
    ctx.line("Token {");
    auto child_ctx = ctx.child();
    child_ctx.line("type: " + token_type_name(type));
    if (keyword != Keyword::None) {
        child_ctx.line("keyword: " + keyword_name(keyword));
    }
    child_ctx.line("text: \"" + text + "\"");
    if (type == TokenType::StringLiteral || type == TokenType::CharConstant ||
            type == TokenType::LabelRefAddr || type == TokenType::LabelRefLine) {
        child_ctx.line("svalue: \"" + svalue + "\"");
    }
    if (type == TokenType::Integer) {
        child_ctx.line("ivalue: " + std::to_string(ivalue));
    }
    if (type == TokenType::Float) {
        child_ctx.line("nvalue: " + std::to_string(nvalue));
    }
    if (!ws_before.empty()) {
        child_ctx.line("ws_before: \"" + ws_before + "\"");
    }
    loc.dump(child_ctx);
    ctx.line("}");
}
#endif

std::string to_string(const std::vector<Token>& tokens) {
    std::string out;
    for (const auto& token : tokens) {
        out += token.ws_before + token.text;
    }
    return out;
}

#ifdef _DEBUG
void TokLine::dump(DumpContext ctx) const {
    ctx.line("TokLine {");
    auto child_ctx = ctx.child();
    child_ctx.line("source_type: " +
                   std::string(source_type == SourceType::BASIC ?
                               "BASIC" : "ASM"));
    child_ctx.line("src_line:");
    src_line.dump(child_ctx.child());
    child_ctx.line("tokens: [");
    auto tokens_ctx = child_ctx.child();
    for (const auto& token : tokens) {
        token.dump(tokens_ctx);
    }
    child_ctx.line("]");
    ctx.line("}");
}
#endif

bool TokFile::tokenize(const std::vector<SrcLine>& src_lines) {
    lines.clear();
    SourceType source_type = SourceType::BASIC;

    for (const auto& src_line : src_lines) {
        if (match_ASM(src_line.text, src_line.loc)) {
            source_type = SourceType::ASM;
            continue;
        }
        else if (match_BASIC(src_line.text, src_line.loc)) {
            source_type = SourceType::BASIC;
            continue;
        }

        TokLine tok_line;
        tok_line.source_type = source_type;
        tok_line.src_line = src_line;

        if (!tokenize_line(src_line.text, source_type,
                           src_line.loc,
                           tok_line.tokens)) {
            // error already reported
        }


        lines.push_back(std::move(tok_line));
    }

    return get_error_count() == 0;
}

#ifdef _DEBUG
void TokFile::dump(DumpContext ctx) const {
    ctx.line("TokFile {");
    auto child_ctx = ctx.child();
    for (const auto& line : lines) {
        line.dump(child_ctx);
    }
    ctx.line("}");
}
#endif
