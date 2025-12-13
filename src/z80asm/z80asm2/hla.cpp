//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "hla.h"
#include "hla_codegen.h"
#include "hla_parser.h"
#include "keywords.h"
#include "macros.h"
#include "preprocessor.h"

static Token kw_tok(Keyword k) {
    return Token(TokenType::Identifier, keyword_to_string(k), k, false);
}

HLA::HLA(Preprocessor* pp)
    : pp_(pp) {
}

void HLA::clear() {
    out_queue_.clear();
    block_stack_.clear();
}

bool HLA::next_line(TokenLine& out_line) {
    while (true) {
        // 1) If we have already produced lines, return them first.
        if (!out_queue_.empty()) {
            out_line = std::move(out_queue_.front());
            out_queue_.pop_front();
            return true;
        }

        // 2) Otherwise, read next cleaned line from the preprocessor.
        TokenLine line;
        if (!next_pp_line(line)) {
            // No more input. check for unclosed blocks.
            if (!block_stack_.empty()) {
                const hla::Block& top_blk = block_stack_.back();
                g_errors.error(top_blk.location, ErrorCode::InvalidSyntax, "Unclosed HLA block");
            }

            return false;
        }

        // 3) Check for HLA directives beginning with '%'.
        const auto& toks = line.tokens();
        if (toks.size() >= 2 &&
                toks[0].is(TokenType::Modulo) &&
                toks[1].is(TokenType::Identifier) &&
                keyword_is_hla_directive(toks[1].keyword())) {

            size_t i = 2;
            switch (toks[1].keyword()) {
            case Keyword::IF:
                process_IF(line, i);
                continue;
            case Keyword::ELIF:
            case Keyword::ELSEIF:
                process_ELIF(line, i);
                continue;
            case Keyword::ELSE:
                process_ELSE(line, i);
                continue;
            case Keyword::ENDIF:
                process_ENDIF(line, i);
                continue;
            case Keyword::WHILE:
                process_WHILE(line, i);
                continue;
            case Keyword::WEND:
            case Keyword::ENDW:
            case Keyword::ENDWHILE:
                process_WEND(line, i);
                continue;
            case Keyword::REPEAT:
                process_REPEAT(line, i);
                continue;
            case Keyword::UNTIL:
                process_UNTIL(line, i);
                continue;
            case Keyword::UNTILB:
                process_UNTILB(line, i);
                continue;
            case Keyword::UNTILBC:
                process_UNTILBC(line, i);
                continue;
            case Keyword::BREAK:
                process_BREAK(line, i);
                continue;
            case Keyword::CONTINUE:
                process_CONTINUE(line, i);
                continue;
            default:
                out_line = std::move(line);
                return true;
            }
        }

        // 4) Not a directive; pass the cleaned line through.
        out_line = std::move(line);
        return true;
    }
}

bool HLA::next_pp_line(TokenLine& out_line) {
    return pp_ && pp_->pp_next_line(out_line);
}

void HLA::process_IF(const TokenLine& line, size_t& i) {
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %IF");
        return;
    }

    // Generate labels for IF
    const size_t id = g_unique_id_counter++;
    const std::string else_label = "HLA_IF_" + std::to_string(id) + "_ELSE";
    const std::string end_label = "HLA_IF_" + std::to_string(id) + "_END";

    try {
        // Parse boolean expression after %IF
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr();

        // Emit branch-if-false to else_label
        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_bif(*expr, else_label, line.location(), out_queue_);
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %IF expression: ") + ex.what());
    }

    // Remember this IF to handle ELSE/ELIF/ENDIF later
    hla::Block blk;
    blk.kind = hla::Block::Kind::If;
    blk.location = line.location();
    blk.else_label = else_label;
    blk.end_label = end_label;
    blk.saw_else = false;
    block_stack_.push_back(std::move(blk));
}

