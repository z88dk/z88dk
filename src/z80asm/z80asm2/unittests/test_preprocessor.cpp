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
    pp.push_virtual_file(content, "virtual_label", 1, true);

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
    pp.push_virtual_file(content, "virtual_db", 1, true);

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
    pp.push_virtual_file(content, "virtual_include", 1, true);

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
    pp.push_virtual_file(content, "virtual_noarg", 1, true);

    TokensLine line;
    // consume all produced lines (there should be none)
    while (pp.next_line(line)) { }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    // should report the specific invalid-syntax message
    REQUIRE(msg.find("Expected filename in include directive") !=
            std::string::npos);
    // should include the source line and location
    REQUIRE(msg.find("#include") != std::string::npos);
    REQUIRE(msg.find("virtual_noarg:1:") != std::string::npos);
}

TEST_CASE("Preprocessor: include with angle brackets treated as string; missing file reports FileNotFound",
          "[preprocessor][include][angle]") {
    g_errors.reset();
    Preprocessor pp;

    // angle-bracket include - lexer reports the name as a string token
    const std::string missing = "pp_angle_missing.tmp";
    const std::string content = "#include <" + missing + ">\n";
    pp.push_virtual_file(content, "virtual_angle", 1, true);

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
    pp.push_virtual_file(content, "escape_test", 1, true);

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

    pp.push_virtual_file(content, "include_forms", 1, true);

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
        pp.push_virtual_file(content, "inc_trail_q", 1, true);
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
        pp.push_virtual_file(content, "inc_trail_a", 1, true);
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
        pp.push_virtual_file(content, "inc_trail_p", 1, true);
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

// New tests: LINE directive handling and errors

TEST_CASE("Preprocessor: LINE <n> sets logical line numbers for following lines",
          "[preprocessor][line]") {
    g_errors.reset();
    Preprocessor pp;

    // LINE 100 then two ordinary lines
    const std::string content = "LINE 100\nfirst_line\nsecond_line\n";
    pp.push_virtual_file(content, "line_test", 1, true);

    TokensLine line;
    // first returned line should be "first_line" with logical line 100
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "first_line");
    REQUIRE(line.location().line_num() == 100);
    REQUIRE(line.location().filename() == "line_test");

    // next returned line should be "second_line" with logical line 101
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "second_line");
    REQUIRE(line.location().line_num() == 101);
    REQUIRE(line.location().filename() == "line_test");
}

TEST_CASE("Preprocessor: LINE <n>, \"filename\" sets logical filename and line numbers",
          "[preprocessor][line]") {
    g_errors.reset();
    Preprocessor pp;

    // LINE 200, "other.asm" then a line
    const std::string content = "LINE 200, \"other.asm\"\nonly_line\n";
    pp.push_virtual_file(content, "orig_file", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "only_line");
    REQUIRE(line.location().line_num() == 200);
    REQUIRE(line.location().filename() == "other.asm");
}

TEST_CASE("Preprocessor: LINE with missing argument reports error",
          "[preprocessor][line][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "LINE\n";
    pp.push_virtual_file(content, "line_missing_arg", 1, true);

    TokensLine line;
    // consume produced lines (none expected)
    while (pp.next_line(line)) { }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Expected line number in LINE directive") !=
            std::string::npos);
    REQUIRE(msg.find("line_missing_arg:1:") != std::string::npos);
}

// New tests: C_LINE directive behavior and errors

TEST_CASE("Preprocessor: C_LINE <n> sets constant logical line number for following lines",
          "[preprocessor][cline]") {
    g_errors.reset();
    Preprocessor pp;

    // C_LINE 400 then two ordinary lines
    const std::string content = "C_LINE 400\none_line\ntwo_line\n";
    pp.push_virtual_file(content, "cline_test", 1, true);

    TokensLine line;
    // first returned line should be "one_line" with logical line 400
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "one_line");
    REQUIRE(line.location().line_num() == 400);
    REQUIRE(line.location().filename() == "cline_test");

    // next returned line should be "two_line" with the same logical line 400
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "two_line");
    REQUIRE(line.location().line_num() == 400);
    REQUIRE(line.location().filename() == "cline_test");
}

TEST_CASE("Preprocessor: C_LINE <n>, \"filename\" sets constant filename and line number",
          "[preprocessor][cline]") {
    g_errors.reset();
    Preprocessor pp;

    // C_LINE 300, "cfile.c" then a line
    const std::string content = "C_LINE 300, \"cfile.c\"\nonly_c_line\n";
    pp.push_virtual_file(content, "orig_c_line", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "only_c_line");
    REQUIRE(line.location().line_num() == 300);
    REQUIRE(line.location().filename() == "cfile.c");
}

TEST_CASE("Preprocessor: C_LINE with missing argument reports error",
          "[preprocessor][cline][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "C_LINE\n";
    pp.push_virtual_file(content, "cline_missing_arg", 1, true);

    TokensLine line;
    // consume produced lines (none expected)
    while (pp.next_line(line)) { }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Expected line number in C_LINE directive") !=
            std::string::npos);
    REQUIRE(msg.find("cline_missing_arg:1:") != std::string::npos);
}

// New test: push_binary_file should produce DEFB lines for a 256-byte file
// containing values 0..255 (16 bytes per line -> 16 lines).
TEST_CASE("Preprocessor: push_binary_file reads 0..255 bytes and emits DEFB lines",
          "[preprocessor][binary]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fname = "pp_0_255.bin";
    // create binary file with bytes 0..255
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        for (int i = 0; i < 256; ++i) {
            char c = static_cast<char>(i);
            ofs.write(&c, 1);
        }
    }

    // Push the binary file as a virtual file (DEFB lines)
    pp.push_binary_file(fname, Location(fname, 1));

    TokensLine line;
    std::vector<int> ints;
    int returned_lines = 0;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        // collect integer tokens from the DEFB lines
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
        ++returned_lines;
    }

    // Expect 256 bytes, values 0..255, and 16 lines (256/16)
    REQUIRE(ints.size() == 256);
    for (int i = 0; i < 256; ++i) {
        REQUIRE(ints[i] == i);
    }
    REQUIRE(returned_lines == 16);

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: BINARY directive is parsed and replaced by 16 DEFB lines at directive logical location",
          "[preprocessor][binary][directive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fname = "pp_bin_directive.bin";
    // write 0..255
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        for (int i = 0; i < 256; ++i) {
            char c = static_cast<char>(i);
            ofs.write(&c, 1);
        }
    }

    // Set a LINE directive with a logical filename so we can assert locations.
    const int logical_start = 300;
    const std::string logical_fname = "binary_logic.asm";
    std::string content;
    content += "LINE " + std::to_string(logical_start) + ", \"" + logical_fname +
               "\"\n";
    content += "BINARY \"" + fname + "\"\n";
    content += "after_directive\n";

    pp.push_virtual_file(content, "virtual_binary_dir", 1, true);

    TokensLine line;
    std::vector<int> ints;
    int defb_lines = 0;
    bool saw_after = false;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.empty()) {
            continue;
        }
        const std::string first = toks[0].text();
        if (first == "DEFB") {
            // check that each DEFB line has the same logical location as the BINARY directive
            REQUIRE(line.location().line_num() == logical_start);
            REQUIRE(line.location().filename() == logical_fname);
            ++defb_lines;
            for (const auto& t : toks) {
                if (t.is(TokenType::Integer)) {
                    ints.push_back(t.int_value());
                }
            }
        }
        else if (first == "after_directive") {
            saw_after = true;
            break;
        }
    }

    REQUIRE(defb_lines == 16);
    REQUIRE(ints.size() == 256);
    for (int i = 0; i < 256; ++i) {
        REQUIRE(ints[i] == i);
    }
    REQUIRE(saw_after);

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: INCBIN directive is parsed and replaced by 16 DEFB lines at directive logical location",
          "[preprocessor][binary][directive][incbin]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fname = "pp_incbin_directive.bin";
    // write 0..255
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        for (int i = 0; i < 256; ++i) {
            char c = static_cast<char>(i);
            ofs.write(&c, 1);
        }
    }

    const int logical_start = 400;
    const std::string logical_fname = "incbin_logic.asm";
    std::string content;
    content += "LINE " + std::to_string(logical_start) + ", \"" + logical_fname +
               "\"\n";
    content += "INCBIN \"" + fname + "\"\n";
    content += "after_incbin\n";

    pp.push_virtual_file(content, "virtual_incbin_dir", 1, true);

    TokensLine line;
    std::vector<int> ints;
    int defb_lines = 0;
    bool saw_after = false;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.empty()) {
            continue;
        }
        const std::string first = toks[0].text();
        if (first == "DEFB") {
            REQUIRE(line.location().line_num() == logical_start);
            REQUIRE(line.location().filename() == logical_fname);
            ++defb_lines;
            for (const auto& t : toks) {
                if (t.is(TokenType::Integer)) {
                    ints.push_back(t.int_value());
                }
            }
        }
        else if (first == "after_incbin") {
            saw_after = true;
            break;
        }
    }

    REQUIRE(defb_lines == 16);
    REQUIRE(ints.size() == 256);
    for (int i = 0; i < 256; ++i) {
        REQUIRE(ints[i] == i);
    }
    REQUIRE(saw_after);

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: LINE accepts quoted, angle-bracketed and plain filename forms",
          "[preprocessor][line][forms]") {
    g_errors.reset();
    Preprocessor pp;

    std::string content;
    content += "LINE 10, \"line_q.asm\"\nline_q\n";
    content += "LINE 20, <line_a.asm>\nline_a\n";
    content += "LINE 30, line_p.asm\nline_p\n";

    pp.push_virtual_file(content, "virtual_line_forms", 1, true);

    TokensLine line;

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "line_q");
    REQUIRE(line.location().line_num() == 10);
    REQUIRE(line.location().filename() == "line_q.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "line_a");
    REQUIRE(line.location().line_num() == 20);
    REQUIRE(line.location().filename() == "line_a.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "line_p");
    REQUIRE(line.location().line_num() == 30);
    REQUIRE(line.location().filename() == "line_p.asm");
}

TEST_CASE("Preprocessor: C_LINE accepts quoted, angle-bracketed and plain filename forms",
          "[preprocessor][cline][forms]") {
    g_errors.reset();
    Preprocessor pp;

    std::string content;
    content += "C_LINE 101, \"cline_q.c\"\ncline_q\n";
    content += "C_LINE 202, <cline_a.c>\ncline_a\n";
    content += "C_LINE 303, cline_p.c\ncline_p\n";

    pp.push_virtual_file(content, "virtual_cline_forms", 1, true);

    TokensLine line;

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "cline_q");
    REQUIRE(line.location().line_num() == 101);
    REQUIRE(line.location().filename() == "cline_q.c");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "cline_a");
    REQUIRE(line.location().line_num() == 202);
    REQUIRE(line.location().filename() == "cline_a.c");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line.tokens()[0].text() == "cline_p");
    REQUIRE(line.location().line_num() == 303);
    REQUIRE(line.location().filename() == "cline_p.c");
}

