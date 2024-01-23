//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "scan_re.h"
#include "z80asm.h"
using namespace std;

//-----------------------------------------------------------------------------

/*!re2c
    re2c:define:YYCTYPE     = char;
    re2c:define:YYCURSOR    = p;
    re2c:define:YYLIMIT     = limit;
    re2c:define:YYMARKER    = marker;
    re2c:yyfill:enable      = 0;
    re2c:indent:top         = 2;

    end 	= "\x00";
    ws		= [ \t\r\n\v\f];
    ident 	= [_a-zA-Z][_$a-zA-Z0-9]*;
    bin		= [0-1];
    oct		= [0-7];
    dec		= [0-9];
    hex		= [0-9a-fA-F];
    mantissa= dec+ '.' dec* | dec* '.' dec+;
    exp		= 'e' [-+]? dec+;
*/

/*!max:re2c*/

//-----------------------------------------------------------------------------

#if 0
static int a2i(const char* start, const char* end, int base) {
    return static_cast<int>(strtol(string(start, end).c_str(), NULL, base));
}
#endif

#if 0
static double a2f(const char* start, const char* end) {
    return atof(string(start, end).c_str());
}
#endif

#if 0
static string str_swap_x_y(string str) {
    for (auto& c : str) {
        switch (c) {
        case 'x': c = 'y'; break;
        case 'X': c = 'Y'; break;
        case 'y': c = 'x'; break;
        case 'Y': c = 'X'; break;
        default:;
        }
    }
    return str;
}
#endif

//-----------------------------------------------------------------------------
// Tokens
//-----------------------------------------------------------------------------

#if 0
Tokens::Tokens(const string& text) {
    string str;
    int quote = 0;
    bool raw_strings = g_args.opt_raw_strings;
    is_ok = true;
    bool blank_before = false;
    const char* p = text.c_str(), * p0 = p, * marker = p;

main_loop:
    while (true) {
        p0 = p;

#define PUSH_TOKEN1(ttype)          do { m_tokens.emplace_back(ttype, blank_before); \
                                         blank_before = false; } while (0)
#define PUSH_TOKEN2(ttype, arg)     do { m_tokens.emplace_back(ttype, blank_before, arg); \
                                         blank_before = false; } while (0)
#define PUSH_TOKEN3(ttype, arg1, arg2) \
                                    do { m_tokens.emplace_back(ttype, blank_before, arg1, arg2); \
                                         blank_before = false; } while (0)