void HLA::process_ELIF(const TokenLine& line, size_t& i) {
    // Validate context
    if (block_stack_.empty() || block_stack_.back().kind != hla::Block::Kind::If) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%ELIF without matching %IF");
        return;
    }
    hla::Block& blk = block_stack_.back();
    if (blk.saw_else) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%ELIF not allowed after %ELSE");
        return;
    }

    // %ELIF <expr>
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %ELIF");
        return;
    }

    try {
        // Close previous true-branch: jump to end, then place else-label
        {
            // Emit: JP end_label
            TokenLine jp(line.location());
            jp.tokens().push_back(kw_tok(Keyword::JP));
            jp.tokens().push_back(Token(TokenType::Identifier, blk.end_label, false));
            out_queue_.push_back(std::move(jp));

            // Place: .else_label
            hla::CodeGen cg(g_unique_id_counter);
            cg.emit_label(blk.else_label, line.location(), out_queue_);
        }

        // Parse boolean expression of this %ELIF
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr();

        // Create a new else label for the remainder of the chain
        const size_t id = g_unique_id_counter++;
        const std::string new_else_label = "HLA_IF_" + std::to_string(id) + "_ELSE";

        // Emit branch-if-false of this ELIF to its else label
        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_bif(*expr, new_else_label, line.location(), out_queue_);

        // Update block's else_label to the new one
        blk.else_label = new_else_label;
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %ELIF expression: ") + ex.what());
    }
}

void HLA::process_ELSE(const TokenLine& line, size_t& i) {
    // Validate context
    if (block_stack_.empty() || block_stack_.back().kind != hla::Block::Kind::If) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%ELSE without matching %IF");
        return;
    }
    hla::Block& blk = block_stack_.back();
    if (blk.saw_else) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Multiple %ELSE in the same %IF");
        return;
    }

    // %ELSE must not have an expression
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %ELSE");
        return;
    }

    // Close previous true-branch: jump to end, then place else-label
    {
        TokenLine jp(line.location());
        jp.tokens().push_back(kw_tok(Keyword::JP));
        jp.tokens().push_back(Token(TokenType::Identifier, blk.end_label, false));
        out_queue_.push_back(std::move(jp));

        // Place: .else_label
        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_label(blk.else_label, line.location(), out_queue_);
    }

    blk.saw_else = true;
}

void HLA::process_ENDIF(const TokenLine& line, size_t& i) {
    // Validate context
    if (block_stack_.empty() || block_stack_.back().kind != hla::Block::Kind::If) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%ENDIF without matching %IF");
        return;
    }
    // %ENDIF must not have extra tokens
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %ENDIF");
        return;
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // If no %ELSE was seen, we still need to place the current else_label
    hla::CodeGen cg(g_unique_id_counter);
    if (!blk.saw_else) {
        cg.emit_label(blk.else_label, line.location(), out_queue_);
    }

    // Always place the end label to terminate the IF chain
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}

void HLA::process_WHILE(const TokenLine& line, size_t& i) {
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %WHILE");
        return;
    }

    try {
        // Parse boolean expression after %WHILE
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr();

        // Labels for WHILE
        const size_t id = g_unique_id_counter++;
        const std::string top_label = "HLA_WHILE_" + std::to_string(id) + "_TOP";
        const std::string end_label = "HLA_WHILE_" + std::to_string(id) + "_END";

        // Place: .top_label
        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_label(top_label, line.location(), out_queue_);

        // Emit branch-if-false to end_label
        cg.emit_bif(*expr, end_label, line.location(), out_queue_);

        // Push While block
        hla::Block blk;
        blk.kind = hla::Block::Kind::While;
        blk.location = line.location();
        blk.top_label = top_label;
        blk.end_label = end_label;
        block_stack_.push_back(std::move(blk));
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %WHILE expression: ") + ex.what());
    }
}