TEST_CASE("Preprocessor: BINARY accepts quoted, angle-bracketed and plain filename forms",
          "[preprocessor][binary][forms]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fq = "bin_q.dat";
    const std::string fa = "bin_a.dat";
    const std::string fp = "bin_p.dat";
    // create small binary files with distinct contents
    {
        std::ofstream ofs(fq, std::ios::binary);
        REQUIRE(ofs.is_open());
        unsigned char data[] = { 10, 11, 12 };
        ofs.write(reinterpret_cast<const char*>(data), sizeof(data));
        std::ofstream ofs2(fa, std::ios::binary);
        REQUIRE(ofs2.is_open());
        unsigned char data2[] = { 20, 21 };
        ofs2.write(reinterpret_cast<const char*>(data2), sizeof(data2));
        std::ofstream ofs3(fp, std::ios::binary);
        REQUIRE(ofs3.is_open());
        unsigned char data3[] = { 30 };
        ofs3.write(reinterpret_cast<const char*>(data3), sizeof(data3));
    }

    std::string content;
    content += "BINARY \"" + fq + "\"\n";
    content += "BINARY <" + fa + ">\n";
    content += "BINARY " + fp + "\n";
    content += "after_binary\n";

    pp.push_virtual_file(content, "virtual_binary_forms", 1, true);

    TokensLine line;
    std::vector<std::vector<int>> groups;
    bool saw_after = false;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.empty()) {
            continue;
        }
        const std::string first = toks[0].text();
        if (first == "DEFB") {
            std::vector<int> g;
            for (const auto& t : toks) {
                if (t.is(TokenType::Integer)) {
                    g.push_back(t.int_value());
                }
            }
            groups.push_back(g);
        }
        else if (first == "after_binary") {
            saw_after = true;
            break;
        }
    }

    REQUIRE(groups.size() == 3);
    REQUIRE(groups[0] == std::vector<int>({10, 11, 12}));
    REQUIRE(groups[1] == std::vector<int>({20, 21}));
    REQUIRE(groups[2] == std::vector<int>({30}));
    REQUIRE(saw_after);

    std::remove(fq.c_str());
    std::remove(fa.c_str());
    std::remove(fp.c_str());
}

TEST_CASE("Preprocessor: INCBIN accepts quoted, angle-bracketed and plain filename forms",
          "[preprocessor][binary][forms][incbin]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fq = "inc_q.dat";
    const std::string fa = "inc_a.dat";
    const std::string fp = "inc_p.dat";
    // create small binary files with distinct contents
    {
        std::ofstream ofs(fq, std::ios::binary);
        REQUIRE(ofs.is_open());
        unsigned char data[] = { 1, 2, 3, 4 };
        ofs.write(reinterpret_cast<const char*>(data), sizeof(data));
        std::ofstream ofs2(fa, std::ios::binary);
        REQUIRE(ofs2.is_open());
        unsigned char data2[] = { 5, 6 };
        ofs2.write(reinterpret_cast<const char*>(data2), sizeof(data2));
        std::ofstream ofs3(fp, std::ios::binary);
        REQUIRE(ofs3.is_open());
        unsigned char data3[] = { 7 };
        ofs3.write(reinterpret_cast<const char*>(data3), sizeof(data3));
    }

    std::string content;
    content += "INCBIN \"" + fq + "\"\n";
    content += "INCBIN <" + fa + ">\n";
    content += "INCBIN " + fp + "\n";
    content += "after_incbin\n";

    pp.push_virtual_file(content, "virtual_incbin_forms", 1, true);

    TokensLine line;
    std::vector<std::vector<int>> groups;
    bool saw_after = false;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.empty()) {
            continue;
        }
        const std::string first = toks[0].text();
        if (first == "DEFB") {
            std::vector<int> g;
            for (const auto& t : toks) {
                if (t.is(TokenType::Integer)) {
                    g.push_back(t.int_value());
                }
            }
            groups.push_back(g);
        }
        else if (first == "after_incbin") {
            saw_after = true;
            break;
        }
    }

    REQUIRE(groups.size() == 3);
    REQUIRE(groups[0] == std::vector<int>({1, 2, 3, 4}));
    REQUIRE(groups[1] == std::vector<int>({5, 6}));
    REQUIRE(groups[2] == std::vector<int>({7}));
    REQUIRE(saw_after);

    std::remove(fq.c_str());
    std::remove(fa.c_str());
    std::remove(fp.c_str());
}

// Added define-related unit tests
TEST_CASE("Preprocessor: object-like #define and name define expand to replacement",
          "[preprocessor][define][object]") {
    g_errors.reset();
    Preprocessor pp;

    // #define form
    {
        const std::string content = "#define X 5\nX\n";
        pp.push_virtual_file(content, "def_obj_hash", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        // Expect integer token 5 as replacement
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 5);
    }

    // name define form
    {
        const std::string content = "Y define 6\nY\n";
        pp.push_virtual_file(content, "def_obj_name", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 6);
    }
}

TEST_CASE("Preprocessor: function-like macros expand arguments (arguments are macro-expanded)",
          "[preprocessor][define][function][args]") {
    g_errors.reset();
    Preprocessor pp;

    // Argument A is an object-like macro; ensure it's expanded when passed to F
    {
        const std::string content =
            "#define A 10\n"
            "#define F(x) x\n"
            "F(A)\n";
        pp.push_virtual_file(content, "def_func_arg_expand", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        // Expect the expanded token to be integer 10
        bool found10 = false;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == 10) {
                found10 = true;
                break;
            }
        }
        REQUIRE(found10);
    }

    // Multi-argument example: ADD(1,TWO) -> should contain both 1 and 2 after expansion
    {
        const std::string content =
            "#define TWO 2\n"
            "#define ADD(a,b) a + b\n"
            "ADD(1,TWO)\n";
        pp.push_virtual_file(content, "def_func_multiarg", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        int found1 = 0, found2 = 0;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == 1) {
                ++found1;
            }
            if (t.is(TokenType::Integer) && t.int_value() == 2) {
                ++found2;
            }
        }
        REQUIRE(found1 >= 1);
        REQUIRE(found2 >= 1);
    }
}

TEST_CASE("Preprocessor: empty define body is replaced by integer 1 (both syntaxes, object and function)",
          "[preprocessor][define][empty]") {
    g_errors.reset();
    Preprocessor pp;

    // #define with empty body
    {
        const std::string content = "#define EMPTY\nEMPTY\n";
        pp.push_virtual_file(content, "def_empty_hash", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 1);
    }

    // name define with empty body
    {
        const std::string content = "E define\nE\n";
        pp.push_virtual_file(content, "def_empty_name", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 1);
    }

    // function-like macro with empty body should also expand to 1
    {
        const std::string content = "#define F(x)\nF(2)\n";
        pp.push_virtual_file(content, "def_empty_func", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 1);
    }
}

