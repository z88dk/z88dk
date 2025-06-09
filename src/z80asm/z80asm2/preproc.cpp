//-----------------------------------------------------------------------------
// z80asm
// Macro preprocessor
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "input_files.h"
#include "location.h"
#include "preproc.h"
using namespace std;

Preproc* g_preproc{ nullptr };

void Preproc::clear() {
    m_expanded_lines.clear();
    m_in.clear();
    m_out.clear();
    m_autolabel_id = 1;
}

void Preproc::expand(const string& input_line) {
    m_in.scan(input_line);

    expand_macros();

    while (!m_in.peek().is(TType::END)) {
        m_out.clear();
        // EQU
        if (m_in.peek(0).is(TType::DOT) && m_in.peek(1).is(TType::IDENT) && m_in.peek(2).is(Keyword::EQU)) {
            m_out.push_back(m_in.peek(1)); // IDENT
            m_out.push_back(m_in.peek(2)); // equ
            m_in.next(3);
            collect_statement();
            push_out();
        }
        // EQU
        else if (m_in.peek(0).is(TType::IDENT) && m_in.peek(1).is(TType::COLON) && m_in.peek(2).is(Keyword::EQU)) {
            m_out.push_back(m_in.peek(0)); // IDENT
            m_out.push_back(m_in.peek(2)); // equ
            m_in.next(3);
            collect_statement();
            push_out();
        }
        // .ASSUME
        else if (m_in.peek(0).is(TType::DOT) && m_in.peek(1).is(Keyword::ASSUME)) {
            m_out.push_back(m_in.peek(1)); // ASSUME
            m_in.next(2);
            collect_statement();
            push_out();
        }
        // .label
        else if (m_in.peek(0).is(TType::DOT) && m_in.peek(1).is(TType::IDENT)) {
            m_out.push_back(m_in.peek(1)); // IDENT
            m_out.push_back(Token(TType::COLON, false)); // :
            m_in.next(2);
            push_out();
        }
        // label:
        else if (m_in.peek(0).is(TType::IDENT) && m_in.peek(1).is(TType::COLON)) {
            m_out.push_back(m_in.peek(0)); // IDENT
            m_out.push_back(Token(TType::COLON, false)); // :
            m_in.next(2);
            push_out();
        }
        // #INCLUDE
        else if (m_in.peek(0).is(TType::HASH) && m_in.peek(1).is(Keyword::INCLUDE) && m_in.peek(2).is(TType::RAW_STR)) {
            string filename = m_in.peek(2).svalue();
            m_in.next(3);
            check_end();
            g_input_files->push_file(filename);
        }
        // INCLUDE
        else if (m_in.peek(0).is(Keyword::INCLUDE) && m_in.peek(1).is(TType::RAW_STR)) {
            string filename = m_in.peek(1).svalue();
            m_in.next(2);
            check_end();
            g_input_files->push_file(filename);
        }
        // Handle one statement, possibly empty
        else {
            collect_statement();
            push_out();
        }
    }
}

void Preproc::collect_statement() {
    while (!m_in.peek().is(TType::END)) {
        if (m_in.peek().is_end()) {
            m_in.next();
            return;
        }
        else {
            m_out.push_back(m_in.peek());
            m_in.next();
        }
    }
}

void Preproc::expand_macros() {
    // TODO
}

bool Preproc::getline(string& line) {
    line.clear();
    while (true) {
        if (m_expanded_lines.empty()) {
            return false;
        }
        else {
            line = m_expanded_lines.front();
            m_expanded_lines.pop_front();
            if (!line.empty())
                return true;
        }
    }
}

string Preproc::autolabel() {
    return string("__") + std::to_string(m_autolabel_id++);
}

void Preproc::preproc_only(const string& filename) {
    g_preproc->clear();
    Location location;

    g_input_files->push_file(filename);
    string line;
    while (g_input_files->getline(line)) {
        g_preproc->expand(line);
        string expanded_line;
        while (g_preproc->getline(expanded_line)) {
            g_location->set_expanded_text(expanded_line);
            if (location != *g_location) {
                cout << "LINE " << g_location->line_num()
                    << " \"" << g_location->filename() << "\"" << endl;
                location.set_filename(g_location->filename());
                location.set_line_num(g_location->line_num());
            }
            cout << expanded_line << endl;
            location.inc_line_num();
        }
    }
}

void Preproc::push_out() {
    string line = m_out.to_string();
    m_expanded_lines.push_back(line);
    m_out.clear();
}

void Preproc::check_end() {
    if (!m_in.peek().is(TType::END)) {
        g_error->error_expected_eol();
        m_in.clear();
    }
}

