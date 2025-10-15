//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "error_reporter.h"
#include "keywords.h"
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
        int line_directive_value = 0;
        int line_directive_physical_line = 0;
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
    bool is_recursive_include(const std::string& filename) const;
    void split_logical_lines(const char* buffer,
                             std::vector<LogicalLine>& lines);

    // Process directives
    bool is_directive(const char*& p, Keyword& keyword) const;
    bool process_directive(Keyword keyword, const char*& p, Location& location);
    bool process_include(const char*& p, Location& location);
    bool process_define(const char*& p, Location& location);
    bool process_undef(const char*& p, Location& location);
    bool process_line(const char*& p, Location& location);

    // Expands a macro invocation (object-like or function-like) in a line.
    // Returns the expanded string.
    static const inline int MAX_MACRO_RECURSION = 32;
    std::string expand_macros(const std::string& line,
                              int recursion_depth = 0);
    std::string expand_object_macro(const Macro& macro, int recursion_depth);
    std::string expand_function_macro(const Macro& macro,
                                      const std::vector<MacroToken>& tokens,
                                      size_t& i, int recursion_depth);
    bool handle_macro_operators(const std::vector<MacroToken>& tokens,
                                size_t& i, std::vector<std::string>& output);

    // Helper: Expand macro body with arguments
    std::string expand_macro_with_args(const Macro& macro,
                                       const std::vector<std::string>& args,
                                       int recursion_depth);
    std::unordered_map<std::string, std::string> make_param_map(
        const Macro& macro, const std::vector<std::string>& args);
    void expand_macro_token_with_args(
        const std::unordered_map<std::string, std::string>& param_map,
        const std::vector<MacroToken>& body_tokens,
        size_t& i,
        std::vector<std::string>& output);

    // Remove all comments from a line (handles multi-line comments with state)
    std::string remove_comments(InputFile& file);
    void handle_string_literal(const std::string& line,
                               size_t& i, std::string& result, bool& in_string);
    void handle_char_literal(const std::string& line,
                             size_t& i, std::string& result, bool& in_char);
    bool handle_multiline_comment_end(const std::string& line,
                                      size_t& i, bool& in_multiline_comment);

    // split line at colons and backslashes, except the first colon
    // if it's part of a label
    void split_lines(const std::string& line,
                     std::vector<std::string>& split_lines);
};
