//-----------------------------------------------------------------------------
// z80asm - scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "errors.h"
#include "scan.h"
#include "utils.h"
#include "xassert.h"
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
using namespace std;

//-----------------------------------------------------------------------------

/*!re2c
    re2c:define:YYCTYPE     = char;
    re2c:define:YYCURSOR    = p;
    re2c:define:YYMARKER    = marker;
    re2c:indent:top         = 2;
    re2c:yyfill:enable      = 0;

    end 	= "\x00";
    ws		= [ \t\v\f\r\n];
    ident 	= [_a-zA-Z][_a-zA-Z0-9$]*;
    bin		= [0-1];
    oct		= [0-7];
    dec		= [0-9];
    hex		= [0-9a-fA-F];
    mantissa= dec+ '.' dec* | dec* '.' dec+;
    exp		= 'e' [-+]? dec+;
*/

//-----------------------------------------------------------------------------

static int a2i(const char* start, const char* end, int base) {
    return (int)(strtol(string(start, end).c_str(), NULL, base));
}

static double a2f(const char* start, const char* end) {
    return atof(string(start, end).c_str());
}

static string str_swap_xy(string str) {
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

//-----------------------------------------------------------------------------

Keyword keyword_lookup(const string& text) {
    static unordered_map<string, Keyword> keywords = {
#define KW(id, text)    { text, id },
#include "scan.def"
    };

    auto it = keywords.find(str_tolower(text));
    if (it == keywords.end())
        return KW_NONE;
    else
        return it->second;
}

//-----------------------------------------------------------------------------

Token::Token(TkCode code, bool blank_before, int ivalue)
    : code_(code), ivalue_(ivalue), blank_before_(blank_before) {
}

Token::Token(TkCode code, bool blank_before, double fvalue)
    : code_(code), fvalue_(fvalue), blank_before_(blank_before) {
}

Token::Token(TkCode code, bool blank_before, const string& svalue)
    : code_(code), keyword_(keyword_lookup(svalue)), svalue_(svalue)
    , blank_before_(blank_before) {
}

TkCode Token::code() const { return code_; }
Keyword Token::keyword() const { return keyword_; }
int Token::ivalue() const { return ivalue_; }
double Token::fvalue() const { return fvalue_; }
string Token::svalue() const { return svalue_; }
bool Token::blank_before() const { return blank_before_; }

string Token::to_string() const {
    static const char* tokens[] = {
#define TK(id, text)     text,
#include "scan.def"
    };

    switch (code_) {
    case TK_IDENT:
        return svalue_;
    case TK_INTEGER:
        return std::to_string(ivalue_);
    case TK_FLOATING:
        return std::to_string(fvalue_);
    case TK_STRING:
        return c_string(svalue_);
    default:
        return tokens[(int)code_];
    }
}

string Token::to_string(const vector<Token>& tokens) {
    string out;
    for (auto& token : tokens) {
        string str = token.to_string();
        out = concat(out, str);
    }
    return out;
}

string Token::concat(const string& s1, const string& s2) {
    if (s1.empty() || s2.empty())
        return s1 + s2;
    else if (str_ends_with(s1, "##"))   // cpp-style concatenation
        return s1.substr(0, s1.length() - 2) + s2;
    else if (isspace(s1.back()) || isspace(s2.front()))
        return s1 + s2;
    else if (is_ident(s1.back()) && is_ident(s2.front()))
        return s1 + " " + s2;
    else if (s1.back() == '$' && isxdigit(s2.front()))
        return s1 + " " + s2;
    else if ((s1.back() == '%' || s1.back() == '@') &&
        (isdigit(s2.front()) || s2.front() == '"'))
        return s1 + " " + s2;
    else if ((s1.back() == '&' && s2.front() == '&') ||
        (s1.back() == '|' && s2.front() == '|') ||
        (s1.back() == '^' && s2.front() == '^') ||
        (s1.back() == '*' && s2.front() == '*') ||
        (s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
        (s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
        (s1.back() == '=' && s2.front() == '=') ||
        (s1.back() == '!' && s2.front() == '=') ||
        (s1.back() == '#' && s2.front() == '#'))
        return s1 + " " + s2;
    else
        return s1 + s2;
}

string Token::c_string(const string& text) {
    string out = "\"";
    for (auto c : text) {
        switch (c) {
        case '\a': out += "\\a"; break;
        case '\b': out += "\\b"; break;
        case '\f': out += "\\f"; break;
        case '\n': out += "\\n"; break;
        case '\r': out += "\\r"; break;
        case '\t': out += "\\t"; break;
        case '\v': out += "\\v"; break;
        case '\\': out += "\\\\"; break;
        case '"': out += "\\\""; break;
        default:
            if (c >= 0x20 && c < 0x7f)
                out.push_back(c);
            else if ((c & 0xff) < 8)
                out += "\\" + std::to_string(c & 0xff);		// \o
            else {
                std::ostringstream ss;
                ss << "\\x"
                    << std::setfill('0') << std::setw(2)
                    << std::hex << (c & 0xff);
                out += ss.str();
            }
        }
    }
    out += "\"";
    return out;
}

//-----------------------------------------------------------------------------

Lexer::Lexer(const string& text) {
    set_text(text);
}

void Lexer::clear() {
    tokens_.clear();
    pos_ = 0;
}

bool Lexer::set_text(const string& text) {
    clear();
    string str;
    int quote = 0;
    bool raw_strings = g_options.raw_strings();
    bool got_error = false;
    bool blank_before = false;
    const char* p = text.c_str();
    const char* p0 = p;
    const char* pstr = p;
    const char* marker = p;

main_loop:
    while (true) {
        p0 = p;

#define PUSH_TOKEN1(type)       do { tokens_.emplace_back(type, blank_before); \
                                     blank_before = false; } while (0)
#define PUSH_TOKEN2(type, arg)  do { tokens_.emplace_back(type, blank_before, arg); \
                                     blank_before = false; } while (0)
        /*!re2c
            end             { p--; goto end; }
            *               { g_errors.error(ErrInvalidChar, p0); got_error = true; goto end; }
            ws+             { blank_before = true; continue; }
            ';'             { goto end; }
            '#'             { PUSH_TOKEN1(TK_HASH); continue; }
            '##'            { PUSH_TOKEN1(TK_DBLHASH); continue; }
            '\\'            { PUSH_TOKEN1(TK_BACKSLASH); continue; }
            ':'             { PUSH_TOKEN1(TK_COLON); continue; }
            '?'             { PUSH_TOKEN1(TK_QUEST); continue; }
            '"'             { quote = 2; pstr = p0; goto string_loop; }
            "'"             { quote = 1; pstr = p0; goto string_loop; }
            '!'				{ PUSH_TOKEN1(TK_LOGNOT); continue; }
            '$'				{ PUSH_TOKEN1(TK_ASMPC); continue; }
            '%'				{ PUSH_TOKEN1(TK_MOD); continue; }
            '&'				{ PUSH_TOKEN1(TK_BINAND); continue; }
            '&&'			{ PUSH_TOKEN1(TK_LOGAND); continue; }
            '('				{ PUSH_TOKEN1(TK_LPAREN); continue; }
            ')'				{ PUSH_TOKEN1(TK_RPAREN); continue; }
            '*'				{ PUSH_TOKEN1(TK_MULT); continue; }
            '**'			{ PUSH_TOKEN1(TK_POWER); continue; }
            '+'				{ PUSH_TOKEN1(TK_PLUS); continue; }
            ','				{ PUSH_TOKEN1(TK_COMMA); continue; }
            '-'				{ PUSH_TOKEN1(TK_MINUS); continue; }
            '.'				{ PUSH_TOKEN1(TK_DOT); continue; }
            '/'				{ PUSH_TOKEN1(TK_DIV); continue; }
            '<'				{ PUSH_TOKEN1(TK_LT); continue; }
            '<='			{ PUSH_TOKEN1(TK_LE); continue; }
            '<<'			{ PUSH_TOKEN1(TK_LSHIFT); continue; }
            '='  | '=='		{ PUSH_TOKEN1(TK_EQ); continue; }
            '!=' | '<>'		{ PUSH_TOKEN1(TK_NE); continue; }
            '>'				{ PUSH_TOKEN1(TK_GT); continue; }
            '>='			{ PUSH_TOKEN1(TK_GE); continue; }
            '>>'			{ PUSH_TOKEN1(TK_RSHIFT); continue; }
            '['				{ PUSH_TOKEN1(TK_LSQUARE); continue; }
            ']'				{ PUSH_TOKEN1(TK_RSQUARE); continue; }
            '^'				{ PUSH_TOKEN1(TK_BINXOR); continue; }
            '^^'			{ PUSH_TOKEN1(TK_LOGXOR); continue; }
            '{'				{ PUSH_TOKEN1(TK_LBRACE); continue; }
            '|'				{ PUSH_TOKEN1(TK_BINOR); continue; }
            '||'			{ PUSH_TOKEN1(TK_LOGOR); continue; }
            '}'				{ PUSH_TOKEN1(TK_RBRACE); continue; }
            '~'				{ PUSH_TOKEN1(TK_BINNOT); continue; }

            mantissa exp? 	{ PUSH_TOKEN2(TK_FLOATING, a2f(p0, p)); continue; }
            dec+ 'd'?		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0, p, 10)); continue; }
            dec hex* 'h'	{ PUSH_TOKEN2(TK_INTEGER, a2i(p0, p, 16)); continue; }
            "$" hex+		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0+1, p, 16)); continue; }
            '0x' hex+		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0+2, p, 16)); continue; }
            bin+ 'b'		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0, p, 2)); continue; }
            [%@] bin+		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0+1, p, 2)); continue; }
            '0b' bin+		{ PUSH_TOKEN2(TK_INTEGER, a2i(p0+2, p, 2)); continue; }

            [%@] '"' [-#]* '"' {
                              int n = 0;
                              for (const char* i = p0+2; i < p-1; i++) {
                                  n *= 2;
                                  if (*i == '#') n++;
                              }
                              PUSH_TOKEN2(TK_INTEGER, n);
                              continue;
                            }

            ident "'"?      { str = string(p0, p);

                              // to upper
                              if (g_options.upper_case()) str = str_toupper(str);

                              // handle af' et all
                              Keyword keyword = keyword_lookup(str);
                              if (str.back() == '\'' && keyword == KW_NONE) { // drop quote
                                  str.pop_back();
                                  p--;
                                  keyword = keyword_lookup(str);
                              }

                              // check for -IXIY
                              if (g_options.swap_ixiy() != IXIY_NO_SWAP) {
                                  switch (keyword) {
                                  case KW_IX: case KW_IXH: case KW_IXL:
                                  case KW_IY: case KW_IYH: case KW_IYL:
                                      str = str_swap_xy(str);
                                      keyword = keyword_lookup(str);
                                      break;
                                  default:;
                                  }
                              }

                              // check for .ASSUME
                              if (keyword == KW_ASSUME && !tokens_.empty() && tokens_.back().code() == TK_DOT)
                                  tokens_.pop_back();       // remove '.'

                              // need raw strings after INCLUDE, BINARY, INCBIN, LINE, C_LINE
                              switch (keyword) {
                              case KW_INCLUDE: case KW_BINARY: case KW_INCBIN:
                              case KW_LINE:    case KW_C_LINE:
                                  raw_strings = true;
                                  break;
                              default:;
                              }

                              // check for ASMPC
                              if (keyword == KW_ASMPC)
                                  PUSH_TOKEN1(TK_ASMPC);
                              else
                                  PUSH_TOKEN2(TK_IDENT, str);

                              continue;
                            }
        */
    }

string_loop:
    str.clear();
    while (true) {
        p0 = p;

#define PUSH_CHAR(c)        do { if (raw_strings) { str.push_back(*p0); p = p0+1; } \
                                 else { str.push_back( (c) & 0xff ); } } while (0)

        /*!re2c
            end             { p--; g_errors.error(ErrMissingQuote, pstr); got_error = true; goto end; }
            *               { str.push_back(*p0); continue; }
            '"'             { if (quote == 2) {
                                  PUSH_TOKEN2(TK_STRING, str);
                                  goto main_loop;
                              }
                              else {
                                  str.push_back(*p0);
                                  continue;
                              }
                            }
            "'"             { if (quote == 1) {
                                  if (str.length() != 1) {
                                      g_errors.error(ErrInvalidCharConst, pstr); got_error = true; goto end;
                                  }
                                  else {
                                      PUSH_TOKEN2(TK_INTEGER, str[0]);
                                      goto main_loop;
                                  }
                              }
                              else {
                                  str.push_back(*p0);
                                  continue;
                              }
                            }
            '\\' "a"        { PUSH_CHAR('\a'); continue; }
            '\\' "b"        { PUSH_CHAR('\b'); continue; }
            '\\' "e"        { PUSH_CHAR('\x1b'); continue; }
            '\\' "f"        { PUSH_CHAR('\f'); continue; }
            '\\' "n"        { PUSH_CHAR('\n'); continue; }
            '\\' "r"        { PUSH_CHAR('\r'); continue; }
            '\\' "t"        { PUSH_CHAR('\t'); continue; }
            '\\' "v"        { PUSH_CHAR('\v'); continue; }
            '\\' oct{1,3}   { PUSH_CHAR(a2i(p0+1, p, 8)); continue; }
            '\\' "x" hex{1,2} { PUSH_CHAR(a2i(p0+2, p, 16)); continue; }
            '\\' .          { PUSH_CHAR(p0[1]); continue; }
        */
    }

end:
    if (got_error)
        clear();
    return !got_error;
}

