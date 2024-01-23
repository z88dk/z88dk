//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "z80asm.h"
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

string expand_env_vars(string text) {
    while (true) {
        // search backwards to expand nested references
        size_t dollar_pos = text.rfind("${");
        if (dollar_pos == string::npos)
            break;
        size_t end_pos = text.substr(dollar_pos + 2).find('}');
        if (end_pos == string::npos)
            break;

        string varname = text.substr(dollar_pos + 2, end_pos);
        char* valptr = getenv(varname.c_str());
        string value = valptr == nullptr ? "" : string(valptr);

        text.replace(dollar_pos, end_pos + 2 + 1, value);
    }
    return text;
}

string unquote(string text) {
    while (true) {
        size_t q1pos = text.find('"');
        size_t q2pos = text.find('\'');
        size_t q_pos = min(q1pos, q2pos);
        if (q_pos == string::npos)
            break;		// no more quotes
        char q = text[q_pos];
        size_t end = text.substr(q_pos + 1).find(q);	// find matching quote
        if (end == string::npos)
            break;		// no matching quote

        text.erase(q_pos, 1);
        text.erase(q_pos + 1 + end - 1, 1);
    }
    return text;
}

string str_chomp(string text) {
    while (!text.empty() && is_space(text.back()))
        text.pop_back();
    return text;
}

string str_strip(string text) {
    const char* p = text.c_str();
    while (*p != '\0' && is_space(*p))
        p++;
    text.erase(0, p - text.c_str());
    return str_chomp(text);
}

string str_remove_all_blanks(const string& text) {
    string out;
    for (auto c : text)
        if (!is_space(c))
            out.push_back(c);
    return out;
}

