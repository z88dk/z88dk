//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../dump_context.h"
#include "../lexer.h"
#include <string>

void Token::dump(DumpContext ctx) const {
    ctx.line("Token {");
    auto child_ctx = ctx.child();
    child_ctx.line("type: " + token_type_name(type));
    child_ctx.line("keyword: " + keyword_name(keyword));
    child_ctx.line("text: \"" + text + "\"");
    child_ctx.line("svalue: \"" + svalue + "\"");
    child_ctx.line("ivalue: " + std::to_string(ivalue));
    child_ctx.line("nvalue: " + std::to_string(nvalue));
    child_ctx.line("ws_before: \"" + ws_before + "\"");
    child_ctx.line("filename: \"" + filename + "\"");
    child_ctx.line("line_num: " + std::to_string(line_num));
    ctx.line("}");
}

void TokLine::dump(DumpContext ctx) const {
    ctx.line("TokLine {");
    auto child_ctx = ctx.child();
    child_ctx.line("source_type: " + std::string(source_type == SourceType::BASIC ?
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

void TokFile::dump(DumpContext ctx) const {
    ctx.line("TokFile {");
    auto child_ctx = ctx.child();
    for (const auto& line : lines) {
        line.dump(child_ctx);
    }
    ctx.line("}");
}

#endif
