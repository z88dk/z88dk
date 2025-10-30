//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../utils.h"
#include "catch_amalgamated.hpp"
#include <cstdio>
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

    // leading or trailing whitespace is not accepted (function expects exact match)
    REQUIRE_FALSE(parse_int_from_chars(" 42", 10, out));
    REQUIRE_FALSE(parse_int_from_chars("42 ", 10, out));

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
// Tests for escape_string (added earlier)
// -----------------------------------------------------------------------------

TEST_CASE("escape_string escapes control characters to C-style sequences",
          "[escape_string][controls]") {
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

    REQUIRE(escape_string(in) == expected);
}

TEST_CASE("escape_string escapes double-quotes and backslashes correctly",
          "[escape_string][quotes][backslash]") {
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

    REQUIRE(escape_string(in) == expected);

    // also test a single backslash -> becomes double backslash
    REQUIRE(escape_string(std::string("\\", 1)) == std::string("\\\\"));
}

TEST_CASE("escape_string converts non-printable bytes to \\xHH (uppercase hex)",
          "[escape_string][hex]") {
    std::string in;
    in.push_back(static_cast<char>(1));     // 0x01
    in.push_back(static_cast<char>(0x80));  // 0x80 (non-printable, > 0x7f)

    // expected: \x01\x80 (uppercase hex)
    std::string expected;
    expected += "\\x01";
    expected += "\\x80";

    REQUIRE(escape_string(in) == expected);
}

TEST_CASE("escape_string leaves printable ASCII unchanged",
          "[escape_string][printable]") {
    std::string s = "Hello, 123! ~";
    REQUIRE(escape_string(s) == s);
}

TEST_CASE("escape_string returns empty string for empty input",
          "[escape_string][empty]") {
    REQUIRE(escape_string(std::string()) == std::string());
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

