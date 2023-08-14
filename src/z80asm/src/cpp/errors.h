//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
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

class Location {
public:
    Location(const string& filename = "", int line_num = 0,
        const string& source_line = "", const string& expanded_line = "");

    void clear();
    void inc_line() { m_line_num += m_line_inc; }

    const string& filename() const { return m_filename; }
    int line_num() const { return m_line_num; }
    const string& source_line() const { return m_source_line; }
    const string& expanded_line() const { return m_expanded_line; }
    bool is_c_source() const { return m_is_c_source; }

    void set_filename(const string& filename) { m_filename = filename; }
    void set_line_num(int line_num, int line_inc = 1) { m_line_num = line_num; m_line_inc = line_inc; }
    void set_source_line(const string& line) { m_source_line = line; m_expanded_line.clear(); }
    void set_expanded_line(const string& line) { m_expanded_line = line; }
    void set_c_source(bool f) { m_is_c_source = f; }

private:
	string	m_filename;		        // current assembly file
	int		m_line_num{ 0 };	    // curremt assembly line number
	int		m_line_inc{ 1 };	    // increment to next line number
	string	m_source_line;	        // current assembly source line
	string	m_expanded_line;	    // current macro expanded line
    bool    m_is_c_source{ false }; // C_LINE seen
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
	int		m_count;			        // error count
	vector<Location>    m_locations;	// current location on top of stack

	void show_error(const string& prefix, ErrCode code, const string& arg = "");
};

extern Errors g_errors;
