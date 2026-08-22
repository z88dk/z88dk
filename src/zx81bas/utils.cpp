//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "utils.h"
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

bool str_ends_with(const std::string& str, const std::string& ending) {
    if (str.length() >= ending.length()) {
        return (0 == str.compare(str.length() - ending.length(), ending.length(),
                                 ending));
    }
    else {
        return false;
    }
}