TEST_CASE("Preprocessor: macro recursion limit is enforced for self-recursive macro",
          "[preprocessor][define][recursion]") {
    g_errors.reset();
    Preprocessor pp;

    // Self-recursive macro R -> R should eventually trigger recursion limit
    const std::string content =
        "#define R R\n"
        "R\n";
    pp.push_virtual_file(content, "def_recursion", 1, true);

    TokensLine line;
    // consume produced lines (there will be at least one)
    while (pp.next_line(line)) { }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro recursion limit") != std::string::npos);
}

// Tests for UNDEF (both "name undef" and "#undef name" forms)
TEST_CASE("Preprocessor: name undef removes macro (name UNDEF syntax)",
          "[preprocessor][define][undef]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "M define 42\nM undef\nM\n";
    pp.push_virtual_file(content, "def_name_undef", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    // After undef the token should be the identifier 'M', not the expansion 42
    REQUIRE(toks[0].text() == "M");
}

TEST_CASE("Preprocessor: #undef removes macro (#undef name syntax)",
          "[preprocessor][define][undef][hash]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "#define N 99\n#undef N\nN\n";
    pp.push_virtual_file(content, "def_hash_undef", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    // After #undef the token should be the identifier 'N', not the expansion 99
    REQUIRE(toks[0].text() == "N");
}

// -----------------------------------------------------------------------------
// New tests exercising the '#' (stringize) operator in function-like macros
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: stringize operator '#' produces a string token for a simple identifier",
          "[preprocessor][define][stringize]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define S(x) #x\n"
        "S(Hello)\n";
    pp.push_virtual_file(content, "str_simple", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    REQUIRE(toks.size() >= 9);

    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 'H');
    REQUIRE(toks[1].is(TokenType::Comma));

    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 'e');
    REQUIRE(toks[3].is(TokenType::Comma));

    REQUIRE(toks[4].is(TokenType::Integer));
    REQUIRE(toks[4].int_value() == 'l');
    REQUIRE(toks[5].is(TokenType::Comma));

    REQUIRE(toks[6].is(TokenType::Integer));
    REQUIRE(toks[6].int_value() == 'l');
    REQUIRE(toks[7].is(TokenType::Comma));

    REQUIRE(toks[8].is(TokenType::Integer));
    REQUIRE(toks[8].int_value() == 'o');
}

TEST_CASE("Preprocessor: stringize '#' uses the original (unexpanded) argument",
          "[preprocessor][define][stringize][unexpanded]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A X\n"
        "#define S(x) #x\n"
        "S(A)\n";
    pp.push_virtual_file(content, "str_unexpanded", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 1);

    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 'A');
}

TEST_CASE("Preprocessor: stringize '#' escapes double-quotes and backslashes in emitted token.text and preserves original token text in string_value",
          "[preprocessor][define][stringize][escape]") {
    g_errors.reset();
    Preprocessor pp;

    // Argument is a string literal token "\"hi\"" in source; after stringize:
    // - string_value should be the original token text including its quotes: "\"hi\""
    // - token.text() should be the quoted/escaped form emitted by the preprocessor:
    //   outer quotes plus escaped inner quotes -> "\"\\\"hi\\\"\""
    const std::string content =
        "#define S(x) #x\n"
        "S(\"hi\")\n";
    pp.push_virtual_file(content, "str_escape", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 7);

    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == '"');
    REQUIRE(toks[1].is(TokenType::Comma));

    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 'h');
    REQUIRE(toks[3].is(TokenType::Comma));

    REQUIRE(toks[4].is(TokenType::Integer));
    REQUIRE(toks[4].int_value() == 'i');
    REQUIRE(toks[5].is(TokenType::Comma));

    REQUIRE(toks[6].is(TokenType::Integer));
    REQUIRE(toks[6].int_value() == '"');
}

// New test: verify stringize with multiple tokens containing a space produces "A B" -> 65,32,66
TEST_CASE("Preprocessor: stringize '#' preserves spaces between tokens producing 65,32,66 for S(A B)",
          "[preprocessor][define][stringize][space]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define S(x) #x\n"
        "S(A B)\n";
    pp.push_virtual_file(content, "str_space", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    REQUIRE(toks.size() >= 5);

    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 'A');
    REQUIRE(toks[1].is(TokenType::Comma));

    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == ' ');
    REQUIRE(toks[3].is(TokenType::Comma));

    REQUIRE(toks[4].is(TokenType::Integer));
    REQUIRE(toks[4].int_value() == 'B');
}

// Test: block comments replaced by a single Whitespace token (single-line)
TEST_CASE("Preprocessor: single-line /* */ comment replaced by single Whitespace token",
          "[preprocessor][comment]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "A/*single*/B\n";
    pp.push_virtual_file(content, "comment_single", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect: Identifier 'A', one Whitespace token, Identifier 'B'
    REQUIRE(toks.size() >= 3);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "A");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[1].text() == " ");
    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "B");
}

// Test: block comments that span lines are also replaced by a single Whitespace token
TEST_CASE("Preprocessor: multi-line /* */ comment replaced by single Whitespace token",
          "[preprocessor][comment][multiline]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "A/*multi\nline\ncomment*/B\n";
    pp.push_virtual_file(content, "comment_multi", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect: Identifier 'A', one Whitespace token, Identifier 'B'
    REQUIRE(toks.size() >= 3);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "A");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[1].text() == " ");
    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "B");
}

// -----------------------------------------------------------------------------
// New tests for the '##' token pasting operator
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: DoubleHash '##' concatenates two identifiers into one identifier token",
          "[preprocessor][tokenpaste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "A ## B\n";
    pp.push_virtual_file(content, "paste_ids", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect a single identifier token 'AB' (whitespace and other tokens may be preserved)
    bool foundAB = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier) && t.text() == "AB") {
            foundAB = true;
            break;
        }
    }
    REQUIRE(foundAB);
}

TEST_CASE("Preprocessor: DoubleHash '##' concatenates identifier and integer into single identifier token",
          "[preprocessor][tokenpaste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "P##1\n";
    pp.push_virtual_file(content, "paste_id_int", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool foundP1 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier) && t.text() == "P1") {
            foundP1 = true;
            break;
        }
    }
    REQUIRE(foundP1);
}

TEST_CASE("Preprocessor: DoubleHash '##' supports multiple pastes in the same line",
          "[preprocessor][tokenpaste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "A##B C##D\n";
    pp.push_virtual_file(content, "paste_multi", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool foundAB = false, foundCD = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            if (t.text() == "AB") {
                foundAB = true;
            }
            if (t.text() == "CD") {
                foundCD = true;
            }
        }
    }
    REQUIRE(foundAB);
    REQUIRE(foundCD);
}

// -----------------------------------------------------------------------------
// New tests for DEFL directive (both variants) and using previous value
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: DEFL infix 'name DEFL expr' defines and replaces symbol",
          "[preprocessor][defl][infix]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "idx DEFL 7\n"
        "idx\n";
    pp.push_virtual_file(content, "defl_infix", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 7);
}

TEST_CASE("Preprocessor: DEFL prefix 'DEFL name=expr' defines and replaces symbol",
          "[preprocessor][defl][prefix]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "DEFL count=9\n"
        "count\n";
    pp.push_virtual_file(content, "defl_prefix", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 9);
}

TEST_CASE("Preprocessor: DEFL can use previous value (DEFL index=index+1)",
          "[preprocessor][defl][previous]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "index DEFL 0\n"
        "DEFL index=index+1\n"
        "DEFL index=index+1\n"
        "index\n";
    pp.push_virtual_file(content, "defl_prev", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 2);
}

// -----------------------------------------------------------------------------
// New test: DEFL with non-constant expression stores macro-expanded body
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: DEFL stores non-constant expanded body (e.g., comma list) and expands at use sites",
          "[preprocessor][defl][nonconst]") {
    g_errors.reset();
    Preprocessor pp;

    // LIST expands to "10, 20" (a non-constant expression for eval_const_expr).
    // DEFL P=LIST should store the expanded body so that "db P" becomes "db 10,20".
    const std::string content =
        "#define A 10\n"
        "#define B 20\n"
        "#define LIST A, B\n"
        "DEFL P=LIST\n"
        "db P\n";
    pp.push_virtual_file(content, "defl_nonconst", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(
                line)); // expect the "db P" line after directives are consumed

    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 5);
    // First token should be the directive/identifier "db"
    REQUIRE(toks[0].text() == "db");

    // Collect integers and commas after "db"
    std::vector<int> ints;
    int commas = 0;
    for (size_t i = 1; i < toks.size(); ++i) {
        if (toks[i].is(TokenType::Integer)) {
            ints.push_back(toks[i].int_value());
        }
        else if (toks[i].is(TokenType::Comma)) {
            ++commas;
        }
    }

    REQUIRE(ints.size() == 2);
    REQUIRE(ints[0] == 10);
    REQUIRE(ints[1] == 20);
    REQUIRE(commas == 1);
}

