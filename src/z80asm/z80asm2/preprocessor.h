//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "error_reporter.h"
#include "lexer.h"
#include <deque>
#include <string>
#include <unordered_map>
#include <vector>

class Preprocessor {
public:
    Preprocessor(ErrorReporter& reporter);

    // Open the main file and start processing
    bool open(const std::string& filename);

    // Get the next preprocessed line, returns false at EOF
    bool next_line(std::string& out_line, Location& out_location);

private:
    struct LogicalLine {
        std::string text;
        int physical_line_num; // 1-based
    };

    struct InputFile {
        std::string filename;
        std::vector<LogicalLine> lines;
        size_t line_index = 0;
        Location location;
        bool line_directive_active = false;
    };

    struct Macro {
        // parameter names (empty for object-like)
        std::vector<std::string> params;

        // tokenized macro body
        std::vector<MacroToken> body_tokens;
    };

    ErrorReporter& reporter_;
    std::vector<InputFile> file_stack_;
    std::unordered_map<std::string, Macro> macros_;
    std::deque<std::string> split_queue_;

    // Handle file stack
    bool read_file(const std::string& filename,
        std::vector<LogicalLine>& lines);
    void push_file(const std::string& filename);
    void pop_file();

    // Process directives
    bool is_directive(const std::string& line,
                      Keyword& keyword, size_t& after_word) const;
    bool process_directive(Keyword keyword, const std::string& line,
                           size_t after_word, Location& location);
    bool process_include(const std::string& rest, Location& location);
    bool process_define(const std::string& rest, Location& location);
    bool process_undef(const std::string& rest, Location& location);
    bool process_line(const std::string& rest, Location& location);

    // Expands a macro invocation (object-like or function-like) in a line.
    // Returns the expanded string.
    static const inline int MAX_MACRO_RECURSION = 32;
    std::string expand_macros(const std::string& line,
                              int recursion_depth = 0);

    // Helper: Expand macro body with arguments
    std::string expand_macro_with_args(const Macro& macro,
                                       const std::vector<std::string>& args, int recursion_depth);

    // Remove all comments from a line (handles multi-line comments with state)
    std::string remove_comments(InputFile& file);

    // split line at colons and backslashes, except the first colon
    // if it's part of a label
    void split_lines(const std::string& line,
                     std::vector<std::string>& split_lines);
};
