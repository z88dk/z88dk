//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "float.h"
#include "if.h"
#include "lex.h"
#include "preproc.h"
#include "utils.h"
#include "asmerrors.h"
#include <cassert>
using namespace std;

//-----------------------------------------------------------------------------
// global state
static bool g_hold_getline;
static bool g_do_preproc_line;
static Preproc g_preproc;

//-----------------------------------------------------------------------------

static string concat(const string& s1, const string& s2) {
	if (s1.empty() || s2.empty())
		return s1 + s2;
	else if (str_ends_with(s1, "##"))   // cpp-style concatenation
		return s1.substr(0, s1.length() - 2) + s2;
	else if (isspace(s1.back()) || isspace(s2.front()))
		return s1 + s2;
	else if (isident(s1.back()) && isident(s2.front()))
		return s1 + " " + s2;
	else if (s1.back() == '$' && isxdigit(s2.front()))
		return s1 + " " + s2;
	else if ((s1.back() == '%' || s1.back() == '@') &&
		(isdigit(s2.front()) || s2.front() == '"'))
		return s1 + " " + s2;
	else if ((s1.back() == '&' && s2.front() == '&') ||
		(s1.back() == '|' && s2.front() == '|') ||
		(s1.back() == '^' && s2.front() == '^') ||
		(s1.back() == '*' && s2.front() == '*') ||
		(s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
		(s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
		(s1.back() == '=' && s2.front() == '=') ||
		(s1.back() == '!' && s2.front() == '=') ||
		(s1.back() == '#' && s2.front() == '#'))
		return s1 + " " + s2;
	else
		return s1 + s2;
}

static int next_id() {
	static int id = 0;
	return ++id;
}

static string unique_name(const string& name) {
	return name + "__" + std::to_string(next_id());
}

//-----------------------------------------------------------------------------

Location::Location(const string& filename, int line_num)
	: filename(filename), line_num(line_num) {}

//-----------------------------------------------------------------------------

PreprocLevel::PreprocLevel(Macros* parent)
	: defines(parent) {
	init();
}

void PreprocLevel::init(const string& text) {
	if (!text.empty()) {
		if (g_do_preproc_line && !starts_with_hash(text))
			split_lines(m_lines, text);
		else
			m_lines.push_back(text);
	}
}

bool PreprocLevel::getline(string& line) {
	line.clear();
	if (m_lines.empty())
		return false;

	line = m_lines.front();
	m_lines.pop_front();

	return true;
}

//-----------------------------------------------------------------------------

PreprocFile::PreprocFile(const string& filename, ifstream& ifs)
	: filename(filename)
	, ifs(move(ifs))
	, location(filename, 0) {}

bool PreprocFile::getline(string& line) {
	while (true) {
		if (m_queue.getline(line))
			return true;
		else if (get_cont_lines(line))
			m_queue.init(line);
		else
			return false;
	}
}

bool PreprocFile::get_cont_lines(string& line) {
	if (!get_source_line(line))
		return false;

	// if line ends with backslash, concatenate with next line
	while (remove_final_backslash(line)) {
		string this_line;
		if (get_source_line(this_line)) {
			line += this_line;
		}
		else {
			line += "\n";			// eof, put back newline
			break;
		}
	}
	return true;
}

bool PreprocFile::get_source_line(string& line) {
	line.clear();

	if (!ifs.is_open() || ifs.eof())
		return false;

	// read line
	if (!safe_getline(ifs, line))
		return false;

	line.push_back('\n');
	location.inc_line();

	list_got_source_line(location.filename.c_str(), location.line_num, line.c_str());
	set_error_location(location.filename.c_str(), location.line_num);
	set_error_source_line(line.c_str());

	return true;
}

//-----------------------------------------------------------------------------

void ExpandedText::append(const string& str) {
	m_text = concat(m_text, str);
}

//-----------------------------------------------------------------------------

IfNest::IfNest(Keyword keyword, Location location, bool flag)
	: keyword(keyword), location(location), flag(flag), done_if(false) {}

//-----------------------------------------------------------------------------

Preproc::Preproc() {
	m_levels.emplace_back();
}

bool Preproc::open(const string& filename, bool search_include_path) {
	// search file in path
	string found_filename = filename;
	if (search_include_path)
		found_filename = search_includes(filename.c_str());

	// check for recursive includes
	if (recursive_include(found_filename)) {
		g_errors.error(ErrCode::IncludeRecursion, filename);
		return false;
	}

	// open file
	ifstream ifs(found_filename, ios::binary);
	if (!ifs.is_open()) {
		g_errors.error(ErrCode::FileOpen, found_filename);
		return false;
	}
	else {
		m_files.emplace_back(found_filename, ifs);
		return true;
	}
}

void Preproc::close() {
	m_files.clear();
	m_levels.clear();
	m_output.clear();
	m_if_stack.clear();
	m_macros.clear();

	m_levels.emplace_back();
	g_float_format.set(FloatFormat::Format::genmath);
}

bool Preproc::getline(string& line) {
	line.clear();
	while (true) {
		if (!m_output.empty()) {		// output queue
			line = m_output.front();
			m_output.pop_front();
			if (!line.empty())
				return true;
		}
		else if (m_levels.back().getline(line)) {	// read from macro expansion
			if (g_do_preproc_line)
				parse_line(line);
			else
				m_output.push_back(line);
		}
		else if (m_levels.size() > 1)	// end of macro expansion
			m_levels.pop_back();		// drop one level and continue
		else if (m_files.empty()) {		// end of input
			got_eof();
			return false;
		}
		else if (m_files.back().getline(line)) {	// read from file
			if (g_do_preproc_line)
				parse_line(line);
			else
				m_output.push_back(line);
		}
		else
			m_files.pop_back();
	}
}

bool Preproc::get_unpreproc_line(string& line) {
	bool save_do_preproc_line = g_do_preproc_line;
	g_do_preproc_line = false;
	bool ret = getline(line);
	g_do_preproc_line = save_do_preproc_line;
	return ret;
}

string Preproc::filename() const {
	if (!m_files.empty())
		return m_files.back().location.filename;
	else
		return "";
}

int Preproc::line_num() const {
	if (!m_files.empty())
		return m_files.back().location.line_num;
	else
		return 0;
}

bool Preproc::is_c_source() const {
	if (m_files.empty())
		return false;
	else
		return m_files.back().is_c_source;
}

void Preproc::set_filename(const string& filename) {
	if (!m_files.empty())
		m_files.back().location.filename = filename;
}

void Preproc::set_line_num(int line_num, int line_inc) {
	if (!m_files.empty()) {
		m_files.back().location.line_num = line_num - line_inc;
		m_files.back().location.line_inc = line_inc;
	}
}

void Preproc::set_c_source(bool f) {
	if (!m_files.empty())
		m_files.back().is_c_source = f;
}

bool Preproc::recursive_include(const string& filename) {
	for (auto& elem : m_files) {
		if (elem.filename == filename)
			return true;
	}
	return false;
}

void Preproc::got_eof() {
	if (!m_if_stack.empty()) {
		g_errors.error(ErrCode::UnbalancedStructStartedAt,
			m_if_stack.back().location.filename + ":" +
			std::to_string(m_if_stack.back().location.line_num));
		m_if_stack.clear();
	}
	close();
}

void Preproc::parse_line(const string& line) {
	m_lexer.set(line);

	// do these irrespective of ifs_active()
	if (check_opcode(Keyword::IF, &Preproc::do_if)) return;
	if (check_opcode(Keyword::ELSE, &Preproc::do_else)) return;
	if (check_opcode(Keyword::ENDIF, &Preproc::do_endif)) return;
	if (check_opcode(Keyword::IFDEF, &Preproc::do_ifdef)) return;
	if (check_opcode(Keyword::IFNDEF, &Preproc::do_ifndef)) return;
	if (check_opcode(Keyword::ELIF, &Preproc::do_elif)) return;
	if (check_opcode(Keyword::ELIFDEF, &Preproc::do_elifdef)) return;
	if (check_opcode(Keyword::ELIFNDEF, &Preproc::do_elifndef)) return;

	if (!ifs_active()) return;

	// do these only if ifs_active()
	if (check_hash_directive(Keyword::DEFINE, &Preproc::do_define)) return;
	if (check_hash_directive(Keyword::INCLUDE, &Preproc::do_include)) return;
	if (check_hash_directive(Keyword::UNDEF, &Preproc::do_undef)) return;
	if (check_opcode(Keyword::BINARY, &Preproc::do_binary)) return;
	if (check_opcode(Keyword::EXITM, &Preproc::do_exitm)) return;
	if (check_opcode(Keyword::FLOAT, &Preproc::do_float)) return;
	if (check_opcode(Keyword::INCBIN, &Preproc::do_binary)) return;
	if (check_opcode(Keyword::INCLUDE, &Preproc::do_include)) return;
	if (check_opcode(Keyword::LOCAL, &Preproc::do_local)) return;
	if (check_opcode(Keyword::SETFLOAT, &Preproc::do_setfloat)) return;
	if (check_defl()) return;
	if (check_macro()) return;
	if (check_reptx()) return;
	if (check_hash()) return;

	// last check - macro call
	if (check_macro_call()) return;

	// expand macros in text
	m_lexer.rewind();
	ExpandedText expanded = expand(m_lexer, defines());
	if (expanded.got_error())
		m_output.push_back(line);
	else
		m_output.push_back(expanded.text());
}

void Preproc::do_label() {
	// extract label
	string line = m_lexer.peek().svalue + ":\n";
	m_lexer.next();

	// expand macros in label
	m_output.push_back(expand(line));
}

bool Preproc::ifs_active() {
	if (m_levels.back().exitm_called)
		return false;
	for (auto& f : m_if_stack) {
		if (!f.flag)
			return false;
	}
	return true;
}

bool Preproc::check_opcode(Keyword keyword, void(Preproc::* do_action)()) {
	if (m_lexer[0].is(TType::Label) && m_lexer[1].is(keyword)) {
		if (ifs_active())
			do_label();
		else
			m_lexer.next();
		m_lexer.next();
		((*this).*(do_action))();
		return true;
	}
	else if (m_lexer[0].is(keyword)) {
		m_lexer.next();
		((*this).*(do_action))();
		return true;
	}
	else
		return false;
}

bool Preproc::check_hash_directive(Keyword keyword, void(Preproc::* do_action)()) {
	if (m_lexer[0].is(TType::Hash) && m_lexer[1].is(keyword)) {
		m_lexer.next();
		m_lexer.next();
		((*this).*(do_action))();
		return true;
	}
	else
		return false;
}

bool Preproc::check_hash() {
	if (m_lexer[0].is(TType::Hash))
		return true;
	else
		return false;
}

bool Preproc::check_defl() {
	if (m_lexer[0].is(TType::Label, TType::Ident) &&
		m_lexer[1].is(Keyword::DEFL)) {
		string name = m_lexer[0].svalue;
		m_lexer.next();				// skip name
		m_lexer.next();				// skip DEFC
		do_defl(name);
		return true;
	}
	else if (m_lexer[0].is(Keyword::DEFL) &&
		m_lexer[1].is(TType::Ident) &&
		m_lexer[2].is(TType::Eq)) { 
		string name = m_lexer[1].svalue;
		m_lexer.next();				// skip DEFL
		m_lexer.next();				// skip name
		m_lexer.next();				// skip '='
		do_defl(name);
		return true;
	}
	else
		return false;
}

bool Preproc::check_macro() {
	if (m_lexer[0].is(TType::Label, TType::Ident) &&
		m_lexer[1].is(Keyword::MACRO)) {
		string name = m_lexer[0].svalue;
		m_lexer.next();				// skip name
		m_lexer.next();				// skip MACRO
		do_macro(name);
		return true;
	}
	else if (m_lexer[0].is(Keyword::MACRO) &&
		m_lexer[1].is(TType::Ident)) {
		string name = m_lexer[1].svalue;
		m_lexer.next();				// skip MACRO
		m_lexer.next();				// skip name
		do_macro(name);
		return true;
	}
	else if (m_lexer[0].is(Keyword::ENDM)) {
		g_errors.error(ErrCode::UnbalancedStruct);
		return true;
	}
	else
		return false;
}

bool Preproc::check_macro_call() {
	if (m_lexer[0].is(TType::Label) && m_lexer[1].is(TType::Ident)) {
		string name = m_lexer[1].svalue;
		// find in MACRO macros OR in #define macros
		shared_ptr<Macro> macro = m_macros.find_all(name);
		if (!macro)       macro = defines().find_all(name);
		if (macro) {
			do_label();
			m_lexer.next();
			do_macro_call(macro);
			return true;
		}
	}

	if (m_lexer[0].is(TType::Ident)) {
		string name = m_lexer[0].svalue;
		// find in MACRO macros OR in #define macros
		shared_ptr<Macro> macro = m_macros.find_all(name);
		if (!macro)       macro = defines().find_all(name);
		if (macro) {
			m_lexer.next();
			do_macro_call(macro);
			return true;
		}
	}

	return false;
}

bool Preproc::check_reptx() {
	if (m_lexer[0].is(Keyword::REPT)) {
		m_lexer.next();
		do_rept();
		return true;
	}
	else if (m_lexer[0].is(Keyword::REPTC)) {
		m_lexer.next();
		do_reptc();
		return true;
	}
	else if (m_lexer[0].is(Keyword::REPTI)) {
		m_lexer.next();
		do_repti();
		return true;
	}
	else if (m_lexer[0].is(Keyword::ENDR)) {
		g_errors.error(ErrCode::UnbalancedStruct);
		return true;
	}
	else
		return false;
}

void Preproc::do_if() {
	// expand macros in condition
	string cond_text = expand(m_lexer.text_ptr());

	// check condition
	bool flag, error;
	parse_expr_eval_if_condition(cond_text.c_str(), &flag, &error);
	if (!error) {
		m_if_stack.emplace_back(Keyword::IF, m_files.back().location, flag);
		m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
	}
}

void Preproc::do_else() {
	if (!m_lexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename + ":" +
				std::to_string(m_if_stack.back().location.line_num));
		else {
			bool flag = !m_if_stack.back().done_if;
			m_if_stack.back().keyword = Keyword::ELSE;
			m_if_stack.back().flag = flag;
			m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
		}
	}
}

void Preproc::do_endif() {
	if (!m_lexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF && last != Keyword::ELSE)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename + ":" +
				std::to_string(m_if_stack.back().location.line_num));
		else
			m_if_stack.pop_back();
	}
}

