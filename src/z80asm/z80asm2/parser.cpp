//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "errors.h"
#include "options.h"
#include "parser.h"
#include "unit.h"
#include <cassert>

//-----------------------------------------------------------------------------
// action tables
//-----------------------------------------------------------------------------

// Dispatch on the literal 0/1 in the generated inc file.
// 0 -> emit nullptr
// 1 -> emit &Preprocessor::handle_<id>
#define X(f, id)    X_##f(id)
#define X_0(id)     nullptr,
#define X_1(id)     &Parser::process_##id,

const Parser::Action Parser::asm_directive_actions[] = {
#include "keywords_asm_directive.inc"
};

#undef X
#undef X_0
#undef X_1

//-----------------------------------------------------------------------------
// Parser class
//-----------------------------------------------------------------------------

Parser::Parser(CompilationUnit* unit)
    : unit_(unit) {
}

void Parser::clear() {
    line_ = nullptr;
    i_ = 0;
    exprs_.clear();
}

bool Parser::parse(const TokenLine& line) {
    line_ = &line;
    i_ = 0;
    exprs_.clear();
    const auto& tokens = line_->tokens();

    // check for empty line
    if (i_ >= tokens.size()) {
        return true;
    }

    // check for label
    // preprocessor has already split labels from rest of line
    if (tokens.size() >= 2 &&
            tokens[0].is(TokenType::Dot) &&
            tokens[1].is(TokenType::Identifier)) {
        const std::string label_name = tokens[1].text();
        i_ += 2;
        expect_end();

        // handle label
        unit_->current_module()->add_label_symbol(
            label_name, line_->location(), 0);
        return true;
    }

    // check for directive
    if (tokens.size() >= 1 &&
            tokens[0].is(TokenType::Identifier) &&
            keyword_is_asm_directive(tokens[0].keyword())) {
        Keyword keyword = tokens[0].keyword();
        ++i_;
        process_directive(keyword);
        return true;
    }

    // unexpected tokens
    expect_end();

    return false;
}

void Parser::process_directive(Keyword keyword) {
    size_t idx = static_cast<size_t>(keyword);
    Action action = asm_directive_actions[idx];
    if (action) {
        (this->*action)();
    }
    else {
        assert(0);
    }
}

void Parser::process_DEFB() {
    process_define_list(1, PatchRange::ByteUnsigned);
}

void Parser::process_DB() {
    process_define_list(1, PatchRange::ByteUnsigned);
}

void Parser::process_DEFM() {
    process_define_list(1, PatchRange::ByteUnsigned);
}

void Parser::process_DM() {
    process_define_list(1, PatchRange::ByteUnsigned);
}

void Parser::process_BYTE() {
    process_define_list(1, PatchRange::ByteUnsigned);
}

void Parser::process_DEFW() {
    process_define_list(2, PatchRange::Word);
}

void Parser::process_DW() {
    process_define_list(2, PatchRange::Word);
}

void Parser::process_WORD() {
    process_define_list(2, PatchRange::Word);
}

void Parser::process_DEFW_BE() {
    process_define_list(2, PatchRange::WordBigEndian);
}

void Parser::process_DW_BE() {
    process_define_list(2, PatchRange::WordBigEndian);
}

void Parser::process_DEFDB() {
    process_define_list(2, PatchRange::WordBigEndian);
}

void Parser::process_DDB() {
    process_define_list(2, PatchRange::WordBigEndian);
}

void Parser::process_DEFP() {
    process_define_list(3, PatchRange::Ptr24);
}

void Parser::process_DP() {
    process_define_list(3, PatchRange::Ptr24);
}

void Parser::process_PTR() {
    process_define_list(3, PatchRange::Ptr24);
}

void Parser::process_DEFQ() {
    process_define_list(4, PatchRange::Dword);
}

void Parser::process_DQ() {
    process_define_list(4, PatchRange::Dword);
}

void Parser::process_DWORD() {
    process_define_list(4, PatchRange::Dword);
}

