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
	ws		=  [ \t\v\f];
	nl		= "\r\n"|"\r"|"\n";
	_ 		= ws*;
*/

void SourceFile::parse_line() {
	m_ptr = m_line.c_str();
	const char* YYMARKER, *yyt1, *yyt2, *p1, *p2;
	
	/*!re2c
		_ '#@#' _ 'include' _ '"' @p1 [^"\r\n\000]+ @p2 '"' _ nl {
					do_include(string(p1, p2)); return; }
		*		{ 	m_out_lines.push_back(m_line); return; }
	*/
}