void Preproc::do_ifdef_ifndef(bool invert) {
	if (!m_lexer.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		string name = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			// expand macros in condition
			string cond_text = expand(name);

			// check condition
			bool f = check_ifdef_condition(cond_text.c_str());
			if (invert)
				f = !f;
			m_if_stack.emplace_back(Keyword::IF, m_files.back().location, f);
			m_if_stack.back().done_if = m_if_stack.back().done_if || f;
		}
	}
}

void Preproc::do_ifdef() {
	do_ifdef_ifndef(false);
}

void Preproc::do_ifndef() {
	do_ifdef_ifndef(true);
}

void Preproc::do_elif() {
	if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename + ":" +
				std::to_string(m_if_stack.back().location.line_num));
		else {
			// expand macros in condition
			string cond_text = expand(m_lexer.text_ptr());

			// check condition
			bool flag, error;
			parse_expr_eval_if_condition(cond_text.c_str(), &flag, &error);
			if (!error) {
				if (m_if_stack.back().done_if)
					flag = false;
				m_if_stack.back().keyword = Keyword::ELIF;
				m_if_stack.back().flag = flag;
				m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
			}
		}
	}
}

void Preproc::do_elifdef_elifndef(bool invert) {
	if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename + ":" +
				std::to_string(m_if_stack.back().location.line_num));
		else {
			if (!m_lexer.peek().is(TType::Ident))
				g_errors.error(ErrCode::Syntax);
			else {
				string name = m_lexer.peek().svalue;
				m_lexer.next();
				if (!m_lexer.peek().is(TType::Newline))
					g_errors.error(ErrCode::Syntax);
				else {
					// expand macros in condition
					string cond_text = expand(name);

					// check condition
					bool f = check_ifdef_condition(cond_text.c_str());
					if (invert)
						f = !f;
					if (m_if_stack.back().done_if)
						f = false;
					m_if_stack.back().keyword = Keyword::ELIF;
					m_if_stack.back().flag = f;
					m_if_stack.back().done_if = m_if_stack.back().done_if || f;
				}
			}
		}
	}
}

