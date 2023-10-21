//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "defines.h"
#include "errors.h"
#include "if.h"
#include "scan.h"
#include <deque>
#include <fstream>
#include <iostream>
#include <list>
#include <string>
using namespace std;

//-----------------------------------------------------------------------------

struct PreprocLevel {
	Macros		defines;			// #defines, macro args
	bool		exitm_called{ false };

	PreprocLevel(Macros* parent = nullptr);
	void split_lines(ScannedLine& line);
	bool getline(ScannedLine& line);

private:
	deque<ScannedLine>	m_lines;
};

//-----------------------------------------------------------------------------

class ExpandedLine : public ScannedLine {
public:
    ExpandedLine(const string& text = "", const vector<Token>& tokens = {});

	bool got_error() const { return m_error; }
	void set_error(bool f) { m_error = f; }
private:
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
	bool getline(ScannedLine& line);
	bool get_unpreproc_line(ScannedLine& line);
	const Location& location() const;
	bool is_c_source() const;
    void set_location(Location location);
	void set_filename(const string& filename);
	void set_line_num(int line_num, int line_inc = 1);
	void set_c_source(bool f);

private:
	list<FileScanner>	m_files;		// input stack of files
	list<PreprocLevel>	m_levels;		// levels of macro expansion
	deque<ScannedLine>	m_output;       // parsed output
	vector<IfNest>		m_if_stack;		// state of nested IFs
	Macros				m_macros;		// MACRO..ENDM macros
    ScannedLine         m_line;         // line being parsed
    bool                m_reading_macro_body{ false };

	bool getline1(ScannedLine& line);
	bool recursive_include(const string& filename);

	Macros& defines() { return m_levels.back().defines; }
	Macros& defines_base() { return m_levels.front().defines; }

	void got_eof();
	void parse_line(const ScannedLine& line);     // sets m_line
	bool ifs_active();
	bool symbol_defined(const Token& ident);

    int check_label_index();    // -1 if no label, else index of Ident token
    void do_label(int label_index);

    bool check_opcode(Keyword keyword, void (Preproc::* do_action)());
	bool check_hash_directive(Keyword keyword, void (Preproc::* do_action)());
	bool check_opt_hash_opcode(Keyword keyword, void (Preproc::* do_action)());
	bool check_hash();
	bool check_defl();
	bool check_macro();
	bool check_macro_call();
	bool check_reptx();
	bool check_gbz80_opcodes();
	bool check_z80_ld_bit_opcodes();

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
    void do_line();
    void do_c_line();

    void push_expanded(ScannedLine& line, Macros& defines);
	ExpandedLine expand(ScannedLine& line, Macros& defines);
	void expand_ident(ExpandedLine& out, const Token& ident, ScannedLine& line, Macros& defines);
	ExpandedLine expand_define_call(const Token& ident, ScannedLine& line, Macros& defines);
	ScannedLine collect_param(ScannedLine& line);
	vector<ScannedLine> collect_macro_params(ScannedLine& line);
	vector<string> collect_name_list(ScannedLine& line);
    ScannedLine collect_macro_body(Keyword start_keyword, Keyword end_keyword);
    ScannedLine collect_macro_body1(Keyword start_keyword, Keyword end_keyword);
	string collect_reptc_arg(ScannedLine& line);
};

extern Preproc g_preproc;
