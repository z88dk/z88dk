//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "float.h"
#include "if.h"
#include "preproc.h"
#include "scan.h"
#include "strpool.h"
#include "utils.h"
#include "xassert.h"
#include <cassert>
using namespace std;

//-----------------------------------------------------------------------------
// global state
static bool g_hold_getline = false;

Preproc g_preproc;

//-----------------------------------------------------------------------------

static int next_id() {
	static int id = 0;
	return ++id;
}

static string unique_name(const string& name) {
	return name + "__" + std::to_string(next_id());
}

//-----------------------------------------------------------------------------

PreprocLevel::PreprocLevel(Macros* parent)
	: defines(parent) {
}

void PreprocLevel::split_lines(ScannedLine& line) {
    ScannedLine this_line;

    for (unsigned line_start = 0; line_start < line.tokens().size(); ) {
        bool is_hash_line = false;      // line started with '#'
        int conditional = 0;            // count pairs of '?' ':'
        int parens = 0;                 // count open parens
        bool got_eol = false;

        unsigned i;
        for (i = line_start; !got_eol && i < line.tokens().size(); i++) {
            Token token = line.tokens()[i];
            switch (token.type()) {
            case TType::Hash:
                if (this_line.tokens().empty())
                    is_hash_line = true;
                this_line.append({ token });
                break;

            case TType::LParen:
                if (!is_hash_line)
                    parens++;
                this_line.append({ token });
                break;

            case TType::RParen:
                if (!is_hash_line)
                    parens--;
                this_line.append({ token });
                break;

            case TType::Quest:
                if (!is_hash_line)
                    conditional++;
                this_line.append({ token });
                break;

            case TType::Colon:
                if (conditional > 0) {     // conditional
                    conditional--;
                    this_line.append({ token });
                }
                else if (i == line_start + 1 && line.tokens()[line_start].type() == TType::Ident)    // label:
                    this_line.append({ token });
                else if (is_hash_line)
                    this_line.append({ token });
                else if (parens > 0) {          // in parens
                    this_line.append({ token });
                }
                else                             // line break
                    got_eol = true;
                break;

            case TType::Backslash:
                if (is_hash_line) 
                    this_line.append({ token });
                else                            // line break
                    got_eol = true;
                break;

            case TType::Newline:
                got_eol = true;                 // line break
                break;

            default:
                this_line.append({ token });
            }
        }

        this_line.append({ Token{TType::Newline, false} });
        m_lines.push_back(this_line);
        this_line.clear();
        line_start = i;
    }

    // push tokens after last separator
    if (!this_line.tokens().empty()) {
        this_line.append({ Token{TType::Newline, false} });
        m_lines.push_back(this_line);
    }
}

bool PreprocLevel::getline(ScannedLine& line) {
	line.clear();
    if (m_lines.empty()) {
		return false;
    }
    else {
        line = m_lines.front();
        m_lines.pop_front();

        return true;
    }
}

//-----------------------------------------------------------------------------

ExpandedLine::ExpandedLine(const string& text, const vector<Token>& tokens)
    : ScannedLine(text, tokens) {
}

//-----------------------------------------------------------------------------

IfNest::IfNest(Keyword keyword, Location location, bool flag)
	: keyword(keyword), location(location), flag(flag), done_if(false) {}

//-----------------------------------------------------------------------------

Preproc::Preproc() {
	m_levels.emplace_back();
}

