//-----------------------------------------------------------------------------
// z80asm
// preprocessor lexer
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc.h"
using namespace std;

/*!re2c
	re2c:define:YYCTYPE = char;
	re2c:define:YYCURSOR = m_ptr;
	re2c:yyfill:enable = 0;
	re2c:indent:top = 2;

	end 	= "\000";
	ws		= [ \t\v\f];
	nl		= "\r\n"|"\r"|"\n";
	_ 		= ws*;
	__ 		= ws+;
	_b		= [^_a-zA-Z0-9\000];
	ident 	= [_a-zA-Z][_a-zA-Z0-9]*;
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

static int a2i(const char* str, int base) {
	return (int)strtol(str, NULL, base);
}

// split lines on '\\', replace numbers by decimal base
void SourceFile::split_line() {
	string output;
	const char* YYMARKER, * p1;
	m_ptr = m_line.c_str();
	while (true) {
		const char* p0 = m_ptr;
		/*!re2c
			ws+				{ output += " "; continue; }
			';' [^\r\n\000]* { continue; }
			end				{ m_in_lines.push_back(output); return; }
			nl				{ output += "\n"; continue; }
			'\\'			{ output += "\n"; m_in_lines.push_back(output);
							  output.clear(); continue; }
			dec+ 'd'? _b	{ m_ptr--; output += to_string(a2i(p0, 10)); continue; }
			mantissa exp? _b{ m_ptr--; output += string(p0, m_ptr); continue; }
			dec hex* 'h' _b	{ m_ptr--; output += to_string(a2i(p0, 16)); continue; }
			"$" hex+ _b		{ m_ptr--; output += to_string(a2i(p0+1, 16)); continue; }
			'0x' hex+ _b	{ m_ptr--; output += to_string(a2i(p0+2, 16)); continue; }
			bin+ 'b' _b		{ m_ptr--; output += to_string(a2i(p0, 2)); continue; }
			[%@] bin+ _b	{ m_ptr--; output += to_string(a2i(p0+1, 2)); continue; }
			'0b' bin+ _b	{ m_ptr--; output += to_string(a2i(p0+2, 2)); continue; }

			[%@] '"' [-#]* @p1 '"'	{
							  int n = 0;
							  for (const char* p = p0+2; p < p1; p++) {
								  n *= 2; if (*p == '#') n++;
							  }
							  output += to_string(n); continue; }

			"'"  qchar* "'" |
			'"' qqchar* '"' { output += string(p0, m_ptr); continue; }

			operand			{ output += string(p0, m_ptr); continue; }
			*				{ output += string(p0, m_ptr); continue; }
		*/
	}
}


void SourceFile::parse_line() {
	m_ptr = m_line.c_str();
	const char* YYMARKER, *yyt1, *yyt2, *p1, *p2;
	
	/*!re2c
		_ '#@#' _ 'include' _ '"' @p1 [^"\r\n\000]+ @p2 '"' _ nl {
					do_include(string(p1, p2)); return; }
		*		{ 	m_out_lines.push_back(m_line); return; }
	*/
}
