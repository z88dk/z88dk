//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../utils.h"
#include "catch_amalgamated.hpp"
#include <cstdio>
#include <filesystem>
#include <limits>
#include <string>

TEST_CASE("to_upper converts strings to uppercase", "[to_upper]") {
    REQUIRE(to_upper("abc") == "ABC");
    REQUIRE(to_upper("AbC123") == "ABC123");
    REQUIRE(to_upper("already UPPER") == "ALREADY UPPER");
    REQUIRE(to_upper("") == "");
    REQUIRE(to_upper("!@#") == "!@#");
}

TEST_CASE("to_lower converts strings to lowercase", "[to_lower]") {
    REQUIRE(to_lower("ABC") == "abc");
    REQUIRE(to_lower("AbC123") == "abc123");
    REQUIRE(to_lower("already lower") == "already lower");
    REQUIRE(to_lower("") == "");
    REQUIRE(to_lower("!@#") == "!@#");
}

TEST_CASE("ltrim removes leading whitespace", "[ltrim]") {
    REQUIRE(ltrim("   abc") == "abc");
    REQUIRE(ltrim("\t\txyz") == "xyz");
    REQUIRE(ltrim("  \t  test  ") == "test  ");
    REQUIRE(ltrim("") == "");
    REQUIRE(ltrim("nochange") == "nochange");
}

TEST_CASE("rtrim removes trailing whitespace", "[rtrim]") {
    REQUIRE(rtrim("abc   ") == "abc");
    REQUIRE(rtrim("xyz\t\t") == "xyz");
    REQUIRE(rtrim("  test  \t  ") == "  test");
    REQUIRE(rtrim("") == "");
    REQUIRE(rtrim("nochange") == "nochange");
}

TEST_CASE("trim removes leading and trailing whitespace", "[trim]") {
    REQUIRE(trim("   abc   ") == "abc");
    REQUIRE(trim("\t\txyz\t") == "xyz");
    REQUIRE(trim("  \t  test  \t ") == "test");
    REQUIRE(trim("") == "");
    REQUIRE(trim("nochange") == "nochange");
}

TEST_CASE("read_file_to_string and write_string_to_file basic I/O",
          "[file_io]") {
    const std::string fname = "test_utils_io.txt";
    const std::string content = "Hello, file!\nSecond line.\n";

    // write and read back
    write_string_to_file(fname, content);
    REQUIRE(read_file_to_string(fname) == content);

    // empty content
    const std::string fname_empty = "test_utils_io_empty.txt";
    write_string_to_file(fname_empty, std::string());
    REQUIRE(read_file_to_string(fname_empty) == std::string());

    // binary content with embedded null
    const std::string fname_bin = "test_utils_io_bin.tmp";
    std::string bin;
    bin.push_back('a');
    bin.push_back('\0');
    bin.push_back('b');
    write_string_to_file(fname_bin, bin);
    std::string bin_read = read_file_to_string(fname_bin);
    REQUIRE(bin_read.size() == bin.size());
    REQUIRE(bin_read == bin);

    // cleanup
    std::remove(fname.c_str());
    std::remove(fname_empty.c_str());
    std::remove(fname_bin.c_str());
}

TEST_CASE("read_file_to_string throws on missing file", "[file_io]") {
    const std::string missing = "this_file_should_not_exist_12345.tmp";
    // ensure file does not exist before test
    std::remove(missing.c_str());
    REQUIRE_THROWS_AS(read_file_to_string(missing), std::runtime_error);
}

TEST_CASE("parse_int_from_chars valid conversions", "[parse_int_from_chars]") {
    int out = 0;

    REQUIRE(parse_int_from_chars("123", 10, out));
    REQUIRE(out == 123);

    REQUIRE(parse_int_from_chars("  123", 10, out));
    REQUIRE(out == 123);

    REQUIRE(parse_int_from_chars("123  ", 10, out));
    REQUIRE(out == 123);

    REQUIRE(parse_int_from_chars("-42", 10, out));
    REQUIRE(out == -42);

    REQUIRE(parse_int_from_chars("1A3f", 16, out));
    REQUIRE(out == 0x1A3F);

    REQUIRE(parse_int_from_chars("0xFF", 16, out));
    REQUIRE(out == 255);

    REQUIRE(parse_int_from_chars("1011", 2, out));
    REQUIRE(out == 11);

    REQUIRE(parse_int_from_chars("75", 8, out));
    REQUIRE(out == 61);
}

