//-----------------------------------------------------------------------------
// z80asm - store location in source file
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

class Location {
public:
    Location(const string& filename = "", int line_num = 0, bool is_c_file = false);
    void clear();
    bool empty() const;
    const string& filename() const;
    int line_num() const;
    bool is_c_file() const;
    void set_filename(const string& filename);
    void set_line(const string& filename, int line_num);
    void set_line(int line_num);
    void set_c_line(const string& filename, int line_num);
    void set_c_line(int line_num);
    void inc_line_num(int increment = 1);
    string to_string() const;

private:
    // TODO: implement as a global string table to reduce memory consumption
    string filename_;               // source file name
    int line_num_{ 0 };             // source line number
    bool is_c_file_{ false };       // if C_LINE was found, lines are not incremented
};

string to_string(const Location& location);
