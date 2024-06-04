//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "xassert.h"
#include <algorithm>
#include <cctype>
#include <cstdint>
#include <iostream>
#include <sstream>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------

bool is_ident_start(char c) {
    return c == '_' || isalpha(c);
}

bool is_ident(char c) {
    return c == '_' || c == '$' || isalnum(c);
}

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

//-----------------------------------------------------------------------------

bool str_begins_with(const string& str, const string& beginning) {
    if (str.length() >= beginning.length())
        return (0 == str.compare(0, beginning.length(), beginning));
    else
    return false;
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

string str_chomp(const string& str_) {
    string str = str_;
    while (!str.empty() && isspace(str.back()))
        str.pop_back();
    return str;
}

string str_strip(const string& str) {
    const char* p = str.c_str();
    while (*p && isspace(*p))
        p++;
    return str_chomp(p);
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

string str_remove_all_blanks(const string& str) {
    string out;
    for (auto c : str)
        if (!isspace(c))
            out.push_back(c);
    return out;
}

string str_replace_all(string text, const string& find, const string& replace) {
    if (text.empty() || find.empty())
        return text;

    size_t p = 0;
    while ((p = text.find(find, p)) != string::npos) {
        text.replace(p, find.length(), replace);
        p += replace.length();
    }
    return text;
}

//-----------------------------------------------------------------------------

int ipow(int base, int exp) {
    if (exp < 0)
        return 0;
    else {
        int result = 1;
        for (;;) {
            if (exp & 1)
                result *= base;
            exp >>= 1;
            if (!exp)
                break;
            base *= base;
        }
        return result;
    }
}

//-----------------------------------------------------------------------------
// string table
//-----------------------------------------------------------------------------

void swrite_int16(int n, ostream& os) {
    char buffer[sizeof(int16_t)];
    buffer[0] = (n >> 0) & 0xff;
    buffer[1] = (n >> 8) & 0xff;
    os.write(buffer, sizeof(buffer));
}

void swrite_int32(int n, ostream& os) {
    char buffer[sizeof(int32_t)];
    buffer[0]=(n >> 0) & 0xff;
    buffer[1]=(n >> 8) & 0xff;
    buffer[2]=(n >> 16) & 0xff;
    buffer[3]=(n >> 24) & 0xff;
    os.write(buffer, sizeof(buffer));
}

void swrite_string(const string& s, ostream& os) {
    xassert(s.size() <= INT16_MAX);
    swrite_int16(static_cast<int>(s.size()), os);
    os.write(s.c_str(), s.size());
}

int sread_int16(istream& is) {
    char buffer[sizeof(int16_t)];
    is.read(buffer, sizeof(buffer));
    xassert(is.gcount() == sizeof(buffer));
    int res = (int)(int16_t)((buffer[0] & 0xff) | ((buffer[1] & 0xff) << 8));
    return res;
}

int sread_int32(istream& is) {
    char buffer[sizeof(int32_t)];
    is.read(buffer, sizeof(buffer));
    xassert(is.gcount() == sizeof(buffer));
    int res = (int)(int32_t)((buffer[0] & 0xff) | ((buffer[1] & 0xff) << 8)
        | ((buffer[2] & 0xff) << 16) | ((buffer[3] & 0xff) << 24));
    return res;
}

string sread_string(istream& is) {
    int len = sread_int16(is);
    string out;
    out.resize(len);
    is.read(&out[0], len);
    xassert(is.gcount() == len);
    return out;
}

StringTable::StringTable() {
    clear();
}

void StringTable::clear() {
    list_.clear();
    hash_.clear();
    int id = add_string("");
    xassert(id == 0);
}

int StringTable::add_string(const string& str) {
    auto it = hash_.find(str);
    if (it == hash_.end()) {
        int id = (int)list_.size();
        list_.push_back(str);
        hash_[str] = id;
        return id;
    }
    else
        return it->second;
}

const string& StringTable::lookup(int id) {
    xassert(id >= 0 && id < static_cast<int>(count()));
    return list_[id];
}

bool StringTable::find(const string& str) {
    auto it = hash_.find(str);
    if (it == hash_.end())
        return false;
    else
        return true;
}

size_t StringTable::count() const {
    return list_.size();
}

streampos StringTable::write(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write size of table and placeholder for size of strings
    swrite_int32((int)count(), os);
    streampos strings_size_fpos = os.tellp();
    swrite_int32(0, os);

    // write index of each string into array of strings concatenated separated by '\0'
    size_t str_table = 0;
    for (size_t id = 0; id < count(); id++) {
        size_t pos = str_table;                 // position of this string in table
        str_table += list_[id].size() + 1;      // next position

        swrite_int32((int)pos, os);             // index into strings
    }

    // write all strings together
    for (size_t id = 0; id < count(); id++) {
        os.write(list_[id].c_str(), list_[id].size() + 1);    // write string including '\0'
    }

    // align to int32 size
    size_t aligned_str_table = ((str_table + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));
    size_t extra_bytes = aligned_str_table - str_table;
    static const char align[sizeof(int32_t)] = { 0 };
    os.write(align, extra_bytes);

    streampos end_fpos = os.tellp();
    os.seekp(strings_size_fpos);
    swrite_int32((int)aligned_str_table, os);
    os.seekp(end_fpos);

    return start_fpos;
}

void StringTable::read(ifstream& is, streampos start_fpos) {
    clear();

    streampos cur_fpos = is.tellg();

    // read count and length of buffer
    if (is.eof())
        is.clear(ios::eofbit);
    is.seekg(start_fpos);
    int count = sread_int32(is);
    int buffer_len = sread_int32(is);

    // read string buffer
    is.seekg(start_fpos + (streampos)((2 + count) * sizeof(uint32_t)));
    string buffer;
    buffer.resize(buffer_len);
    is.read(&buffer[0], buffer_len);
    xassert(is.gcount() == buffer_len);

    // read each string
    is.seekg(start_fpos + (streampos)(2 * sizeof(uint32_t)));
    for (int i = 0; i < count; i++) {
        int pos = sread_int32(is);
        string text(&buffer[pos]);
        int id = add_string(text);
        xassert(id == i);
    }

    // seek to start pos
    is.seekg(cur_fpos);
}
