//-----------------------------------------------------------------------------
// z80asm
// lexer
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "if.h"
#include "lex.h"
#include "preproc.h"
#include "utils.h"
#include <cctype>
#include <unordered_map>
using namespace std;

/*!re2c
	re2c:define:YYCTYPE = char;
	re2c:define:YYCURSOR = p;
	re2c:yyfill:enable = 0;
	re2c:indent:top = 2;

	end 	= "\000";
	ws		=  [ \t\v\f];
	nl		= "\r\n"|"\r"|"\n";
	ident 	= [_a-zA-Z][_a-zA-Z0-9]*;
	operand	= ident |
			  'b\''   | 'c\''   | 'd\''   | 'e\''    | 'h\''   | 'l\''    | 'a\'' |
			  'af\''  | 'bc\''  | 'de\''  | 'hl\''   |
			  'ccf\'' | 'scf\'' | 'rra\'' | 'rrca\'' | 'rla\'' | 'rlca\'' |
			  'ds.b'  | 'ds.w'  | 'ds.p'  | 'ds.q';
	bin		= [0-1];
	oct		= [0-7];
	dec		= [0-9];
	mantissa= dec+ '.' dec* | dec* '.' dec+;
	exp		= 'e' [-+]? dec+;
	hex		= [0-9a-fA-F];
	qchar_	= '\\' [0-7]{1,3} |
			  '\\x' [0-9a-fA-F]{1,2} |
			  '\\' [^\r\n\000];
	qchar	= qchar_ | [^\r\n\000\\'];
	qqchar	= qchar_ | [^\r\n\000\\"];
*/

//-----------------------------------------------------------------------------

static unordered_map<string, Keyword> keyword_table = {
#	define X(id, text)		{ text, Keyword::id },
#	include "keyword.def"
};

static int a2i(const char* str, int base) {
	return (int)strtol(str, NULL, base);
}

static Keyword lu_keyword(const string& text) {
	auto it = keyword_table.find(str_tolower(text));
	if (it == keyword_table.end())
		return Keyword::None;
	else
		return it->second;
}

static string ident_change_case(const string& ident) {
	if (g_args.ucase())
		return str_toupper(ident);
	else
		return ident;
}

bool isident(const string& ident) {
	if (ident.empty())
		return false;
	else if (ident[0] != '_' && !isalpha(ident[0]))
		return false;
	else {
		for (auto c : ident) {
			if (c != '_' && !isalnum(c))
				return false;
		}
	}
	return true;
}

bool starts_with_hash(const string& line) {
	const char* p = line.c_str();
	const char* YYMARKER{ nullptr };
	/*!re2c
		ws* '#'				{ return true; }
		*					{ return false; }
	*/
}

bool remove_final_backslash(string& line) {
	const char* p = line.c_str();
	const char* YYMARKER{ nullptr };
	while (true) {
		size_t parsed_len = p - line.c_str();
		/*!re2c
			end					{ return false; }
			';'					{ return false; }
			"'"  qchar* "'" |
			'"' qqchar* '"' |
			operand         	{ continue; }
			'\\' nl? end		{ line.erase(parsed_len);
								  line.push_back(' ');
								  return true; }
			*					{ continue; }
		*/
	}
}

const char* scan_label(const char* p) {
	const char* p0 = p;
	const char* YYMARKER = nullptr;
	/*!re2c
		ws* ident ws* ':'	{ return p; }
		ws* '.' ws* ident	{ return p; }
		ws* ident ws* ':' ws* ('equ' | '=') { return p; }
		ws* '.' ws* ident ws* ('equ' | '=') { return p; }
		*					{ return p0; }
	*/
}

const char* scan_stmt(const char* p) {
	int conditional = 0;
	const char* p1 = nullptr;
	const char* yyt1 = nullptr;
	const char* YYMARKER = nullptr;
	while (true) {
		/*!re2c
			end					{ return p; }
			@p1 ';'				{ return p1; }
			'?'					{ conditional++; continue; }
			@p1 ':'				{ if (conditional==0) return p1; else { conditional--; continue; } }
			@p1 nl				{ return p1; }
			@p1 '\\'			{ return p1; }
			"'"  qchar* "'" |
			'"' qqchar* '"' |
			operand				{ continue; }
			*					{ continue; }
		*/
	}
}

const char* scan_comment(const char* p) {
	const char* p0 = p;
	/*!re2c
		';' [^\r\n\000]*		{ return p; }
		*						{ return p0; }
	*/
}

const char* scan_split_line(const char* p) {
	const char* p0 = p;
	/*!re2c
		nl | '\\' | ':'			{ return p; }
		*						{ return p0; }
	*/
}

void split_lines(deque<string>& lines, const string& line) {
	const char* p = line.c_str();

	while (*p != '\0') {
		const char* p0 = p;
		p = scan_label(p);
		p = scan_stmt(p);
		if (p != p0) {
			string output = string(p0, p) + "\n";
			lines.push_back(output);
		}

		p = scan_comment(p);
		p = scan_split_line(p);
	}
}

