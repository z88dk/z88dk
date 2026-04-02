//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

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
    // Returns the list of files that were pushed via push_file,
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

    // current single-line expansion chain
    int macro_fixpoint_iterations_ = 0;
    ExpansionChain current_line_chain_;

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
    bool is_name_directive(const TokenLine& line, size_t& i, Keyword& keyword, std::string& name) const;
    void expect_end(const TokenLine& line, size_t i) const;
    bool parse_identifier(const TokenLine& line, size_t& i, std::string& out_name) const;
    bool parse_keyword(const TokenLine& line, size_t& i, Keyword& out_keyword) const;
    bool eval_const_expr(const TokenLine& line, size_t& i, int& out_value);

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
};

// called when command line -E is given
void preprocess_only();
