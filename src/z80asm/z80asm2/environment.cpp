//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "string_utils.h"
#include <algorithm>
#include <cstdlib>
#include <filesystem>
#include <iomanip>
#include <sstream>

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

