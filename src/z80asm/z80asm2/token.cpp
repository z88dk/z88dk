//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "options.h"
#include "token.h"
#include "utils.h"
#include <unordered_map>
using namespace std;

string to_string(TType ttype) {
    static unordered_map<TType, string> ttypes = {
        //@@BEGIN: ttype_text
        { TType::ASMPC, "$" },
        { TType::ASSIGN_LIST, "" },
        { TType::BACKSLASH, "\\" },
        { TType::BYTE_LIST, "" },
        { TType::COLON, ":" },
        { TType::COMMA, "," },
        { TType::CONST_ASSIGN_LIST, "" },
        { TType::CONST_EXPR, "" },
        { TType::CONST_EXPR_IF, "" },
        { TType::DHASH, "##" },
        { TType::DOT, "." },
        { TType::END, "" },
        { TType::EXPR, "" },
        { TType::EXPR_LIST, "" },
        { TType::FLOAT, "" },
        { TType::HASH, "#" },
        { TType::IDENT, "" },
        { TType::IDENT_LIST, "" },
        { TType::INT, "" },
        { TType::LBRACE, "{" },
        { TType::LPAREN, "(" },
        { TType::LSQUARE, "[" },
        { TType::NEWLINE, "\n" },
        { TType::OPERATOR, "" },
        { TType::QUEST, "?" },
        { TType::RAW_STR, "" },
        { TType::RBRACE, "}" },
        { TType::RPAREN, ")" },
        { TType::RSQUARE, "]" },
        { TType::STR, "" },
        //@@END
    };

    auto it = ttypes.find(ttype);
    if (it == ttypes.end())
        return "";
    else
        return it->second;
}

string to_string(Keyword keyword) {
    static unordered_map<Keyword, string> keywords = {
        //@@BEGIN: keyword_text
        { Keyword::A, "a" },
        { Keyword::AF, "af" },
        { Keyword::AF1, "af'" },
        { Keyword::AIX, "aix" },
        { Keyword::AIY, "aiy" },
        { Keyword::ALIGN, "align" },
        { Keyword::ASMPC, "asmpc" },
        { Keyword::ASSERT, "assert" },
        { Keyword::ASSUME, "assume" },
        { Keyword::B, "b" },
        { Keyword::BINARY, "binary" },
        { Keyword::BYTE, "byte" },
        { Keyword::C, "c" },
        { Keyword::CALL_OZ, "call_oz" },
        { Keyword::CALL_PKG, "call_pkg" },
        { Keyword::CMD, "cmd" },
        { Keyword::CU, "cu" },
        { Keyword::C_LINE, "c_line" },
        { Keyword::DB, "db" },
        { Keyword::DC, "dc" },
        { Keyword::DDB, "ddb" },
        { Keyword::DEFB, "defb" },
        { Keyword::DEFC, "defc" },
        { Keyword::DEFDB, "defdb" },
        { Keyword::DEFGROUP, "defgroup" },
        { Keyword::DEFINE, "define" },
        { Keyword::DEFM, "defm" },
        { Keyword::DEFP, "defp" },
        { Keyword::DEFQ, "defq" },
        { Keyword::DEFS, "defs" },
        { Keyword::DEFVARS, "defvars" },
        { Keyword::DEFW, "defw" },
        { Keyword::DM, "dm" },
        { Keyword::DMA, "dma" },
        { Keyword::DP, "dp" },
        { Keyword::DQ, "dq" },
        { Keyword::DS, "ds" },
        { Keyword::DW, "dw" },
        { Keyword::DWORD, "dword" },
        { Keyword::EQU, "equ" },
        { Keyword::EXTERN, "extern" },
        { Keyword::GLOBAL, "global" },
        { Keyword::INCBIN, "incbin" },
        { Keyword::INCLUDE, "include" },
        { Keyword::IX, "ix" },
        { Keyword::IXH, "ixh" },
        { Keyword::IXL, "ixl" },
        { Keyword::IY, "iy" },
        { Keyword::IYH, "iyh" },
        { Keyword::IYL, "iyl" },
        { Keyword::JP, "jp" },
        { Keyword::JR, "jr" },
        { Keyword::LD, "ld" },
        { Keyword::LIB, "lib" },
        { Keyword::LINE, "line" },
        { Keyword::MOVE, "move" },
        { Keyword::NC, "nc" },
        { Keyword::NONE, "" },
        { Keyword::NOP, "nop" },
        { Keyword::NZ, "nz" },
        { Keyword::ORG, "org" },
        { Keyword::P, "p" },
        { Keyword::PTR, "ptr" },
        { Keyword::PUBLIC, "public" },
        { Keyword::Q, "q" },
        { Keyword::SECTION, "section" },
        { Keyword::STOP, "stop" },
        { Keyword::W, "w" },
        { Keyword::WAIT, "wait" },
        { Keyword::WORD, "word" },
        { Keyword::WR0, "wr0" },
        { Keyword::WR1, "wr1" },
        { Keyword::WR2, "wr2" },
        { Keyword::WR3, "wr3" },
        { Keyword::WR4, "wr4" },
        { Keyword::WR5, "wr5" },
        { Keyword::WR6, "wr6" },
        { Keyword::XDEF, "xdef" },
        { Keyword::XIX, "xix" },
        { Keyword::XLIB, "xlib" },
        { Keyword::XREF, "xref" },
        { Keyword::YIY, "yiy" },
        { Keyword::Z, "z" },
        //@@END
    };

    auto it = keywords.find(keyword);
    if (it == keywords.end())
        return "";
    else
        return it->second;

}

