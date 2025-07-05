//-----------------------------------------------------------------------------
// z80asm
// Location of an input line
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "string_table.h"
#include <string>
using namespace std;

class Location {
public:
    Location(const string& filename = "", int line_num = 0);
    Location(const Location& other);
    Location& operator=(const Location& other);
    void clear();
    bool empty() const;

    bool operator==(const Location& other) const;
    bool operator!=(const Location& other) const { return !(*this == other); }

    const string& filename() const { return m_str_table.get_string(m_filename_id); }
    int line_num() const { return m_line_num; }

    void set(const string& filename, int line_num);
    void set_filename(const string& filename);
    void set_line_num(int line_num);
    void inc_line_num();

private:
    int m_filename_id{ 0 };
    int m_line_num{ 0 };

    static StringTable m_str_table;
};

extern Location* g_location;

class SourceText {
public:
    SourceText() = default;
    void clear();
    void clear_expanded_text();
    const string& text() const { return m_text; }
    const string& expanded_text() const { return m_expanded_text; }

    void set_text(const string& text);
    void set_expanded_text(const string& expanded_text);

private:
    string m_text;
    string m_expanded_text;
};

extern SourceText* g_source_text;