void HLA::process_WEND(const TokenLine& line, size_t& i) {
    // Validate context
    if (block_stack_.empty() ||
            block_stack_.back().kind != hla::Block::Kind::While) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%WEND without matching %WHILE");
        return;
    }
    // %WEND must not have extra tokens
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %WEND");
        return;
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // Emit: JP top_label
    {
        TokenLine jp(line.location());
        jp.tokens().push_back(kw_tok(Keyword::JP));
        jp.tokens().push_back(Token(TokenType::Identifier, blk.top_label, false));
        out_queue_.push_back(std::move(jp));
    }

    // Place: .end_label
    hla::CodeGen cg(g_unique_id_counter);
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}

void HLA::process_REPEAT(const TokenLine& line, size_t& i) {
    // %REPEAT must not have trailing tokens
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %REPEAT");
        return;
    }

    const size_t id = g_unique_id_counter++;
    const std::string top_label = "HLA_REPEAT_" + std::to_string(id) + "_TOP";
    const std::string end_label = "HLA_REPEAT_" + std::to_string(id) + "_END";

    hla::CodeGen cg(g_unique_id_counter);
    cg.emit_label(top_label, line.location(), out_queue_);

    hla::Block blk;
    blk.kind = hla::Block::Kind::Repeat;
    blk.location = line.location();
    blk.top_label = top_label;
    blk.end_label = end_label;
    block_stack_.push_back(std::move(blk));
}

void HLA::process_UNTIL(const TokenLine& line, size_t& i) {
    if (block_stack_.empty() ||
            block_stack_.back().kind != hla::Block::Kind::Repeat) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%UNTIL without matching %REPEAT");
        return;
    }
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %UNTIL");
        return;
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    try {
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr();

        // Branch back to top if expression is false
        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_bif(*expr, blk.top_label, line.location(), out_queue_);
        // Place end label
        cg.emit_label(blk.end_label, line.location(), out_queue_);
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %UNTIL expression: ") + ex.what());
    }
}

void HLA::process_UNTILB(const TokenLine& line, size_t& i) {
    // %UNTILB ends a %REPEAT loop using a B counter:
    //   dec b
    //   jp nz, <top_label>
    if (block_stack_.empty() ||
            block_stack_.back().kind != hla::Block::Kind::Repeat) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%UNTILB without matching %REPEAT");
        return;
    }
    // No extra tokens allowed after %UNTILB
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %UNTILB");
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // DEC B
    {
        TokenLine dec(line.location());
        dec.tokens().push_back(kw_tok(Keyword::DEC));
        dec.tokens().push_back(kw_tok(Keyword::B));
        out_queue_.push_back(std::move(dec));
    }
    // JP NZ, <top_label>
    {
        TokenLine jp(line.location());
        jp.tokens().push_back(kw_tok(Keyword::JP));
        jp.tokens().push_back(kw_tok(Keyword::NZ));
        jp.tokens().push_back(Token(TokenType::Comma, ",", false));
        jp.tokens().push_back(Token(TokenType::Identifier, blk.top_label, false));
        out_queue_.push_back(std::move(jp));
    }

    // Place end label
    hla::CodeGen cg(g_unique_id_counter);
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}

void HLA::process_UNTILBC(const TokenLine& line, size_t& i) {
    // %UNTILBC ends a %REPEAT loop by: dec bc; ld a, b; or c; jp nz, <top>
    if (block_stack_.empty()
            || block_stack_.back().kind != hla::Block::Kind::Repeat) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%UNTILBC without matching %REPEAT");
        return;
    }
    // No extra tokens allowed after %UNTILBC
    if (i < line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %UNTILBC");
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // dec bc
    {
        TokenLine t(line.location());
        t.tokens().push_back(kw_tok(Keyword::DEC));
        t.tokens().push_back(kw_tok(Keyword::BC));
        out_queue_.push_back(std::move(t));
    }
    // ld a, b
    {
        TokenLine t(line.location());
        t.tokens().push_back(kw_tok(Keyword::LD));
        t.tokens().push_back(kw_tok(Keyword::A));
        t.tokens().push_back(Token(TokenType::Comma, ",", false));
        t.tokens().push_back(kw_tok(Keyword::B));
        out_queue_.push_back(std::move(t));
    }
    // or c
    {
        TokenLine t(line.location());
        t.tokens().push_back(kw_tok(Keyword::OR));
        t.tokens().push_back(kw_tok(Keyword::C));
        out_queue_.push_back(std::move(t));
    }
    // jp nz, <top_label>
    {
        TokenLine t(line.location());
        t.tokens().push_back(kw_tok(Keyword::JP));
        t.tokens().push_back(kw_tok(Keyword::NZ));
        t.tokens().push_back(Token(TokenType::Comma, ",", false));
        t.tokens().push_back(Token(TokenType::Identifier, blk.top_label, false));
        out_queue_.push_back(std::move(t));
    }

    // place end label
    hla::CodeGen cg(g_unique_id_counter);
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}