TEST_CASE("parse_int_from_chars invalid inputs and edge cases",
          "[parse_int_from_chars]") {
    int out = 0;

    // empty string
    REQUIRE_FALSE(parse_int_from_chars("", 10, out));

    // trailing non-numeric characters
    REQUIRE_FALSE(parse_int_from_chars("123abc", 10, out));

    // invalid digit for base
    REQUIRE_FALSE(parse_int_from_chars("12G", 16, out));
    REQUIRE_FALSE(parse_int_from_chars("2", 2, out)); // '2' invalid for base 2

    // overflow (one more than INT_MAX)
    long long overflow_val = static_cast<long long>(std::numeric_limits<int>::max())
                             + 1LL;
    std::string overflow_str = std::to_string(overflow_val);
    REQUIRE_FALSE(parse_int_from_chars(overflow_str, 10, out));
}

TEST_CASE("parse_int_from_chars ignores underscores in digit strings (valid cases)",
          "[parse_int_from_chars][underscores]") {
    int out = 0;

    // Decimal (with and without sign)
    REQUIRE(parse_int_from_chars("1_234", 10, out));
    REQUIRE(out == 1234);
    REQUIRE(parse_int_from_chars("-1_234", 10, out));
    REQUIRE(out == -1234);

    // Decimal with multiple, clustered underscores
    REQUIRE(parse_int_from_chars("1___2__3", 10, out));
    REQUIRE(out == 123);

    // Hex (explicit base 16)
    REQUIRE(parse_int_from_chars("1A_2F", 16, out));
    REQUIRE(out == 0x1A2F);

    // Hex with 0x/0X prefix (base argument will be overridden to 16)
    REQUIRE(parse_int_from_chars("0xAB_CD", 10, out));
    REQUIRE(out == 0xABCD);
    REQUIRE(parse_int_from_chars("0X_E_AD_BE_EF", 16, out));
    REQUIRE(out == 0xEADBEEF);

    // Binary
    REQUIRE(parse_int_from_chars("1010_1100", 2, out));
    REQUIRE(out == 0b10101100);

    // Octal
    REQUIRE(parse_int_from_chars("7_5", 8, out));
    REQUIRE(out == 075);
}

TEST_CASE("parse_int_from_chars with underscores: invalid inputs and overflow",
          "[parse_int_from_chars][underscores][invalid]") {
    int out = 0;

    // Invalid character remains invalid after removing underscores
    REQUIRE_FALSE(parse_int_from_chars("12_3G", 10,
                                       out));   // 'G' invalid for base 10
    REQUIRE_FALSE(parse_int_from_chars("1Z_2", 16, out));    // 'Z' invalid hex

    // Overflow even with separators
    const long long over = static_cast<long long>(std::numeric_limits<int>::max()) +
                           1LL;
    std::string over_str = std::to_string(over);
    // Insert some underscores into the string (e.g., 2147_483_648 for INT_MAX+1 on 32-bit)
    if (over_str.size() > 4) {
        over_str.insert(over_str.begin() + 4, '_');
    }
    REQUIRE_FALSE(parse_int_from_chars(over_str, 10, out));
}

// -----------------------------------------------------------------------------
// Tests for escape_c_string (added earlier)
// -----------------------------------------------------------------------------

TEST_CASE("escape_c_string escapes control characters to C-style sequences",
          "[escape_c_string][controls]") {
    // build a string with common control characters
    std::string in;
    in.push_back('\a');
    in.push_back('\b');
    in.push_back('\f');
    in.push_back('\n');
    in.push_back('\r');
    in.push_back('\t');
    in.push_back('\v');

    std::string expected;
    expected += "\\a";
    expected += "\\b";
    expected += "\\f";
    expected += "\\n";
    expected += "\\r";
    expected += "\\t";
    expected += "\\v";

    REQUIRE(escape_c_string(in) == expected);
}

