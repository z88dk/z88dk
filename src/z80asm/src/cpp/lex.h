//-----------------------------------------------------------------------------
// z80asm
// lexer
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstring>
#include <deque>
#include <string>
#include <vector>
using namespace std;

inline bool isident(char c) {
	return c == '_' || isalnum(c);
}

inline const char* skip_spaces(const char* p) {
	while (isspace(*p) && *p != '\r' && *p != '\n')
		p++;
	return p;
}

bool starts_with_hash(const string& line);
bool remove_final_backslash(string& line);
void split_lines(deque<string>& lines, const string& line);

enum class TType {
	End, Newline,
	Ident, Label, Integer, Floating, String, ASMPC,
	BinNot, LogNot, BinAnd, LogAnd, BinOr, LogOr, BinXor, LogXor,
	Plus, Minus, Mul, Pow, Div, Mod,
	Eq, Ne, Lt, Le, Gt, Ge, Shl, Shr,
	Quest, Colon, Dot, Comma, Hash, DblHash,
	Lparen, Rparen, Lsquare, Rsquare, Lbrace, Rbrace,
	Backslash, 
};

enum class Keyword {
#	define X(id, text)		id,
#	include "keyword.def"
};

struct Token {
	TType   ttype{ TType::End };
	int     ivalue{ 0 };
	string  svalue;
	double	fvalue{ 0.0 };
	Keyword	keyword{ Keyword::None };
	size_t	col{ 0 };

	Token(TType ttype = TType::End, int ivalue = 0)
		: ttype(ttype), ivalue(ivalue) {}
	Token(TType ttype, const string& svalue, Keyword keyword = Keyword::None)
		: ttype(ttype), svalue(svalue), keyword(keyword) {}
	Token(TType ttype, double fvalue)
		: ttype(ttype), fvalue(fvalue) {}

	void clear() { *this = Token(); }

	bool is(TType ttype) { return this->ttype == ttype; }
	bool is(Keyword keyword) { return this->keyword == keyword; }
	template <typename T, typename... Types>
	bool is(T var1, Types... var2) {
		if (is(var1))
			return true;
		else if (is(var2...))
			return true;
		else
			return false;
	}
};

class Lexer {
public:
	Lexer(const string& text = "") { set(text); }
	void set(const string& text = "");
	void clear() { set(); }

	const string& text() const { return m_text; }
	const char* text_ptr() const {
		return m_pos < m_tokens.size() ?
			m_text.c_str() + m_tokens[m_pos].col :
			m_text.c_str() + m_text.length();
	}
	size_t size() const { return m_tokens.size(); }

	void rewind() { m_pos = 0; }
	bool at_end() const { return m_pos >= m_tokens.size(); }
	size_t pos() const { return m_pos; }
	void set_pos(size_t pos) { m_pos = pos; }

	Token& peek(int offset = 0);			// 0: current; 1: next; -1: previous
	Token& operator[](int offset);
	void next();

private:
	string			m_text;
	vector<Token>	m_tokens;
	size_t			m_pos;
};
