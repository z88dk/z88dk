//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "utils.h"
#include <exception>
#include <string>
#include <vector>
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

static string norm_path(string filename) {
    size_t p = 0;
    while ((p = filename.find("\\")) != string::npos)
        filename[p] = '/';
    while ((p = filename.find("//")) != string::npos)
        filename.replace(p, 2, "/");
    return filename;
}

string search_path(const string& filename_, const vector<string>& path) {
    string filename = norm_path(filename_);
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

string file_basename(const string& filename_) {
    string filename = norm_path(filename_);
    return fs::path(filename).stem().generic_string();
}

string file_replace_extension(const string& filename_, const string& extension) {
    string filename = norm_path(filename_);
    fs::path file_path{ filename };
    file_path.replace_extension(extension);
    return file_path.generic_string();
}

string file_prepend_output_dir(const string& filename_) {
    string filename = norm_path(filename_);
    if (g_output_dir.empty())
        return filename;
    else {
        string output_dir = norm_path(g_output_dir);
        if (!output_dir.empty() && output_dir.back() == '/')
            output_dir.pop_back();
        if (filename.substr(0, output_dir.size() + 1) == output_dir + "/") {
            // #2260: may be called with an object file already with the path prepended; do not add it twice
            return filename;
        }
        else {
            // NOTE: concatenation (/) of a relative fs::path and an
            // absolute fs::path discards the first one! Do our magic
            // with strings instead.
            // is it a win32 absolute path?
            string file;
            if (isalpha(filename[0]) && filename[1] == ':') {	// C:
                file += output_dir + "/";
                file += string(1, filename[0]) + "/";
                file += string(filename.substr(2));
            }
            else {
                file += output_dir + "/";
                file += filename;
            }
            return norm_path(file);
        }
    }
}

string file_parent_dir(const string& filename_) {
    string filename = norm_path(filename_);
    string parent_dir = fs::path(filename).parent_path().generic_string();
    if (parent_dir.empty())
        return ".";
    else
        return parent_dir;
}

bool file_is_regular_file(const string& filename) {
    return fs::is_regular_file(filename);
}

bool file_is_directory(const string& filename) {
    return fs::is_directory(filename);
}

bool file_create_directories(const string& dirname) {
    if (file_is_directory(dirname))
        return true;
    else {
        bool ok = true;
        try {
            fs::create_directories(dirname);
        }
        catch (exception&) {
            ok = false;
        }
        return ok;
    }
}

string file_asm_filename(const string& filename) {
    return file_replace_extension(filename, EXT_ASM);
}

string file_lis_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_LIS));
}

string file_o_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_O));
}

string file_def_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_DEF));
}

// see https://github.com/z88dk/z88dk/issues/2049
// No fix, to avoid breaking too many things:
// -oFILE generates single binary FILE
// -oFILE.EXT generates single binary file FILE.EXT
// section outputs are always FILE_CODE.bin
string file_bin_filename(const string& filename_, const string& section) {
    string filename = norm_path(filename_);
    fs::path file_path, file_ext;

    if (g_bin_filename.empty()) {
        file_path = filename;
        file_ext = EXT_BIN;
    }
    else {
        // output file may have no extension
        file_path = g_bin_filename;
        file_ext = file_path.extension();
    }

    string filename1 = file_prepend_output_dir(file_path.generic_string());
    string filename2 = file_replace_extension(filename1, file_ext.generic_string());
    file_path = filename2;

    if (!section.empty()) {
        // output file with section has .bin extension
        fs::path new_path;
        new_path = file_path.parent_path();
        if (file_path.stem() != EXT_BIN)
            new_path /= file_path.stem();
        else
            new_path /= "";
        new_path += "_";
        new_path += section;
        new_path += EXT_BIN;
        file_path = new_path;
    }

    return file_path.generic_string();
}

string file_lib_filename(const string& filename) {
    return file_replace_extension(filename, EXT_LIB);
}

string file_sym_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_SYM));
}

string file_map_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_MAP));
}

string file_reloc_filename(const string& filename) {
    return file_prepend_output_dir(file_replace_extension(filename, EXT_RELOC));
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
        g_asm.error(ErrFileOpen, filename);
        perror(filename.c_str());
        return false;
    }
    else {
        string parent_dir = fs::path(filename).parent_path().generic_string();
        if (!parent_dir.empty()) {
            count_open_++;
            g_include_path.push_back(parent_dir);
        }
        g_asm.clear_location();
        g_asm.set_location(location_);
        return true;
    }
}

bool OpenFile::getline(string& line) {
    line.clear();
    bool ok = !safe_getline(ifs_, line).eof();
    if (ok) {
        location_.inc_line_num();
        g_asm.set_location(location_);
        g_asm.set_source_line(line);
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
        g_asm.error(ErrIncludeRecursion, filename);
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
            g_asm.clear_location();
            if (!open_files_.empty())
                g_asm.set_location(open_files_.back().location());
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
        g_asm.set_source_line(line);
        return true;
    }
}

