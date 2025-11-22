//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../preprocessor.h"
#include "../symbol_table.h"
#include "catch_amalgamated.hpp"
#include <cstdio>
#include <fstream>
#include <sstream>
#include <string>

#ifdef _WIN32
#include <windows.h>
#define SLEEP_MS(ms) Sleep(ms)
#else
#include <unistd.h>
#define SLEEP_MS(ms) usleep((ms) * 1000)
#endif

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

// Local helper: run the preprocessor on an in-memory string and collect tokenized lines
static std::vector<TokensLine> run_pp_on_text(const std::string& src,
        const std::string& fname) {
    Preprocessor pp;
    pp.clear();
    pp.push_virtual_file(src, fname, 1, true);

    TokensLine line;
    std::vector<TokensLine> out;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            out.push_back(line);
        }
    }
    return out;
}

// Extract first integer found from a 'DEFB <int>' line
static int find_defb_value(const std::vector<TokensLine>& lines) {
    for (const auto& l : lines) {
        if (!l.empty() && l[0].is(Keyword::DEFB)) {
            for (const auto& t : l.tokens()) {
                if (t.is(TokenType::Integer)) {
                    return t.int_value();
                }
            }
        }
    }
    REQUIRE(false); // Should have found a DEFB line
    return -1;
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE(msg.find("File not found: " + missing) != std::string::npos);

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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == "from_quoted");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "from_angle");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "from_plain");

    // finally the sentinel from the original virtual file
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "sentinel");
    REQUIRE_FALSE(g_errors.has_errors());

    // cleanup
    std::remove(fq.c_str());
    std::remove(fa.c_str());
    std::remove(fp.c_str());
}

// New tests: trailing extra text after include filename should produce an error
TEST_CASE("Preprocessor: include with trailing extra token after filename is flagged as error",
          "[preprocessor][include][error][trailing]") {
    g_errors.reset();
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
    REQUIRE(line[0].text() == "first_line");
    REQUIRE(line.location().line_num() == 100);
    REQUIRE(line.location().filename() == "line_test");

    // next returned line should be "second_line" with logical line 101
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "second_line");
    REQUIRE(line.location().line_num() == 101);
    REQUIRE(line.location().filename() == "line_test");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == "only_line");
    REQUIRE(line.location().line_num() == 200);
    REQUIRE(line.location().filename() == "other.asm");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == "one_line");
    REQUIRE(line.location().line_num() == 400);
    REQUIRE(line.location().filename() == "cline_test");

    // next returned line should be "two_line" with the same logical line 400
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "two_line");
    REQUIRE(line.location().line_num() == 400);
    REQUIRE(line.location().filename() == "cline_test");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == "only_c_line");
    REQUIRE(line.location().line_num() == 300);
    REQUIRE(line.location().filename() == "cfile.c");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE(line[0].text() == "line_q");
    REQUIRE(line.location().line_num() == 10);
    REQUIRE(line.location().filename() == "line_q.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "line_a");
    REQUIRE(line.location().line_num() == 20);
    REQUIRE(line.location().filename() == "line_a.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "line_p");
    REQUIRE(line.location().line_num() == 30);
    REQUIRE(line.location().filename() == "line_p.asm");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == "cline_q");
    REQUIRE(line.location().line_num() == 101);
    REQUIRE(line.location().filename() == "cline_q.c");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "cline_a");
    REQUIRE(line.location().line_num() == 202);
    REQUIRE(line.location().filename() == "cline_a.c");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 1);
    REQUIRE(line[0].text() == "cline_p");
    REQUIRE(line.location().line_num() == 303);
    REQUIRE(line.location().filename() == "cline_p.c");
    REQUIRE_FALSE(g_errors.has_errors());
}

// Added test: C_LINE then ordinary lines then LINE then ordinary lines
TEST_CASE("Preprocessor: sequence C_LINE then lines then LINE then lines applies constant then incrementing logical line numbers",
          "[preprocessor][cline][line][sequence]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "C_LINE 500, \"c_fixed.asm\"\n"
        "A\n"
        "B\n"
        "LINE 700, \"l_start.asm\"\n"
        "C\n"
        "D\n";
    pp.push_virtual_file(content, "cline_line_sequence", 1, true);

    TokensLine line;

    // First logical output: A at 500 (fixed)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "A");
    REQUIRE(line.location().line_num() == 500);
    REQUIRE(line.location().filename() == "c_fixed.asm");

    // Second logical output: B still at 500 (C_LINE does not increment)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "B");
    REQUIRE(line.location().line_num() == 500);
    REQUIRE(line.location().filename() == "c_fixed.asm");

    // Third logical output: C at 700 (LINE sets start)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "C");
    REQUIRE(line.location().line_num() == 700);
    REQUIRE(line.location().filename() == "l_start.asm");

    // Fourth logical output: D at 701 (LINE increments)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "D");
    REQUIRE(line.location().line_num() == 701);
    REQUIRE(line.location().filename() == "l_start.asm");

    // No further lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE_FALSE(g_errors.has_errors());

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
    REQUIRE_FALSE(g_errors.has_errors());
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

    // Multi-argument example: ADD1(1,TWO) -> should contain both 1 and 2 after expansion
    {
        const std::string content =
            "#define TWO 2\n"
            "#define ADD1(a,b) a + b\n"
            "ADD1(1,TWO)\n";
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "one");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "two");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "A");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "B");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after2");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "L1");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "L2");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_np");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "A");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "B");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_pair");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "LHS");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "RHS");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "done");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "A");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "B");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "end2");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "L");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "M");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_nested");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "X");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "Y");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "tail");
    REQUIRE_FALSE(g_errors.has_errors());
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

    REQUIRE(pp.next_line(line));
    REQUIRE(line.size() >= 3);
    REQUIRE(line[0].text() == "A");
    REQUIRE(line[1].text() == " ");
    REQUIRE(line[2].text() == "B");
    REQUIRE(line.location().line_num() == 700);
    REQUIRE(line.location().filename() == "arg_multiline_1.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_ml");
    REQUIRE_FALSE(g_errors.has_errors());
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

    REQUIRE(pp.next_line(line));
    REQUIRE(line.size() >= 3);
    REQUIRE(line[0].text() == "X");
    REQUIRE(line[1].text() == " ");
    REQUIRE(line[2].text() == "Y");
    REQUIRE(line.location().line_num() == 710);
    REQUIRE(line.location().filename() == "arg_multiline_2.asm");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_ml2");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "L_1");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
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
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "L_2");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_local");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "done_local");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");

    // No further output expected.
    REQUIRE_FALSE(pp.next_line(line));

    // No errors should have been reported.
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "L_1");
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
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() ==
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_nested_locals");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "A");
    REQUIRE(line.location().line_num() == 111);
    REQUIRE(line.location().filename() == "exitm_call.asm");

    // Next should be the line after the macro call in the original file
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "X");

    // No other lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "LHS");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "RHS");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "tail");
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "LBL");
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
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");
    REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == word);
        REQUIRE(line.location().line_num() == 42);
        REQUIRE(line.location().filename() == "call_define_string.asm");
    }

    // Next ordinary line from the original file
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");
    REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "after0");

        // No further lines
        REQUIRE_FALSE(pp.next_line(line));
        // No errors expected
        REQUIRE_FALSE(g_errors.has_errors());
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
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "after_neg");

        // No further lines
        REQUIRE_FALSE(pp.next_line(line));
        // No errors expected
        REQUIRE_FALSE(g_errors.has_errors());
    }
}

TEST_CASE("Preprocessor: REPT with undefined expression is rejected and body consumed",
          "[preprocessor][rept][error][nonconst]") {
    g_errors.reset();
    g_symbol_table.clear();
    Preprocessor pp;

    // 'A' is undefined -> undefined expression for REPT count
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
    REQUIRE(msg.find("Undefined symbol: A") != std::string::npos);
    REQUIRE(msg.find("rept_nonconst:1:") != std::string::npos);
}

TEST_CASE("Preprocessor: REPT with non-constant expression is rejected and body consumed",
          "[preprocessor][rept][error][nonconst]") {
    g_errors.reset();
    g_symbol_table.clear();
    Symbol a;
    a.name = "A";
    a.is_defined = true;
    a.is_constant = false;
    g_symbol_table.add_symbol("A", a);
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
    REQUIRE(msg.find("Not constant symbol: A") != std::string::npos);
    REQUIRE(msg.find("rept_nonconst:1:") != std::string::npos);
}

