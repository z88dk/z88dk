//-----------------------------------------------------------------------------
// z80asm
// Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "scanner.h"
#include "utils.h"
#include <cstring>
using namespace std;

Scanner::Scanner(const vector<Token>& tokens) {
    m_tokens = tokens;
}

void Scanner::clear() {
    m_tokens.clear();
    m_pos = 0;
}

bool Scanner::scan(const string& text) {
    clear();
    const char* p = text.c_str();
    while (*p != '\0') {
        const char* p0 = p;
        bool blank_before = false;
        string arg;
        Keyword keyword = Keyword::NONE;

        switch (*p++) {
            // Uppercase A-Z
        case 'A': case 'B': case 'C': case 'D': case 'E':
        case 'F': case 'G': case 'H': case 'I': case 'J':
        case 'K': case 'L': case 'M': case 'N': case 'O':
        case 'P': case 'Q': case 'R': case 'S': case 'T':
        case 'U': case 'V': case 'W': case 'X': case 'Y': case 'Z':

            // Lowercase a-z
        case 'a': case 'b': case 'c': case 'd': case 'e':
        case 'f': case 'g': case 'h': case 'i': case 'j':
        case 'k': case 'l': case 'm': case 'n': case 'o':
        case 'p': case 'q': case 'r': case 's': case 't':
        case 'u': case 'v': case 'w': case 'x': case 'y': case 'z':

            // Underscore
        case '_':
            while (is_ident(*p))
                ++p;
            if (*p == '\'')
                ++p;

            // handle alternate registers
            arg = string(p0, p);
            keyword = ::lookup_keyword(arg);
            if (keyword == Keyword::NONE && arg.back() == '\'') {	// not alternate register
                --p;
                arg.pop_back();
                keyword = ::lookup_keyword(arg);
            }

            if (keyword == Keyword::ASMPC) {
                m_tokens.emplace_back(TType::ASMPC, blank_before);
            }
            else {
                m_tokens.emplace_back(TType::IDENT, blank_before);
                m_tokens.back().set_keyword(arg);
            }
            break;

            // Digits
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
            while (isdigit(*p))
                ++p;
            arg = string(p0, p);
            m_tokens.emplace_back(TType::INT, blank_before);
            m_tokens.back().set_ivalue(std::stoi(arg));
            break;

            // Operatos
        case '+': m_tokens.emplace_back(TType::OPERATOR, blank_before); m_tokens.back().set_operator(Operator::PLUS); break;
        case '-': m_tokens.emplace_back(TType::OPERATOR, blank_before); m_tokens.back().set_operator(Operator::MINUS); break;
        case '/': m_tokens.emplace_back(TType::OPERATOR, blank_before); m_tokens.back().set_operator(Operator::DIV); break;
        case '%': m_tokens.emplace_back(TType::OPERATOR, blank_before); m_tokens.back().set_operator(Operator::MOD); break;
        case '~': m_tokens.emplace_back(TType::OPERATOR, blank_before); m_tokens.back().set_operator(Operator::BIN_NOT); break;

        case '*':
            if (*p == '*') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::POWER);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::MULT);
            }
            break;

        case '=':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::EQ);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::EQ);
            }
            break;

        case '!':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::NE);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LOG_NOT);
            }
            break;

        case '&':
            if (*p == '&') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LOG_AND);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::BIN_AND);
            }
            break;

        case '<':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LE);
            }
            else if (*p == '<') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LSHIFT);
            }
            else if (*p == '>') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::NE);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LT);
            }
            break;

        case '>':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::GE);
            }
            else if (*p == '>') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::RSHIFT);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::GT);
            }
            break;

        case '^':
            if (*p == '^') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LOG_XOR);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::BIN_XOR);
            }
            break;

        case '|':
            if (*p == '|') {
                ++p;
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::LOG_OR);
            }
            else {
                m_tokens.emplace_back(TType::OPERATOR, blank_before);
                m_tokens.back().set_operator(Operator::BIN_OR);
            }
            break;

            // Symbols
        case '$': m_tokens.emplace_back(TType::ASMPC, blank_before); break;
        case '(': m_tokens.emplace_back(TType::LPAREN, blank_before); break;
        case ')': m_tokens.emplace_back(TType::RPAREN, blank_before); break;
        case ',': m_tokens.emplace_back(TType::COMMA, blank_before); break;
        case '.': m_tokens.emplace_back(TType::DOT, blank_before); break;
        case ':': m_tokens.emplace_back(TType::COLON, blank_before); break;
        case '?': m_tokens.emplace_back(TType::QUEST, blank_before); break;
        case ']': m_tokens.emplace_back(TType::RSQUARE, blank_before); break;
        case '[': m_tokens.emplace_back(TType::LSQUARE, blank_before); break;
        case '{': m_tokens.emplace_back(TType::LBRACE, blank_before); break;
        case '}': m_tokens.emplace_back(TType::RBRACE, blank_before); break;
        case '\\': m_tokens.emplace_back(TType::BACKSLASH, blank_before); break;

        case '#':
            if (*p == '#') {
                ++p;
                m_tokens.emplace_back(TType::DHASH, blank_before);
            }
            else {
                m_tokens.emplace_back(TType::HASH, blank_before);
            }
            break;

            // String
        case '"':
            --p;
            if (!m_tokens.empty() &&
                (m_tokens.back().is(Keyword::INCLUDE) ||
                    m_tokens.back().is(Keyword::BINARY) ||
                    m_tokens.back().is(Keyword::INCBIN) ||
                    m_tokens.back().is(Keyword::LINE) ||
                    m_tokens.back().is(Keyword::C_LINE))) {
                if (parse_raw_string(p, arg)) {
                    m_tokens.emplace_back(TType::RAW_STR, blank_before);
                    m_tokens.back().set_svalue(arg);
                }
                else {
                    clear();
                    return false;
                }
            }
            else {
                if (parse_c_string(p, arg)) {
                    m_tokens.emplace_back(TType::STR, blank_before);
                    m_tokens.back().set_svalue(arg);
                }
                else {
                    clear();
                    return false;
                }
            }
            break;

            // Quoted character
        case '\'':
            --p;
            if (!m_tokens.empty() &&
                (m_tokens.back().is(Keyword::INCLUDE) ||
                    m_tokens.back().is(Keyword::BINARY) ||
                    m_tokens.back().is(Keyword::INCBIN) ||
                    m_tokens.back().is(Keyword::LINE) ||
                    m_tokens.back().is(Keyword::C_LINE))) {
                if (parse_raw_string(p, arg)) {
                    m_tokens.emplace_back(TType::RAW_STR, blank_before);
                    m_tokens.back().set_svalue(arg);
                }
                else {
                    clear();
                    return false;
                }
            }
            else {
                if (parse_c_string(p, arg)) {
                    if (arg.size() == 1) {
                        m_tokens.emplace_back(TType::INT, blank_before);
                        m_tokens.back().set_ivalue(static_cast<int>(arg[0]));
                    }
                    else {
                        g_error->error_invalid_quoted_char();
                        clear();
                        return false;
                    }
                }
                else {
                    clear();
                    return false;
                }
            }
            break;

            // White space
        case '\n':
            m_tokens.emplace_back(TType::NEWLINE, blank_before);
            break;

        case ' ': case '\t': case '\v': case '\f': case '\r':
            blank_before = true;
            break;

            // Comments
        case ';':
            p += strlen(p);
            break;

        default:
            g_error->error_invalid_char(*p);
            clear();
            return false;
        }
    }

    return true;
}

