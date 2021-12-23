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

//-----------------------------------------------------------------------------

struct Location {
	string filename;
	int line_num;
	int line_inc{ 1 };

	Location(const string& filename = "", int line_num = 0);
	void inc_line() { line_num += line_inc; }
};

//-----------------------------------------------------------------------------

struct PreprocLevel {
	Macros		defines;			// #defines, macro args
	bool		exitm_called{ false };

	PreprocLevel(Macros* parent = nullptr);
	void init(const string& text = "");
	bool getline(string& line);

private:
	deque<string>	m_lines;
};

//-----------------------------------------------------------------------------

struct PreprocFile {
	string			filename;
	ifstream		ifs;
	Location		location;
	bool			is_c_source{ false };

	PreprocFile(const string& filename, ifstream& ifs);
	bool getline(string& line);

private:
	PreprocLevel	 m_queue;		// used to split input lines

	bool get_cont_lines(string& line);
	bool get_source_line(string& line);
};

//-----------------------------------------------------------------------------

class ExpandedText {
public:
	string text() const { return m_text; }
	bool got_error() const { return m_error; }
	void append(const string& str);
	void set_error(bool f) { m_error = f; }
private:
	string  m_text;
	bool    m_error{ false };
};

//-----------------------------------------------------------------------------

struct IfNest {
	Keyword		keyword;
	Location	location;
	bool		flag;
	bool		done_if;

	IfNest(Keyword keyword, Location location, bool flag);
};

//-----------------------------------------------------------------------------

class Preproc {
public:
	Preproc();

	bool open(const string& filename, bool search_include_path);
	void close();
	bool getline(string& line);
	string filename() const;
	int line_num() const;
	bool is_c_source() const;
	void set_filename(const string& filename);
	void set_line_num(int line_num, int line_inc = 1);
	void set_c_source(bool f);

private:
	list<PreprocFile>	m_files;		// input stack of files
	list<PreprocLevel>	m_levels;		// levels of macro expansion
	deque<string>		m_output;       // parsed output
	vector<IfNest>		m_if_stack;		// state of nested IFs
	Lexer				m_lexer;		// line being parsed

	bool recursive_include(const string& filename);
	bool getline_(string& lime);

	Macros& defines() { return m_levels.back().defines; }
	Macros& defines_base() { return m_levels.front().defines; }

	void got_eof();
	void parse_line(const string& line);
	void do_label();
	bool ifs_active();

	bool check_keyword(Keyword keyword, void (Preproc::* do_action)());

	void do_if();
	void do_else();
	void do_endif();
	void do_ifdef_ifndef(bool invert);
	void do_ifdef();
	void do_ifndef();
	void do_elif();
	void do_elifdef_elifndef(bool invert);
	void do_elifdef();
	void do_elifndef();

	ExpandedText expand(Lexer& lexer, Macros& defines);
	void expand_ident(ExpandedText& out, const string& ident, Lexer& lexer, Macros& defines);
	ExpandedText expand_define_call(const string& name, Lexer& lexer, Macros& defines);
	string collect_param(Lexer& lexer);
	vector<string> collect_macro_params(Lexer& lexer);
};

#if 0


bool starts_with_hash(const string& line);
void split_lines(deque<string>& lines, const string& line);

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

	bool recursive_include(const string& filename);
};

// joins continuation lines, splits lines by '\\'
class LineSplitFilter : public LineFilter {
public:
	LineSplitFilter(LineSource* source);

private:
	bool get_source_line(string& line);
	void parse_line(const string& line) override;
};

// scanner for macro parameters
class ParamScanner {
public:
	ParamScanner(const string& text = "") { init_text(text); }
	void init_text(const string& text) { m_text = text; p = m_text.c_str(); }
	vector<string> collect_params();
	bool collect_param(string& param);
	string collect_name();
	char next_char();
	bool expect_eol();

protected:
	string		m_text;
	const char* p{ nullptr };
};

// expands macros
class MacroExpander : public ParamScanner {
public:
	MacroExpander(const string& text, Macros* defines);
	string expand();

private:
	Macros*		m_defines;
	string		m_output;
	bool			m_recursive_error{ false };

	void do_expand();
	void check_macro_call(const string& name);
	void expand_macro(shared_ptr<Macro> macro);
};

struct PreprocLevel {
	Macros		defines;					// #defines, macro args
	bool			exitm_called{ false };

	PreprocLevel(Macros* parent = nullptr);
	void init(const string& line = "");
	bool getline(string& line);

private:
	deque<string>	m_lines;
};

struct IfNest {
	Keyword keyword;
	bool		flag;
	bool		done_if;
	string	filename;
	int		line_num;

	IfNest(Keyword keyword, bool flag, const string& filename, int line_num);
};

class PreprocFilter : public LineFilter, public ParamScanner {
public:
	PreprocFilter(LineSource* source);
	void got_eof() override;
	bool getline(string& line) override;

private:
	list<PreprocLevel>	m_levels;		// levels of macro expansion
	Macros				m_macros;		// opcode-like macros
	vector<IfNest>		m_if_stack;		// stack of active IFs

	void parse_line(const string& line) override;
	void parse_define(const string& name);
	void parse_params(shared_ptr<Macro> macro);

	bool check_ifs(const string& line);
	bool check_defines(const string& line);
	bool check_macro_call(const string& line);

	void do_label(const string& name);
	void do_if();
	void do_ifdef();
	void do_ifndef();
	void do_elif();
	void do_elifdef();
	void do_elifndef();
	void do_else();
	void do_endif();
	void do_macro_call(shared_ptr<Macro> macro);

	bool ifs_active() const;
};

extern SourceFileStack g_source_file_stack;
extern PreprocFilter g_preproc_filter;
extern LineSplitFilter g_preproc;
#endif