// New tests: DEFINE accepts and ignores optional '=' before the body

TEST_CASE("Preprocessor: name DEFINE accepts optional '=' before object-like body",
          "[preprocessor][define][equals][object]") {
    // Form with space before '='
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "A DEFINE = 5\nA\n";
        pp.push_virtual_file(content, "def_eq_obj_spaced", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 5);
    }

    // Form without spaces around '='
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "B define=6\nB\n";
        pp.push_virtual_file(content, "def_eq_obj_nospaces", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 6);
    }
}

TEST_CASE("Preprocessor: DEFINE '=' with empty body expands to 1 (object and function forms)",
          "[preprocessor][define][equals][empty]") {
    // Object-like empty body with '='
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "E DEFINE =\nE\n";
        pp.push_virtual_file(content, "def_eq_empty_obj", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line)); // expanded "E"
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 1);
    }

    // Function-like empty body with '='
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "#define F(x)\nF(2)\n";
        pp.push_virtual_file(content, "def_eq_empty_func", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line)); // expanded "F(2)"
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 1);
    }
}

// New tests: DEFINE name = body (prefix form) accepts and ignores optional '=' before the body

TEST_CASE("Preprocessor: prefix DEFINE accepts optional '=' before object-like body",
          "[preprocessor][define][equals][prefix][object]") {
    // Spaced form: "DEFINE A = 5"
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "DEFINE A = 5\nA\n";
        pp.push_virtual_file(content, "def_prefix_eq_obj_spaced", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line)); // expanded "A"
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 5);
    }

    // Tight form: "DEFINE B=6"
    {
        g_errors.reset();
        Preprocessor pp;
        const std::string content = "DEFINE B=6\nB\n";
        pp.push_virtual_file(content, "def_prefix_eq_obj_nospaces", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line)); // expanded "B"
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == 6);
    }
}

TEST_CASE("Preprocessor: prefix DEFINE with '=' and empty body expands to 1",
          "[preprocessor][define][equals][prefix][empty]") {
    g_errors.reset();
    Preprocessor pp;

    // Object-like empty body: "DEFINE E ="
    const std::string content = "DEFINE E =\nE\n";
    pp.push_virtual_file(content, "def_prefix_eq_empty_obj", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expanded "E"
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 1);
}

TEST_CASE("Preprocessor: prefix DEFINE function-like accepts optional '=' before body",
          "[preprocessor][define][equals][prefix][function]") {
    g_errors.reset();
    Preprocessor pp;

    // Function-like: "DEFINE ID(x) = x"
    const std::string content =
        "DEFINE ID(x) = x\n"
        "ID(7)\n";
    pp.push_virtual_file(content, "def_prefix_eq_func", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expanded "ID(7)"
    const auto& toks = line.tokens();

    bool found7 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 7) {
            found7 = true;
            break;
        }
    }
    REQUIRE(found7);
}

// Synonym tests: UNDEFINE behaves the same as UNDEF

TEST_CASE("Preprocessor: name UNDEFINE removes macro (synonym to UNDEF)",
          "[preprocessor][define][undef][undefine][synonym]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "M define 42\nM UNDEFINE\nM\n";
    pp.push_virtual_file(content, "def_name_undefine", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    // After UNDEFINE the token should be the identifier 'M', not the expansion 42
    REQUIRE(toks[0].text() == "M");
}

TEST_CASE("Preprocessor: #UNDEFINE removes macro (synonym to #undef)",
          "[preprocessor][define][undef][undefine][synonym][hash]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "#define N 99\n#UNDEFINE N\nN\n";
    pp.push_virtual_file(content, "def_hash_undefine", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(!toks.empty());
    // After #UNDEFINE the token should be the identifier 'N', not the expansion 99
    REQUIRE(toks[0].text() == "N");
}

// -----------------------------------------------------------------------------
// MACRO multi-line expansion tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: MACRO (directive form) expands to multiple lines at call-site location",
          "[preprocessor][macro][multiline][location]") {
    g_errors.reset();
    Preprocessor pp;

    // Define a multi-line macro with one parameter, then set a logical location
    // and invoke it. Each expanded line must carry the macro call's location.
    const std::string content =
        "MACRO TWOLINES(x)\n"
        "one x\n"
        "two x\n"
        "ENDM\n"
        "LINE 123, \"callsite1.asm\"\n"
        "TWOLINES(5)\n"
        "after\n";
    pp.push_virtual_file(content, "macro_multiline_dir", 1, true);

    TokensLine line;

    // 1st expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "one");
    {
        bool has5 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 5) {
                has5 = true;
                break;
            }
        }
        REQUIRE(has5);
    }
    REQUIRE(line.location().line_num() == 123);
    REQUIRE(line.location().filename() == "callsite1.asm");

    // 2nd expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "two");
    {
        bool has5 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 5) {
                has5 = true;
                break;
            }
        }
        REQUIRE(has5);
    }
    REQUIRE(line.location().line_num() == 123);
    REQUIRE(line.location().filename() == "callsite1.asm");

    // Next line after macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after");
}

TEST_CASE("Preprocessor: MACRO (name-directive form) expands to multiple lines at call-site location",
          "[preprocessor][macro][multiline][location][name-directive]") {
    g_errors.reset();
    Preprocessor pp;

    // Define using the "<name> MACRO(...)" form, then set a logical location and invoke it.
    const std::string content =
        "TM MACRO(y)\n"
        "A y\n"
        "B y\n"
        "ENDM\n"
        "LINE 200, \"callsite2.asm\"\n"
        "TM(9)\n"
        "after2\n";
    pp.push_virtual_file(content, "macro_multiline_name", 1, true);

    TokensLine line;

    // 1st expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "A");
    {
        bool has9 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 9) {
                has9 = true;
                break;
            }
        }
        REQUIRE(has9);
    }
    REQUIRE(line.location().line_num() == 200);
    REQUIRE(line.location().filename() == "callsite2.asm");

    // 2nd expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "B");
    {
        bool has9 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 9) {
                has9 = true;
                break;
            }
        }
        REQUIRE(has9);
    }
    REQUIRE(line.location().line_num() == 200);
    REQUIRE(line.location().filename() == "callsite2.asm");

    // Next line after macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after2");
}

// -----------------------------------------------------------------------------
// MACRO header: parentheses around parameters are optional
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: MACRO header without parentheses (directive form) parses params and expands correctly",
          "[preprocessor][macro][params][optional-parens][directive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO NOPAREN a,b\n"
        "L1 a\n"
        "L2 b\n"
        "ENDM\n"
        "LINE 321, \"opt_paren1.asm\"\n"
        "NOPAREN(11,22)\n"
        "after_np\n";
    pp.push_virtual_file(content, "macro_params_no_paren_dir", 1, true);

    TokensLine line;

    // First expanded line: L1 11
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "L1");
    {
        bool has11 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 11) {
                has11 = true;
                break;
            }
        }
        REQUIRE(has11);
    }
    REQUIRE(line.location().line_num() == 321);
    REQUIRE(line.location().filename() == "opt_paren1.asm");

    // Second expanded line: L2 22
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "L2");
    {
        bool has22 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 22) {
                has22 = true;
                break;
            }
        }
        REQUIRE(has22);
    }
    REQUIRE(line.location().line_num() == 321);
    REQUIRE(line.location().filename() == "opt_paren1.asm");

    // Next line after macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_np");
}

TEST_CASE("Preprocessor: MACRO header without parentheses (name-directive form) parses params and expands correctly",
          "[preprocessor][macro][params][optional-parens][name-directive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "PAIR MACRO x,y\n"
        "A x\n"
        "B y\n"
        "ENDM\n"
        "LINE 654, \"opt_paren2.asm\"\n"
        "PAIR(7,8)\n"
        "after_pair\n";
    pp.push_virtual_file(content, "macro_params_no_paren_name", 1, true);

    TokensLine line;

    // First expanded line: A 7
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "A");
    {
        bool has7 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 7) {
                has7 = true;
                break;
            }
        }
        REQUIRE(has7);
    }
    REQUIRE(line.location().line_num() == 654);
    REQUIRE(line.location().filename() == "opt_paren2.asm");

    // Second expanded line: B 8
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "B");
    {
        bool has8 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 8) {
                has8 = true;
                break;
            }
        }
        REQUIRE(has8);
    }
    REQUIRE(line.location().line_num() == 654);
    REQUIRE(line.location().filename() == "opt_paren2.asm");

    // Next line after macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_pair");
}