string Lexer::text() const {
    return Token::to_string(tokens_);
}

string Lexer::peek_text(int idx) const {
    vector<Token> pending_tokens;
    for (int i = pos_ + idx; i < (int)tokens_.size(); i++)
        if (i >= 0)
            pending_tokens.push_back(tokens_[i]);
    return Token::to_string(pending_tokens);
}

const Token& Lexer::peek(int idx) {
    static const Token end{ TK_END, false };
    int i = pos_ + idx;
    if (i >= 0 && i < (int)tokens_.size())
        return tokens_[i];
    else
        return end;
}

void Lexer::next(int n) {
    pos_ += n;
}

bool Lexer::at_end() const {
    return pos_ >= (int)tokens_.size();
}

void Lexer::flush() {
    pos_ = (int)tokens_.size();
}

Symbol* Token::symbol() const {
    xassert(symbol_);
    return symbol_;
}

void Token::set_code(TkCode code) {
    code_ = code;
}

void Token::set_ivalue(int ivalue) {
    ivalue_ = ivalue;
}

void Token::set_fvalue(double fvalue) {
    fvalue_ = fvalue;
}

void Token::set_svalue(const string& svalue) {
    svalue_ = svalue;
    keyword_ = keyword_lookup(svalue_);
}

void Token::set_symbol(Symbol* symbol) {
    symbol_ = symbol;
}