void Scanner::rewind() {
    m_pos = 0;
}

void Scanner::next(int num) {
    m_pos += num;
    if (m_pos > static_cast<int>(m_tokens.size()))
        m_pos = static_cast<int>(m_tokens.size());
}

Token& Scanner::peek(int offset) {
    static Token end;
    int pos = m_pos + offset;
    if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
        return m_tokens[pos];
    else
        return end;
}

Token& Scanner::operator[](int pos) {
    static Token end;
    if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
        return m_tokens[pos];
    else
        return end;
}

Token& Scanner::front() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.front();
}

Token& Scanner::back() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.back();
}

bool Scanner::parse_raw_string(const char*& p, string& result) {
    char quote = *p++;
    result.clear();
    while (*p != quote && *p != '\0') {
        result += *p++;
    }
    if (*p != quote) {
        g_error->error_unterminated_string();
        result.clear();
        return false;
    }
    else {
        ++p;
    }

    return true;
}

bool Scanner::parse_c_string(const char*& p, string& result) {
    char quote = *p++;
    result.clear();
    while (*p != quote && *p != '\0') {
        if (*p == '\\') {
            ++p;
            if (*p == '\0') {
                g_error->error_unterminated_string();
                result.clear();
                return false;
            }
            else if (*p >= '0' && *p <= '7') {
                result += parse_octal(p);
            }
            else if (*p == 'x' && isxdigit(p[1])) {
                ++p; // skip 'x'
                result += parse_hex(p);
            }
            else {
                char result_char = '\0';
                if (parse_escape_char(*p++, result_char)) {
                    result += result_char;
                }
                else {
                    result.clear();
                    return false;
                }
            }
        }
        else {
            result += *p++;
        }
    }
    if (*p != quote) {
        g_error->error_unterminated_string();
        result.clear();
        return false;
    }
    else {
        ++p;
    }

    return true;
}

bool Scanner::parse_escape_char(char c, char& result) {
    result = '\0';
    switch (c) {
    case 'n':  result = '\n'; return true;
    case 't':  result = '\t'; return true;
    case 'r':  result = '\r'; return true;
    case 'b':  result = '\b'; return true;
    case 'f':  result = '\f'; return true;
    case 'a':  result = '\a'; return true;
    case 'v':  result = '\v'; return true;
    case 'e':  result = '\x1b'; return true;
    case '\\': result = '\\'; return true;
    case '\'': result = '\''; return true;
    case '\"': result = '\"'; return true;
    case '?':  result = '\?'; return true;
    default:
        g_error->error_invalid_escape_char(c);
        return false;
    }
}

char Scanner::parse_octal(const char*& p) {
    int value = 0;
    int count = 0;
    while (count < 3 && *p >= '0' && *p <= '7') {
        value = (value * 8) + (*p - '0');
        ++p;
        ++count;
    }
    return static_cast<char>(value);
}

char Scanner::parse_hex(const char*& p) {
    int value = 0;
    while (isxdigit(*p)) {
        value *= 16;
        if (*p >= '0' && *p <= '9') {
            value += (*p - '0');
        }
        else if (*p >= 'a' && *p <= 'f') {
            value += (*p - 'a' + 10);
        }
        else if (*p >= 'A' && *p <= 'F') {
            value += (*p - 'A' + 10);
        }
        ++p;
    }
    return static_cast<char>(value);
}

string Scanner::to_string() const {
    string result;
    for (auto& token : m_tokens) {
        result = Token::concat(result, token.to_string());
    }
    return result;
}