TEST_CASE("escape_c_string escapes double-quotes and backslashes correctly",
          "[escape_c_string][quotes][backslash]") {
    std::string in;
    in.push_back('"');   // "
    in += "hi";
    in.push_back('"');   // "
    in.push_back('\\');  // backslash at end

    // expected: \"hi\"\\  (each " becomes \" and backslash becomes \\)
    std::string expected;
    expected += "\\\"";
    expected += "hi";
    expected += "\\\"";
    expected += "\\\\";

    REQUIRE(escape_c_string(in) == expected);

    // also test a single backslash -> becomes double backslash
    REQUIRE(escape_c_string(std::string("\\", 1)) == std::string("\\\\"));
}

TEST_CASE("escape_c_string converts non-printable bytes to \\xHH (uppercase hex)",
          "[escape_c_string][hex]") {
    std::string in;
    in.push_back(static_cast<char>(1));     // 0x01
    in.push_back(static_cast<char>(0x80));  // 0x80 (non-printable, > 0x7f)

    // expected: \x01\x80 (uppercase hex)
    std::string expected;
    expected += "\\x01";
    expected += "\\x80";

    REQUIRE(escape_c_string(in) == expected);
}

TEST_CASE("escape_c_string leaves printable ASCII unchanged",
          "[escape_c_string][printable]") {
    std::string s = "Hello, 123! ~";
    REQUIRE(escape_c_string(s) == s);
}

TEST_CASE("escape_c_string returns empty string for empty input",
          "[escape_c_string][empty]") {
    REQUIRE(escape_c_string(std::string()) == std::string());
}

// -----------------------------------------------------------------------------
// Tests for unescape_c_string (reverse of escape_c_string)
// -----------------------------------------------------------------------------

TEST_CASE("unescape_c_string reverses escape_c_string (roundtrip)",
          "[unescape][roundtrip]") {
    // Build a raw string with control chars, quotes, backslash and high-bit byte
    std::string raw;
    raw.push_back('\a');
    raw.push_back('\b');
    raw.push_back('\f');
    raw.push_back('\n');
    raw.push_back('\r');
    raw.push_back('\t');
    raw.push_back('\v');
    raw.push_back('"');
    raw.push_back('\\');
    raw.push_back(static_cast<char>(0x80));

    std::string esc = escape_c_string(raw);
    std::string got = unescape_c_string(esc);
    REQUIRE(got.size() == raw.size());
    REQUIRE(got == raw);

    // Also works when wrapped in quotes
    std::string quoted = std::string("\"") + esc + std::string("\"");
    REQUIRE(unescape_c_string(quoted) == raw);
}

TEST_CASE("unescape_c_string handles hex and octal escapes and \\e",
          "[unescape][escapes]") {
    // Hex: \x41\x42 -> "AB"
    REQUIRE(unescape_c_string("\\x41\\x42") == std::string("AB"));

    // Single hex digit after \x also accepted
    REQUIRE(unescape_c_string("\\x4A") == std::string("J"));

    // Octal: \101\102 -> "AB"
    REQUIRE(unescape_c_string("\\101\\102") == std::string("AB"));

    // \e -> ESC (27)
    std::string esc;
    esc.push_back(static_cast<char>(27));
    REQUIRE(unescape_c_string("\\e") == esc);
}

TEST_CASE("unescape_c_string handles unknown escapes as the escaped character",
          "[unescape][unknown]") {
    // \z -> 'z'
    REQUIRE(unescape_c_string("\\z") == std::string("z"));
    // Trailing backslash is kept literal
    REQUIRE(unescape_c_string("A\\") == std::string("A\\"));
}

TEST_CASE("unescape_c_string accepts already unescaped content and quoted strings",
          "[unescape][input-forms]") {
    REQUIRE(unescape_c_string("Plain") == std::string("Plain"));
    REQUIRE(unescape_c_string("\"Plain\"") == std::string("Plain"));
    REQUIRE(unescape_c_string("'Plain'") == std::string("Plain"));
}

// -----------------------------------------------------------------------------
// New tests for str_ends_with
// -----------------------------------------------------------------------------

