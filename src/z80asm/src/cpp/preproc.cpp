//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// // Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "preproc.h"
#include "utils.h"

SourceFileStack g_source_file_stack;
static LineSplitFilter splitter1{ &g_source_file_stack };
PreprocFilter g_preproc_filter{ &splitter1 };
LineSplitFilter g_preproc{ &g_preproc_filter };

//-----------------------------------------------------------------------------

LineFilter::LineFilter(LineSource* source)
	: m_source(source) {}

bool LineFilter::getline(string& line) {
	while (true) {
		if (m_source->hold())
			return false;
		else if (!m_lines.empty()) {
			line = m_lines.front();
			m_lines.pop_front();
			return true;
		}
		else if (get_source_line(line))
			parse_line(line);
		else {
			got_eof();
			return false;
		}
	}
}

bool LineFilter::hold() const {
	return m_source->hold();
}

bool LineFilter::get_source_line(string& line) {
	return m_source->getline(line);
}

//-----------------------------------------------------------------------------

bool SourceFile::open(const string& filename) {
	m_filename = filename;
	m_line_num = 0;
	m_line_inc = 1;
	m_is_c_source = false;
	m_hold = false;

	m_ifs.open(filename, ios::binary);
	if (!m_ifs.is_open()) {
		error_read_file(filename.c_str());
		return false;
	}
	else
		return true;
}

bool SourceFile::getline(string& line) {
	line.clear();
	if (!m_ifs.is_open() || m_ifs.eof())
		return false;

	safe_getline(m_ifs, line);
	line.push_back('\n');
	m_line_num += m_line_inc;
	got_source_line(m_filename.c_str(), m_line_num, line.c_str());
	return true;
}

//-----------------------------------------------------------------------------

bool SourceFileStack::open(const string& filename, bool search_include_path) {
	// search file in path
	string found_filename;
	if (search_include_path)
		found_filename = search_includes(filename.c_str());
	else
		found_filename = filename;

	// check for recursive includes
	if (recursive_include(found_filename)) {
		error_include_recursion(filename.c_str());
		return false;
	}

	// open file
	m_files.emplace_back();
	return m_files.back().open(found_filename);
}

bool SourceFileStack::recursive_include(const string& filename) {
	for (auto& elem : m_files) {
		if (elem.filename() == filename)
			return true;
	}
	return false;
}

void SourceFileStack::hold_input() {
	m_files.emplace_back();
	m_files.back().set_hold(true);		// true - getline does not pop()
}

void SourceFileStack::unhold_input() {
	if (!m_files.empty() && m_files.back().hold())
		m_files.pop_back();
}

bool SourceFileStack::getline(string& line) {
	line.clear();
	while (true) {
		if (m_files.empty()) {		// end of input
			return false;
		}
		else if (m_files.back().hold())
			return false;
		else if (m_files.back().getline(line))
			return true;
		else
			m_files.pop_back();
	}
}

string SourceFileStack::filename() const {
	for (auto it = m_files.rbegin(); it != m_files.rend(); it++) {
		string filename = it->filename();
		if (!filename.empty())
			return filename;
	}
	return "";
}

int SourceFileStack::line_num() const {
	for (auto it = m_files.rbegin(); it != m_files.rend(); it++) {
		if (!it->filename().empty())
			return it->line_num();
	}
	return 0;
}

bool SourceFileStack::is_c_source() const {
	for (auto it = m_files.rbegin(); it != m_files.rend(); it++) {
		if (!it->filename().empty())
			return it->is_c_source();
	}
	return false;
}

bool SourceFileStack::hold() const {
	if (m_files.empty())
		return false;
	else
		return m_files.back().hold();
}

void SourceFileStack::set_filename(const string& filename) {
	if (!m_files.empty())
		m_files.back().set_filename(filename);
}

void SourceFileStack::set_line_num(int line_num, int line_inc) {
	if (!m_files.empty()) {
		m_files.back().set_line_num(line_num - line_inc, line_inc);
	}
}

void SourceFileStack::set_c_source(bool f) {
	if (!m_files.empty())
		m_files.back().set_c_source(f);
}

//-----------------------------------------------------------------------------

LineSplitFilter::LineSplitFilter(LineSource* source)
	: LineFilter(source) {}

