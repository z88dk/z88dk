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

std::string to_upper(const std::string_view s) {
    std::string result(s);
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::toupper(c));
    });
    return result;
}

std::string to_lower(const std::string_view s) {
    std::string result(s);
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::tolower(c));
    });
    return result;
}

std::string ltrim(const std::string_view s) {
    size_t start = s.find_first_not_of(blanks);
    return std::string((start == std::string::npos) ? "" : s.substr(start));
}

std::string rtrim(const std::string_view s) {
    size_t end = s.find_last_not_of(blanks);
    return std::string((end == std::string::npos) ? "" : s.substr(0, end + 1));
}

std::string trim(const std::string_view s) {
    return ltrim(rtrim(s));
}

std::string int_to_hex(int value) {
    std::ostringstream oss;
    if (abs(value < 10)) {
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
