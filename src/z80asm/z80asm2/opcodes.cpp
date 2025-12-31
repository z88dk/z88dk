//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "errors.h"
#include "keywords.h"
#include "opcodes.h"
#include <algorithm>
#include <cassert>

// Return target state, or NO_ACTION if no transition.
int32_t OpcodesParser::find_transition(int32_t state, uint16_t token) {
    // If dense_row_offsets[state] != -1, use O(1) dense lookup
    int32_t dense_offset = dense_row_offsets[state];
    if (dense_offset != -1) {
        // O(1) lookup in dense_rows
        int32_t target = dense_rows[dense_offset + token];
        return target;
    }

    // Otherwise, use sparse CSR row (binary search)
    uint32_t start = state_offsets[state];
    uint32_t end = state_offsets[state + 1];
    const uint16_t* first = &trans_tokens[start];
    const uint16_t* last = &trans_tokens[end];
    const uint16_t* it = std::lower_bound(first, last, token);
    if (it == last || *it != token) {
        return NO_ACTION;
    }
    uint32_t idx = uint32_t(it - &trans_tokens[0]);
    return trans_targets[idx];
}

// Return accept action index or NO_ACTION
int32_t OpcodesParser::accept_action(int32_t state) {
    return accept_index[state]; // map to accept_actions if >=0
}

OpcodesParser::OpcodesParser(CompilationUnit* unit)
    : unit_(unit) {
}

void OpcodesParser::clear() {
    line_ = nullptr;
    i_ = 0;
    exprs_.clear();
}

bool OpcodesParser::parse(const TokenLine& line) {
    line_ = &line;
    i_ = 0;

    // check for empty line
    if (i_ >= line_->tokens().size()) {
        return true;
    }

    int action_idx = follow_dfa();
    if (action_idx < 0) {
        return false;
    }

    do_action(action_idx);
    return true;
}

// return action id, NO_ACTION if follow_dfa failed
int OpcodesParser::follow_dfa() {
    const auto& tokens = line_->tokens();
    if (i_ >= tokens.size()) {
        g_errors.error(ErrorCode::InvalidSyntax, "Unexpected empty line");
        return NO_ACTION;
    }

    // find transition for CPU token
    int state = 0;
    DFA_Token dt = get_dfa_token(g_options.cpu_id);
    state = find_transition(state, static_cast<uint16_t>(dt));
    if (state < 0) {
        g_errors.error(ErrorCode::InvalidCpu, cpu_name(g_options.cpu_id));
        return NO_ACTION;
    }

    // follow DFA transtions for rest of tokens
    while (true) {
        dt = get_dfa_token(*line_, i_);
        int action_idx = accept_action(state);
        if (dt == DFA_Token::TK_EndOfLine && action_idx >= 0) {
            return action_idx;
        }

        int target_state = find_transition(state, static_cast<uint16_t>(dt));
        if (target_state >= 0) {
            state = target_state;
            ++i_;
            continue;
        }

        // check for Expr token as fallback
        target_state = find_transition(state,
                                       static_cast<uint16_t>(DFA_Token::Expr));
        if (target_state >= 0) {
            Expression expr;
            if (!expr.parse(*line_, i_, unit_->current_module(),
                            unit_->current_module()->current_section())) {
                // expression parse failed
                g_errors.error(ErrorCode::InvalidSyntax,
                               "Invalid expression starting at token '" +
                               tokens[i_].text() + "'");
                return NO_ACTION;
            }

            exprs_.push_back(std::move(expr));
            state = target_state;
            continue;
        }

        // check for PlusExpr token as fallback
        if (dt == DFA_Token::TK_Plus || dt == DFA_Token::TK_Minus) {
            target_state = find_transition(state,
                                           static_cast<uint16_t>(DFA_Token::PlusExpr));
            if (target_state >= 0) {
                Expression expr;
                if (!expr.parse(*line_, i_, unit_->current_module(),
                                unit_->current_module()->current_section())) {
                    // expression parse failed
                    g_errors.error(ErrorCode::InvalidSyntax,
                                   "Invalid expression starting at token '" +
                                   tokens[i_].text() + "'");
                    return NO_ACTION;
                }

                exprs_.push_back(std::move(expr));
                state = target_state;
                continue;
            }
        }

        // invalid token
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token '" + tokens[i_].text() +
                       "' for cpu " + cpu_name(g_options.cpu_id));
        return NO_ACTION;
    }
}

