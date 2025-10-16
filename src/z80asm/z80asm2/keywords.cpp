//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "keywords.h"
#include <algorithm>
#include <unordered_map>

#define X(id, text, flags) { text, Keyword::id },
Keyword to_keyword(const std::string& s) {
    static const std::unordered_map<std::string, Keyword> keyword_map = {
#include "keywords.def"
    };
    auto it = keyword_map.find(to_upper(s));
    return it != keyword_map.end() ? it->second : Keyword::None;
}
#undef X

#define X(id, text, flags) flags,
static const int keyword_flags[] = {
    0,
#include "keywords.def"
};
#undef X

bool keyword_is_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_DIRECTIVE) != 0;
}

bool keyword_is_name_directive(Keyword kw) {
    int flags = keyword_flags[static_cast<int>(kw)];
    return (flags & IS_NAME_DIRECTIVE) != 0;
}

std::string to_upper(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
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

