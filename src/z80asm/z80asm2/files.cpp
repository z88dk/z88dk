//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "utils.h"
using namespace std;

#if __has_include(<filesystem>)
// std::filesystem from C++17
#include <filesystem>
namespace fs = std::filesystem;
#else
// boost::filesystem from Boost
#include <boost/filesystem.hpp>
namespace fs = boost::filesystem;
#endif

//-----------------------------------------------------------------------------

string search_path(const string& filename, const vector<string>& path) {
    fs::path file_path{ filename };

    // if path is empty, return filename as-is
    if (path.empty())
        return file_path.generic_string();

    // if file exists, return filename as-is
    if (fs::is_regular_file(file_path))
        return file_path.generic_string();

    // search in directory list
    for (auto& dir : path) {
        fs::path full_path{ fs::path(dir) / file_path };

        if (fs::is_regular_file(full_path))
            return full_path.generic_string();
    }

    // not found, return original file name
    return file_path.generic_string();
}

//-----------------------------------------------------------------------------

OpenFile::OpenFile() {
}

OpenFile::~OpenFile() {
    for (int i = 0; i < count_open_; i++)
        g_include_path.pop_back();
}

const string& OpenFile::filename() const {
    return filename_;
}

Location& OpenFile::location() {
    return location_;
}

bool OpenFile::open(const string& filename) {
    filename_ = filename;
    location_ = Location(filename);
    ifs_.open(filename, ios::binary);
    if (!ifs_.is_open()) {
        g_errors.error(ErrFileOpen, filename);
        perror(filename.c_str());
        return false;
    }
    else {
        string parent_dir = fs::path(filename).parent_path().generic_string();
        if (!parent_dir.empty()) {
            count_open_++;
            g_include_path.push_back(parent_dir);
        }
        g_errors.clear_location();
        g_errors.set_location(location_);
        return true;
    }
}

bool OpenFile::getline(string& line) {
    line.clear();
    bool ok = !safe_getline(ifs_, line).eof();
    if (ok) {
        location_.inc_line_num();
        g_errors.set_location(location_);
        g_errors.set_source_line(line);
        return true;
    }
    else
        return false;
}

//-----------------------------------------------------------------------------

const string& FileReader::filename() const {
    static string empty;
    if (open_files_.empty())
        return empty;
    else
        return open_files_.back().filename();
}

Location& FileReader::location() {
    static Location empty;
    if (open_files_.empty())
        return empty;
    else
        return open_files_.back().location();
}

bool FileReader::open(const string& filename_) {
    // canonize path
    string filename = fs::path(filename_).generic_string();

    // search file in path
    string found_filename = search_path(filename, g_include_path);

    // check for recursive includes
    if (recursive_include(found_filename)) {
        g_errors.error(ErrIncludeRecursion, filename);
        return false;
    }

    // open file
    open_files_.emplace_back();
    return open_files_.back().open(found_filename);
}

bool FileReader::getline(string& line) {
    line.clear();
    while (true) {
        if (open_files_.empty())
            return false;
        else if (getline1(line))
            return true;
        else {
            open_files_.pop_back();
            g_errors.clear_location();
            if (!open_files_.empty())
                g_errors.set_location(open_files_.back().location());
        }
    }
}

bool FileReader::recursive_include(const string& filename) {
    for (auto& file : open_files_) {
        if (file.filename() == filename)
            return true;
    }
    return false;
}

bool FileReader::getline1(string& line) {
    return open_files_.back().getline(line);
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
        g_errors.set_source_line(line);
        return true;
    }
}
