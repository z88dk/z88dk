//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "string_utils.h"
#include <algorithm>
#include <cctype>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

static constexpr std::string_view blanks = " \t\r\n\v\f";

std::string to_lower(std::string_view s) {
    std::string result(s);
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::tolower(c));
    });
    return result;
}

std::string to_upper(std::string_view s) {
    std::string result(s);
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::toupper(c));
    });
    return result;
}

static std::string ltrim(std::string_view s) {
    size_t start = s.find_first_not_of(blanks);
    return std::string((start == std::string::npos) ? "" : s.substr(start));
}

static std::string rtrim(std::string_view s) {
    size_t end = s.find_last_not_of(blanks);
    return std::string((end == std::string::npos) ? "" : s.substr(0, end + 1));
}

std::string trim(std::string_view s) {
    return ltrim(rtrim(s));
}

std::string escape_string(std::string_view s) {
    std::string result;
    result.reserve(s.size() + 2);
    result.push_back('"');
    for (unsigned char c : s) {
        switch (c) {
        case '\\':
            result += "\\\\";
            break;
        case '"':
            result += "\\\"";
            break;
        case '\a':
            result += "\\a";
            break;
        case '\b':
            result += "\\b";
            break;
        case '\f':
            result += "\\f";
            break;
        case '\n':
            result += "\\n";
            break;
        case '\r':
            result += "\\r";
            break;
        case '\t':
            result += "\\t";
            break;
        case '\v':
            result += "\\v";
            break;
        case '\0':
            result += "\\x00";
            break;
        default:
            if (c >= 0x20 && c < 0x7F) {
                result.push_back(static_cast<char>(c));
            }
            else {
                // non-printable: emit \xHH
                static constexpr char hex_digits[] = "0123456789ABCDEF";
                result += "\\x";
                result.push_back(hex_digits[(c >> 4) & 0x0F]);
                result.push_back(hex_digits[c & 0x0F]);
            }
            break;
        }
    }
    result.push_back('"');
    return result;
}

std::string int_to_hex(int value) {
    std::ostringstream oss;
    if (abs(value) < 10) {
        oss << value;
    }
    else if (value < 0) {
        oss << "-$" << std::hex << std::setw(2) << std::setfill('0')
            << std::uppercase << (-value);
    }
    else {
        oss << "$" << std::hex << std::setw(2) << std::setfill('0')
            << std::uppercase << value;
    }
    return oss.str();
}
