//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string>
#include <vector>

class Token;

// macro tokens
enum class MacroTokenType {
    Identifier,
    Number,
    StringLiteral,
    Operator,
    Punctuator,
};

struct MacroToken {
    MacroTokenType type;
    std::string text;
};

// tokenize the macro body into a list of MacroToken
std::vector<MacroToken> tokenize_macro_body(const std::string& body);

// Scanning functions for null-terminated strings (C-style)
// Each function advances 'p' if successful, returns true and sets 'out'.
// If not successful, 'p' is unchanged and returns false.

// Scan one or more whitespace characters (space, tab, etc.)
// Advances 'p' past the whitespace, returns true if at least one was found, false otherwise.
bool scan_whitespace(const char*& p);
void skip_whitespace(const char*& p);

// Scan a C identifier: [_a-zA-Z][_a-zA-Z0-9]*
bool scan_identifier(const char*& p, std::string& out);

// Scan an assemnbler label:
// '@' identifier (local label, refers to previous non-local label)
// identifier '@' identifier (local label fully qualified)
bool scan_label(const char*& p, std::string& out);

// Scan an integer literal (decimal, hex with 0x/0X, binary with 0b/0B, octal with 0 prefix)
bool scan_integer(const char*& p, int& out);

// Scan a floating-point literal (C-style)
bool scan_float(const char*& p, double& out);

// Scan a string literal (C-style, double quotes, supports escapes)
bool scan_string_literal(const char*& p, std::string& out);
std::string unescape_string(const std::string& str);

// Scan an operator or punctuator (e.g., "+", "-", "==", "&&", etc.)
bool scan_operator(const char*& p, std::string& out);

class Lexer {
public:
    Lexer();
    void reset(const std::string& input);
    Token next_token();
};