void Preproc::do_elifdef() {
	do_elifdef_elifndef(false);
}

void Preproc::do_elifndef() {
	do_elifdef_elifndef(true);
}

void Preproc::do_include() {
	if (!m_lexer.peek().is(TType::String))
		g_errors.error(ErrCode::Syntax);
	else {
		string filename = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			open(filename, true);
		}
	}
}

void Preproc::do_binary() {
	if (!m_lexer.peek().is(TType::String))
		g_errors.error(ErrCode::Syntax);
	else {
		string filename = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			// search file in path
			string found_filename = search_includes(filename.c_str());

			// open file
			ifstream ifs(found_filename, ios::binary);
			if (!ifs.is_open())
				g_errors.error(ErrCode::FileOpen, found_filename);
			else {
				// output DEFB lines
				const int line_len = 16;
				unsigned char bytes[line_len];

				while (!ifs.eof()) {
					ifs.read(reinterpret_cast<char*>(bytes), line_len);
					size_t num_read = static_cast<size_t>(ifs.gcount());
					if (num_read > 0) {
						string line = "defb ";
						string separator = "";
						for (size_t i = 0; i < num_read; i++) {
							line += separator + std::to_string(bytes[i]);
							separator = ",";
						}
						line += "\n";
						m_output.push_back(line);
					}
				}
			}
		}
	}
}

