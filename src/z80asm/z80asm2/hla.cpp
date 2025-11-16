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

static Token kw_tok(Keyword k) {
    return Token(TokenType::Identifier, keyword_to_string(k), k);
}

void HLA::clear() {
    preprocessor_.clear();
    out_queue_.clear();
    block_stack_.clear();
    label_counter_ = 0;
}

void HLA::push_file(const std::string& filename) {
    preprocessor_.push_file(filename);
}

void HLA::push_virtual_file(const std::string& content,
                            const std::string& filename,
                            int first_line_num, bool inc_line_nums) {
    preprocessor_.push_virtual_file(content, filename, first_line_num,
                                    inc_line_nums);
}

bool HLA::next_line(TokensLine& out_line) {
    while (true) {
        // 1) If we have already produced lines, return them first.
        if (!out_queue_.empty()) {
            out_line = std::move(out_queue_.front());
            out_queue_.pop_front();
            return true;
        }

        // 2) Otherwise, read next cleaned line from the preprocessor.
        TokensLine line;
        if (!next_cleaned_line(line)) {
            // No more input. check for unclosed blocks.
            if (!block_stack_.empty()) {
                const hla::Block& top_blk = block_stack_.back();
                g_errors.set_location(top_blk.location);
                g_errors.error(ErrorCode::InvalidSyntax, "Unclosed HLA block");
            }

            return false;
        }

        // 3) Check for HLA directives beginning with '%'.
        if (line.size() >= 2 && line[0].is(TokenType::Modulus) &&
                line[1].is(TokenType::Identifier) &&
                keyword_is_hla_directive(line[1].keyword())) {

            unsigned i = 2;
            switch (line[1].keyword()) {
            case Keyword::IF:
                process_if(line, i);
                continue;
            case Keyword::ELIF:
                process_elif(line, i);
                continue;
            case Keyword::ELSE:
                process_else(line, i);
                continue;
            case Keyword::ENDIF:
                process_endif(line, i);
                continue;
            case Keyword::WHILE:
                process_while(line, i);
                continue;
            case Keyword::WEND:
                process_wend(line, i);
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

bool HLA::next_cleaned_line(TokensLine& out_line) {
    if (preprocessor_.next_line(out_line)) {
        // remove whitespace tokens
        TokensLine cleaned_line(out_line.location());
        cleaned_line.reserve(out_line.size());
        for (const auto& t : out_line.tokens()) {
            if (!t.is(TokenType::Whitespace)) {
                cleaned_line.push_back(t);
            }
        }
        out_line = std::move(cleaned_line);
        return true;
    }
    return false;
}

void HLA::process_if(const TokensLine& line, unsigned& i) {
    if (i >= line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %IF");
        return;
    }

    // Generate labels for IF
    const unsigned id = label_counter_++;
    const std::string else_label = "HLA_IF_" + std::to_string(id) + "_ELSE";
    const std::string end_label = "HLA_IF_" + std::to_string(id) + "_END";

    try {
        // Parse boolean expression after %IF
        hla::Parser parser(line, i);
        auto expr = parser.parse_bool_expr();

        // Emit branch-if-false to else_label
        hla::CodeGen cg(label_counter_);
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

void HLA::process_elif(const TokensLine& line, unsigned& i) {
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
    if (i >= line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %ELIF");
        return;
    }

    try {
        // Close previous true-branch: jump to end, then place else-label
        {
            // Emit: JP end_label
            TokensLine jp(line.location());
            jp.push_back(kw_tok(Keyword::JP));
            jp.push_back(Token(TokenType::Identifier, blk.end_label));
            out_queue_.push_back(std::move(jp));

            // Place: .else_label
            hla::CodeGen cg(label_counter_);
            cg.emit_label(blk.else_label, line.location(), out_queue_);
        }

        // Parse boolean expression of this %ELIF
        hla::Parser parser(line, i);
        auto expr = parser.parse_bool_expr();

        // Create a new else label for the remainder of the chain
        const unsigned id = label_counter_++;
        const std::string new_else_label = "HLA_IF_" + std::to_string(id) + "_ELSE";

        // Emit branch-if-false of this ELIF to its else label
        hla::CodeGen cg(label_counter_);
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

void HLA::process_else(const TokensLine& line, unsigned& i) {
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
    if (i < line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %ELSE");
        return;
    }

    // Close previous true-branch: jump to end, then place else-label
    {
        TokensLine jp(line.location());
        jp.push_back(kw_tok(Keyword::JP));
        jp.push_back(Token(TokenType::Identifier, blk.end_label));
        out_queue_.push_back(std::move(jp));

        // Place: .else_label
        hla::CodeGen cg(label_counter_);
        cg.emit_label(blk.else_label, line.location(), out_queue_);
    }

    blk.saw_else = true;
}

void HLA::process_endif(const TokensLine& line, unsigned& i) {
    // Validate context
    if (block_stack_.empty() || block_stack_.back().kind != hla::Block::Kind::If) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%ENDIF without matching %IF");
        return;
    }
    // %ENDIF must not have extra tokens
    if (i < line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %ENDIF");
        return;
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // If no %ELSE was seen, we still need to place the current else_label
    hla::CodeGen cg(label_counter_);
    if (!blk.saw_else) {
        cg.emit_label(blk.else_label, line.location(), out_queue_);
    }

    // Always place the end label to terminate the IF chain
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}

void HLA::process_while(const TokensLine& line, unsigned& i) {
    if (i >= line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Expected expression after %WHILE");
        return;
    }

    try {
        // Parse boolean expression after %WHILE
        hla::Parser parser(line, i);
        auto expr = parser.parse_bool_expr();

        // Labels for WHILE
        const unsigned id = label_counter_++;
        const std::string top_label = "HLA_WHILE_" + std::to_string(id) + "_TOP";
        const std::string end_label = "HLA_WHILE_" + std::to_string(id) + "_END";

        // Place: .top_label
        hla::CodeGen cg(label_counter_);
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

void HLA::process_wend(const TokensLine& line, unsigned& i) {
    // Validate context
    if (block_stack_.empty()
            || block_stack_.back().kind != hla::Block::Kind::While) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "%WEND without matching %WHILE");
        return;
    }
    // %WEND must not have extra tokens
    if (i < line.size()) {
        g_errors.set_location(line.location());
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected tokens after %WEND");
        return;
    }

    hla::Block blk = block_stack_.back();
    block_stack_.pop_back();

    // Emit: JP top_label
    {
        TokensLine jp(line.location());
        jp.push_back(kw_tok(Keyword::JP));
        jp.push_back(Token(TokenType::Identifier, blk.top_label));
        out_queue_.push_back(std::move(jp));
    }

    // Place: .end_label
    hla::CodeGen cg(label_counter_);
    cg.emit_label(blk.end_label, line.location(), out_queue_);
}