void HLA::process_BREAK(const TokenLine& line, size_t& i) {
    // Must be inside a WHILE or REPEAT block
    if (block_stack_.empty() ||
            !(block_stack_.back().kind == hla::Block::Kind::While ||
              block_stack_.back().kind == hla::Block::Kind::Repeat)) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%BREAK outside loop");
        return;
    }
    const hla::Block& blk = block_stack_.back();

    // Plain %BREAK with no tokens after
    if (i >= line.tokens().size()) {
        TokenLine jp(line.location());
        jp.tokens().push_back(kw_tok(Keyword::JP));
        jp.tokens().push_back(Token(TokenType::Identifier, blk.end_label, false));
        out_queue_.push_back(std::move(jp));
        return;
    }

    // Expect: IF <bool-expr>
    if (!(line.tokens()[i].is(TokenType::Identifier) &&
            line.tokens()[i].keyword() == Keyword::IF)) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %BREAK");
        return;
    }
    ++i; // consume IF
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %BREAK IF");
        return;
    }

    try {
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr(); // expression E

        // Wrap in NOT so emit_bif branches on TRUE of E to end_label
        auto not_node = std::make_unique<hla::Not>();
        not_node->e = std::move(expr);

        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_bif(*not_node, blk.end_label, line.location(), out_queue_);
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %BREAK IF expression: ") + ex.what());
    }
}

void HLA::process_CONTINUE(const TokenLine& line, size_t& i) {
    // Must be inside a WHILE or REPEAT block
    if (block_stack_.empty() ||
            !(block_stack_.back().kind == hla::Block::Kind::While ||
              block_stack_.back().kind == hla::Block::Kind::Repeat)) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%CONTINUE outside loop");
        return;
    }
    const hla::Block& blk = block_stack_.back();

    // Plain %CONTINUE (no IF): unconditional jump to top label
    if (i >= line.tokens().size()) {
        TokenLine jp(line.location());
        jp.tokens().push_back(kw_tok(Keyword::JP));
        jp.tokens().push_back(Token(TokenType::Identifier, blk.top_label, false));
        out_queue_.push_back(std::move(jp));
        return;
    }

    // Expect: IF <bool-expr>
    if (!(line.tokens()[i].is(TokenType::Identifier) &&
            line.tokens()[i].keyword() == Keyword::IF)) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %CONTINUE");
        return;
    }
    ++i; // consume IF
    if (i >= line.tokens().size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected expression after %CONTINUE IF");
        return;
    }

    try {
        hla::Parser parser(line, i, pp_->pp_module(), pp_->pp_current_section());
        auto expr = parser.parse_bool_expr(); // expression E

        // We want to jump when E is TRUE. emit_bif branches on FALSE.
        // Wrap in NOT so branch-if-false of !E == branch-if-true of E.
        auto not_node = std::make_unique<hla::Not>();
        not_node->e = std::move(expr);

        hla::CodeGen cg(g_unique_id_counter);
        cg.emit_bif(*not_node, blk.top_label, line.location(), out_queue_);
    }
    catch (const std::exception& ex) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Error parsing %CONTINUE IF expression: ") + ex.what());
    }
}
