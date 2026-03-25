//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <filesystem>
#include <iomanip>
#include <sstream>
#include <cstdlib>
#include <malloc.h>
#include "string_utils.h"

// On Linux, lexically_normal() does not regard backslashes as path separators
static std::string nomalize_slashes(const std::string_view path) {
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

std::string escape_string(const std::string_view s) {
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

std::string normalize_path(const std::string_view path_) {
    std::string path = nomalize_slashes(path_);

    if (path.empty()) {
        return ".";
    }

    // Preserve UNC prefix: if original path starts with // or \\,
    // ensure the normalized result also starts with a double slash.
    const bool had_unc_prefix = starts_with(path, "//");

    try {
        std::filesystem::path p(path);
        std::string result = p.lexically_normal().generic_string();

        if (had_unc_prefix) {
            // If normalization collapsed the leading // to / (or removed it),
            // put it back so UNC paths are preserved consistently across platforms.
            if (!starts_with(result, "//")) {
                if (starts_with(result, "/")) {
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

std::string parent_dir(const std::string_view path) {
    try {
        std::filesystem::path p(nomalize_slashes(path));
        return p.parent_path().generic_string();
    }
    catch (...) {
        return std::string();
    }
}

std::string replace_extension(const std::string_view filename, const std::string_view extension) {
    try {
        std::filesystem::path p(filename);
        p.replace_extension(extension);
        return normalize_path(p.lexically_normal().generic_string());
    }
    catch (...) {
        return normalize_path(std::string(filename) + std::string(extension));
    }
}

std::string prepend_output_dir(const std::string_view filename,
                               const std::string_view output_dir_) {
    namespace fs = std::filesystem;

    std::string output_dir(output_dir_);

    if (output_dir.empty()) {
        return normalize_path(filename);
    }
    else if (filename.substr(0, output_dir.size() + 1) == output_dir + "/") {
        // #2260: may be called with an object file already with
        // the path prepended; do not add it twice
        return normalize_path(filename);
    }
    else {
        // NOTE: concatenation (/) of a relative fs::path and an
        // absolute fs::path discards the first one! Do our magic
        // with strings instead.

        // is it a win32 absolute path?
        std::string file;
        if (filename.size() >= 2 && is_alpha(filename[0]) && filename[1] == ':') {	// C:
            file += output_dir + "/";
            file += std::string(1, filename[0]) + "/";
            file += std::string(filename.substr(2));
        }
        else {
            file += output_dir + "/";
            file += filename;
        }
        fs::path path{ file };
        return normalize_path(path.lexically_normal().generic_string());
    }
}

// Helper: get environment variable value in a secure, cross-platform way.
// Returns empty string if the variable is not set.
std::string get_env_value(const std::string_view name_) {
    std::string name(name_);
#ifdef _MSC_VER
    char* buf = nullptr;
    size_t sz = 0;
    if (_dupenv_s(&buf, &sz, name.c_str()) != 0 || buf == nullptr) {
        return std::string();
    }
    std::string value(buf);
    free(buf);
    return value;
#else
    const char* v = std::getenv(name.c_str());
    return v ? std::string(v) : std::string();
#endif
}

// Expand environment variables of the form ${VAR}. Supports nesting such as ${var${param}}.
// Unset variables expand to the empty string. Recursively expands until no patterns remain.
std::string expand_env_vars(const std::string_view text) {
    const size_t RUNAWAY_GUARD = 1000; // prevent infinite loops
    std::string s(text);

    // Limit iterations to avoid infinite loops if values reintroduce placeholders cyclically.
    size_t guard = 0;
    while (true) {
        size_t start = s.find("${");
        if (start == std::string::npos) {
            break;
        }

        // Find matching closing brace for this ${ ... }, supporting nested ${...} inside.
        size_t level = 1;
        size_t i = start + 2;
        size_t end = std::string::npos;

        while (i < s.size()) {
            if (s[i] == '$' && i + 1 < s.size() && s[i + 1] == '{') {
                level++;
                i += 2;
                continue;
            }
            if (s[i] == '}') {
                level--;
                if (level == 0) {
                    end = i;
                    break;
                }
            }
            i++;
        }

        if (end == std::string::npos) {
            // Unbalanced pattern; stop processing to avoid infinite loop.
            break;
        }

        // Extract inner name and recursively expand it to support nested names.
        std::string inner = s.substr(start + 2, end - (start + 2));
        std::string var_name = expand_env_vars(inner);

        // Secure env fetch (avoids MSVC C4996 warning for getenv)
        std::string value = get_env_value(var_name);

        // Replace the pattern with the environment value.
        s = s.substr(0, start) + value + s.substr(end + 1);

        if (++guard > RUNAWAY_GUARD) {
            // Safety guard to prevent runaway expansion.
            break;
        }
    }

    return s;
}

