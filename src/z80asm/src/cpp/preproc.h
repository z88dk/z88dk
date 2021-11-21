//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "defines.h"
#include "if.h"
#include "lex.h"
#include <deque>
#include <fstream>
#include <iostream>
#include <list>
#include <string>
using namespace std;

class SourceFile {
public:
	bool open(const string& filename, bool search_include_path = true);
	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }
	bool is_c_source() const { return m_is_c_source; }
	bool is_open() const { return m_ifs.is_open(); }

	void set_filename(const string& filename) { m_filename = filename; }
	void set_line_num(int line_num, int line_inc = 1);
	void set_c_source(bool f = true) { m_is_c_source = f; }
	void set_hold(bool f = true) { m_hold = f; }
	bool hold() const { return m_hold; }

	const char* getline();				// read next line from this file

private:
	ifstream	m_ifs;					// open file
	string		m_filename;				// location file, ...
	int			m_line_num{ 0 };		// ... and line
	int			m_line_inc{ 1 };		// 0 after C_LINE
	bool		m_is_c_source{ false };	// m_filename comes from C_LINE
	deque<string> m_in_lines;			// lines from input
	deque<string> m_out_lines;			// lines to return
	string		m_line;					// last read line
	const char* m_ptr{ nullptr };		// scan pointer in line
	bool		m_hold{ false };		// do not pop g_source_files automatically

	const char* get_input_line();		// read next line from input
	void split_line();					// split input line on '\\'
	void parse_line();					// parse line in m_line
	bool recursive_include(const string& filename);

	void do_include(const string& filename);	// push new SourceFile to g_source_files
};

extern list<SourceFile>	g_source_files;



#if 0
struct Location {
	string  filename;
	int     line_num{ 0 };

	Location(const string& filename = "", int line_num = 0)
		: filename(filename), line_num(line_num) {}
	void clear() { filename.clear(); line_num = 0; }
};

extern Location g_location;

struct Line {
	Location    location;
	string      text;

	Line(const Location& location = g_location, const string& text = "")
		: location(location), text(text) {}
	void clear() { location.clear(); text.clear(); }
};

struct PreprocLevel {
	Line		line;
	Lexer		lexer;
	Macros		defines;					// #defines, -D, macro args
	bool		exitm_called{ false };

	PreprocLevel(Macros* parent = nullptr);
	void init(const Line& line);
	bool getline();

private:
	list<Line>	m_lines;
};


class Preproc {

};
#endif
