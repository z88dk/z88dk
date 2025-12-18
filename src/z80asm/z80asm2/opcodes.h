//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "expr.h"
#include "keywords.h"
#include "lexer.h"
#include "opcodes_tables.h"
#include "unit.h"
#include <cstdint>
#include <deque>

class OpcodesParser {
public:
    OpcodesParser(CompilationUnit* unit);
    void clear();
    bool parse(const TokenLine& line);

private:    // object data
    CompilationUnit* unit_ = nullptr;
    const TokenLine* line_ = nullptr;
    size_t i_ = 0; // point int line tokens
    std::deque<Expression> exprs_;

    static inline const int NO_ACTION = -1;

    int follow_dfa();
    void do_action(int action_idx);
    Opcode* emit_bytes(uint64_t value);
    void emit_bytes_expr(uint64_t value,
                         int offset, PatchRange range);
    void emit_bytes_expr(uint64_t value,
                         int offset1, PatchRange range1,
                         int offset2, PatchRange range2);
    void emit_bytes_expr_plus_one(uint64_t value,
                                  int offset, PatchRange range);
    void emit_bytes_func(uint64_t value, int offset,
                         const std::string& func);
    Expression get_temp_expr(const std::string& temp_label,
                             int temp_label_offset);
    void emit_bytes_temp_expr(uint64_t value,
                              int offset, PatchRange range,
                              const std::string& temp_label, int temp_label_offset);
    void add_label_symbol(const std::string& label_name, int offset);

    int get_const();
    int get_const_8();
    int get_const_012();
    int get_const_0123();
    int get_const_124();
    int get_const_1248();
    int get_const_16_24_32_40_56();
    int get_const_0_8_16_24_32_40_48_56();

private:    // class data
    // Counts filled by make_dfa.pl
    static const std::uint32_t StateCount;
    static const std::uint16_t TokenCount;
    static const std::uint16_t ActionCount;

    // start states per first opcode token
    static const int32_t start_states[static_cast<size_t>(DFA_Token::Count)];

    // map Keyword and TokenType to DFA_Token
    static const DFA_Token keyword_dfa_tokens[static_cast<size_t>(Keyword::Count)];
    static const DFA_Token token_type_dfa_tokens[static_cast<size_t>(TokenType::Count)];

    // declare alias for member function pointer
    using Action = void (OpcodesParser::*)();

    // CSR transition table
    static const std::uint32_t state_offsets[]; // [StateCount+1]
    static const std::uint16_t trans_tokens[];  // token ids
    static const std::int32_t  trans_targets[]; // target state ids

    // Acceptance table
    static const std::int32_t  accept_index[];   // [-1 == no accept]
    static const Action        accept_actions[];

    // CPU set masks for actions
    // maps action_idx -> cpu_set_index
    static const std::uint8_t action_set[];
    // cpu_set_mask[i] has bit j set if CPU j supported
    static const std::uint64_t cpu_set_mask[];
    // helper to check quickly:
    static bool cpu_ok_for_action(int action_idx);

    static DFA_Token get_dfa_token(const TokenLine& line, size_t i);
    static int32_t find_transition(int32_t state, uint16_t token);
    static int32_t accept_action(int32_t state);

#include "opcodes_tables.def"
};