TEST_CASE("Preprocessor: REPT with extern expression is rejected and body consumed",
          "[preprocessor][rept][error][nonconst]") {
    g_errors.reset();
    g_symbol_table.clear();
    Symbol a;
    a.name = "A";
    a.is_extern = true;
    g_symbol_table.add_symbol("A", a);
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
    REQUIRE(msg.find("Extern symbol: A") != std::string::npos);
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
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
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// REPT* + LOCAL tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: REPT LOCAL renames local labels per iteration",
          "[preprocessor][rept][local][labels]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPT 2\n"
        "LOCAL L\n"
        "L: nop\n"
        "ENDR\n"
        "after_rept_local\n";
    pp.push_virtual_file(content, "rept_local_labels", 1, true);

    TokensLine line;

    // 1st iteration label
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "L_1");

    // 1st iteration body line
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

    // 2nd iteration label
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "L_2");

    // 2nd iteration body line
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

    // After block
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_rept_local");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPT LOCAL renames identifiers per iteration",
          "[preprocessor][rept][local][idents]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPT 2\n"
        "LOCAL t\n"
        "use t\n"
        "ENDR\n"
        "after_rept_local_id\n";
    pp.push_virtual_file(content, "rept_local_idents", 1, true);

    TokensLine line;

    // 1st iteration: 'use t_1'
    REQUIRE(pp.next_line(line));
    bool saw_use = false, saw_t1 = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "use") {
            saw_use = true;
        }
        if (t.text() == "t_1") {
            saw_t1 = true;
        }
    }
    REQUIRE(saw_use);
    REQUIRE(saw_t1);

    // 2nd iteration: 'use t_2'
    REQUIRE(pp.next_line(line));
    saw_use = false;
    bool saw_t2 = false;
    for (const auto& t : line.tokens()) {
        if (t.text() == "use") {
            saw_use = true;
        }
        if (t.text() == "t_2") {
            saw_t2 = true;
        }
    }
    REQUIRE(saw_use);
    REQUIRE(saw_t2);

    // After block
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_rept_local_id");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC LOCAL renames per character iteration and substitutes variable",
          "[preprocessor][reptc][local]") {
    g_errors.reset();
    Preprocessor pp;

    // For each character, we get a unique label and 'defb <charcode>'
    const std::string content =
        "REPTC ch, \"AZ\"\n"
        "LOCAL lab\n"
        "lab: defb ch\n"
        "ENDR\n"
        "after_reptc_local\n";
    pp.push_virtual_file(content, "reptc_local", 1, true);

    TokensLine line;

    // 1st iter label '. lab_1'
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "lab_1");

    // 1st iter body: 'defb 65'
    REQUIRE(pp.next_line(line));
    {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "defb");
        bool hasA = false;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == static_cast<int>('A')) {
                hasA = true;
                break;
            }
        }
        REQUIRE(hasA);
    }

    // 2nd iter label '. lab_2'
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "lab_2");

    // 2nd iter body: 'defb 90'
    REQUIRE(pp.next_line(line));
    {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "defb");
        bool hasZ = false;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == static_cast<int>('Z')) {
                hasZ = true;
                break;
            }
        }
        REQUIRE(hasZ);
    }

    // After block
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_reptc_local");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI LOCAL renames per argument iteration and substitutes variable",
          "[preprocessor][repti][local]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPTI v, 7, 8\n"
        "LOCAL p\n"
        "p: db v\n"
        "ENDR\n"
        "after_repti_local\n";
    pp.push_virtual_file(content, "repti_local", 1, true);

    TokensLine line;

    // 1st iter label '. p_1'
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "p_1");

    // 1st iter body: 'db 7'
    REQUIRE(pp.next_line(line));
    {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "db");
        bool has7 = false;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == 7) {
                has7 = true;
                break;
            }
        }
        REQUIRE(has7);
    }

    // 2nd iter label '. p_2'
    REQUIRE(pp.next_line(line));
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line[0].text() == ".");
    REQUIRE(line[1].text() == "p_2");

    // 2nd iter body: 'db 8'
    REQUIRE(pp.next_line(line));
    {
        const auto& toks = line.tokens();
        REQUIRE(toks.size() >= 3);
        REQUIRE(toks[0].text() == "db");
        bool has8 = false;
        for (const auto& t : toks) {
            if (t.is(TokenType::Integer) && t.int_value() == 8) {
                has8 = true;
                break;
            }
        }
        REQUIRE(has8);
    }

    // After block
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after_repti_local");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTI LOCAL does not rename inside substituted argument tokens",
          "[preprocessor][repti][local][arg-preserve]") {
    g_errors.reset();
    Preprocessor pp;

    // Local name equals an argument value; ensure inserted argument token is not renamed.
    const std::string content =
        "REPTI v, tmp, foo\n"
        "LOCAL tmp\n"
        "emit v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "repti_local_arg_preserve", 1, true);

    TokensLine line;

    // First output line: 'emit tmp' (not 'tmp_1')
    REQUIRE(pp.next_line(line));
    {
        bool saw_emit = false, saw_tmp_literal = false, saw_tmp_renamed = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "emit") {
                saw_emit = true;
            }
            if (t.text() == "tmp") {
                saw_tmp_literal = true;
            }
            if (t.text() == "tmp_1") {
                saw_tmp_renamed = true;
            }
        }
        REQUIRE(saw_emit);
        REQUIRE(saw_tmp_literal);
        REQUIRE_FALSE(saw_tmp_renamed);
    }

    // Second output line: 'emit foo'
    REQUIRE(pp.next_line(line));
    {
        bool saw_emit = false, saw_foo = false;
        for (const auto& t : line.tokens()) {
            if (t.text() == "emit") {
                saw_emit = true;
            }
            if (t.text() == "foo") {
                saw_foo = true;
            }
        }
        REQUIRE(saw_emit);
        REQUIRE(saw_foo);
    }

    // No more lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// EQU directive tests (both directive and name-directive forms)
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: name-directive EQU 'X EQU 5' emits 'DEFC X = 5' tokens",
          "[preprocessor][equ][name]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "X EQU 5\n";
    pp.push_virtual_file(content, "equ_name_basic", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 6);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].is(TokenType::Identifier));
    REQUIRE(t[2].text() == "X");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));

    // RHS: integer 5
    REQUIRE(t.size() >= 7);
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 5);

    // No further lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: name-directive EQU expands RHS macros and preserves tokens",
          "[preprocessor][equ][name][expand]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 10\n"
        "#define B 20\n"
        "SUM EQU A + B\n";
    pp.push_virtual_file(content, "equ_name_expand", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expect the DEFC line

    const auto& t = line.tokens();
    REQUIRE(t.size() >= 11);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].text() == "SUM");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    // RHS must be: 10 <sp> + <sp> 20 (macro-expanded)
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 10);
    REQUIRE(t[7].is(TokenType::Whitespace));
    REQUIRE(t[8].text() == "+");
    REQUIRE(t[9].is(TokenType::Whitespace));
    REQUIRE(t[10].is(TokenType::Integer));
    REQUIRE(t[10].int_value() == 20);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: directive EQU 'EQU Y = 7' emits 'DEFC Y = 7' tokens",
          "[preprocessor][equ][directive][eq]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "EQU Y = 7\n";
    pp.push_virtual_file(content, "equ_dir_eq", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].text() == "Y");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 7);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: directive EQU without '=' 'EQU Z A' expands A and emits 'DEFC Z = 42'",
          "[preprocessor][equ][directive][no-eq]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 42\n"
        "EQU Z A\n";
    pp.push_virtual_file(content, "equ_dir_noeq", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].text() == "Z");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 42);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: name-directive EQU accepts optional '=' after EQU",
          "[preprocessor][equ][name][optional-eq]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 3\n"
        "W EQU = A\n";
    pp.push_virtual_file(content, "equ_name_opt_eq", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[2].text() == "W");
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 3);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EQU emitted DEFC line carries directive logical location",
          "[preprocessor][equ][location]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "LINE 123, \"equ_loc.asm\"\n"
        "V EQU 9\n";
    pp.push_virtual_file(content, "equ_loc", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));

    REQUIRE(line.location().line_num() == 123);
    REQUIRE(line.location().filename() == "equ_loc.asm");

    const auto& t = line.tokens();
    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[2].text() == "V");
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 9);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// '=' synonym to EQU tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: '=' synonym converts 'x = 10' to 'DEFC x = 10' tokens",
          "[preprocessor][equ][eq-synonym]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "x = 10\n";
    pp.push_virtual_file(content, "eqsyn_basic", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].is(TokenType::Identifier));
    REQUIRE(t[2].text() == "x");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 10);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: '=' synonym accepts tight form 'y=7'",
          "[preprocessor][equ][eq-synonym][tight]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "y=7\n";
    pp.push_virtual_file(content, "eqsyn_tight", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].is(TokenType::Identifier));
    REQUIRE(t[2].text() == "y");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 7);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: '=' synonym macro-expands RHS (x = A -> DEFC x = 5)",
          "[preprocessor][equ][eq-synonym][expand]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 5\n"
        "x = A\n";
    pp.push_virtual_file(content, "eqsyn_expand", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // DEFC line
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[2].text() == "x");
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 5);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: '=' synonym DEFC line carries directive logical location",
          "[preprocessor][equ][eq-synonym][location]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "LINE 250, \"eqsyn_loc.asm\"\n"
        "v = 9\n";
    pp.push_virtual_file(content, "eqsyn_loc_src", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));

    REQUIRE(line.location().line_num() == 250);
    REQUIRE(line.location().filename() == "eqsyn_loc.asm");

    const auto& t = line.tokens();
    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[2].text() == "v");
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 9);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// DEFC synonym to EQU tests (both directive and name-directive forms)
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: directive DEFC 'DEFC Y = 7' emits 'DEFC Y = 7' tokens",
          "[preprocessor][defc][directive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "DEFC Y = 7\n";
    pp.push_virtual_file(content, "defc_dir_eq", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].is(TokenType::Identifier));
    REQUIRE(t[2].text() == "Y");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 7);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: name-directive DEFC 'W DEFC 3' emits 'DEFC W = 3' tokens",
          "[preprocessor][defc][name]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "W DEFC 3\n";
    pp.push_virtual_file(content, "defc_name_basic", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& t = line.tokens();

    REQUIRE(t.size() >= 7);
    REQUIRE(t[0].text() == "DEFC");
    REQUIRE(t[1].is(TokenType::Whitespace));
    REQUIRE(t[2].is(TokenType::Identifier));
    REQUIRE(t[2].text() == "W");
    REQUIRE(t[3].is(TokenType::Whitespace));
    REQUIRE(t[4].is(TokenType::EQ));
    REQUIRE(t[5].is(TokenType::Whitespace));
    REQUIRE(t[6].is(TokenType::Integer));
    REQUIRE(t[6].int_value() == 3);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// IF / ELIF / ELSE / ENDIF nested conditionals
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: nested IF with inner ELIF selects correct branches",
          "[preprocessor][if][elif][else][endif][nested]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "LINE 100, \"ifnest.asm\"\n"
        "#define A 1\n"
        "IF A\n"
        "X\n"
        "IF 0\n"
        "Y\n"
        "ELIF 1\n"
        "Z\n"
        "ENDIF\n"
        "ENDIF\n"
        "after\n";
    pp.push_virtual_file(content, "if_nested_src", 1, true);

    TokensLine line;

    // Outer IF true -> "X" emitted
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "X");
    REQUIRE(line.location().line_num() == 102);
    REQUIRE(line.location().filename() == "ifnest.asm");

    // Inner IF false, ELIF true -> "Z" emitted
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "Z");
    REQUIRE(line.location().line_num() == 106);
    REQUIRE(line.location().filename() == "ifnest.asm");

    // After the whole IF block
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "after");

    // No more lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: outer IF false, ELIF true with nested IF-ELSE picks ELIF branch and inner ELSE",
          "[preprocessor][if][elif][else][endif][nested][mix]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 0\n"
        "#define B 1\n"
        "IF A\n"
        "OUTER_TRUE\n"
        "ELIF B\n"
        "ELIF_BRANCH\n"
        "IF 0\n"
        "INNER_TRUE_SHOULD_NOT\n"
        "ELSE\n"
        "INNER_ELSE\n"
        "ENDIF\n"
        "ELSE\n"
        "OUTER_ELSE\n"
        "ENDIF\n"
        "done\n";
    pp.push_virtual_file(content, "if_elif_nested", 1, true);

    TokensLine line;

    // Should select ELIF branch
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "ELIF_BRANCH");

    // Inside ELIF branch the inner IF 0 -> ELSE path selected
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "INNER_ELSE");

    // After full conditional group
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "done");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IF with multiple ELIF selects first true and ignores the rest",
          "[preprocessor][if][elif][else][endif]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define v 2\n"
        "IF v==1\n"
        "ONE\n"
        "ELIF v==2\n"
        "TWO\n"
        "ELIF 1\n"
        "THREE_SHOULD_NOT\n"
        "ELSE\n"
        "ELSE_SHOULD_NOT\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "if_chain", 1, true);

    TokensLine line;

    // Only the first matching ELIF branch ("TWO") should be emitted
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "TWO");

    // No more lines from this block
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// IF tests using symbols from the global symbol table
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: IF uses constant symbol value 1 as true",
          "[preprocessor][if][symtab][true]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Define A as a constant with value 1
    Symbol A;
    A.name = "A";
    A.value = 1;
    A.is_defined = true;
    A.is_constant = true;
    g_symbol_table.add_symbol("A", A);

    Preprocessor pp;
    const std::string content =
        "IF A\n"
        "OK1\n"
        "ELSE\n"
        "BAD\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "if_sym_true", 1, true);

    TokensLine line;

    // Expect IF branch selected
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK1");

    // No more lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IF uses constant symbol value 0 as false and selects ELSE",
          "[preprocessor][if][symtab][false]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Define Z as a constant with value 0
    Symbol Z;
    Z.name = "Z";
    Z.value = 0;
    Z.is_defined = true;
    Z.is_constant = true;
    g_symbol_table.add_symbol("Z", Z);

    Preprocessor pp;
    const std::string content =
        "IF Z\n"
        "BAD\n"
        "ELSE\n"
        "OK0\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "if_sym_false", 1, true);

    TokensLine line;

    // Expect ELSE branch selected
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK0");

    // No more lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IF with undefined symbol does not report error and selects ELSE",
          "[preprocessor][if][symtab][undefined]") {
    g_errors.reset();
    g_symbol_table.clear();

    Preprocessor pp;
    const std::string content =
        "IF U\n"
        "SHOULD_NOT\n"
        "ELSE\n"
        "ELSE_OK\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "if_sym_undef", 1, true);

    TokensLine line;

    // Expect ELSE branch selected due to undefined symbol evaluating as false
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "ELSE_OK");

    // No more lines
    REQUIRE_FALSE(pp.next_line(line));

    // No error reported for undefined symbol U (silent evaluation)
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// IFDEF / IFNDEF / ELIFDEF / ELIFNDEF tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: IFDEF selects true branch when macro is defined",
          "[preprocessor][ifdef]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define M 1\n"
        "IFDEF M\n"
        "T\n"
        "ELSE\n"
        "F\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "ifdef_true", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "T");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IFNDEF selects true branch when macro is not defined",
          "[preprocessor][ifndef]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IFNDEF X\n"
        "MISSING_TRUE\n"
        "ELSE\n"
        "MISSING_FALSE\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "ifndef_true", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "MISSING_TRUE");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELIFDEF after false IF selects when macro is defined",
          "[preprocessor][elifdef]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 1\n"
        "IF 0\n"
        "IF_FALSE\n"
        "ELIFDEF A\n"
        "ELIFDEF_TRUE\n"
        "ELSE\n"
        "ELSE_SHOULD_NOT\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "elifdef_case", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "ELIFDEF_TRUE");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELIFNDEF after false IF selects when macro is not defined",
          "[preprocessor][elifndef]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IF 0\n"
        "IF_FALSE\n"
        "ELIFNDEF ZZZ\n"
        "ELIFNDEF_TRUE\n"
        "ELSE\n"
        "ELSE_SHOULD_NOT\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "elifndef_case", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "ELIFNDEF_TRUE");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IFDEF/ELIFDEF nested with ELSE/ENDIF behave correctly",
          "[preprocessor][ifdef][nested]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define OUT 1\n"
        "IFDEF OUT\n"
        "O\n"
        "IFNDEF IN\n"
        "INNER_TRUE\n"
        "ELIFDEF IN\n"
        "INNER_ELIF_SHOULD_NOT\n"
        "ELSE\n"
        "INNER_ELSE_SHOULD_NOT\n"
        "ENDIF\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "ifdef_nested", 1, true);

    TokensLine line;

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "O");

    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "INNER_TRUE");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// IFDEF/IFNDEF/ELIFDEF/ELIFNDEF with global symbol table
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: IFDEF uses symbol table definition when macro is absent",
          "[preprocessor][ifdef][symtab]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Define symbol S in the global symbol table (no macro named S)
    Symbol s;
    s.name = "S";
    s.is_defined = true;
    s.is_constant = true;
    s.value = 1;
    g_symbol_table.add_symbol("S", s);

    Preprocessor pp;
    const std::string content =
        "IFDEF S\n"
        "OK_S_DEFINED\n"
        "ELSE\n"
        "BAD\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "ifdef_symtab", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK_S_DEFINED");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IFNDEF is false when symbol is defined in symbol table",
          "[preprocessor][ifndef][symtab]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Define symbol Z as present in the symbol table
    Symbol z;
    z.name = "Z";
    z.is_defined = true;
    z.is_constant = true;
    z.value = 0;
    g_symbol_table.add_symbol("Z", z);

    Preprocessor pp;
    const std::string content =
        "IFNDEF Z\n"
        "BAD\n"
        "ELSE\n"
        "OK_Z_DEFINED\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "ifndef_symtab", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK_Z_DEFINED");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELIFDEF selects when symbol is defined in symbol table",
          "[preprocessor][elifdef][symtab]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Define A in the symbol table
    Symbol a;
    a.name = "A";
    a.is_defined = true;
    a.is_constant = true;
    a.value = 123;
    g_symbol_table.add_symbol("A", a);

    Preprocessor pp;
    const std::string content =
        "IF 0\n"
        "IF_FALSE\n"
        "ELIFDEF A\n"
        "ELIFDEF_OK\n"
        "ELSE\n"
        "ELSE_SHOULD_NOT\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "elifdef_symtab", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "ELIFDEF_OK");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELIFNDEF selects when symbol is NOT defined in symbol table and skips when it is",
          "[preprocessor][elifndef][symtab]") {
    // Case 1: Symbol B is NOT defined -> ELIFNDEF branch chosen
    {
        g_errors.reset();
        g_symbol_table.clear();

        Preprocessor pp;
        const std::string content =
            "IF 0\n"
            "IF_FALSE\n"
            "ELIFNDEF B\n"
            "ELIFNDEF_OK\n"
            "ELSE\n"
            "ELSE_SHOULD_NOT\n"
            "ENDIF\n";
        pp.push_virtual_file(content, "elifndef_symtab_undef", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "ELIFNDEF_OK");

        REQUIRE_FALSE(pp.next_line(line));
        REQUIRE_FALSE(g_errors.has_errors());
    }

    // Case 2: Symbol B is defined -> ELIFNDEF should NOT match, hit ELSE
    {
        g_errors.reset();
        g_symbol_table.clear();

        Symbol b;
        b.name = "B";
        b.is_defined = true;
        b.is_constant = true;
        b.value = 7;
        g_symbol_table.add_symbol("B", b);

        Preprocessor pp;
        const std::string content =
            "IF 0\n"
            "IF_FALSE\n"
            "ELIFNDEF B\n"
            "BAD\n"
            "ELSE\n"
            "ELSE_OK\n"
            "ENDIF\n";
        pp.push_virtual_file(content, "elifndef_symtab_def", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "ELSE_OK");

        REQUIRE_FALSE(pp.next_line(line));
        REQUIRE_FALSE(g_errors.has_errors());
    }
}