// -----------------------------------------------------------------------------
// MACRO header: "MACRO name param1,param2" (no parentheses) is accepted
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: MACRO name param1,param2 (no parentheses) header is accepted and expands",
          "[preprocessor][macro][params][no-parens-header]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO H a,b\n"
        "LHS a\n"
        "RHS b\n"
        "ENDM\n"
        "LINE 77, \"hdr_noparen.asm\"\n"
        "H(3,4)\n"
        "done\n";
    pp.push_virtual_file(content, "macro_header_no_parens", 1, true);

    TokensLine line;

    // First expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "LHS");
    {
        bool has3 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 3) {
                has3 = true;
                break;
            }
        }
        REQUIRE(has3);
    }
    REQUIRE(line.location().line_num() == 77);
    REQUIRE(line.location().filename() == "hdr_noparen.asm");

    // Second expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "RHS");
    {
        bool has4 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 4) {
                has4 = true;
                break;
            }
        }
        REQUIRE(has4);
    }
    REQUIRE(line.location().line_num() == 77);
    REQUIRE(line.location().filename() == "hdr_noparen.asm");

    // After expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "done");
}

TEST_CASE("Preprocessor: MACRO name param1,param2 header and call without parentheses are accepted",
          "[preprocessor][macro][params][no-parens-header][no-parens-call]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO G x,y\n"
        "A x\n"
        "B y\n"
        "ENDM\n"
        "LINE 88, \"noparen_call.asm\"\n"
        "G 10,20\n"  // call without parentheses
        "end2\n";
    pp.push_virtual_file(content, "macro_header_call_no_parens", 1, true);

    TokensLine line;

    // First expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "A");
    {
        bool has10 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 10) {
                has10 = true;
                break;
            }
        }
        REQUIRE(has10);
    }
    REQUIRE(line.location().line_num() == 88);
    REQUIRE(line.location().filename() == "noparen_call.asm");

    // Second expanded line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "B");
    {
        bool has20 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 20) {
                has20 = true;
                break;
            }
        }
        REQUIRE(has20);
    }
    REQUIRE(line.location().line_num() == 88);
    REQUIRE(line.location().filename() == "noparen_call.asm");

    // After expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "end2");
}

// -----------------------------------------------------------------------------
// MACRO nesting: inner MACRO/ENDM in a macro body is defined when outer expands
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: nested MACRO (directive form) is defined during outer expansion",
          "[preprocessor][macro][nested][directive-inner]") {
    g_errors.reset();
    Preprocessor pp;

    // OUT defines an inner macro IN(a) in its body. Calling OUT() must define IN,
    // so the subsequent IN(12) expands to two lines at the call-site location.
    const std::string content =
        "MACRO OUT()\n"
        "MACRO IN(a)\n"
        "L a\n"
        "M a\n"
        "ENDM\n"
        "ENDM\n"
        "LINE 500, \"nested_dir_inner.asm\"\n"
        "OUT()\n"
        "IN(12)\n"
        "after_nested\n";
    pp.push_virtual_file(content, "macro_nested_dir_inner", 1, true);

    TokensLine line;

    // Expect expansion of IN(12) produced by the nested macro definition
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "L");
    {
        bool has12 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 12) {
                has12 = true;
                break;
            }
        }
        REQUIRE(has12);
    }
    REQUIRE(line.location().line_num() == 501);
    REQUIRE(line.location().filename() == "nested_dir_inner.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "M");
    {
        bool has12 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 12) {
                has12 = true;
                break;
            }
        }
        REQUIRE(has12);
    }
    REQUIRE(line.location().line_num() == 501);
    REQUIRE(line.location().filename() == "nested_dir_inner.asm");

    // Next ordinary line after the nested macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_nested");
}

TEST_CASE("Preprocessor: nested MACRO (name-directive form) is defined during outer expansion",
          "[preprocessor][macro][nested][name-inner]") {
    g_errors.reset();
    Preprocessor pp;

    // OUTN defines inner macro INN(t) using the name-directive form. After OUTN(),
    // INN(3) must be recognized and expanded at the call-site location.
    const std::string content =
        "MACRO OUTN()\n"
        "INN MACRO(t)\n"
        "X t\n"
        "Y t\n"
        "ENDM\n"
        "ENDM\n"
        "LINE 600, \"nested_name_inner.asm\"\n"
        "OUTN()\n"
        "INN(3)\n"
        "tail\n";
    pp.push_virtual_file(content, "macro_nested_name_inner", 1, true);

    TokensLine line;

    // First expanded line from INN(3)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "X");
    {
        bool has3 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 3) {
                has3 = true;
                break;
            }
        }
        REQUIRE(has3);
    }
    REQUIRE(line.location().line_num() == 601);
    REQUIRE(line.location().filename() == "nested_name_inner.asm");

    // Second expanded line from INN(3)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "Y");
    {
        bool has3 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 3) {
                has3 = true;
                break;
            }
        }
        REQUIRE(has3);
    }
    REQUIRE(line.location().line_num() == 601);
    REQUIRE(line.location().filename() == "nested_name_inner.asm");

    // Next ordinary line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "tail");
}

// -----------------------------------------------------------------------------
// Macro arguments: argument may expand to multiple lines before insertion
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: function-like macro argument can expand to multiple lines (parenthesized call)",
          "[preprocessor][macro][args][multiline]") {
    g_errors.reset();
    Preprocessor pp;

    // INNER() expands to two lines: "A" and "B".
    // OUTER(x) pastes its single argument as-is; calling OUTER(INNER())
    // must yield both lines from INNER at the call-site location.
    const std::string content =
        "MACRO INNER()\n"
        "A\n"
        "B\n"
        "ENDM\n"
        "MACRO OUTER(x)\n"
        "x\n"
        "ENDM\n"
        "LINE 700, \"arg_multiline_1.asm\"\n"
        "OUTER(INNER())\n"
        "after_ml\n";
    pp.push_virtual_file(content, "macro_arg_multiline_paren", 1, true);

    TokensLine line;

    // First line from INNER()
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "A");
    REQUIRE(line.location().line_num() == 700);
    REQUIRE(line.location().filename() == "arg_multiline_1.asm");

    // Second line from INNER()
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "B");
    REQUIRE(line.location().line_num() == 700);
    REQUIRE(line.location().filename() == "arg_multiline_1.asm");

    // Line after the macro call
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_ml");
}

TEST_CASE("Preprocessor: function-like macro argument can expand to multiple lines (unparenthesized call)",
          "[preprocessor][macro][args][multiline][no-parens-call]") {
    g_errors.reset();
    Preprocessor pp;

    // Same as previous test but call OUT without parentheses:
    // "OUT INNER()" -> the argument is the token sequence INNER().
    const std::string content =
        "MACRO INNER()\n"
        "X\n"
        "Y\n"
        "ENDM\n"
        "MACRO OUT(z)\n"
        "z\n"
        "ENDM\n"
        "LINE 710, \"arg_multiline_2.asm\"\n"
        "OUT INNER()\n"
        "after_ml2\n";
    pp.push_virtual_file(content, "macro_arg_multiline_noparen", 1, true);

    TokensLine line;

    // First line from INNER()
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "X");
    REQUIRE(line.location().line_num() == 710);
    REQUIRE(line.location().filename() == "arg_multiline_2.asm");

    // Second line from INNER()
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "Y");
    REQUIRE(line.location().line_num() == 710);
    REQUIRE(line.location().filename() == "arg_multiline_2.asm");

    // Line after the macro call
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_ml2");
}

// -----------------------------------------------------------------------------
// Additional tests: ensure token-paste result is recognized as a macro name
// and expanded when appropriate.
// -----------------------------------------------------------------------------
TEST_CASE("Preprocessor: DoubleHash '##' glue produces an identifier that expands to an object-like macro",
          "[preprocessor][tokenpaste][macro][object]") {
    g_errors.reset();
    Preprocessor pp;

    // Define object-like macro AB -> 777, then use token paste A ## B
    const std::string content =
        "#define AB 777\n"
        "A ## B\n";
    pp.push_virtual_file(content, "paste_then_expand_obj", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool found777 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 777) {
            found777 = true;
            break;
        }
    }
    REQUIRE(found777);
}

TEST_CASE("Preprocessor: DoubleHash '##' glue produces an identifier that expands to a function-like macro when followed by parentheses",
          "[preprocessor][tokenpaste][macro][function]") {
    g_errors.reset();
    Preprocessor pp;

    // Define function-like macro P1(x) -> x, then paste P ## 1 and call it with (99)
    const std::string content =
        "#define P1(x) x\n"
        "P##1(99)\n";
    pp.push_virtual_file(content, "paste_then_expand_func", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool found99 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 99) {
            found99 = true;
            break;
        }
    }
    REQUIRE(found99);
}

