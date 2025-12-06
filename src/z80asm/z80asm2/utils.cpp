//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <cctype>
#include <charconv>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>
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

std::string escape_c_string(const std::string& s) {
    // Convert a raw string to a C-style escaped representation suitable for
    // emitting as a quoted string token. Behavior mirrors str_expand_escapes:
    // - common control characters are escaped (\a, \b, \f, \n, \r, \t, \v)
    // - backslash and double-quote are escaped
    // - printable ASCII (0x20..0x7e) are left as-is
    // - other bytes are emitted as "\xHH"
    std::string out;
    out.reserve(s.size() + 8); // small reservation to reduce reallocs

    for (unsigned char uc : s) {
        switch (uc) {
        case '\a':
            out += "\\a";
            break;
        case '\b':
            out += "\\b";
            break;
        case '\f':
            out += "\\f";
            break;
        case '\n':
            out += "\\n";
            break;
        case '\r':
            out += "\\r";
            break;
        case '\t':
            out += "\\t";
            break;
        case '\v':
            out += "\\v";
            break;
        case '\\':
            out += "\\\\";
            break;
        case '"':
            out += "\\\"";
            break;
        default:
            if (uc >= 0x20 && uc < 0x7f) {
                out.push_back(static_cast<char>(uc));
            }
            else {
                std::ostringstream ss;
                ss << "\\x"
                   << std::hex << std::uppercase << std::setw(2) << std::setfill('0')
                   << (static_cast<int>(uc) & 0xFF)
                   << std::dec;
                out += ss.str();
            }
        }
    }

    return out;
}

std::string read_file_to_string(const std::string& filename) {
    std::ifstream file(filename, std::ios::in | std::ios::binary);
    if (!file) {
        throw std::runtime_error("Failed to open file: " + filename);
    }

    file.seekg(0, std::ios::end);
    size_t size = static_cast<size_t>(file.tellg());
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

std::vector<unsigned char> read_file_to_bytes(const std::string& filename) {
    std::ifstream file(filename, std::ios::in | std::ios::binary);
    if (!file) {
        throw std::runtime_error("Failed to open file: " + filename);
    }

    file.seekg(0, std::ios::end);
    std::streamsize size = file.tellg();
    if (size < 0) {
        throw std::runtime_error("Error determining file size: " + filename);
    }

    std::vector<unsigned char> bytes(static_cast<size_t>(size));
    file.seekg(0, std::ios::beg);

    if (size > 0) {
        file.read(reinterpret_cast<char*>(bytes.data()), size);
        if (!file) {
            throw std::runtime_error("Error reading file: " + filename);
        }
    }

    return bytes;
}

void write_bytes_to_file(const std::string& filename,
                         const std::vector<unsigned char>& bytes) {
    std::ofstream file(filename,
                       std::ios::out | std::ios::binary | std::ios::trunc);
    if (!file) {
        throw std::runtime_error("Failed to open file for writing: " + filename);
    }

    if (!bytes.empty()) {
        file.write(reinterpret_cast<const char*>(bytes.data()),
                   static_cast<std::streamsize>(bytes.size()));
        if (!file) {
            throw std::runtime_error("Error writing file: " + filename);
        }
    }

    file.close();
    if (!file) {
        throw std::runtime_error("Error finalizing file: " + filename);
    }
}

bool file_exists(const std::string& filename) {
    if (filename.empty()) {
        return false;
    }

    std::error_code ec;
    auto status = std::filesystem::status(filename, ec);

    if (ec) {
        return false;
    }

    // Return true only for regular files, false for directories or other types
    return std::filesystem::is_regular_file(status);
}

size_t get_file_size(const std::string& filename) {
    if (filename.empty()) {
        return static_cast<size_t>(-1);
    }

    std::error_code ec;

    // First check if it's a regular file (not a directory)
    auto status = std::filesystem::status(filename, ec);
    if (ec || !std::filesystem::is_regular_file(status)) {
        return static_cast<size_t>(-1);
    }

    // Now get the file size (we know it's a regular file)
    auto size = std::filesystem::file_size(filename, ec);

    if (ec) {
        return static_cast<size_t>(-1);
    }

    return static_cast<size_t>(size);
}

static std::string remove_underscores(const std::string& s) {
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }
    return t;
}

