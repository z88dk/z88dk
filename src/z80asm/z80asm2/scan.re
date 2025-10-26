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

#define PUSH_TOKEN1(type) \
    do { \
        str = std::string(tok, p); \
        Token t(type, str); \
        output.push_back(t); \
    } while (0)

#define PUSH_TOKEN2(type, arg) \
    do { \
        str = std::string(tok, p); \
        Token t(type, str, arg); \
        output.push_back(t); \
    } while (0)

#define YYFILL() 1

static void swap_x_y(std::string & str) {
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

static void swap_ix_iy(std::string& str, Keyword & keyword) {
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

void TokensFile::tokenize_line(int& line_index, TokensLine& output) {
    if (line_index < 0 || line_index >= line_count()) {
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
        mantissa    = dec+ '.' dec* | dec* '.' dec+;
        exp		    = 'e' [-+]? dec+;

        * {
            g_errors.error(ErrorCode::InvalidSyntax,
                    "Unexpected character: '" + std::string(tok, p) + "'");
            output.clear();
            return;
        }

        '\\' ws* end {
            Token t(TokenType::Whitespace, " ");
            output.push_back(t);

            p = text_lines_[line_index].c_str();
            pe = p + text_lines_[line_index].size();
            continue;
        }

        '$'		{
            str = "ASMPC";
            Token t(TokenType::Identifier, str, keyword_lookup(str));
            output.push_back(t);
        }

        $       { goto eof; }
        ';'     { goto eof; }
        '//'    { goto eof; }
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
                PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LT);
                continue; 
            }
        }

        ws+     { PUSH_TOKEN1(TokenType::Whitespace); continue; }
        '\\'    { PUSH_TOKEN1(TokenType::Backslash); continue; }
        '('		{ PUSH_TOKEN1(TokenType::LeftParen); continue; }
        ')'		{ PUSH_TOKEN1(TokenType::RightParen); continue; }
        ','		{ PUSH_TOKEN1(TokenType::Comma); continue; }
        '.'		{ PUSH_TOKEN1(TokenType::Dot); continue; }
        '['		{ PUSH_TOKEN1(TokenType::LeftBracket); continue; }
        ']'		{ PUSH_TOKEN1(TokenType::RightBracket); continue; }
        '{'		{ PUSH_TOKEN1(TokenType::LeftBrace); continue; }
        '}'		{ PUSH_TOKEN1(TokenType::RightBrace); continue; }

        '#'     { PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Hash); continue; }
        '##'    { PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::DoubleHash); continue; }
        ':'     { PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Colon); continue; }
        '?'     { PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Quest); continue; }
        '!'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LogicalNot); continue; }
        '%'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Modulus); continue; }
        '&'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::BitwiseAnd); continue; }
        '&&'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LogicalAnd); continue; }
        '*'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Multiply); continue; }
        '**'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Power); continue; }
        '+'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Plus); continue; }
        '-'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Minus); continue; }
        '/'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::Divide); continue; }
        '<='		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LE); continue; }
        '<<'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::ShiftLeft); continue; }
        '='  | '=='		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::EQ); continue; }
        '!=' | '<>'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::NE); continue; }
        '>'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::GT); continue; }
        '>='		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::GE); continue; }
        '>>'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::ShiftRight); continue; }
        '^'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::BitwiseXor); continue; }
        '^^'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LogicalXor); continue; }
        '|'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::BitwiseOr); continue; }
        '||'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::LogicalOr); continue; }
        '~'		{ PUSH_TOKEN2(TokenType::Operator,
                            OperatorType::BitwiseNot); continue; }

        mantissa exp? 	{
            PUSH_TOKEN2(TokenType::Float, std::stod(str));
            continue;
        }

        dec+ 'd'?		{
            std::string digits = std::string(tok, p);
            if (digits.back() == 'd' || digits.back() == 'D') {
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

        dec hex* 'h'    	{
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

        "$" hex+		    {
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

        '0x' hex+		{
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

        bin+ 'b'		    {
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

        [%@] bin+		{
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

        '0b' bin+		{
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

            Token t(TokenType::Identifier, str, keyword);
            output.push_back(t);
            continue;
        }

        */
    }

    // end of input line
eof:
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
                Token t(TokenType::String, str, str_content);
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
                Token t(TokenType::String, str, str_content);
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
                    Token t(TokenType::Integer, str, str_content[0]);
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
