//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../preprocessor.h"
#include "catch_amalgamated.hpp"
#include <fstream>
#include <cstdio>
#include <string>
#include <sstream>

namespace {
// Redirect std::cerr to an internal buffer for the duration of these tests
// so test error messages don't pollute the console output.
struct StderrSilencer {
    StderrSilencer() : old_buf(std::cerr.rdbuf(stream.rdbuf())) {}
    ~StderrSilencer() {
        std::cerr.rdbuf(old_buf);
    }
    std::string str() const {
        return stream.str();
    }
private:
    std::ostringstream stream;
    std::streambuf* old_buf = nullptr;
};

// Instantiate a single silencer for this translation unit.
static StderrSilencer g_stderr_silencer;
}

TEST_CASE("Preprocessor: split label produces label line then instruction line",
          "[preprocessor]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "start: nop\n";
    pp.push_virtual_file(content, "virtual_label", 1);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // label line
    const auto& toks1 = line.tokens();
    REQUIRE(toks1.size() == 2);
    REQUIRE(toks1[0].text() == ".");       // dot token inserted by split_label
    REQUIRE(toks1[1].text() == "start");   // label name

    REQUIRE(pp.next_line(line)); // instruction line
    const auto& toks2 = line.tokens();
    REQUIRE(toks2.size() >= 1);
    REQUIRE(toks2[0].text() == "nop");
}

TEST_CASE("Preprocessor: transform string to list of integer tokens",
          "[preprocessor]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "db \"AB\"\n";
    pp.push_virtual_file(content, "virtual_db", 1);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect first token to be the directive/identifier 'db'
    REQUIRE(toks.size() >= 4);
    REQUIRE(toks[0].text() == "db");
    REQUIRE(toks[1].text() == " ");

    // Following tokens should represent 'A' (65), comma, 'B' (66)
    REQUIRE(toks[2].int_value() == static_cast<int>('A'));
    REQUIRE(toks[3].text() == ",");
    REQUIRE(toks[4].int_value() == static_cast<int>('B'));
}

TEST_CASE("Preprocessor: include directive pushes included file contents",
          "[preprocessor]") {
    g_errors.reset();
    Preprocessor pp;

    // create a temporary file to be included
    const std::string fname = "pp_include_test.tmp";
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "included_line\n";
    }

    // virtual file that includes the temp file and then has another line
    const std::string content = "#include \"" + fname + "\"\nafter\n";
    pp.push_virtual_file(content, "virtual_include", 1);

    TokensLine line;
    // first non-directive line should come from the included file
    REQUIRE(pp.next_line(line));
    const auto& toks1 = line.tokens();
    REQUIRE(toks1.size() >= 1);
    REQUIRE(toks1[0].text() == "included_line");

    // then the original file's subsequent line should be returned
    REQUIRE(pp.next_line(line));
    const auto& toks2 = line.tokens();
    REQUIRE(toks2.size() >= 1);
    REQUIRE(toks2[0].text() == "after");

    // cleanup
    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: include without filename reports invalid-syntax",
          "[preprocessor][include][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "#include\n";
    pp.push_virtual_file(content, "virtual_noarg", 1);

    TokensLine line;
    // consume all produced lines (there should be none)
    while (pp.next_line(line)) { }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    // should report the specific invalid-syntax message
    REQUIRE(msg.find("Expected filename string in include directive") !=
            std::string::npos);
    // should include the source line and location
    REQUIRE(msg.find("#include") != std::string::npos);
    REQUIRE(msg.find("virtual_noarg:1:") != std::string::npos);
}

TEST_CASE("Preprocessor: include with angle brackets treated as string; missing file reports FileNotFound",
          "[preprocessor][include][angle]") {
    g_errors.reset();
    Preprocessor pp;

    // angle-bracket include — lexer reports the name as a string token
    const std::string missing = "pp_angle_missing.tmp";
    const std::string content = "#include <" + missing + ">\n";
    pp.push_virtual_file(content, "virtual_angle", 1);

    TokensLine line;
    // consume produced lines (none expected because include is processed as directive)
    while (pp.next_line(line)) { }

    // lexer treats <...> as a string so there must NOT be an InvalidSyntax about filename
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();

    // ensure the error is file-not-found for the included filename
    REQUIRE(msg.find("File not found") != std::string::npos);
    REQUIRE(msg.find("Could not read file: " + missing) != std::string::npos);

    // ensure we did NOT record the "Expected filename string in include directive" invalid-syntax
    REQUIRE(msg.find("Expected filename string in include directive") ==
            std::string::npos);
}

