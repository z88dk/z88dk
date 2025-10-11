//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "token.h"
#include <algorithm>
#include <cctype>
#include <iostream>
#include <sstream>
#include <unordered_map>

std::string to_upper(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    return result;
}

std::string ltrim(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\r\n");
    return (start == std::string::npos) ? "" : s.substr(start);
}

std::string rtrim(const std::string& s) {
    size_t end = s.find_last_not_of(" \t\r\n");
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}

#define X(id, text) { text, Keyword::id },
Keyword to_keyword(const std::string& s) {
    static const std::unordered_map<std::string, Keyword> keyword_map = {
#include "keywords.def"
    };
    auto it = keyword_map.find(to_upper(s));
    return it != keyword_map.end() ? it->second : Keyword::None;
}
#undef X

bool scan_identifier(std::istream& is, std::string& out) {
    out.clear();

    // Skip whitespace
    while (is && std::isspace(is.peek())) {
        is.get();
    }

    // First character: must be alpha or underscore
    if (!is || (!std::isalpha(is.peek()) && is.peek() != '_')) {
        return false;
    }

    out += static_cast<char>(is.get());

    // Subsequent characters: alnum or underscore
    while (is && (std::isalnum(is.peek()) || is.peek() == '_')) {
        out += static_cast<char>(is.get());
    }

    // if next character is a "'" and a keyword with that quote exists, e.g. AF'
    // include the quote in the identifier
    if (is && is.peek() == '\'') {
        std::string test = out + "'";
        if (to_keyword(test) != Keyword::None) {
            out += static_cast<char>(is.get());
        }
    }

    return true;
}

std::vector<MacroToken> tokenize_macro_body(const std::string& body) {
    std::vector<MacroToken> tokens;
    std::istringstream is(body);

    while (is) {
        // Skip whitespace
        if (is && std::isspace(is.peek())) {
            tokens.push_back({ MacroTokenType::Punctuator, " " });
            while (is && std::isspace(is.peek())) {
                is.get();
            }
            continue;
        }

        if (!is) {
            break;
        }

        // Identifier
        std::string ident;
        if (scan_identifier(is, ident)) {
            tokens.push_back({ MacroTokenType::Identifier, ident });
            continue;
        }

        // Number
        if (std::isdigit(is.peek())) {
            std::string num;
            while (is && std::isdigit(is.peek())) {
                num += static_cast<char>(is.get());
            }
            tokens.push_back({ MacroTokenType::Number, num });
            continue;
        }

        // String literal
        if (is.peek() == '"') {
            std::string str;
            str += static_cast<char>(is.get());
            while (is && is.peek() != EOF) {
                char c = static_cast<char>(is.get());
                str += c;
                if (c == '\\' && is.peek() != EOF) {
                    str += static_cast<char>(is.get());
                }
                else if (c == '"') {
                    break;
                }
            }
            tokens.push_back({ MacroTokenType::StringLiteral, str });
            continue;
        }

        // Char literal
        if (is.peek() == '\'') {
            std::string str;
            str += static_cast<char>(is.get());
            while (is && is.peek() != EOF) {
                char c = static_cast<char>(is.get());
                str += c;
                if (c == '\\' && is.peek() != EOF) {
                    str += static_cast<char>(is.get());
                }
                else if (c == '\'') {
                    break;
                }
            }
            tokens.push_back({ MacroTokenType::CharLiteral, str });
            continue;
        }

        // Operators and punctuators (handle ## and # specially)
        if (is.peek() == '#') {
            is.get();
            if (is.peek() == '#') {
                is.get();
                tokens.push_back({ MacroTokenType::Operator, "##" });
            }
            else {
                tokens.push_back({ MacroTokenType::Operator, "#" });
            }
            continue;
        }

        // Single-character punctuators/operators
        char c = static_cast<char>(is.get());
        if (is) {
            tokens.push_back({ MacroTokenType::Punctuator, std::string(1, c) });
        }
    }

    return tokens;
}

Lexer::Lexer() {
    // Stub: to be implemented
}

void Lexer::reset(const std::string& /*input*/) {
    // Stub: to be implemented
}

Token Lexer::next_token() {
    // Stub: to be implemented
    return Token(TokenType::EndOfFile, "");
}

