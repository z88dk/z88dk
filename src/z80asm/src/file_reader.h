//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include <fstream>
#include <iostream>
#include <list>
#include <string>
using namespace std;

struct OpenFile {
    ifstream    ifs;            // input file handle
    string      filename;       // name of file opened
    Location    location;       // current input location

    bool open(const string& filename);
};

// read text files
struct FileReader {
    list<OpenFile> open_files;

    bool open(const string& filename);
    bool getline(string& line);

protected:
    bool recursive_include(const string& filename);
    virtual bool getline1(string& line);    // read one line from input
    virtual bool stop_at_eof();             // return true to stop reading, false to continue
};

extern FileReader g_file_reader;

// read source files - join backslash-ended lines with next line
struct SourceReader : public FileReader {
private:
    bool getline1(string& line) override;
};
