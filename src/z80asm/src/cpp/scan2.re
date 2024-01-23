//-----------------------------------------------------------------------------
// z80asm
// scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "scan2.h"
#include "utils1.h"
#include <unordered_map>
#include <cassert>
#include <cmath>
using namespace std;

//-----------------------------------------------------------------------------

/*!re2c
    re2c:define:YYCTYPE     = char;
    re2c:define:YYCURSOR    = p;
    re2c:define:YYLIMIT     = limit;
    re2c:define:YYMARKER    = marker;
    re2c:define:YYFILL      = "yyfill";
    re2c:eof                = 0;
    re2c:indent:top         = 2;

    end 	= "\x00";
    ws		=  [ \t\v\f];
    nl		= "\r\n"|"\r"|"\n";
    ident 	= [_a-zA-Z][_a-zA-Z0-9]*;
    bin		= [0-1];
    oct		= [0-7];
    dec		= [0-9];
    hex		= [0-9a-fA-F];
    mantissa= dec+ '.' dec* | dec* '.' dec+;
    exp		= 'e' [-+]? dec+;
*/

/*!max:re2c*/
#define FILL_SIZE (8*1024)

//-----------------------------------------------------------------------------

static int a2i(const char* start, const char* end, int base) {
    return static_cast<int>(strtol(string(start, end).c_str(), NULL, base));
}

static double a2f(const char* start, const char* end) {
    return atof(string(start, end).c_str());
}

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

//-----------------------------------------------------------------------------

static int keyword_flags[] = {
#define X(id, text, flags)		flags,
#include "keyword.def"
};

Keyword1 keyword_lookup1(const string& text) {
    static unordered_map<string, Keyword1> keywords = {
#define X(id, text, flags)      { text, Keyword1::id },
#include "keyword.def"
    };

    auto it = keywords.find(str_tolower(text));
    if (it == keywords.end())
        return Keyword1::None;
    else
        return it->second;
}

bool keyword_is_reg_8(Keyword1 keyword) {
    return keyword_flags[static_cast<int>(keyword)] & KW_REG_8;
}

bool keyword_is_reg_ix_iy(Keyword1 keyword) {
    return keyword_flags[static_cast<int>(keyword)] & KW_REG_IX_IY;
}

bool keyword_is_z80_ld_bit(Keyword1 keyword) {
    return keyword_flags[static_cast<int>(keyword)] & KW_Z80_LD_BIT;
}

//-----------------------------------------------------------------------------

Token1::Token1(TType1 type, bool blank_before, int ivalue)
    : m_type(type), m_blank_before(blank_before), m_ivalue(ivalue), m_keyword(Keyword1::None) {
}

Token1::Token1(TType1 type, bool blank_before, double fvalue)
    : m_type(type), m_blank_before(blank_before), m_fvalue(fvalue), m_keyword(Keyword1::None) {
}

Token1::Token1(TType1 type, bool blank_before, const string& svalue)
    : m_type(type), m_blank_before(blank_before), m_svalue(svalue) {
    m_keyword = keyword_lookup1(svalue);
}

string Token1::to_string() const {
    static string tokens[] = {
#define X(id, text)     text,
#include "scan2.def"
    };

    switch (m_type) {
    case TType1::Ident:
        return m_svalue;
    case TType1::Integer:
        return std::to_string(m_ivalue);
    case TType1::Floating:
        return std::to_string(m_fvalue);
    case TType1::String:
        return string_bytes(m_svalue);
    default:
        return tokens[static_cast<int>(m_type)];
    }
}

string Token1::to_string(const vector<Token1>& tokens) {
    string out = "";
    for (auto& token : tokens) {
        out = concat(out, token.to_string());
    }
    return out;
}

string Token1::string_bytes(const string& text) {
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
                out += "\\" + std::to_string(c);			// \o
            else {
                std::ostringstream ss;
                ss << "\\x"
                    << std::setfill('0') << std::setw(2)
                    << std::hex << static_cast<unsigned int>(c & 0xff) << std::dec;
                out += ss.str();
            }
        }
    }
    out += "\"";
    return out;
}

