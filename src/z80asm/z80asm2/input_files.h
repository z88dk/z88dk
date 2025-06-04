//-----------------------------------------------------------------------------
// z80asm
// Stack of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <fstream>
#include <iostream>
#include <list>
using namespace std;

class InputFiles {
public:
    InputFiles() {}
    InputFiles(const InputFiles& other) = delete;
    virtual ~InputFiles();
    InputFiles& operator=(const InputFiles& other) = delete;

    void push_file(const string& filename);
    bool getline(string& line);

private:
    struct File {
        string filename;
        int line_num{ 0 };
        int line_inc{ 1 };
        ifstream ifs;
    };
    list<File*> m_files; // stack of input files

    void pop_file();
    bool already_included(const string& filename);
};

extern InputFiles g_input_files;

