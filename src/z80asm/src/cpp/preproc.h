//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// Copyright (C) Paulo Custodio, 2011-2022
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
	void clear() { filename.clear(); line_num = 0; line_inc = 1; }
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
	bool get_unpreproc_line(string& line);
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
	Macros				m_macros;		// MACRO..ENDM macros

	bool recursive_include(const string& filename);

	Macros& defines() { return m_levels.back().defines; }
	Macros& defines_base() { return m_levels.front().defines; }

	void got_eof();
	void parse_line(const string& line);
	void do_label();
	bool ifs_active();

	bool check_opcode(Keyword keyword, void (Preproc::* do_action)());
	bool check_hash_directive(Keyword keyword, void (Preproc::* do_action)());
	bool check_hash();
	bool check_defl();
	bool check_macro();
	bool check_macro_call();
	bool check_reptx();

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
	void do_include();
	void do_binary();
	void do_define();
	void do_undef();
	void do_defl(const string& name);
	void do_macro(const string& name);
	void do_macro_call(shared_ptr<Macro> macro);
	void do_local();
	void do_exitm();
	void do_rept();
	void do_reptc();
	void do_repti();
	void do_float();
	void do_setfloat();

	ExpandedText expand(Lexer& lexer, Macros& defines);
	string expand(const string& text);
	void expand_ident(ExpandedText& out, const string& ident, Lexer& lexer, Macros& defines);
	ExpandedText expand_define_call(const string& name, Lexer& lexer, Macros& defines);
	string collect_param(Lexer& lexer);
	vector<string> collect_macro_params(Lexer& lexer);
	vector<string> collect_name_list(Lexer& lexer);
	string collect_macro_body(Keyword start_keyword, Keyword end_keyword);
	string collect_reptc_arg(Lexer& lexer);
};
