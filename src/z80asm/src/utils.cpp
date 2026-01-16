//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <cctype>
#include <regex>
#include <set>
using namespace std;

bool is_ident(const string& ident) {
    if (ident.empty())
        return false;
    else if (!is_ident_start(ident[0]))
        return false;
    else {
        for (auto c : ident) {
            if (!is_ident(c))
                return false;
        }
        return true;
    }
}

int char_digit(char c) {
    return isdigit(c) ? c - '0' : isxdigit(c) ? 10 + toupper(c) - 'A' : -1;
}

bool str_ends_with(const string& str, const string& ending) {
    if (str.length() >= ending.length())
        return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
    else
        return false;
}

string str_tolower(string str) {
    transform(str.begin(), str.end(), str.begin(), [](char c) {return tolower(c); });
    return str;
}

string str_toupper(string str) {
    transform(str.begin(), str.end(), str.begin(), [](char c) {return toupper(c); });
    return str;
}

string str_strip(const string& str) {
    const char* p = str.c_str();
    while (*p && isspace(*p))
        p++;
    return str_chomp(p);
}

string str_chomp(const string& str_) {
    string str = str_;
    while (!str.empty() && isspace(str.back()))
        str.pop_back();
    return str;
}

string str_remove_all_blanks(const string& str) {
    string out;
    for (auto c : str)
        if (!isspace(c))
            out.push_back(c);
    return out;
}

string str_remove_extra_blanks(const string& str) {
    string out;
    for (const char* p = str.c_str(); *p != '\0'; p++) {
        if (!isspace(*p))
            out.push_back(*p);
        else {
            out.push_back(' ');
            while (isspace(p[1]))
                p++;
        }
    }
    return str_strip(out);
}

string str_replace_all(string text, const string& find, const string& replace) {
    size_t p = 0;
    while ((p = text.find(find, p)) != string::npos) {
        text.replace(p, find.length(), replace);
        p += replace.length();
    }
    return text;
}

static void expand_glob_1(set<fs::path>& result, const string& pattern);

static void expand_wildcards(set<fs::path>& result,
    const vector<string>& elems, size_t cur_elem) {
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
void expand_glob(vector<fs::path>& result, const string& pattern) {
    set<fs::path> files;
    expand_glob_1(files, pattern);

    // #2380 - remove ./ prefix if it was added during glob search
    bool pattern_has_dot_slash = (pattern.substr(0, 2) == "./");
    for (auto& file : files) {
        string file_str = file.generic_string();

        if (!pattern_has_dot_slash && file_str.substr(0, 2) == "./") {
            // ./ was added during glob search
            file_str.erase(file_str.begin(), file_str.begin() + 2);
        }

        result.push_back(file_str);
    }
}

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

std::string pop_end_slash(std::string path) {
    while (!path.empty() && (path.back() == '/' || path.back() == '\\'))
        path.pop_back();
    return path;
}

std::string join_dir(const std::string& a, const std::string& b) {
    std::string left = a;
    std::string right = b;

    // Remove trailing slashes from left
    while (!left.empty() && (left.back() == '/' || left.back() == '\\'))
        left.pop_back();

    // Remove leading slashes from right
    while (!right.empty() && (right.front() == '/' || right.front() == '\\'))
        right.erase(right.begin());

    if (left.empty())
        return right;
    if (right.empty())
        return left;

    return left + "/" + right;
}
