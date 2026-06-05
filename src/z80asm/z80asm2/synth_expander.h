//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "options.h"
#include <vector>

// state of the Synthetic Expander
class SynthExpander {
public:
    SynthExpander(const std::vector<LogicalLine>& lines);

    std::vector<LogicalLine> expand();

private:
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

    CPU synth_expander_cpu_id = DEFAULT_CPU;
    const std::vector<LogicalLine>& lines; // input lines

    void collect_label_tokens(ParseLine& pline, std::vector<Token>& out);
    const TrieTransition* binary_search_transition(size_t node, TrieToken key);
    SynthMatch recognize_synthetic(const LogicalLine& line);
    void interpret_synth_bytecode(const SynthMatch& match,
                                  const LogicalLine& line,
                                  std::vector<LogicalLine>& out);
};