string Token1::concat(const string& s1, const string& s2) {
    if (s1.empty() || s2.empty())
        return s1 + s2;
    else if (str_ends_with(s1, "##"))   // cpp-style concatenation
        return s1.substr(0, s1.length() - 2) + s2;
    else if (is_space(s1.back()) || is_space(s2.front()))
        return s1 + s2;
    else if (is_ident(s1.back()) && is_ident(s2.front()))
        return s1 + " " + s2;
    else if (s1.back() == '$' && is_xdigit(s2.front()))
        return s1 + " " + s2;
    else if ((s1.back() == '%' || s1.back() == '@') &&
        (is_digit(s2.front()) || s2.front() == '"'))
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

//-----------------------------------------------------------------------------

ScannedLine::ScannedLine(const string& text, const vector<Token1>& tokens)
    : m_text(text), m_pos(0) {
    std::copy(tokens.begin(), tokens.end(), std::back_inserter(m_tokens));
}

void ScannedLine::append(const ScannedLine& other) {
    m_text = Token1::concat(m_text, other.text());
    std::copy(other.tokens().begin(), other.tokens().end(), std::back_inserter(m_tokens));
}

void ScannedLine::append(const vector<Token1>& tokens) {
    ScannedLine other{ Token1::to_string(tokens), tokens };
    append(other);
}

void ScannedLine::clear() {
    m_text.clear();
    m_tokens.clear();
    m_pos = 0;
}

Token1& ScannedLine::peek(int offset) {
    static Token1 end{ TType1::End, false };
    unsigned index = m_pos + offset;
    if (index >= m_tokens.size())
        return end;
    else
        return m_tokens[index];
}

void ScannedLine::next(int n) {
    m_pos += n;
    if (m_pos > m_tokens.size())
        m_pos = static_cast<unsigned>(m_tokens.size());
}

vector<Token1> ScannedLine::peek_tokens(int offset) {
    vector<Token1> out;
    unsigned index = m_pos + offset;
    for (unsigned i = index; i < m_tokens.size(); i++)
        out.push_back(m_tokens[i]);
    return out;
}

string ScannedLine::peek_text(int offset) {
    vector<Token1> out = peek_tokens(offset);
    return Token1::to_string(out);
}

//-----------------------------------------------------------------------------

FileScanner::FileScanner() {
    line_start = line_end = p = p0 = marker = limit = m_buffer.c_str();
}

bool FileScanner::open(const string& filename) {
    m_got_eof = true;
    m_buffer.clear();
    line_start = line_end = p = p0 = marker = limit = m_buffer.c_str();

    if (!fs::is_regular_file(fs::path(filename))) {
        g_errors.error(Errors::Code::file_not_found, filename);
        return false;
    }
    else {
        m_ifs.open(filename, ios::binary);
        if (!m_ifs.is_open()) {
            g_errors.os_error(Errors::Code::file_open, filename);
            return false;
        }
        else {
            m_filename = filename;
            m_location = Location(filename);
            m_got_eof = false;
            fill();
            return true;
        }
    }
}

void FileScanner::scan_text(Location location, const string& text) {
    if (m_ifs.is_open())
        m_ifs.close();
    m_filename = location.filename;
    m_location = location;
    m_buffer = text;
    line_start = line_end = p = p0 = marker = m_buffer.c_str();
    limit = m_buffer.c_str() + m_buffer.size();
    m_got_error = false;
    m_got_eof = true;
}

bool FileScanner::get_text_line(ScannedLine& line) {
    line.clear();
    if (peek_text_line(line)) {
        line_start = p0 = marker = p = line_end;
        return true;
    }
    else
        return false;
}

bool FileScanner::peek_text_line(ScannedLine& line) {
    p = p0 = marker = line_end = line_start;

    while (true) {
        /*!re2c
            end             { p--; goto end; }
            nl              { m_location.inc_line_num(); goto end; }
            $               { goto end; }
            *               { continue; }
        */
    }

end:
    if (p > line_start) {
        line_end = p;
        p = p0 = marker = line_start;
        string text = string(line_start, line_end);
        line.set_text(text);
        notify_new_line(text);
        return true;
    }
    else {
        return false;
    }
}

bool FileScanner::get_token_line(ScannedLine& line) {
    line.clear();
    string str, error;
    int quote = 0;
    bool raw_strings = g_args.opt_raw_strings;
    m_got_error = false;
    m_blank_before = false;

    peek_text_line(line);
    p = p0 = marker = line_end = line_start;

main_loop:
    while (true) {
        p0 = p;

#define PUSH_TOKEN1(type)       do { line.tokens().emplace_back(type, m_blank_before); \
                                     m_blank_before = false; } while (0)
#define PUSH_TOKEN2(type, arg)  do { line.tokens().emplace_back(type, m_blank_before, arg); \
                                     m_blank_before = false; } while (0)
        /*!re2c
            end             { p--; goto end; }
            $               { goto end; }
            *               { error_invalid_character(); continue; }
            ws+             { m_blank_before = true; continue; }
            nl              { goto end; }
            ';'	[^\r\n\000]* { continue; }
            '#'             { PUSH_TOKEN1(TType1::Hash); continue; }
            '##'            { PUSH_TOKEN1(TType1::DblHash); continue; }
            '\\' nl         { line_start = p; peek_text_line(line); continue; }
            '\\'            { PUSH_TOKEN1(TType1::Backslash); continue; }
            ':'             { PUSH_TOKEN1(TType1::Colon); continue; }
            '?'             { PUSH_TOKEN1(TType1::Quest); continue; }
            '"'             { quote = 2; goto string_loop; }
            "'"             { quote = 1; goto string_loop; }
            '!'				{ PUSH_TOKEN1(TType1::LogNot); continue; }
            '$'				{ PUSH_TOKEN1(TType1::ASMPC); continue; }
            '%'				{ PUSH_TOKEN1(TType1::Mod); continue; }
            '&'				{ PUSH_TOKEN1(TType1::BinAnd); continue; }
            '&&'			{ PUSH_TOKEN1(TType1::LogAnd); continue; }
            '('				{ PUSH_TOKEN1(TType1::LParen); continue; }
            ')'				{ PUSH_TOKEN1(TType1::RParen); continue; }
            '*'				{ PUSH_TOKEN1(TType1::Mult); continue; }
            '**'			{ PUSH_TOKEN1(TType1::Power); continue; }
            '+'				{ PUSH_TOKEN1(TType1::Plus); continue; }
            ','				{ PUSH_TOKEN1(TType1::Comma); continue; }
            '-'				{ PUSH_TOKEN1(TType1::Minus); continue; }
            '.'				{ PUSH_TOKEN1(TType1::Dot); continue; }
            '/'				{ PUSH_TOKEN1(TType1::Div); continue; }
            '<'				{ PUSH_TOKEN1(TType1::Lt); continue; }
            '<='			{ PUSH_TOKEN1(TType1::Le); continue; }
            '<<'			{ PUSH_TOKEN1(TType1::LShift); continue; }
            '='  | '=='		{ PUSH_TOKEN1(TType1::Eq); continue; }
            '!=' | '<>'		{ PUSH_TOKEN1(TType1::Ne); continue; }
            '>'				{ PUSH_TOKEN1(TType1::Gt); continue; }
            '>='			{ PUSH_TOKEN1(TType1::Ge); continue; }
            '>>'			{ PUSH_TOKEN1(TType1::RShift); continue; }
            '['				{ PUSH_TOKEN1(TType1::LSquare); continue; }
            ']'				{ PUSH_TOKEN1(TType1::RSquare); continue; }
            '^'				{ PUSH_TOKEN1(TType1::BinXor); continue; }
            '^^'			{ PUSH_TOKEN1(TType1::LogXor); continue; }
            '{'				{ PUSH_TOKEN1(TType1::LBrace); continue; }
            '|'				{ PUSH_TOKEN1(TType1::BinOr); continue; }
            '||'			{ PUSH_TOKEN1(TType1::LogOr); continue; }
            '}'				{ PUSH_TOKEN1(TType1::RBrace); continue; }
            '~'				{ PUSH_TOKEN1(TType1::BinNot); continue; }

            mantissa exp? 	{ PUSH_TOKEN2(TType1::Floating, a2f(p0, p)); continue; }
            dec+ 'd'?		{ PUSH_TOKEN2(TType1::Integer, a2i(p0, p, 10)); continue; }
            dec hex* 'h'	{ PUSH_TOKEN2(TType1::Integer, a2i(p0, p, 16)); continue; }
            "$" hex+		{ PUSH_TOKEN2(TType1::Integer, a2i(p0+1, p, 16)); continue; }
            '0x' hex+		{ PUSH_TOKEN2(TType1::Integer, a2i(p0+2, p, 16)); continue; }
            bin+ 'b'		{ PUSH_TOKEN2(TType1::Integer, a2i(p0, p, 2)); continue; }
            [%@] bin+		{ PUSH_TOKEN2(TType1::Integer, a2i(p0+1, p, 2)); continue; }
            '0b' bin+		{ PUSH_TOKEN2(TType1::Integer, a2i(p0+2, p, 2)); continue; }

            [%@] '"' [-#]* '"' {
                              int n = 0;
                              for (const char* i = p0+2; i < p-1; i++) {
                                  n *= 2;
                                  if (*i == '#') n++;
                              }
                              PUSH_TOKEN2(TType1::Integer, n);
                              continue;
                            }

            ident "'"?      { str = string(p0, p);

                              // to upper
                              if (g_args.opt_ucase) str = str_toupper(str);

                              // handle af' et all
                              Keyword1 keyword = keyword_lookup1(str);
                              if (str.back() == '\'' && keyword == Keyword1::None) { // drop quote
                                str.pop_back();
                                p--;
                                keyword = keyword_lookup1(str);
                              }

                              // check for -IXIY
                              if (g_args.opt_swap_ixiy != SwapIXIY::no_swap) {
                                switch (keyword) {
                                case Keyword1::IX: case Keyword1::IXH: case Keyword1::IXL:
                                case Keyword1::IY: case Keyword1::IYH: case Keyword1::IYL:
                                  str = str_swap_x_y(str);
                                  keyword = keyword_lookup1(str);
                                  break;
                                default:;
                                }
                              }

                              // check for .ASSUME
                              if (keyword == Keyword1::ASSUME && !line.tokens().empty() &&
                                  line.tokens().back().is(TType1::Dot))
                                line.tokens().pop_back();       // remove '.'

                              // need raw strings after INCLUDE, BINARY, INCBIN, LINE, C_LINE
                              switch (keyword) {
                              case Keyword1::INCLUDE: case Keyword1::BINARY: case Keyword1::INCBIN:
                              case Keyword1::LINE:    case Keyword1::C_LINE:
                                raw_strings = true;
                                break;
                              default:;
                              }

                              // check for ASMPC
                              if (keyword == Keyword1::ASMPC)
                                PUSH_TOKEN1(TType1::ASMPC);
                              else
                                PUSH_TOKEN2(TType1::Ident, str);
                              continue;
                            }
        */
    }

