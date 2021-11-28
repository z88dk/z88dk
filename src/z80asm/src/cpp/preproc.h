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

class LineSource {
public:
	virtual bool getline(string& line) = 0;
	virtual bool hold() const = 0;
};

class LineFilter : public LineSource {
public:
	LineFilter(LineSource* source);
	bool getline(string& line) override;
	bool hold() const override;
	virtual void got_eof() {}

protected:
	LineSource*		m_source;
	deque<string>	m_lines;

	virtual bool get_source_line(string& line);
	virtual void parse_line(const string& line) = 0;
};

class SourceFile {
public:
	bool open(const string& filename);
	bool getline(string& line);

	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }
	bool is_c_source() const { return m_is_c_source; }
	bool hold() const { return m_hold; }

	void set_filename(const string& filename) { m_filename = filename; }
	void set_line_num(int line_num, int line_inc = 1) { m_line_num = line_num; m_line_inc = line_inc; }
	void set_c_source(bool f) { m_is_c_source = f; }
	void set_hold (bool f) { m_hold = f; }

private:
	string		m_filename;				// current location
	ifstream		m_ifs;					// file stream
	int			m_line_num{ 0 };			// current line number
	int			m_line_inc{ 1 };			// current line increment
	bool			m_is_c_source{ false };	// true if C_LINE called
	bool			m_hold{ false };			// do not get next line
};

class SourceFileStack : public LineSource {
public:
	bool open(const string& filename, bool search_include_path);
	void hold_input();					// stop getline geting new lines
	void unhold_input();
	bool getline(string& line) override;	// read next line, pop and continue on EOF

	string filename() const;				// name of current file
	int line_num() const;				// location in current file
	bool is_c_source() const;			// true if C_LINE called
	bool hold() const override;			// true if input blocked

	void set_filename(const string& filename);
	void set_line_num(int line_num, int line_inc = 1);
	void set_c_source(bool f);

private:
	list<SourceFile>		m_files;			// source files stack
#if 0
	deque<string>		m_out_lines;		// lines to return
	string				m_line;			// last read line
	const char*			p{ nullptr };	// scan pointer in line

	vector<IfNest>		m_if_stack;		// state of nested IFs
#endif

	bool recursive_include(const string& filename);
#if 0
	void parse_line(const string& line);// parse line, send output to queue

	void do_if();
	void do_else();
	void do_endif();

	void do_label(const string& label);	
	void do_if();						
	void do_else();						
	void do_endif();						

	void do_include(const string& filename);	// push new SourceFile to g_source_file_stack
#endif
};

// joins continuation lines, splits lines by '\\'
class LineSplitFilter : public LineFilter {
public:
	LineSplitFilter(LineSource* source);

private:
	bool get_source_line(string& line);
	void parse_line(const string& line) override;
	void split_line(const string& line);
};

// expands macros
class MacroExpander {
public:
	MacroExpander(const string& text, Macros* defines);
	string expand();

private:
	string		m_text;
	Macros*		m_defines;
	const char* p{ nullptr };
	string		m_output;
	bool			m_recursive_error{ false };

	void do_expand();
	void check_macro_call(const string& name);
	void expand_macro(shared_ptr<Macro> macro);
	vector<string> collect_params();
	bool collect_param(string& param);
	char next_char();
};

class MacroExpandFilter : public LineFilter {
public:
	MacroExpandFilter(LineSource* source);
	void got_eof() override;

private:
	Macros		m_defines;
	const char* p{ nullptr };

	virtual void parse_line(const string& line) override;
	void parse_define(const string& name);
	void parse_params(shared_ptr<Macro> macro);
};

extern SourceFileStack g_source_file_stack;
extern MacroExpandFilter g_macro_expand_filter;
extern LineSplitFilter g_preproc;

#if 0
struct PreprocLevel {
	string		line;
	Macros		defines;					// #defines, macro args
	bool			exitm_called{ false };

	PreprocLevel(Macros* parent = nullptr);
	void init(const string& line = "");
	bool getline();

private:
	deque<string>	m_lines;

	bool starts_with_hash();
	void split_line();
};

struct IfNest {
	Keyword keyword;
	bool	flag;
	bool	done_if;
	string	filename;
	int		line_num;

	IfNest(Keyword keyword, bool flag, const string& filename, int line_num);
};

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


class SourceFileStack {

};
#endif