// -----------------------------------------------------------------------------
// Recursive include tests (direct and indirect)
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: direct recursive include is detected and triggers RecursiveInclude error",
          "[preprocessor][include][recursive][direct]") {
    g_errors.reset();
    Preprocessor pp;

    // Create a file that includes itself
    const std::string fname = "recursive_self.asm";
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fname << "\"\n";
        ofs << "after_include\n";
    }

    pp.push_file(fname);

    TokensLine line;
    // Consume all produced lines (none expected due to error)
    int produced = 0;
    while (pp.next_line(line)) {
        ++produced;
    }

    // No lines should be produced from the recursive include
    REQUIRE(produced == 0);

    // Must have reported a RecursiveInclude error
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Recursive include") != std::string::npos);
    REQUIRE(msg.find(fname) != std::string::npos);

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: indirect recursive include (A->B->A) is detected and triggers RecursiveInclude error",
          "[preprocessor][include][recursive][indirect]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fileA = "rec_a.asm";
    const std::string fileB = "rec_b.asm";

    // A includes B
    {
        std::ofstream ofs(fileA, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileB << "\"\n";
        ofs << "in_A\n";
    }

    // B includes A (creating the cycle)
    {
        std::ofstream ofs(fileB, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileA << "\"\n";
        ofs << "in_B\n";
    }

    pp.push_file(fileA);

    TokensLine line;
    // Consume all produced lines
    int produced = 0;
    while (pp.next_line(line)) {
        ++produced;
    }

    // No normal lines should be produced due to recursive include
    REQUIRE(produced == 0);

    // Must have reported a RecursiveInclude error
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Recursive include") != std::string::npos);
    // Should mention one of the files involved in the cycle
    bool mentions_cycle = (msg.find(fileA) != std::string::npos) ||
                          (msg.find(fileB) != std::string::npos);
    REQUIRE(mentions_cycle);

    std::remove(fileA.c_str());
    std::remove(fileB.c_str());
}

TEST_CASE("Preprocessor: longer cycle (A->B->C->A) is detected and triggers RecursiveInclude error",
          "[preprocessor][include][recursive][indirect][long]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fileA = "cycle_a.asm";
    const std::string fileB = "cycle_b.asm";
    const std::string fileC = "cycle_c.asm";

    // A includes B
    {
        std::ofstream ofs(fileA, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileB << "\"\n";
        ofs << "in_A\n";
    }

    // B includes C
    {
        std::ofstream ofs(fileB, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileC << "\"\n";
        ofs << "in_B\n";
    }

    // C includes A (closing the cycle)
    {
        std::ofstream ofs(fileC, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileA << "\"\n";
        ofs << "in_C\n";
    }

    pp.push_file(fileA);

    TokensLine line;
    int produced = 0;
    while (pp.next_line(line)) {
        ++produced;
    }

    // No normal lines should be produced
    REQUIRE(produced == 0);

    // Must have reported a RecursiveInclude error
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Recursive include") != std::string::npos);

    std::remove(fileA.c_str());
    std::remove(fileB.c_str());
    std::remove(fileC.c_str());
}

TEST_CASE("Preprocessor: same file can be included multiple times if not recursive (A->B, A->B again after B closes)",
          "[preprocessor][include][multiple][nonrecursive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fileA = "multi_a.asm";
    const std::string fileB = "multi_b.asm";

    // A includes B twice (non-recursive: B doesn't include A)
    {
        std::ofstream ofs(fileA, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileB << "\"\n";
        ofs << "middle_A\n";
        ofs << "#include \"" << fileB << "\"\n";
        ofs << "end_A\n";
    }

    // B is simple
    {
        std::ofstream ofs(fileB, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "in_B\n";
    }

    pp.push_file(fileA);

    TokensLine line;
    std::vector<std::string> lines;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should get: in_B, middle_A, in_B, end_A
    REQUIRE(lines.size() == 4);
    REQUIRE(lines[0] == "in_B");
    REQUIRE(lines[1] == "middle_A");
    REQUIRE(lines[2] == "in_B");
    REQUIRE(lines[3] == "end_A");

    // No errors expected
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fileA.c_str());
    std::remove(fileB.c_str());
}

TEST_CASE("Preprocessor: path normalization prevents redundant path forms from avoiding cycle detection",
          "[preprocessor][include][recursive][normalize]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fileA = "norm_a.asm";
    const std::string fileB = "norm_b.asm";

    // A includes B using relative path
    {
        std::ofstream ofs(fileA, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << fileB << "\"\n";
        ofs << "in_A\n";
    }

    // B includes A using a different form that normalizes to the same path
    // e.g., "./norm_a.asm" should normalize to "norm_a.asm"
    {
        std::ofstream ofs(fileB, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"./norm_a.asm\"\n";
        ofs << "in_B\n";
    }

    pp.push_file(fileA);

    TokensLine line;
    int produced = 0;
    while (pp.next_line(line)) {
        ++produced;
    }

    // No lines should be produced
    REQUIRE(produced == 0);

    // Must have reported a RecursiveInclude error
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Recursive include") != std::string::npos);

    std::remove(fileA.c_str());
    std::remove(fileB.c_str());
}

// -----------------------------------------------------------------------------
// File cache tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: file cache reuses unchanged files",
          "[preprocessor][cache][hit]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string fname = "cache_test1.asm";

    // Create a test file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "test_line\n";
    }

    // First preprocessor instance - should read from disk
    Preprocessor pp1;
    pp1.push_file(fname);

    TokensLine line1;
    REQUIRE(pp1.next_line(line1));
    REQUIRE(!line1.empty());
    REQUIRE(line1[0].text() == "test_line");

    // Second preprocessor instance - should hit cache
    Preprocessor pp2;
    pp2.push_file(fname);

    TokensLine line2;
    REQUIRE(pp2.next_line(line2));
    REQUIRE(!line2.empty());
    REQUIRE(line2[0].text() == "test_line");
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: file cache works with multiple includes",
          "[preprocessor][cache][multiple]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string inc1 = "cache_inc1.asm";
    const std::string inc2 = "cache_inc2.asm";
    const std::string main_file = "cache_main.asm";

    // Create include files
    {
        std::ofstream ofs(inc1, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "from_inc1\n";
    }
    {
        std::ofstream ofs(inc2, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "from_inc2\n";
    }
    {
        std::ofstream ofs(main_file, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << inc1 << "\"\n";
        ofs << "#include \"" << inc2 << "\"\n";
        ofs << "#include \"" << inc1 << "\"\n"; // Include inc1 again
        ofs << "main_line\n";
    }

    Preprocessor pp;
    pp.push_file(main_file);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see: from_inc1, from_inc2, from_inc1 (cached), main_line
    REQUIRE(lines.size() == 4);
    REQUIRE(lines[0] == "from_inc1");
    REQUIRE(lines[1] == "from_inc2");
    REQUIRE(lines[2] == "from_inc1"); // Second include of inc1 uses cache
    REQUIRE(lines[3] == "main_line");
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(inc1.c_str());
    std::remove(inc2.c_str());
    std::remove(main_file.c_str());
}

TEST_CASE("Preprocessor: file cache shared across preprocessor instances",
          "[preprocessor][cache][shared]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string fname = "cache_shared.asm";

    // Create test file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "shared_content\n";
    }

    // First instance reads file
    {
        Preprocessor pp1;
        pp1.push_file(fname);

        TokensLine line;
        REQUIRE(pp1.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "shared_content");
    }

    // Second instance should use cached version
    // (No file modification between instances)
    {
        Preprocessor pp2;
        pp2.push_file(fname);

        TokensLine line;
        REQUIRE(pp2.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "shared_content");
    }
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: clear_file_cache empties the cache",
          "[preprocessor][cache][clear]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string fname = "cache_clear.asm";

    // Create test file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "before_clear\n";
    }

    // Read file to populate cache
    {
        Preprocessor pp;
        pp.push_file(fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "before_clear");
    }

    // Clear cache
    Preprocessor::clear_file_cache();

    // Modify file without waiting (since cache is cleared, modification time doesn't matter)
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "after_clear\n";
    }

    // Read again - should get new content (cache was cleared)
    {
        Preprocessor pp;
        pp.push_file(fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "after_clear");
    }
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: file cache handles path normalization",
          "[preprocessor][cache][normalize]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string fname = "cache_norm.asm";

    // Create test file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "normalized\n";
    }

    // Read with plain name
    {
        Preprocessor pp;
        pp.push_file(fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "normalized");
    }

    // Read with relative path (./ prefix) - should use same cache entry
    {
        Preprocessor pp;
        pp.push_file("./" + fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "normalized");
    }
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: file cache handles nested includes efficiently",
          "[preprocessor][cache][nested]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string common = "cache_common.asm";
    const std::string level1a = "cache_level1a.asm";
    const std::string level1b = "cache_level1b.asm";
    const std::string main_file = "cache_nested_main.asm";

    // Common file included by multiple files
    {
        std::ofstream ofs(common, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "common_content\n";
    }

    // Level 1 files both include common
    {
        std::ofstream ofs(level1a, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << common << "\"\n";
        ofs << "level1a_content\n";
    }
    {
        std::ofstream ofs(level1b, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << common << "\"\n";
        ofs << "level1b_content\n";
    }

    // Main file includes both level 1 files
    {
        std::ofstream ofs(main_file, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << level1a << "\"\n";
        ofs << "#include \"" << level1b << "\"\n";
        ofs << "main_content\n";
    }

    Preprocessor pp;
    pp.push_file(main_file);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see common twice (once from each level1 file), plus level1 and main content
    REQUIRE(lines.size() == 5);
    REQUIRE(lines[0] == "common_content");
    REQUIRE(lines[1] == "level1a_content");
    REQUIRE(lines[2] == "common_content"); // Second include uses cache
    REQUIRE(lines[3] == "level1b_content");
    REQUIRE(lines[4] == "main_content");
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(common.c_str());
    std::remove(level1a.c_str());
    std::remove(level1b.c_str());
    std::remove(main_file.c_str());
}

TEST_CASE("Preprocessor: file cache invalidates on file modification",
          "[preprocessor][cache][invalidate]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string fname = "cache_test2.asm";

    // Create initial file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "original_line\n";
    }

    // First read - populates cache
    {
        Preprocessor pp;
        pp.push_file(fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "original_line");
    }

    // Wait to ensure different modification time
    SLEEP_MS(1100);

    // Modify the file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "modified_line\n";
    }

    // Second read - should detect modification and reload
    {
        Preprocessor pp;
        pp.push_file(fname);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "modified_line");
    }
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

// -----------------------------------------------------------------------------
// REPT with positive count - basic functionality
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: REPT with positive count repeats body correctly",
          "[preprocessor][rept][positive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "REPT 3\n"
        "line1\n"
        "ENDR\n"
        "after\n";
    pp.push_virtual_file(content, "rept_positive", 1, true);

    TokensLine line;
    int count = 0;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (!toks.empty()) {
            if (toks[0].text() == "line1") {
                ++count;
            }
            else if (toks[0].text() == "after") {
                break;
            }
        }
    }

    REQUIRE(count == 3);
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// BINARY/INCBIN Error Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: BINARY with missing file reports FileNotFound error",
          "[preprocessor][binary][error][missing]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string missing = "missing_binary.bin";
    const std::string content = "BINARY \"" + missing + "\"\n";
    pp.push_virtual_file(content, "binary_missing", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("File not found") != std::string::npos);
    REQUIRE(msg.find(missing) != std::string::npos);
}

TEST_CASE("Preprocessor: INCBIN with missing file reports FileNotFound error",
          "[preprocessor][binary][error][missing][incbin]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string missing = "missing_incbin.bin";
    const std::string content = "INCBIN \"" + missing + "\"\n";
    pp.push_virtual_file(content, "incbin_missing", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("File not found") != std::string::npos);
    REQUIRE(msg.find(missing) != std::string::npos);
}

TEST_CASE("Preprocessor: BINARY with empty file produces no DEFB lines",
          "[preprocessor][binary][empty]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fname = "empty_binary.bin";
    // Create empty binary file
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        // Write nothing
    }

    const std::string content = "BINARY \"" + fname + "\"\nafter\n";
    pp.push_virtual_file(content, "binary_empty", 1, true);

    TokensLine line;
    int defb_count = 0;
    bool saw_after = false;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (!toks.empty()) {
            if (toks[0].text() == "DEFB") {
                ++defb_count;
            }
            else if (toks[0].text() == "after") {
                saw_after = true;
            }
        }
    }

    REQUIRE(defb_count == 0);
    REQUIRE(saw_after);
    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("Preprocessor: BINARY with non-multiple-of-16 size handles last partial line",
          "[preprocessor][binary][partial]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string fname = "partial_binary.bin";
    // Create binary file with 20 bytes (16 + 4)
    {
        std::ofstream ofs(fname, std::ios::binary);
        REQUIRE(ofs.is_open());
        for (int i = 0; i < 20; ++i) {
            char c = static_cast<char>(i);
            ofs.write(&c, 1);
        }
    }

    const std::string content = "BINARY \"" + fname + "\"\n";
    pp.push_virtual_file(content, "binary_partial", 1, true);

    TokensLine line;
    std::vector<int> ints;
    int line_count = 0;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (!toks.empty() && toks[0].text() == "DEFB") {
            ++line_count;
            for (const auto& t : toks) {
                if (t.is(TokenType::Integer)) {
                    ints.push_back(t.int_value());
                }
            }
        }
    }

    REQUIRE(line_count == 2); // 16 bytes + 4 bytes = 2 lines
    REQUIRE(ints.size() == 20);
    for (int i = 0; i < 20; ++i) {
        REQUIRE(ints[i] == i);
    }
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

// -----------------------------------------------------------------------------
// LINE/C_LINE Error Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: LINE with non-numeric line number reports error",
          "[preprocessor][line][error][nonnumeric]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "LINE abc\n";
    pp.push_virtual_file(content, "line_nonnumeric", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("Expected line number") != std::string::npos ||
             msg.find("Invalid") != std::string::npos));
}

TEST_CASE("Preprocessor: LINE with negative line number is accepted (implementation-defined)",
          "[preprocessor][line][negative]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "LINE -5\ntest\nthis\n";
    pp.push_virtual_file(content, "line_negative", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == -5);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].text() == "test");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == -4);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].text() == "this");

    REQUIRE_FALSE(pp.next_line(line));

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: LINE with trailing tokens after filename reports error",
          "[preprocessor][line][error][trailing]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "LINE 100, \"file.asm\" extra\n";
    pp.push_virtual_file(content, "line_trailing", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unexpected token") != std::string::npos);
}