bool Preproc::open(const string& filename_, bool search_include_path) {
	// canonize path
	string filename = fs::path(filename_).generic_string();

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
    m_files.emplace_back();
    return m_files.back().open(found_filename);
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

bool Preproc::getline1(ScannedLine& line) {
	line.clear();
    while (true) {
        if (!m_output.empty()) {		// output queue
            line = m_output.front();
            m_output.pop_front();
            if (!line.empty())
                return true;
        }
        else if (m_levels.back().getline(line)) {	// read from macro expansion
            if (m_reading_macro_body)
                m_output.push_back(line);
            else
                parse_line(line);
        }
        else if (m_levels.size() > 1)	// end of macro expansion
            m_levels.pop_back();		// drop one level and continue
        else if (m_files.empty()) {		// end of input
            got_eof();
            return false;
        }
        else if (m_files.back().get_token_line(line)) {	// read from file
            if (m_reading_macro_body)
                m_output.push_back(line);
            else
                m_levels.back().split_lines(line);
        }
        else
            m_files.pop_back();
	}
}

bool Preproc::getline(ScannedLine& line) {
    if (getline1(line)) {
        if (!m_reading_macro_body) {
            // publish expanded line
            string source_line = location().source_line();
            string source_line_no_blanks = str_remove_all_blanks(source_line);
            string expanded_line = line.to_string();
            string expanded_line_no_blanks = str_remove_all_blanks(expanded_line);
            if (!expanded_line_no_blanks.empty() &&
                source_line_no_blanks != expanded_line_no_blanks) {
                list_got_expanded_line(expanded_line.c_str());
                set_error_expanded_line(expanded_line.c_str());
            }
        }
        return true;
	}
    else 
        return false;
}

bool Preproc::get_unpreproc_line(ScannedLine& line) {
    line.clear();
    while (true) {
        if (m_files.empty())
            return false;
        else if (m_files.back().get_text_line(line))
            return true;
        else
            m_files.pop_back();
    }
}

const Location& Preproc::location() const {
	static Location empty_location;
	if (!m_files.empty())
		return m_files.back().location();
	else
		return empty_location;
}

bool Preproc::is_c_source() const {
	if (m_files.empty())
		return false;
	else
		return m_files.back().location().is_c_source();
}

void Preproc::set_location(Location location) {
    if (!m_files.empty())
        m_files.back().location() = location;
}

void Preproc::set_filename(const string& filename) {
	if (!m_files.empty())
		m_files.back().location().set_filename(filename);
}

void Preproc::set_line_num(int line_num, int line_inc) {
	if (!m_files.empty()) {
		m_files.back().location().set_line_num(line_num - line_inc, line_inc);
	}
}

void Preproc::set_c_source(bool f) {
    if (!m_files.empty())
        m_files.back().location().set_c_source(f);
}

bool Preproc::recursive_include(const string& filename) {
	for (auto& elem : m_files) {
		if (elem.filename() == filename)
			return true;
	}
	return false;
}

void Preproc::got_eof() {
	if (!m_if_stack.empty()) {
		g_errors.error(ErrCode::UnbalancedStructStartedAt,
			m_if_stack.back().location.filename() + ":" +
			std::to_string(m_if_stack.back().location.line_num()));
		m_if_stack.clear();
	}
	close();
}

void Preproc::parse_line(const ScannedLine& line) {
    m_line = line;
    m_line.rewind();

	// do these irrespective of ifs_active()
	if (check_opt_hash_opcode(Keyword::IF, &Preproc::do_if)) return;
	if (check_opt_hash_opcode(Keyword::ELSE, &Preproc::do_else)) return;
	if (check_opt_hash_opcode(Keyword::ENDIF, &Preproc::do_endif)) return;
	if (check_opt_hash_opcode(Keyword::IFDEF, &Preproc::do_ifdef)) return;
	if (check_opt_hash_opcode(Keyword::IFNDEF, &Preproc::do_ifndef)) return;
	if (check_opt_hash_opcode(Keyword::ELIF, &Preproc::do_elif)) return;
	if (check_opt_hash_opcode(Keyword::ELIFDEF, &Preproc::do_elifdef)) return;
	if (check_opt_hash_opcode(Keyword::ELIFNDEF, &Preproc::do_elifndef)) return;

	if (!ifs_active()) return;

	// do these only if ifs_active()
	if (check_hash_directive(Keyword::DEFINE, &Preproc::do_define)) return;
	if (check_opt_hash_opcode(Keyword::INCLUDE, &Preproc::do_include)) return;
	if (check_hash_directive(Keyword::UNDEF, &Preproc::do_undef)) return;
	if (check_opcode(Keyword::BINARY, &Preproc::do_binary)) return;
	if (check_opcode(Keyword::EXITM, &Preproc::do_exitm)) return;
	if (check_opcode(Keyword::FLOAT, &Preproc::do_float)) return;
	if (check_opcode(Keyword::INCBIN, &Preproc::do_binary)) return;
	if (check_opcode(Keyword::LOCAL, &Preproc::do_local)) return;
	if (check_opcode(Keyword::SETFLOAT, &Preproc::do_setfloat)) return;
	if (check_opcode(Keyword::LINE, &Preproc::do_line)) return;
	if (check_opcode(Keyword::C_LINE, &Preproc::do_c_line)) return;
	if (check_defl()) return;
	if (check_macro()) return;
	if (check_reptx()) return;
	if (check_hash()) return;
	if (check_gbz80_opcodes()) return;
	if (check_z80_ld_bit_opcodes()) return;

	// last check - macro call
	if (check_macro_call()) return;

	// expand macros in text
    m_line.rewind();
    push_expanded(m_line, defines());
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

bool Preproc::symbol_defined(const Token& ident) {
	// expand macros in condition
    string name = ident.svalue();
    ScannedLine symbol_line{ name, {ident} };
    ExpandedLine expanded_line = expand(symbol_line, defines());
    string expanded_text = str_chomp(expanded_line.to_string());
	string expanded_name = expanded_text.empty() ? name : expanded_text;

	// check macro
	if (m_macros.find_all(expanded_name))
		return true;

	// check preprocessor macro
	if (defines().find_all(expanded_name))
		return true;

	// check assembler symbol
	if (check_ifdef_condition(expanded_name.c_str()))
		return true;
	else
		return false;
}

int Preproc::check_label_index() {
    if (m_line.peek(0).is(TType::Ident) && m_line.peek(1).is(TType::Colon))
        return 0;
    else if (m_line.peek(0).is(TType::Dot) && m_line.peek(1).is(TType::Ident))
        return 1;
    else
        return -1;
}

void Preproc::do_label(int label_index) {
    Token label_token = m_line.peek(label_index);
    m_line.next(2);

    ScannedLine label_line;
    label_line.append({ label_token, Token{TType::Colon, false},
                        Token{TType::Newline, false} });
    push_expanded(label_line, defines());
}

bool Preproc::check_opcode(Keyword keyword, void(Preproc::* do_action)()) {
    int label_index = check_label_index();
    if (label_index >= 0 && m_line.peek(2).is(keyword)) {
        if (ifs_active())
            do_label(label_index);
        else
            m_line.next(2);
        m_line.next();
        ((*this).*(do_action))();
        return true;
    }
	else if (m_line.peek(0).is(keyword) && !m_line.peek(1).is(TType::Colon)) {
		m_line.next();
		((*this).*(do_action))();
		return true;
	}
	else
		return false;
}

bool Preproc::check_hash_directive(Keyword keyword, void(Preproc::* do_action)()) {
	if (m_line.peek(0).is(TType::Hash) && m_line.peek(1).is(keyword)) {
		m_line.next(2);
		((*this).*(do_action))();
		return true;
	}
	else
		return false;
}

bool Preproc::check_opt_hash_opcode(Keyword keyword, void(Preproc::* do_action)()) {
	if (check_hash_directive(keyword, do_action))
		return true;
	else if (check_opcode(keyword, do_action))
		return true;
	else
		return false;
}

bool Preproc::check_hash() {
	if (m_line.peek(0).is(TType::Hash))
		return true;
	else
		return false;
}

bool Preproc::check_defl() {
    int label_index = check_label_index();
    if (label_index >= 0 && m_line.peek(2).is(Keyword::DEFL)) {
        string name = m_line.peek(label_index).svalue();
        m_line.next(3);			// skip name: DEFL
        do_defl(name);
        return true;
    }
    else if (m_line.peek(0).is(TType::Ident) && m_line.peek(1).is(Keyword::DEFL)) {
        string name = m_line.peek(0).svalue();
        m_line.next(2);			// skip name DEFL
        do_defl(name);
        return true;
    }
	else if (m_line.peek(0).is(Keyword::DEFL) &&
		m_line.peek(1).is(TType::Ident) &&
		m_line.peek(2).is(TType::Eq)) { 
		string name = m_line.peek(1).svalue();
		m_line.next(3);			// skip DEFL name=
		do_defl(name);
		return true;
	}
	else
		return false;
}

bool Preproc::check_macro() {
    int label_index = check_label_index();
    if (label_index >= 0 && m_line.peek(2).is(Keyword::MACRO)) {
        string name = m_line.peek(label_index).svalue();
        m_line.next(3);			// skip name: MACRO
        do_macro(name);
        return true;
    }
    else if (m_line.peek(0).is(TType::Ident) && m_line.peek(1).is(Keyword::MACRO)) {
        string name = m_line.peek(0).svalue();
        m_line.next(2);			// skip name MACRO
        do_macro(name);
        return true;
    }
	else if (m_line.peek(0).is(Keyword::MACRO) && m_line.peek(1).is(TType::Ident)) {
		string name = m_line.peek(1).svalue();
		m_line.next(2);			// skip MACRO name
		do_macro(name);
		return true;
	}
    else if (label_index >= 0 && m_line.peek(2).is(Keyword::ENDM, Keyword::ENDR)) {
        g_errors.error(ErrCode::Syntax);
        return true;
    }
    else if (m_line.peek(0).is(TType::Ident) && m_line.peek(1).is(Keyword::ENDM, Keyword::ENDR)) {
        g_errors.error(ErrCode::Syntax);
        return true;
    }
    else if (m_line.peek(0).is(Keyword::ENDM, Keyword::ENDR)) {
        g_errors.error(ErrCode::UnbalancedStruct);
		return true;
	}
    else {
		return false;
    }
}

bool Preproc::check_macro_call() {
    int label_index = check_label_index();
    if (label_index >= 0 && m_line.peek(2).is(TType::Ident)) {
        string name = m_line.peek(2).svalue();

        // find in MACRO macros OR in #define macros
        shared_ptr<Macro> macro = m_macros.find_all(name);
        if (!macro)
            macro = defines().find_all(name);

        if (macro) {
            do_label(label_index);
            m_line.next();
            do_macro_call(macro);
            return true;
        }
    }
    else if (label_index < 0 && m_line.peek(0).is(TType::Ident)) {
		string name = m_line.peek(0).svalue();

        // find in MACRO macros OR in #define macros
        shared_ptr<Macro> macro = m_macros.find_all(name);
        if (!macro)
            macro = defines().find_all(name);

        if (macro) {
			m_line.next();
			do_macro_call(macro);
			return true;
		}
	}

    return false;
}

bool Preproc::check_reptx() {
	if (m_line.peek(0).is(Keyword::REPT) && !m_line.peek(1).is(TType::Colon)) {
		m_line.next();
		do_rept();
		return true;
	}
	else if (m_line.peek(0).is(Keyword::REPTC) && !m_line.peek(1).is(TType::Colon)) {
		m_line.next();
		do_reptc();
		return true;
	}
	else if (m_line.peek(0).is(Keyword::REPTI) && !m_line.peek(1).is(TType::Colon)) {
		m_line.next();
		do_repti();
		return true;
	}
	else if (m_line.peek(0).is(Keyword::ENDR) && !m_line.peek(1).is(TType::Colon)) {
		g_errors.error(ErrCode::UnbalancedStruct);
		return true;
	}
	else
		return false;
}

bool Preproc::check_gbz80_opcodes() {
    ScannedLine out;

    // ld ($ff00+xxx --> ldh (xxx
	// ld ($ff00-xxx --> ldh (-xxx
	// ld ($ff00)xxx --> ldh (0)xxx
	if (m_line.peek(0).is(Keyword::LD) &&
		m_line.peek(1).is(TType::LParen) &&
		m_line.peek(2).is(TType::Integer) && m_line.peek(2).ivalue() == 0xff00) {
		switch (m_line.peek(3).type()) {
		case TType::Plus:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::LParen, false} });
            out.append(m_line.peek_tokens(4));
            push_expanded(out, defines());
			return true;

		case TType::Minus:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::LParen, false} });
            out.append(m_line.peek_tokens(3));
            push_expanded(out, defines());
            return true;

		case TType::RParen:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::LParen, false},
                Token{TType::Integer, false, 0} });
            out.append(m_line.peek_tokens(3));
            push_expanded(out, defines());
            return true;

		default:
			return false;
		}
	}
	// ld ($ff00+xxx --> ldh (xxx
	// ld ($ff00-xxx --> ldh (-xxx
	// ld ($ff00)xxx --> ldh (0)xxx
	if (m_line.peek(0).is(Keyword::LD) &&
		m_line.peek(1).is(Keyword::A) &&
		m_line.peek(2).is(TType::Comma) &&
		m_line.peek(3).is(TType::LParen) &&
		m_line.peek(4).is(TType::Integer) && m_line.peek(4).ivalue() == 0xff00) {
		switch (m_line.peek(5).type()) {
		case TType::Plus:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::Ident, false, "a"},
                         Token{TType::Comma, false}, Token{TType::LParen, false} });
            out.append(m_line.peek_tokens(6));
            push_expanded(out, defines());
            return true;

		case TType::Minus:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::Ident, false, "a"},
                         Token{TType::Comma, false}, Token{TType::LParen, false} });
            out.append(m_line.peek_tokens(5));
            push_expanded(out, defines());
            return true;

		case TType::RParen:
            out.append({ Token{TType::Ident, false, "ldh"}, Token{TType::Ident, false, "a"},
                         Token{TType::Comma, false}, Token{TType::LParen, false},
                         Token{TType::Integer, false, 0} });
            out.append(m_line.peek_tokens(5));
            push_expanded(out, defines());
            return true;

		default:
			return false;
		}
	}
	else
		return false;
}