Keyword lookup_keyword(const string& text) {
    static unordered_map<string, Keyword> keywords = {
        //@@BEGIN: keyword_lookup
        { "a", Keyword::A },
        { "af", Keyword::AF },
        { "af'", Keyword::AF1 },
        { "aix", Keyword::AIX },
        { "aiy", Keyword::AIY },
        { "align", Keyword::ALIGN },
        { "asmpc", Keyword::ASMPC },
        { "assert", Keyword::ASSERT },
        { "assume", Keyword::ASSUME },
        { "b", Keyword::B },
        { "binary", Keyword::BINARY },
        { "byte", Keyword::BYTE },
        { "c", Keyword::C },
        { "call_oz", Keyword::CALL_OZ },
        { "call_pkg", Keyword::CALL_PKG },
        { "cmd", Keyword::CMD },
        { "cu", Keyword::CU },
        { "c_line", Keyword::C_LINE },
        { "db", Keyword::DB },
        { "dc", Keyword::DC },
        { "ddb", Keyword::DDB },
        { "defb", Keyword::DEFB },
        { "defc", Keyword::DEFC },
        { "defdb", Keyword::DEFDB },
        { "defgroup", Keyword::DEFGROUP },
        { "define", Keyword::DEFINE },
        { "defm", Keyword::DEFM },
        { "defp", Keyword::DEFP },
        { "defq", Keyword::DEFQ },
        { "defs", Keyword::DEFS },
        { "defvars", Keyword::DEFVARS },
        { "defw", Keyword::DEFW },
        { "dm", Keyword::DM },
        { "dma", Keyword::DMA },
        { "dp", Keyword::DP },
        { "dq", Keyword::DQ },
        { "ds", Keyword::DS },
        { "dw", Keyword::DW },
        { "dword", Keyword::DWORD },
        { "equ", Keyword::EQU },
        { "extern", Keyword::EXTERN },
        { "global", Keyword::GLOBAL },
        { "incbin", Keyword::INCBIN },
        { "include", Keyword::INCLUDE },
        { "ix", Keyword::IX },
        { "ixh", Keyword::IXH },
        { "ixl", Keyword::IXL },
        { "iy", Keyword::IY },
        { "iyh", Keyword::IYH },
        { "iyl", Keyword::IYL },
        { "jp", Keyword::JP },
        { "jr", Keyword::JR },
        { "ld", Keyword::LD },
        { "lib", Keyword::LIB },
        { "line", Keyword::LINE },
        { "move", Keyword::MOVE },
        { "nc", Keyword::NC },
        { "", Keyword::NONE },
        { "nop", Keyword::NOP },
        { "nz", Keyword::NZ },
        { "org", Keyword::ORG },
        { "p", Keyword::P },
        { "ptr", Keyword::PTR },
        { "public", Keyword::PUBLIC },
        { "q", Keyword::Q },
        { "section", Keyword::SECTION },
        { "stop", Keyword::STOP },
        { "w", Keyword::W },
        { "wait", Keyword::WAIT },
        { "word", Keyword::WORD },
        { "wr0", Keyword::WR0 },
        { "wr1", Keyword::WR1 },
        { "wr2", Keyword::WR2 },
        { "wr3", Keyword::WR3 },
        { "wr4", Keyword::WR4 },
        { "wr5", Keyword::WR5 },
        { "wr6", Keyword::WR6 },
        { "xdef", Keyword::XDEF },
        { "xix", Keyword::XIX },
        { "xlib", Keyword::XLIB },
        { "xref", Keyword::XREF },
        { "yiy", Keyword::YIY },
        { "z", Keyword::Z },
        //@@END
    };

    auto it = keywords.find(str_to_lower(text));
    if (it == keywords.end())
        return Keyword::NONE;
    else
        return it->second;
}

