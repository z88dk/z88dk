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

bool parse_int_from_chars(const std::string& s, int base, int& out) {
    std::string t = s;
    if (t.size() >= 2 && t[0] == '0' &&
            (t[1] == 'x' || t[1] == 'X')) {
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
