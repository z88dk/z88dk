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

// default file name extensions
#define EXT_ASM     ".asm"    
#define EXT_LIS		".lis"    
#define EXT_O		".o"	  
#define EXT_DEF     ".def"    
#define EXT_BIN     ".bin"    
#define EXT_LIB     ".lib"    
#define EXT_SYM     ".sym"    
#define EXT_MAP     ".map"    
#define EXT_RELOC   ".reloc"
#define EXT_M4      ".m4"

// file names
string file_search_path(const string& filename, const vector<string>& path);
string file_basename(const string& filename);
string file_replace_extension(const string& filename, const string& extension);
string file_prepend_output_dir(const string& filename);
string file_parent_dir(const string& filename);
bool file_is_regular_file(const string& filename);
bool file_is_directory(const string& filename);
bool file_create_directories(const string& dirname);

string file_asm_filename(const string& filename);
string file_lis_filename(const string& filename);
string file_o_filename(const string& filename);
string file_def_filename(const string& filename);
string file_bin_filename(const string& filename, const string& section = "");
string file_lib_filename(const string& filename);
string file_sym_filename(const string& filename);
string file_map_filename(const string& filename);
string file_reloc_filename(const string& bin_filename);

istream& safe_getline(istream& is, string& t);

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

