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
                           int first_line_num, bool inc_line_nums);

    // Push a TokensFile constructed directly from tokenized lines (no re-tokenization).
    void push_virtual_file(const std::vector<TokensLine>& tok_lines,
                           const std::string& filename,
                           int first_line_num, bool inc_line_nums);

    // Push a virtual file constructed from a binary file.
    void push_binary_file(const std::string& bin_filename,
                          const Location& location);

    // Pop and return the next processed TokensLine.
    bool next_line(TokensLine& out_line);

    // Register a simple macro replacement (no parameters). Replacement may be
    // one or more TokensLine objects (multi-line macro).
    void define_macro(const std::string& name,
                      const std::string replacement);

    void define_macro(const std::string& name,
                      const std::vector<TokensLine>& replacement);

private:
    static const inline int MAX_MACRO_RECURSION = 32;

    struct Macro {
        std::vector<TokensLine> replacement; // replacement token lines
        std::vector<std::string> params;     // parameter names
        std::vector<std::string> locals;     // LOCAL names declared in macro body
        bool is_function_like =
            false;       // true if definition had params or used empty ()
        bool is_multi_line() const {
            return replacement.size() > 1;
        }
    };

    struct File {
        TokensFile tokens_file;
        unsigned line_index = 0;

        // Optional forced logical location (from LINE/C_LINE)
        bool has_forced_location = false;
        unsigned forced_at_line_num = 0;
        int forced_start_line_num = 0;
        std::string forced_filename;
        bool forced_constant_line_numbers = false;

        // True when this file represents an expanded macro "virtual file".
        bool is_macro_expansion = false;
    };

    // Queue of tokenized lines waiting to be processed/consumed.
    std::deque<TokensLine> input_queue_;

    // Stack of source files currently open (keeps ownership of TokensFile objects).
    std::vector<File> file_stack_;

    // Macro table
    std::unordered_map<std::string, Macro> macros_;

    // Track macro expansion recursion depth per macro name (to avoid infinite recursion).
    std::unordered_map<std::string, int> macro_recursion_count_;

    // Global counter used to produce unique names for LOCAL symbols on each macro expansion.
    unsigned local_id_counter_ = 0;

    // When true, a directive is being processed from input_queue_ (not from file_stack_).
    // Used so MACRO can read its body from the queue produced by macro expansion.
    bool reading_queue_for_directive_ = false;

    // Fetch a raw next logical line for MACRO body parsing, from the proper source:
    // - input_queue_ when reading_queue_for_directive_ is true
    // - file_stack_ otherwise (and applies forced location if needed).
    bool fetch_line_for_macro_body(TokensLine& out);

    // Internal helpers
    void expect_end(const TokensLine& line, unsigned i) const;
    bool parse_params_list(const TokensLine& line, unsigned& i,
                           std::vector<std::string>& out_params) const;
    bool parse_macro_args(const TokensLine& line, unsigned& i,
                          std::vector<TokensLine>& out_args);
    bool parse_line_args(const TokensLine& line, unsigned& i,
                         int& out_linenum, std::string& out_filename,
                         const char* directive_name) const;
    bool parse_filename(const TokensLine& line, unsigned& i,
                        std::string& out_filename, bool& out_is_angle) const;
    bool parse_identifier(const TokensLine& line, unsigned& i,
                          std::string& out_name) const;
    bool parse_keyword(const TokensLine& line, unsigned& i,
                       Keyword& out_keyword) const;
    TokensLine collect_tokens(const TokensLine& line, unsigned& i);

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
    std::string search_include_path(const std::string& filename,
                                    bool is_angle) const;

    // BINARY / INCBIN
    void process_binary(const TokensLine& line, unsigned& i);
    void do_binary(const std::string& filename, bool is_angle,
                   const Location& location);

    // LINE / C_LINE
    void process_line(const TokensLine& line, unsigned& i);
    void process_c_line(const TokensLine& line, unsigned& i);

    // DEFINE
    void process_define(const TokensLine& line, unsigned& i);
    void process_name_define(const TokensLine& line, unsigned& i,
                             const std::string& name);
    void do_define(const TokensLine& line, unsigned& i,
                   const std::string& name,
                   const std::vector<std::string>& params,
                   bool had_func_parens);

    // UNDEFINE / UNDEF
    void process_undef(const TokensLine& line, unsigned& i);
    void process_name_undef(const TokensLine& line, unsigned& i,
                            const std::string& name);
    void do_undef(const std::string& name, const TokensLine& line, unsigned& i);

    // DEFL
    void process_defl(const TokensLine& line, unsigned& i);
    void process_name_defl(const TokensLine& line, unsigned& i,
                           const std::string& name);
    void do_defl(const TokensLine& line, unsigned& i,
                 const std::string& name);

    // MACRO
    void process_macro(const TokensLine& line, unsigned& i);
    void process_name_macro(const TokensLine& line, unsigned& i,
                            const std::string& name);
    void do_macro(const TokensLine& line, unsigned& i,
                  const std::string& name);

    // REPT / REPTC / REPTI
    void process_rept(const TokensLine& line, unsigned& i);
    void process_reptc(const TokensLine& line, unsigned& i);
    void process_name_reptc(const TokensLine& line, unsigned& i,
                            const std::string& var_name);
    void do_reptc(const std::string& var_name,
                  const TokensLine& arg_line,
                  const TokensLine& directive_line);

    void process_repti(const TokensLine& line, unsigned& i);
    void process_name_repti(const TokensLine& line, unsigned& i,
                            const std::string& var_name);
    void do_repti(const std::string& var_name,
                  const std::vector<TokensLine>& arg_list,
                  const TokensLine& directive_line);

    // EXITM
    void process_exitm(const TokensLine& line, unsigned& i);
    void do_exitm();

    // LOCAL
    void process_local(const TokensLine& line, unsigned& i,
                       std::vector<std::string>& out_locals);

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
        std::vector<std::vector<TokensLine>>& expanded_args_flat,
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
        const std::vector<std::vector<TokensLine>>& expanded_args_flat,
        const std::vector<TokensLine>& original_args,
        const std::string& name);
    void append_expansion_into_out(
        const std::vector<TokensLine>& further_expanded,
        TokensLine& out,
        std::vector<TokensLine>& result,
        const Location& in_location);

    std::vector<TokensLine> expand_macros(const TokensLine& line);
    std::vector<TokensLine> expand_macros(const std::vector<TokensLine>& lines);
    TokensLine expand_macros_in_line(const TokensLine& line);
};


