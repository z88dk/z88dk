//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "lexer_tokens.h"
#include "opcodes_trie_token.h"
#include <cstdint>
#include <vector>

// Node of the Trie tree
struct TrieNode {
    uint32_t first_transition;
    uint32_t count;
    int32_t accept_id;   // -1 if not accepting
};

// Transition of the Trie tree
struct TrieTransition {
    TrieToken token;
    uint32_t next_node;
};

// action for a Trie node, which is a sequence of bytecode instructions
struct TrieAction {
    uint32_t first_bytecode;
    uint32_t count;
};

// bytecode for synthetic expansion
enum class SynthOp : uint8_t {
    EmitToken,      // emit a token, followed by TrieToken value
    EmitInteger,    // emit an integer literal, followed by integer value
    EmitExprRef,    // emit an expression reference, followed by expression index
    EmitDispExprRef,// emit a displacement expression reference, followed by expression index
    EmitLabelRef,   // emit a label reference, followed by label index
    EmitLineBreak,  // emit a line break (end of logical line)
};

struct SynthBytecode {
    SynthOp op;
    uint16_t operand;
};

// expression spans for synthetic expansion
struct ExprSpan {
    size_t begin;  // token index in LogicalLine
    size_t end;    // one past last token of the expression
};

// match of a synthetic opcode pattern, used during synthetic expansion
struct SynthMatch {
    bool matched = false;
    int32_t accept_id = -1;
    std::vector<Token> label_tokens;
    std::vector<ExprSpan> expr_spans;
};

std::vector<LogicalLine> synthetic_expand(const std::vector<LogicalLine>& lines);
