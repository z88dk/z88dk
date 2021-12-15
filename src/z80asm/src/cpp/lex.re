//-----------------------------------------------------------------------------
// z80asm
// lexer
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

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

	end 		= "\000";
	ws		=  [ \t\v\f];
	nl		= "\r\n"|"\r"|"\n";
	eos		= [;\r\n];
	_ 		= ws*;
	__ 		= ws+;
	_b		= [^_a-zA-Z0-9\000];
	ident 	= [_a-zA-Z][_a-zA-Z0-9]*;
	ident_prefix = [.#$%@];
	operand	= ident |
			  'b\''   | 'c\''   | 'd\''   | 'e\''    | 'h\''   | 'l\''    | 'a\'' |
			  'af\''  | 'bc\''  | 'de\''  | 'hl\''   |
			  'ccf\'' | 'scf\'' | 'rra\'' | 'rrca\'' | 'rla\'' | 'rlca\'' |
			  'ds.b'  | 'ds.w'  | 'ds.p'  | 'ds.q';
	bin		= [0-1];
	oct		= [0-7];
	dec		= [0-9];
	hex		= [0-9a-fA-F];
	mantissa= [-+]? dec+ '.' dec* | dec* '.' dec+;
	exp		= [eE][-+]?[0-9]+;
	qchar_	= '\\' ['"\\abefnrtv] |
			  '\\' [0-7]{1,3} |
			  '\\x' [0-9a-fA-F]{1,2} |
			  '\\' [^\r\n\000];
	qchar	= qchar_ | [^\r\n\000'];
	qqchar	= qchar_ | [^\r\n\000"];
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
	if (option_ucase())
		return str_toupper(ident);
	else
		return ident;
}

bool starts_with_hash(const string& line) {
	const char* p = line.c_str();
	const char* YYMARKER{ nullptr };
	/*!re2c
		_ '#'				{ return true; }
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
			';' [^\r\n\000]*	{ return false; }
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

void split_lines(deque<string>& lines, const string& line) {
	string output;
	const char* YYMARKER{ nullptr };
	const char* p = line.c_str();

	while (true) {
		const char* p0 = p;
		/*!re2c
			__				{ output += " "; continue; }
			';' [^\r\n\000]*{ continue; }
			end             { if (!output.empty()) {
								  output += "\n"; lines.push_back(output); }
							  return; }
			nl | '\\'		{ output += "\n"; lines.push_back(output);
							  output.clear(); continue; }
			"'"  qchar* "'" |
			'"' qqchar* '"' |
			operand         { output += string(p0, p); continue; }
			*               { output += string(p0, p); continue; }
		*/
	}
}

//-----------------------------------------------------------------------------

Token& Lexer::operator[](int offset) {
	return peek(offset);
}

Token& Lexer::peek(int offset) {
	static Token end{ TType::End };
	size_t index = m_pos + offset;
	if (index >= m_tokens.size())
		return end;
	else
		return m_tokens[index];
}

void Lexer::next() {
	if (m_pos < m_tokens.size())
		m_pos++;
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
			";"				{ return; }
			"\n"				{ m_tokens.emplace_back(TType::Newline);
							  m_tokens.back().col = col;
							  continue; }
			dec+ 'd'?		{ m_tokens.emplace_back(TType::Integer, a2i(p0, 10));
							  m_tokens.back().col = col;
							  continue; }
			mantissa exp? 	{ m_tokens.emplace_back(TType::Floating, atof(p0));
							  m_tokens.back().col = col;
							  continue; }
			dec hex* 'h'		{ m_tokens.emplace_back(TType::Integer, a2i(p0, 16));
							  m_tokens.back().col = col;
							  continue; }
			"$" hex+			{ m_tokens.emplace_back(TType::Integer, a2i(p0+1, 16));
							  m_tokens.back().col = col;
							  continue; }
			'0x' hex+		{ m_tokens.emplace_back(TType::Integer, a2i(p0+2, 16));
							  m_tokens.back().col = col;
							  continue; }
			bin+ 'b'			{ m_tokens.emplace_back(TType::Integer, a2i(p0, 2));
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
								  error_invalid_squoted_string();
								  return;
							  }
							  m_tokens.emplace_back(TType::Integer, str[0]);
							  m_tokens.back().col = col;
							  continue; }

			'"' @p1 qqchar* @p2 '"'	{
							  string str = str_compress_escapes(string(p1, p2));
							  m_tokens.emplace_back(TType::String, str);
							  m_tokens.back().col = col;
							  continue; }

			'!'				{ m_tokens.emplace_back(TType::LogNot);
							  m_tokens.back().col = col;
							  continue; }
			'#'				{ m_tokens.emplace_back(TType::Hash);
							  m_tokens.back().col = col;
							  continue; }
			'##'				{ m_tokens.emplace_back(TType::DblHash);
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
			'&&'				{ m_tokens.emplace_back(TType::LogAnd);
							  m_tokens.back().col = col;
							  continue; }
			'('				{ m_tokens.emplace_back(TType::Lparen);
							  m_tokens.back().col = col;
							  continue; }
			')'				{ m_tokens.emplace_back(TType::Rparen);
							  m_tokens.back().col = col;
							  continue; }
			'*'				{ m_tokens.emplace_back(TType::Mul);
							  m_tokens.back().col = col;
							  continue; }
			'**'				{ m_tokens.emplace_back(TType::Pow);
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
			'<='				{ m_tokens.emplace_back(TType::Le);
							  m_tokens.back().col = col;
							  continue; }
			'<<'				{ m_tokens.emplace_back(TType::Shl);
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
			'>='				{ m_tokens.emplace_back(TType::Ge);
							  m_tokens.back().col = col;
							  continue; }
			'>>'				{ m_tokens.emplace_back(TType::Shr);
							  m_tokens.back().col = col;
							  continue; }
			'?'				{ m_tokens.emplace_back(TType::Quest);
							  m_tokens.back().col = col;
							  continue; }
			'['				{ m_tokens.emplace_back(TType::Lsquare);
							  m_tokens.back().col = col;
							  continue; }
			'\\'				{ m_tokens.emplace_back(TType::Backslash);
							  m_tokens.back().col = col;
							  continue; }
			']'				{ m_tokens.emplace_back(TType::Rsquare);
							  m_tokens.back().col = col;
							  continue; }
			'^'				{ m_tokens.emplace_back(TType::BinXor);
							  m_tokens.back().col = col;
							  continue; }
			'^^'				{ m_tokens.emplace_back(TType::LogXor);
							  m_tokens.back().col = col;
							  continue; }
			'{'				{ m_tokens.emplace_back(TType::Lbrace);
							  m_tokens.back().col = col;
							  continue; }
			'|'				{ m_tokens.emplace_back(TType::BinOr);
							  m_tokens.back().col = col;
							  continue; }
			'||'				{ m_tokens.emplace_back(TType::LogOr);
							  m_tokens.back().col = col;
							  continue; }
			'}'				{ m_tokens.emplace_back(TType::Rbrace);
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
								  m_tokens.emplace_back(TType::Ident, str, keyword);
							  }
							  m_tokens.back().col = col;
							  continue; }

			operand @p1		{ string str = ident_change_case(string(p0, p1));
							  Keyword keyword = lu_keyword(str);
							  m_tokens.emplace_back(TType::Ident, str, keyword);
							  m_tokens.back().col = col;
							  continue; }

			"'" |
			'"'				{ error_unclosed_string(); return; }

			*				{ error_invalid_char(); return; }

		*/
	}
}

//-----------------------------------------------------------------------------

string ParamScanner::collect_name() {
	const char* YYMARKER{ nullptr }, * yyt1{ nullptr }, * p1{ nullptr };

	/*!re2c
		_ @p1 ident		{ return string(p1, p); }
		*               { error_syntax(); return ""; }
	*/
}

//-----------------------------------------------------------------------------

void MacroExpander::do_expand() {
	const char* YYMARKER{ nullptr };
	p = m_text.c_str();

	while (true) {
		const char* p0 = p;
		/*!re2c
			end             { return; }
			ident_prefix? ident {
							  check_macro_call(string(p0, p)); continue; }
			"'"  qchar* "'" |
			'"' qqchar* '"' |
			operand         { m_output += string(p0, p); continue; }
			*               { m_output += string(p0, p); continue; }
		*/
	}
}

//-----------------------------------------------------------------------------

bool PreprocFilter::check_ifs(const string& line) {
	const char* YYMARKER{ nullptr }, * yyt1{ nullptr }, * yyt2{ nullptr }, * yyt3{ nullptr };
	const char *p1{ nullptr }, * p2{ nullptr };
	p = line.c_str();

	/*!re2c
		_ '.' _ @p1 ident @p2 __ 'if' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_if();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'if' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_if();
							  return true; }
		_ 'if' _ ':'			{ return false; }
		_ 'if' _b			{ p--;
							  do_if(); 
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'ifdef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_ifdef();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'ifdef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_ifdef();
							  return true; }
		_ 'ifdef' _ ':'		{ return false; }
		_ 'ifdef' _b			{ p--;
							  do_ifdef();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'ifndef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_ifndef();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'ifndef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_ifndef();
							  return true; }
		_ 'ifndef' _ ':'		{ return false; }
		_ 'ifndef' _b			{ p--;
							  do_ifndef();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'elif' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elif();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'elif' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elif();
							  return true; }
		_ 'elif' _ ':'		{ return false; }
		_ 'elif' _b			{ p--;
							  do_elif();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'elifdef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elifdef();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'elifdef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elifdef();
							  return true; }
		_ 'elifdef' _ ':'	{ return false; }
		_ 'elifdef' _b		{ p--;
							  do_elifdef();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'elifndef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elifndef();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'elifndef' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_elifndef();
							  return true; }
		_ 'elifndef' _ ':'	{ return false; }
		_ 'elifndef' _b		{ p--;
							  do_elifndef();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'else' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_else();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'else' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_else();
							  return true; }
		_ 'else' _ ':'		{ return false; }
		_ 'else' _b			{ p--;
							  do_else();
							  return true; }

		_ '.' _ @p1 ident @p2 __ 'endif' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_endif();
							  return true; }
		_ @p1 ident @p2 _ ':' _ 'endif' _b {
							  p--;
							  if (ifs_active()) do_label(string(p1, p2));
							  do_endif();
							  return true; }
		_ 'endif' _ ':'		{ return false; }
		_ 'endif' _b			{ p--;
							  do_endif();
							  return true; }


		*					{ return false; }
	*/
}

bool PreprocFilter::check_defines(const string& line) {
	const char* YYMARKER{ nullptr }, * yyt1{ nullptr }, * yyt2{ nullptr };
	const char* p1{ nullptr }, * p2{ nullptr };
	p = line.c_str();

	/*!re2c
		_ '#' _ 'define' _ @p1 ident_prefix ident @p2 {
							  parse_define(string(p1, p2));
							  return true; }
		_ '#' _ 'define' __ @p1 ident @p2 {
							  parse_define(string(p1, p2));
							  return true; }
		_ '#' _ 'define' _b	{ error_syntax(); return true; }

		_ '#' _ 'undef' _ @p1 ident_prefix ident @p2 _ eos {
							  m_levels.front().defines.remove(string(p1, p2));
							  return true; }
		_ '#' _ 'undef' __ @p1 ident @p2 _ eos {
							  m_levels.front().defines.remove(string(p1, p2));
							  return true; }
		_ '#' _ 'undef' _b	{ error_syntax(); return true; }

		_ '#'				{ return true; }


		*					{ return false; }
	*/
}

bool PreprocFilter::check_macro_call(const string& line) {
	const char* YYMARKER{ nullptr }, * yyt1{ nullptr }, * yyt2{ nullptr }, * yyt3{ nullptr };
	const char* p1{ nullptr }, * p2{ nullptr }, * p3{ nullptr }, * p4{ nullptr };
	shared_ptr<Macro> macro;
	p = line.c_str();

	/*!re2c
		_ '.' _ @p1 ident @p2 __ @p3 ident @p4 {
							  macro = m_macros.find_all(string(p3, p4));
							  if (macro) {
							      do_label(string(p1, p2));
								  do_macro_call(macro);
								  return true;
							  }
							  else
							      return false;
							}
		_ @p1 ident @p2 _ ':' _ @p3 ident @p4 {
							  macro = m_macros.find_all(string(p3, p4));
							  if (macro) {
								  do_label(string(p1, p2));
								  do_macro_call(macro);
								  return true;
							  }
							  else
								  return false;
							}
		_ @p3 ident @p4		{
							  macro = m_macros.find_all(string(p3, p4));
							  if (macro) {
								  do_macro_call(macro);
								  return true;
							  }
							  else
								  return false;
							}

		*					{ return false; }
	*/
}

void PreprocFilter::parse_params(shared_ptr<Macro> macro) {
	while (true) {
		const char* p0 = p;
		/*!re2c
			__				{ continue; }
			ident_prefix? ident {
							  string name = string(p0, p);
							  macro->push_arg(name);
							  p = skip_spaces(p);
							  if (*p == ',') {
							      p++; continue;
							  }
							  else
							      return; }
			*				{ error_syntax(); return; }
		*/
	}
}

//-----------------------------------------------------------------------------

#if 0
/*
!re2c
_ '#@#' _ 'include' _ '"' @p1[^ "\r\n\000]+ @p2 '"' _ nl {
do_include(string(p1, p2)); return; }
	*/
#endif