DFA_Token OpcodesParser::get_dfa_token(CPU cpu_id) {
    return map_cpu_to_dfa_tokens[static_cast<size_t>(cpu_id)];
}

// get DFA_Token from current token
DFA_Token OpcodesParser::get_dfa_token(const TokenLine& line, size_t i) {
    if (i >= line.tokens().size()) {
        return DFA_Token::TK_EndOfLine;
    }

    const Token& token = line.tokens()[i];
    Keyword kw = token.keyword();
    DFA_Token dt = map_keyword_to_dfa_tokens[static_cast<size_t>(kw)];
    if (dt != DFA_Token::None) {
        return dt;
    }

    TokenType tt = token.type();
    dt = map_token_type_to_dfa_tokens[static_cast<size_t>(tt)];
    return dt;
}

// call site inside member function
void OpcodesParser::do_action(int action_idx) {
    assert(action_idx >= 0 && action_idx < ActionCount);

    // call through correct this
    (this->*accept_actions[action_idx])();
}

void OpcodesParser::pop_expr(Expression& out) {
    // get first expression and move it into caller-provided storage
    assert(!exprs_.empty());
    out = std::move(exprs_.front());
    exprs_.pop_front();
}

Opcode* OpcodesParser::emit_bytes(uint64_t value) {
    const Location& location = line_->location();
    Section* section = unit_->current_module()->current_section();
    Opcode opcode(section, location);
    opcode.add_bytes(value);
    return section->add_opcode(std::move(opcode));
}

void OpcodesParser::emit_bytes_expr(uint64_t value,
                                    int offset, PatchRange range) {
    // get first expresion
    Expression expr;
    pop_expr(expr);

    // emit opcode
    emit_bytes_expr(value, offset, range, expr);
}

void OpcodesParser::emit_bytes_expr(uint64_t value,
                                    int offset, PatchRange range, const Expression& expr) {
    // emit fixed part
    Opcode* opcode = emit_bytes(value);

    // emit patch
    Patch patch(opcode, offset, range, expr);
    opcode->add_patch(std::move(patch));
}

void OpcodesParser::emit_bytes_expr(uint64_t value,
                                    int offset1, PatchRange range1,
                                    int offset2, PatchRange range2) {
    // get first expresions
    Expression expr1, expr2;
    pop_expr(expr1);
    pop_expr(expr2);

    // emit fixed part
    Opcode* opcode = emit_bytes(value);

    // emit patches
    Patch patch1(opcode, offset1, range1, std::move(expr1));
    opcode->add_patch(std::move(patch1));

    Patch patch2(opcode, offset2, range2, std::move(expr2));
    opcode->add_patch(std::move(patch2));
}

void OpcodesParser::emit_bytes_func(uint64_t value,
                                    int offset, PatchRange range,
                                    const std::string& func) {

    // declare the function as external symbol
    unit_->current_module()->declare_symbol(
        func, line_->location(), SymbolScope::Extern);

    // build expression referencing the function
    Expression func_expr;
    TokenLine func_line(line_->location());
    func_line.tokens().push_back((Token(TokenType::Identifier, func, false)));
    size_t i = 0;
    if (!func_expr.parse(func_line, i, unit_->current_module(),
                         unit_->current_module()->current_section())) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Invalid function expression: " + func_line.to_string());
        return;
    }

    // emit fixed part
    Opcode* opcode = emit_bytes(value);

    // emit patch
    Patch patch(opcode, offset, range, std::move(func_expr));
    opcode->add_patch(std::move(patch));
}