TEST_CASE("Preprocessor: DoubleHash '##' glue with identifier+integer produces macro name and expands correctly",
          "[preprocessor][tokenpaste][macro][idint]") {
    g_errors.reset();
    Preprocessor pp;

    // Define macro Q2 -> 202, then use token paste Q ## 2
    const std::string content =
        "#define Q2 202\n"
        "Q ## 2\n";
    pp.push_virtual_file(content, "paste_id_int_expand", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool found202 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 202) {
            found202 = true;
            break;
        }
    }
    REQUIRE(found202);
}

// -----------------------------------------------------------------------------
// NEW TESTS: LOCAL symbol support inside macros
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: LOCAL inside macro renames local symbols on each expansion (labels)",
          "[preprocessor][macro][local][labels]") {
    g_errors.reset();
    Preprocessor pp;

    // Macro defines local label 'L' and uses it. Each expansion should rename L -> L_1, L_2, ...
    const std::string content =
        "MACRO M()\n"
        "LOCAL L\n"
        "L: nop\n"
        "ENDM\n"
        "LINE 900, \"local_labels.asm\"\n"
        "M()\n"
        "M()\n"
        "after_local\n";
    pp.push_virtual_file(content, "macro_local_labels", 1, true);

    TokensLine line;

    // First expansion: label line ('. L_1') then 'nop' line
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() == "L_1");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    // instruction 'nop' should follow (label removed from instruction line)
    bool saw_nop = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "nop") {
            saw_nop = true;
            break;
        }
    }
    REQUIRE(saw_nop);

    // Second expansion: label 'L_2'
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() == "L_2");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    saw_nop = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "nop") {
            saw_nop = true;
            break;
        }
    }
    REQUIRE(saw_nop);

    // After expansions: next original line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_local");
}

TEST_CASE("Preprocessor: LOCAL inside macro renames identifiers (non-labels) per expansion",
          "[preprocessor][macro][local][idents]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO U(x)\n"
        "LOCAL tmp\n"
        "mov tmp, x\n"
        "ENDM\n"
        "LINE 910, \"local_idents.asm\"\n"
        "U(5)\n"
        "U(6)\n"
        "done_local\n";
    pp.push_virtual_file(content, "macro_local_idents", 1, true);

    TokensLine line;

    // First expansion: mov tmp_1,5  (tmp renamed)
    REQUIRE(pp.next_line(line));
    bool found_mov = false, found_tmp1 = false, found_5 = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "mov") {
            found_mov = true;
        }
        if (t.text() == "tmp_1") {
            found_tmp1 = true;
        }
        if (t.is(TokenType::Integer) && t.int_value() == 5) {
            found_5 = true;
        }
    }
    REQUIRE(found_mov);
    REQUIRE(found_tmp1);
    REQUIRE(found_5);

    // Second expansion: mov tmp_2,6
    REQUIRE(pp.next_line(line));
    found_mov = found_tmp1 = found_5 = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "mov") {
            found_mov = true;
        }
        if (t.text() == "tmp_2") {
            found_tmp1 = true;
        }
        if (t.is(TokenType::Integer) && t.int_value() == 6) {
            found_5 = true;
        }
    }
    REQUIRE(found_mov);
    REQUIRE(found_tmp1);
    REQUIRE(found_5);

    // After expansions
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "done_local");
}

// New test: LOCAL outside a macro definition is ignored (not emitted)
TEST_CASE("Preprocessor: LOCAL outside macro definition is ignored",
          "[preprocessor][local][outside]") {
    g_errors.reset();
    Preprocessor pp;

    // LOCAL appears outside any MACRO; it should be treated as a directive-like
    // construct and not produce any output line. Only the subsequent 'after' line
    // should be returned by the preprocessor.
    const std::string content =
        "LOCAL tmp\n"
        "after\n";
    pp.push_virtual_file(content, "local_outside_test", 1, true);

    TokensLine line;

    // First returned logical line must be the 'after' line.
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after");

    // No further output expected.
    REQUIRE(!pp.next_line(line));

    // No errors should have been reported.
    REQUIRE(!g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// MACRO local symbols in nested macros
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: nested LOCAL - only top-level LOCAL is handled; inner LOCAL handled when sub-macro is parsed",
          "[preprocessor][macro][local][nested]") {
    g_errors.reset();
    Preprocessor pp;

    // OUT has its own LOCAL L and defines a sub-macro IN with its own LOCAL J.
    // Only L is handled during OUT() expansion. J is handled when IN() is parsed/defined,
    // and renamed when IN() is expanded.
    const std::string content =
        "MACRO OUT()\n"
        "LOCAL L\n"
        "L: nop\n"
        "MACRO IN()\n"
        "LOCAL J\n"
        "J: nop\n"
        "ENDM\n"
        "ENDM\n"
        "LINE 1000, \"local_nested.asm\"\n"
        "OUT()\n"
        "IN()\n"
        "after_nested_locals\n";
    pp.push_virtual_file(content, "macro_local_nested", 1, true);

    TokensLine line;

    // OUT() expansion at call-site line 1000
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() == "L_1");
    REQUIRE(line.location().line_num() == 1000);
    REQUIRE(line.location().filename() == "local_nested.asm");

    REQUIRE(pp.next_line(line));
    {
        bool saw_nop = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "nop") {
                saw_nop = true;
                break;
            }
        }
        REQUIRE(saw_nop);
    }
    REQUIRE(line.location().line_num() == 1000);
    REQUIRE(line.location().filename() == "local_nested.asm");

    // IN() is invoked on the next physical line -> call-site line 1001
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() ==
            "J_2"); // inner local renamed on its own expansion
    REQUIRE(line.location().line_num() == 1001);
    REQUIRE(line.location().filename() == "local_nested.asm");

    REQUIRE(pp.next_line(line));
    {
        bool saw_nop = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "nop") {
                saw_nop = true;
                break;
            }
        }
        REQUIRE(saw_nop);
    }
    REQUIRE(line.location().line_num() == 1001);
    REQUIRE(line.location().filename() == "local_nested.asm");

    // Next ordinary line
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after_nested_locals");
}

// -----------------------------------------------------------------------------
// NEW TESTS: EXITM
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: EXITM inside MACRO aborts the current macro expansion",
          "[preprocessor][macro][exitm]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M()\n"
        "A\n"
        "EXITM\n"
        "B\n"
        "ENDM\n"
        "LINE 111, \"exitm_call.asm\"\n"
        "M()\n"
        "after\n";
    pp.push_virtual_file(content, "exitm_test", 1, true);

    TokensLine line;

    // Only the lines before EXITM ("A") should be emitted from the macro
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "A");
    REQUIRE(line.location().line_num() == 111);
    REQUIRE(line.location().filename() == "exitm_call.asm");

    // Next should be the line after the macro call in the original file
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after");
}

TEST_CASE("Preprocessor: EXITM outside of macro is ignored",
          "[preprocessor][exitm][outside]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "EXITM\n"
        "X\n";
    pp.push_virtual_file(content, "exitm_outside", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "X");

    // No other lines
    REQUIRE(!pp.next_line(line));
    REQUIRE(!g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Macro redefinition diagnostics
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: #define redefines existing #define -> MacroRedefined error",
          "[preprocessor][define][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 1\n"
        "#define A 2\n"
        "A\n";
    pp.push_virtual_file(content, "redef_define_hash", 1, true);

    TokensLine line;
    // Consume all lines so diagnostics are emitted
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("A") != std::string::npos);
}

TEST_CASE("Preprocessor: name define redefines existing define -> MacroRedefined error",
          "[preprocessor][define][name][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "B define 10\n"
        "B define 20\n"
        "B\n";
    pp.push_virtual_file(content, "redef_define_name", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("B") != std::string::npos);
}

TEST_CASE("Preprocessor: MACRO (directive form) redefines existing MACRO -> MacroRedefined error",
          "[preprocessor][macro][directive][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M()\n"
        "ENDM\n"
        "MACRO M()\n"
        "ENDM\n"
        "M()\n";
    pp.push_virtual_file(content, "redef_macro_dir", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("M") != std::string::npos);
}

TEST_CASE("Preprocessor: MACRO (name-directive form) redefines existing MACRO -> MacroRedefined error",
          "[preprocessor][macro][name][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "N MACRO()\n"
        "ENDM\n"
        "N MACRO()\n"
        "ENDM\n"
        "N()\n";
    pp.push_virtual_file(content, "redef_macro_name", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("N") != std::string::npos);
}