string str_remove_extra_blanks(const string& text) {
    string out;
    for (const char* p = text.c_str(); *p != '\0'; p++) {
        if (!is_space(*p))
            out.push_back(*p);
        else {
            out.push_back(' ');
            while (is_space(p[1]))
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

string str_tolower(string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {return to_lower(c); });
    return str;
}

string str_toupper(string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {return to_upper(c); });
    return str;
}

string str_to_cstr(const string& str) {
    string out = "\"";
    for (auto c : str) {
        switch (c) {
        case '\a': out += "\\a"; break;
        case '\b': out += "\\b"; break;
        case '\f': out += "\\f"; break;
        case '\n': out += "\\n"; break;
        case '\r': out += "\\r"; break;
        case '\t': out += "\\t"; break;
        case '\v': out += "\\v"; break;
        case '\\': out += "\\\\"; break;
        case '"': out += "\\\""; break;
        default:
            if (c >= 0x20 && c < 0x7f)
                out.push_back(c);
            else if ((c & 0xff) < 8)
                out += "\\" + to_string(c);			// \o
            else {
                std::ostringstream ss;
                ss << "\\x"
                    << std::setfill('0') << std::setw(2)
                    << std::hex << static_cast<unsigned int>(c & 0xff) << std::dec;
                out += ss.str();
            }
        }
    }
    out += "\"";
    return out;
}

// https://stackoverflow.com/questions/874134/find-out-if-string-ends-with-another-string-in-c
bool str_ends_with(const string& str, const string& ending) {
    if (str.length() >= ending.length())
        return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
    else
        return false;
}

// https://www.bing.com/search?q=c%2B%2B+split+blank+delimited+string+into+vector+of+stringsd&showconv=1&sendquery=1&form=WSBQFC&qs=SW&cvid=286798d5917e488fb05cbeda30b71104&pq=c%2B%2B+split+blank+delimited+string+into+vector+of+stringsd&cc=PT&setlang=en-US&nclid=9310176510014EEEAB71B45D62C6D720&ts=1703540528160&wsso=Moderate
vector<string> split(const string& s) {
    istringstream iss(s);
    vector<string> tokens{ istream_iterator<string>{iss},
                           istream_iterator<string>{} };
    return tokens;
}

bool is_little_endian(void) {
    uint32_t endian = 0x12345678;
    if (*(byte_t*)&endian == 0x78)
        return true;
    else
        return false;
}

int parse_le_int32(const byte_t* mem) {
    int value = 0;
    if (is_little_endian()) {
        // little endian architecture
        value = *(int*)mem;
    }
    else {
        // big endian architecture
        value =
            ((mem[0] << 0) & 0x000000FFL) |
            ((mem[1] << 8) & 0x0000FF00L) |
            ((mem[2] << 16) & 0x00FF0000L) |
            ((mem[3] << 24) & 0xFF000000L);
        if (value & 0x80000000L)
            value |= ~0xFFFFFFFFL;		// sign-extend above bit 31
    }
    return value;
}

void write_le_int32(byte_t* mem, int value) {
    if (is_little_endian()) {
        // little endian architecture
        *(int*)mem = value;
    }
    else {
        // big endian architecture
        mem[0] = (value >> 0) & 0x000000FFL;
        mem[1] = (value >> 8) & 0x000000FFL;
        mem[2] = (value >> 16) & 0x000000FFL;
        mem[3] = (value >> 24) & 0x000000FFL;
    }
}

//-----------------------------------------------------------------------------
// Filesystem
//-----------------------------------------------------------------------------

// https://stackoverflow.com/questions/6089231/getting-std-ifstream-to-handle-lf-cr-and-crlf
istream& safe_getline(istream& ifs, string& text) {
    text.clear();

    // The characters in the stream are read one-by-one using a std::streambuf.
    // That is faster than reading them one-by-one using the std::istream.
    // Code that uses streambuf this way must be guarded by a sentry object.
    // The sentry object performs various tasks,
    // such as thread synchronization and updating the stream state.

    istream::sentry se(ifs, true);
    streambuf* sb = ifs.rdbuf();

    for (;;) {
        int c = sb->sbumpc();
        switch (c) {
        case '\n':
            return ifs;
        case '\r':
            if (sb->sgetc() == '\n')
                sb->sbumpc();
            return ifs;
        case streambuf::traits_type::eof():
            // Also handle the case when the last line has no line ending
            if (text.empty())
                ifs.setstate(ios::eofbit);
            return ifs;
        default:
            text += (char)c;
        }
    }
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

void expand_glob(vector<fs::path>& result, const string& pattern) {
    // use set in recursion to eliminate duplicates
    result.clear();
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

//-----------------------------------------------------------------------------
// PoolStr
//-----------------------------------------------------------------------------

std::ostream& operator<<(std::ostream& out, const PoolStr& s) {
    out << s.m_str;
    return out;
}

std::istream& operator>>(std::istream& in, PoolStr& s) {
    string input;
    in >> input;
    s.init(input);
    return in;
}

PoolStr PoolStr::operator+(const string& str) {
    PoolStr result{ string(m_str) + str };
    return result;
}

void PoolStr::init(const string& str) {
    static unordered_set<string> g_pool;
    m_str = g_pool.insert(str).first->c_str();
}

//-----------------------------------------------------------------------------
// String table
//-----------------------------------------------------------------------------

StringTable::StringTable() {
    clear();
}

void StringTable::clear() {
    m_list.clear();
    m_hash.clear();
    size_t id = add_string("");
    xassert(id == 0);
}

size_t StringTable::add_string(const string& str) {
    auto it = m_hash.find(str);
    if (it == m_hash.end()) {
        size_t id = m_list.size();
        m_list.push_back(str);
        m_hash[str] = id;
        return id;
    }
    else
        return it->second;
}

const string& StringTable::lookup(size_t id) {
    xassert(id < count());
    return m_list[id];
}

bool StringTable::find(const string& str) {
    auto it = m_hash.find(str);
    if (it == m_hash.end())
        return false;
    else
        return true;
}
