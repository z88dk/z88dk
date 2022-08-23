//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>
using namespace std;

enum class ErrCode {
#	define X(code, message)		code,
#	include "errors.def"
};

struct Location {
	string	filename;		// current assembly file
	int		line_num{ 0 };	// curremt assembly line number
	int		line_inc{ 1 };	// increment to next line number
	string	source_line;	// current assembly source line
	string	expanded_line;	// current macro expanded line

	Location(const string& filename = "", int line_num = 0,
		const string& source_line = "", const string& expanded_line = "");
	void clear();
	void inc_line() { line_num += line_inc; }
};

class Errors {
public:
	Errors();
	void clear();				// clear top location, keep count

	int count() const { return m_count; }
	void reset_count() { m_count = 0; }

	Location& location() { return m_locations.back(); }
	void set_location(const Location& location);

	void set_file_location(const string& filename, int line_num = 0);
	void set_source_line(const string& line);
	void set_expanded_line(const string& line);

	void error(ErrCode code, const string& arg = "");
	void warning(ErrCode code, const string& arg = "");

	void push_location(const Location& location);
	void pop_location();

private:
	int		m_count;			// error count
	vector<Location>	m_locations;	// current location on top of stack

	void show_error(const string& prefix, ErrCode code, const string& arg = "");
};

extern Errors g_errors;
