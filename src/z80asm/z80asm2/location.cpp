//-----------------------------------------------------------------------------
// z80asm
// Location of an input line
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"
using namespace std;

Location g_location;

Location::Location(const string& filename, int line_num)
    : m_filename(filename), m_line_num(line_num) {
    clear_text();
}

void Location::clear() {
    m_filename.clear();
    m_line_num = 0;
    clear_text();
}

void Location::clear_text() {
    m_text.clear();
    m_expanded_text.clear();
}

bool Location::empty() const {
    return m_filename.empty() && m_line_num == 0;
}

void Location::set_filename(const string& filename) {
    m_filename = filename;
    m_line_num = 0;
    m_text.clear();
    m_expanded_text.clear();
}

void Location::set_line_num(int line_num) {
    m_line_num = line_num;
    m_text.clear();
    m_expanded_text.clear();
}

void Location::set_text(const string& text) {
    m_text = text;
    m_expanded_text.clear();
}

void Location::set_expanded_text(const string& expanded_text) {
    if (expanded_text == m_text)
        m_expanded_text.clear();
    else
        m_expanded_text = expanded_text;
}