#define ERROR(...)                  do { g_errors.error(__VA_ARGS__); \
                                         is_ok = false; } while (0)
        /*!re2c
            end             { p--; goto end; }
            *               { p--; string error_char(1, *p);
                              ERROR(Errors::Code::invalid_character,
                                        (*p > 32 && *p < 127) ? error_char :
                                        int_to_hex(*p & 0xff, 2));
                              goto end; }
            ws+             { blank_before = true; continue; }
            ';'             { goto end; }
            '#'             { PUSH_TOKEN1(TType::Hash); continue; }
            '##'            { PUSH_TOKEN1(TType::DblHash); continue; }
            '\\'            { PUSH_TOKEN1(TType::Backslash); continue; }
            ':'             { PUSH_TOKEN1(TType::Colon); continue; }
            '?'             { PUSH_TOKEN1(TType::Quest); continue; }
            '"'             { quote = 2; goto string_loop; }
            "'"             { quote = 1; goto string_loop; }
            '!'				{ PUSH_TOKEN1(TType::LogNot); continue; }
            '$'				{ PUSH_TOKEN1(TType::Dollar); continue; }
            '%'				{ PUSH_TOKEN1(TType::Mod); continue; }
            '&'				{ PUSH_TOKEN1(TType::BinAnd); continue; }
            '&&'			{ PUSH_TOKEN1(TType::LogAnd); continue; }
            '('				{ PUSH_TOKEN1(TType::LParen); continue; }
            ')'				{ PUSH_TOKEN1(TType::RParen); continue; }
            '*'				{ PUSH_TOKEN1(TType::Mult); continue; }
            '**'			{ PUSH_TOKEN1(TType::Power); continue; }
            '+'				{ PUSH_TOKEN1(TType::Plus); continue; }
            ','				{ PUSH_TOKEN1(TType::Comma); continue; }
            '-'				{ PUSH_TOKEN1(TType::Minus); continue; }
            '.'				{ PUSH_TOKEN1(TType::Dot); continue; }
            '/'				{ PUSH_TOKEN1(TType::Div); continue; }
            '<'				{ PUSH_TOKEN1(TType::Lt); continue; }
            '<='			{ PUSH_TOKEN1(TType::Le); continue; }
            '<<'			{ PUSH_TOKEN1(TType::LShift); continue; }
            '='  | '=='		{ PUSH_TOKEN1(TType::Eq); continue; }
            '!=' | '<>'		{ PUSH_TOKEN1(TType::Ne); continue; }
            '>'				{ PUSH_TOKEN1(TType::Gt); continue; }
            '>='			{ PUSH_TOKEN1(TType::Ge); continue; }
            '>>'			{ PUSH_TOKEN1(TType::RShift); continue; }
            '['				{ PUSH_TOKEN1(TType::LSquare); continue; }
            ']'				{ PUSH_TOKEN1(TType::RSquare); continue; }
            '^'				{ PUSH_TOKEN1(TType::BinXor); continue; }
            '^^'			{ PUSH_TOKEN1(TType::LogXor); continue; }
            '{'				{ PUSH_TOKEN1(TType::LBrace); continue; }
            '|'				{ PUSH_TOKEN1(TType::BinOr); continue; }
            '||'			{ PUSH_TOKEN1(TType::LogOr); continue; }
            '}'				{ PUSH_TOKEN1(TType::RBrace); continue; }
            '~'				{ PUSH_TOKEN1(TType::BinNot); continue; }

            mantissa exp? 	{ PUSH_TOKEN2(TType::Floating, a2f(p0, p)); continue; }
            dec+ 'd'?		{ PUSH_TOKEN2(TType::Integer, a2i(p0, p, 10)); continue; }
            dec hex* 'h'	{ PUSH_TOKEN2(TType::Integer, a2i(p0, p, 16)); continue; }
            "$" hex+		{ PUSH_TOKEN2(TType::Integer, a2i(p0+1, p, 16)); continue; }
            '0x' hex+		{ PUSH_TOKEN2(TType::Integer, a2i(p0+2, p, 16)); continue; }
            bin+ 'b'		{ PUSH_TOKEN2(TType::Integer, a2i(p0, p, 2)); continue; }
            [%@] bin+		{ PUSH_TOKEN2(TType::Integer, a2i(p0+1, p, 2)); continue; }
            '0b' bin+		{ PUSH_TOKEN2(TType::Integer, a2i(p0+2, p, 2)); continue; }

            [%@] '"' [-#]* '"' {
                              int n = 0;
                              for (const char* i = p0+2; i < p-1; i++) {
                                  n *= 2;
                                  if (*i == '#') n++;
                              }
                              PUSH_TOKEN2(TType::Integer, n);
                              continue;
                            }

            ident "'"?      { str = string(p0, p);

                              // to upper
                              if (g_args.opt_ucase)
                                  str = str_toupper(str);

                              // handle af' et all
                              Keyword keyword = keyword_lookup(str);
                              if (str.back() == '\'' && keyword == Keyword::None) { // drop quote
                                  str.pop_back();
                                  p--;
                                  keyword = keyword_lookup(str);
                              }

                              // check for -IXIY
                              if (g_args.opt_swap_ixiy != SwapIXIY::no_swap) {
                                  switch (keyword) {
                                  case Keyword::IX: case Keyword::IXH: case Keyword::IXL:
                                  case Keyword::IY: case Keyword::IYH: case Keyword::IYL:
                                      str = str_swap_x_y(str);
                                      keyword = keyword_lookup(str);
                                      break;
                                  default:;
                                  }
                              }

                              // check for .ASSUME
                              if (keyword == Keyword::ASSUME && !m_tokens.empty() &&
                                  m_tokens.back().ttype  == TType::Dot)
                                  m_tokens.pop_back();       // remove '.'

                              // need raw strings after INCLUDE, BINARY, INCBIN, LINE, C_LINE
                              switch (keyword) {
                              case Keyword::INCLUDE: case Keyword::BINARY: case Keyword::INCBIN:
                              case Keyword::LINE:    case Keyword::C_LINE:
                                raw_strings = true;
                                break;
                              default:;
                              }

                              // check for ASMPC
                              if (keyword == Keyword::ASMPC)
                                PUSH_TOKEN1(TType::Dollar);
                              else
                                PUSH_TOKEN3(TType::Ident, str, keyword);
                              continue;
                            }
        */
    }

