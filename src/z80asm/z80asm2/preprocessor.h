//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "keywords.h"
#include "lexer.h"
#include <deque>
#include <functional>
#include <string>
#include <unordered_map>
#include <vector>

class Preprocessor {
public:
    Preprocessor() = default;

    // Clear all state (stack, macros, recursion counters)
    void clear();

    // Push a TokensFile constructed from a file.
    void push_file(const std::string& filename);

    // Push a TokensFile constructed from a string (virtual file).
    void push_virtual_file(const std::string& content,
                           const std::string& filename,
                           int first_line_num = 1);

    // Push a virtual file constructed from a binary file.
    void push_binary_file(const std::string& bin_filename);

    // Pop and return the next processed TokensLine.
    bool next_line(TokensLine& out_line);

    // Register a simple macro replacement (no parameters). Replacement may be
    // one or more TokensLine objects (multi-line macro).
    void define_macro(const std::string& name,
                      const std::vector<TokensLine>& replacement);

private:
    static const inline int MAX_MACRO_RECURSION = 32;

    struct Macro {
        std::vector<TokensLine> replacement; // replacement token lines
        std::vector<std::string> params;     // parameter names (empty => object-like)
        bool is_function = false;
    };

    struct File {
        TokensFile tokens_file;
        unsigned line_index = 0;

        // Optional forced logical location produced by a LINE directive.
        // When has_forced_location is true the logical location for the
        // token lines starting at forced_from_index will be:
        //   filename = forced_filename (if not empty)
        //   line_num = forced_start_line_num + (physical_index - forced_from_index)
        // If forced_constant_line_numbers is true the line_num will always be
        // equal to forced_start_line_num for all subsequent lines.
        bool has_forced_location = false;
        unsigned forced_from_index = 0;
        int forced_start_line_num = 0;
        std::string forced_filename;
        bool forced_constant_line_numbers = false;
    };

    // Queue of tokenized lines waiting to be processed/consumed.
    std::deque<TokensLine> input_queue_;

    // Stack of source files currently open (keeps ownership of
    // TokensFile objects).
    std::vector<File> file_stack_;

    // Macro table
    std::unordered_map<std::string, Macro> macros_;

    // Track macro expansion recursion depth per macro name
    // (to avoid infinite recursion).
    std::unordered_map<std::string, int> macro_recursion_count_;

    // parse and process directives

    // Internal helpers
    void expect_end(const TokensLine& line, unsigned i) const;
    bool parse_params_list(const TokensLine& line, unsigned& i,
                           std::vector<std::string>& out_params) const;
    bool parse_macro_args(const TokensLine& line, unsigned& i,
                          std::vector<TokensLine>& out_args);
    // Helper to parse arguments common to LINE and C_LINE.
    // Parses: <linenum> [ , "filename" ]
    // On success returns true and sets linenum/filename (filename may be empty).
    // On failure it emits an appropriate error message using directive_name and returns false.
    bool parse_line_args(const TokensLine& line, unsigned& i,
                         int& out_linenum, std::string& out_filename,
                         const char* directive_name) const;
    // Parse a filename from the tokens at position i.
    // Supports:
    //  - quoted string token (double-quoted or angle-bracketed)
    //  - plain filename parsed up to whitespace
    // On success returns true, sets out_filename and out_is_angle and advances i.
    // On failure returns false and does not emit errors (caller should emit appropriate message).
    bool parse_filename(const TokensLine& line, unsigned& i,
                        std::string& out_filename, bool& out_is_angle) const;

    // parse directives
    bool is_directive(const TokensLine& line, unsigned& i,
                      Keyword& keyword) const;
    bool is_name_directive(const TokensLine& line, unsigned& i,
                           Keyword& keyword, std::string& name) const;
    void process_directive(const TokensLine& line, unsigned& i,
                           Keyword keyword);
    void process_name_directive(const TokensLine& line, unsigned& i,
                                Keyword keyword, const std::string& name);

    // INCLUDE
    void process_include(const TokensLine& line, unsigned& i);
    void do_include(const std::string& filename, bool is_angle);
    // Search include path for a candidate filename. Returns resolved path or
    // original file name if not found. Uses the same semantics as
    // resolve_include_candidate.
    std::string search_include_path(const std::string& filename,
                                    bool is_angle) const;

    // BINARY / INCBIN
    void process_binary(const TokensLine& line, unsigned& i);
    void do_binary(const std::string& filename, bool is_angle);

    // LINE / C_LINE
    void process_line(const TokensLine& line, unsigned& i);
    void process_c_line(const TokensLine& line, unsigned& i);

    // DEFINE
    void process_define(const TokensLine& line, unsigned& i);
    void process_name_define(const TokensLine& line, unsigned& i,
                             const std::string& name);
    // New helper that contains the common trailing work after argument parsing.
    // Consumes the rest of the tokens from `i` (or the provided index) and
    // registers the macro `name`. `i` is updated to the index after what was consumed.
    void do_define(const TokensLine& line, unsigned& i,
                   const std::string& name, bool has_args,
                   const std::vector<std::string>& params);

    // UNDEF
    void process_undef(const TokensLine& line, unsigned& i);
    void process_name_undef(const TokensLine& line, unsigned& i,
                            const std::string& name);
    // New helper for shared UNDEF behavior
    void do_undef(const std::string& name, const TokensLine& line, unsigned& i);

    // Macro expansion and line splitting
    void split_lines(const Location& location,
                     const std::vector<TokensLine>& expanded);
    void split_line(const Location& location, const TokensLine& expanded);
    void split_label(const Location& location,
                     const TokensLine& expanded, unsigned& i);
    void merge_double_hash(TokensLine& line);

    // Refactored helpers for expand_macros (logical blocks)
    bool is_macro_call(const TokensLine& in_line, unsigned idx,
                       const Macro& macro,
                       unsigned& args_start_idx) const;
    bool parse_and_expand_macro_args(
        const TokensLine& in_line,
        unsigned args_start_idx,
        std::vector<TokensLine>& expanded_args_flat,
        std::vector<TokensLine>& out_original_args,
        unsigned& out_after_idx);
    bool try_stringize_parameter(
        const TokensLine& rep_line,
        unsigned& pidx,
        const Macro& macro,
        const std::vector<TokensLine>& original_args,
        TokensLine& new_line);
    std::vector<TokensLine> substitute_and_expand(
        const Macro& macro,
        const std::vector<TokensLine>& expanded_args_flat,
        const std::vector<TokensLine>& original_args,
        const std::string& name);
    void append_expansion_into_out(
        const std::vector<TokensLine>& further_expanded,
        TokensLine& out,
        std::vector<TokensLine>& result,
        const Location& in_location);

    std::vector<TokensLine> expand_macros(const std::vector<TokensLine>& lines);
};

