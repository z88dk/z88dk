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
#include <memory>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <ctime>

class Preprocessor {
public:
    Preprocessor() = default;

    // Clear all state (stack, macros, recursion counters)
    void clear();

    // Clear the global file cache
    static void clear_file_cache();

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

    // Dependency collection API
    // Returns the list of files that were pushed via push_file/push_binary_file,
    // in the order they were recorded (duplicates preserved).
    const std::vector<std::string>& dependency_filenames() const;

    // Clears the collected dependency filenames.
    void clear_dependencies();

    // preprocess one file and generate dependency information
    static void preprocess_file(
        const std::string& input_filename,
        const std::string& output_filename,
        bool gen_dependency);

    void generate_dependency_file();

private:
    static const inline int MAX_MACRO_RECURSION = 32;

    struct Macro {
        std::vector<TokensLine> replacement; // replacement token lines
        std::vector<std::string> params;     // parameter names
        std::vector<std::string> locals;     // LOCAL names declared in macro body
        // true if definition had params or used empty ()
        bool is_function_like = false;
        // recursion depth counter per macro (avoid global map lookups)
        int recursion_depth = 0;
    };

    // Cache entry for a file
    struct CachedFile {
        std::shared_ptr<TokensFile> tokens_file;
        std::time_t mod_time = 0;
    };

    struct File {
        // Pointer to cached or virtual file
        std::shared_ptr<TokensFile> tokens_file;
        unsigned line_index = 0;

        // Queue of split lines
        std::deque<TokensLine> split_queue_;

        // Optional forced logical location (from LINE/C_LINE)
        bool has_forced_location = false;
        unsigned forced_at_line_num = 0;
        int forced_start_line_num = 0;
        std::string forced_filename;
        bool forced_constant_line_numbers = false;

        // True when this file represents an expanded macro "virtual file".
        bool is_macro_expansion = false;
        bool exitm_found = false;
    };

    struct IfFrame {
        bool branch_active = false; // whether this level currently includes text
        bool any_taken = false;     // whether any previous branch in this chain matched
        bool seen_else = false;     // whether ELSE already occurred
    };

    // Global file cache (static, shared across all Preprocessor instances)
    static std::unordered_map<std::string, CachedFile> file_cache_;

    // Queue of tokenized lines waiting to be processed/consumed.
    std::deque<TokensLine> input_queue_;

    // Stack of source files currently open.
    std::vector<File> file_stack_;

    // Macro table
    std::unordered_map<std::string, Macro> macros_;

    // Counter for LOCAL renaming.
    unsigned local_id_counter_ = 0;

    // When true, a directive is being processed from input_queue_ (not from file_stack_).
    bool reading_queue_for_directive_ = false;

    // Conditional inclusion stack
    std::vector<IfFrame> if_stack_;

    // Makefile dependency collection (order-preserving, duplicates allowed)
    std::vector<std::string> dep_files_;

    // Set of absolute paths this Preprocessor instance has already included.
    std::unordered_set<std::string> included_once_;


    // Fetch a line from the input file, or file_input_queue_ if not empty.
    bool fetch_line(TokensLine& out);
    Location compute_location(const File& file, const TokensLine& out);

    // collect segments from the input file
    void collect_guard_segments(File& file, TokensLine& line,
                                unsigned& line_index, std::vector<TokensLine>& segments);

    // Pre-split a raw physical line into colon or backslahs-separated segments
    // Returns true if the line was split and segments were produced.
    bool split_line(const TokensLine& line,
                    std::vector<TokensLine>& out_segments);
    bool split_label(const Location& location,
                     const TokensLine& line, unsigned& i,
                     std::vector<TokensLine>& out_segments);

    // Fetch a raw next logical line for MACRO/REPT bodies.
    bool fetch_line_for_macro_body(TokensLine& out);
    bool collect_macro_body(std::vector<TokensLine>& out_body,
                            std::vector<std::string>& out_locals,
                            Keyword start_keyword, Keyword end_keyword);
    // Helper to get or create a cached file
    std::shared_ptr<TokensFile> get_cached_file(const std::string&
            normalized_filename);

