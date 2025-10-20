//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "keywords.h"
#include "lexer.h"
#include "utils.h"
#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <iostream>
#include <sstream>
#include <unordered_map>

TokenizedLine::TokenizedLine(int line_num)
    : line_num_(line_num), cur_index_(0) {
}

void TokenizedLine::clear() {
    tokens_.clear();
    cur_index_ = 0;
}

void TokenizedLine::push_back(const Token& token) {
    tokens_.push_back(token);
}

void TokenizedLine::push_back(Token&& token) {
    tokens_.push_back(std::move(token));
}

const Token& TokenizedLine::peek(int ahead) const {
    int index = cur_index_ + ahead;
    if (index < 0 || static_cast<size_t>(index) >= tokens_.size()) {
        static Token eof_token(TokenType::EndOfFile, "");
        return eof_token;
    }
    else {
        return tokens_[index];
    }
}

void TokenizedLine::advance() {
    if (cur_index_ < static_cast<int>(tokens_.size())) {
        ++cur_index_;
    }
}

void TokenizedLine::rewind() {
    cur_index_ = 0;
}

bool TokenizedLine::at_end() const {
    return cur_index_ >= static_cast<int>(tokens_.size());
}

void TokenizedLine::skip_spaces() {
    // Advance current index past any whitespace tokens.
    while (cur_index_ < static_cast<int>(tokens_.size()) &&
            tokens_[cur_index_].type() == TokenType::Whitespace) {
        ++cur_index_;
    }
}

// Reconstruct the line by concatenating the original token texts in order.
std::string TokenizedLine::to_string() const {
    std::string out;
    out.reserve(tokens_.size() * 4);
    for (const auto& tok : tokens_) {
        out += tok.text();
    }
    return out;
}


TokenizedFile::TokenizedFile(const std::string& filename,
                             int first_line_num) :
    filename_(filename),
    first_line_num_(first_line_num),
    inc_line_nums_(true) {
    std::string content;
    try {
        content = read_file_to_string(filename);
    }
    catch (...) {
        // file read error
        g_errors.error(ErrorCode::FileNotFound,
                       "Could not open file: " + filename_);
        content.clear();
    }

    tokenize(content);
}

TokenizedFile::TokenizedFile(const std::string& content,
                             const std::string& filename, int first_line_num) :
    filename_(filename),
    first_line_num_(first_line_num),
    inc_line_nums_(false) {
    tokenize(content);
}

const std::string& TokenizedFile::get_line(int index) const {
    if (index < 0 || static_cast<size_t>(index) >= text_lines_.size()) {
        static std::string empty;
        return empty;
    }
    else {
        return text_lines_[index];
    }
}

const TokenizedLine& TokenizedFile::get_tokenized_line(int index) const {
    if (index < 0 || static_cast<size_t>(index) >= tok_lines_.size()) {
        static TokenizedLine empty_line(0);
        return empty_line;
    }
    else {
        return tok_lines_[index];
    }
}

void TokenizedFile::clear() {
    text_lines_.clear();
    tok_lines_.clear();
}

void TokenizedFile::split_lines(const char*& p) {
    text_lines_.clear();
    while (*p) {
        const char* line_start = p;
        while (*p && *p != '\r' && *p != '\n') {
            ++p;
        }
        text_lines_.emplace_back(line_start, p - line_start);
        // Handle line endings
        if (*p == '\r') {
            ++p;
            if (*p == '\n') {
                ++p;
            }
        }
        else if (*p == '\n') {
            ++p;
        }
    }
}

void TokenizedFile::tokenize(const std::string& content) {
    // Split content into lines
    const char* p = content.c_str();
    split_lines(p);

    // Tokenize each line
    Location location(filename_, first_line_num_);
    for (int i = 0; i < static_cast<int>(text_lines_.size()); ++i) {
        // notify error reporter of current line
        int line_num = first_line_num_ + (inc_line_nums_ ? i : 0);
        location.set_line_num(line_num);
        g_errors.set_location(location);
        g_errors.set_source_line(text_lines_[i]);

        // split in tokens, possibly advancing i for line continuations
        // and multi-line comments
        TokenizedLine tok_line(line_num);
        tokenize_line(i, tok_line);
        if (!tok_line.empty()) {
            tok_lines_.push_back(std::move(tok_line));
        }
    }
}

//-----------------------------------------------------------------------------

static bool has_dot_eE(const std::string& s) {
    return s.find_first_of(".eE") != std::string::npos;
}