string_loop:
    str.clear();
    while (true) {
        p0 = p;
        /*!re2c
            end             { p--; ERROR(Errors::Code::missing_quote); goto end; }
            *               { str.push_back(*p0); continue; }
            '"'             { if (quote == 2) {
                                PUSH_TOKEN2(TType::String, str);
                                goto main_loop;
                              }
                              else {
                                str.push_back(*p0);
                                continue;
                              }
                            }
            "'"             { if (quote == 1) {
                                if (str.length() != 1) {
                                  ERROR(Errors::Code::invalid_character_constant);
                                  goto main_loop;
                                }
                                else {
                                  PUSH_TOKEN2(TType::Integer, str[0]);
                                  goto main_loop;
                                }
                              }
                              else {
                                str.push_back(*p0);
                                continue;
                              }
                            }
            '\\' "a"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\a'); } continue; }
            '\\' "b"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\b'); } continue; }
            '\\' "e"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\x1b'); } continue; }
            '\\' "f"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\f'); } continue; }
            '\\' "n"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\n'); } continue; }
            '\\' "r"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\r'); } continue; }
            '\\' "t"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\t'); } continue; }
            '\\' "v"        { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back('\v'); } continue; }
            '\\' oct{1,3}   { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back(a2i(p0+1, p, 8)); } continue; }
            '\\' "x" hex{1,2} { if (raw_strings) { str.push_back(*p0); p = p0+1; }
                              else { str.push_back(a2i(p0+2, p, 16)); } continue; }
            '\\' .          { if (raw_strings) {
                                str.push_back(*p0); p--;
                              }
                              else {
                                str.push_back(p0[1]);
                              }
                              continue;
                            }
        */
    }

end:
    if (!is_ok)
        m_tokens.clear();
}

Tokens::Tokens(const vector<Token>& tokens)
    : m_tokens(tokens) {
}

Token& Tokens::operator[](int offset) {
    static Token end{ TType::End, false };
    size_t index = pos + offset;
    if (index >= m_tokens.size())
        return end;
    else
        return m_tokens[index];
}

void Tokens::clear() {
    pos = 0;
    is_ok = true;
    m_tokens.clear();
}

void Tokens::push_back(const string& text) {
    Tokens other = Tokens(text);
    m_tokens.insert(m_tokens.end(), other.cbegin(), other.cend());
}

void Tokens::push_back(const Tokens& other) {
    m_tokens.insert(m_tokens.end(), other.cbegin(), other.cend());
}

string Tokens::to_string() const {
    string out;
    for (auto& token : m_tokens) {
        if (token.blank_before)
            out += " ";
        out = concat(out, token.to_string());
    }
    return out;
}

Tokens Tokens::peek_tokens(int offset) {
    size_t start = pos + offset;
    if (static_cast<size_t>(start) >= m_tokens.size())
        return Tokens();
    else {
        vector<Token> tokens;
        tokens.insert(tokens.end(), m_tokens.begin() + start, m_tokens.end());
        return Tokens(tokens);
    }
}

string to_string(const Tokens& tokens) {
    return tokens.to_string();
}

#endif
