//-----------------------------------------------------------------------------
// z80asm
// Location of an input line
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"
using namespace std;

Location* g_location{ nullptr };
SourceText* g_source_text{ nullptr };
StringTable Location::m_str_table;


Location::Location(const string& filename, int line_num)
    : m_filename_id(m_str_table.add_string(filename)), m_line_num(line_num) {
}

Location::Location(const Location& other) {
    m_filename_id = other.m_filename_id;
    m_line_num = other.m_line_num;
}

Location& Location::operator=(const Location& other) {
    if (this != &other) {
        m_filename_id = other.m_filename_id;
        m_line_num = other.m_line_num;
    }
    return *this;
}

bool Location::operator==(const Location& other) const {
    return m_filename_id == other.m_filename_id && m_line_num == other.m_line_num;
}

void Location::clear() {
    m_filename_id = 0;
    m_line_num = 0;
}

bool Location::empty() const {
    return m_filename_id == 0 && m_line_num == 0;
}

void Location::set(const string& filename, int line_num) {
    m_filename_id = m_str_table.add_string(filename);
    m_line_num = line_num;
}

void Location::set_filename(const string& filename) {
    m_filename_id = m_str_table.add_string(filename);
    m_line_num = 0;
}

void Location::set_line_num(int line_num) {
    m_line_num = line_num;
}

void Location::inc_line_num() {
    m_line_num++;
}

void SourceText::clear() {
    m_text.clear();
    m_expanded_text.clear();
}

void SourceText::clear_expanded_text() {
    m_expanded_text.clear();
}

void SourceText::set_text(const string& text) {
    m_text = text;
    m_expanded_text.clear();
}

void SourceText::set_expanded_text(const string& expanded_text) {
    if (expanded_text == m_text)
        m_expanded_text.clear();
    else
        m_expanded_text = expanded_text;
}