bool Preproc::check_z80_ld_bit_opcodes() {
    ScannedLine out;

    // ld a, res 0, (ix+127) --> res 0, (ix+126), a
	if (m_line.peek(0).is(Keyword::LD) &&
		keyword_is_reg_8(m_line.peek(1).keyword()) &&
		m_line.peek(2).is(TType::Comma) &&
		keyword_is_z80_ld_bit(m_line.peek(3).keyword()) &&
		m_line.peek(4).is(TType::Integer) &&
		m_line.peek(5).is(TType::Comma) &&
		m_line.peek(6).is(TType::LParen) &&
		keyword_is_reg_ix_iy(m_line.peek(7).keyword())) {

        string reg8 = m_line.peek(1).svalue();
        out.append(m_line.peek_tokens(3));
        xassert(out.tokens().back().is(TType::Newline));
        out.tokens().pop_back();
        out.append({ Token{TType::Comma, false}, Token{TType::Ident, false, reg8},
                     Token{TType::Newline, false} });
        push_expanded(out, defines());
		return true;
	}
	// ld a,rl (ix+127) --> rl (ix+127), a
	else if (m_line.peek(0).is(Keyword::LD) &&
		keyword_is_reg_8(m_line.peek(1).keyword()) &&
		m_line.peek(2).is(TType::Comma) &&
		keyword_is_z80_ld_bit(m_line.peek(3).keyword()) &&
		m_line.peek(4).is(TType::LParen) &&
		keyword_is_reg_ix_iy(m_line.peek(5).keyword())) {

        string reg8 = m_line.peek(1).svalue();
        out.append(m_line.peek_tokens(3));
        xassert(out.tokens().back().is(TType::Newline));
        out.tokens().pop_back();
        out.append({ Token{TType::Comma, false}, Token{TType::Ident, false, reg8},
                     Token{TType::Newline, false} });
        push_expanded(out, defines());
        return true;
	}
    else {
		return false;
    }
}