TEST_CASE("str_ends_with detects suffix correctly", "[str_ends_with]") {
    REQUIRE(str_ends_with("filename.asm", ".asm"));
    REQUIRE(str_ends_with("hello", "lo"));
    REQUIRE_FALSE(str_ends_with("hello", "Hello")); // case-sensitive
    REQUIRE(str_ends_with("abc", ""));              // empty ending should match
    REQUIRE_FALSE(str_ends_with("",
                                "a"));          // non-empty ending can't match empty string
    REQUIRE(str_ends_with("", ""));                 // empty ends-with empty -> true
    REQUIRE_FALSE(str_ends_with("short", "longer_suffix"));
}

// -----------------------------------------------------------------------------
// New tests for str_starts_with
// -----------------------------------------------------------------------------

TEST_CASE("str_starts_with detects prefix correctly", "[str_starts_with]") {
    REQUIRE(str_starts_with("filename.asm", "file"));
    REQUIRE(str_starts_with("hello", "he"));
    REQUIRE_FALSE(str_starts_with("hello", "He")); // case-sensitive
    REQUIRE(str_starts_with("abc", ""));           // empty beginning matches
    REQUIRE_FALSE(str_starts_with("",
                                  "a"));       // non-empty beginning can't match empty
    REQUIRE(str_starts_with("",
                            ""));              // empty starts-with empty -> true
    REQUIRE_FALSE(str_starts_with("short", "shorter_prefix"));
}

//-----------------------------------------------------------------------------
// Tests for parse_float_from_chars (previously untested)
// -----------------------------------------------------------------------------