std::string unescape_c_string(const std::string& s) {
    // Reverse of escape_c_string:
    // - supports: \a \b \f \n \r \t \v \\ \" \'
    // - supports: \xHH (1-2 hex digits; escape_c_string emits 2)
    // - supports: \NNN (1-3 octal digits)
    // - supports: \e (ESC, 27) for compatibility with lexer
    // - unknown escapes decode to the escaped character (e.g., \z -> 'z')
    // Accepts optional surrounding single or double quotes.
    auto hex_val = [](char c) -> int {
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'a' && c <= 'f') {
            return 10 + (c - 'a');
        }
        if (c >= 'A' && c <= 'F') {
            return 10 + (c - 'A');
        }
        return -1;
    };

    std::string out;
    if (s.empty()) {
        return out;
    }

    size_t start = 0;
    size_t end = s.size();

    // Strip matching surrounding quotes if present
    if (end >= 2 && ((s.front() == '"' && s.back() == '"') ||
                     (s.front() == '\'' && s.back() == '\''))) {
        start = 1;
        end -= 1;
        if (end <= start) {
            return out;
        }
    }

    out.reserve(end - start);

    for (size_t i = start; i < end; ++i) {
        char c = s[i];
        if (c != '\\') {
            out.push_back(c);
            continue;
        }

        // Backslash at end -> keep it literal
        if (i + 1 >= end) {
            out.push_back('\\');
            break;
        }

        char e = s[++i];
        switch (e) {
        case 'a':
            out.push_back('\a');
            break;
        case 'b':
            out.push_back('\b');
            break;
        case 'f':
            out.push_back('\f');
            break;
        case 'n':
            out.push_back('\n');
            break;
        case 'r':
            out.push_back('\r');
            break;
        case 't':
            out.push_back('\t');
            break;
        case 'v':
            out.push_back('\v');
            break;
        case '\\':
            out.push_back('\\');
            break;
        case '"':
            out.push_back('"');
            break;
        case '\'':
            out.push_back('\'');
            break;
        case 'e':
            out.push_back(static_cast<char>(27));
            break; // ESC (compat)
        case 'x':
        case 'X': {
            // Parse up to 2 hex digits
            int value = 0;
            int digits = 0;
            size_t j = i + 1;
            while (j < end && digits < 2) {
                int hv = hex_val(s[j]);
                if (hv < 0) {
                    break;
                }
                value = (value << 4) | hv;
                ++j;
                ++digits;
            }
            if (digits > 0) {
                out.push_back(static_cast<char>(value & 0xFF));
                i = j - 1;
            }
            else {
                // No hex digits after \x -> treat as literal 'x'
                out.push_back('x');
            }
            break;
        }
        default:
            if (e >= '0' && e <= '7') {
                // Octal: up to 3 digits including the one we already consumed
                int value = e - '0';
                int digits = 1;
                size_t j = i + 1;
                while (j < end && digits < 3 && s[j] >= '0' && s[j] <= '7') {
                    value = (value << 3) + (s[j] - '0');
                    ++j;
                    ++digits;
                }
                out.push_back(static_cast<char>(value & 0xFF));
                i = j - 1;
            }
            else {
                // Unknown escape -> decode as the escaped character
                out.push_back(e);
            }
            break;
        }
    }

    return out;
}

bool parse_int_from_chars(const std::string& s, int base, int& out) {
    // Copy input and remove all underscore separators
    std::string t = trim(remove_underscores(s));

    // Handle 0x/0X hexadecimal prefix
    if (t.size() >= 2 && t[0] == '0' && (t[1] == 'x' || t[1] == 'X')) {
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

bool parse_float_from_chars(const std::string& s, double& out) {
    // Copy input and remove all underscore separators
    std::string t = trim(remove_underscores(s));
    if (t.empty()) {
        return false;
    }

    size_t pos = 0;
    try {
        double v = std::stod(t, &pos);
        // Reject if stod didn't consume the whole string (e.g., "1.23foo")
        if (pos != t.size()) {
            return false;
        }
        out = v;
        return true;
    }
    catch (const std::invalid_argument&) {
        // No conversion could be performed (e.g., ".", "e10", "1.e+")
        return false;
    }
    catch (const std::out_of_range&) {
        // Value out of range for double
        return false;
    }
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

std::string absolute_path(const std::string& path) {
    try {
        std::filesystem::path p(nomalize_slashes(path));
        p = std::filesystem::absolute(p);

        // Convert to string with forward slashes for platform independence
        std::string result = p.lexically_normal().generic_string();

        // absolute path ends in / if the result is a directory
        // Remove trailing slash unless it's the root "/"
        if (result.length() > 1 && result.back() == '/') {
            result.pop_back();
        }

        return result;
    }
    catch (const std::filesystem::filesystem_error& e) {
        throw std::runtime_error("Error resolving absolute path: " +
                                 std::string(e.what()));
    }
}

std::vector<std::string> split_lines(const std::string& text) {
    std::vector<std::string> lines;
    const char* p = text.c_str();
    while (*p) {
        const char* line_start = p;
        while (*p && *p != '\r' && *p != '\n') {
            ++p;
        }
        lines.emplace_back(line_start, p - line_start);
        // Handle line endings
        if (*p == '\r') {
            ++p;
            if (*p == '\n') {
                ++p;
            }
        }
        else if (*p == '\n') {
            ++p;
        }
    }
    return lines;
}

// Helper: get environment variable value in a secure, cross-platform way.
// Returns empty string if the variable is not set.
std::string get_env_value(const std::string& name) {
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
std::string expand_env_vars(const std::string& text) {
    const size_t RUNAWAY_GUARD = 1000; // prevent infinite loops
    std::string s = text;

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

std::string int_to_hex(int value) {
    std::ostringstream oss;
    if (value < 0) {
        oss << "-0x" << std::hex << std::uppercase << (-value);
    }
    else {
        oss << "0x" << std::hex << std::uppercase << value;
    }
    return oss.str();
}