void Preproc::do_if() {
	// expand macros in condition
    vector<Token> cond_tokens = m_line.peek_tokens();
    ScannedLine cond_line{ Token::to_string(cond_tokens), cond_tokens };
    ExpandedLine expanded_cond = expand(cond_line, defines());
    string cond_text = expanded_cond.to_string();

	// check condition
	bool flag, error;
	parse_expr_eval_if_condition(cond_text.c_str(), &flag, &error);
	if (!error) {
		m_if_stack.emplace_back(Keyword::IF, m_files.back().location(), flag);
		m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
	}
}

void Preproc::do_else() {
	if (!m_line.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename() + ":" +
				std::to_string(m_if_stack.back().location.line_num()));
		else {
			bool flag = !m_if_stack.back().done_if;
			m_if_stack.back().keyword = Keyword::ELSE;
			m_if_stack.back().flag = flag;
			m_if_stack.back().done_if = m_if_stack.back().done_if || flag;
		}
	}
}

void Preproc::do_endif() {
	if (!m_line.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_if_stack.empty())
		g_errors.error(ErrCode::UnbalancedStruct);
	else {
		Keyword last = m_if_stack.back().keyword;
		if (last != Keyword::IF && last != Keyword::ELIF && last != Keyword::ELSE)
			g_errors.error(ErrCode::UnbalancedStructStartedAt,
				m_if_stack.back().location.filename() + ":" +
				std::to_string(m_if_stack.back().location.line_num()));
		else
			m_if_stack.pop_back();
	}
}