std::vector<MacroToken> tokenize_macro_body(const std::string& body) {
    std::vector<MacroToken> tokens;
    const char* p = body.c_str();

    while (*p) {
        // Whitespace
        if (scan_whitespace(p)) {
            tokens.push_back({ MacroTokenType::Punctuator, " " });
            continue;
        }

        // Identifier
        std::string ident;
        if (scan_identifier(p, ident)) {
            tokens.push_back({ MacroTokenType::Identifier, ident });
            continue;
        }

        // Floating point umber
        double fvalue;
        if (scan_float(p, fvalue)) {
            std::string str = std::to_string(fvalue);
            // must have dot or e to distinguish form integer
            if (!has_dot_eE(str)) {
                str += ".0";
            }
            tokens.push_back({ MacroTokenType::Number, str });
        }

        // Integer
        int ivalue;
        if (scan_integer(p, ivalue)) {
            std::string str = std::to_string(ivalue);
            tokens.push_back({ MacroTokenType::Number, str });
            continue;
        }

        // String literal
        std::string str;
        if (scan_string_literal(p, str)) {
            tokens.push_back({ MacroTokenType::StringLiteral, str });
            continue;
        }

        // Operators and punctuators (handle ## and # specially)
        if (*p == '#') {
            if (p[1] == '#') {
                tokens.push_back({ MacroTokenType::Operator, "##" });
                p += 2;
            }
            else {
                tokens.push_back({ MacroTokenType::Operator, "#" });
                ++p;
            }
            continue;
        }

        if (scan_operator(p, str)) {
            tokens.push_back({ MacroTokenType::Punctuator, str });
            continue;
        }

        // Single-character catch-all
        tokens.push_back({ MacroTokenType::Punctuator,
                           std::string(1, *p) });
        ++p;
    }

    return tokens;
}

bool scan_whitespace(const char*& p) {
    const char* start = p;
    while (*p && std::isspace(static_cast<unsigned char>(*p))) {
        ++p;
    }
    return p != start;
}

// Helper: skip whitespace using scan_whitespace()
void skip_whitespace(const char*& p) {
    scan_whitespace(p);
}

bool scan_identifier(const char*& p, std::string& out) {
    out.clear();
    const char* start = p;

    // Skip whitespace using the helper
    skip_whitespace(p);

    // First character: must be alpha or underscore
    if (!*p || (!std::isalpha(static_cast<unsigned char>(*p)) && *p != '_')) {
        p = start;
        return false;
    }

    out += *p++;
    // Subsequent characters: alnum or underscore
    while (*p && (std::isalnum(static_cast<unsigned char>(*p)) || *p == '_')) {
        out += *p++;
    }

    // If next character is a "'" and a keyword with that quote exists, e.g. AF'
    if (*p == '\'') {
        std::string test = out + "'";
        if (keyword_lookup(test) != Keyword::None) {
            out += *p++;
        }
    }

    return true;
}

// Helper: scan digits (with underscores) in the given base, return value in 'out'.
// Advances p, returns true if at least one digit was found, false otherwise.
static bool scan_digits(const char*& p, int base, int& out) {
    out = 0;
    bool found = false;
    while (*p) {
        if (base == 16 && std::isxdigit(static_cast<unsigned char>(*p))) {
            found = true;
            out = out * 16 + (std::isdigit(*p) ? *p - '0'
                              : std::tolower(*p) - 'a' + 10);
            ++p;
        }
        else if (base == 10 && std::isdigit(static_cast<unsigned char>(*p))) {
            found = true;
            out = out * 10 + (*p - '0');
            ++p;
        }
        else if (base == 2 && (*p == '0' || *p == '1')) {
            found = true;
            out = out * 2 + (*p - '0');
            ++p;
        }
        else if (*p == '_') {
            ++p; // skip underscore
        }
        else {
            break;
        }
    }
    return found;
}