TEST_CASE("Preprocessor: mixed redefinitions (#define then MACRO, and MACRO then #define) produce MacroRedefined",
          "[preprocessor][macro][define][mixed][redefine][error]") {
    // #define first, then MACRO
    {
        g_errors.reset();
        Preprocessor pp;

        const std::string content =
            "#define X 1\n"
            "MACRO X()\n"
            "ENDM\n"
            "X\n";
        pp.push_virtual_file(content, "redef_mixed_def_then_macro", 1, true);

        TokensLine line;
        while (pp.next_line(line)) {}

        REQUIRE(g_errors.has_errors());
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Macro redefined") != std::string::npos);
        REQUIRE(msg.find("X") != std::string::npos);
    }

    // MACRO first, then #define
    {
        g_errors.reset();
        Preprocessor pp;

        const std::string content =
            "MACRO Y()\n"
            "ENDM\n"
            "#define Y 2\n"
            "Y\n";
        pp.push_virtual_file(content, "redef_mixed_macro_then_def", 1, true);

        TokensLine line;
        while (pp.next_line(line)) {}

        REQUIRE(g_errors.has_errors());
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Macro redefined") != std::string::npos);
        REQUIRE(msg.find("Y") != std::string::npos);
    }
}

TEST_CASE("Preprocessor: DEFL redefinition does NOT raise MacroRedefined",
          "[preprocessor][defl][redefine][noerror]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "Z DEFL 1\n"
        "Z DEFL 2\n"
        "Z\n";
    pp.push_virtual_file(content, "redef_defl", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    // DEFL redefinitions should not be flagged as MacroRedefined
    REQUIRE(!g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Preprocessor::define_macro(string content) multi-line expansion tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: define_macro from string content with multiple lines expands at call-site location",
          "[preprocessor][define_macro][string][multiline]") {
    g_errors.reset();
    Preprocessor pp;

    // Build a multi-line macro body from a string (two lines).
    const std::string macro_text =
        "LHS 10\n"
        "RHS 20\n";

    // Tokenize the string and define an object-like macro that expands to multiple lines.
    // This emulates Preprocessor::define_macro(name, std::string).
    TokensFile tf(macro_text, "<macro_define_string>", 1, false);
    pp.define_macro("ML", tf.tok_lines());

    // Use a LINE directive to fix the call-site logical location and then invoke the macro.
    const std::string content =
        "LINE 777, \"call_ml.asm\"\n"
        "ML\n"
        "tail\n";
    pp.push_virtual_file(content, "ml_call_site", 1, true);

    TokensLine line;

    // First expanded line: "LHS 10"
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "LHS");
    {
        bool has10 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 10) {
                has10 = true;
                break;
            }
        }
        REQUIRE(has10);
    }
    REQUIRE(line.location().line_num() == 777);
    REQUIRE(line.location().filename() == "call_ml.asm");

    // Second expanded line: "RHS 20"
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "RHS");
    {
        bool has20 = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && t.int_value() == 20) {
                has20 = true;
                break;
            }
        }
        REQUIRE(has20);
    }
    REQUIRE(line.location().line_num() == 777);
    REQUIRE(line.location().filename() == "call_ml.asm");

    // Next original line after the macro expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "tail");
}

TEST_CASE("Preprocessor: define_macro from string content with label splits label and keeps call-site location",
          "[preprocessor][define_macro][string][label][multiline]") {
    g_errors.reset();
    Preprocessor pp;

    // Macro content includes a label and two instructions.
    const std::string macro_text =
        "LBL: nop\n"
        "ret\n";

    // Tokenize string and define macro.
    TokensFile tf(macro_text, "<macro_define_label>", 1, false);
    pp.define_macro("BLK", tf.tok_lines());

    // Fix call-site location and invoke the macro.
    const std::string content =
        "LINE 1234, \"call_define_label.asm\"\n"
        "BLK\n"
        "after\n";
    pp.push_virtual_file(content, "blk_call_site", 1, true);

    TokensLine line;

    // Label line emitted first: ". LBL"
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() == "LBL");
    REQUIRE(line.location().line_num() == 1234);
    REQUIRE(line.location().filename() == "call_define_label.asm");

    // Instruction line following the label: "nop"
    REQUIRE(pp.next_line(line));
    {
        bool saw_nop = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "nop") {
                saw_nop = true;
                break;
            }
        }
        REQUIRE(saw_nop);
    }
    REQUIRE(line.location().line_num() == 1234);
    REQUIRE(line.location().filename() == "call_define_label.asm");

    // Second instruction line: "ret"
    REQUIRE(pp.next_line(line));
    {
        bool saw_ret = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "ret") {
                saw_ret = true;
                break;
            }
        }
        REQUIRE(saw_ret);
    }
    REQUIRE(line.location().line_num() == 1234);
    REQUIRE(line.location().filename() == "call_define_label.asm");

    // Next original line after expansion
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after");
}

// -----------------------------------------------------------------------------
// Preprocessor::define_macro(name, string) - multi-line content expands properly
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: define_macro(name, string) expands multi-line body at call-site location",
          "[preprocessor][define_macro][string][multiline]") {
    g_errors.reset();
    Preprocessor pp;

    // Define an object-like macro from a raw multi-line string
    pp.define_macro("S", "text\nwith\nseveral\nlines");

    // Fix the call-site location; invoking S should emit four lines at line 42
    const std::string content =
        "LINE 42, \"call_define_string.asm\"\n"
        "S\n"
        "after\n";
    pp.push_virtual_file(content, "define_string_call", 1, true);

    TokensLine line;

    const std::vector<std::string> expected = { "text", "with", "several", "lines" };
    for (const auto& word : expected) {
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.tokens().empty());
        REQUIRE(line.tokens()[0].text() == word);
        REQUIRE(line.location().line_num() == 42);
        REQUIRE(line.location().filename() == "call_define_string.asm");
    }

    // Next ordinary line from the original file
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "after");
}

// -----------------------------------------------------------------------------
// define_macro API redefinition diagnostics
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: define_macro(name, string) reports MacroRedefined on redefinition",
          "[preprocessor][define_macro][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    pp.define_macro("A", "1\n");
    pp.define_macro("A", "2\n"); // redefinition should be reported

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("A") != std::string::npos);
}

TEST_CASE("Preprocessor: define_macro(name, tok_lines) reports MacroRedefined on redefinition",
          "[preprocessor][define_macro][vector][redefine][error]") {
    g_errors.reset();
    Preprocessor pp;

    // first definition via tok_lines
    {
        TokensFile tf("X 10\n", "<macro_vec_1>", 1, false);
        pp.define_macro("B", tf.tok_lines());
    }

    // second definition via tok_lines (same name) triggers error
    {
        TokensFile tf2("X 20\n", "<macro_vec_2>", 1, false);
        pp.define_macro("B", tf2.tok_lines());
    }

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Macro redefined") != std::string::npos);
    REQUIRE(msg.find("B") != std::string::npos);
}

// ... existing tests ...

// -----------------------------------------------------------------------------
// REPT directive tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: REPT with zero and negative counts emits no lines",
          "[preprocessor][rept][zero][negative]") {
    // Zero count
    {
        g_errors.reset();
        Preprocessor pp;

        const std::string content =
            "REPT 0\n"
            "Z0\n"
            "ENDR\n"
            "after0\n";
        pp.push_virtual_file(content, "rept_zero", 1, true);

        TokensLine line;

        // First returned line should be the one after the REPT block (no Z0 lines)
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.tokens().empty());
        REQUIRE(line.tokens()[0].text() == "after0");

        // No further lines
        REQUIRE(!pp.next_line(line));
        // No errors expected
        REQUIRE(!g_errors.has_errors());
    }

    // Negative count
    {
        g_errors.reset();
        Preprocessor pp;

        const std::string content =
            "REPT -3\n"
            "NEG\n"
            "ENDR\n"
            "after_neg\n";
        pp.push_virtual_file(content, "rept_negative", 1, true);

        TokensLine line;

        // First returned line should be the one after the REPT block (no NEG lines)
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.tokens().empty());
        REQUIRE(line.tokens()[0].text() == "after_neg");

        // No further lines
        REQUIRE(!pp.next_line(line));
        // No errors expected
        REQUIRE(!g_errors.has_errors());
    }
}

TEST_CASE("Preprocessor: REPT with non-constant expression is rejected and body consumed",
          "[preprocessor][rept][error][nonconst]") {
    g_errors.reset();
    Preprocessor pp;

    // 'A' is undefined -> non-constant expression for REPT count
    const std::string content =
        "REPT A\n"
        "X\n"
        "ENDR\n";
    pp.push_virtual_file(content, "rept_nonconst", 1, true);

    TokensLine line;
    // Consume any produced lines (none expected)
    int produced = 0;
    while (pp.next_line(line)) {
        ++produced;
    }

    REQUIRE(produced == 0);
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Constant expression expected in REPT") != std::string::npos);
    REQUIRE(msg.find("rept_nonconst:1:") != std::string::npos);
}