string_loop:
    str.clear();
    error.clear();
    while (true) {
        p0 = p;
        /*!re2c
            end             { p--; error_missing_quote(error); goto end; }
            $               { error_missing_quote(error); goto end; }
            *               { str.push_back(*p0); continue; }
            nl              { if (raw_strings) {
                                str.append(string(p0, p));
                                error = string("started at ") + string(m_location.filename) +
                                        ":" + std::to_string(m_location.line_num);
                                line_start = p; peek_text_line(line);
                                continue;
                              }
                              else {
                                error_missing_quote(error); goto end;
                              }
                            }
            '"'             { if (quote == 2) {
                                PUSH_TOKEN2(TType1::String, str);
                                goto main_loop;
                              }
                              else {
                                str.push_back(*p0);
                                continue;
                              }
                            }
            "'"             { if (quote == 1) {
                                if (str.length() != 1) {
                                  error_invalid_character_constant();
                                  goto main_loop;
                                }
                                else {
                                  PUSH_TOKEN2(TType1::Integer, str[0]);
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
    if (p > line_start) {
        if (m_got_error)
            line.tokens().clear();

        PUSH_TOKEN1(TType1::Newline);
        line_start = line_end = p0 = marker = p;
        return true;
    }
    else
        return false;
}

bool FileScanner::fill() {
    if (m_got_eof)
        return false;
    else {
        // save indexes
        size_t line_start_index = line_start - m_buffer.c_str();
        size_t line_end_index = line_end - m_buffer.c_str();
        size_t p_index = p - m_buffer.c_str();
        size_t p0_index = p0 - m_buffer.c_str();
        size_t marker_index = marker - m_buffer.c_str();

        // remove all before line_start
        m_buffer.erase(m_buffer.begin(), m_buffer.begin() + line_start_index);

        // adjust indices
        line_end_index -= line_start_index;
        p_index -= line_start_index;
        p0_index -= line_start_index;
        line_start_index = 0;

        // read from file
        size_t cur_size = m_buffer.size();
        m_buffer.resize(cur_size + FILL_SIZE + YYMAXFILL);      // reserve extra YYMAXFILL for re2c
        m_ifs.read(&m_buffer[cur_size], FILL_SIZE);
        m_buffer.resize(cur_size + m_ifs.gcount());

        // check for end of file
        if (m_ifs.gcount() < FILL_SIZE) {     // got to the end of file
            m_got_eof = true;
            if (!m_buffer.empty() && !is_eol(m_buffer.back()))
                m_buffer.push_back('\n');       // add missing newline
            m_buffer.push_back('\n');           // read a blank line at the end
        }

        // adjust pointers
        line_start = m_buffer.c_str() + line_start_index;
        line_end = m_buffer.c_str() + line_end_index;
        p = m_buffer.c_str() + p_index;
        p0 = m_buffer.c_str() + p0_index;
        marker = m_buffer.c_str() + marker_index;
        limit = m_buffer.c_str() + m_buffer.size();

        return true;
    }
}

void FileScanner::notify_new_line(const string& text_) {
    string text = str_chomp(text_) + "\n";
    g_errors.source_line = text;
    g_errors.expanded_line.clear();
    g_errors.location = m_location;
    list_got_source_line(m_location.filename.c_str(), m_location.line_num,
        g_errors.source_line.c_str());
}
