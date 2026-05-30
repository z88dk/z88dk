//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "lexer_tokens.h"
#include "parser.h"
#include "string_utils.h"
#include <memory>
#include <utility>
#include <vector>

std::unique_ptr<LabelStmt> parse_label(ParseLine& pline) {
    // .label
    if (pline.peek().type == TokenType::Dot && pline.peek(1).type == TokenType::Identifier) {
        auto label = std::make_unique<LabelStmt>(pline.peek(1).text_id, pline.peek().loc);
        pline.advance();
        pline.advance();
        return label;
    }

    // .label@local
    if (pline.peek().type == TokenType::Dot && pline.peek(1).type == TokenType::LocalLabel) {
        auto label = std::make_unique<LabelStmt>(pline.peek(1).text_id, pline.peek().loc);
        label->is_local = true;
        label->at_pos = pline.peek(1).value.label_at_pos;
        pline.advance();
        pline.advance();
        return label;
    }

    // label:
    if (pline.peek().type == TokenType::Identifier && pline.peek(1).type == TokenType::Colon) {
        auto label = std::make_unique<LabelStmt>(pline.peek().text_id, pline.peek().loc);
        pline.advance();
        pline.advance();
        return label;
    }

    // label@local:
    if (pline.peek().type == TokenType::LocalLabel && pline.peek(1).type == TokenType::Colon) {
        auto label = std::make_unique<LabelStmt>(pline.peek().text_id, pline.peek().loc);
        label->is_local = true;
        label->at_pos = pline.peek().value.label_at_pos;
        pline.advance();
        pline.advance();
        return label;
    }

    return nullptr;
}

static void parse_line(const std::vector<LogicalLine>& asm_lines, size_t& line,
                       std::unique_ptr<Program>& prog) {
    ParseLine pline(asm_lines[line].tokens);

    // check for label
    auto label = parse_label(pline);
    if (label) {
        prog->stmts.push_back(std::move(label));
    }

    // if not at end of line, error
    pline.check_end_of_line();
}

std::unique_ptr<Program> parse(const std::vector<LogicalLine>& asm_lines) {
    auto prog = std::make_unique<Program>();
    for (size_t line = 0; line < asm_lines.size(); line++) {
        parse_line(asm_lines, line, prog);
    }
    return prog;
}
