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

// New tests: LINE directive handling and errors

TEST_CASE("Preprocessor: LINE <n> sets logical line numbers for following lines",
          "[preprocessor][line]") {
    g_errors.reset();
    Preprocessor pp;

    // LINE 100 then two ordinary lines
    const std::string content = "LINE 100\nfirst_line\nsecond_line\n";
    pp.push_virtual_file(content, "line_test", 1);

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
    pp.push_virtual_file(content, "orig_file", 1);

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
    pp.push_virtual_file(content, "line_missing_arg", 1);

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
    pp.push_virtual_file(content, "cline_test", 1);

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
    pp.push_virtual_file(content, "orig_c_line", 1);

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
    pp.push_virtual_file(content, "cline_missing_arg", 1);

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
    pp.push_binary_file(fname);

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

    pp.push_virtual_file(content, "virtual_binary_dir", 1);

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

    pp.push_virtual_file(content, "virtual_incbin_dir", 1);

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

    pp.push_virtual_file(content, "virtual_line_forms", 1);

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

    pp.push_virtual_file(content, "virtual_cline_forms", 1);

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

    pp.push_virtual_file(content, "virtual_binary_forms", 1);

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

    pp.push_virtual_file(content, "virtual_incbin_forms", 1);

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
        pp.push_virtual_file(content, "def_obj_hash", 1);

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
        pp.push_virtual_file(content, "def_obj_name", 1);

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
        pp.push_virtual_file(content, "def_func_arg_expand", 1);

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
        pp.push_virtual_file(content, "def_func_multiarg", 1);

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
        pp.push_virtual_file(content, "def_empty_hash", 1);

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
        pp.push_virtual_file(content, "def_empty_name", 1);

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
        pp.push_virtual_file(content, "def_empty_func", 1);

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
    pp.push_virtual_file(content, "def_recursion", 1);

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
    pp.push_virtual_file(content, "def_name_undef", 1);

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
    pp.push_virtual_file(content, "def_hash_undef", 1);

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
    pp.push_virtual_file(content, "str_simple", 1);

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
    pp.push_virtual_file(content, "str_unexpanded", 1);

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
    pp.push_virtual_file(content, "str_escape", 1);

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
    pp.push_virtual_file(content, "str_space", 1);

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
    pp.push_virtual_file(content, "comment_single", 1);

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
    pp.push_virtual_file(content, "comment_multi", 1);

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
    pp.push_virtual_file(content, "paste_ids", 1);

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
    pp.push_virtual_file(content, "paste_id_int", 1);

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
    pp.push_virtual_file(content, "paste_multi", 1);

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
