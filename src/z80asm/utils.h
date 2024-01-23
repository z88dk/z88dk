//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
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

typedef uint8_t byte_t;
typedef uint16_t word_t;
typedef uint32_t dword_t;
typedef unsigned int uint_t;

// number of elements of array
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))

// character classification
// ctype.h on MSVC asserts that character is in range -1 to 255; this fails for signed chars
inline bool is_alnum(char c) { return c > 0 && isalnum(c); }
inline bool is_alpha(char c) { return c > 0 && isalpha(c); }
inline bool is_lower(char c) { return c > 0 && islower(c); }
inline bool is_upper(char c) { return c > 0 && isupper(c); }
inline bool is_digit(char c) { return c > 0 && isdigit(c); }
inline bool is_xdigit(char c) { return c > 0 && isxdigit(c); }
inline bool is_cntrl(char c) { return c > 0 && iscntrl(c); }
inline bool is_graph(char c) { return c > 0 && isgraph(c); }
inline bool is_print(char c) { return c > 0 && isprint(c); }
inline bool is_punct(char c) { return c > 0 && ispunct(c); }
inline bool is_space(char c) { return c > 0 && isspace(c); }
inline bool is_blank(char c) { return c > 0 && isblank(c); }
inline bool is_eol(char c) { return c == '\r' || c == '\n'; }

inline bool is_ident_start(char c) { return c == '_' || is_alpha(c); }
inline bool is_ident(char c) { return c == '_' || c == '$' || is_alnum(c); }

inline char to_lower(char c) { return c > 0 ? tolower(c) : c; }
inline char to_upper(char c) { return c > 0 ? toupper(c) : c; }

bool is_ident(const string& ident);

// convert int to hex
// https://stackoverflow.com/questions/5100718/integer-to-hex-string-in-c
template<typename T>
string int_to_hex(T i, int width) {
    std::ostringstream ss;
    if (i <= -10)
        ss << "-$"
        << std::setfill('0') << std::setw(width)
        << std::hex << -i << std::dec;
    else if (i < 10)
        ss << i;
    else
        ss << "$"
        << std::setfill('0') << std::setw(width)
        << std::hex << i << std::dec;
    return ss.str();
}

// string manipulation
string expand_env_vars(string text);
string unquote(string text);
string str_chomp(string text);
string str_strip(string text);
string str_remove_all_blanks(const string& text);
string str_remove_extra_blanks(const string& text);
string str_replace_all(string text, const string& find, const string& replace);
string str_tolower(string str);
string str_toupper(string str);
string str_to_cstr(const string& str);
bool str_ends_with(const string& str, const string& ending);
vector<string> split(const string& s);

// convert between file-representation (little-endian) to internal representation
bool is_little_endian(void);
int  parse_le_int32(const byte_t* mem);
void write_le_int32(byte_t* mem, int value);

// filsystem
istream& safe_getline(istream& ifs, string& text);
void expand_glob(vector<fs::path>& result, const string& pattern);

// pooled string - const char* to a constant string pool
class PoolStr {
public:
    PoolStr(const string& str = "") { init(str); }
    PoolStr(const PoolStr& other) { m_str = other.m_str; }
    PoolStr& operator=(const string& str) { init(str); return *this; }
    PoolStr& operator=(const PoolStr& other) { m_str = other.m_str; return *this; }

    void clear() { init(""); }
    bool empty() const { return m_str[0] == '\0'; }

    PoolStr operator+(const string& str);

    bool operator==(const PoolStr& rhs) const { return m_str == rhs.m_str; }
    bool operator!=(const PoolStr& rhs) const { return m_str != rhs.m_str; }

    const char* c_str() const { return m_str; }
    operator string() const { return string(m_str); }

    friend std::ostream& operator<<(std::ostream& out, const PoolStr& s);
    friend std::istream& operator>>(std::istream& in, PoolStr& s);

private:
    const char* m_str;

    void init(const string& str = "");
};

// string table for object files
class StringTable {
public:
    StringTable();
    void clear();

    size_t add_string(const string& str);
    const string& lookup(size_t id);
    bool find(const string& str);
    size_t count() const { return static_cast<size_t>(m_list.size()); }

private:
    vector<string> m_list;
    unordered_map<string, size_t> m_hash;
};

