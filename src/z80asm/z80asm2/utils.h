//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

typedef uint8_t byte_t;
typedef uint16_t word_t;
typedef uint32_t dword_t;
typedef unsigned int uint_t;

// number of elements of array
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))

// convert argument to string
#define TOSTR(x)	_TOSTR(x)
#define _TOSTR(x)	#x

bool is_ident_start(char c);
bool is_ident(char c);
bool is_ident(const string& ident);
int char_digit(char c);

bool str_begins_with(const string& str, const string& beginning);
bool str_ends_with(const string& str, const string& ending);
string str_tolower(string str);
string str_toupper(string str);
string str_chomp(const string& str);
string str_strip(const string& str);
string str_remove_extra_blanks(const string& str);
string str_remove_all_blanks(const string& str);
string str_replace_all(string text, const string& find, const string& replace);

int ipow(int base, int exp);

// convert int to hex
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

//-----------------------------------------------------------------------------
// string table
//-----------------------------------------------------------------------------

// read/write binary data from/to streams
void swrite_int16(int n, ostream& os);
void swrite_int32(int n, ostream& os);
void swrite_string(const string& s, ostream& os);

int sread_int16(istream& is);
int sread_int32(istream& is);
string sread_string(istream& is);

int sread_int32(const byte_t* mem);

class StringTable {
public:
    StringTable();
    void clear();

    int add_string(const string& str);
    const string& lookup(int id);
    bool find(const string& str);
    size_t count() const;
    streampos write(ofstream& os);
    void read(ifstream& is, streampos start_fpos);
    void parse(const byte_t* mem);

private:
    vector<string> list_;
    unordered_map<string, int> hash_;
};
