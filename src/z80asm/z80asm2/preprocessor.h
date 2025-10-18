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
        bool is_macro_expansion = false;
    };

    struct Macro {
        // parameter names (empty for object-like)
        std::vector<std::string> params;

        // tokenized macro body as multiple logical lines
        // each entry is the token vector for one logical line
        std::vector<std::vector<MacroToken>> body_lines;

        bool is_function_like() const {
            return !params.empty();
        }

        bool is_multi_line() const {
            return body_lines.size() > 1;
        }
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
    bool process_defl(const char*& p, Location& location);
    bool process_undef(const char*& p, Location& location);
    bool process_line(const char*& p, Location& location);
    bool process_macro(const char*& p, Location& location);

    // Checks for "name DIRECTIVE value" syntax.
    // If found, sets 'name' and 'keyword' and returns true. Advances 'p' past the directive.
    bool is_name_directive(const char*& p, std::string& name,
                           Keyword& keyword) const;
    bool process_name_directive(Keyword keyword, const std::string& name,
                                const char*& p);
    bool process_name_defl(const char*& p, const std::string& name);
    bool process_name_define(const char*& p, const std::string& name);
    bool process_name_macro(const char*& p, const std::string& name);

    // Parameter parsing helpers used by both `process_macro` and `process_name_macro`.
    bool parse_param_list_parenthesized(const char*& p,
                                        std::vector<std::string>& params);
    void parse_param_list_comma_separated(const char*& p,
                                          std::vector<std::string>& params);
    // Read macro body (lines) from the current input file into `macro` until ENDM.
    // Returns true if ENDM was found, false on EOF (still fills macro.body_lines).
    bool read_macro_body(InputFile& file, Macro& macro, const std::string& name);

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
        std::vector<std::string>& output) const;

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

    // Global counter used to uniquify LOCAL identifiers per expansion
    static inline int macro_expansion_counter_ = 0;

    // Helper: invoke a multi-line macro during expansion (pushes a virtual InputFile)
    std::string expand_multiline_macro_invocation(const std::string& name,
            const Macro& macro,
            const std::vector<MacroToken>& tokens,
            size_t& i,
            int recursion_depth,
            const std::string& prefix = std::string());
    // For object-like multi-line invocation we need tokens and index so any trailing
    // tokens on the same logical line can be captured and pushed for later expansion.
    std::string expand_multiline_object_macro_invocation(
        const std::string& name,
        const Macro& macro,
        const std::vector<MacroToken>& tokens,
        size_t& i,
        int recursion_depth,
        const std::string& prefix = std::string());

    // New helpers to remove duplication between the two expand_multiline_* methods
    int get_invocation_physical_line_num() const;
    std::vector<LogicalLine> build_virt_lines_from_macro(
        const Macro& macro,
        const std::unordered_map<std::string, std::string>& combined_param_map,
        int phys_line_num) const;
    void push_virtual_macro_file(const std::string& name,
                                 int uniq_id,
                                 std::vector<LogicalLine>&& virt_lines);
    // Push a macro virtual file plus an optional suffix virtual file that will be
    // processed after the macro body. `virt_lines` should already have the
    // caller-provided prefix applied (if any). If `suffix` is empty no suffix file
    // is pushed. `phys_line_num` is used for the suffix logical line.
    void push_macro_and_suffix_files(const std::string& name,
                                     int uniq_id,
                                     std::vector<LogicalLine>&& virt_lines,
                                     const std::string& suffix,
                                     int phys_line_num);

    // Apply a caller-provided prefix (text before the macro on the same logical line)
    // to the first virtual line produced by a macro expansion.
    // Ensures a separating space is inserted when necessary.
    void apply_prefix_to_virt_lines(std::vector<LogicalLine>& virt_lines,
                                    const std::string& prefix) const;

    // Parse macro argument list starting at tokens[start_index].
    // On success returns true, sets out_index to the token index after ')'
    // and fills out_args with expanded argument strings.
    bool parse_macro_args(const std::vector<MacroToken>& tokens,
                          size_t start_index,
                          size_t& out_index,
                          std::vector<std::string>& out_args,
                          int recursion_depth);

    // Helpers to extract LOCAL identifiers from a macro and build a map of
    // unique local names for a given expansion id.
    std::vector<std::string> collect_local_names(const Macro& macro) const;
    std::unordered_map<std::string, std::string> make_local_rename_map(
        const Macro& macro, int uniq_id) const;
};