void Preproc::do_define() {
	if (!m_lexer.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get name
		size_t name_col = m_lexer.peek().col;
		string name = m_lexer.peek().svalue;
		m_lexer.next();

		// check if name is followed by '(' without spaces
		size_t this_col = m_lexer.peek().col;
		bool has_space = (this_col > name_col + name.length());
		bool has_args = (!has_space && m_lexer.peek().is(TType::Lparen));

		// create macro
		auto macro = make_shared<Macro>(name);
		defines_base().add(macro);				// create macro

		// collect args
		if (has_args) {
			m_lexer.next();						// skip '('
			while (true) {
				if (!m_lexer.peek().is(TType::Ident)) {
					g_errors.error(ErrCode::Syntax);
					return;
				}
				string arg = m_lexer.peek().svalue;
				macro->push_arg(arg);
				m_lexer.next();					// skip name

				if (m_lexer.peek().is(TType::Comma)) {
					m_lexer.next();				// skip ','
					continue;
				}
				else if (m_lexer.peek().is(TType::Rparen)) {
					m_lexer.next();				// skip ')'
					break;
				}
				else {
					g_errors.error(ErrCode::Syntax);
					return;
				}
			}
		}

		// collect body
		string body = str_chomp(m_lexer.text_ptr());
		macro->push_body(body);

		while (!m_lexer.peek().is(TType::Newline))
			m_lexer.next();
	}
}

