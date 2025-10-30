//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <cctype>
#include <charconv>
#include <fstream>
#include <stdexcept>
#include <string>
#include <sstream>
#include <iomanip>

std::string to_upper(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::toupper(c));
    });
    return result;
}

std::string to_lower(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::tolower(c));
    });
    return result;
}

std::string ltrim(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\r\n");
    return (start == std::string::npos) ? "" : s.substr(start);
}

std::string rtrim(const std::string& s) {
    size_t end = s.find_last_not_of(" \t\r\n");
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}

std::string trim(const std::string& s) {
    return ltrim(rtrim(s));
}

bool str_ends_with(const std::string& str, const std::string& ending) {
    if (str.length() >= ending.length())
        return (0 == str.compare(
                    str.length() - ending.length(),
                    ending.length(),
                    ending));
    else {
        return false;
    }
}

std::string escape_string(const std::string& s) {
    // Convert a raw string to a C-style escaped representation suitable for
    // emitting as a quoted string token. Behavior mirrors str_expand_escapes:
    // - common control characters are escaped (\a, \b, \f, \n, \r, \t, \v)
    // - backslash and double-quote are escaped
    // - printable ASCII (0x20..0x7e) are left as-is
    // - other bytes are emitted as "\xHH"
    std::string out;
    out.reserve(s.size() + 8); // small reservation to reduce reallocs

    for (unsigned char uc : s) {
        switch (uc) {
        case '\a':
            out += "\\a";
            break;
        case '\b':
            out += "\\b";
            break;
        case '\f':
            out += "\\f";
            break;
        case '\n':
            out += "\\n";
            break;
        case '\r':
            out += "\\r";
            break;
        case '\t':
            out += "\\t";
            break;
        case '\v':
            out += "\\v";
            break;
        case '\\':
            out += "\\\\";
            break;
        case '"':
            out += "\\\"";
            break;
        default:
            if (uc >= 0x20 && uc < 0x7f) {
                out.push_back(static_cast<char>(uc));
            }
            else {
                std::ostringstream ss;
                ss << "\\x"
                   << std::hex << std::uppercase << std::setw(2) << std::setfill('0')
                   << (static_cast<int>(uc) & 0xFF)
                   << std::dec;
                out += ss.str();
            }
        }
    }

    return out;
}

std::string read_file_to_string(const std::string& filename) {
    std::ifstream file(filename, std::ios::in | std::ios::binary);
    if (!file) {
        throw std::runtime_error("Failed to open file: " + filename);
    }

    file.seekg(0, std::ios::end);
    size_t size = file.tellg();
    std::string content(size, '\0');
    file.seekg(0);
    file.read(&content[0], size);

    if (!file) {
        throw std::runtime_error("Error reading file: " + filename);
    }

    return content;
}

void write_string_to_file(const std::string& filename,
                          const std::string& content) {
    std::ofstream file(filename, std::ios::out | std::ios::binary);
    if (!file) {
        throw std::runtime_error("Failed to open file for writing: " + filename);
    }

    file.write(content.data(),
               static_cast<std::streamsize>(content.size()));
    if (!file) {
        throw std::runtime_error("Error writing file: " + filename);
    }
}

static std::string remove_underscores(const std::string& s) {
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }
    return t;
}

bool parse_int_from_chars(const std::string& s, int base, int& out) {
    // Copy input and remove all underscore separators
    std::string t = trim(remove_underscores(s));

    // Handle 0x/0X hexadecimal prefix
    if (t.size() >= 2 && t[0] == '0' && (t[1] == 'x' || t[1] == 'X')) {
        t.erase(0, 2);
        base = 16;
    }

    int value = 0;
    auto res = std::from_chars(t.data(), t.data() + t.size(), value, base);
    if (res.ec != std::errc()) {
        return false;    // parse error or out_of_range
    }
    if (res.ptr != t.data() + t.size()) {
        return false;    // trailing chars
    }
    out = value;
    return true;
}

bool parse_float_from_chars(const std::string& s, double& out) {
    // Copy input and remove all underscore separators
    std::string t = trim(remove_underscores(s));
    if (t.empty()) {
        return false;
    }

    size_t pos = 0;
    try {
        double v = std::stod(t, &pos);
        // Reject if stod didn't consume the whole string (e.g., "1.23foo")
        if (pos != t.size()) {
            return false;
        }
        out = v;
        return true;
    }
    catch (const std::invalid_argument&) {
        // No conversion could be performed (e.g., ".", "e10", "1.e+")
        return false;
    }
    catch (const std::out_of_range&) {
        // Value out of range for double
        return false;
    }
}
