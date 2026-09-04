//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "utils.h"
#include "zx81chars.h"
#include <cctype>
#include <string>
#include <vector>

/*!re2c
    re2c:define:YYCTYPE = char;
    re2c:define:YYCURSOR = p;
    re2c:define:YYMARKER = marker;
    re2c:define:YYLIMIT = limit;
    re2c:eof = 0;
    re2c:yyfill:enable = 0;
    re2c:indent:top = 2;

    ws          = [ \t\v\f\r\n];
    ident       = [_a-zA-Z][_a-zA-Z0-9]*;
    bin         = [0-1];
    oct         = [0-7];
    dec         = [0-9];
    hex         = [0-9a-fA-F];
    decu        = dec ('_'* dec)*;
    hexu        = hex ('_'* hex)*;
    binu        = bin ('_'* bin)*;
    mantissau   = decu '.' decu* | decu* '.' decu+;
    expu        = [eE] [-+]? decu;
*/

// Remove underscores
static double parse_float_from_chars(const std::string& s) {
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }
    return std::stod(t);
}

// Remove underscores
static int parse_int_from_chars(const std::string& s, int base) {
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }
    return std::stoul(t, nullptr, base);
}

bool tokenize_line(const std::string& text, SourceType source_type,
                   const SourceLoc& loc,
                   std::vector<Token>& tokens) {
    const char* p = text.c_str();
    const char* limit = p + text.size();
    const char* marker = nullptr;

    auto check_trailing_char = [&]() -> bool {
        if (isalnum(*p) || *p == '_') {
            error(loc, "Invalid character '" + std::string(1, *p));
            return false;
        }
        return true;
    };

    while (*p) {
        Token token;
        token.loc = loc;
collect_token:
        const char* start = p;

        /*!re2c

            *       { error("Unexpected character: " + std::string(1, *p)); break; }

            $       { break; }

            ws+     { token.ws_before += std::string(start, p); goto collect_token; }

            ';'     { if (source_type == SourceType::BASIC) {
                        token.type = TokenType::Semicolon;
                        token.text = std::string(start, p);
                        goto push_token;
                      } else {
                        break; // ignore the rest of the line
                      }
                    }

            "'"     { if (source_type == SourceType::BASIC) {
                        break; // ignore the rest of the line
                      } else {
                        // Char constant
                        std::vector<uint8_t> bytes;
                        if (!encode_zx81_string(p, '\'', bytes, loc)) {
                            break;
                        }
                        p++; // skip closing quote
                        if (bytes.size() != 1) {
                            error(loc, "Char constant must be a single character");
                            break;
                        }
                        token.text = std::string(start, p);
                        token.svalue = std::string(start+1, p-1);
                        token.type = TokenType::CharConstant;
                        goto push_token;
                      }
                    }

            '"'    {    // String literal
                        std::vector<uint8_t> bytes;
                        if (!encode_zx81_string(p, '"', bytes, loc)) {
                            break;
                        }
                        p++; // skip closing quote
                        token.text = std::string(start, p);
                        token.svalue = std::string(start+1, p-1);
                        token.type = TokenType::StringLiteral;
                        goto push_token;
                    }

            '//'    { break; // ignore the rest of the line
                    }

            '#'     { token.type = TokenType::Hash; token.text = std::string(start, p); goto push_token; }
            '$'     { token.type = TokenType::Dollar; token.text = std::string(start, p); goto push_token; }
            '%'     { token.type = TokenType::Percent; token.text = std::string(start, p); goto push_token; }
            '!'     { token.type = TokenType::Exclamation; token.text = std::string(start, p); goto push_token; }
            '&'     { token.type = TokenType::Ampersand; token.text = std::string(start, p); goto push_token; }
            '@'     { token.type = TokenType::At; token.text = std::string(start, p); goto push_token; }
            '('     { token.type = TokenType::LeftParen; token.text = std::string(start, p); goto push_token; }
            ')'     { token.type = TokenType::RightParen; token.text = std::string(start, p); goto push_token; }
            '*'     { token.type = TokenType::Multiply; token.text = std::string(start, p); goto push_token; }
            '**'    { token.type = TokenType::Power; token.text = std::string(start, p); goto push_token; }
            '^'     { token.type = TokenType::Power; token.text = std::string(start, p); goto push_token; }
            '+'     { token.type = TokenType::Plus; token.text = std::string(start, p); goto push_token; }
            ','     { token.type = TokenType::Comma; token.text = std::string(start, p); goto push_token; }
            '-'     { token.type = TokenType::Minus; token.text = std::string(start, p); goto push_token; }
            '/'     { token.type = TokenType::Divide; token.text = std::string(start, p); goto push_token; }
            '\\'    { token.type = TokenType::IntDivide; token.text = std::string(start, p); goto push_token; }
            ':'     { token.type = TokenType::Colon; token.text = std::string(start, p); goto push_token; }
            '='     { token.type = TokenType::Equal; token.text = std::string(start, p); goto push_token; }
            '>'     { token.type = TokenType::Greater; token.text = std::string(start, p); goto push_token; }
            '>='    { token.type = TokenType::GreaterEqual; token.text = std::string(start, p); goto push_token; }
            '<>'    { token.type = TokenType::NotEqual; token.text = std::string(start, p); goto push_token; }
            '<'     { token.type = TokenType::Less; token.text = std::string(start, p); goto push_token; }
            '<='    { token.type = TokenType::LessEqual; token.text = std::string(start, p); goto push_token; }
            '?'     { token.type = TokenType::Question; token.text = std::string(start, p); goto push_token; }

            '!='    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '##'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '&&'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '.'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '<<'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '=='    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '>>'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '['     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            ']'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '^^'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '{'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '|'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '||'    { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '}'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }
            '~'     { token.type = TokenType::AsmOperator; token.text = std::string(start, p); goto push_token; }

        mantissau expu? {
            if (!check_trailing_char()) break;
            token.type = TokenType::Float;
            token.text = std::string(start, p);
            token.nvalue = parse_float_from_chars(token.text);
            goto push_token;
        }

        decu 'd'? {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text, 10);
            goto push_token;
        }

        decu ('_'* hex)* 'h' {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text, 16);
            goto push_token;
        }

        "$" hexu {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text.substr(1), 16);
            goto push_token;
        }

        '0x' hexu {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text.substr(2), 16);
            goto push_token;
        }

        binu 'b' {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text, 2);
            goto push_token;
        }

        [%@] binu {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text.substr(1), 2);
            goto push_token;
        }

        '0b' binu {
            if (!check_trailing_char()) break;
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = parse_int_from_chars(token.text.substr(2), 2);
            goto push_token;
        }

        [%@] '"' [-#]* '"' {
            int value = 0;
            for (const char* i = start + 2; i < p - 1; ++i) {
                value *= 2;
                if (*i == '#') ++value;
            }
            token.type = TokenType::Integer;
            token.text = std::string(start, p);
            token.ivalue = value;
            goto push_token;
        }

        ident {
            if (source_type == SourceType::BASIC && *p == '$') {
                ++p; // include trailing $ in identifier
            }
            token.type = TokenType::Identifier;
            token.text = str_toupper(std::string(start, p));    // BASIC is case insensitive
            token.keyword = lookup_keyword(token.text);
            goto push_token;
        }

        */
push_token:
        tokens.push_back(token);
    }

    return get_error_count() == 0;
}
