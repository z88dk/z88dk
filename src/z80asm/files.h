//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include <fstream>
#include <iostream>
#include <list>
#include <string>
using namespace std;

class FileReader {
public:
    bool open(const string& filename);
    bool is_open() const;
    void push_back(const string& line);
    bool getline(string& line);
    bool is_pushed_back() const { return m_is_pushed_back; }
    Location& get_location();

private:
    struct OpenFile {
        ifstream ifs;
        Location location;

        OpenFile(const string& filename)
            : ifs(filename, ios::binary), location(filename) {}
    };

    list<OpenFile> m_open_files;
    vector<string> m_pushed_back_lines;
    bool m_is_pushed_back{ false };

    bool check_recursion(const string& filename) const;
};


class FileLister {
public:
    bool open(const string& filename);
    void close();

    void notify_source_line(const Location& location, const string& line);
    void notify_expanded_line(const Location& location, const string& line);

private:
    ofstream m_ofs;
};


extern FileReader g_file_reader;
extern FileLister g_file_lister;
