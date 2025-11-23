//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "keywords.h"
#include "lexer.h"
#include "options.h"
#include "utils.h"

#ifdef _MSC_VER
#pragma warning(push)
#pragma warning(disable:4127) // conditional expression is constant (expected in re2c-generated YYFILL() checks)
#endif

#define PUSH_TOKEN1(type) \
    do { \
        str = std::string(tok, p); \
        bool has_space_after = (p < pe) && is_space(*p); \
        Token t(type, str, has_space_after); \
        output.push_back(t); \
    } while (0)

#define PUSH_TOKEN2(type, arg) \
    do { \
        str = std::string(tok, p); \
        bool has_space_after = (p < pe) && is_space(*p); \
        Token t(type, str, arg, has_space_after); \
        output.push_back(t); \
    } while (0)

#define CHECK_TRAILING_CHAR() \
    do { \
        if (p < pe && is_ident_char(*p)) { \
            g_errors.error(ErrorCode::InvalidSyntax, \
                    "Invalid character '" + std::string(1, *p) + "' after literal: '" + std::string(tok, p + 1) + "'"); \
            output.clear(); \
            return; \
        } \
    } while (0)

#define YYFILL() 1

static void swap_x_y(std::string& str) {
    // replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
    for (auto& c : str) {
        switch (c) {
        case 'x': c = 'y'; break;
        case 'X': c = 'Y'; break;
        case 'y': c = 'x'; break;
        case 'Y': c = 'X'; break;
        default:;
        }
    }
}

static void swap_ix_iy(std::string& str, Keyword& keyword) {
    switch (keyword) {
    case Keyword::IX: case Keyword::IXH: case Keyword::IXL:
    case Keyword::IY: case Keyword::IYH: case Keyword::IYL:
    case Keyword::AIX: case Keyword::PIX: case Keyword::XIX: case Keyword::YIX: case Keyword::ZIX:
    case Keyword::AIY: case Keyword::PIY: case Keyword::XIY: case Keyword::YIY: case Keyword::ZIY:
        swap_x_y(str);
        keyword = keyword_lookup(str);
        break;
    default:;
    }
}

