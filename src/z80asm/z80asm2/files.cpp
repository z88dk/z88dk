//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "utils.h"
#include <exception>
#include <regex>
#include <set>
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

string file_norm_path(string filename) {
    size_t p = 0;
    while ((p = filename.find("\\")) != string::npos)
        filename[p] = '/';
    while ((p = filename.find("//")) != string::npos)
        filename.replace(p, 2, "/");
    return filename;
}

string file_search_path(const string& filename_, const vector<string>& path) {
    string filename = file_norm_path(filename_);
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
    string filename = file_norm_path(filename_);
    return fs::path(filename).stem().generic_string();
}

string file_extension(const string& filename) {
    return fs::path(filename).extension().generic_string();
}

string file_replace_extension(const string& filename_, const string& extension) {
    string filename = file_norm_path(filename_);
    fs::path file_path{ filename };
    file_path.replace_extension(extension);
    return file_path.generic_string();
}

string file_prepend_output_dir(const string& filename_) {
    string filename = file_norm_path(filename_);
    string output_dir = file_norm_path(g_options.output_dir());
    if (output_dir.empty())
        return filename;
    else {
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
            return file_norm_path(file);
        }
    }
}

string file_parent_path(const string& filename_) {
    string filename = file_norm_path(filename_);
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

static bool check_signature(const string& filename, const string& signature_base, int version) {
    ifstream ifs(filename, ios::binary);

    // open file
    if (!ifs.is_open())
        return false;

    // read signature
    char buffer[SIGNATURE_SIZE];
    ifs.read(buffer, sizeof(buffer));
    if (ifs.gcount() != sizeof(buffer))
        return false;

    // check signature_base
    string got_signature_base = string(buffer, buffer + SIGNATURE_BASE_SIZE);
    if (got_signature_base != signature_base)
        return false;

    // check version
    int got_version = atoi(buffer + SIGNATURE_BASE_SIZE);
    if (got_version != version)
        return false;

    return true;
}

bool file_is_object_file(const string& filename) {
    return check_signature(filename, OBJ_FILE_SIGNATURE, OBJ_FILE_VERSION);
}

bool file_is_library_file(const string& filename) {
    return check_signature(filename, LIB_FILE_SIGNATURE, OBJ_FILE_VERSION);
}

string file_current_path() {
    return file_norm_path(fs::current_path().generic_string());
}

static void expand_glob_1(set<fs::path>& result, const string& pattern);

static void expand_wildcards(set<fs::path>& result, const vector<string>& elems, size_t cur_elem) {
    // build prefix and suffix
    fs::path prefix;
    for (size_t i = 0; i < cur_elem; i++) {
        prefix /= fs::path(elems[i]);
    }
    if (prefix.empty()) {
        prefix = ".";
    }

    fs::path suffix;
    for (size_t i = cur_elem + 1; i < elems.size(); i++) {
        suffix /= elems[i];
    }

    // expand current element
    if (elems[cur_elem] == "**") {
        fs::path new_path{ prefix };
        if (!suffix.empty())
            new_path /= suffix;
        expand_glob_1(result, new_path.generic_string());		// recurse

        for (auto& entry : fs::recursive_directory_iterator(prefix)) {
            if (fs::is_directory(entry)) {
                fs::path new_path{ entry };
                if (!suffix.empty())
                    new_path /= suffix;
                expand_glob_1(result, new_path.generic_string());		// recurse
            }
            else if (suffix.empty() && fs::is_regular_file(entry)) {
                expand_glob_1(result, entry.path().generic_string());
            }
        }
    }
    else {
        // make a regex pattern
        string pattern = elems[cur_elem];
        pattern = str_replace_all(pattern, ".", "\\.");
        pattern = str_replace_all(pattern, "*", ".*");
        pattern = str_replace_all(pattern, "?", ".");
        regex re{ pattern };

        // iterate through directory and recurse for each match
        if (fs::is_directory(prefix)) {
            for (auto& entry : fs::directory_iterator(prefix)) {
                string entry_basename_str = entry.path().filename().generic_string();
                if (regex_match(entry_basename_str, re)) {
                    fs::path new_path{ entry };
                    if (!suffix.empty())
                        new_path /= suffix;
                    expand_glob_1(result, new_path.generic_string());		// recurse
                }
            }
        }
    }
}

static void expand_glob_1(set<fs::path>& result, const string& pattern) {
    // split path in directory/file elements
    fs::path full_path{ pattern };
    vector<string> elems;
    for (auto elem : full_path) {
        elems.push_back(elem.generic_string());
    }

    // iterate through element looking for wildcards
    for (size_t i = 0; i < elems.size(); i++) {
        // check if this element has wildcards
        size_t wc_pos = elems[i].find_first_of("?*");
        if (wc_pos != string::npos) {
            expand_wildcards(result, elems, i);
            return;
        }
    }

    // if we reached here, there are no wildcards
    fs::path path{ pattern };
    if (fs::is_directory(path) || fs::is_regular_file(path))
        result.insert(path);
}

// use set in recursion to eliminate duplicates
void file_expand_glob(vector<string>& result, const string& pattern) {
    result.clear();

    set<fs::path> filenames;
    expand_glob_1(filenames, pattern);

    // #2380 - remove ./ prefix if it was added during glob search
    bool pattern_has_dot_slash = (pattern.substr(0, 2) == "./");
    for (auto& filename : filenames) {
        string filename_str = filename.generic_string();
        if (!pattern_has_dot_slash && filename_str.substr(0, 2) == "./") {
            // ./ was added during glob search
            filename_str.erase(filename_str.begin(), filename_str.begin() + 2);
        }

        result.push_back(filename_str);
    }
}

bool file_newer(const string& filename1, const string& filename2) {
    if (fs::last_write_time(filename1) >= fs::last_write_time(filename2))
        return true;
    else
        return false;
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
    string filename = file_norm_path(filename_);
    fs::path file_path, file_ext;

    string bin_filename = g_options.bin_filename();
    if (bin_filename.empty()) {
        file_path = filename;
        file_ext = EXT_BIN;
    }
    else {
        // output file may have no extension
        file_path = bin_filename;
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

istream& safe_getline(istream& is, string& t) {
    t.clear();

    // The characters in the stream are read one-by-one using a streambuf.
    // That is faster than reading them one-by-one using the istream.
    // Code that uses streambuf this way must be guarded by a sentry object.
    // The sentry object performs various tasks,
    // such as thread synchronization and updating the stream state.

    istream::sentry se(is, true);
    streambuf* sb = is.rdbuf();

    for (;;) {
        int c = sb->sbumpc();
        switch (c) {
        case '\n':
            return is;
        case '\r':
            if (sb->sgetc() == '\n')
                sb->sbumpc();
            return is;
        case streambuf::traits_type::eof():
            // Also handle the case when the last line has no line ending
            if (t.empty())
                is.setstate(ios::eofbit);
            return is;
        default:
            t += (char)c;
        }
    }
}

//-----------------------------------------------------------------------------

OpenFile::OpenFile() {
}

OpenFile::~OpenFile() {
    for (int i = 0; i < count_open_; i++)
        g_options.include_path().pop_back();
}

const string& OpenFile::filename() const {
    return filename_;
}

Location& OpenFile::location() {
    return location_;
}

bool OpenFile::open(const string& filename) {
    close();
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
            g_options.include_path().push_back(parent_dir);
        }
        g_errors.clear_location();
        g_errors.set_location(location_);
        return true;
    }
}

void OpenFile::close() {
    if (ifs_.is_open())
        ifs_.close();
}

bool OpenFile::getline(string& line) {
    line.clear();
    bool ok = ifs_.is_open() && !safe_getline(ifs_, line).eof();
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

FileReader::FileReader() {
    clear();
}

void FileReader::clear() {
    while (!open_files_.empty()) {
        open_files_.back().close();
        open_files_.pop_back();
    }
}

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
    string found_filename = file_search_path(filename, g_options.include_path());

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