// Helper: scan a single-quoted character literal, including C escapes and '\e' for Escape (0x1B).
// Advances p, returns true and sets out if successful, false otherwise.
static bool scan_char_as_int(const char*& p, int& out) {
    const char* start = p;
    if (*p != '\'') {
        return false;
    }
    ++p; // skip opening quote

    if (*p == '\0' || *p == '\'') { // empty char literal
        p = start;
        return false;
    }

    char value = 0;
    if (*p == '\\') {
        ++p;
        if (*p == 'n')      {
            value = '\n';
            ++p;
        }
        else if (*p == 'r') {
            value = '\r';
            ++p;
        }
        else if (*p == 't') {
            value = '\t';
            ++p;
        }
        else if (*p == 'b') {
            value = '\b';
            ++p;
        }
        else if (*p == 'f') {
            value = '\f';
            ++p;
        }
        else if (*p == 'a') {
            value = '\a';
            ++p;
        }
        else if (*p == 'v') {
            value = '\v';
            ++p;
        }
        else if (*p == '\\') {
            value = '\\';
            ++p;
        }
        else if (*p == '\'') {
            value = '\'';
            ++p;
        }
        else if (*p == '\"') {
            value = '\"';
            ++p;
        }
        else if (*p == 'e') {
            value = 0x1B;
            ++p;
        }
        else if (*p >= '0' && *p <= '7') { // octal escape: \o, \oo, \ooo
            int oct = 0, count = 0;
            while (count < 3 && *p >= '0' && *p <= '7') {
                oct = oct * 8 + (*p - '0');
                ++p;
                ++count;
            }
            value = static_cast<char>(oct);
        }
        else if (*p == 'x') { // hex escape: \xNN
            ++p;
            int hex = 0, count = 0;
            while (count < 2 && std::isxdigit(static_cast<unsigned char>(*p))) {
                hex = hex * 16 + (std::isdigit(*p) ? *p - '0' : std::tolower(*p) - 'a' + 10);
                ++p;
                ++count;
            }
            value = static_cast<char>(hex);
        }
        else {
            // Unrecognized escape, treat as literal char
            value = *p;
            if (*p) {
                ++p;
            }
        }
    }
    else {
        value = *p;
        ++p;
    }

    if (*p != '\'') { // must end with closing quote
        p = start;
        return false;
    }
    ++p; // skip closing quote
    out = static_cast<unsigned char>(value);
    return true;
}

bool scan_label(const char*& p, std::string& out) {
    std::string ident1, ident2;
    const char* start = p;

    skip_whitespace(p);
    if (*p == '@') {
        ++p; // skip '@'
        if (!scan_identifier(p, ident1)) {
            p = start;
            return false;
        }
        out = "@" + ident1;
        return true;
    }
    else {
        if (!scan_identifier(p, ident1)) {
            p = start;
            return false;
        }
        const char* start2 = p;
        skip_whitespace(p);
        if (*p == '@') {
            ++p; // skip '@'
            if (!scan_identifier(p, ident2)) {
                p = start2;
                out = ident1;
                return true;
            }
            out = ident1 + "@" + ident2;
            return true;
        }
        else {
            p = start2;
            out = ident1;
            return true;
        }
    }

    return false;
}

bool scan_integer(const char*& p, int& out) {
    const char* start = p;
    skip_whitespace(p);

    // Single-quoted character literal as integer
    if (scan_char_as_int(p, out)) {
        return true;
    }

    // Hexadecimal: 0x or 0X prefix
    if (*p == '0' && (p[1] == 'x' || p[1] == 'X')) {
        p += 2;
        int value = 0;
        if (!scan_digits(p, 16, value)) {
            p = start;
            return false;
        }
        out = value;
        return true;
    }

    // Hexadecimal: $ prefix
    if (*p == '$') {
        ++p;
        int value = 0;
        if (!scan_digits(p, 16, value)) {
            p = start;
            return false;
        }
        out = value;
        return true;
    }

    // Graphical bitmask: % or @ prefix, then double quote,
    // then sequence of '-' or '#', then double quote
    if ((*p == '%' || *p == '@') && p[1] == '"') {
        ++p; // skip % or @
        ++p; // skip opening "
        int value = 0;
        bool found = false;
        while (*p && *p != '"') {
            if (*p == '-' || *p == '#') {
                found = true;
                value = value << 1;
                if (*p == '#') {
                    value |= 1;
                }
                ++p;
            }
            else {
                p = start;
                return false;
            }
        }
        if (*p == '"') {
            ++p; // skip closing "
            if (!found) {
                p = start;
                return false;
            }
            out = value;
            return true;
        }
        else {
            p = start;
            return false;
        }
    }

    // Binary: % or @ prefix
    if (*p == '%' || *p == '@') {
        ++p;
        int value = 0;
        if (!scan_digits(p, 2, value)) {
            p = start;
            return false;
        }
        out = value;
        return true;
    }

    // Bit-mask formats: 0bxxxx_xxxx (accepts "0b" as 0, underscores allowed)
    if (*p == '0' && (p[1] == 'b' || p[1] == 'B')) {
        p += 2;
        int value = 0;
        bool found = scan_digits(p, 2, value);
        if (!found) {
            out = 0;
            return true;
        }
        out = value;
        return true;
    }

    // Binary: sequence of 0s and 1s (with underscores) followed by 'b' or 'B' (at least one digit)
    if (*p == '0' || *p == '1') {
        const char* bin_start = p;
        int value = 0;
        bool found = scan_digits(p, 2, value);
        if ((*p == 'b' || *p == 'B') && found) {
            ++p;
            out = value;
            return true;
        }
        // If not followed by 'b' or 'B', rewind and continue with other formats
        p = bin_start;
    }

    // Hexadecimal: digits (with underscores) followed by 'h' or 'H'
    if (std::isdigit(static_cast<unsigned char>(*p))) {
        const char* digits_start = p;
        int value = 0;
        bool found = scan_digits(p, 16, value);
        // If next char is 'h' or 'H' and at least one digit was found, treat as hex
        if ((*p == 'h' || *p == 'H') && found) {
            ++p;
            out = value;
            return true;
        }
        // Otherwise, treat as decimal (only if all were digits and underscores)
        p = digits_start;
        value = 0;
        found = scan_digits(p, 10, value);
        // Check for 'd' or 'D' suffix (decimal explicit)
        if ((*p == 'd' || *p == 'D') && found) {
            ++p;
        }
        if (found) {
            out = value;
            return true;
        }
    }

    // No valid integer found
    p = start;
    return false;
}