void TokensFile::tokenize_line(unsigned& line_index, TokensLine& output) {
    if (line_index >= line_count()) {
        return;
    }

    const char* p = text_lines_[line_index].c_str();
    const char* pe = p + text_lines_[line_index].size();
    const char* tok = p;
    const char* marker = p;
    char end_quote = 0;
    bool raw_strings = false;   // set to true after INCLUDE/LINE/...
    const char* string_start = p;
    std::string str;
    std::string str_content;

main_loop:
    while (p < pe) {
        tok = p;

        /*!re2c
        re2c:define:YYCTYPE = char;
        re2c:define:YYCURSOR = p;
        re2c:define:YYLIMIT = pe;
        re2c:define:YYMARKER = marker;
        re2c:eof = 0;
        re2c:indent:top = 2;

        end         	= "\x00";
        ws		    = [ \t\v\f\r\n];
        ident1 	    = [_a-zA-Z][_a-zA-Z0-9]*;
        ident       = '@' ident1 | ident1 '@' ident1 | ident1;
        bin		    = [0-1];
        oct		    = [0-7];
        dec		    = [0-9];
        hex		    = [0-9a-fA-F];

        decu        = dec ('_'* dec)*;
        hexu        = hex ('_'* hex)*;
        binu        = bin ('_'* bin)*;

        mantissau   = decu '.' decu* | decu* '.' decu+;
        expu        = [eE] [-+]? decu;

        * {
            g_errors.error(ErrorCode::InvalidSyntax,
                    "Unexpected character: '" + std::string(tok, p) + "'");
            output.clear();
            return;
        }

        '\\' {
            const char* q = p;
            while (q < pe && is_space(*q)) {
                ++q;
            }
            if (q >= pe) {
                // line continuation
                ++line_index;
                if (line_index >= line_count()) {
                    return;
                }
                p = text_lines_[line_index].c_str();
                pe = p + text_lines_[line_index].size();
                continue;
            }
            else {
                // not a line continuation
                PUSH_TOKEN1(TokenType::Backslash);
                continue;
            }
        }

        $       { goto eol; }
        ';'     { goto eol; }
        '//'    { goto eol; }
        '/*'    { goto c_comment; }

        '"'     {
            end_quote = '"';
            string_start = tok;
            goto string_loop;
        }

        "'"     {
            end_quote = '\'';
            string_start = tok;
            goto string_loop;
        }

        "<"     {
            if (raw_strings) {
                end_quote = '>';
                string_start = tok;
                goto string_loop;
            }
            else {
                PUSH_TOKEN1(TokenType::LT);
                continue; 
            }
        }

        ws+     { continue; }
        '('		{ PUSH_TOKEN1(TokenType::LeftParen); continue; }
        ')'		{ PUSH_TOKEN1(TokenType::RightParen); continue; }
        ','		{ PUSH_TOKEN1(TokenType::Comma); continue; }
        '.'		{ PUSH_TOKEN1(TokenType::Dot); continue; }
        '['		{ PUSH_TOKEN1(TokenType::LeftBracket); continue; }
        ']'		{ PUSH_TOKEN1(TokenType::RightBracket); continue; }
        '{'		{ PUSH_TOKEN1(TokenType::LeftBrace); continue; }
        '}'		{ PUSH_TOKEN1(TokenType::RightBrace); continue; }

        '#'     { PUSH_TOKEN1(TokenType::Hash); continue; }
        '##'    { PUSH_TOKEN1(TokenType::DoubleHash); continue; }
        ':'     { PUSH_TOKEN1(TokenType::Colon); continue; }
        '?'     { PUSH_TOKEN1(TokenType::Quest); continue; }
        '!'		{ PUSH_TOKEN1(TokenType::LogicalNot); continue; }
        '%'		{ PUSH_TOKEN1(TokenType::Modulus); continue; }
        '&'		{ PUSH_TOKEN1(TokenType::BitwiseAnd); continue; }
        '&&'		{ PUSH_TOKEN1(TokenType::LogicalAnd); continue; }
        '*'		{ PUSH_TOKEN1(TokenType::Multiply); continue; }
        '**'		{ PUSH_TOKEN1(TokenType::Power); continue; }
        '+'		{ PUSH_TOKEN1(TokenType::Plus); continue; }
        '-'		{ PUSH_TOKEN1(TokenType::Minus); continue; }
        '/'		{ PUSH_TOKEN1(TokenType::Divide); continue; }
        '<='		{ PUSH_TOKEN1(TokenType::LE); continue; }
        '<<'		{ PUSH_TOKEN1(TokenType::ShiftLeft); continue; }
        '='  | '=='		{ PUSH_TOKEN1(TokenType::EQ); continue; }
        '!=' | '<>'		{ PUSH_TOKEN1(TokenType::NE); continue; }
        '>'		{ PUSH_TOKEN1(TokenType::GT); continue; }
        '>='		{ PUSH_TOKEN1(TokenType::GE); continue; }
        '>>'		{ PUSH_TOKEN1(TokenType::ShiftRight); continue; }
        '^'		{ PUSH_TOKEN1(TokenType::BitwiseXor); continue; }
        '^^'		{ PUSH_TOKEN1(TokenType::LogicalXor); continue; }
        '|'		{ PUSH_TOKEN1(TokenType::BitwiseOr); continue; }
        '||'		{ PUSH_TOKEN1(TokenType::LogicalOr); continue; }
        '~'		{ PUSH_TOKEN1(TokenType::BitwiseNot); continue; }
        '@'		{ PUSH_TOKEN1(TokenType::At); continue; }
        '$'		{ PUSH_TOKEN1(TokenType::Dollar); continue; }

        mantissau expu? 	{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok, p);
            double value = 0.0;
            if (!parse_float_from_chars(digits, value)) {
                g_errors.error(ErrorCode::InvalidFloat, digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Float, value);
            continue;
        }

        decu 'd'?		{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok, p);
            if (!digits.empty() && (digits.back() == 'd' || digits.back() == 'D')) {
                digits.pop_back();
            }
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 10, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid decimal integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        decu ('_'* hex)* 'h'    	{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok, p - 1);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 16, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid hexdecimal integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        "$" hexu		    {
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok + 1, p);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 16, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid hexdecimal integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        '0x' hexu		{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok + 2, p);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 16, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid hexdecimal integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        binu 'b'		    {
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok, p - 1);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 2, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid binary integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        [%@] binu		{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok + 1, p);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 2, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid binary integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        '0b' binu		{
            CHECK_TRAILING_CHAR();
            std::string digits = std::string(tok + 2, p);
            int value = 0;
            if (!parse_int_from_chars(digits.c_str(), 2, value)) {
                g_errors.error(ErrorCode::InvalidInteger,
                        "Invalid binary integer: " + digits);
                output.clear();
                return;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        [%@] '"' [-#]* '"' {
            int value = 0;
            for (const char* i = tok + 2; i < p - 1; ++i) {
                value *= 2;
                if (*i == '#') ++value;
            }

            PUSH_TOKEN2(TokenType::Integer, value);
            continue;
        }

        ident "'"?      {
            str = std::string(tok, p);

            // to upper
            if (g_options.ucase_labels) {
                str = to_upper(str);
            }

            // handle af' et all
            Keyword keyword = keyword_lookup(str);
            if (str.back() == '\'' && keyword == Keyword::None) {
                // drop quote
                str.pop_back();
                --p;
                keyword = keyword_lookup(str);
            }

            // check for -IXIY
            if (g_options.swap_ix_iy) {
                swap_ix_iy(str, keyword);
            }

            // check for .ASSUME
            if (keyword == Keyword::ASSUME && !output.empty() &&
                output.back().is(TokenType::Dot)) {
                output.pop_back();       // remove '.'
            }

            // check for ASMPC
            if (keyword == Keyword::ASMPC) {
                bool has_space_after = (p < pe) && is_space(*p);
                Token t(TokenType::ASMPC, str, keyword, has_space_after);
                output.push_back(t);
                continue;
            }

            // need raw strings after INCLUDE, BINARY, INCBIN, LINE, C_LINE
            switch (keyword) {
            case Keyword::INCLUDE:
            case Keyword::BINARY:
            case Keyword::INCBIN:
            case Keyword::LINE:
            case Keyword::C_LINE:
                raw_strings = true;
                break;
            default:;
            }

            bool has_space_after = (p < pe) && is_space(*p);
            Token t(TokenType::Identifier, str, keyword, has_space_after);
            output.push_back(t);
            continue;
        }

        */
    }

    // end of input line
eol:
    return;

    // find end of c-comment, possibly reading more lines
c_comment:
    while (true) {
        while (p < pe) {
            if (*p == '*' && (p + 1) < pe && *(p + 1) == '/') {
                p += 2;
                goto main_loop;
            }
            ++p;
        }

        // continue to next line
        if (line_index + 1 >= line_count()) {
            break;
        }

        ++line_index;
        p = text_lines_[line_index].c_str();
        pe = p + text_lines_[line_index].size();
    }

    g_errors.error(ErrorCode::UnterminatedComment);
    output.clear();
    return;

    // parse string literal
string_loop:
    str.clear();
    str_content.clear();
    while (p < pe) {
        tok = p;

        /*!re2c
        end { p = pe; continue; }
        $   { p = pe; continue; }
        *   { str_content.push_back(*tok); continue; }
        '>' {
            if (end_quote == '>') {
                str = std::string(string_start, p);
                bool has_space_after = (p < pe) && is_space(*p);
                Token t(TokenType::String, str, str_content, has_space_after);
                output.push_back(t);
                goto main_loop;
            }
            else {
                str_content.push_back(*tok);
                continue;
            }
        }
        '"' {
            if (end_quote == '"') {
                str = std::string(string_start, p);
                bool has_space_after = (p < pe) && is_space(*p);
                Token t(TokenType::String, str, str_content, has_space_after);
                output.push_back(t);
                goto main_loop;
            }
            else {
                str_content.push_back(*tok);
                continue;
            }
        }
        '\'' {
            if (end_quote == '\'') {
                if (str_content.size() != 1) {
                    g_errors.error(ErrorCode::InvalidSyntax,
                        "Invalid quoted character");
                    output.clear();
                    return;
                }
                else {
                    str = std::string(string_start, p);
                    bool has_space_after = (p < pe) && is_space(*p);
                    Token t(TokenType::Integer, str, str_content[0],
                            has_space_after);
                    output.push_back(t);
                    goto main_loop;
                }
            }
            else {
                str_content.push_back(*tok);
                continue;
            }
        }
        '\\' "a"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\a');
            }
            continue;
        }
        '\\' "b"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\b');
            }
            continue;
        }
        '\\' "e"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\x1B');
            }
            continue;
        }
        '\\' "f"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\f');
            }
            continue;
        }
        '\\' "n"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\n');
            }
            continue;
        }
        '\\' "r"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\r');
            }
            continue;
        }
        '\\' "t"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\t');
            }
            continue;
        }
        '\\' "v"    {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back('\v');
            }
            continue;
        }
        '\\' oct{1,3}   {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                std::string digits = std::string(tok + 1, p);
                int value = 0;
                if (!parse_int_from_chars(digits.c_str(), 8, value)) {
                    g_errors.error(ErrorCode::InvalidInteger,
                            "Invalid octal integer: " + digits);
                    output.clear();
                    return;
                }

                str_content.push_back(static_cast<char>(value));
            }
            continue;
        }
        '\\' "x" hex{1,2}   {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                std::string digits = std::string(tok + 2, p);
                int value = 0;
                if (!parse_int_from_chars(digits.c_str(), 16, value)) {
                    g_errors.error(ErrorCode::InvalidInteger,
                            "Invalid hexadecimal integer: " + digits);
                    output.clear();
                    return;
                }

                str_content.push_back(static_cast<char>(value));
            }
            continue;
        }
        '\\' .  {
            if (raw_strings) {
                str_content.push_back(*tok);
                p = tok + 1;
            }
            else {
                str_content.push_back(tok[1]);
            }
            continue;
        }
        */
    }

    g_errors.error(ErrorCode::UnterminatedString);
    output.clear();
    return;
}

#ifdef _MSC_VER
#pragma warning(pop)
#endif
