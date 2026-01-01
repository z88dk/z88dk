//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "file_reader.h"
#include "options.h"
#include "utils.h"
using namespace std;

//-----------------------------------------------------------------------------

FileReader g_file_reader;

//-----------------------------------------------------------------------------

bool OpenFile::open(const string& filename_) {
    filename = filename_;
    location = Location(filename);
    ifs.open(filename, ios::binary);
    if (!ifs.is_open()) {
        g_errors.error(ErrFileOpen, filename);
        perror(filename.c_str());
        return false;
    }
    else
        return true;
}

bool FileReader::open(const string& filename_) {
    // canonize path
    string filename = fs::path(filename_).generic_string();

    // search file in path
    string found_filename = g_options.search_include_path(filename);

    // check for recursive includes
    if (recursive_include(found_filename)) {
        g_errors.error(ErrIncludeRecursion, filename);
        return false;
    }

    // open file
    open_files.emplace_back();
    return open_files.back().open(found_filename);
}

bool FileReader::getline(string& line) {
    line.clear();
    while (true) {
        if (open_files.empty())
            return false;
        else if (getline1(line))
            return true;
        else if (stop_at_eof())
            return false;
        else {
            open_files.pop_back();
            g_errors.location.clear();
            if (!open_files.empty())
                g_errors.location = open_files.back().location;
            else
                g_errors.location = Location();
        }
    }
}

bool FileReader::recursive_include(const string& filename) {
    for (auto& file : open_files) {
        if (file.filename == filename)
            return true;
    }
    return false;
}

bool FileReader::getline1(string& line) {
    bool ok = !safe_getline(open_files.back().ifs, line).eof();
    if (ok) {
        open_files.back().location.inc_line_num();
        g_errors.location = open_files.back().location;
        g_errors.location.set_source_line(line);
        return true;
    }
    else
        return false;
}

bool FileReader::stop_at_eof() {
    return false;
}

//-----------------------------------------------------------------------------

bool SourceReader::getline1(string& line) {
    bool ok = FileReader::getline1(line);
    if (!ok)
        return false;
    else {
        while (ok && !line.empty() && line.back() == '\\') {
            line.pop_back();        // remove backslash
            line.push_back(' ');    // add space
            string cont_line;
            ok = FileReader::getline1(cont_line);
            line += cont_line;
        }
        g_errors.location.set_source_line(line);
        return true;
    }
}
