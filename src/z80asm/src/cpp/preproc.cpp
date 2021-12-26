//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// // Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "lex.h"
#include "preproc.h"
#include "utils.h"
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

//-----------------------------------------------------------------------------

Location::Location(const string& filename, int line_num)
	: filename(filename), line_num(line_num) {}

//-----------------------------------------------------------------------------

PreprocLevel::PreprocLevel(Macros* parent)
	: defines(parent) {
	init();
}

void PreprocLevel::init(const string& text) {
	if (g_do_preproc_line && !starts_with_hash(text))
		split_lines(m_lines, text);
	else 
		m_lines.push_back(text);
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
	got_source_line(location.filename.c_str(), location.line_num, line.c_str());

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
		error_include_recursion(filename.c_str());
		return false;
	}

	// open file
	ifstream ifs(found_filename, ios::binary);
	if (!ifs.is_open()) {
		error_read_file(found_filename.c_str());
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

	m_levels.emplace_back();
}

bool Preproc::getline(string& line) {
	line.clear();
	while (true) {
		if (!m_output.empty()) {
			line = m_output.front();
			m_output.pop_front();
			return true;
		}
		else if (m_levels.size() > 1)
			m_levels.pop_back();		// drop one level and continue
		else if (m_files.empty()) {
			got_eof();
			return false;
		}
		else if (m_files.back().getline(line)) {
			if (g_do_preproc_line)
				parse_line(line);
			else
				m_output.push_back(line);
		}
		else
			m_files.pop_back();
	}
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
		error_unbalanced_struct_at(
			m_if_stack.back().location.filename.c_str(),
			m_if_stack.back().location.line_num);
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
	if (check_opcode(Keyword::INCLUDE, &Preproc::do_include)) return;
	if (check_hash_directive(Keyword::INCLUDE, &Preproc::do_include)) return;
	if (check_opcode(Keyword::BINARY, &Preproc::do_binary)) return;
	if (check_opcode(Keyword::INCBIN, &Preproc::do_binary)) return;
	if (check_hash_directive(Keyword::DEFINE, &Preproc::do_define)) return;
	if (check_hash_directive(Keyword::UNDEF, &Preproc::do_undef)) return;
	if (check_defl()) return;
	if (check_hash()) return;

	// last check - macro call

	// expand macros in text
	m_lexer.rewind();
	ExpandedText expanded = expand(m_lexer, defines());
	if (expanded.got_error())
		m_output.push_back(line);
	else
		m_output.push_back(expanded.text());
}

void Preproc::do_label() {
	string line = m_lexer.peek().svalue + ":\n";
	m_output.push_back(line);
	m_lexer.next();
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

void Preproc::do_if() {
	bool flag, error;
	parse_expr_eval_if_condition(m_lexer.text_ptr(), &flag, &error);
	if (!error) {
		m_if_stack.emplace_back(Keyword::IF, m_files.back().location, flag);
		m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
	}
}

void Preproc::do_else() {
	if (!m_lexer.peek().is(TType::Newline))
		error_syntax();
	else if (m_if_stack.empty())
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().location.filename.c_str(),
				m_if_stack.back().location.line_num);
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
		error_syntax();
	else if (m_if_stack.empty())
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF && last != Keyword::ELSE)
			error_unbalanced_struct_at(
				m_if_stack.back().location.filename.c_str(),
				m_if_stack.back().location.line_num);
		else
			m_if_stack.pop_back();
	}
}

void Preproc::do_ifdef_ifndef(bool invert) {
	if (!m_lexer.peek().is(TType::Ident))
		error_syntax();
	else {
		string name = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			error_syntax();
		else {
			bool f = check_ifdef_condition(name.c_str());
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
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().location.filename.c_str(),
				m_if_stack.back().location.line_num);
		else {
			bool flag, error;
			parse_expr_eval_if_condition(m_lexer.text_ptr(), &flag, &error);
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
		error_unbalanced_struct();
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			error_unbalanced_struct_at(
				m_if_stack.back().location.filename.c_str(),
				m_if_stack.back().location.line_num);
		else {
			if (!m_lexer.peek().is(TType::Ident))
				error_syntax();
			else {
				string name = m_lexer.peek().svalue;
				m_lexer.next();
				if (!m_lexer.peek().is(TType::Newline))
					error_syntax();
				else {
					bool f = check_ifdef_condition(name.c_str());
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
		error_syntax();
	else {
		string filename = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			error_syntax();
		else {
			open(filename, true);
		}
	}
}

void Preproc::do_binary() {
	if (!m_lexer.peek().is(TType::String))
		error_syntax();
	else {
		string filename = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			error_syntax();
		else {
			// search file in path
			string found_filename = search_includes(filename.c_str());

			// open file
			ifstream ifs(found_filename, ios::binary);
			if (!ifs.is_open()) 
				error_read_file(found_filename.c_str());
			else {
				// output DEFB lines
				const int line_len = 32;
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
		error_syntax();
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
					error_syntax();
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
					error_syntax();
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
		error_syntax();
	else {
		// get name
		string name = m_lexer.peek().svalue;
		m_lexer.next();
		if (!m_lexer.peek().is(TType::Newline))
			error_syntax();
		else
			defines_base().remove(name);
	}
}

void Preproc::do_defl(const string& name) {
	if (m_lexer.peek().is(TType::Newline))
		error_syntax();
	else {
		// if name is not defined, create an empty one
		if (!defines_base().find(name)) {
			auto macro = make_shared<Macro>(name);
			defines_base().add(macro);
		}

		// expand macros in expression, may refer to name
		string text = str_chomp(m_lexer.text_ptr());
		ExpandedText expanded = expand(m_lexer, defines());
		if (!expanded.got_error())
			text = str_chomp(expanded.text());

		// redefine name
		defines_base().remove(name);
		auto macro = make_shared<Macro>(name);
		macro->push_body(text);
		defines_base().add(macro);
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
		case TType::Eq: out.append("=="); break;
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
			error_wrong_number_macro_args(macro->name().c_str());
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
		case TType::End:
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
		case TType::End:
			return params;
		default:
			error_syntax();
			return params;
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

const char* sfile_getline() {
	static string line;				// to return line.c_str() - NOT REENTRANT
	if (g_hold_getline)
		return nullptr;
	g_do_preproc_line = false;		// no preprocessing on input line
	if (g_preproc.getline(line))
		return line.c_str();
	else
		return nullptr;
}

const char* sfile_get_source_line() {
	static string line;				// to return line.c_str() - NOT REENTRANT
	if (g_hold_getline)
		return nullptr;
	g_do_preproc_line = true;		// preprocessing on input line
	if (g_preproc.getline(line))
		return line.c_str();
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






#if 0


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



#endif