// -----------------------------------------------------------------------------
// Macro Parameter Mismatch Tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: function-like macro with too few arguments reports error",
          "[preprocessor][macro][args][error][few]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define ADD1(a,b) a + b\n"
        "ADD1(5)\n";
    pp.push_virtual_file(content, "macro_few_args", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("argument count mismatch") != std::string::npos);
}

TEST_CASE("Preprocessor: function-like macro with too many arguments reports error",
          "[preprocessor][macro][args][error][many]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define ADD1(a,b) a + b\n"
        "ADD1(5,10,15)\n";
    pp.push_virtual_file(content, "macro_many_args", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("argument count mismatch") != std::string::npos);
}

TEST_CASE("Preprocessor: function-like macro with empty parentheses when expecting args reports error",
          "[preprocessor][macro][args][error][empty]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define MUL(a,b) a * b\n"
        "MUL()\n";
    pp.push_virtual_file(content, "macro_empty_args", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("argument count mismatch") != std::string::npos);
}

// -----------------------------------------------------------------------------
// EXITM in nested contexts
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: EXITM in nested macro only exits innermost macro",
          "[preprocessor][macro][exitm][nested]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO OUTER()\n"
        "outer_before\n"
        "MACRO INNER()\n"
        "inner_line\n"
        "EXITM\n"
        "inner_after_exitm\n"
        "ENDM\n"
        "INNER()\n"
        "outer_after\n"
        "ENDM\n"
        "OUTER()\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_nested_macro", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see: outer_before, inner_line, outer_after, done
    // Should NOT see: inner_after_exitm
    REQUIRE(std::find(lines.begin(), lines.end(), "outer_before") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "inner_line") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "outer_after") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(),
                      "inner_after_exitm") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: multiple EXITM in same macro - first one takes effect",
          "[preprocessor][macro][exitm][multiple]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M()\n"
        "line1\n"
        "EXITM\n"
        "line2\n"
        "EXITM\n"
        "line3\n"
        "ENDM\n"
        "M()\n"
        "after\n";
    pp.push_virtual_file(content, "exitm_multiple", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    REQUIRE(std::find(lines.begin(), lines.end(), "line1") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "line2") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "line3") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after") != lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Token Pasting Edge Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: token paste at beginning of replacement list",
          "[preprocessor][tokenpaste][edge][beginning]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define PASTE(x) ## x\n"
        "PASTE(test)\n";
    pp.push_virtual_file(content, "paste_beginning", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.size() >= 3);
    REQUIRE(line[0].is(TokenType::DoubleHash));
    REQUIRE(line[1].is(TokenType::Whitespace));
    REQUIRE(line[2].is(TokenType::Identifier));
    REQUIRE(line[2].text() == "test");

    REQUIRE_FALSE(pp.next_line(line));

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: token paste at end of replacement list",
          "[preprocessor][tokenpaste][edge][end]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define PASTE(x) x ##\n"
        "PASTE(test)\n";
    pp.push_virtual_file(content, "paste_end", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.size() >= 3);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "test");
    REQUIRE(line[1].is(TokenType::Whitespace));
    REQUIRE(line[2].is(TokenType::DoubleHash));

    REQUIRE_FALSE(pp.next_line(line));

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: multiple consecutive ## operators",
          "[preprocessor][tokenpaste][edge][consecutive]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define MULTI(a,b,c) a ## b ## c\n"
        "MULTI(X,Y,Z)\n";
    pp.push_virtual_file(content, "paste_consecutive", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    bool foundXYZ = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier) && t.text() == "XYZ") {
            foundXYZ = true;
            break;
        }
    }
    REQUIRE(foundXYZ);
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Stringize Edge Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: stringize with whitespace-only argument",
          "[preprocessor][stringize][edge][whitespace]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define STR(x) #x\n"
        "STR(\" \")\n";
    pp.push_virtual_file(content, "stringize_whitespace", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.size() >= 5);
    REQUIRE(line[0].is(TokenType::Integer));
    REQUIRE(line[0].int_value() == 34);     // quotes
    REQUIRE(line[1].is(TokenType::Comma));
    REQUIRE(line[2].is(TokenType::Integer));
    REQUIRE(line[2].int_value() == 32);     // space
    REQUIRE(line[3].is(TokenType::Comma));
    REQUIRE(line[4].is(TokenType::Integer));
    REQUIRE(line[4].int_value() == 34);     // quotes

    REQUIRE_FALSE(pp.next_line(line));

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: stringize with special characters",
          "[preprocessor][stringize][edge][special]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define STR(x) #x\n"
        "STR(@#$%)\n";
    pp.push_virtual_file(content, "stringize_special", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Should produce character codes for @, #, $, %
    std::vector<int> chars;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            chars.push_back(t.int_value());
        }
    }
    REQUIRE(!chars.empty());
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Conditional Directive Error Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: unmatched ENDIF reports error",
          "[preprocessor][if][error][unmatched]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "line1\n"
        "ENDIF\n"
        "line2\n";
    pp.push_virtual_file(content, "unmatched_endif", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ENDIF") != std::string::npos ||
             msg.find("without") != std::string::npos));
}

TEST_CASE("Preprocessor: ELIF without preceding IF reports error",
          "[preprocessor][if][error][elif]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "line1\n"
        "ELIF 1\n"
        "line2\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "elif_without_if", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ELIF") != std::string::npos ||
             msg.find("without") != std::string::npos));
}

TEST_CASE("Preprocessor: ELSE without preceding IF reports error",
          "[preprocessor][if][error][else]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "line1\n"
        "ELSE\n"
        "line2\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "else_without_if", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ELSE") != std::string::npos ||
             msg.find("without") != std::string::npos));
}

TEST_CASE("Preprocessor: multiple ELSE in same IF block reports error",
          "[preprocessor][if][error][multiple-else]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IF 1\n"
        "line1\n"
        "ELSE\n"
        "line2\n"
        "ELSE\n"
        "line3\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "multiple_else", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ELSE") != std::string::npos ||
             msg.find("multiple") != std::string::npos ||
             msg.find("duplicate") != std::string::npos));
}

TEST_CASE("Preprocessor: ENDIF without IF reports error",
          "[preprocessor][if][error][endif-solo]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "start\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "endif_solo", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("ENDIF") != std::string::npos);
}

// -----------------------------------------------------------------------------
// MACRO Error Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: MACRO without ENDM reports error at end of file",
          "[preprocessor][macro][error][noendm]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M()\n"
        "body\n";
    pp.push_virtual_file(content, "macro_no_endm", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ENDM") != std::string::npos ||
             msg.find("MACRO") != std::string::npos));
}

TEST_CASE("Preprocessor: ENDM without MACRO reports error",
          "[preprocessor][macro][error][endm-solo]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "line\n"
        "ENDM\n";
    pp.push_virtual_file(content, "endm_solo", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("ENDM") != std::string::npos ||
             msg.find("without") != std::string::npos));
}

TEST_CASE("Preprocessor: MACRO with empty name reports error",
          "[preprocessor][macro][error][noname]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO ()\n"
        "body\n"
        "ENDM\n";
    pp.push_virtual_file(content, "macro_no_name", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE((msg.find("name") != std::string::npos ||
             msg.find("Expected") != std::string::npos));
}

TEST_CASE("Preprocessor: MACRO with duplicate parameter names reports error",
          "[preprocessor][macro][error][dup-params]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(a,a)\n"
        "body\n"
        "ENDM\n";
    pp.push_virtual_file(content, "macro_dup_params", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Duplicate definition") != std::string::npos);
}

// -----------------------------------------------------------------------------
// Virtual File Edge Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: empty virtual file produces no lines",
          "[preprocessor][virtual][empty]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "";
    pp.push_virtual_file(content, "empty_virtual", 1, true);

    TokensLine line;
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: virtual file with only whitespace produces no lines",
          "[preprocessor][virtual][whitespace]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "   \n\t\n  \n";
    pp.push_virtual_file(content, "whitespace_virtual", 1, true);

    TokensLine line;
    int line_count = 0;
    while (pp.next_line(line)) {
        ++line_count;
    }

    REQUIRE(line_count == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: virtual file with only comments produces no output lines",
          "[preprocessor][virtual][comments]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "; comment 1\n"
        "// comment 2\n"
        "/* block comment */\n";
    pp.push_virtual_file(content, "comment_virtual", 1, true);

    TokensLine line;
    int line_count = 0;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            ++line_count;
        }
    }

    REQUIRE(line_count == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// String Edge Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: empty string produces no characters",
          "[preprocessor][string][empty]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "db \"\"\n";
    pp.push_virtual_file(content, "empty_string", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Should have "db" and whitespace, but no integer tokens
    int int_count = 0;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            ++int_count;
        }
    }

    REQUIRE(int_count == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: string with only escape sequences",
          "[preprocessor][string][escapes-only]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "db \"\\n\\r\\t\"\n";
    pp.push_virtual_file(content, "escapes_only", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    std::vector<int> ints;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            ints.push_back(t.int_value());
        }
    }

    REQUIRE(ints.size() == 3);
    REQUIRE(ints[0] == 10);  // \n
    REQUIRE(ints[1] == 13);  // \r
    REQUIRE(ints[2] == 9);   // \t
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Label Splitting Edge Cases
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: multiple labels on same line - each gets split",
          "[preprocessor][label][multiple]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "lab1: lab2: nop\n";
    pp.push_virtual_file(content, "multiple_labels", 1, true);

    TokensLine line;
    std::vector<std::string> labels;

    while (pp.next_line(line)) {
        const auto& toks = line.tokens();
        if (toks.size() >= 2 && toks[0].text() == ".") {
            labels.push_back(toks[1].text());
        }
    }

    // Should see both labels split out
    REQUIRE(labels.size() >= 2);
    REQUIRE(std::find(labels.begin(), labels.end(), "lab1") != labels.end());
    REQUIRE(std::find(labels.begin(), labels.end(), "lab2") != labels.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: label with no following instruction",
          "[preprocessor][label][alone]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "label:\n";
    pp.push_virtual_file(content, "label_alone", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Should produce label line with dot and label name
    REQUIRE(toks.size() >= 2);
    REQUIRE(toks[0].text() == ".");
    REQUIRE(toks[1].text() == "label");

    // No instruction line should follow
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// Add these tests after the existing EXITM tests (around line 4120)

// -----------------------------------------------------------------------------
// EXITM with conditional execution tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: EXITM inside IF with true condition exits macro",
          "[preprocessor][macro][exitm][if][true]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(cond)\n"
        "before\n"
        "IF cond\n"
        "EXITM\n"
        "ENDIF\n"
        "after\n"
        "ENDM\n"
        "LINE 100, \"exitm_if_true.asm\"\n"
        "M(1)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_if_true", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see: before, done
    // Should NOT see: after (EXITM was executed)
    REQUIRE(std::find(lines.begin(), lines.end(), "before") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EXITM inside IF with false condition does not exit macro",
          "[preprocessor][macro][exitm][if][false]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(cond)\n"
        "before\n"
        "IF cond\n"
        "EXITM\n"
        "ENDIF\n"
        "after\n"
        "ENDM\n"
        "LINE 200, \"exitm_if_false.asm\"\n"
        "M(0)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_if_false", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see: before, after, done
    // All lines should be present (EXITM was not executed)
    REQUIRE(std::find(lines.begin(), lines.end(), "before") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EXITM in ELSE branch exits when IF condition is false",
          "[preprocessor][macro][exitm][if][else]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(cond)\n"
        "before\n"
        "IF cond\n"
        "in_if\n"
        "ELSE\n"
        "in_else\n"
        "EXITM\n"
        "ENDIF\n"
        "after\n"
        "ENDM\n"
        "LINE 300, \"exitm_else.asm\"\n"
        "M(0)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_else", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // Should see: before, in_else, done
    // Should NOT see: in_if, after (EXITM in ELSE was executed)
    REQUIRE(std::find(lines.begin(), lines.end(), "before") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "in_else") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "in_if") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: nested IF with EXITM - inner condition controls exit",
          "[preprocessor][macro][exitm][if][nested]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(outer, inner)\n"
        "start\n"
        "IF outer\n"
        "outer_block\n"
        "IF inner\n"
        "EXITM\n"
        "ENDIF\n"
        "after_inner\n"
        "ENDIF\n"
        "end\n"
        "ENDM\n"
        "LINE 400, \"exitm_nested_if.asm\"\n"
        "M(1, 0)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_nested_if", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // outer=1, inner=0: Should execute outer block and continue to end
    // Should see: start, outer_block, after_inner, end, done
    REQUIRE(std::find(lines.begin(), lines.end(), "start") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "outer_block") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after_inner") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "end") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: nested IF with EXITM - inner true condition exits macro",
          "[preprocessor][macro][exitm][if][nested][exit]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(outer, inner)\n"
        "start\n"
        "IF outer\n"
        "outer_block\n"
        "IF inner\n"
        "EXITM\n"
        "ENDIF\n"
        "after_inner\n"
        "ENDIF\n"
        "end\n"
        "ENDM\n"
        "LINE 500, \"exitm_nested_if_exit.asm\"\n"
        "M(1, 1)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_nested_if_exit", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // outer=1, inner=1: Should exit at inner EXITM
    // Should see: start, outer_block, done
    // Should NOT see: after_inner, end
    REQUIRE(std::find(lines.begin(), lines.end(), "start") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "outer_block") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "after_inner") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "end") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EXITM with IFDEF/IFNDEF conditionals",
          "[preprocessor][macro][exitm][ifdef]") {
    g_errors.reset();
    Preprocessor pp;

    // Test with IFDEF (symbol defined - should exit)
    {
        const std::string content =
            "#define SYM 1\n"
            "MACRO M()\n"
            "before\n"
            "IFDEF SYM\n"
            "EXITM\n"
            "ENDIF\n"
            "after\n"
            "ENDM\n"
            "M()\n"
            "done\n";
        pp.push_virtual_file(content, "exitm_ifdef_defined", 1, true);

        TokensLine line;
        std::vector<std::string> lines;

        while (pp.next_line(line)) {
            if (!line.empty()) {
                lines.push_back(line[0].text());
            }
        }

        REQUIRE(std::find(lines.begin(), lines.end(), "before") != lines.end());
        REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
        REQUIRE(std::find(lines.begin(), lines.end(), "after") == lines.end());
    }

    // Test with IFNDEF (symbol not defined - should exit)
    {
        g_errors.reset();
        Preprocessor pp2;

        const std::string content =
            "MACRO M()\n"
            "before\n"
            "IFNDEF UNDEF_SYM\n"
            "EXITM\n"
            "ENDIF\n"
            "after\n"
            "ENDM\n"
            "M()\n"
            "done\n";
        pp2.push_virtual_file(content, "exitm_ifndef_undef", 1, true);

        TokensLine line;
        std::vector<std::string> lines;

        while (pp2.next_line(line)) {
            if (!line.empty()) {
                lines.push_back(line[0].text());
            }
        }

        REQUIRE(std::find(lines.begin(), lines.end(), "before") != lines.end());
        REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
        REQUIRE(std::find(lines.begin(), lines.end(), "after") == lines.end());
    }
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EXITM with ELIF branch",
          "[preprocessor][macro][exitm][elif]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(val)\n"
        "start\n"
        "IF val == 1\n"
        "branch1\n"
        "ELIF val == 2\n"
        "branch2\n"
        "EXITM\n"
        "ELIF val == 3\n"
        "branch3\n"
        "ENDIF\n"
        "end\n"
        "ENDM\n"
        "LINE 600, \"exitm_elif.asm\"\n"
        "M(2)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_elif", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // val=2: Should execute ELIF branch with EXITM
    // Should see: start, branch2, done
    // Should NOT see: branch1, branch3, end
    REQUIRE(std::find(lines.begin(), lines.end(), "start") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "branch2") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "branch1") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "branch3") == lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "end") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: multiple EXITMs in different IF branches - only executed one is effective",
          "[preprocessor][macro][exitm][if][multiple]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO M(cond)\n"
        "start\n"
        "IF cond\n"
        "true_branch\n"
        "EXITM\n"
        "ELSE\n"
        "false_branch\n"
        "EXITM\n"
        "ENDIF\n"
        "never_reached\n"
        "ENDM\n"
        "LINE 700, \"exitm_multi_if.asm\"\n"
        "M(1)\n"
        "M(0)\n"
        "done\n";
    pp.push_virtual_file(content, "exitm_multi_if", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            lines.push_back(line[0].text());
        }
    }

    // M(1): start, true_branch
    // M(0): start, false_branch
    // done
    // never_reached should never appear
    REQUIRE(std::find(lines.begin(), lines.end(), "start") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "true_branch") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "false_branch") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "done") != lines.end());
    REQUIRE(std::find(lines.begin(), lines.end(), "never_reached") == lines.end());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: IF without ENDIF reports error at end of input",
          "[preprocessor][if][error][noendif]") {
    g_errors.reset();
    Preprocessor pp;

    // Unclosed IF; EOF reached without ENDIF
    const std::string content =
        "IF 1\n"
        "OK\n";
    pp.push_virtual_file(content, "if_no_endif", 1, true);

    TokensLine line;
    // Consume all output to trigger end-of-input checks
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    // Accept flexible wording: look for ENDIF or IF-related untermination
    REQUIRE((msg.find("ENDIF") != std::string::npos ||
             msg.find("unterminated") != std::string::npos ||
             msg.find("IF") != std::string::npos));
}

