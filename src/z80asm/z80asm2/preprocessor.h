//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla.h"
#include "keywords.h"
#include "lexer.h"
#include "macros.h"
#include "module.h"
#include "symbols.h"
#include <ctime>
#include <deque>
#include <memory>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

class Preprocessor {
public:
    Preprocessor();

    // Clear all state (stack, macros)
    void clear();

    // Push a TokenFileReader constructed from a file.
    void push_file(const std::string& filename);

    // Push a TokenFileReader constructed from a string (virtual file).
    void push_virtual_file(const std::string& content,
                           const std::string& filename,
                           int first_line_num, bool fixed_line_nums);

    // Push a TokenFileReader constructed directly from tokenized lines (no re-tokenization).
    void push_virtual_file(const std::vector<TokenLine>& tok_lines);

    // Push a virtual file constructed from a binary file.
    void push_binary_file(const std::string& bin_filename,
                          const Location& location);

    // Register a simple macro replacement (no parameters). Replacement may be
    // one or more TokenLine objects (multi-line macro).
    void define_macro(const std::string& name,
                      const Location& location,
                      const std::string replacement);

    void define_macro(const std::string& name,
                      const Location& location,
                      const std::vector<TokenLine>& replacement);

    // Return the next preprocessed line
    bool next_line(TokenLine& out_line);

    // Dependency collection API
    // Returns the list of files that were pushed via push_file/push_binary_file,
    // in the order they were recorded (duplicates preserved).
    const std::vector<std::string>& dependency_filenames() const;

    void generate_dependency_file();

    // preprocess one file and generate dependency information
    static void preprocess_file(
        const std::string& input_filename,
        const std::string& output_filename,
        bool gen_dependency);

private:
    // limit total single-pass iterations for one physical line
    static constexpr int MAX_FIXPOINT_ITERATIONS = 256;

    struct File {
        // Token file reader for this file
        TokenFileReader tf_reader;

        // Optional forced logical location (from LINE/C_LINE)
        bool has_forced_location = false;
        size_t forced_at_line_num = 0;
        size_t forced_start_line_num = 0;
        std::string forced_filename;
        bool forced_constant_line_numbers = false;

        // remembers raw physical line number of the most recently fetched line
        size_t last_physical_line_num = 0;

        // True when this file represents an expanded macro "virtual file".
        bool is_macro_expansion = false;
        bool exitm_found = false;
        bool is_virtual_file = false;
    };

    struct IfFrame {
        Location location;          // location of the IF/ELIF/ELSE
        bool branch_active = false; // whether this level currently includes text
        bool any_taken = false;     // whether any previous branch in this chain matched
        bool seen_else = false;     // whether ELSE already occurred
    };

    // tracking single-line expansion chain (for recursion detection)
    struct ExpansionChain {
        // sequence of macro names expanded (object-like single-token expansions)
        std::vector<std::string> names;
        void reset() {
            names.clear();
        }
        void add(const std::string& n) {
            names.push_back(n);
        }
        bool has_cycle(const std::string& n) const {
            for (const auto& x : names) if (x == n) {
                    return true;
                }
            return false;
        }
    };

    // Queue of tokenized lines waiting to be processed/consumed.
    std::deque<TokenLine> input_queue_;

    // Stack of source files currently open.
    std::vector<File> file_stack_;

    // Macro table
    Macros macros_;

    // When true, a directive is being processed from input_queue_ (not from file_stack_).
    bool reading_queue_for_directive_ = false;

    // Conditional inclusion stack
    std::vector<IfFrame> if_stack_;

    // Makefile dependency collection
    DependencyFile dependency_file_;

    // Set of absolute paths this Preprocessor instance has already included.
    std::unordered_set<std::string> included_once_;

    // current single-line expansion chain
    int macro_fixpoint_iterations_ = 0;
    ExpansionChain current_line_chain_;

    // current High-Level-Assembly context (for HLA directives)
    HLA hla_context_;

    // module containing symbol table to hold DEFC identifiers parsed in preprocessor
    Module module_;

    //--- Internal methods ---

    // Pop and return the next processed TokenLine, to be used by HLA
    friend class HLA;
    bool pp_next_line(TokenLine& out_line);

    // Fetch a line from the input file, or file_input_queue_ if not empty.
    bool fetch_line(TokenLine& out);
    Location compute_location(const File& file, const TokenLine& out);

    // replace strings by integer lists
    bool post_process_line(const TokenLine& line, TokenLine& out);

    // update symtab from an assembly instruction
    void update_symtab(const TokenLine& line);

    // handle directives for a line (both queued and fetched paths)
    // Returns true if the line was fully handled (consumed) and the caller
    // should continue the loop.
    // Returns false if no directive/name-directive consumed the line, so the caller
    // should: for queued lines -> emit the line; for fetched lines -> expand macros and emit.
    bool handle_directives_for_line(TokenLine& line, bool reading_from_queue);

    // parse directives
    bool output_active() const;
    bool is_directive(const TokenLine& line, size_t& i, Keyword& keyword) const;
    bool is_name_directive(const TokenLine& line, size_t& i, Keyword& keyword, std::string& name) const;
    void process_directive(const TokenLine& line, size_t& i, Keyword keyword);
    void process_name_directive(const TokenLine& line, size_t& i, Keyword keyword, const std::string& name);
    void expect_end(const TokenLine& line, size_t i) const;
    bool parse_identifier(const TokenLine& line, size_t& i, std::string& out_name) const;
    bool parse_keyword(const TokenLine& line, size_t& i, Keyword& out_keyword) const;