bool scan_float(const char*& p, double& out) {
    const char* start = p;
    skip_whitespace(p);

    // Number must start with a digit or a .
    if (!std::isdigit(static_cast<unsigned char>(*p)) && *p != '.') {
        return false;
    }

    const char* s = p;
    bool has_digits = false;
    bool has_dot = false;
    bool has_exp = false;

    // Digits before decimal point
    while (std::isdigit(static_cast<unsigned char>(*s))) {
        has_digits = true;
        ++s;
    }

    // Decimal point
    if (*s == '.') {
        has_dot = true;
        ++s;
        // Digits after decimal point
        while (std::isdigit(static_cast<unsigned char>(*s))) {
            has_digits = true;
            ++s;
        }
    }

    // Exponent
    if (*s == 'e' || *s == 'E') {
        has_exp = true;
        ++s;
        // Optional sign in exponent
        if (*s == '+' || *s == '-') {
            ++s;
        }
        bool exp_digits = false;
        while (std::isdigit(static_cast<unsigned char>(*s))) {
            exp_digits = true;
            ++s;
        }
        if (!exp_digits) {
            p = start;
            return false;
        }
    }

    // Must have at least a dot or exponent, and at least one digit somewhere
    if ((has_dot || has_exp) && has_digits) {
        char* endptr = nullptr;
        out = std::strtod(p, &endptr);
        if (endptr != p) {
            p = endptr;
            return true;
        }
    }

    p = start;
    return false;
}

bool scan_string_literal(const char*& p, std::string& out) {
    const char* start = p;
    out.clear();

    if (*p != '"') {
        return false;
    }

    out += *p++; // add opening quote

    while (*p) {
        if (*p == '"') {
            out += *p++; // add closing quote
            return true;
        }
        if (*p == '\\') {
            out += *p++; // add backslash
            if (!*p) {
                // unterminated escape
                p = start;
                return false;
            }
            char esc = *p;
            out += *p++; // add escape char
            // Optionally, validate escape sequences here
            // Accept C-escapes plus \e
            if (esc == 'x') {
                // Hex escape: \xNN (up to 2 hex digits)
                int count = 0;
                while (count < 2 && std::isxdigit(static_cast<unsigned char>(*p))) {
                    out += *p++;
                    ++count;
                }
            }
            else if (esc >= '0' && esc <= '7') {
                // Octal escape: \o, \oo, \ooo (up to 3 octal digits)
                int count = 1;
                while (count < 3 && *p >= '0' && *p <= '7') {
                    out += *p++;
                    ++count;
                }
            }
            // else: single-char escape, already added
        }
        else {
            out += *p++;
        }
    }

    // If we reach here, no closing quote found
    p = start;
    return false;
}