Expression OpcodesParser::get_temp_expr(const std::string& temp_label,
                                        int temp_label_offset) {

    // build expression referencing the temp_label+temp_label_offset
    Expression temp_expr;
    TokenLine temp_line(line_->location());
    temp_line.tokens().push_back((Token(TokenType::Identifier, temp_label, false)));
    if (temp_label_offset < 0) {
        temp_line.tokens().push_back((Token(TokenType::Minus, "-", false)));
        temp_line.tokens().push_back((Token(TokenType::Integer, std::to_string(-temp_label_offset), -temp_label_offset,
                                            false)));
    }
    else if (temp_label_offset > 0) {
        temp_line.tokens().push_back((Token(TokenType::Plus, "+", false)));
        temp_line.tokens().push_back((Token(TokenType::Integer, std::to_string(temp_label_offset), temp_label_offset, false)));
    }
    else {
        // nothing to add if zero
    }

    size_t i = 0;
    if (!temp_expr.parse(temp_line, i, unit_->current_module(),
                         unit_->current_module()->current_section())) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Invalid temp expression: " + temp_line.to_string());
        return Expression();
    }

    return temp_expr;
}

void OpcodesParser::emit_bytes_temp_expr(uint64_t value,
        int offset, PatchRange range,
        const std::string& temp_label, int temp_label_offset) {
    // compute temp expression
    Expression temp_expr = get_temp_expr(temp_label, temp_label_offset);
    if (temp_expr.empty()) {
        return;
    }

    // emit fixed part
    Opcode* opcode = emit_bytes(value);

    // emit patch
    Patch patch(opcode, offset, range, std::move(temp_expr));
    opcode->add_patch(std::move(patch));
}

void OpcodesParser::add_label_symbol(const std::string& label_name,
                                     int offset) {
    unit_->current_module()->add_label_symbol(
        label_name, line_->location(), offset);
}

int OpcodesParser::get_const() {
    // get first expresion
    assert(exprs_.size() >= 1);
    Expression expr = std::move(exprs_.front());
    exprs_.pop_front();

    if (!expr.is_constant()) {
        g_errors.error(ErrorCode::InvalidOperand,
                       "Expected constant expression");
        return 0;
    }

    int c = expr.evaluate();
    return c;
}

int OpcodesParser::get_const_8() {
    int c = get_const();
    if (c < 0 || c >= 8) {
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) + " out of range 0..7");
        return 0;
    }

    return c;
}

int OpcodesParser::get_const_012() {
    int c = get_const();
    if (c < 0 || c > 2) {
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) + " out of range 0,1,2");
        return 0;
    }

    return c;
}

int OpcodesParser::get_const_0123() {
    int c = get_const();
    if (c < 0 || c > 3) {
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) + " out of range 0,1,2,3");
        return 0;
    }

    return c;
}

int OpcodesParser::get_const_124() {
    int c = get_const();
    switch (c) {
    case 1:
    case 2:
    case 4:
        return c;
    default:
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) + " out of range 1,2,4");
        return 0;
    }
}

int OpcodesParser::get_const_1248() {
    int c = get_const();
    switch (c) {
    case 1:
    case 2:
    case 4:
    case 8:
        return c;
    default:
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) + " out of range 1,2,4,8");
        return 0;
    }
}

int OpcodesParser::get_const_16_24_32_40_56() {
    int c = get_const();
    switch (c) {
    case 0x10:
    case 0x18:
    case 0x20:
    case 0x28:
    case 0x38:
        return c;
    default:
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) +
                       " out of range 0x10, 0x18, 0x20, 0x28, 0x38");
        return 0;
    }
}

int OpcodesParser::get_const_0_8_16_24_32_40_48_56() {
    int c = get_const();
    switch (c) {
    case 0x00:
    case 0x08:
    case 0x10:
    case 0x18:
    case 0x20:
    case 0x28:
    case 0x30:
    case 0x38:
        return c;
    default:
        g_errors.error(ErrorCode::IntegerRange,
                       "Constant " + int_to_hex(c) +
                       " out of range 0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38");
        return 0;
    }
}