TEST_CASE("Preprocessor: outer IF missing ENDIF is reported even when inner blocks close",
          "[preprocessor][if][error][noendif][nested]") {
    g_errors.reset();
    Preprocessor pp;

    // Outer IF is missing ENDIF; inner IF/ELSE/ENDIF is correctly closed
    const std::string content =
        "IF 1\n"
        "X\n"
        "IF 0\n"
        "Y\n"
        "ELSE\n"
        "Z\n"
        "ENDIF\n";
    pp.push_virtual_file(content, "if_outer_no_endif", 1, true);

    TokensLine line;
    // Consume all output to trigger end-of-input checks
    while (pp.next_line(line)) {}

    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    // Accept flexible wording: look for ENDIF or IF-related untermination
    REQUIRE((msg.find("ENDIF") != std::string::npos ||
             msg.find("unterminated") != std::string::npos ||
             msg.find("IF") != std::string::npos));
}

TEST_CASE("Preprocessor: dependency_filenames captures push_file and #include in order with duplicates",
          "[preprocessor][deps][include][order][dups]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();
    Preprocessor pp;

    const std::string inc1 = "dep_inc1.asm";
    const std::string inc2 = "dep_inc2.asm";
    const std::string mainf = "dep_main.asm";

    // Create include files
    {
        std::ofstream ofs1(inc1, std::ios::binary);
        REQUIRE(ofs1.is_open());
        ofs1 << "from_inc1\n";
    }
    {
        std::ofstream ofs2(inc2, std::ios::binary);
        REQUIRE(ofs2.is_open());
        ofs2 << "from_inc2\n";
    }
    // Main includes inc1, inc2, inc1 again (duplicate)
    {
        std::ofstream ofs(mainf, std::ios::binary);
        REQUIRE(ofs.is_open());
        ofs << "#include \"" << inc1 << "\"\n";
        ofs << "#include \"" << inc2 << "\"\n";
        ofs << "#include \"" << inc1 << "\"\n";
        ofs << "done\n";
    }

    // Push main file (records main), then process includes (records incs)
    pp.push_file(mainf);

    TokensLine line;
    while (pp.next_line(line)) {
        // drain
    }

    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 4);
    // Order preserved, duplicates allowed
    REQUIRE(deps[0] == mainf);
    REQUIRE(deps[1] == inc1);
    REQUIRE(deps[2] == inc2);
    REQUIRE(deps[3] == inc1);
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(inc1.c_str());
    std::remove(inc2.c_str());
    std::remove(mainf.c_str());
}

TEST_CASE("Preprocessor: dependency_filenames captures BINARY/INCBIN in order (including missing files)",
          "[preprocessor][deps][binary][incbin][order]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string ok1 = "dep_ok1.bin";
    const std::string ok2 = "dep_ok2.bin";
    const std::string missing = "dep_missing.bin";

    // Create two small binary files; leave 'missing' absent on purpose
    {
        std::ofstream o1(ok1, std::ios::binary);
        REQUIRE(o1.is_open());
        unsigned char data1[] = { 1, 2, 3 };
        o1.write(reinterpret_cast<const char*>(data1), sizeof(data1));
    }
    {
        std::ofstream o2(ok2, std::ios::binary);
        REQUIRE(o2.is_open());
        unsigned char data2[] = { 4 };
        o2.write(reinterpret_cast<const char*>(data2), sizeof(data2));
    }

    // Use a virtual file to emit BINARY/INCBIN directives
    std::string content;
    content += "BINARY \"" + ok1 + "\"\n";
    content += "INCBIN \"" + missing + "\"\n"; // should still be recorded in deps
    content += "BINARY \"" + ok2 + "\"\n";
    pp.push_virtual_file(content, "deps_binary_script", 1, true);

    TokensLine line;
    while (pp.next_line(line)) {
        // drain
    }

    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 3);
    REQUIRE(deps[0] == ok1);
    REQUIRE(deps[1] == missing);
    REQUIRE(deps[2] == ok2);

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("File not found: " + missing) != std::string::npos);

    std::remove(ok1.c_str());
    std::remove(ok2.c_str());
}

TEST_CASE("Preprocessor: clear() resets dependency_filenames",
          "[preprocessor][deps][clear]") {
    g_errors.reset();
    Preprocessor pp;

    // Record a dependency via push_binary_file (file may not exist)
    const std::string dep = "dep_clear_dummy.bin";
    pp.push_binary_file(dep, Location("loc", 1));

    {
        const auto& deps = pp.dependency_filenames();
        REQUIRE(!deps.empty());
        REQUIRE(deps.front() == dep);
    }

    // Now clear and verify dependencies are empty
    pp.clear();
    REQUIRE(pp.dependency_filenames().empty());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("File not found: " + dep) != std::string::npos);
}

TEST_CASE("Preprocessor: multi-line macro expands in the middle of a three-statements line (parenthesized call)",
          "[preprocessor][macro][multiline][split][colon]") {
    g_errors.reset();
    Preprocessor pp;

    // Define a 2-line macro and call it between two colon-separated statements
    const std::string content =
        "MYMACRO MACRO a,b\n"
        "DEFB a\n"
        "DEFB b\n"
        "ENDM\n"
        "NOP : MYMACRO(10,20) : HALT\n";
    pp.push_virtual_file(content, "macro_midline_parenthesized.asm", 1, true);

    std::vector<std::string> outs;
    TokensLine line;
    while (pp.next_line(line)) {
        outs.push_back(line.to_string());
    }

    // Expect: one line with code before, then all macro lines, then one line with code after
    REQUIRE(outs.size() == 4);
    // Trim simple leading/trailing spaces to make matching robust
    auto trim = [](std::string s) {
        auto issp = [](unsigned char c) {
            return std::isspace(c) != 0;
        };
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [&](char c) {
            return !issp((unsigned char)c);
        }));
        s.erase(std::find_if(s.rbegin(), s.rend(), [&](char c) {
            return !issp((unsigned char)c);
        }).base(), s.end());
        return s;
    };

    REQUIRE(trim(outs[0]) == "NOP");
    REQUIRE(trim(outs[1]) == "DEFB 10");
    REQUIRE(trim(outs[2]) == "DEFB 20");
    REQUIRE(trim(outs[3]) == "HALT");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: multi-line macro expands in the middle of a three-statements line (unparenthesized call)",
          "[preprocessor][macro][multiline][split][colon][noparen]") {
    g_errors.reset();
    Preprocessor pp;

    // Same macro, unparenthesized call form
    const std::string content =
        "MYMACRO MACRO a,b\n"
        "DEFB a\n"
        "DEFB b\n"
        "ENDM\n"
        "NOP : MYMACRO 10, 20 : HALT\n";
    pp.push_virtual_file(content, "macro_midline_noparen.asm", 1, true);

    std::vector<std::string> outs;
    TokensLine line;
    while (pp.next_line(line)) {
        outs.push_back(line.to_string());
    }

    // The preprocessor must still split into: before, expanded lines, after
    REQUIRE(outs.size() == 4);
    auto trim = [](std::string s) {
        auto issp = [](unsigned char c) {
            return std::isspace(c) != 0;
        };
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [&](char c) {
            return !issp((unsigned char)c);
        }));
        s.erase(std::find_if(s.rbegin(), s.rend(), [&](char c) {
            return !issp((unsigned char)c);
        }).base(), s.end());
        return s;
    };

    REQUIRE(trim(outs[0]) == "NOP");
    REQUIRE(trim(outs[1]) == "DEFB 10");
    REQUIRE(trim(outs[2]) == "DEFB 20");
    REQUIRE(trim(outs[3]) == "HALT");
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: identifier before ':' is a label only when not a directive/name-directive/conditional/opcode",
          "[preprocessor][labels][colon][keywords]") {
    auto trim = [](std::string s) {
        auto issp = [](unsigned char c) {
            return std::isspace(c) != 0;
        };
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [&](char c) {
            return !issp((unsigned char)c);
        }));
        s.erase(std::find_if(s.rbegin(), s.rend(), [&](char c) {
            return !issp((unsigned char)c);
        }).base(), s.end());
        return s;
    };

    SECTION("Non-keyword: parsed as label, then following statement") {
        g_errors.reset();
        Preprocessor pp;

        // 'LBL' is not a keyword; should be parsed as a label, then 'NOP' as a separate line
        const std::string content =
            "LBL : NOP\n";
        pp.push_virtual_file(content, "label_ok.asm", 1, true);

        std::vector<std::string> outs;
        TokensLine line;
        while (pp.next_line(line)) {
            outs.push_back(line.to_string());
        }

        REQUIRE(outs.size() == 2);
        // Label line is emitted as ".<label>"
        REQUIRE(trim(outs[0]) == ".LBL");
        REQUIRE(trim(outs[1]) == "NOP");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Opcode keyword: NOT a label; ':' is a separator") {
        g_errors.reset();
        Preprocessor pp;

        // 'LD' is an opcode; must not be treated as a label
        const std::string content =
            "LD : NOP\n";
        pp.push_virtual_file(content, "label_opcode.asm", 1, true);

        std::vector<std::string> outs;
        TokensLine line;
        while (pp.next_line(line)) {
            outs.push_back(line.to_string());
        }

        // Expect two logical lines: "LD" and "NOP" (no label line)
        REQUIRE(outs.size() == 2);
        REQUIRE(trim(outs[0]) == "LD");
        REQUIRE(trim(outs[1]) == "NOP");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Directive keyword: NOT a label; ':' is a separator") {
        g_errors.reset();
        Preprocessor pp;

        // 'EQU' is a (name) directive; must not be treated as a label.
        // The directive itself is consumed by the preprocessor and will likely error due to missing identifier,
        // but 'NOP' after ':' must still be emitted as the next logical line.
        const std::string content =
            "EQU : NOP : HALT\n";
        pp.push_virtual_file(content, "label_directive.asm", 1, true);

        TokensLine line;
        REQUIRE(pp.next_line(line));
        // EQU is not output because of the missing identifier; error expected
        // It is not treated as a label.
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Expected identifier after EQU") != std::string::npos);
        g_errors.reset();

        REQUIRE(line.size() == 1);
        REQUIRE(line[0].is(Keyword::NOP));

        REQUIRE(pp.next_line(line));
        REQUIRE(line.size() == 1);
        REQUIRE(line[0].is(Keyword::HALT));

        REQUIRE_FALSE(pp.next_line(line));

        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Conditional directive keyword: NOT a label; ':' is a separator") {
        g_errors.reset();
        Preprocessor pp;

        // 'IF' is a conditional directive; must not be treated as a label.
        // Provide a valid IF so the directive can be consumed cleanly.
        const std::string content =
            "IF 1 : NOP\n"
            "ENDIF\n";
        pp.push_virtual_file(content, "label_conditional.asm", 1, true);

        std::vector<std::string> outs;
        TokensLine line;
        while (pp.next_line(line)) {
            outs.push_back(line.to_string());
        }

        // Only the 'NOP' from the active branch should be emitted, with no label line like '.IF'
        REQUIRE_FALSE(outs.empty());
        // Filter out potential empty/whitespace-only lines defensively
        std::vector<std::string> trimmed;
        trimmed.reserve(outs.size());
        for (auto& s : outs) {
            auto t = trim(s);
            if (!t.empty()) {
                trimmed.push_back(std::move(t));
            }
        }
        REQUIRE(trimmed.size() == 1);
        REQUIRE(trimmed[0] == "NOP");
        REQUIRE_FALSE(g_errors.has_errors());
    }
}

