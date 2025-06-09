//-----------------------------------------------------------------------------
// z80asm
// Utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
using namespace std;

string str_to_lower(string input) {
    std::transform(input.begin(), input.end(), input.begin(),
        [](unsigned char c) { return std::tolower(c); });
    return input;
}

bool str_ends_with(const string& str, const string& ending) {
    if (str.length() >= ending.length())
        return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
    else
        return false;
}

string binary_to_c_string(const unsigned char* data, size_t length) {
    ostringstream out;
    out << '"';  // Start of C string literal

    for (size_t i = 0; i < length; ++i) {
        unsigned char c = data[i];

        switch (c) {
        case '\n': out << "\\n"; break;
        case '\r': out << "\\r"; break;
        case '\t': out << "\\t"; break;
        case '\v': out << "\\v"; break;
        case '\b': out << "\\b"; break;
        case '\f': out << "\\f"; break;
        case '\a': out << "\\a"; break;
        case '\\': out << "\\\\"; break;
        case '\"': out << "\\\""; break;
        default:
            if (isprint(c)) {
                out << c;
            }
            else {
                out << "\\x"
                    << hex << setw(2) << setfill('0')
                    << static_cast<int>(c);
            }
        }
    }

    out << '"';  // End of C string literal
    return out.str();
}

bool is_ident(char c) {
    return c == '_' || isalnum(c);
}

bool read_custom_line(ifstream& stream, string& line) {
    line.clear();
    char ch;
    while (stream.get(ch)) {
        if (ch == '\n') {
            // Unix-style \n or part of \r\n (Windows)
            break;
        }
        else if (ch == '\r') {
            // Could be Mac-style \r or Windows-style \r\n
            if (stream.peek() == '\n') {
                stream.get(); // consume the \n
            }
            break;
        }
        else {
            line += ch;
        }
    }
    return !line.empty() || !stream.eof();
}

int ipow(int base, int exp) {
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

string sanitize_pathname(string path) {
    std::replace(path.begin(), path.end(), '\\', '/');
    return path;
}