void Preproc::do_ifdef_ifndef(bool invert) {
	if (!m_line.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
        Token name = m_line.peek();
		m_line.next();
		if (!m_line.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			bool f = symbol_defined(name);
			if (invert)
				f = !f;
			m_if_stack.emplace_back(Keyword::IF, m_files.back().location(), f);
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
				m_if_stack.back().location.filename() + ":" +
				std::to_string(m_if_stack.back().location.line_num()));
		else {
			// expand macros in condition
            vector<Token> cond_tokens = m_line.peek_tokens();
            ScannedLine cond_line{ Token::to_string(cond_tokens), cond_tokens };
            ExpandedLine expanded_cond = expand(cond_line, defines());
            string cond_text = expanded_cond.to_string();

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
				m_if_stack.back().location.filename() + ":" +
				std::to_string(m_if_stack.back().location.line_num()));
		else {
			if (!m_line.peek().is(TType::Ident))
				g_errors.error(ErrCode::Syntax);
			else {
                Token name = m_line.peek();
				m_line.next();
				if (!m_line.peek().is(TType::Newline))
					g_errors.error(ErrCode::Syntax);
				else {
					bool f = symbol_defined(name);
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
	if (!m_line.peek().is(TType::String))
		g_errors.error(ErrCode::Syntax);
	else {
		string filename = m_line.peek().svalue();
		m_line.next();
		if (!m_line.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			open(filename, true);
		}
	}
}

void Preproc::do_binary() {
	if (!m_line.peek().is(TType::String))
		g_errors.error(ErrCode::Syntax);
	else {
		string filename = m_line.peek().svalue();
		m_line.next();
		if (!m_line.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else {
			// search file in path
			string found_filename = search_includes(filename.c_str());

			// open file
			if (!fs::is_regular_file(fs::path(found_filename))) {
				g_errors.error(ErrCode::FileNotFound, found_filename);
			}
			else {
				ifstream ifs(found_filename, ios::binary);
				if (!ifs.is_open())
					g_errors.error(ErrCode::FileOpen, found_filename);
				else {
					// output DEFB lines
					const int line_len = 16;
					unsigned char bytes[line_len];

					while (!ifs.eof()) {
						ifs.read(reinterpret_cast<char*>(bytes), line_len);
						unsigned num_read = static_cast<unsigned>(ifs.gcount());
						if (num_read > 0) {
                            ScannedLine out;
                            out.append({ Token{TType::Ident, false, "defb"} });
                            for (unsigned i = 0; i < num_read; i++) {
                                if (i != 0)
                                    out.append({ Token{TType::Comma, false} });
                                out.append({ Token{TType::Integer, false, bytes[i]} });
							}
                            out.append({ Token{TType::Newline, false} });
                            push_expanded(out, defines());
                        }
					}
				}
			}
		}
	}
}

void Preproc::do_define() {
    if (!m_line.peek().is(TType::Ident)) {
		g_errors.error(ErrCode::Syntax);
    }
	else {
		// get name
		string name = m_line.peek().svalue();
		m_line.next();

		// check if name is followed by '(' without spaces
        bool has_space = m_line.peek().blank_before();
		bool has_args = (!has_space && m_line.peek().is(TType::LParen));

		// create macro
		auto macro = make_shared<Macro>(name);
		defines_base().add(macro);				// create macro

		// collect args
		if (has_args) {
			m_line.next();						// skip '('
			while (!m_line.at_end()) {
				if (!m_line.peek().is(TType::Ident)) {
					g_errors.error(ErrCode::Syntax);
					return;
				}
				string arg = m_line.peek().svalue();
				macro->push_arg(arg);
				m_line.next();					// skip name

				if (m_line.peek().is(TType::Comma)) {
					m_line.next();				// skip ','
					continue;
				}
				else if (m_line.peek().is(TType::RParen)) {
					m_line.next();				// skip ')'
					break;
				}
				else {
					g_errors.error(ErrCode::Syntax);
					return;
				}
			}
		}

		// collect body
        vector<Token> body_tokens = m_line.peek_tokens();
        if (!body_tokens.empty() && body_tokens.back().is(TType::Newline))
            body_tokens.pop_back();     // remove newline
        ScannedLine body{ Token::to_string(body_tokens), body_tokens };
		macro->push_body(body);
	}
}

void Preproc::do_undef() {
	if (!m_line.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get name
		string name = m_line.peek().svalue();
		m_line.next();
		if (!m_line.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else
			defines_base().remove(name);
	}
}

void Preproc::do_defl(const string& name) {
	if (m_line.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		// if name is not defined, create an empty one
		if (!defines_base().find(name)) {
			auto macro = make_shared<Macro>(name);
			defines_base().add(macro);
		}

		// expand macros in expression, may refer to name
        vector<Token> expr_tokens = m_line.peek_tokens();
        if (!expr_tokens.empty() && expr_tokens.back().is(TType::Newline))
            expr_tokens.pop_back();     // remove newline
        ScannedLine expr_line{ Token::to_string(expr_tokens), expr_tokens };
        ExpandedLine expanded_expr = expand(expr_line, defines());

		// redefine name
		defines_base().remove(name);
		auto macro = make_shared<Macro>(name);
        macro->push_body(expanded_expr);
		defines_base().add(macro);
	}
}

void Preproc::do_macro(const string& name) {
	// create macro
	auto macro = make_shared<Macro>(name);
	m_macros.add(macro);								// create macro

	// collect args
	if (!m_line.peek().is(TType::Newline)) {
		vector<string> args = collect_name_list(m_line);
		for (auto& arg : args)
			macro->push_arg(arg);
	}

	// collect body
	ScannedLine body = collect_macro_body(Keyword::MACRO, Keyword::ENDM);
	macro->push_body(body);
}

void Preproc::do_macro_call(shared_ptr<Macro> macro) {
	// collect arguments
	vector<ScannedLine> params;
	if (macro->args().size() != 0) {
		params = collect_macro_params(m_line);
		if (macro->args().size() != params.size()) {
			g_errors.error(ErrCode::MacroArgsNumber, macro->name());
			return;
		}
	}

	// create new level of macro expansion
	m_levels.emplace_back(&defines());

	// create macros in the new level for each argument
    for (unsigned i = 0; i < macro->args().size(); i++) {
        string arg = macro->args()[i];
        ScannedLine param = i < params.size() ? params[i] : ScannedLine();
		shared_ptr<Macro> param_macro = make_shared<Macro>(arg, param);
		defines().add(param_macro);
	}

	// create lines from body; append rest of the macro call line
    ScannedLine body = macro->body();
    body.append(m_line.peek_tokens());
	m_levels.back().split_lines(body);
}

void Preproc::do_local() {
	// collect symbols
	vector<string> names = collect_name_list(m_line);
	for (auto& name : names) {
		// define new name
		string def_name = unique_name(name);
		auto macro = make_shared<Macro>(name);
        ScannedLine body{ def_name, { Token{TType::Ident, false, def_name} } };
        macro->push_body(body);
		defines().add(macro);			// add to top layer
	}
}

void Preproc::do_exitm() {
	if (!m_line.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (m_levels.size() == 1)
		g_errors.error(ErrCode::UnbalancedStruct);
	else
		m_levels.back().exitm_called = true;
}

void Preproc::do_rept() {
	if (m_line.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		int count = 0;
		bool error = false;

        // expand macros in count
        vector<Token> count_tokens = m_line.peek_tokens();
        ScannedLine count_line{ Token::to_string(count_tokens), count_tokens };
        ExpandedLine expanded_count = expand(count_line, defines());
        string count_text = expanded_count.to_string();
		parse_const_expr_eval(count_text.c_str(), &count, &error);
		if (!error) {
			ScannedLine body = collect_macro_body(Keyword::REPT, Keyword::ENDR);

			// create new level for expansion
			m_levels.emplace_back(&defines());
            ScannedLine block;
            for (int i = 0; i < count; i++)
                block.append(body);

			m_levels.back().split_lines(block);
		}
	}
}

void Preproc::do_reptc() {
	if (!m_line.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get variable to iterate
		string var = m_line.peek().svalue();
		m_line.next();
		if (!m_line.peek().is(TType::Comma))
			g_errors.error(ErrCode::Syntax);
		else {
			m_line.next();
			// build string to iterate
			string str = collect_reptc_arg(m_line);
			ScannedLine body = collect_macro_body(Keyword::REPTC, Keyword::ENDR);

			// create new level for expansion
			m_levels.emplace_back(&defines());
            ScannedLine block;
			for (auto& c : str) {
                block.append({ Token{TType::Hash, false },
                               Token{TType::Ident, false, "undef"},
                               Token{TType::Ident, false, var},
                               Token{TType::Newline, false } });

                block.append({ Token{TType::Hash, false },
                               Token{TType::Ident, false, "define"},
                               Token{TType::Ident, false, var},
                               Token{TType::Ident, false, std::to_string(c)},
                               Token{TType::Newline, false } });

                block.append(body);
			}

			// create lines from body
			m_levels.back().split_lines(block);
		}
	}
}

void Preproc::do_repti() {
	if (!m_line.peek().is(TType::Ident))
		g_errors.error(ErrCode::Syntax);
	else {
		// get variable to iterate
		string var = m_line.peek().svalue();
		m_line.next();
		if (!m_line.peek().is(TType::Comma))
			g_errors.error(ErrCode::Syntax);
		else {
			m_line.next();
			if (m_line.peek().is(TType::Newline))
				g_errors.error(ErrCode::Syntax);
			else {
				// collect params to iterate
				vector<ScannedLine> params = collect_macro_params(m_line);
				if (!m_line.peek().is(TType::Newline))
					g_errors.error(ErrCode::Syntax);
				else {
					ScannedLine body = collect_macro_body(Keyword::REPTI, Keyword::ENDR);

					// expand macros in parameters
                    for (auto& param : params) {
                        ExpandedLine expanded_param = expand(param, defines());
                        param = expanded_param;
                    }

					// create new level for expansion
					m_levels.emplace_back(&defines());
                    ScannedLine block;
                    for (auto& param : params) {
                        block.append({ Token{TType::Hash, false },
                                       Token{TType::Ident, false, "undef"},
                                       Token{TType::Ident, false, var},
                                       Token{TType::Newline, false } });

                        block.append({ Token{TType::Hash, false },
                                       Token{TType::Ident, false, "define"},
                                       Token{TType::Ident, false, var} });
                        block.append(param);
                        block.append({ Token{TType::Newline, false } });

                        block.append(body);
					}

					// create lines from body
					m_levels.back().split_lines(block);
				}
			}
		}
	}
}

void Preproc::do_float() {
	ExpandedLine expanded = expand(m_line, defines());	// expand macros in line
	ScannedLine sublexer{ expanded };

	if (sublexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else {
		while (true) {
			// parse expression
            FloatExpr expr;
			if (!expr.parse(sublexer)) {
				g_errors.error(ErrCode::Syntax, expanded.to_string());
				return;
			}
			else if (expr.eval_error()) {
				g_errors.error(ErrCode::ExprEval, expanded.to_string());
				return;
			}
			else {
				double value = expr.value();
				vector<uint8_t> bytes = g_float_format.float_to_bytes(value);
                ScannedLine line;
                line.append({ Token{TType::Ident, false, "defb"} });
                for (unsigned i = 0; i < bytes.size(); i++) {
                    if (i != 0)
                        line.append({ Token{TType::Comma, false} });
                    line.append({ Token{TType::Integer, false, bytes[i]}});
                }
                line.append({ Token{TType::Semicolon, false},
                              Token{TType::Ident, false, "float"},
                              Token{TType::Dot, false},
                              Token{TType::Ident, false, g_float_format.get_type()},
                              Token{TType::LParen, false},
                              Token{TType::Floating, false, value},
                              Token{TType::RParen, false},
                              Token{TType::Newline, false} });
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
	ExpandedLine expanded = expand(m_line, defines());	// expand macros in line
	ScannedLine sublexer{ expanded };

	if (sublexer.peek().is(TType::Newline))
		g_errors.error(ErrCode::Syntax);
	else if (sublexer.peek().is(TType::Ident)) {
		string format = sublexer.peek().svalue();
		sublexer.next();
		if (!sublexer.peek().is(TType::Newline))
			g_errors.error(ErrCode::Syntax);
		else if (!g_float_format.set_text(format))
			g_errors.error(ErrCode::InvalidFloatFormat, FloatFormat::get_formats());
		else {}
	}
}

void Preproc::do_line() {
    if (m_line.peek(0).is(TType::Integer)) {
        int line_num = m_line.peek(0).ivalue();
        set_line_num(line_num, 1);
        set_c_source(false);
        m_line.next();

        if (m_line.peek(0).is(TType::Comma)) {
            m_line.next();
            if (m_line.peek(0).is(TType::String)) {
                string filename = m_line.peek(0).svalue();
                set_filename(filename);
                m_line.next();
            }
        }
    }

    if (!m_line.peek(0).is(TType::Newline, TType::End))
        g_errors.error(ErrCode::Syntax);

    set_error_location(location().filename().c_str(), location().line_num());
}

static string url_encode(const string& str) {
    const char* hex = "0123456789abcdef";
    ostringstream out;
    for (auto c : str) {
        if (is_alnum(c))
            out << c;
        else
            out << '_' << hex[(c >> 4) & 0xf] << hex[c & 0xf];
    }
    return out.str();
}


void Preproc::do_c_line() {
    if (m_line.peek(0).is(TType::Integer)) {
        int line_num = m_line.peek(0).ivalue();
        set_line_num(line_num, 0);
        set_c_source(true);
        m_line.next();

        if (m_line.peek(0).is(TType::Comma)) {
            m_line.next();
            if (m_line.peek(0).is(TType::String)) {
                string filename = m_line.peek(0).svalue();
                set_filename(filename);
                m_line.next();
            }
        }
    }

    if (!m_line.peek(0).is(TType::Newline, TType::End))
        g_errors.error(ErrCode::Syntax);

    set_error_location(location().filename().c_str(), location().line_num());

    // add debug symbol
    if (g_args.debug()) {
        string symbol_name = "__C_LINE_" + std::to_string(location().line_num()) +
            "_" + url_encode(location().filename());
        if (!find_local_symbol(symbol_name.c_str())) {
            ScannedLine label_line;
            label_line.append({ Token{TType::Ident, false, symbol_name}, Token{TType::Colon, false},
                                Token{TType::Newline, false} });
            push_expanded(label_line, defines());
        }
    }
}

void Preproc::push_expanded(ScannedLine& line, Macros& defines) {
    ExpandedLine expanded = expand(line, defines);
    if (expanded.got_error())
        m_output.push_back(line);
    else
        m_output.push_back(expanded);
}

ExpandedLine Preproc::expand(ScannedLine& line, Macros& defines) {
    ExpandedLine out;

	while (!line.at_end()) {
		Token token = line.peek(0);
		line.next();

        if (token.is(TType::Ident))
            expand_ident(out, token, line, defines);
        else
            out.append({ token });
	}
	return out;
}

void Preproc::expand_ident(ExpandedLine& out, const Token& ident, ScannedLine& line, Macros& defines) {
	unsigned pos = line.pos();
    ExpandedLine expanded = expand_define_call(ident, line, defines);
	if (expanded.got_error()) {
		line.set_pos(pos);
        out.append({ ident });
	}
	else
		out.append(expanded);
}

ExpandedLine Preproc::expand_define_call(const Token& ident, ScannedLine& line, Macros& defines) {
    ExpandedLine out;

	shared_ptr<Macro> macro = defines.find_all(ident.svalue());
	if (!macro) {							    // macro does not exists - insert name
        out.append({ ident });
		return out;
	}

	// macro exists
	if (macro->is_expanding()) {				// recursive invocation
		out.append(macro->body());
		out.set_error(true);
		return out;
	}

	// collect arguments
	vector<ScannedLine> params;
	if (macro->args().size() != 0) {
		params = collect_macro_params(line);
		if (macro->args().size() != params.size()) {
			g_errors.error(ErrCode::MacroArgsNumber, macro->name());
			return out;
		}
	}

	// create macros for each argument
	Macros sub_defines{ defines };				// create scope for arguments
	for (unsigned i = 0; i < macro->args().size(); i++) {
		string arg = macro->args()[i];
        ScannedLine param = i < params.size() ? params[i] : ScannedLine();
		shared_ptr<Macro> param_macro = make_shared<Macro>(arg, param);
		sub_defines.add(param_macro);
	}

	// expand macro
	macro->set_expanding(true);
    ScannedLine sub_lexer{ Token::to_string(macro->body().tokens()), macro->body().tokens() };
	out = expand(sub_lexer, sub_defines);
	macro->set_expanding(false);
	return out;
}

ScannedLine Preproc::collect_param(ScannedLine& line) {
    ScannedLine out;
    int open_parens = 0;
	while (!line.at_end()) {
        Token token = line.peek(0);
        switch (token.type()) {
        case TType::Newline:
            return out;

        case TType::LParen:
            open_parens++;
            out.append({ token });
            line.next();
            break;

        case TType::RParen:
            open_parens--;
            if (open_parens < 0) {
                return out;
            }
            else {
                out.append({ token });
                line.next();
            }
            break;

        case TType::Comma:
            if (open_parens == 0) {
                return out;
            }
            else {
                out.append({ token });
                line.next();
            }
            break;

        default:
            out.append({ token });
            line.next();
        }
	}

    return out;
}

vector<ScannedLine> Preproc::collect_macro_params(ScannedLine& line) {
	vector<ScannedLine> params;

	bool in_parens = line.peek().is(TType::LParen);
    if (in_parens)
		line.next();

	// collect up to close parens or end of line
	while (!line.at_end()) {
		params.push_back(collect_param(line));
		switch (line.peek().type()) {
		case TType::Comma:
			line.next();
			continue;

		case TType::RParen:
			if (in_parens)
				line.next();
			return params;

		case TType::Newline:
			return params;

		default:
			g_errors.error(ErrCode::Syntax);
			return params;
		}
	}

    g_errors.error(ErrCode::Syntax);
    return params;
}

vector<string> Preproc::collect_name_list(ScannedLine& line) {
	vector<string> names;
	while (true) {
		if (!line.peek().is(TType::Ident)) {
			g_errors.error(ErrCode::Syntax);
			break;
		}
		string name = line.peek().svalue();
		names.push_back(name);
		line.next();

		if (line.peek().is(TType::Comma)) 
			line.next();
		else if (line.peek().is(TType::Newline))
			break;
		else {
			g_errors.error(ErrCode::Syntax);
			break;
		}
	}
	return names;
}

ScannedLine Preproc::collect_macro_body(Keyword start_keyword, Keyword end_keyword) {
    m_reading_macro_body = true;
    ScannedLine out = collect_macro_body1(start_keyword, end_keyword);
    m_reading_macro_body = false;
    return out;
}

ScannedLine Preproc::collect_macro_body1(Keyword start_keyword, Keyword end_keyword) {
    Location start_location = m_files.back().location();

    // collect body
    ScannedLine empty, body, line;
    while (getline(line)) {
        m_line = line;

        int label_index = check_label_index();
        if ((label_index >= 0 && m_line.peek(2).is(start_keyword)) ||
            (m_line.peek(0).is(TType::Ident) && m_line.peek(1).is(start_keyword)) ||
            (m_line.peek(0).is(start_keyword))) {
            g_errors.error(ErrCode::UnbalancedStructStartedAt,
                start_location.filename() + ":" +
                std::to_string(start_location.line_num()));
            return empty;
        }
        else if (m_line.peek(0).is(end_keyword)) {
            m_line.next();
            if (!m_line.peek(0).is(TType::Newline)) {
                g_errors.error(ErrCode::Syntax);
                return empty;
            }
            else {
                return body;
            }
        }
        else {
            body.append(line);
        }
    }

    g_errors.error(ErrCode::UnbalancedStruct,
        start_location.filename() + ":" +
        std::to_string(start_location.line_num()));
    return empty;
}

string Preproc::collect_reptc_arg(ScannedLine& line) {
	string out;

	string prev_expanded;
	while (!line.at_end()) {
		Token token = line.peek();
		switch (token.type()) {
		case TType::String:
			line.next();
			if (!line.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else
				return token.svalue();
		case TType::Integer:
			line.next();
			if (!line.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else
				return std::to_string(token.ivalue());
		case TType::Ident: {
			ExpandedLine expanded = expand(line, defines());
			string expanded_text = str_chomp(expanded.to_string());
			if (!line.peek().is(TType::End, TType::Newline)) {
				g_errors.error(ErrCode::Syntax);
				return "";
			}
			else if (expanded_text == prev_expanded) {		// detect loop
				return expanded_text;
			}
			else {
				prev_expanded = expanded_text;
				ScannedLine sublexer{ expanded };
				line = sublexer;
				continue;
			}
		}
		default:
			g_errors.error(ErrCode::Syntax);
			return "";
		}
	}

    g_errors.error(ErrCode::Syntax);
    return "";
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
	ScannedLine line;
	if (g_hold_getline)
		return nullptr;
    if (g_preproc.getline(line)) 
		return must_strdup(line.to_string().c_str());	// needs to be freed by the user
	else
		return nullptr;
}

const char* sfile_filename() {
	if (g_preproc.location().filename().empty())
		return nullptr;
	else
		return spool_add(g_preproc.location().filename().c_str());
}

int sfile_line_num() {
	return g_preproc.location().line_num();
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