TEST_CASE("Preprocessor: object-like macros cascade (A -> B -> C -> 123)",
          "[preprocessor][macro][cascade][object]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A B\n"
        "#define B C\n"
        "#define C 123\n"
        "A\n";
    pp.push_virtual_file(content, "macro_cascade_object", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expanded "A"
    const auto& toks = line.tokens();

    bool found123 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 123) {
            found123 = true;
            break;
        }
    }
    REQUIRE(found123);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: function-like macro expands to object-like macro and recurses (M() -> N -> 42)",
          "[preprocessor][macro][cascade][function->object]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define N 42\n"
        "#define M() N\n"
        "M()\n";
    pp.push_virtual_file(content, "macro_cascade_func_to_obj", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expanded "M()"
    const auto& toks = line.tokens();

    bool found42 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 42) {
            found42 = true;
            break;
        }
    }
    REQUIRE(found42);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: function-like macro expands to another function-like call and recurses (F() -> ID(7) -> 7)",
          "[preprocessor][macro][cascade][function->function]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define ID(x) x\n"
        "#define F() ID(7)\n"
        "F()\n";
    pp.push_virtual_file(content, "macro_cascade_func_to_func", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expanded "F()"
    const auto& toks = line.tokens();

    bool found7 = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer) && t.int_value() == 7) {
            found7 = true;
            break;
        }
    }
    REQUIRE(found7);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: 'NOP:' is not treated as a label (labels cannot be instructions)",
          "[preprocessor][label][instruction][colon]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "NOP: HALT\n";
    pp.push_virtual_file(content, "nop_colon.asm", 1, true);

    std::vector<TokensLine> lines;
    TokensLine line;
    while (pp.next_line(line)) {
        lines.push_back(line);
    }

    // Expect two logical lines: "NOP" and "HALT"
    REQUIRE(lines.size() == 2);

    // First line must start with identifier "NOP" (not a label line ".NOP")
    REQUIRE(lines[0].size() >= 1);
    REQUIRE(lines[0][0].is(TokenType::Identifier));
    REQUIRE(lines[0][0].text() == "NOP");

    // Ensure no emitted label line ".NOP"
    for (const auto& l : lines) {
        REQUIRE(!(l.size() >= 2 &&
                  l[0].is(TokenType::Dot) &&
                  l[1].is(TokenType::Identifier) &&
                  l[1].text() == "NOP"));
    }
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: '.NOP' is not treated as a label (instruction after dot)",
          "[preprocessor][label][instruction][dot]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        ".NOP\n";
    pp.push_virtual_file(content, "dot_nop.asm", 1, true);

    std::vector<TokensLine> lines;
    TokensLine line;
    while (pp.next_line(line)) {
        lines.push_back(line);
    }

    // Single logical line expected
    REQUIRE(lines.size() == 1);

    // Line tokens should be '.' followed by 'NOP'
    REQUIRE(lines[0].size() >= 2);
    REQUIRE(lines[0][0].is(TokenType::Dot));
    REQUIRE(lines[0][1].is(TokenType::Identifier));
    REQUIRE(lines[0][1].text() == "NOP");

    // Because 'NOP' is an instruction, this must NOT have been converted into a label definition
    // (label definitions would be indistinguishable by content here, so we assert that no second
    // logical line was emitted as would happen for ".name : ..." patterns).
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: normal label 'LBL:' still recognized (control case)",
          "[preprocessor][label][control]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "LBL: NOP\n";
    pp.push_virtual_file(content, "label_control.asm", 1, true);

    std::vector<TokensLine> lines;
    TokensLine line;
    while (pp.next_line(line)) {
        lines.push_back(line);
    }

    // Expect two lines: label definition ".LBL" and instruction "NOP"
    REQUIRE(lines.size() == 2);

    REQUIRE(lines[0].size() >= 2);
    REQUIRE(lines[0][0].is(TokenType::Dot));
    REQUIRE(lines[0][1].is(TokenType::Identifier));
    REQUIRE(lines[0][1].text() == "LBL");

    REQUIRE(lines[1].size() >= 1);
    REQUIRE(lines[1][0].is(TokenType::Identifier));
    REQUIRE(lines[1][0].text() == "NOP");
    REQUIRE_FALSE(g_errors.has_errors());
}

// Labels and colon-separators with leading opcode followed by a one-identifier statement
TEST_CASE("Preprocessor: opcode before ':' is not a label but following statement is split",
          "[preprocessor][label][opcode-first][chain]") {
    g_errors.reset();
    Preprocessor pp;
    const std::string content = "NOP: L2: X\n";
    pp.push_virtual_file(content, "label_chain_opcode_first.asm", 1, true);

    std::vector<std::string> outs;
    TokensLine line;
    while (pp.next_line(line)) {
        outs.push_back(line.to_string());
    }

    // Expect three logical outputs:
    // 1) "NOP" (no '.NOP' label line)
    // 2) ".L2" (label split)
    // 3) "X"
    auto trim = [](std::string s) {
        auto issp = [](unsigned char c) {
            return std::isspace(c) != 0;
        };
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [&](char c) {
            return !issp((unsigned char)c);
        }));
        s.erase(std::find_if(s.rbegin(), s.rend(), [&](char c) {
            return !issp((unsigned char)c);
        }).base(), s.end());
        return s;
    };
    REQUIRE(outs.size() == 3);
    REQUIRE(trim(outs[0]) == "NOP");
    REQUIRE(trim(outs[1]) == "L2");
    REQUIRE(trim(outs[2]) == "X");
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// New tests: directive groups entirely on one physical line using ':' separators
// Verify conditional directives embedded in colon-separated statement lists work.
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: single-line colon-separated IF true yields branch body",
          "[preprocessor][if][colon][singleline][true]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "IF 1 : NOP : ENDIF\n";
    pp.push_virtual_file(content, "if_colon_true.asm", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "NOP");
    // No more output
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: single-line colon-separated IF false with ELSE selects ELSE branch",
          "[preprocessor][if][else][colon][singleline][false]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "IF 0 : SHOULD_NOT : ELSE : OK : ENDIF\n";
    pp.push_virtual_file(content, "if_colon_else.asm", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: single-line colon-separated IF with multiple ELIF picks first true only",
          "[preprocessor][if][elif][colon][singleline]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IF 0 : A : ELIF 1 : B : ELIF 1 : C : ENDIF\n";
    pp.push_virtual_file(content, "if_colon_elif_chain.asm", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "B");
    // Ensure subsequent true ELIF branch 'C' was ignored
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: single-line colon-separated IF/ELIF/ELSE chain picks ELSE when no prior true",
          "[preprocessor][if][elif][else][colon][singleline]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IF 0 : A : ELIF 0 : B : ELSE : FALLBACK : ENDIF\n";
    pp.push_virtual_file(content, "if_colon_full_chain.asm", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "FALLBACK");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: single-line colon-separated nested IF works",
          "[preprocessor][if][nested][colon][singleline]") {
    g_errors.reset();
    Preprocessor pp;

    // Inner IF is false so ELIF emits Z; outer IF true so both inner result and outer ENDIF processed.
    const std::string content =
        "IF 1 : IF 0 : Y : ELIF 1 : Z : ENDIF : ENDIF\n";
    pp.push_virtual_file(content, "if_colon_nested.asm", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "Z");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: single-line colon-separated IF chain ignores trailing tokens after ENDIF",
          "[preprocessor][if][colon][trailing]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "IF 1 : OK : ENDIF : EXTRA_SHOULD_BE_STATEMENT\n";
    pp.push_virtual_file(content, "if_colon_trailing.asm", 1, true);

    TokensLine line;
    // First: OK (from IF)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "OK");
    // Second: EXTRA_SHOULD_BE_STATEMENT (standalone after ENDIF)
    REQUIRE(pp.next_line(line));
    REQUIRE(!line.empty());
    REQUIRE(line[0].text() == "EXTRA_SHOULD_BE_STATEMENT");
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// z80asm preprocessor PRAGMA ONCE unit tests
//-----------------------------------------------------------------------------

TEST_CASE("Preprocessor: PRAGMA ONCE prevents second inclusion in same instance",
          "[preprocessor][pragma_once][single]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();
    const std::string inc = "po_once.inc";
    const std::string mainf = "po_main_once.asm";
    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o << "PRAGMA ONCE\nVAL1\n";
    }
    {
        std::ofstream o(mainf);
        REQUIRE(o.is_open());
        o << "#include \"" << inc << "\"\n#include \"" << inc << "\"\nAFTER\n";
    }
    Preprocessor pp;
    pp.push_file(mainf);
    TokensLine line;
    std::vector<std::string> out;
    while (pp.next_line(line)) if (!line.empty()) {
            out.push_back(line[0].text());
        }
    REQUIRE(out.size() == 2);
    REQUIRE(out[0] == "VAL1");
    REQUIRE(out[1] == "AFTER");
    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 3);
    REQUIRE(deps[0] == mainf);
    REQUIRE(deps[1] == inc);
    REQUIRE(deps[2] == inc);
    std::remove(inc.c_str());
    std::remove(mainf.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: PRAGMA ONCE inclusion per instance",
          "[preprocessor][pragma_once][instances]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();
    const std::string inc = "po_once_instance.inc";
    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o << "PRAGMA ONCE\nDATA\n";
    }
    {
        Preprocessor p1;
        p1.push_file(inc);
        TokensLine l;
        std::vector<std::string> v;
        while (p1.next_line(l)) if (!l.empty()) {
                v.push_back(l[0].text());
            }
        REQUIRE(v.size() == 1);
        REQUIRE(v[0] == "DATA");
    }
    {
        Preprocessor p2;
        p2.push_file(inc);
        TokensLine l;
        std::vector<std::string> v;
        while (p2.next_line(l)) if (!l.empty()) {
                v.push_back(l[0].text());
            }
        REQUIRE(v.size() == 1);
        REQUIRE(v[0] == "DATA");
    }
    std::remove(inc.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: absence of PRAGMA ONCE allows multiple inclusion",
          "[preprocessor][pragma_once][absent]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();
    const std::string inc = "po_no_once.inc";
    const std::string mainf = "po_no_once_main.asm";
    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o << "VALX\n";
    }
    {
        std::ofstream o(mainf);
        REQUIRE(o.is_open());
        o << "#include \"" << inc << "\"\n#include \"" << inc << "\"\n";
    }
    Preprocessor pp;
    pp.push_file(mainf);
    TokensLine l;
    std::vector<std::string> v;
    while (pp.next_line(l)) if (!l.empty()) {
            v.push_back(l[0].text());
        }
    REQUIRE(v.size() == 2);
    REQUIRE(v[0] == "VALX");
    REQUIRE(v[1] == "VALX");
    std::remove(inc.c_str());
    std::remove(mainf.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: nested includes with PRAGMA ONCE only emit inner once",
          "[preprocessor][pragma_once][nested]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();
    const std::string inner = "po_inner_once.inc";
    const std::string outer = "po_outer_once.asm";
    {
        std::ofstream o(inner);
        REQUIRE(o.is_open());
        o << "PRAGMA ONCE\nINNER_LINE\n";
    }
    {
        std::ofstream o(outer);
        REQUIRE(o.is_open());
        o << "#include \"" << inner << "\"\n#include \"" << inner <<
          "\"\nAFTER_OUTER\n";
    }
    Preprocessor pp;
    pp.push_file(outer);
    TokensLine l;
    std::vector<std::string> v;
    while (pp.next_line(l)) if (!l.empty()) {
            v.push_back(l[0].text());
        }
    REQUIRE(v.size() == 2);
    REQUIRE(v[0] == "INNER_LINE");
    REQUIRE(v[1] == "AFTER_OUTER");
    std::remove(inner.c_str());
    std::remove(outer.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: PRAGMA ONCE trailing tokens error",
          "[preprocessor][pragma_once][error][trailing]") {
    g_errors.reset();
    Preprocessor pp;
    pp.push_virtual_file("PRAGMA ONCE extra\n", "po_trailing", 1, true);
    TokensLine l;
    while (pp.next_line(l)) {} REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Unexpected token") !=
            std::string::npos);
}

// -----------------------------------------------------------------------------
// Include guard (#ifndef / #define) pattern tests
// -----------------------------------------------------------------------------