// read line and continuation lines
bool LineSplitFilter::get_source_line(string& line) {
	line.clear();
	string this_line;
	bool first_line = true;
	while (true) {
		if (!m_source->getline(this_line)) {
			if (first_line)
				return false;
		}
		line += this_line;
		first_line = false;

		if (!remove_final_backslash(line)) 
			break;
	}
	return true;
}

// split lines on '\\'
void LineSplitFilter::parse_line(const string& line) {
	if (starts_with_hash(line))
		m_lines.push_back(line);		// don't split # lines
	else
		split_lines(m_lines, line);
}


//-----------------------------------------------------------------------------

vector<string> ParamScanner::collect_params() {
	bool in_parens = false;
	if (*p == '(') {				// '(' after name without spaces
		in_parens = true;
		p++;
	}

	vector<string> params;
	string param;
	while (collect_param(param)) {
		params.push_back(param);
		if (next_char() == ',') {
			p++;
			continue;
		}
		else
			break;
	}

	if (in_parens) {
		if (next_char() == ')')
			p++;
	}

	return params;
}

bool ParamScanner::collect_param(string& param) {
	param.clear();
	if (next_char() == ')' || *p == '\r' || *p == '\n' || *p == '\0')
		return false;

	const char* p0 = p;
	int parens = 0;
	while (next_char() != '\r' && *p != '\n' && *p != '\0') {
		switch (*p++) {
		case '(':
			parens++;
			break;
		case ')':
			if (parens == 0) {
				p--;
				param = string(p0, p);
				return true;
			}
			else
				parens--;
			break;
		case ',':
			if (parens == 0) {
				p--;
				param = string(p0, p);
				return true;
			}
			break;
		case '"':
			while (*p != '"' && *p != '\r' && *p != '\n' && *p != '\0') {
				if (*p == '\\')
					p += 2;
				else
					p++;
			}
			if (*p == '"')
				p++;
			break;
		case '\'':
			while (*p != '\'' && *p != '\r' && *p != '\n' && *p != '\0') {
				if (*p == '\\')
					p += 2;
				else
					p++;
			}
			if (*p == '\'')
				p++;
			break;
		default:
			break;
		}
	}
	param = string(p0, p);
	return true;
}

char ParamScanner::next_char() {
	p = skip_spaces(p);
	return *p;
}

bool ParamScanner::expect_eol() {
	if (next_char() != ';' && *p != '\r' && *p != '\n') {
		error_syntax();
		return false;
	}
	else
		return true;
}

//-----------------------------------------------------------------------------

MacroExpander::MacroExpander(const string& text, Macros* defines)
	: ParamScanner(text), m_defines(defines) {}

string MacroExpander::expand() {
	m_output.clear();
	m_recursive_error = false;
	do_expand();
	if (m_recursive_error)
		return m_text;
	else
		return m_output;
}

void MacroExpander::check_macro_call(const string& name) {
	shared_ptr<Macro> macro;

	// try full name
	if ((macro = m_defines->find_all(name)) != nullptr)
		expand_macro(macro);
	// try name without prefix
	else if (!isident(name[0]) && (macro = m_defines->find_all(name.substr(1))) != nullptr) {
		m_output += name.front();
		expand_macro(macro);
	}
	else
		m_output += name;
}

void MacroExpander::expand_macro(shared_ptr<Macro> macro) {
	if (macro->is_expanding()) {
		m_recursive_error = true;
	}
	else {
		// create a scope for the recursive evaluation
		Macros sub_defines{ m_defines };

		// collect parameters
		if (macro->args().size()) {
			vector<string> params = collect_params();
			for (size_t i = 0; i < macro->args().size(); i++) {
				shared_ptr<Macro> param = make_shared<Macro>(
					macro->args()[i],
					i < params.size() ? params[i] : "");
				sub_defines.add(param);
			}
		}

		macro->set_expanding(true);
		MacroExpander expander{ macro->body(), &sub_defines };
		m_output += expander.expand();
		macro->set_expanding(false);
	}
}

//-----------------------------------------------------------------------------

PreprocLevel::PreprocLevel(Macros* parent)
	: defines(parent) {
	init();
}

void PreprocLevel::init(const string& line) {
	split_lines(m_lines, line);
}

