//-----------------------------------------------------------------------------
// z80asm
// Location of an input line
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

class Location {
public:
    Location(const string& filename = "", int line_num = 0);
    void clear();
    void clear_text();
    bool empty() const;

    const string& filename() const { return m_filename; }
    int line_num() const { return m_line_num; }
    const string& text() const { return m_text; }
    const string& expanded_text() const { return m_expanded_text; }

    void set_filename(const string& filename);
    void set_line_num(int line_num);
    void set_text(const string& text);
    void set_expanded_text(const string& expanded_text);

private:
    string m_filename;
    int m_line_num;
    string m_text;
    string m_expanded_text;
};

extern Location* g_location;

