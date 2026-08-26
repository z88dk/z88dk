//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "utils.h"
#include "zx81chars.h"
#include <algorithm>
#include <cctype>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <string>
#include <unordered_map>
#include <vector>

// lookup zx81 character code
bool encode_zx81_char(const char*& p, bool check_keywords,
                      uint8_t& out_code,
                      const SourceLoc& loc) {
    static std::vector<std::unordered_map<std::string, uint8_t>> zx81_char_map =
    []() {
        std::vector<std::unordered_map<std::string, uint8_t>> map;
#define X(str, code) \
            { size_t len = strlen(str); \
              while (map.size() <= len) { map.emplace_back(); } \
              map[len][str] = code; }
#include "zx81chars.def"
#undef X
        return map;
    }
    ();

    // check hexadecimal escape sequence first
    if (*p == '\\' && isxdigit(p[1]) && isxdigit(p[2])) {
        char hex_str[3] = { p[1], p[2], '\0' };
        out_code = static_cast<uint8_t>(std::strtoul(hex_str, nullptr, 16));
        p += 3;
        return true;
    }

    // compute the maximum length of the token to check
    size_t check_size = std::min(strlen(p), zx81_char_map.size() - 1);
    if (!check_keywords && isalpha(*p)) {
        check_size = 1; // only check single-character tokens for identifiers
    }

    // check for multi-character tokens first
    for (size_t len = check_size; len >= 1; --len) {
        std::string check_str(p, len);
        check_str = str_toupper(check_str);
        auto it = zx81_char_map[len].find(check_str);
        if (it != zx81_char_map[len].end()) {
            p += len;
            out_code = it->second;
            return true;
        }
    }

    // character not found
    error(loc, "Unknown ZX81 encoding: \"" +
          std::string(p, strlen(p)) + "\"");
    return false;
}

bool encode_zx81_string(const char*& p, char delimiter,
                        std::vector<uint8_t>& bytes,
                        const SourceLoc& loc) {
    while (*p && *p != delimiter) {
        uint8_t code;
        if (encode_zx81_char(p, /*check_keywords=*/false, code, loc)) {
            bytes.push_back(code);
        }
        else {
            return false; // return false on error
        }
    }

    if (*p != delimiter) {
        error(loc, "Unterminated string literal");
        return false;
    }

    return true;
}