TEST_CASE("parse_float_from_chars valid conversions (mantissa and exponent)",
          "[parse_float_from_chars][valid]") {
    double out = 0.0;

    // Basic forms
    REQUIRE(parse_float_from_chars("123.0", out));
    REQUIRE(out == Catch::Approx(123.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("  123.0", out));
    REQUIRE(out == Catch::Approx(123.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("123.0  ", out));
    REQUIRE(out == Catch::Approx(123.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars(".5", out));
    REQUIRE(out == Catch::Approx(0.5).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("1.", out));
    REQUIRE(out == Catch::Approx(1.0).epsilon(1e-12));

    // Exponents
    REQUIRE(parse_float_from_chars("1e2", out));
    REQUIRE(out == Catch::Approx(100.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("1E+3", out));
    REQUIRE(out == Catch::Approx(1000.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("-2.5e-1", out));
    REQUIRE(out == Catch::Approx(-0.25).epsilon(1e-12));
}

TEST_CASE("parse_float_from_chars accepts underscores anywhere (they are ignored)",
          "[parse_float_from_chars][underscores]") {
    double out = 0.0;

    // Underscores in integer and fractional parts
    REQUIRE(parse_float_from_chars("1_234.5", out));
    REQUIRE(out == Catch::Approx(1234.5).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("12.3_45", out));
    REQUIRE(out == Catch::Approx(12.345).epsilon(1e-12));

    // Underscores in exponent part
    REQUIRE(parse_float_from_chars("1.25e1_2", out));
    REQUIRE(out == Catch::Approx(1.25e12).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("3.0e-0_3", out));
    REQUIRE(out == Catch::Approx(3.0e-3).epsilon(1e-12));

    // Combined underscore usage (permissive in utils: underscores are simply removed)
    REQUIRE(parse_float_from_chars("4_2.e0_0", out));
    REQUIRE(out == Catch::Approx(42.0).epsilon(1e-12));

    // Edge underscore placements that are rejected by the lexer are still accepted by utils
    REQUIRE(parse_float_from_chars("1_.2", out));  // becomes "1.2"
    REQUIRE(out == Catch::Approx(1.2).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("1._", out));   // becomes "1."
    REQUIRE(out == Catch::Approx(1.0).epsilon(1e-12));

    REQUIRE(parse_float_from_chars("._5", out));   // becomes ".5"
    REQUIRE(out == Catch::Approx(0.5).epsilon(1e-12));
}

TEST_CASE("parse_float_from_chars invalid inputs and edge cases",
          "[parse_float_from_chars][invalid]") {
    double out = 0.0;

    // Empty string
    REQUIRE_FALSE(parse_float_from_chars("", out));

    // Trailing non-numeric characters
    REQUIRE_FALSE(parse_float_from_chars("1.23foo", out));

    // Missing exponent digits
    REQUIRE_FALSE(parse_float_from_chars("1.e", out));
    REQUIRE_FALSE(parse_float_from_chars("1.e+", out));
    REQUIRE_FALSE(parse_float_from_chars("1.e-", out));
    REQUIRE_FALSE(parse_float_from_chars(".5E", out));
    REQUIRE_FALSE(parse_float_from_chars(".5E+", out));

    // Multiple exponent signs or duplicated 'e'
    REQUIRE_FALSE(parse_float_from_chars("1.2e++3", out));
    REQUIRE_FALSE(parse_float_from_chars("1.2e--3", out));
    REQUIRE_FALSE(parse_float_from_chars("1.2ee3", out));

    // Out of range for double (platform-dependent, but 1e309 should overflow IEEE-754 double)
    REQUIRE_FALSE(parse_float_from_chars("1e309", out));
}

//-----------------------------------------------------------------------------
// z80asm2 utils.h - binary file I/O tests
//-----------------------------------------------------------------------------

TEST_CASE("read_file_to_bytes and write_bytes_to_file roundtrip",
          "[utils][bytes][io]") {
    const std::string fname = "test_utils_bytes.bin";

    // Data with zeros and high-bit values
    const std::vector<unsigned char> data = { 0x00, 0x41, 0xFF, 0x20, 0x00, 0x7E };

    // Write and read back
    write_bytes_to_file(fname, data);
    std::vector<unsigned char> read_back = read_file_to_bytes(fname);

    REQUIRE(read_back == data);

    // Overwrite with different content (shorter)
    const std::vector<unsigned char> data2 = { 0x12, 0x34, 0x56 };
    write_bytes_to_file(fname, data2);
    std::vector<unsigned char> read_back2 = read_file_to_bytes(fname);
    REQUIRE(read_back2 == data2);

    // Cleanup
    std::remove(fname.c_str());
}

TEST_CASE("write_bytes_to_file handles empty content and read back is empty",
          "[utils][bytes][empty]") {
    const std::string fname = "test_utils_bytes_empty.bin";

    const std::vector<unsigned char> empty;
    write_bytes_to_file(fname, empty);

    std::vector<unsigned char> read_back = read_file_to_bytes(fname);
    REQUIRE(read_back.empty());

    std::remove(fname.c_str());
}

TEST_CASE("read_file_to_bytes throws on missing file",
          "[utils][bytes][error]") {
    const std::string missing = "this_binary_should_not_exist_98765.tmp";
    // ensure file does not exist before test
    std::remove(missing.c_str());
    REQUIRE_THROWS_AS(read_file_to_bytes(missing), std::runtime_error);
}

TEST_CASE("String/file cross-compatibility between text and bytes helpers",
          "[utils][bytes][string][io]") {
    const std::string fname = "test_utils_cross.tmp";

    // Write using string helper (with embedded NUL) and read using bytes helper
    std::string s;
    s.push_back('A');
    s.push_back('\0');
    s.push_back('Z');

    write_string_to_file(fname, s);
    std::vector<unsigned char> bytes = read_file_to_bytes(fname);
    REQUIRE(bytes.size() == s.size());
    for (size_t i = 0; i < s.size(); ++i) {
        REQUIRE(bytes[i] == static_cast<unsigned char>(s[i]));
    }

    // Now write using bytes helper and read using string helper
    const std::vector<unsigned char> b2 = { 0xDE, 0xAD, 0x00, 0xBE, 0xEF };
    write_bytes_to_file(fname, b2);
    std::string s2 = read_file_to_string(
                         fname); // read_file_to_string is binary-safe
    REQUIRE(s2.size() == b2.size());
    for (size_t i = 0; i < b2.size(); ++i) {
        REQUIRE(static_cast<unsigned char>(s2[i]) == b2[i]);
    }

    std::remove(fname.c_str());
}

//-----------------------------------------------------------------------------
// Tests for normalize_path
//-----------------------------------------------------------------------------

TEST_CASE("normalize_path resolves dot and dot-dot components",
          "[normalize_path]") {
    REQUIRE(normalize_path("a/b/c") == "a/b/c");
    REQUIRE(normalize_path("a/./b") == "a/b");
    REQUIRE(normalize_path("a/b/.") ==
            "a/b/");     // trailing /. normalizes to trailing /
    REQUIRE(normalize_path("a/b/../c") == "a/c");
    REQUIRE(normalize_path("a/../b") == "b");
    REQUIRE(normalize_path("./a/b") == "a/b");
    REQUIRE(normalize_path("../a/b") == "../a/b");
    REQUIRE(normalize_path("a/b/../../c") == "c");
}

TEST_CASE("normalize_path removes redundant separators",
          "[normalize_path]") {
    REQUIRE(normalize_path("a//b") == "a/b");
    REQUIRE(normalize_path("a///b///c") == "a/b/c");
    REQUIRE(normalize_path("a/b/") == "a/b/");      // trailing slash is preserved
    REQUIRE(normalize_path("/a/b") == "/a/b");
#ifdef _WIN32
    // Windows UNC paths must keep the two leading slashes
    REQUIRE(normalize_path("//server/share") == "//server/share");
#else
    // On POSIX, '//' is implementation-defined; accept either preserved or collapsed
    const auto posix_unc = normalize_path("//a/b");
    REQUIRE((posix_unc == "//a/b" || posix_unc == "/a/b"));
#endif
}

TEST_CASE("normalize_path handles platform-specific separators",
          "[normalize_path]") {
    // Test with backslashes (Windows-style)
    REQUIRE(normalize_path("a\\b\\c") == "a/b/c");
    REQUIRE(normalize_path("a\\..\\b") == "b");
    REQUIRE(normalize_path("a\\.\\b") == "a/b");

    // Mixed separators
    REQUIRE(normalize_path("a/b\\c") == "a/b/c");
    REQUIRE(normalize_path("a\\b/c") == "a/b/c");
}

// Additional UNC-specific tests for Windows to ensure leading '//' is preserved
#ifdef _WIN32
TEST_CASE("normalize_path preserves UNC leading '//' and normalizes the rest",
          "[normalize_path][windows][unc]") {
    // Basic UNC path remains with two leading slashes
    REQUIRE(normalize_path("//server/share") == "//server/share");

    // Backslashes are converted and leading slashes preserved
    REQUIRE(normalize_path("\\\\server\\share\\folder") == "//server/share/folder");

    // Redundant leading/trailing/mid separators normalize but keep exactly two leading slashes
    REQUIRE(normalize_path("////server//share///folder") ==
            "//server/share/folder");
}
#endif

TEST_CASE("normalize_path handles edge cases",
          "[normalize_path]") {
    // Empty path returns "."
    REQUIRE(normalize_path("") == ".");

    // Single dot
    REQUIRE(normalize_path(".") == ".");

    // Double dot
    REQUIRE(normalize_path("..") == "..");

    // Root paths - lexically_normal() simplifies these
    REQUIRE(normalize_path("/") == "/");
    REQUIRE(normalize_path("/.") == "/");      // /. normalizes to /
    REQUIRE(normalize_path("/..") ==
            "/");     // /.. normalizes to / (can't go above root)

    // Multiple trailing slashes
    REQUIRE(normalize_path("a/b///") ==
            "a/b/");   // trailing slashes normalize to single /
}

TEST_CASE("normalize_path preserves relative vs absolute nature",
          "[normalize_path]") {
    // Relative paths stay relative
    REQUIRE(normalize_path("a/b") == "a/b");
    REQUIRE(normalize_path("../a/b") == "../a/b");

    // Absolute paths stay absolute
    REQUIRE(normalize_path("/a/b") == "/a/b");
    REQUIRE(normalize_path("/a/../b") == "/b");
}

//-----------------------------------------------------------------------------
// Tests for parent_dir
//-----------------------------------------------------------------------------

TEST_CASE("parent_dir returns parent directory",
          "[parent_dir]") {
    REQUIRE(parent_dir("a/b/c") == "a/b");
    REQUIRE(parent_dir("a/b") == "a");
    REQUIRE(parent_dir("a") == "");
    REQUIRE(parent_dir("/a/b/c") == "/a/b");
    REQUIRE(parent_dir("/a") == "/");
}

TEST_CASE("parent_dir handles platform-specific separators",
          "[parent_dir]") {
    REQUIRE(parent_dir("a\\b\\c") == "a/b");
    REQUIRE(parent_dir("a\\b") == "a");

    // Mixed separators
    REQUIRE(parent_dir("a/b\\c") == "a/b");
}

TEST_CASE("parent_dir handles edge cases",
          "[parent_dir]") {
    // Empty path
    REQUIRE(parent_dir("") == "");

    // Single file
    REQUIRE(parent_dir("file.txt") == "");

    // Root - parent_path() of "/" returns "/"
    REQUIRE(parent_dir("/") == "/");

    // Current directory
    REQUIRE(parent_dir(".") == "");
    REQUIRE(parent_dir("./file.txt") == ".");

    // Parent directory
    REQUIRE(parent_dir("..") == "");
    REQUIRE(parent_dir("../file.txt") == "..");
}

TEST_CASE("parent_dir handles trailing separators",
          "[parent_dir]") {
    REQUIRE(parent_dir("a/b/") == "a/b");
    REQUIRE(parent_dir("a/") == "a");
    REQUIRE(parent_dir("/a/") == "/a");
}

//-----------------------------------------------------------------------------
// Tests for absolute_path
//-----------------------------------------------------------------------------

TEST_CASE("absolute_path converts relative to absolute",
          "[absolute_path]") {
    // Get current working directory for comparison
    std::filesystem::path cwd = std::filesystem::current_path();
    std::string cwd_str = cwd.lexically_normal().generic_string();

    // Test relative path
    std::string result = absolute_path(".");
    REQUIRE(result == cwd_str);

    // Test with subdirectory
    std::string expected = cwd_str + "/subdir";
    REQUIRE(absolute_path("subdir") == expected);
}

TEST_CASE("absolute_path resolves dot and dot-dot in result",
          "[absolute_path]") {
    std::filesystem::path cwd = std::filesystem::current_path();
    std::string cwd_str = cwd.lexically_normal().generic_string();

    // Path with .. should resolve correctly
    std::string result = absolute_path("a/../b");
    std::string expected = cwd_str + "/b";
    REQUIRE(result == expected);

    // Path with . should resolve correctly
    result = absolute_path("a/./b");
    expected = cwd_str + "/a/b";
    REQUIRE(result == expected);
}

TEST_CASE("absolute_path returns forward slashes on all platforms",
          "[absolute_path]") {
    std::string result = absolute_path(".");

    // Result should not contain backslashes
    REQUIRE(result.find('\\') == std::string::npos);

    // Should contain forward slashes (unless it's a very short path)
    bool has_forward_slash = (result.find('/') != std::string::npos);
    bool is_short_path = (result.length() <= 3); // e.g., "C:/" or "/"
    REQUIRE((has_forward_slash || is_short_path));
}

TEST_CASE("absolute_path handles already-absolute paths",
          "[absolute_path]") {
    // Create a known absolute path
    std::filesystem::path cwd = std::filesystem::current_path();
    std::string abs_input = cwd.lexically_normal().generic_string() + "/test";

    std::string result = absolute_path(abs_input);
    REQUIRE(result == abs_input);
}

TEST_CASE("absolute_path handles paths with platform separators",
          "[absolute_path]") {
    std::filesystem::path cwd = std::filesystem::current_path();
    std::string cwd_str = cwd.lexically_normal().generic_string();

    // Test with backslashes
    std::string result = absolute_path("a\\b");
    std::string expected = cwd_str + "/a/b";
    REQUIRE(result == expected);
}

TEST_CASE("absolute_path normalizes result",
          "[absolute_path]") {
    std::filesystem::path cwd = std::filesystem::current_path();
    std::string cwd_str = cwd.lexically_normal().generic_string();

    // Test with redundant separators
    std::string result = absolute_path("a//b");
    std::string expected = cwd_str + "/a/b";
    REQUIRE(result == expected);
}

TEST_CASE("absolute_path throws on filesystem errors",
          "[absolute_path]") {
    // Most paths should work, but we can test that the function
    // properly propagates exceptions by checking the behavior is consistent
    // Note: It's hard to trigger a filesystem_error in a portable way,
    // so this test just verifies the function doesn't crash on valid inputs
    REQUIRE_NOTHROW(absolute_path("."));
    REQUIRE_NOTHROW(absolute_path(".."));
    REQUIRE_NOTHROW(absolute_path("test"));
}