void Parser::process_DEFS() {
    // Parse expressions following the directive
    parse_expr_list();

    // Must have at least one expression
    if (exprs_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "DEFS requires at least one expression");
        return;
    }

    Module* module = unit_ ? unit_->current_module() : nullptr;
    Section* section = module ? module->current_section() : nullptr;
    if (!section) {
        return;
    }

    // Evaluate all expressions, ensuring they are constant
    std::vector<int> values;
    values.reserve(exprs_.size());

    bool failed = false;
    while (!exprs_.empty()) {
        Expression expr = std::move(exprs_.front());
        exprs_.pop_front();

        if (!expr.is_constant()) {
            g_errors.error(expr.location(), ErrorCode::NotConstantSymbol, "Constant expression expected");
            failed = true;
            continue;
        }

        int v = expr.evaluate();
        values.push_back(v);
    }

    if (failed || values.empty()) {
        return;
    }

    // First expression: space to reserve
    int count = values[0];
    if (count < 0 || count > 65536) {
        g_errors.error(ErrorCode::IntegerRange, std::to_string(count));
        return;
    }

    // Helper for filler range check
    auto check_filler = [](int v) -> bool {
        return v >= -128 && v <= 255;
    };

    Opcode opcode(section, line_->location());

    if (values.size() == 1) {
        // Use global filler
        int filler = g_options.filler_byte;
        if (!check_filler(filler)) {
            g_errors.error(ErrorCode::IntegerRange, std::to_string(filler));
            return;
        }
        for (int i = 0; i < count; ++i) {
            opcode.add_byte(static_cast<uint8_t>(filler & 0xFF));
        }
    }
    else if (values.size() == 2) {
        // Custom filler
        int filler = values[1];
        if (!check_filler(filler)) {
            g_errors.error(ErrorCode::IntegerRange, std::to_string(filler));
            return;
        }
        for (int i = 0; i < count; ++i) {
            opcode.add_byte(static_cast<uint8_t>(filler & 0xFF));
        }
    }
    else {
        // String/data bytes + padding with global filler
        int str_len = static_cast<int>(values.size()) - 1;
        if (count < str_len) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "String longer than reserved space");
            return;
        }
        // Copy provided bytes
        for (int i = 1; i < static_cast<int>(values.size()); ++i) {
            int b = values[i];
            if (!check_filler(b)) {
                g_errors.error(ErrorCode::IntegerRange, std::to_string(b));
                return;
            }
            opcode.add_byte(static_cast<uint8_t>(b & 0xFF));
        }
        // Pad remaining with global filler
        int filler = g_options.filler_byte;
        if (!check_filler(filler)) {
            g_errors.error(ErrorCode::IntegerRange, std::to_string(filler));
            return;
        }
        for (int i = str_len; i < count; ++i) {
            opcode.add_byte(static_cast<uint8_t>(filler & 0xFF));
        }
    }

    // Emit opcode into the current section
    section->add_opcode(opcode);
}

void Parser::process_DS() {
    process_DEFS();
}

void Parser::process_define_list(int element_size, PatchRange range) {
    // Parse expressions following the directive
    parse_expr_list();

    Module* module = unit_ ? unit_->current_module() : nullptr;
    Section* section = module ? module->current_section() : nullptr;
    if (!section) {
        return;
    }

    Opcode opcode(section, line_->location());
    while (!exprs_.empty()) {
        Expression expr = std::move(exprs_.front());
        exprs_.pop_front();

        int offset = static_cast<int>(opcode.size());
        for (int b = 0; b < element_size; ++b) {
            opcode.add_byte(0); // placeholders
        }
        Patch patch(&opcode, offset, range, expr);
        opcode.add_patch(patch);
    }

    // Emit opcode into the current section (add_opcode clones internally)
    section->add_opcode(opcode);
}

void Parser::parse_expr_list() {
    if (!line_) {
        return;
    }

    Module* module = unit_ ? unit_->current_module() : nullptr;
    Section* section = module ? module->current_section() : nullptr;
    const auto& tokens = line_->tokens();

    while (true) {
        while (i_ < tokens.size() && tokens[i_].is(TokenType::Comma)) {
            ++i_;
        }

        if (i_ >= tokens.size()) {
            break;
        }

        Expression expr;
        if (!expr.parse(*line_, i_, module, section)) {
            g_errors.error(ErrorCode::InvalidSyntax, "Invalid expression");
            return;
        }
        exprs_.push_back(std::move(expr));

        if (i_ < tokens.size() && !tokens[i_].is(TokenType::Comma)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Expected ',' between expressions");
            return;
        }
    }
}

void Parser::expect_end() {
    if (i_ < line_->tokens().size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line_->tokens()[i_].text() + "'");
    }
}