TEST_CASE("Preprocessor: nested REPT repeats inner body correctly",
          "[preprocessor][rept][nested]") {
    g_errors.reset();
    Preprocessor pp;

    // Outer repeats 2x; inner repeats 3x -> total 6 lines "N"
    const std::string content =
        "REPT 2\n"
        "REPT 3\n"
        "N\n"
        "ENDR\n"
        "ENDR\n";
    pp.push_virtual_file(content, "rept_nested", 1, true);

    TokensLine line;
    int countN = 0;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (!toks.empty() && toks[0].text() == "N") {
            ++countN;
        }
    }

    REQUIRE(countN == 6);
    // No errors expected
    REQUIRE(!g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// REPTC directive tests (both syntaxes; string, number and token-sequence args)
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: REPTC (directive) with string argument produces character codes",
          "[preprocessor][reptc][directive][string]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPTC var, \"ABC\"\n"
        "defb var\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_dir_string", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    // 'A','B','C'
    REQUIRE(ints == std::vector<int>({ 'A', 'B', 'C' }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC (name-directive) with string argument produces character codes",
          "[preprocessor][reptc][name][string]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "ch REPTC \"XY\"\n"
        "defb ch\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_name_string", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    // 'X','Y'
    REQUIRE(ints == std::vector<int>({ 'X', 'Y' }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC (directive) with numeric argument iterates over decimal digits",
          "[preprocessor][reptc][directive][number]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPTC d, 2305\n"
        "defb d\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_dir_number", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    // '2','3','0','5'
    REQUIRE(ints == std::vector<int>({ '2', '3', '0', '5' }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC (name-directive) with numeric argument iterates over decimal digits",
          "[preprocessor][reptc][name][number]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "v REPTC 47\n"
        "defb v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_name_number", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    // '4','7'
    REQUIRE(ints == std::vector<int>({ '4', '7' }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC (directive) with identifier token sequence produces character codes",
          "[preprocessor][reptc][directive][tokens]") {
    g_errors.reset();
    Preprocessor pp;

    // Bare identifier "hello" becomes the sequence 'h','e','l','l','o'
    const std::string content =
        "REPTC var, hello\n"
        "defb var\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_dir_ident", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    const std::vector<int> expected = { 'h', 'e', 'l', 'l', 'o' };
    REQUIRE(ints == expected);
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC (name-directive) with identifier token sequence produces character codes",
          "[preprocessor][reptc][name][tokens]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "x REPTC world\n"
        "defb x\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_name_ident", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    const std::vector<int> expected = { 'w', 'o', 'r', 'l', 'd' };
    REQUIRE(ints == expected);
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC accepts token-paste macro result as the string source (directive form)",
          "[preprocessor][reptc][directive][tokens][paste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define cat(a, b) a ## b\n"
        "REPTC v, cat(hell, o)\n"
        "defb v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_dir_cat", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    const std::vector<int> expected = { 'h', 'e', 'l', 'l', 'o' };
    REQUIRE(ints == expected);
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC accepts token-paste macro result as the string source (name-directive form)",
          "[preprocessor][reptc][name][tokens][paste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define cat(a, b) a ## b\n"
        "v REPTC cat(AB, C)\n"
        "defb v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_name_cat", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    const std::vector<int> expected = { 'A', 'B', 'C' };
    REQUIRE(ints == expected);
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC with DEFL numeric symbol iterates over digits",
          "[preprocessor][reptc][defl][number]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "DEFL version=23\n"
        "REPTC var, version\n"
        "defb var\n"
        "ENDR\n";
    pp.push_virtual_file(content, "reptc_defl_number", 1, true);

    TokensLine line;
    std::vector<int> ints;
    while (pp.next_line(line)) {
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                ints.push_back(t.int_value());
            }
        }
    }
    // '2','3'
    REQUIRE(ints == std::vector<int>({ '2', '3' }));
    REQUIRE(!g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// REPTI directive tests (both syntaxes; macro expansion, token-paste, nesting)
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: REPTI (directive) enumerates identifier list into body",
          "[preprocessor][repti][directive][idents]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPTI reg, bc, de, hl, af\n"
        "push reg\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_dir_idents", 1, true);

    TokensLine line;
    std::vector<std::string> seen;
    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "push");
        REQUIRE(toks[1].is(TokenType::Whitespace));
        seen.push_back(toks[2].text());
    }

    REQUIRE(seen == std::vector<std::string>({ "bc", "de", "hl", "af" }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI (name-directive) enumerates identifier list into body",
          "[preprocessor][repti][name][idents]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "r REPTI ix, iy\n"
        "use r\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_name_idents", 1, true);

    TokensLine line;
    std::vector<std::string> seen;
    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "use");
        REQUIRE(toks[1].is(TokenType::Whitespace));
        seen.push_back(toks[2].text());
    }

    REQUIRE(seen == std::vector<std::string>({ "ix", "iy" }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI duplicates body for integer expression arguments (no evaluation, textual)",
          "[preprocessor][repti][directive][numbers]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPTI v, 10, 20+1\n"
        "db v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_dir_numbers", 1, true);

    TokensLine line;
    int line_no = 0;
    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        REQUIRE(!toks.empty());
        REQUIRE(toks[0].text() == "db");
        REQUIRE(toks[1].is(TokenType::Whitespace));
        if (line_no == 0) {
            REQUIRE(toks.size() >= 3);
            REQUIRE(toks[2].is(TokenType::Integer));
            REQUIRE(toks[2].int_value() == 10);
        }
        else if (line_no == 1) {
            REQUIRE(toks.size() >= 4);
            REQUIRE(toks[2].is(TokenType::Integer));
            REQUIRE(toks[2].int_value() == 20);
            REQUIRE(toks[3].text() == "+");
            REQUIRE(toks[4].is(TokenType::Integer));
            REQUIRE(toks[4].int_value() == 1);
        }
        else {
            // Only two output lines expected
            REQUIRE(false);
        }
        ++line_no;
    }
    REQUIRE(line_no == 2);
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI expands macros in arguments before substitution",
          "[preprocessor][repti][macro-arg]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define R1 bc\n"
        "#define R2 de\n"
        "REPTI r, R1, R2\n"
        "push r\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_dir_macro_args", 1, true);

    TokensLine line;
    std::vector<std::string> seen;
    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "push");
        REQUIRE(toks[1].is(TokenType::Whitespace));
        seen.push_back(toks[2].text());
    }

    REQUIRE(seen == std::vector<std::string>({ "bc", "de" }));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI argument can be a macro producing multiple tokens",
          "[preprocessor][repti][macro-arg][multitokens]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define EXPR 1 + 2\n"
        "REPTI x, EXPR\n"
        "X x\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_dir_macro_expr", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 7);
    REQUIRE(toks[0].text() == "X");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 1);
    REQUIRE(toks[3].is(TokenType::Whitespace));
    REQUIRE(toks[4].text() == "+");
    REQUIRE(toks[5].is(TokenType::Whitespace));
    REQUIRE(toks[6].is(TokenType::Integer));
    REQUIRE(toks[6].int_value() == 2);
    REQUIRE(!pp.next_line(line));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI accepts token-paste result in argument via macro",
          "[preprocessor][repti][tokens][paste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define cat(a,b) a ## b\n"
        "REPTI reg, cat(H, L)\n"
        "push reg\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_dir_cat", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 3);
    REQUIRE(toks[0].text() == "push");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "HL");
    REQUIRE(!pp.next_line(line));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI accepts token-paste in name-directive form via macro",
          "[preprocessor][repti][name][tokens][paste]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define cat(a,b) a ## b\n"
        "r REPTI cat(A, B)\n"
        "emit r\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_name_cat", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();
    REQUIRE(toks.size() >= 3);
    REQUIRE(toks[0].text() == "emit");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "AB");
    REQUIRE(!pp.next_line(line));
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Preprocessor: nested REPTI duplicates body for the cartesian product of arguments",
          "[preprocessor][repti][nested]") {
    g_errors.reset();
    Preprocessor pp;

    // Outer over 1,2; inner over A,B -> pairs in order:
    // (1,A), (1,B), (2,A), (2,B)
    const std::string content =
        "REPTI o, 1, 2\n"
        "REPTI i, A, B\n"
        "PAIR o i\n"
        "ENDR\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_nested", 1, true);

    TokensLine line;
    std::vector<std::pair<int, std::string>> pairs;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.empty()) {
            continue;
        }
        REQUIRE(toks.size() >= 5);
        REQUIRE(toks[0].text() == "PAIR");
        REQUIRE(toks[1].is(TokenType::Whitespace));
        REQUIRE(toks[2].is(TokenType::Integer));
        int left = toks[2].int_value();
        REQUIRE(toks[3].is(TokenType::Whitespace));
        REQUIRE(toks[4].is(TokenType::Identifier));
        std::string right = toks[4].text();
        pairs.emplace_back(left, right);
    }

    REQUIRE(pairs.size() == 4);
    REQUIRE(pairs[0] == std::make_pair(1, std::string("A")));
    REQUIRE(pairs[1] == std::make_pair(1, std::string("B")));
    REQUIRE(pairs[2] == std::make_pair(2, std::string("A")));
    REQUIRE(pairs[3] == std::make_pair(2, std::string("B")));
    REQUIRE(!g_errors.has_errors());
}
