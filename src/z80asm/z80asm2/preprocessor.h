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

    // Push a TokensFile constructed from a file.
    void push_file(const std::string& filename);

    // Push a TokensFile constructed from a string (virtual file).
    void push_virtual_file(const std::string& content,
                           const std::string& filename,
                           int first_line_num = 1);

    // Pop and return the next processed TokensLine.
    bool next_line(TokensLine& out_line);

    // Register a simple macro replacement (no parameters). Replacement may be
    // one or more TokensLine objects (multi-line macro).
    void define_macro(const std::string& name,
                      const std::vector<TokensLine>& replacement);

    // Clear all state (stack, macros, recursion counters)
    void clear();

private:
    static const inline int MAX_MACRO_RECURSION = 32;

    struct Macro {
        std::vector<TokensLine> replacement; // replacement token lines
        std::vector<std::string> params;     // parameter names (empty => object-like)
        bool is_function = false;
    };

    struct File {
        TokensFile tokens_file;
        int line_index = 0;
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

    // Internal helpers
    void expect_end(const TokensLine& line, int i) const;
    void skip_spaces(const TokensLine& line, int& i) const;
    bool is_directive(const TokensLine& line, int& i, Keyword& keyword) const;
    bool is_name_directive(const TokensLine& line, int& i,
                           Keyword& keyword, std::string& name) const;
    void process_directive(const TokensLine& line, int& i, Keyword keyword);
    void process_name_directive(const TokensLine& line, int& i,
                                Keyword keyword, const std::string& name);
    void process_include(const TokensLine& line, int& i);
    void split_lines(const Location& location,
                     const std::vector<TokensLine>& expanded);
    void split_line(const Location& location, const TokensLine& expanded);
    void split_label(const Location& location,
                     const TokensLine& expanded, int& i);
    std::vector<TokensLine> expand_macros(const std::vector<TokensLine>& lines);
};