std::string unescape_string(const std::string& str) {
    std::string out;
    if (str.empty()) {
        return out;
    }

    // Work on the interior if the string is quoted, otherwise use entire input
    size_t i = 0;
    size_t len = str.size();
    if (str.front() == '"' && len >= 2) {
        i = 1;
        len = (str.back() == '"' ? str.size() - 1 : str.size());
    }
    else {
        i = 0;
        len = str.size();
    }

    for (; i < len; ++i) {
        char c = str[i];
        if (c != '\\') {
            out.push_back(c);
            continue;
        }

        // Escape sequence
        if (i + 1 >= len) {
            // Trailing backslash, treat literally
            out.push_back('\\');
            break;
        }

        char esc = str[++i];
        switch (esc) {
        case 'n':
            out.push_back('\n');
            break;
        case 'r':
            out.push_back('\r');
            break;
        case 't':
            out.push_back('\t');
            break;
        case 'b':
            out.push_back('\b');
            break;
        case 'f':
            out.push_back('\f');
            break;
        case 'a':
            out.push_back('\a');
            break;
        case 'v':
            out.push_back('\v');
            break;
        case '\\':
            out.push_back('\\');
            break;
        case '\'':
            out.push_back('\'');
            break;
        case '"':
            out.push_back('"');
            break;
        case 'e':
            out.push_back(static_cast<char>(0x1B));
            break;
        case '0': // fallthrough to octal parsing starting with this digit
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7': {
            // Octal escape: up to 3 octal digits (we already consumed first)
            int val = esc - '0';
            int count = 1;
            while (count < 3 && i + 1 < len && str[i + 1] >= '0' && str[i + 1] <= '7') {
                ++i;
                val = (val << 3) + (str[i] - '0');
                ++count;
            }
            out.push_back(static_cast<char>(val));
            break;
        }
        case 'x': {
            // Hex escape: up to 2 hex digits
            int val = 0;
            int count = 0;
            while (count < 2 && i + 1 < len
                    && std::isxdigit(static_cast<unsigned char>(str[i + 1]))) {
                ++i;
                char h = str[i];
                val = val * 16 + (std::isdigit(static_cast<unsigned char>
                                               (h)) ? h - '0' : std::tolower(h) - 'a' + 10);
                ++count;
            }
            out.push_back(static_cast<char>(val));
            break;
        }
        default:
            // Unknown escape: treat as literal escaped character
            out.push_back(esc);
            break;
        }
    }

    return out;
}

bool scan_operator(const char*& p, std::string& out) {
    const char* start = p;
    out.clear();

    switch (*p) {
    case '&':
        if (p[1] == '&') {
            out = "&&";
            p += 2;
            return true;
        }
        out = "&";
        ++p;
        return true;
    case '|':
        if (p[1] == '|') {
            out = "||";
            p += 2;
            return true;
        }
        out = "|";
        ++p;
        return true;
    case '^':
        if (p[1] == '^') {
            out = "^^";
            p += 2;
            return true;
        }
        out = "^";
        ++p;
        return true;
    case '<':
        if (p[1] == '=') {
            out = "<=";
            p += 2;
            return true;
        }
        if (p[1] == '>') {
            out = "<>";
            p += 2;
            return true;
        }
        if (p[1] == '<') {
            out = "<<";
            p += 2;
            return true;
        }
        out = "<";
        ++p;
        return true;
    case '>':
        if (p[1] == '=') {
            out = ">=";
            p += 2;
            return true;
        }
        if (p[1] == '>') {
            out = ">>";
            p += 2;
            return true;
        }
        out = ">";
        ++p;
        return true;
    case '=':
        if (p[1] == '=') {
            out = "==";
            p += 2;
            return true;
        }
        out = "=";
        ++p;
        return true;
    case '!':
        if (p[1] == '=') {
            out = "!=";
            p += 2;
            return true;
        }
        out = "!";
        ++p;
        return true;
    case '+':
        out = "+";
        ++p;
        return true;
    case '-':
        out = "-";
        ++p;
        return true;
    case '*':
        if (p[1] == '*') {
            out = "**";
            p += 2;
            return true;
        }
        out = "*";
        ++p;
        return true;
    case '/':
        out = "/";
        ++p;
        return true;
    case '%':
        out = "%";
        ++p;
        return true;
    case '@':
        out = "@";
        ++p;
        return true;
    case '#':
        if (p[1] == '#') {
            out = "##";
            p += 2;
            return true;
        }
        out = "#";
        ++p;
        return true;
    case '~':
        out = "~";
        ++p;
        return true;
    case '?':
        out = "?";
        ++p;
        return true;
    case ':':
        out = ":";
        ++p;
        return true;
    case ',':
        out = ",";
        ++p;
        return true;
    case '.':
        out = ".";
        ++p;
        return true;
    case '(':
        out = "(";
        ++p;
        return true;
    case ')':
        out = ")";
        ++p;
        return true;
    case '{':
        out = "{";
        ++p;
        return true;
    case '}':
        out = "}";
        ++p;
        return true;
    case '[':
        out = "[";
        ++p;
        return true;
    case ']':
        out = "]";
        ++p;
        return true;
    default:
        break;
    }

    p = start;
    return false;
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