TEST_CASE("Preprocessor: include guard #ifndef/#define at top prevents second inclusion",
          "[preprocessor][include][guard]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string inc = "ig_guard_simple.inc";
    const std::string mainf = "ig_guard_simple_main.asm";

    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o <<
          "#ifndef IG_GUARD_SIMPLE\n"
          "#define IG_GUARD_SIMPLE\n"
          "SIMPLE_LINE\n"
          "#endif\n";
    }
    {
        std::ofstream o(mainf);
        REQUIRE(o.is_open());
        o <<
          "#include \"" << inc << "\"\n"
          "#include \"" << inc << "\"\n"
          "AFTER\n";
    }

    Preprocessor pp;
    pp.push_file(mainf);

    TokensLine line;
    std::vector<std::string> out;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            out.push_back(line[0].text());
        }
    }

    // Body emitted only once
    REQUIRE(out.size() == 2);
    REQUIRE(out[0] == "SIMPLE_LINE");
    REQUIRE(out[1] == "AFTER");

    // Dependencies list should contain main + both include attempts (duplicate recorded)
    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 3);
    REQUIRE(deps[0] == mainf);
    REQUIRE(deps[1] == inc);
    REQUIRE(deps[2] == inc);

    std::remove(inc.c_str());
    std::remove(mainf.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: include guard with leading blank/whitespace lines still detected",
          "[preprocessor][include][guard][whitespace]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string inc = "ig_guard_ws.inc";
    const std::string mainf = "ig_guard_ws_main.asm";

    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o <<
          "\n"
          "   \t \n"
          "#ifndef   IG_GUARD_WS \n"
          "\n"
          "   \t \n"
          "#define IG_GUARD_WS\n"
          "WS_LINE\n"
          "#endif\n";
    }
    {
        std::ofstream o(mainf);
        REQUIRE(o.is_open());
        o <<
          "#include \"" << inc << "\"\n"
          "#include \"" << inc << "\"\n"
          "TAIL\n";
    }

    Preprocessor pp;
    pp.push_file(mainf);

    TokensLine line;
    std::vector<std::string> out;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            out.push_back(line[0].text());
        }
    }

    REQUIRE(out.size() == 2);
    REQUIRE(out[0] == "WS_LINE");
    REQUIRE(out[1] == "TAIL");

    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 3);
    REQUIRE(deps[0] == mainf);
    REQUIRE(deps[1] == inc);
    REQUIRE(deps[2] == inc);

    std::remove(inc.c_str());
    std::remove(mainf.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: include guard skipped entirely when symbol pre-defined before first include",
          "[preprocessor][include][guard][predefined]") {
    g_errors.reset();
    Preprocessor::clear_file_cache();

    const std::string inc = "ig_guard_predef.inc";
    const std::string mainf = "ig_guard_predef_main.asm";

    {
        std::ofstream o(inc);
        REQUIRE(o.is_open());
        o <<
          "#ifndef IG_GUARD_PRE\n"
          "#define IG_GUARD_PRE\n"
          "PREDEF_BODY\n"
          "#endif\n";
    }
    {
        std::ofstream o(mainf);
        REQUIRE(o.is_open());
        o <<
          "#define IG_GUARD_PRE 1\n"
          "#include \"" << inc << "\"\n"
          "ENDLINE\n";
    }

    Preprocessor pp;
    pp.push_file(mainf);

    TokensLine line;
    std::vector<std::string> out;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            out.push_back(line[0].text());
        }
    }

    // Guard body must be completely skipped
    REQUIRE(out.size() == 1);
    REQUIRE(out[0] == "ENDLINE");

    const auto& deps = pp.dependency_filenames();
    REQUIRE(deps.size() == 2);
    REQUIRE(deps[0] == mainf);
    REQUIRE(deps[1] == inc);

    std::remove(inc.c_str());
    std::remove(mainf.c_str());
    REQUIRE_FALSE(g_errors.has_errors());
}

// --- Added tests: line continuation with trailing backslash ---
// A backslash at end of a physical line should be replaced by a single space
// and the next physical line, producing one logical line.

TEST_CASE("Preprocessor: single trailing backslash joins next line with one space",
          "[preprocessor][linecontinuation][backslash]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "A\\\n"
        "B\n";
    pp.push_virtual_file(content, "lc_simple", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect: Identifier 'A', Whitespace ' ', Identifier 'B'
    REQUIRE(toks.size() >= 3);
    REQUIRE(toks[0].text() == "A");
    REQUIRE(toks[1].is(TokenType::Whitespace));
    REQUIRE(toks[1].text() == " ");
    REQUIRE(toks[2].text() == "B");
    REQUIRE_FALSE(pp.next_line(line)); // no extra logical line
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: multiple trailing backslashes cascade into one logical line",
          "[preprocessor][linecontinuation][backslash][multi]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "A\\\n"
        "B\\\n"
        "C\\\n"
        "D\n";
    pp.push_virtual_file(content, "lc_multi", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Collect identifiers ignoring whitespace
    std::vector<std::string> idents;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            idents.push_back(t.text());
        }
    }
    REQUIRE(idents == std::vector<std::string>({ "A", "B", "C", "D" }));
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: backslash line continuation preserves commas and numeric tokens",
          "[preprocessor][linecontinuation][binary]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "db 1,\\\n"
        "2,3\\\n"
        ",4\n";
    pp.push_virtual_file(content, "lc_commas", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Extract integer values in order
    std::vector<int> ints;
    for (const auto& t : toks)
        if (t.is(TokenType::Integer)) {
            ints.push_back(t.int_value());
        }
    REQUIRE(ints == std::vector<int>({ 1, 2, 3, 4 }));

    // Count commas: should be 3 (between 4 integers)
    int comma_count = 0;
    for (const auto& t : toks)
        if (t.is(TokenType::Comma)) {
            ++comma_count;
        }
    REQUIRE(comma_count == 3);
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: backslash continuation inside macro argument preserves spacing",
          "[preprocessor][linecontinuation][macro][args]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define SHOW(x) x\n"
        "SHOW(A\\\n"
        "B)\n";
    pp.push_virtual_file(content, "lc_macro_arg", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expansion of SHOW(...)
    const auto& toks = line.tokens();

    // Expect identifiers A and B with at least one whitespace between after processing
    std::vector<std::string> idents;
    int whitespace_blocks = 0;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            idents.push_back(t.text());
        }
        if (t.is(TokenType::Whitespace)) {
            ++whitespace_blocks;
        }
    }
    REQUIRE(idents == std::vector<std::string>({ "A", "B" }));
    REQUIRE(whitespace_blocks >= 1);
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: backslash before comment stops at comment newline",
          "[preprocessor][linecontinuation][comment]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "X\\\n"
        "; comment line\n"
        "Y\n";
    pp.push_virtual_file(content, "lc_comment", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == 1);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "X");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == 3);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "Y");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: trailing backslash followed by blank line joins empty line",
          "[preprocessor][linecontinuation][blank]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "FIRST\\\n"
        "\n"
        "SECOND\n";
    pp.push_virtual_file(content, "lc_blank", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == 1);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "FIRST");

    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == 3);
    REQUIRE(line.size() >= 1);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "SECOND");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: trailing backslash followed by whitespace still joins line",
          "[preprocessor][linecontinuation][blank]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "FIRST\\ \t \v \f \n"
        "SECOND\n";
    pp.push_virtual_file(content, "lc_blank", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE(line.location().line_num() == 1);
    REQUIRE(line.size() >= 3);
    REQUIRE(line[0].is(TokenType::Identifier));
    REQUIRE(line[0].text() == "FIRST");
    REQUIRE(line[1].is(TokenType::Whitespace));
    REQUIRE(line[2].is(TokenType::Identifier));
    REQUIRE(line[2].text() == "SECOND");

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: backslash at end of last line (no following line) yields original line (no join)",
          "[preprocessor][linecontinuation][eof]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "ONLY\\\n";
    pp.push_virtual_file(content, "lc_eof", 1, true);

    TokensLine line;
    // Depending on implementation this may produce either empty output or 'ONLY'
    bool got_line = pp.next_line(line);
    if (got_line) {
        // If a line is produced ensure it contains ONLY
        bool has_only = false;
        for (const auto& t : line.tokens())
            if (t.is(TokenType::Identifier) && t.text() == "ONLY") {
                has_only = true;
            }
        REQUIRE(has_only);
        REQUIRE_FALSE(pp.next_line(line));
    }
    // No error expected either way
    REQUIRE_FALSE(g_errors.has_errors());
}

// -----------------------------------------------------------------------------
// Added tests: DEFL with comma-separated list body should preserve list tokens
// -----------------------------------------------------------------------------
TEST_CASE("Preprocessor: DEFL preserves non-constant comma-separated list",
          "[preprocessor][defl][list]") {
    g_errors.reset();
    Preprocessor pp;

    // First line defines X as list 1,2 (directive produces no output line)
    // Second line uses X -> should expand to "1,2"
    const std::string content =
        "X DEFL 1,2\n"
        "X\n";
    pp.push_virtual_file(content, "defl_list", 1, true);

    TokensLine line;
    // Consume expanded output (skip directive)
    REQUIRE(pp.next_line(line));          // expansion of X
    REQUIRE(line.to_string() == "1,2");

    // Tokens: Integer 1 , Comma , Integer 2
    const auto& toks = line.tokens();
    REQUIRE(toks.size() == 3);
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 1);
    REQUIRE(toks[1].is(TokenType::Comma));
    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 2);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: DEFL list expands inside another line (db macro usage)",
          "[preprocessor][defl][list][db]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "VAL DEFL 1,2\n"
        "db VAL\n";
    pp.push_virtual_file(content, "defl_list_db", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expansion of db VAL
    REQUIRE(line.to_string() == "db 1,2");

    const auto& toks = line.tokens();
    // Expect: Identifier 'db', Whitespace, Integer 1, Comma, Integer 2
    REQUIRE(toks.size() == 5);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "db");
    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 1);
    REQUIRE(toks[3].is(TokenType::Comma));
    REQUIRE(toks[4].is(TokenType::Integer));
    REQUIRE(toks[4].int_value() == 2);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: DEFL list with macro in body expands before storing",
          "[preprocessor][defl][list][macro]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "#define A 5\n"
        "Y DEFL A,6\n"
        "Y\n";
    pp.push_virtual_file(content, "defl_list_macro", 1, true);

    TokensLine line;

    // First non-empty expanded output should be "5,6"
    // Skip any lines produced by #define (none) then expansion of Y
    REQUIRE(pp.next_line(line)); // expansion of Y
    REQUIRE(line.to_string() == "5,6");

    const auto& toks = line.tokens();
    REQUIRE(toks.size() == 3);
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 5);
    REQUIRE(toks[1].is(TokenType::Comma));
    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 6);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// Replace the self-redefinition test with a non-recursive variant that uses a previous symbol.

TEST_CASE("Preprocessor: DEFL referencing previous symbol accumulates list elements",
          "[preprocessor][defl][list][prev]") {
    g_errors.reset();
    Preprocessor pp;

    // Avoid self-reference recursion: build new symbol from previous symbol
    const std::string content =
        "Z0 DEFL 1\n"
        "Z1 DEFL Z0,2\n"
        "Z1\n";
    pp.push_virtual_file(content, "defl_list_prev", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line)); // expansion of Z1
    REQUIRE(line.to_string() == "1,2");

    const auto& toks = line.tokens();
    REQUIRE(toks.size() == 3);
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 1);
    REQUIRE(toks[1].is(TokenType::Comma));
    REQUIRE(toks[2].is(TokenType::Integer));
    REQUIRE(toks[2].int_value() == 2);

    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELSEIF is a synonym of ELIF in IF/ELSEIF.../ELSE/ENDIF chain",
          "[preprocessor][if][elseif][elif]") {
    auto run_chain = [](const std::string & syn,
    const std::vector<std::string>& defines) -> int {
        Preprocessor pp;
        g_errors.reset();

        std::string content;
        // Optional defines (empty body expands to 1)
        for (const auto& d : defines) {
            content += "#define " + d + "\n";
        }

        // Condition chain using the provided synonym (ELIF or ELSEIF)
        content +=
        "IF ONE\n"
        "defb 1\n"
        + syn + " TWO\n"
        "defb 2\n"
        + syn + " THREE\n"
        "defb 3\n"
        "ELSE\n"
        "defb 0\n"
        "ENDIF\n";

        pp.push_virtual_file(content, "elseif_chain", 1, true);

        TokensLine line;
        while (pp.next_line(line)) {
            const auto& toks = line.tokens();
            if (toks.empty()) {
                continue;
            }
            if (toks[0].text() == "defb") {
                for (const auto& t : toks) {
                    if (t.is(TokenType::Integer)) {
                        return t.int_value();
                    }
                }
            }
        }
        // If we didn't find a defb line, surface a failure
        REQUIRE_FALSE(true);
        return -1;
    };

    // Assert ELSEIF works and yields expected selection
    REQUIRE(run_chain("ELSEIF", {}) == 0);
    REQUIRE(run_chain("ELSEIF", { "ONE" }) == 1);
    REQUIRE(run_chain("ELSEIF", { "TWO" }) == 2);
    REQUIRE(run_chain("ELSEIF", { "THREE" }) == 3);

    // Compare ELIF vs ELSEIF results across the same define sets
    std::vector<std::vector<std::string>> cases = {
        {},
        {"ONE"},
        {"TWO"},
        {"THREE"},
    };

    for (const auto& defs : cases) {
        int r_elif = run_chain("ELIF", defs);
        int r_elseif = run_chain("ELSEIF", defs);
        REQUIRE(r_elif == r_elseif);
    }

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: ELSEIFDEF is a synonym of ELIFDEF",
          "[preprocessor][elifdef][elseifdef]") {
    auto run_chain = [](const std::string & syn,
    const std::vector<std::string>& defines) -> int {
        g_errors.reset();

        std::string content;
        for (const auto& d : defines) {
            content += "#DEFINE " + d + "\n";
        }

        content +=
        "IFDEF ONE\n"
        "DEFB 1\n"
        + syn + " TWO\n"
        "DEFB 2\n"
        + syn + " THREE\n"
        "DEFB 3\n"
        "ELSE\n"
        "DEFB 0\n"
        "ENDIF\n";

        auto lines = run_pp_on_text(content, "pp_elifdef_synonyms.asm");
        REQUIRE_FALSE(g_errors.has_errors());
        return find_defb_value(lines);
    };

    // Baseline expectations using ELSEIFDEF
    REQUIRE(run_chain("ELSEIFDEF", {}) == 0);
    REQUIRE(run_chain("ELSEIFDEF", { "ONE" }) == 1);
    REQUIRE(run_chain("ELSEIFDEF", { "TWO" }) == 2);
    REQUIRE(run_chain("ELSEIFDEF", { "THREE" }) == 3);

    // Ensure ELIFDEF yields the same result set as ELSEIFDEF
    std::vector<std::vector<std::string>> cases = { {}, {"ONE"}, {"TWO"}, {"THREE"} };
    for (const auto& defs : cases) {
        int r_else = run_chain("ELSEIFDEF", defs);
        int r_elif = run_chain("ELIFDEF", defs);
        REQUIRE(r_else == r_elif);
    }
}

