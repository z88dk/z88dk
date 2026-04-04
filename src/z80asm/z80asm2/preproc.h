//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "const_symbols.h"
#include "file_mgr.h"
#include "lexer_tokens.h"
#include "preproc.h"
#include "source_loc.h"
#include "string_interner.h"
#include <deque>
#include <string_view>
#include <vector>

struct LogicalLine {
    std::vector<Token> tokens;
    SourceLoc loc;
};

struct MacroBody {
    std::vector<Token> tokens;                 // object/function-like
    std::vector<std::vector<Token>> lines;     // classical multi-line
    std::vector<StringInterner::Id> params;    // interned identifiers
    bool is_function_like = false;
    bool is_multiline = false;
};

struct Preproc {
    // ---------------------------------------------------------------------
    // Include stack: tracks nested file inclusion
    // ---------------------------------------------------------------------
    struct IncludeFrame {
        const SourceFile* file = nullptr;
        size_t current_line = 0;
        StringInterner::Id logical_file_id = 0;
        size_t logical_line = 1;
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
    // Dependency genration: set of logical file IDs encountered
    // during preprocessing
    // ---------------------------------------------------------------------
    std::vector<StringInterner::Id> dependency_files;


    // ---------------------------------------------------------------------
    // Methods
    // ---------------------------------------------------------------------

    // copy defines from options, command line, or global scope
    void set_const_symbols(const ConstSymbols& defs);

    // main entry point: preprocess file and return vector of tokens
    // for assembler
    std::vector<Token> preprocess(std::string_view filename);

private:

    // ---------------------------------------------------------------------
    // Directive processing: classification and dispatch
    // ---------------------------------------------------------------------

    // dispatch table for directive handlers
    using DirectiveHandler =
        void (Preproc::*)(const std::vector<Token>&, size_t&);
    static std::unordered_map<Keyword, DirectiveHandler> directive_handlers_;

    // main driver for directive processing: classifies line and
    // dispatches to handlers
    enum class LineType {
        Normal,
        Skip,
        ControlOnly
    };
    LineType process_directive_line(const std::vector<Token>& input_line,
                                    LogicalLine& out_line
                                   );

    void check_end_of_line(const std::vector<Token>& input_line,
                           size_t& pos,
                           std::string_view directive_name);
    bool parse_filename(const std::vector<Token>& input_line,
                        size_t& pos,
                        std::string_view directive_name,
                        std::string& out_filename,
                        bool& out_is_angle_bracket,
                        SourceLoc& out_filename_loc);
    bool parse_and_resolve_file(const std::vector<Token>& input_line,
                                size_t& pos,
                                std::string_view directive_name,
                                std::string& out_resolved,
                                SourceLoc& out_filename_loc);

    void process_INCLUDE(const std::vector<Token>& input_line, size_t& pos);
    void process_BINARY(const std::vector<Token>& input_line, size_t& pos);

    // ---------------------------------------------------------------------
    // Macro expansion: classification and dispatch
    // ---------------------------------------------------------------------

    // macro expansion: takes a logical line with macro invocation tokens and
    // expands it, pushing resulting lines to macro_work_queue
    void expand_line(const LogicalLine& in, std::vector<Token>& out_tokens);

    // helper for dumping logical lines during debugging
    void dump_logical_line(const LogicalLine& line,
                           StringInterner::Id& cur_file_id);
};