void Preproc::do_undef() {
	if (!m_lexer.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get name
		string name = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else
			defines_base().remove(name);
	}
}

void Preproc::do_defl(const string& name) {
	if (m_lexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		// if name is not defined, create an empty one
		if (!defines_base().find(name)) {
			auto macro = make_shared<Macro>(name);
			defines_base().add(macro);
		}

		// expand macros in expression, may refer to name
		string text = str_chomp(expand(m_lexer.text_ptr()));

		// redefine name
		defines_base().remove(name);
		auto macro = make_shared<Macro>(name);
		macro->push_body(text);
		defines_base().add(macro);
	}
}

void Preproc::do_macro(const string& name) {
	// create macro
	auto macro = make_shared<Macro>(name);
	m_macros.add(macro);								// create macro

	// collect args
	if (!m_lexer.peek().is(TType::Newline)) {
		vector<string> args = collect_name_list(m_lexer);
		for (auto& arg : args)
			macro->push_arg(arg);
	}

	// collect body
	string body = collect_macro_body(Keyword::MACRO, Keyword::ENDM);
	macro->push_body(body);
}

void Preproc::do_macro_call(shared_ptr<Macro> macro) {
	// collect arguments
	vector<string> params;
	if (macro->args().size() != 0) {
		params = collect_macro_params(m_lexer);
		if (macro->args().size() != params.size()) {
			g_errors.error(ErrCode::MacroArgsNumber, macro->name());
			return;
		}
	}

	// create new level of macro expansion
	m_levels.emplace_back(&defines());

	// create macros in the new level for each argument
	for (size_t i = 0; i < macro->args().size(); i++) {
		string arg = macro->args()[i];
		string param = i < params.size() ? params[i] : "";
		shared_ptr<Macro> param_macro = make_shared<Macro>(arg, param);
		defines().add(param_macro);
	}

	// create lines from body; append rest of the macro call line
	string body = macro->body() + " " + string(m_lexer.text_ptr());
	m_levels.back().init(body);
}

void Preproc::do_local() {
	// collect symbols
	vector<string> names = collect_name_list(m_lexer);
	for (auto& name : names) {
		// define new name
		string def_name = unique_name(name);
		auto macro = make_shared<Macro>(name);
		macro->push_body(def_name);
		defines().add(macro);			// add to top layer
	}
}

void Preproc::do_exitm() {
	if (!m_lexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_levels.size() == 1)
		g_errors.error(ErrCode::UnbalancedStruct);
	else
		m_levels.back().exitm_called = true;
}