bool PreprocLevel::getline(string& line) {
	line.clear();
	if (!m_lines.empty()) {			// have lines in queue
		line = m_lines.front();
		m_lines.pop_front();
		return true;
	}
	else
		return false;
}

//-----------------------------------------------------------------------------

IfNest::IfNest(Keyword keyword, bool flag, const string& filename, int line_num)
	: keyword(keyword), flag(flag), done_if(false)
	, filename(filename), line_num(line_num) {}

//-----------------------------------------------------------------------------

PreprocFilter::PreprocFilter(LineSource* source)
	: LineFilter(source) {
	m_levels.emplace_back();
}

void PreprocFilter::got_eof() {
	m_levels.clear();
	m_levels.emplace_back();
	m_macros.clear();
	if (!m_if_stack.empty()) {
		error_unbalanced_struct_at(
			m_if_stack.back().filename.c_str(),
			m_if_stack.back().line_num);
		m_if_stack.clear();
	}
}

bool PreprocFilter::getline(string& line) {
	while (true) {
		if (m_source->hold())
			return false;
		else if (!m_lines.empty()) {
			line = m_lines.front();
			m_lines.pop_front();
			return true;
		}
		else if (m_levels.back().getline(line))
			return true;
		else if (m_levels.size() > 1)
			m_levels.pop_back();		// drop one level and continue
		else if (get_source_line(line))
			parse_line(line);
		else {
			got_eof();
			return false;
		}
	}
}

void PreprocFilter::parse_line(const string& line) {
	// do these irrespective of ifs_active()
	if (check_ifs(line))
		return;

	if (!ifs_active())
		return;

	// do these only if ifs_active()
	if (check_defines(line))
		return;

	// last check
	if (check_macro_call(line))
		return;

	// expand macros in text
	MacroExpander expander{ line, &m_levels.back().defines };
	string expanded = expander.expand();
	m_lines.push_back(expanded);
}

void PreprocFilter::parse_define(const string& name) {
	// create macro, check for duplicate names
	shared_ptr<Macro> macro = make_shared<Macro>(name);
	m_levels.front().defines.add(macro);

	// check for parameters
	if (*p == '(') {
		p++;
		parse_params(macro);
		p = skip_spaces(p);
		if (*p == ')')
			p++;
		else
			error_syntax();
	}

	// get macro body
	p = skip_spaces(p);
	const char* p0 = p;
	while (*p != '\0' && *p != '\r' && *p != '\n')
		p++;
	macro->push_body(string(p0, p));
}

void PreprocFilter::do_label(const string& name) {
	m_lines.push_back(name + ":\n");
}

void PreprocFilter::do_if() {
	bool flag, error;
	parse_expr_eval_if_condition(p, &flag, &error);
	if (!error) {
		m_if_stack.emplace_back(Keyword::IF, flag,
			g_source_file_stack.filename(), g_source_file_stack.line_num());
		m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
	}
}

void PreprocFilter::do_ifdef() {
	string name = collect_name();
	if (!name.empty()) {
		if (expect_eol()) {
			bool defined = check_ifdef_condition(name.c_str());
			m_if_stack.emplace_back(Keyword::IF, defined,
				g_source_file_stack.filename(), g_source_file_stack.line_num());
			m_if_stack.back().done_if = m_if_stack.back().done_if || defined;
		}
	}
}

void PreprocFilter::do_ifndef() {
	string name = collect_name();
	if (!name.empty()) {
		if (expect_eol()) {
			bool not_defined = !check_ifdef_condition(name.c_str());
			m_if_stack.emplace_back(Keyword::IF, not_defined,
				g_source_file_stack.filename(), g_source_file_stack.line_num());
			m_if_stack.back().done_if = m_if_stack.back().done_if || not_defined;
		}
	}
}

void PreprocFilter::do_elif() {
	if (m_if_stack.empty())
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().filename.c_str(),
				m_if_stack.back().line_num);
		else {
			bool flag, error;
			parse_expr_eval_if_condition(p, &flag, &error);
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

void PreprocFilter::do_elifdef() {
	if (m_if_stack.empty())
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().filename.c_str(),
				m_if_stack.back().line_num);
		else {
			string name = collect_name();
			if (!name.empty()) {
				if (expect_eol()) {
					bool defined = check_ifdef_condition(name.c_str());
					if (m_if_stack.back().done_if)
						defined = false;
					m_if_stack.back().keyword = Keyword::ELIF;
					m_if_stack.back().flag = defined;
					m_if_stack.back().done_if = m_if_stack.back().done_if || defined;
				}
			}
		}
	}
}