    // INCLUDE
    void process_INCLUDE(const TokenLine& line, size_t& i);
    void do_INCLUDE(const std::string& filename, bool is_angle);
    std::string search_include_path(const std::string& filename,
                                    bool is_angle) const;
    bool parse_filename(const TokenLine& line, size_t& i,
                        std::string& out_filename, bool& out_is_angle) const;

    // BINARY / INCBIN
    void process_BINARY(const TokenLine& line, size_t& i);
    void process_INCBIN(const TokenLine& line, size_t& i);
    void do_BINARY(const std::string& filename, bool is_angle,
                   const Location& location);

    // LINE / C_LINE
    void process_LINE(const TokenLine& line, size_t& i);
    void process_C_LINE(const TokenLine& line, size_t& i);
    bool parse_LINE_args(const TokenLine& line, size_t& i,
                         size_t& out_linenum, std::string& out_filename,
                         Keyword keyword) const;

    // DEFINE
    void process_DEFINE(const TokenLine& line, size_t& i);
    void process_name_DEFINE(const TokenLine& line, size_t& i,
                             const std::string& name);
    void do_DEFINE(const TokenLine& line, size_t& i, Macro& macro);

    // EQU / name EQU (includes DEFC synonym)
    void process_EQU(const TokenLine& line, size_t& i);
    void process_name_EQU(const TokenLine& line, size_t& i,
                          const std::string& name);
    void process_name_DEFC(const TokenLine& line, size_t& i,
                           const std::string& name);
    void do_EQU(const TokenLine& line, size_t& i, const std::string& name);

    // UNDEF / UNDEFINE
    void process_UNDEF(const TokenLine& line, size_t& i);
    void process_UNDEFINE(const TokenLine& line, size_t& i);
    void process_name_UNDEF(const TokenLine& line, size_t& i,
                            const std::string& name);
    void process_name_UNDEFINE(const TokenLine& line, size_t& i,
                               const std::string& name);
    void do_UNDEF(const std::string& name, const TokenLine& line, size_t& i);

    // DEFL
    void process_DEFL(const TokenLine& line, size_t& i);
    void process_name_DEFL(const TokenLine& line, size_t& i, const std::string& name);
    void do_DEFL(const TokenLine& line, size_t& i, const std::string& name);

    // MACRO
    void process_MACRO(const TokenLine& line, size_t& i);
    void process_ENDM(const TokenLine& line, size_t& i);
    void process_name_MACRO(const TokenLine& line, size_t& i, const std::string& name);
    void do_MACRO(const TokenLine& line, size_t& i, const std::string& name);

    // REPT / REPTC / REPTI
    void process_REPT(const TokenLine& line, size_t& i);
    void process_ENDR(const TokenLine& line, size_t& i);
    void process_REPTC(const TokenLine& line, size_t& i);
    void process_name_REPTC(const TokenLine& line, size_t& i, const std::string& var_name);
    void do_REPTC(bool ok, const std::string& var_name, const TokenLine& line, size_t& i);
    void process_REPTI(const TokenLine& line, size_t& i);
    void process_name_REPTI(const TokenLine& line, size_t& i, const std::string& var_name);
    void do_REPTI(bool ok, const std::string& var_name, const TokenLine& line, size_t& i);
    bool collect_rept_body(const Location& location, RepeatBlock* block, Keyword keyword);
    bool fetch_line_for_macro_body(TokenLine& out);
    bool eval_const_expr(const TokenLine& line, size_t& i, int& out_value);

    // IF / ELIF / ELSE / ENDIF
    void process_IF(const TokenLine& line, size_t& i);
    void process_ELIF(const TokenLine& line, size_t& i);
    void process_ELSEIF(const TokenLine& line, size_t& i);
    void process_ELSE(const TokenLine& line, size_t& i);
    void process_ENDIF(const TokenLine& line, size_t& i);
    bool eval_if_expr(const TokenLine& line, size_t& i, Keyword keyword);

    // IFDEF / IFNDEF / ELIFDEF / ELIFNDEF
    void process_IFDEF(const TokenLine& line, size_t& i);
    void process_IFNDEF(const TokenLine& line, size_t& i);
    void process_ifdef_ifndef(const TokenLine& line, size_t& i, bool negated);
    void process_ELIFDEF(const TokenLine& line, size_t& i);
    void process_ELSEIFDEF(const TokenLine& line, size_t& i);
    void process_ELIFNDEF(const TokenLine& line, size_t& i);
    void process_ELSEIFNDEF(const TokenLine& line, size_t& i);
    void process_elifdef_elifndef(const TokenLine& line, size_t& i, bool negated);
    bool eval_ifdef_name(const TokenLine& line, size_t& i, bool negated, Keyword keyword);

    // EXITM
    void process_EXITM(const TokenLine& line, size_t& i);
    void do_EXITM();

    // LOCAL
    void process_LOCAL(const TokenLine& line, size_t& i);

    // PRAGMA
    void process_PRAGMA(const TokenLine& line, size_t& i);

    // ASSERT
    void process_ASSERT(const TokenLine& line, size_t& i);

    // Get the module/section maintained in the preprocessor
#ifdef UNIT_TESTS
public:
#endif
    Module* pp_module();    // only public for unit tests
    Section* pp_current_section();
private:

    // tables of actions for directives
    using Action = void (Preprocessor::*)(const TokenLine& line, size_t& i);
    using ActionName = void (Preprocessor::*)(
                           const TokenLine& line, size_t& i, const std::string& name);

    static const Action preproc_directive_actions[];
    static const ActionName preproc_name_directive_actions[];
};

// called when command line -E is given
void preprocess_only();
