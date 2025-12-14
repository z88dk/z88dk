//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "location.h"
#include <string>
#include <vector>
#include <unordered_map>

extern size_t g_unique_id_counter; // to create unique local names

//-----------------------------------------------------------------------------
// Macro
//-----------------------------------------------------------------------------

class Macro {
public:
    Macro(const std::string& name, const Location& location);

    const std::string& name() const;
    const Location& location() const;

    bool is_function_like() const;
    void set_function_like(bool f);

    const std::vector<std::string>& parameters() const;
    void add_parameter(const std::string& param);

    const std::vector<std::string>& locals() const;
    void add_local(const std::string& local);

    const std::vector<TokenLine>& body_lines() const;
    std::vector<TokenLine>& body_lines();
    void add_body_line(const TokenLine& line);
    void add_body_line(const TokenLine& line, size_t i);

    bool parse_parameters(const TokenLine& line, size_t& index);
    bool parse_locals(const TokenLine& line, size_t& index);
    bool parse_arguments(const TokenLine& line, size_t& index, std::vector<TokenLine>& out_arguments);
    bool parse_body_line(const TokenLine& line);

    void expand(const Location& location, const std::vector<TokenLine>& arguments, std::vector<TokenLine>& out_lines);
    TokenLine expand_flat(const Location& location, const std::vector<TokenLine>& arguments);

    // Recursion counter API
    size_t recursion_count() const {
        return recursion_count_;
    }
    void increment_recursion() {
        ++recursion_count_;
    }
    void decrement_recursion() {
        if (recursion_count_ > 0) {
            --recursion_count_;
        }
    }

    // New: expand with both expanded and raw (unexpanded) arguments to support stringize `#`
    void expand_with_raw(const Location& location,
                         const std::vector<TokenLine>& expanded_args,
                         const std::vector<TokenLine>& raw_args,
                         std::vector<TokenLine>& out_lines);

private:
    std::string name_;
    Location location_;
    bool is_function_like_ = false;

    std::vector<std::string> parameters_;
    std::vector<std::string> locals_;
    std::vector<TokenLine> body_lines_;

    int nesting_level_ = 1; // start at 1 because MACRO was already parsed

    // Per-macro recursion counter (non-thread-safe; assembler is single-threaded)
    size_t recursion_count_ = 0;
};

//-----------------------------------------------------------------------------
// Macros container
//-----------------------------------------------------------------------------

class Macros {
public:
    bool has_macro(const std::string& name) const;
    Macro* get_macro(const std::string& name);
    const Macro* get_macro(const std::string& name) const;

    void add_macro(const Macro& macro);
    void replace_macro(const Macro& macro);
    void remove_macro(const std::string& name);
    void clear();

    bool expand(const TokenLine& line, std::vector<TokenLine>& out_lines);
    bool expand(const TokenLine& line, size_t i, std::vector<TokenLine>& out_lines);

    bool expand_once(const TokenLine& line, std::vector<TokenLine>& out_lines);
    bool expand_once(const TokenLine& line, size_t i, std::vector<TokenLine>& out_lines);

    TokenLine expand_flat(const TokenLine& line);
    TokenLine expand_flat(const TokenLine& line, size_t i);

    const std::string& last_expanded_macro() const;

private:
    std::unordered_map<std::string, Macro> macros_;
    std::string last_expanded_macro_;

    TokenLine flatten(const Location& location, const std::vector<TokenLine>& lines);
};

//-----------------------------------------------------------------------------
// REPT* block
//-----------------------------------------------------------------------------

class RepeatBlock {
public:
    enum class Type { Count, Iterate, Chars };
    RepeatBlock(Type type, const Location& location);
    const Location& location() const;

    void add_body_line(const TokenLine& line);
    bool parse_body_line(const TokenLine& line);

    virtual bool expand(const Location& location, std::vector<TokenLine>& out_lines) = 0;

protected:
    Type type_;
    Macro macro_; // to reuse parameter/local handling
    int nesting_level_ = 1; // start at 1 because REPT was already parsed
};

class RepeatCountBlock : public RepeatBlock {
public:
    RepeatCountBlock(const Location& location, size_t count);
    size_t count() const;

    bool expand(const Location& location, std::vector<TokenLine>& out_lines) override;

protected:
    size_t count_;
};

class RepeatIterateBlock : public RepeatBlock {
public:
    RepeatIterateBlock(const Location& location, const std::string& variable);
    const std::string& variable() const;
    const std::vector<TokenLine>& items() const;
    std::vector<TokenLine>& items();

    virtual bool parse_items(const TokenLine& line, size_t& index);
    bool expand(const Location& location, std::vector<TokenLine>& out_lines) override;

protected:
    std::vector<TokenLine> items_;
};

class RepeatCharsBlock : public RepeatIterateBlock {
public:
    RepeatCharsBlock(const Location& location, const std::string& variable);
    bool parse_chars(const TokenLine& line, size_t& index);

private:
    bool parse_items(const TokenLine& line, size_t& index) override;
};
