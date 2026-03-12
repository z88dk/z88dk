//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <filesystem>
#include <unordered_set>

const char* strpool(const std::string& str) {
    static std::unordered_set<std::string> pool;
    auto [it, _] = pool.insert(str);
    return it->c_str();
}

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

bool str_ends_with(const std::string& str, const std::string& ending) {
    if (ending.length() > str.length()) {
        return false;
    }

    // empty ending matches anything
    if (ending.empty()) {
        return true;
    }

    return str.compare(str.length() - ending.length(),
                       ending.length(), ending) == 0;
}

bool str_starts_with(const std::string& str, const std::string& beginning) {
    if (beginning.size() > str.size()) {
        return false;
    }

    // empty beginning matches anything
    if (beginning.empty()) {
        return true;
    }

    return str.compare(0, beginning.size(), beginning) == 0;
}

// On Linux, lexically_normal() does not regard backslashes as path separators
static std::string nomalize_slashes(const std::string& path) {
    std::string result;
    result.reserve(path.size());
    for (auto c : path) {
        if (c == '\\') {
            result.push_back('/');
        }
        else {
            result.push_back(c);
        }
    }
    return result;
}

std::string normalize_path(const std::string& path_) {
    std::string path = nomalize_slashes(path_);

    if (path.empty()) {
        return ".";
    }

    // Preserve UNC prefix: if original path starts with // or \\,
    // ensure the normalized result also starts with a double slash.
    const bool had_unc_prefix = str_starts_with(path, "//");

    try {
        std::filesystem::path p(path);
        std::string result = p.lexically_normal().generic_string();

        if (had_unc_prefix) {
            // If normalization collapsed the leading // to / (or removed it),
            // put it back so UNC paths are preserved consistently across platforms.
            if (!str_starts_with(result, "//")) {
                if (str_starts_with(result, "/")) {
                    result = "/" + result;  // make it begin with "//"
                }
                else {
                    result = "//" + result; // add full UNC prefix if missing
                }
            }
        }
        return result;
    }
    catch (...) {
        return path;
    }
}

std::string parent_dir(const std::string& path) {
    try {
        std::filesystem::path p(nomalize_slashes(path));
        return p.parent_path().generic_string();
    }
    catch (...) {
        return std::string();
    }
}