void PreprocFilter::do_elifndef() {
	if (m_if_stack.empty())
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().filename.c_str(),
				m_if_stack.back().line_num);
		else {
			string name = collect_name();
			if (!name.empty()) {
				if (expect_eol()) {
					bool not_defined = !check_ifdef_condition(name.c_str());
					if (m_if_stack.back().done_if)
						not_defined = false;
					m_if_stack.back().keyword = Keyword::ELIF;
					m_if_stack.back().flag = not_defined;
					m_if_stack.back().done_if = m_if_stack.back().done_if || not_defined;
				}
			}
		}
	}
}

void PreprocFilter::do_else() {
	if (expect_eol()) {
		if (m_if_stack.empty())
			error_unbalanced_struct();
		else {
			Keyword last = m_if_stack.back().keyword;
			if (last != Keyword::IF && last != Keyword::ELIF)
				error_unbalanced_struct_at(
					m_if_stack.back().filename.c_str(),
					m_if_stack.back().line_num);
			else {
				bool flag = !m_if_stack.back().done_if;
				m_if_stack.back().keyword = Keyword::ELSE;
				m_if_stack.back().flag = flag;
				m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
			}
		}
	}
}

void PreprocFilter::do_endif() {
	if (expect_eol()) {
		if (m_if_stack.empty())
			error_unbalanced_struct();
		else {
			Keyword last = m_if_stack.back().keyword;
			if (last != Keyword::IF && last != Keyword::ELIF && last != Keyword::ELSE)
				error_unbalanced_struct_at(
					m_if_stack.back().filename.c_str(),
					m_if_stack.back().line_num);
			else 
				m_if_stack.pop_back();
		}
	}
}

void PreprocFilter::do_macro_call(shared_ptr<Macro> macro) {
	// collect arguments
	vector<string> params;
	if (macro->args().size() != 0) {
		params = collect_params();
		if (macro->args().size() != params.size())
			error_wrong_number_macro_args(macro->name().c_str());
	}
	expect_eol();

	// create new level of macro expansion
	m_levels.emplace_back(&m_levels.back().defines);

	// create macros for each argument
	for (size_t i = 0; i < macro->args().size(); i++) {
		string arg = macro->args()[i];
		string param = i < params.size() ? params[i] : "";
		shared_ptr<Macro> param_macro = make_shared<Macro>(arg, param);
		m_levels.back().defines.add(param_macro);
	}

	// create lines from body
	m_levels.back().init(macro->body());
}

bool PreprocFilter::ifs_active() const {
	if (m_levels.back().exitm_called)
		return false;
	for (auto& f : m_if_stack) {
		if (!f.flag)
			return false;
	}
	return true;
}

//-----------------------------------------------------------------------------

void sfile_hold_input() {
	g_source_file_stack.hold_input();
}

void sfile_unhold_input() {
	g_source_file_stack.unhold_input();
}

bool sfile_open(const char* filename, bool search_include_path) {
	return g_source_file_stack.open(filename, search_include_path);
}

const char* sfile_getline() {
	static string line;				// so that we can return line.c_str() - NOT REENTRANT
	if (g_source_file_stack.getline(line))
		return line.c_str();
	else
		return nullptr;
}

const char* sfile_get_source_line() {
	static string line;				// so that we can return line.c_str() - NOT REENTRANT
	if (g_preproc.getline(line))
		return line.c_str();
	else
		return nullptr;
}

const char* sfile_filename() {
	string filename = g_source_file_stack.filename();
	return filename.empty() ? nullptr : spool_add(filename.c_str());
}

int sfile_line_num() {
	return g_source_file_stack.line_num();
}

bool sfile_is_c_source() {
	return g_source_file_stack.is_c_source();
}

void sfile_set_filename(const char* filename) {
	g_source_file_stack.set_filename(filename);
}

void sfile_set_line_num(int line_num, int line_inc) {
	g_source_file_stack.set_line_num(line_num, line_inc);
}

void sfile_set_c_source(bool f) {
	g_source_file_stack.set_c_source(f);
}