void Preproc::do_rept() {
	if (m_lexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		int count = 0;
		bool error = false;

		string count_text = expand(m_lexer.text_ptr());
		parse_const_expr_eval(count_text.c_str(), &count, &error);
		if (!error) {
			string body = collect_macro_body(Keyword::REPT, Keyword::ENDR);

			// create new level for expansion
			m_levels.emplace_back(&defines());
			string block;
			for (int i = 0; i < count; i++)
				block += body;

			m_levels.back().init(block);
		}
	}
}

void Preproc::do_reptc() {
	if (!m_lexer.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get variable to iterate
		string var = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Comma))
			g_errors.error(ErrCode::Syntax);
		else {
			m_lexer.next();
			// build string to iterate
			string str = collect_reptc_arg(m_lexer);
			string body = collect_macro_body(Keyword::REPTC, Keyword::ENDR);

			// create new level for expansion
			m_levels.emplace_back(&defines());
			string block = "\n";			// lines starting with # are not split
			for (auto& c : str) {
				block += "#undef " + var + "\n";
				block += "#define " + var + " " + std::to_string(c) + "\n";
				block += body;
			}

			// create lines from body
			m_levels.back().init(block);
		}
	}
}

void Preproc::do_repti() {
	if (!m_lexer.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get variable to iterate
		string var = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Comma))
			g_errors.error(ErrCode::Syntax);
		else {
			m_lexer.next();
			if (m_lexer.peek().is(TType::Newline))
				g_errors.error(ErrCode::Syntax);
			else {
				// collect params to iterate
				vector<string> params = collect_macro_params(m_lexer);
				if (!m_lexer.peek().is(TType::Newline))
					g_errors.error(ErrCode::Syntax);
				else {
					string body = collect_macro_body(Keyword::REPTI, Keyword::ENDR);

					// expand macros in parameters
					for (auto& param : params)
						param = expand(param);

					// create new level for expansion
					m_levels.emplace_back(&defines());
					string block = "\n";			// lines starting with # are not split
					for (auto& param : params) {
						block += "#undef " + var + "\n";
						block += "#define " + var + " " + param + "\n";
						block += body;
					}

					// create lines from body
					m_levels.back().init(block);
				}
			}
		}
	}
}

void Preproc::do_float() {
	string expanded = expand(m_lexer.text_ptr());	// expand macros in line
	Lexer sublexer{ expanded };

	if (sublexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		while (true) {
			// parse expression
			FloatExpr expr{ sublexer };
			if (!expr.parse()) {
				g_errors.error(ErrCode::Syntax, expanded);
				return;
			}
			else if (expr.eval_error()) {
				g_errors.error(ErrCode::ExprEval, expanded);
				return;
			}
			else {
				double value = expr.value();
				vector<uint8_t> bytes = g_float_format.float_to_bytes(value);
				string bytes_csv = vector_to_csv(bytes);
				string line = "defb " + bytes_csv +
					";float." + g_float_format.get_type() + "(" + std::to_string(value) + ")\n";
				m_output.push_back(line);
			}

			// check for next
			if (sublexer.peek().is(TType::Comma)) {
				sublexer.next();
				continue;
			}
			else if (sublexer.peek().is(TType::Newline))
				break;
			else {
				g_errors.error(ErrCode::Syntax);
				return;
			}
		}
	}
}

