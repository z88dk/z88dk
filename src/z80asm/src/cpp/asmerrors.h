//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <string>
using namespace std;

enum class ErrCode {
#	define X(code, message)		code,
#	include "asmerrors.def"
};

class Errors {
public:
	Errors();
	void clear();				// clear all but count

	int count() const { return m_count; }
	string filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

	void set_location(const string& filename, int line_num = 0);
	void set_source_line(const string& line);
	void set_expanded_line(const string& line);

	void error(ErrCode code, const string& arg = "");
	void warning(ErrCode code, const string& arg = "");

private:
	int		m_count;			// error count
	string	m_filename;			// current assembly file
	int		m_line_num;			// curremt assembly line number
	string	m_source_line;		// current assembly source line
	string	m_expanded_line;	// current macro expanded line

	void show_error(const string& prefix, ErrCode code, const string& arg = "");
};

extern Errors g_errors;