    // Helpers
    void expect_end(const TokensLine& line, unsigned i) const;
    bool parse_params_list(const TokensLine& line, unsigned& i,
                           std::vector<std::string>& out_params) const;
    bool parse_macro_args(const TokensLine& line, unsigned& i,
                          std::vector<TokensLine>& out_args);
    bool parse_line_args(const TokensLine& line, unsigned& i,
                         int& out_linenum, std::string& out_filename,
                         Keyword keyword) const;
    bool parse_filename(const TokensLine& line, unsigned& i,
                        std::string& out_filename, bool& out_is_angle) const;
    bool parse_identifier(const TokensLine& line, unsigned& i,
                          std::string& out_name) const;
    bool parse_keyword(const TokensLine& line, unsigned& i,
                       Keyword& out_keyword) const;
    TokensLine collect_tokens(const TokensLine& line, unsigned& i);
    // try to evaluate constant expression with the rest of the line
    bool eval_const_expr(const TokensLine& expr_tokens, int& out_value,
                         bool silent);
    bool eval_if_expr(const TokensLine& line, unsigned& i,
                      Keyword keyword);
    bool eval_ifdef_name(const TokensLine& line, unsigned& i,
                         bool negated, Keyword keyword);

    // parse directives
    bool output_active() const;
    bool is_directive(const TokensLine& line, unsigned& i,
                      Keyword& keyword) const;
    bool is_name_directive(const TokensLine& line, unsigned& i,
                           Keyword& keyword, std::string& name) const;
    void process_directive(const TokensLine& line, unsigned& i,
                           Keyword keyword);
    void process_name_directive(const TokensLine& line, unsigned& i,
                                Keyword keyword, const std::string& name);
    void process_contitional_directive(const TokensLine& line,
                                       unsigned& i,
                                       Keyword keyword);

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

    // EQU / name EQU (includes DEFC synonym)
    void process_equ(const TokensLine& line, unsigned& i);
    void process_name_equ(const TokensLine& line, unsigned& i,
                          const std::string& name);

    // UNDEF / UNDEFINE
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

    // IF / ELIF / ELSE / ENDIF
    void process_if(const TokensLine& line, unsigned& i);
    void process_elif(const TokensLine& line, unsigned& i);
    void process_else(const TokensLine& line, unsigned& i);
    void process_endif(const TokensLine& line, unsigned& i);

    // IFDEF / IFNDEF / ELIFDEF / ELIFNDEF
    void process_ifdef(const TokensLine& line, unsigned& i,
                       bool negated);
    void process_elifdef(const TokensLine& line, unsigned& i,
                         bool negated);

    // EXITM
    void process_exitm(const TokensLine& line, unsigned& i);
    void do_exitm();

    // LOCAL
    void process_local(const TokensLine& line, unsigned& i,
                       std::vector<std::string>& out_locals);

    // PRAGMA
    void process_pragma(const TokensLine& line, unsigned& i);

    // Macro expansion and line splitting
    // Replace string tokens by comma-separated integers.
    // Returns true if any change was made; the (possibly) transformed line is written to 'out'.
    bool post_process_line(const TokensLine& line, TokensLine& out);
    void add_virtual_file(std::vector<TokensLine> expanded);
    bool merge_double_hash(const TokensLine& line, TokensLine& out);

    // expand_macros helpers
    bool is_macro_call(
        const TokensLine& in_line, unsigned idx,
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
    bool substitute_and_expand(
        Macro& macro,
        const std::vector<std::vector<TokensLine>>& expanded_args_flat,
        const std::vector<TokensLine>& original_args,
        std::vector<TokensLine>& out_expanded);
    void append_expansion_into_out(
        const std::vector<TokensLine>& further_expanded,
        TokensLine& out,
        std::vector<TokensLine>& result,
        const Location& in_location);

    // Expand macros in a single line. Returns true if any macro expansion
    // or token-paste changed the input. Result lines placed in 'out'.
    bool expand_macros(const TokensLine& line, bool at_start,
                       std::vector<TokensLine>& out);
    // Expand macros in multiple lines. Returns true if any change occurred.
    bool expand_macros(const std::vector<TokensLine>& lines, bool at_start,
                       std::vector<TokensLine>& out);
    TokensLine expand_macros_in_line(const TokensLine& line);

    // #ifndef/#define detector
    bool detect_ifndef_guard(File& file, std::string& out_symbol);
};

// called when command line -E is given
void preprocess_only();