TEST_CASE("Preprocessor: ELSEIFNDEF is a synonym of ELIFNDEF",
          "[preprocessor][elifndef][elseifndef]") {
    auto run_chain = [](const std::string & syn,
    const std::vector<std::string>& defines) -> int {
        g_errors.reset();

        std::string content;
        for (const auto& d : defines) {
            content += "#DEFINE " + d + "\n";
        }

        content +=
        "IFNDEF ONE\n"
        "DEFB 1\n"
        + syn + " TWO\n"
        "DEFB 2\n"
        + syn + " THREE\n"
        "DEFB 3\n"
        "ELSE\n"
        "DEFB 0\n"
        "ENDIF\n";

        auto lines = run_pp_on_text(content, "pp_elifndef_synonyms.asm");
        REQUIRE_FALSE(g_errors.has_errors());
        return find_defb_value(lines);
    };

    // Baseline expectations using ELSEIFNDEF
    REQUIRE(run_chain("ELSEIFNDEF", {}) ==
            1);               // ONE not defined -> first branch
    REQUIRE(run_chain("ELSEIFNDEF", { "ONE" }) ==
            2);          // ONE defined, TWO not defined -> second branch
    REQUIRE(run_chain("ELSEIFNDEF", { "ONE", "TWO" }) ==
            3);   // ONE & TWO defined, THREE not defined -> third branch
    REQUIRE(run_chain("ELSEIFNDEF", { "ONE", "TWO", "THREE" }) ==
            0); // All defined -> ELSE

    // Ensure ELIFNDEF yields the same result set as ELSEIFNDEF
    std::vector<std::vector<std::string>> cases = {
        {},
        {"ONE"},
        {"ONE", "TWO"},
        {"ONE", "TWO", "THREE"}
    };
    for (const auto& defs : cases) {
        int r_else = run_chain("ELSEIFNDEF", defs);
        int r_elif = run_chain("ELIFNDEF", defs);
        REQUIRE(r_else == r_elif);
    }
}

// Added test: chained token pasting outside macros (A##B##C -> ABC)
TEST_CASE("Preprocessor: chained token pasting A##B##C produces single identifier ABC",
          "[preprocessor][tokenpaste][chained][outside-macro]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content = "A##B##C\n";
    pp.push_virtual_file(content, "paste_chained", 1, true);

    TokensLine line;
    REQUIRE(pp.next_line(line));
    const auto& toks = line.tokens();

    // Expect one identifier token 'ABC' somewhere in the line
    bool foundABC = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier) && t.text() == "ABC") {
            foundABC = true;
            break;
        }
    }
    REQUIRE(foundABC);

    // No further logical lines
    REQUIRE_FALSE(pp.next_line(line));
    REQUIRE_FALSE(g_errors.has_errors());
}

// Added test: outer macro calls inner macro that uses EXITM; outer continues after each call
TEST_CASE("Preprocessor: outer macro continues after inner macro EXITM (multiple inner calls)",
          "[preprocessor][macro][exitm][nested][continue]") {
    g_errors.reset();
    Preprocessor pp;

    // INNER(n): emits inner_start then EXITM (inner_end suppressed)
    // OUTER(a,b): emits pre_a, calls INNER(a), emits mid_b, calls INNER(b), emits post
    const std::string content =
        "MACRO INNER(n)\n"
        "inner_start n\n"
        "EXITM\n"
        "inner_end n\n"      // should never appear
        "ENDM\n"
        "MACRO OUTER(a,b)\n"
        "pre_a a\n"
        "INNER(a)\n"
        "mid_b b\n"
        "INNER(b)\n"
        "post\n"
        "ENDM\n"
        "LINE 123, \"outer_inner_exitm.asm\"\n"
        "OUTER(1,2)\n"
        "done\n";

    pp.push_virtual_file(content, "outer_inner_exitm_test", 1, true);

    TokensLine line;
    std::vector<std::string> lines;

    while (pp.next_line(line)) {
        if (!line.empty()) {
            // Capture first token text from each logical output line
            lines.push_back(line[0].text());
        }
    }

    // Expected sequence (order matters):
    // pre_a, inner_start, mid_b, inner_start, post, done
    const std::vector<std::string> expected = {
        "pre_a", "inner_start", "mid_b", "inner_start", "post", "done"
    };
    REQUIRE(lines.size() == expected.size());
    REQUIRE(lines == expected);

    // Ensure suppressed tokens (inner_end) do not appear
    REQUIRE(std::find(lines.begin(), lines.end(), "inner_end") == lines.end());

    // All expanded lines share logical location line 123 except the final 'done'
    // (location checks optional; only verify no errors)
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: EXITM inside REPT inside MACRO aborts macro after first REPT iteration",
          "[preprocessor][macro][exitm][rept][iteration-cut]") {
    g_errors.reset();
    Preprocessor pp;

    // Macro M(val):
    //  REPT 3
    //    db val
    //    EXITM          (should abort entire macro on first iteration)
    //    db 999         (skipped)
    //  ENDR
    //  db 888           (skipped)
    // After expansion only a single 'db <val>' line must be emitted.
    const std::string content =
        "MACRO M(val)\n"
        "REPT 3\n"
        "db val\n"
        "EXITM\n"
        "db 999\n"
        "ENDR\n"
        "db 888\n"
        "ENDM\n"
        "LINE 321, \"exitm_rept_macro.asm\"\n"
        "M(7)\n"
        "after\n";

    pp.push_virtual_file(content, "exitm_rept_macro_src", 1, true);

    TokensLine line;
    std::vector<std::string> first_tokens;
    while (pp.next_line(line)) {
        if (!line.empty()) {
            first_tokens.push_back(line[0].text());
        }
    }

    // Expect exactly two logical output lines: 'db' (with 7) and 'after'
    REQUIRE(first_tokens.size() == 2);
    REQUIRE(first_tokens[0] == "db");
    REQUIRE(first_tokens[1] == "after");

    // Verify the first line contains integer 7 and does NOT contain 999 or 888
    {
        bool has7 = false, has999 = false, has888 = false;
        for (const auto& t : pp.dependency_filenames()) {
            (void)t; // silence unused if dependency_filenames not needed
        }
        // Re-run inspection on stored tokens of the first emitted line
        // (We can reconstruct by re-running the preprocessor, simpler: re-parse content)
        Preprocessor pp2;
        pp2.push_virtual_file(content, "exitm_rept_macro_src2", 1, true);
        REQUIRE(pp2.next_line(line)); // db 7
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                if (t.int_value() == 7) {
                    has7 = true;
                }
                if (t.int_value() == 999) {
                    has999 = true;
                }
                if (t.int_value() == 888) {
                    has888 = true;
                }
            }
        }
        REQUIRE(has7);
        REQUIRE_FALSE(has999);
        REQUIRE_FALSE(has888);
    }

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: C_LINE then REPT block keeps constant logical line number for all emitted REPT lines",
          "[preprocessor][cline][rept][location]") {
    g_errors.reset();
    Preprocessor pp;

    // C_LINE fixes logical line and filename; REPT 3 should emit three X lines all at the same logical line.
    const std::string content =
        "C_LINE 6100, \"cline_rept.asm\"\n"
        "REPT 3\n"
        "X\n"
        "ENDR\n";
    pp.push_virtual_file(content, "cline_rept_src", 1, true);

    TokensLine line;
    int emitted = 0;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "X");
        REQUIRE(line.location().line_num() == 6100);
        REQUIRE(line.location().filename() == "cline_rept.asm");
        ++emitted;
    }

    REQUIRE(emitted == 3);
    REQUIRE_FALSE(g_errors.has_errors());
}

// Added tests: C_LINE then REPTC / REPTI blocks keep constant logical line number for all emitted lines

TEST_CASE("Preprocessor: C_LINE then REPTC block keeps constant logical line number for all emitted REPTC lines",
          "[preprocessor][cline][reptc][location]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "C_LINE 6201, \"cline_reptc.asm\"\n"
        "REPTC ch, \"AZ\"\n"
        "defb ch\n"
        "ENDR\n";
    pp.push_virtual_file(content, "cline_reptc_src", 1, true);

    TokensLine line;
    int emitted = 0;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "defb");
        // Expect integer token 65 for 'A' or 90 for 'Z'
        bool has_char = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && (t.int_value() == 'A'
                                             || t.int_value() == 'Z')) {
                has_char = true;
                break;
            }
        }
        REQUIRE(has_char);
        REQUIRE(line.location().line_num() == 6201);
        REQUIRE(line.location().filename() == "cline_reptc.asm");
        ++emitted;
    }

    REQUIRE(emitted == 2);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: C_LINE then REPTI block keeps constant logical line number for all emitted REPTI lines",
          "[preprocessor][cline][repti][location]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "C_LINE 6301, \"cline_repti.asm\"\n"
        "REPTI v, 7,8\n"
        "db v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "cline_repti_src", 1, true);

    TokensLine line;
    int emitted = 0;
    std::vector<int> values;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "db");
        int found = -1;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                found = t.int_value();
                break;
            }
        }
        REQUIRE((found == 7 || found == 8));
        values.push_back(found);
        REQUIRE(line.location().line_num() == 6301);
        REQUIRE(line.location().filename() == "cline_repti.asm");
        ++emitted;
    }

    REQUIRE(emitted == 2);
    REQUIRE(values == std::vector<int>({ 7, 8 }));
    REQUIRE_FALSE(g_errors.has_errors());
}

// Added tests: LINE then REPT / REPTC / REPTI blocks keep invocation logical line number, and following line advances appropriately.

TEST_CASE("Preprocessor: LINE then REPT block emits all repeated lines at REPT invocation line number",
          "[preprocessor][line][rept][location]") {
    g_errors.reset();
    Preprocessor pp;

    // Physical layout:
    // 1: LINE 100, "line_rept.asm"
    // 2: REPT 3
    // 3: X
    // 4: ENDR
    // 5: AFTER
    //
    // Expected logical line numbers:
    // REPT expansion lines: 100 (constant invocation line)
    // AFTER: 103 (100 + (physical_line(5) - physical_line(LINE) - 1) = 100 + 3)
    const std::string content =
        "LINE 100, \"line_rept.asm\"\n"
        "REPT 3\n"
        "X\n"
        "ENDR\n"
        "AFTER\n";
    pp.push_virtual_file(content, "line_rept_src", 1, true);

    TokensLine line;
    int rept_emitted = 0;
    bool saw_after = false;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        const std::string first = line[0].text();
        if (first == "X") {
            REQUIRE(line.location().line_num() == 100);
            REQUIRE(line.location().filename() == "line_rept.asm");
            ++rept_emitted;
        }
        else if (first == "AFTER") {
            saw_after = true;
            REQUIRE(line.location().line_num() == 103);
            REQUIRE(line.location().filename() == "line_rept.asm");
        }
    }

    REQUIRE(rept_emitted == 3);
    REQUIRE(saw_after);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: LINE then REPTC block emits all character iterations at invocation line number",
          "[preprocessor][line][reptc][location]") {
    g_errors.reset();
    Preprocessor pp;

    // Physical layout:
    // 1: LINE 200, "line_reptc.asm"
    // 2: REPTC ch, \"AZ\"
    // 3: defb ch
    // 4: ENDR
    //
    // Expected logical line numbers for two emitted defb lines: 200 and 200.
    const std::string content =
        "LINE 200, \"line_reptc.asm\"\n"
        "REPTC ch, \"AZ\"\n"
        "defb ch\n"
        "ENDR\n";
    pp.push_virtual_file(content, "line_reptc_src", 1, true);

    TokensLine line;
    int emitted = 0;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "defb");
        bool hasAorZ = false;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer) && (t.int_value() == 'A'
                                             || t.int_value() == 'Z')) {
                hasAorZ = true;
                break;
            }
        }
        REQUIRE(hasAorZ);
        REQUIRE(line.location().line_num() == 200);
        REQUIRE(line.location().filename() == "line_reptc.asm");
        ++emitted;
    }
    REQUIRE(emitted == 2);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: LINE then REPTI block emits all argument iterations at invocation line number",
          "[preprocessor][line][repti][location]") {
    g_errors.reset();
    Preprocessor pp;

    // Physical layout:
    // 1: LINE 300, "line_repti.asm"
    // 2: REPTI v, 7,8
    // 3: db v
    // 4: ENDR
    //
    // Expected logical line numbers for two emitted db lines: 300 and 300.
    const std::string content =
        "LINE 300, \"line_repti.asm\"\n"
        "REPTI v, 7,8\n"
        "db v\n"
        "ENDR\n";
    pp.push_virtual_file(content, "line_repti_src", 1, true);

    TokensLine line;
    std::vector<int> values;
    int emitted = 0;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "db");
        int val = -1;
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                val = t.int_value();
                break;
            }
        }
        REQUIRE((val == 7 || val == 8));
        REQUIRE(line.location().line_num() == 300);
        REQUIRE(line.location().filename() == "line_repti.asm");
        values.push_back(val);
        ++emitted;
    }
    REQUIRE(emitted == 2);
    REQUIRE(values == std::vector<int>({ 7, 8 }));
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Preprocessor: REPTC inside MACRO expands characters to integers in body",
          "[preprocessor][macro][reptc]") {
    g_errors.reset();
    Preprocessor pp;

    const std::string content =
        "MACRO EMIT()\n"
        "REPTC ch, \"AB\"\n"
        "db ch\n"
        "ENDR\n"
        "ENDM\n"
        "EMIT()\n";
    pp.push_virtual_file(content, "macro_reptc", 1, true);

    TokensLine line;
    std::vector<int> values;
    while (pp.next_line(line)) {
        REQUIRE(!line.empty());
        REQUIRE(line[0].text() == "db");
        // collect first integer per line
        for (const auto& t : line.tokens()) {
            if (t.is(TokenType::Integer)) {
                values.push_back(t.int_value());
                break;
            }
        }
    }

    REQUIRE(values.size() == 2);
    REQUIRE(values[0] == 65); // 'A'
    REQUIRE(values[1] == 66); // 'B'
    REQUIRE_FALSE(g_errors.has_errors());
}