Token::Token(TType ttype, bool blank_before)
    : m_ttype(ttype), m_blank_before(blank_before) {
}

void Token::set_keyword(const string& text) {
    m_keyword = ::lookup_keyword(text);
    m_svalue = text;
	
	// check SwapIXIY
	if (g_options->swap_ixiy() != SwapIXIY::NO_SWAP) {
		switch (m_keyword) {
		case Keyword::AIX:
		case Keyword::AIY:
		case Keyword::IX:
		case Keyword::IXH:
		case Keyword::IXL:
		case Keyword::IY:
		case Keyword::IYH:
		case Keyword::IYL:
		case Keyword::XIX:
		case Keyword::YIY:
			m_svalue = swap_x_y(m_svalue);
			m_keyword = ::lookup_keyword(m_svalue);
            break;
		default:;
		}
	}
}

bool Token::is_end() const {
    return is(TType::END) || is(TType::NEWLINE) || is(TType::COLON) || is(TType::BACKSLASH);
}

string Token::to_string() const {
    switch (m_ttype) {
    case TType::IDENT:
		// check SwapIXIY
		if (g_options->swap_ixiy() != SwapIXIY::NO_SWAP) {
			string str;
			switch (m_keyword) {
			case Keyword::AIX:
			case Keyword::AIY:
			case Keyword::IX:
			case Keyword::IXH:
			case Keyword::IXL:
			case Keyword::IY:
			case Keyword::IYH:
			case Keyword::IYL:
			case Keyword::XIX:
			case Keyword::YIY:
				str = swap_x_y(m_svalue);
				return str;
			default:;
				// fall through
			}
		}
        return m_svalue;
    case TType::INT:
        return std::to_string(m_ivalue);
    case TType::FLOAT:
        return std::to_string(m_fvalue);
    case TType::STR:
        return binary_to_c_string(reinterpret_cast<const unsigned char*>(m_svalue.c_str()), m_svalue.size());
    case TType::RAW_STR:
        return "\"" + m_svalue + "\"";		// syntax error in a later stage if string contains '"'
    case TType::OPERATOR:
        return ::to_string(m_operator);
    default:
        return ::to_string(m_ttype);
    }
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

string Token::swap_x_y(string str) {
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
    return str;
}