TEST_CASE("Preprocessor: string escape sequences are converted to integer list",
          "[preprocessor][strings][escapes]") {
    g_errors.reset();
    Preprocessor pp;

    // The assembly string contains many escape sequences. Use a C++ literal
    // where backslashes are escaped so the assembler sees the intended escapes.
    const std::string content =
        "db \"A\\a\\b\\e\\f\\n\\r\\t\\v\\x41\\101\\\\\\\"\\'\"\n";
    pp.push_virtual_file(content, "escape_test", 1);

    TokensLine line;
    REQUIRE(pp.next_line(line));

    const auto& toks = line.tokens();

    // Collect integer token values produced from the string
    std::vector<int> ints;
    int comma_count = 0;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            ints.push_back(t.int_value());
        }
        else if (t.is(TokenType::Comma)) {
            ++comma_count;
        }
    }

    // Expected interpreted character codes:
    // 'A', '\a'(7), '\b'(8), '\e'(27), '\f'(12), '\n'(10), '\r'(13),
    // '\t'(9), '\v'(11), '\x41'(65), '\101'(65), '\\'(92), '"' (34), '\'' (39)
    std::vector<int> expected = {
        static_cast<int>('A'),
        7, 8, 27, 12, 10, 13, 9, 11,
        0x41, 0101, static_cast<int>('\\'), static_cast<int>('"'),
        static_cast<int>('\'')
    };

    REQUIRE(ints.size() == expected.size());
    REQUIRE(ints == expected);

    // Ensure commas separate the numbers (n-1 commas for n characters)
    REQUIRE(comma_count == static_cast<int>(expected.size()) - 1);
}

// New test: include accepts quoted, angle and plain filename forms
TEST_CASE("Preprocessor: include accepts quoted, angle and plain filename forms",
          "[preprocessor][include][forms]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fq = "inc_quoted.tmp";
    const std::string fa = "inc_angle.tmp";
    const std::string fp = "inc_plain.tmp";

    // create the three files with distinct first lines
    {
        std::ofstream ofs(fq, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "from_quoted\n";
        std::ofstream ofs2(fa, std::ios::binary);
        REQUIRE(ofs2.is_open());
        ofs2 << "from_angle\n";
        std::ofstream ofs3(fp, std::ios::binary);
        REQUIRE(ofs3.is_open());
        ofs3 << "from_plain\n";
    }

    // Build virtual file with three include directives using the three forms,
    // then a sentinel line to ensure we continue after includes.
    std::string content;
    content += "#include \"" + fq + "\"\n";
    content += "#include <" + fa + ">\n";
    content += "#include " + fp + "\n";
    content += "sentinel\n";

    pp.push_virtual_file(content, "include_forms", 1);

    TokensLine line;

    // Expect included contents to appear in the same order
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "from_quoted");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "from_angle");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "from_plain");

    // finally the sentinel from the original virtual file
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "sentinel");

    // cleanup
    std::remove(fq.c_str());
    std::remove(fa.c_str());
    std::remove(fp.c_str());
}

// New tests: trailing extra text after include filename should produce an error
TEST_CASE("Preprocessor: include with trailing extra token after filename is flagged as error",
          "[preprocessor][include][error][trailing]") {
    const std::string fq = "inc_trail_quoted.tmp";
    const std::string fa = "inc_trail_angle.tmp";
    const std::string fp = "inc_trail_plain.tmp";

    // create files to be referenced
    {
        std::ofstream ofs(fq, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "Q\n";
        std::ofstream ofs2(fa, std::ios::binary);
        REQUIRE(ofs2.is_open());
        ofs2 << "A\n";
        std::ofstream ofs3(fp, std::ios::binary);
        REQUIRE(ofs3.is_open());
        ofs3 << "P\n";
    }

    TokensLine line;

    // Quoted form with trailing token
    {
        g_errors.reset();
        Preprocessor pp;
        std::string content = "#include \"" + fq + "\" trailing\n";
        pp.push_virtual_file(content, "inc_trail_q", 1);
        while (pp.next_line(line)) { }
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Unexpected token") != std::string::npos);
        REQUIRE(msg.find("trailing") != std::string::npos);
    }

    // Angle-bracket form with trailing token
    {
        g_errors.reset();
        Preprocessor pp;
        std::string content = "#include <" + fa + "> trailing\n";
        pp.push_virtual_file(content, "inc_trail_a", 1);
        while (pp.next_line(line)) { }
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Unexpected token") != std::string::npos);
        REQUIRE(msg.find("trailing") != std::string::npos);
    }

    // Plain filename form with trailing token
    {
        g_errors.reset();
        Preprocessor pp;
        std::string content = "#include " + fp + " trailing\n";
        pp.push_virtual_file(content, "inc_trail_p", 1);
        while (pp.next_line(line)) { }
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Unexpected token") != std::string::npos);
        REQUIRE(msg.find("trailing") != std::string::npos);
    }

    // cleanup
    std::remove(fq.c_str());
    std::remove(fa.c_str());
    std::remove(fp.c_str());
}
