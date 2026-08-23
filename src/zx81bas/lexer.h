//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include "preproc.h"
#include <string>
#include <vector>

enum class TokenType {
    None,
#define X(str, tt) tt,
#include "tokens.def"
#undef X
};

std::string token_type_name(TokenType type);

enum class Keyword {
    None,
#define X(str, kw) kw,
#include "keywords.def"
#undef X
};

Keyword lookup_keyword(const std::string& text);
std::string keyword_name(Keyword keyword);

struct Token : TreeNode {
    TokenType type = TokenType::None;
    Keyword keyword = Keyword::None;
    std::string text;       // original token text
    std::string svalue;     // string contents as ASCII
    int ivalue = 0;
    double nvalue = 0.0;
    std::string ws_before;  // white space before token
    std::string filename;
    int line_num = 0;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

std::string to_string(const std::vector<Token>& tokens);

enum class SourceType { BASIC, ASM };

// BASIC or ASM line
struct TokLine : TreeNode {
    SourceType source_type = SourceType::BASIC;
    SrcLine src_line;           // input source line
    std::vector<Token> tokens;  // tokens for the line

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct TokFile : TreeNode {
    std::vector<TokLine> lines;    // all BASIC lines

    bool tokenize(const std::vector<SrcLine>& src_lines);

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};
