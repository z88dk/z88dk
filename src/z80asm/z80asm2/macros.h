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
    void add_body_line(const TokenLine& line);

    bool parse_parameters(const TokenLine& line, size_t& index);
    bool parse_locals(const TokenLine& line, size_t& index);
    bool parse_arguments(const TokenLine& line, size_t& index,
                         std::vector<TokenLine>& out_arguments);
    bool parse_body_line(const TokenLine& line);

    void expand(const Location& location, const std::vector<TokenLine>& arguments,
                std::vector<TokenLine>& out_lines);
    TokenLine expand_flat(const Location& location, const std::vector<TokenLine>& arguments);

private:
    std::string name_;
    Location location_;
    bool is_function_like_ = false;
    std::vector<std::string> parameters_;
    std::vector<std::string> locals_;
    std::vector<TokenLine> body_lines_;
    int nesting_level_ = 1; // start at 1 because MACRO was already parsed
};

//-----------------------------------------------------------------------------
// Macros container
//-----------------------------------------------------------------------------

class Macros {
public:
    Macros() = default;
    bool has_macro(const std::string& name) const;
    Macro* get_macro(const std::string& name);
    const Macro* get_macro(const std::string& name) const;
    void add_macro(const Macro& macro);
    void clear();

    bool expand(const TokenLine& line, std::vector<TokenLine>& out_lines);
    TokenLine expand_flat(const TokenLine& line);

private:
    std::unordered_map<std::string, Macro> macros_;
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
