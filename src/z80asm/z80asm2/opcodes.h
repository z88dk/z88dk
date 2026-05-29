//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include "opcodes_trie_token.h"
#include <vector>
#include <cstdint>

// Node of the Trie tree
struct TrieNode {
    uint16_t first_transition;
    uint16_t count;
    int16_t accept_id;   // -1 if not accepting
};

// Transition of the Trie tree
struct TrieTransition {
    TrieToken token;
    uint16_t next_transition;
};

// result action bytecode
enum class SynthOp : uint8_t {
    EmitToken,      // emit a token, followed by TrieToken value
    EmitInteger,    // emit an integer literal, followed by integer value
    EmitExprRef,    // emit an expression reference, followed by expression index
    EmitDispExprRef,// emit a displacement expression reference, followed by expression index
    EmitLabelRef,   // emit a label reference, followed by label index
    EmitLineBreak,  // emit a line break (end of logical line)
};

// bytecode for synthetic expansion
struct SynthBytecode {
    SynthOp op;
    uint16_t operand;
};

// action for a Trie node, which is a sequence of bytecode instructions
struct SynthTrieAction {
    uint16_t first_bytecode;
    uint16_t count;
};

// expression spans for synthetic expansion
struct ExprSpan {
    size_t begin;  // token index in LogicalLine
    size_t end;    // one past last token of the expression
};

// match of a synthetic opcode pattern, used during synthetic expansion
struct SynthMatch {
    std::vector<Token> label_tokens;
    bool matched = false;
    int16_t accept_id = -1;
    std::vector<ExprSpan> expr_spans;
};

void collect_label_tokens(ParseLine& pline, std::vector<Token>& out);
std::vector<LogicalLine> synthetic_expand(const std::vector<LogicalLine>& lines);
SynthMatch recognize_synthetic(const LogicalLine& line);
void interpret_synth_bytecode(const SynthMatch& match, const LogicalLine& line,
                              std::vector<LogicalLine>& out);
