//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include <fstream>
#include <iostream>
#include <list>
#include <string>
#include <vector>
using namespace std;

string search_path(const string& filename, const vector<string>& path);

class OpenFile {
public:
    OpenFile();
    virtual ~OpenFile();
    OpenFile(OpenFile& other) = delete;
    OpenFile& operator=(OpenFile& other) = delete;

    const string& filename() const;
    Location& location();

    bool open(const string& filename);
    bool getline(string& line);

private:
    ifstream    ifs_;               // input file handle
    string      filename_;          // name of file opened
    Location    location_;          // current input location
    int         count_open_{ 0 };   // number of times open called
};

// read text files
class FileReader {
public:
    const string& filename() const;
    Location& location();

    bool open(const string& filename);
    bool getline(string& line);

protected:
    list<OpenFile> open_files_;

    bool recursive_include(const string& filename);
    virtual bool getline1(string& line);    // read one line from input
};

// read source files - join backslash-ended lines with next line
class SourceReader : public FileReader {
protected:
    bool getline1(string& line) override;
};
