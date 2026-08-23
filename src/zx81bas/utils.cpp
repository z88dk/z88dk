//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "utils.h"
#include <algorithm>
#include <cctype>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

void remove_file(const std::string& filename) {
    if (std::remove(filename.c_str()) != 0) {
        error("Failed to remove temporary file " + filename);
    }
}

// replace backslashes with forward slashes, and remove duplicate slashes
std::string normalize_path(const std::string& path) {
    std::string output;
    output.reserve(path.size());
    for (size_t i = 0; i < path.size(); ++i) {
        char c = path[i];
        if (c == '\\') {
            c = '/';
        }

        if (c == '/' && !output.empty() && output.back() == '/') {
            // skip duplicate slashes
            continue;
        }
        else {
            output += c;
        }
    }
    return output;
}

#ifdef _DEBUG
void cat_file(const std::string& filename) {
    std::ifstream file(filename);
    if (!file) {
        error("Failed to open file: " + filename);
        return;
    }
    std::string text;
    std::cout << "Contents of " << filename << ":" << std::endl;
    while (std::getline(file, text)) {
        std::cout << text << std::endl;
    }
}
#endif

bool str_ends_with(const std::string& str, const std::string& ending) {
    if (str.length() >= ending.length()) {
        return (0 == str.compare(str.length() - ending.length(), ending.length(),
                                 ending));
    }
    else {
        return false;
    }
}

std::string str_tolower(std::string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {
        return std::tolower(c);
    });
    return str;
}

std::string str_toupper(std::string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {
        return std::toupper(c);
    });
    return str;
}

std::string int_to_hex(uint8_t value) {
    std::ostringstream oss;
    oss << "0x" << std::uppercase << std::hex
        << std::setfill('0') << std::setw(2)
        << static_cast<unsigned>(value);
    return oss.str();
}