//-----------------------------------------------------------------------------

const char* Lexer::text_ptr(int offset) const {
	int index = m_pos + offset;
	if (index < 0)
		return m_text.c_str();
	else if (index < static_cast<int>(m_tokens.size()))
		return m_text.c_str() + m_tokens[index].col;
	else
		return m_text.c_str() + m_text.length();
}

string Lexer::token_text(int offset) const {
	const char* p1 = text_ptr(offset);
	const char* p2 = text_ptr(offset + 1);
	return string(p1, p2);
}

Token& Lexer::peek(int offset) {
	static Token end{ TType::End };
	size_t index = m_pos + offset;
	if (index >= m_tokens.size())
		return end;
	else
		return m_tokens[index];
}

void Lexer::next(int n) {
	m_pos += n;
	if (m_pos > m_tokens.size())
		m_pos = m_tokens.size();
}

void Lexer::set(const string& text) {
	m_text = text;
	m_tokens.clear();
	m_pos = 0;
	const char* p = text.c_str(), * YYMARKER{ nullptr };
	while (true) {
		const char* p0{ p }, * p1{ nullptr }, * p2{ nullptr }, * yyt1{ nullptr };
		size_t col = p - text.c_str();
		bool first_token = m_tokens.empty();
		/*!re2c
			ws+				{ continue; }
			end				{ return; }
			";"	[^\r\n\000]*{ continue; }
			"\n"			{ m_tokens.emplace_back(TType::Newline);
							  m_tokens.back().col = col;
							  continue; }
			mantissa exp? 	{ m_tokens.emplace_back(TType::Floating, atof(p0));
							  m_tokens.back().col = col;
							  continue; }
			dec+ 'd'?		{ m_tokens.emplace_back(TType::Integer, a2i(p0, 10));
							  m_tokens.back().col = col;
							  continue; }
			dec hex* 'h'	{ m_tokens.emplace_back(TType::Integer, a2i(p0, 16));
							  m_tokens.back().col = col;
							  continue; }
			"$" hex+		{ m_tokens.emplace_back(TType::Integer, a2i(p0+1, 16));
							  m_tokens.back().col = col;
							  continue; }
			'0x' hex+		{ m_tokens.emplace_back(TType::Integer, a2i(p0+2, 16));
							  m_tokens.back().col = col;
							  continue; }
			bin+ 'b'		{ m_tokens.emplace_back(TType::Integer, a2i(p0, 2));
							  m_tokens.back().col = col;
							  continue; }
			[%@] bin+		{ m_tokens.emplace_back(TType::Integer, a2i(p0+1, 2));
							  m_tokens.back().col = col;
							  continue; }
			'0b' bin+		{ m_tokens.emplace_back(TType::Integer, a2i(p0+2, 2));
							  m_tokens.back().col = col;
							  continue; }

			[%@] '"' [-#]* @p1 '"'	{
							  int n = 0;
							  for (const char* p = p0+2; p < p1; p++) {
								  n *= 2;
								  if (*p == '#') n++;
							  }
							  m_tokens.emplace_back(TType::Integer, n);
							  m_tokens.back().col = col;
							  continue; }

			"'" @p1 qchar* @p2 "'"	{
							  string str = str_compress_escapes(string(p1, p2));
							  if (str.length() != 1) {
								  g_errors.error(ErrCode::InvalidCharConst);
								  clear();
							  }
							  else {
								  m_tokens.emplace_back(TType::Integer, str[0]);
								  m_tokens.back().col = col;
							  }
							  continue; }

			'"' @p1 qqchar* @p2 '"'	{
							  m_tokens.emplace_back(TType::String, string(p1, p2));
							  m_tokens.back().col = col;
							  continue; }

			'!'				{ m_tokens.emplace_back(TType::LogNot);
							  m_tokens.back().col = col;
							  continue; }
			'#'				{ m_tokens.emplace_back(TType::Hash);
							  m_tokens.back().col = col;
							  continue; }
			'##'			{ m_tokens.emplace_back(TType::DblHash);
							  m_tokens.back().col = col;
							  continue; }
			'$'				{ m_tokens.emplace_back(TType::ASMPC);
							  m_tokens.back().col = col;
							  continue; }
			'%'				{ m_tokens.emplace_back(TType::Mod);
							  m_tokens.back().col = col;
							  continue; }
			'&'				{ m_tokens.emplace_back(TType::BinAnd);
							  m_tokens.back().col = col;
							  continue; }
			'&&'			{ m_tokens.emplace_back(TType::LogAnd);
							  m_tokens.back().col = col;
							  continue; }
			'('				{ m_tokens.emplace_back(TType::LParen);
							  m_tokens.back().col = col;
							  continue; }
			')'				{ m_tokens.emplace_back(TType::RParen);
							  m_tokens.back().col = col;
							  continue; }
			'*'				{ m_tokens.emplace_back(TType::Mul);
							  m_tokens.back().col = col;
							  continue; }
			'**'			{ m_tokens.emplace_back(TType::Pow);
							  m_tokens.back().col = col;
							  continue; }
			'+'				{ m_tokens.emplace_back(TType::Plus);
							  m_tokens.back().col = col;
							  continue; }
			','				{ m_tokens.emplace_back(TType::Comma);
							  m_tokens.back().col = col;
							  continue; }
			'-'				{ m_tokens.emplace_back(TType::Minus);
							  m_tokens.back().col = col;
							  continue; }
			'.'				{ m_tokens.emplace_back(TType::Dot);
							  m_tokens.back().col = col;
							  continue; }
			'/'				{ m_tokens.emplace_back(TType::Div);
							  m_tokens.back().col = col;
							  continue; }
			':'				{ m_tokens.emplace_back(TType::Colon);
							  m_tokens.back().col = col;
							  continue; }
			'<'				{ m_tokens.emplace_back(TType::Lt);
							  m_tokens.back().col = col;
							  continue; }
			'<='			{ m_tokens.emplace_back(TType::Le);
							  m_tokens.back().col = col;
							  continue; }
			'<<'			{ m_tokens.emplace_back(TType::LShift);
							  m_tokens.back().col = col;
							  continue; }
			'='  | '=='		{ m_tokens.emplace_back(TType::Eq);
							  m_tokens.back().col = col;
							  continue; }
			'!=' | '<>'		{ m_tokens.emplace_back(TType::Ne);
							  m_tokens.back().col = col;
							  continue; }
			'>'				{ m_tokens.emplace_back(TType::Gt);
							  m_tokens.back().col = col;
							  continue; }
			'>='			{ m_tokens.emplace_back(TType::Ge);
							  m_tokens.back().col = col;
							  continue; }
			'>>'			{ m_tokens.emplace_back(TType::RShift);
							  m_tokens.back().col = col;
							  continue; }
			'?'				{ m_tokens.emplace_back(TType::Quest);
							  m_tokens.back().col = col;
							  continue; }
			'['				{ m_tokens.emplace_back(TType::LSquare);
							  m_tokens.back().col = col;
							  continue; }
			'\\'			{ m_tokens.emplace_back(TType::Backslash);
							  m_tokens.back().col = col;
							  continue; }
			']'				{ m_tokens.emplace_back(TType::RSquare);
							  m_tokens.back().col = col;
							  continue; }
			'^'				{ m_tokens.emplace_back(TType::BinXor);
							  m_tokens.back().col = col;
							  continue; }
			'^^'			{ m_tokens.emplace_back(TType::LogXor);
							  m_tokens.back().col = col;
							  continue; }
			'{'				{ m_tokens.emplace_back(TType::LBrace);
							  m_tokens.back().col = col;
							  continue; }
			'|'				{ m_tokens.emplace_back(TType::BinOr);
							  m_tokens.back().col = col;
							  continue; }
			'||'			{ m_tokens.emplace_back(TType::LogOr);
							  m_tokens.back().col = col;
							  continue; }
			'}'				{ m_tokens.emplace_back(TType::RBrace);
							  m_tokens.back().col = col;
							  continue; }
			'~'				{ m_tokens.emplace_back(TType::BinNot);
							  m_tokens.back().col = col;
							  continue; }

			'.' ws* @p1 ident @p2 {
							  if (first_token) {
								  string str = ident_change_case(string(p1, p2));
								  m_tokens.emplace_back(TType::Label, str);
							  }
							  else {
								  p = p0 + 1;
								  m_tokens.emplace_back(TType::Dot);
							  }
							  m_tokens.back().col = col;
							  continue; }

			ident @p1 ws* ':' {
							  string str = ident_change_case(string(p0, p1));
							  if (first_token) {
								  m_tokens.emplace_back(TType::Label, str);
							  }
							  else {
								  p = p1;
								  Keyword keyword = lu_keyword(str);
								  if (keyword == Keyword::ASMPC)
									  m_tokens.emplace_back(TType::ASMPC);
								  else
								  m_tokens.emplace_back(TType::Ident, str, keyword);
							  }
							  m_tokens.back().col = col;
							  continue; }

			operand @p1		{ string str = ident_change_case(string(p0, p1));
							  Keyword keyword = lu_keyword(str);
							  if (keyword == Keyword::ASMPC) 
							      m_tokens.emplace_back(TType::ASMPC);
							  else
							      m_tokens.emplace_back(TType::Ident, str, keyword);
							  m_tokens.back().col = col;
							  continue; }

			"'" |
			'"'				{ g_errors.error(ErrCode::MissingQuote); clear(); return; }

			*				{ g_errors.error(ErrCode::InvalidChar); clear(); return; }

		*/
	}
}
