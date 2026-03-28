//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_expr.h"
#include "lexer.h"
#include "source_file.h"
#include "string_interner.h"
#include <deque>
#include <unordered_map>
#include <vector>

static const int MAX_EXPANSION_DEPTH = 1000;

struct LogicalLine {
    std::vector<Token> tokens{};
    SourceLoc loc{};
};

struct MacroBody {
    std::vector<Token> tokens;                 // object/function-like
    std::vector<std::vector<Token>> lines;     // classical multi-line
    std::vector<StringInterner::Id> params;    // interned identifiers
    bool is_function_like = false;
    bool is_multiline = false;
};

struct PreprocessorContext {
    // ---------------------------------------------------------------------
    // Include stack: tracks nested file inclusion
    // ---------------------------------------------------------------------
    struct IncludeFrame {
        const SourceFile* file = nullptr;
        size_t current_line = 0;
        StringInterner::Id logical_file_id = 0;
        int logical_line = 1;
    };

    std::vector<IncludeFrame> include_stack;

    // ---------------------------------------------------------------------
    // Macro table: object-like, function-like, classical multi-line
    // ---------------------------------------------------------------------
    std::unordered_map<StringInterner::Id, MacroBody> macros;

    // ---------------------------------------------------------------------
    // Preprocessor symbols: -DNAME=expr, EQU, IF expressions
    // ---------------------------------------------------------------------
    ConstSymbols const_symbols;

    // ---------------------------------------------------------------------
    // Conditional stack: IF / ELSEIF / ELSE / ENDIF
    // ---------------------------------------------------------------------
    struct ConditionalFrame {
        bool parent_active = true;
        bool this_branch_taken = false;
        bool currently_active = true;
        SourceLoc if_loc;   // for error reporting
    };

    std::vector<ConditionalFrame> cond_stack;

    // ---------------------------------------------------------------------
    // Feedback loop queue:
    //
    // Classical macro expansion may emit directive lines (e.g. nested
    // MACRO/ENDM). These must be processed by the directive engine before
    // normal macro expansion continues. The driver pulls from this queue
    // before reading from include_stack.
    // ---------------------------------------------------------------------
    std::deque<LogicalLine> macro_work_queue;

    // ---------------------------------------------------------------------
    // Options
    // ---------------------------------------------------------------------
    bool compat_mode = true;
};