void Preproc::do_setfloat() {
	string expanded = expand(m_lexer.text_ptr());	// expand macros in line
	Lexer sublexer{ expanded };

	if (sublexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (sublexer.peek().is(TType::Ident)) {
		string format = sublexer.peek().svalue;
		sublexer.next();
		if (!sublexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else if (!set_float_format(format.c_str()))
			g_errors.error(ErrCode::InvalidFloatFormat, FloatFormat::get_formats());
		else {}
	}
}

ExpandedText Preproc::expand(Lexer& lexer, Macros& defines) {
	ExpandedText out;

	while (!lexer.at_end()) {
		Token token = lexer[0];
		lexer.next();

		switch (token.ttype) {
		case TType::End:
			break;
		case TType::Newline: out.append("\n"); break;
		case TType::Ident:
			expand_ident(out, token.svalue, lexer, defines);
			break;
		case TType::Label:
			expand_ident(out, token.svalue, lexer, defines);
			out.append(":");
			break;
		case TType::Integer: out.append(to_string(token.ivalue)); break;
		case TType::Floating: out.append(to_string(token.fvalue)); break;
		case TType::String: out.append("\"" + str_expand_escapes(token.svalue) + "\""); break;
		case TType::ASMPC: out.append("$"); break;
		case TType::BinNot: out.append("~"); break;
		case TType::LogNot: out.append("!"); break;
		case TType::BinAnd: out.append("&"); break;
		case TType::LogAnd: out.append("&&"); break;
		case TType::BinOr: out.append("|"); break;
		case TType::LogOr: out.append("||"); break;
		case TType::BinXor: out.append("^"); break;
		case TType::LogXor: out.append("^^"); break;
		case TType::Plus: out.append("+"); break;
		case TType::Minus: out.append("-"); break;
		case TType::Mul: out.append("*"); break;
		case TType::Pow: out.append("**"); break;
		case TType::Div: out.append("/"); break;
		case TType::Mod: out.append("%"); break;
		case TType::Eq: out.append("="); break;
		case TType::Ne: out.append("!="); break;
		case TType::Lt: out.append("<"); break;
		case TType::Le: out.append("<="); break;
		case TType::Gt: out.append(">"); break;
		case TType::Ge: out.append(">="); break;
		case TType::Shl: out.append("<<"); break;
		case TType::Shr: out.append(">>"); break;
		case TType::Quest: out.append("?"); break;
		case TType::Colon: out.append(":"); break;
		case TType::Dot: out.append("."); break;
		case TType::Comma: out.append(","); break;
		case TType::Hash: out.append("#"); break;
		case TType::DblHash: out.append("##"); break;
		case TType::Lparen: out.append("("); break;
		case TType::Rparen: out.append(")"); break;
		case TType::Lsquare: out.append("["); break;
		case TType::Rsquare: out.append("]"); break;
		case TType::Lbrace: out.append("{"); break;
		case TType::Rbrace: out.append("}"); break;
		case TType::Backslash: out.append("\n"); break;
		default: assert(0);
		}
	}
	return out;
}

string Preproc::expand(const string& text) {
	Lexer sublexer{ text };
	ExpandedText expanded = expand(sublexer, defines());
	if (expanded.got_error())
		return text;
	else
		return expanded.text();
}

void Preproc::expand_ident(ExpandedText& out, const string& ident, Lexer& lexer, Macros& defines) {
	size_t pos = lexer.pos();
	ExpandedText expanded = expand_define_call(ident, lexer, defines);
	if (expanded.got_error()) {
		lexer.set_pos(pos);
		out.append(ident);
	}
	else
		out.append(expanded.text());
}

ExpandedText Preproc::expand_define_call(const string& name, Lexer& lexer, Macros& defines) {
	ExpandedText out;

	shared_ptr<Macro> macro = defines.find_all(name);
	if (!macro) {							// macro does not exists - insert name
		out.append(name);
		return out;
	}

	// macro exists
	if (macro->is_expanding()) {				// recursive invocation
		out.append(macro->body());
		out.set_error(true);
		return out;
	}

	// collect arguments
	vector<string> params;
	if (macro->args().size() != 0) {
		params = collect_macro_params(lexer);
		if (macro->args().size() != params.size()) {
			g_errors.error(ErrCode::MacroArgsNumber, macro->name());
			return out;
		}
	}

	// create macros for each argument
	Macros sub_defines{ defines };				// create scope for arguments
	for (size_t i = 0; i < macro->args().size(); i++) {
		string arg = macro->args()[i];
		string param = i < params.size() ? params[i] : "";
		shared_ptr<Macro> param_macro = make_shared<Macro>(arg, param);
		sub_defines.add(param_macro);
	}

	// expand macro
	macro->set_expanding(true);
	Lexer sub_lexer{ macro->body() };
	out = expand(sub_lexer, sub_defines);
	macro->set_expanding(false);
	return out;
}

string Preproc::collect_param(Lexer& lexer) {
	const char* p0 = lexer.text_ptr();
	int open_parens = 0;
	while (true) {
		const char* p1 = lexer.text_ptr();
		switch (lexer.peek().ttype) {
		case TType::Newline:
			return string(p0, p1);
		case TType::Lparen:
			open_parens++;
			lexer.next();
			break;
		case TType::Rparen:
			open_parens--;
			if (open_parens < 0)
				return string(p0, p1);
			else
				lexer.next();
			break;
		case TType::Comma:
			if (open_parens == 0)
				return string(p0, p1);
			else
				lexer.next();
			break;
		default:
			lexer.next();
		}
	}
}

vector<string> Preproc::collect_macro_params(Lexer& lexer) {
	vector<string> params;

	bool in_parens = (lexer.peek().ttype == TType::Lparen);
	if (in_parens)
		lexer.next();

	// collect up to close parens or end of line
	while (true) {
		params.push_back(collect_param(lexer));
		switch (lexer.peek().ttype) {
		case TType::Comma:
			lexer.next();
			continue;
		case TType::Rparen:
			if (in_parens)
				lexer.next();
			return params;
		case TType::Newline:
			return params;
		default:
			g_errors.error(ErrCode::Syntax);
			return params;
		}
	}
}

vector<string> Preproc::collect_name_list(Lexer& lexer) {
	vector<string> names;
	while (true) {
		if (!lexer.peek().is(TType::Ident)) {
			g_errors.error(ErrCode::Syntax);
			break;
		}
		string name = lexer.peek().svalue;
		names.push_back(name);
		lexer.next();

		if (lexer.peek().is(TType::Comma)) 
			lexer.next();
		else if (lexer.peek().is(TType::Newline))
			break;
		else {
			g_errors.error(ErrCode::Syntax);
			break;
		}
	}
	return names;
}

string Preproc::collect_macro_body(Keyword start_keyword, Keyword end_keyword) {
	Location start_location = m_files.back().location;

	// collect body
	string body, line;
	while (get_unpreproc_line(line)) {
		m_lexer.set(line);

		if ((m_lexer[0].is(TType::Label, TType::Ident) && m_lexer[1].is(start_keyword)) ||
			(m_lexer[0].is(start_keyword))) {
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				start_location.filename + ":" +
				std::to_string(start_location.line_num));
			return "";
		}
		else if (m_lexer[0].is(end_keyword)) {
			m_lexer.next();
			if (!m_lexer[0].is(TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else {
				return body;
			}
		}
		else
			body += line;
	}
	g_errors.error(ErrCode::UnbalancedStruct,
		start_location.filename + ":" +
		std::to_string(start_location.line_num));
	return "";
}

string Preproc::collect_reptc_arg(Lexer& lexer) {
	string out;

	string prev_expanded;
	while (true) {
		Token token = lexer.peek();
		switch (token.ttype) {
		case TType::String:
			lexer.next();
			if (!lexer.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else
				return str_compress_escapes(token.svalue);
		case TType::Integer:
			lexer.next();
			if (!lexer.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else
				return std::to_string(token.ivalue);
		case TType::Ident: {
			ExpandedText expanded = expand(lexer, defines());
			string expanded_text = str_chomp(expanded.text());
			if (!lexer.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else if (expanded_text == prev_expanded) {		// detect loop
				return expanded_text;
			}
			else {
				prev_expanded = expanded_text;
				Lexer sublexer{ expanded_text };
				lexer = sublexer;
				continue;
			}
		}
		default:
			g_errors.error(ErrCode::Syntax);
			return "";
		}
	}
}

//-----------------------------------------------------------------------------

void sfile_hold_input() {
	g_hold_getline = true;
}

void sfile_unhold_input() {
	g_hold_getline = false;
}

bool sfile_open(const char* filename, bool search_include_path) {
	return g_preproc.open(filename, search_include_path);
}

// NOTE: user must free returned pointer
char* sfile_getline() {
	string line;
	if (g_hold_getline)
		return nullptr;
	g_do_preproc_line = false;		// no preprocessing on input line
	if (g_preproc.getline(line))
		return must_strdup(line.c_str());	// needs to be freed by the user
	else
		return nullptr;
}

// NOTE: user must free returned pointer
char* sfile_get_source_line() {
	string line;
	if (g_hold_getline)
		return nullptr;
	g_do_preproc_line = true;		// preprocessing on input line
	if (g_preproc.getline(line)) {
		list_got_expanded_line(line.c_str());
		set_error_expanded_line(line.c_str());
		return must_strdup(line.c_str());	// needs to be freed by the user
	}
	else
		return nullptr;
}

const char* sfile_filename() {
	if (g_preproc.filename().empty())
		return nullptr;
	else
		return spool_add(g_preproc.filename().c_str());
}

int sfile_line_num() {
	return g_preproc.line_num();
}

bool sfile_is_c_source() {
	return g_preproc.is_c_source();
}

void sfile_set_filename(const char* filename) {
	g_preproc.set_filename(filename);
}

void sfile_set_line_num(int line_num, int line_inc) {
	g_preproc.set_line_num(line_num, line_inc);
}

void sfile_set_c_source(bool f) {
	g_preproc.set_c_source(f);
}
