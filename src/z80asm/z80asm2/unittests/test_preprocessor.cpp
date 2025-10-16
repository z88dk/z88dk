//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "catch_amalgamated.hpp"
#include "../preprocessor.h"
#include "../error_reporter.h"
#include <fstream>
#include <string>
#include <vector>
#include <cstdio> // for std::remove

// Helper to capture std::cerr output
class CerrRedirect {
    std::ostringstream ss;
    std::streambuf* old;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

// Track all temp files created
static std::vector<std::string> temp_files;

// Helper: Write lines to a temporary file
static std::string write_temp_file(const std::vector<std::string>& lines) {
    static int counter = 0;
    std::string filename = "test_preproc_tmp_" + std::to_string(counter++) + ".asm";
    std::ofstream ofs(filename);
    for (const auto& line : lines) {
        ofs << line << "\n";
    }
    ofs.close();
    temp_files.push_back(filename);
    return filename;
}

// Add explicit tracking for manually created files
static void track_temp_file(const std::string& filename) {
    temp_files.push_back(filename);
}

// RAII cleanup for temp files
struct TempFileCleaner {
    ~TempFileCleaner() {
        for (const auto& f : temp_files) {
            std::remove(f.c_str());
        }
        temp_files.clear();
    }
};

// Instantiate the cleaner at file scope so it runs after all tests
static TempFileCleaner temp_file_cleaner;

TEST_CASE("Preprocessor normalizes all line endings to NL",
          "[preprocessor][line_endings]") {
    ErrorReporter reporter;
    std::string line;
    Location loc;

    SECTION("Handles LF (\\n) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\nline2\nline3\n";
        }
        Preprocessor pp(reporter);
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line, loc));
    }

    SECTION("Handles CR (\\r) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\rline2\rline3\r";
        }
        Preprocessor pp(reporter);
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line, loc));
    }

    SECTION("Handles CRLF (\\r\\n) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\r\nline2\r\nline3\r\n";
        }
        Preprocessor pp(reporter);
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line, loc));
    }

    SECTION("Handles mixed line endings") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\rline2\nline3\r\nline4";
        }
        Preprocessor pp(reporter);
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line3");
        REQUIRE(pp.next_line(line, loc));
        CHECK(line == "line4");
        REQUIRE_FALSE(pp.next_line(line, loc));
    }

    SECTION("Handles empty input") {
        std::string filename = write_temp_file({});
        Preprocessor pp(reporter);
        REQUIRE(pp.open(filename));
        REQUIRE_FALSE(pp.next_line(line, loc));
    }
}

TEST_CASE("Preprocessor: open() and next_line() basic", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = { "LD A,1", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: open() returns true and next_line() returns false for empty file",
          "[preprocessor][emptyfile]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {}; // empty file
    std::string filename = write_temp_file(lines);

    // open() should succeed even for an empty file
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // next_line() should immediately return false
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: removes comments", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = { "LD A,1 ; comment", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: removes C-style single-line comments",
          "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = { "LD A,1 // comment", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: removes C-style multi-line comments",
          "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A,1 /* comment */ LD B,2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1 LD B,2");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: removes multi-line C-style comments spanning lines",
          "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A,/* comment",
        "and comment",
        "continues here */2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,2");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: removes C-style comment in the middle of a line",
          "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = { "a/**/b" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ab");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: include directive", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    // Create included file
    std::vector<std::string> inc_lines = { "LD C,3" };
    std::string inc_filename = write_temp_file(inc_lines);
    // Main file with include
    std::vector<std::string> lines = { "#include \"" + inc_filename + "\"", "LD A,1" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro object-like expansion", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define FOO 42",
        "LD A,FOO"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // #define is not output
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,42");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro function-like expansion", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define ADD(x,y) x+y",
        "LD A,ADD(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // #define is not output
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1+2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: undef macro", "[preprocessor]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define FOO 99",
        "#undef FOO",
        "LD A,FOO"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // #define and #undef are not output
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,FOO");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: detects include recursion (A includes B, B includes A)",
          "[preprocessor][error]") {
    CerrRedirect redirect;
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Create file B that includes A
    std::string fileA = "test_preproc_cycle_A.asm";
    std::string fileB = "test_preproc_cycle_B.asm";
    {
        std::ofstream ofsB(fileB);
        ofsB << "#include \"" << fileA << "\"\n";
    }
    {
        std::ofstream ofsA(fileA);
        ofsA << "#include \"" << fileB << "\"\n";
    }
    // Track these files for cleanup
    track_temp_file(fileA);
    track_temp_file(fileB);

    // Try to open fileA, which should trigger recursive include
    REQUIRE(preproc.open(fileA));

    std::string out_line;
    Location out_loc;
    // Should eventually fail due to recursion or include loop
    while (preproc.next_line(out_line, out_loc)) {
        // Loop until error or EOF
    }
    std::string output = redirect.str();
    CHECK(reporter.has_error());
    CHECK(output.find("error: Recursive include") != std::string::npos);
}

TEST_CASE("Preprocessor: include directive sets correct Location",
          "[preprocessor][location]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    // Create included file
    std::vector<std::string> inc_lines = { "LD C,3", "LD D,4" };
    std::string inc_filename = write_temp_file(inc_lines);
    // Main file with include
    std::vector<std::string> lines = { "#include \"" + inc_filename + "\"", "LD A,1" };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First line from included file
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    CHECK(out_loc.filename() == inc_filename);
    CHECK(out_loc.line_num() == 1);

    // Second line from included file
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD D,4");
    CHECK(out_loc.filename() == inc_filename);
    CHECK(out_loc.line_num() == 2);

    // Back to main file
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    CHECK(out_loc.filename() == filename);
    CHECK(out_loc.line_num() == 2);

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: Location line numbers stay in sync after multi-line comment",
          "[preprocessor][location]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A,1",
        "/* comment",
        "   spanning",
        "   multiple lines */",
        "LD B,2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First line before comment
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    CHECK(out_loc.line_num() == 1);

    // Next line after multi-line comment
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK(out_loc.line_num() == 5);

    // Next line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    CHECK(out_loc.line_num() == 6);

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro A calls macro B, both with parameters",
          "[preprocessor][macro]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define B(x) x+1",
        "#define A(y) B(y)*2",
        "LD A,A(3)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // #define lines are not output
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,3+1*2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: correct physical line number with continuation and empty lines",
          "[preprocessor][location][continuation]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "",                        // 1: empty
        "LD A,1 \\",               // 2: continuation
        "  + 2 \\",                // 3: continuation
        "  + 3",                   // 4: end of logical line
        "",                        // 5: empty
        "LD B,4",                  // 6: new logical line
        "",                        // 7: empty
        "LD C,5 \\",               // 8: continuation
        "  + 6"                    // 9: end of logical line
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First logical line: lines 2-4, should report line 2
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1 + 2 + 3");
    CHECK(out_loc.line_num() == 2);

    // Second logical line: line 6
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,4");
    CHECK(out_loc.line_num() == 6);

    // Third logical line: lines 8-9, should report line 8
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,5 + 6");
    CHECK(out_loc.line_num() == 8);

    // No more lines
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: LINE directive updates Location line number and filename",
          "[preprocessor][line-directive][location]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A,1",
        "#line 42",
        "LD B,2",
        "LD B,3",
        "#line 100 \"other.asm\"",
        "LD C,4",
        "LD C,5"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First line, before any #line directive
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    CHECK(out_loc.line_num() == 1);
    CHECK(out_loc.filename() == filename);

    // After #line 42
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK(out_loc.line_num() == 42);
    CHECK(out_loc.filename() == filename);

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,3");
    CHECK(out_loc.line_num() == 43);
    CHECK(out_loc.filename() == filename);

    // After #line 100 "other.asm"
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,4");
    CHECK(out_loc.line_num() == 100);
    CHECK(out_loc.filename() == "other.asm");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,5");
    CHECK(out_loc.line_num() == 101);
    CHECK(out_loc.filename() == "other.asm");

    // No more lines
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: LINE directive followed by empty lines and multi-line comments counts physical lines",
          "[preprocessor][line-directive][location][empty][comment]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A,1",                  // 1
        "#line 50",                // 2: set logical line to 50
        "",                        // 3: empty line (physical line 3)
        "/*",                      // 4: start of multi-line comment (physical line 4)
        "   still comment",        // 5: inside comment (physical line 5)
        "   end comment */",       // 6: end of comment (physical line 6)
        "",                        // 7: another empty line (physical line 7)
        "LD B,2",                  // 8: should be logical line 56 (50 + (8-3))
        "LD C,3"                   // 9: should be logical line 57
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First line, before any #line directive
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,1");
    CHECK(out_loc.line_num() == 1);
    CHECK(out_loc.filename() == filename);

    // After #line 50, next logical line is at physical line 8
    // Logical line number should be: 50 + (8 - 3) = 55
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,2");
    CHECK(out_loc.line_num() == 55);
    CHECK(out_loc.filename() == filename);

    // Next logical line: physical line 9, so 50 + (9 - 3) = 56
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,3");
    CHECK(out_loc.line_num() == 56);
    CHECK(out_loc.filename() == filename);

    // No more lines
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: colon in ternary expression is not split",
          "[preprocessor][colon][ternary]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "LD A, cond ? 1 : 2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    REQUIRE(preproc.next_line(out_line, out_loc));
    // The colon in the ternary should not cause a split; the line should be unchanged
    CHECK(out_line == "LD A, cond ? 1 : 2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro with line continuations expands to multiple lines",
          "[preprocessor][macro][continuation]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define pushall \\",
        "    push bc \\ \\",
        "    push de \\ \\",
        "    push hl",
        "pushall"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // The macro should expand to three lines: "push bc", "push de", "push hl"
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push bc");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push de");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push hl");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro token pasting with ## operator",
          "[preprocessor][macro][tokenpaste]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "#define cat(a, b) a ## b",
        "cat(aa,bb)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // The macro should expand to: aabb
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "aabb");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// New test: ensure all input formats accepted by scan_integer are converted to decimal
TEST_CASE("Preprocessor: scan_integer formats in macros are converted to decimal",
          "[preprocessor][scan_integer]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Define macros using the various integer input formats supported by scan_integer.
    // Then emit lines using those macros; Preprocessor should expand macros and the numbers
    // should already be converted to their decimal equivalent by tokenize_macro_body.
    std::vector<std::string> lines = {
        "#define D_DEC 42",            // decimal
        "#define D_0x 0x2A",          // 0x hex
        "#define D_DOLLAR $2A",       // $ hex
        "#define D_HSUFFIX 2Ah",      // hex with h suffix
        "#define D_BIN1 %101010",     // binary with % prefix
        "#define D_BIN2 @101010",     // binary with @ prefix
        "#define D_0b 0b101010",      // binary with 0b prefix
        "#define D_BSUFFIX 101010b",  // binary with trailing b
        "#define D_GRAPH1 %\"#-#\"",  // graphical bitmask: '#-#' => binary 101 => 5
        "#define D_GRAPH2 @\"#-#\"",  // graphical bitmask: '#-#' => binary 101 => 5
        "#define D_CHAR 'A'",         // quoted character => ASCII 65
        // Use the macros in instructions so preprocessor returns expanded decimal numbers
        "LD A,D_DEC",
        "LD B,D_0x",
        "LD C,D_DOLLAR",
        "LD D,D_HSUFFIX",
        "LD E,D_BIN1",
        "LD E,D_BIN2",
        "LD H,D_0b",
        "LD L,D_BSUFFIX",
        "LD M,D_GRAPH1",
        "LD M,D_GRAPH2",
        "LD X,D_CHAR"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expected outputs after macro expansion: decimals only
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD C,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD D,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD E,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD E,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD H,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD L,42");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD M,5");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD M,5");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD X,65");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// New test: ensure all input formats accepted by scan_float are recognized and output contains '.' or 'e'
TEST_CASE("Preprocessor: scan_float formats are recognized and output contains dot or e",
          "[preprocessor][scan_float]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Define macros using representative float formats accepted by scan_float.
    std::vector<std::string> lines = {
        "#define F1 1.0",       // standard decimal with fraction
        "#define F2 1.",        // trailing dot
        "#define F3 .5",        // leading dot
        "#define F4 1e3",       // exponent without dot
        "#define F5 1E+3",      // exponent with sign and uppercase E
        "#define F6 1.0e-2",    // fraction with exponent
        "#define F7 .0",        // zero with leading dot
        "#define F8 0.0",       // explicit zero with fraction
        // Use the macros to force expansion into output lines
        "LD A,F1",
        "LD B,F2",
        "LD C,F3",
        "LD D,F4",
        "LD E,F5",
        "LD H,F6",
        "LD L,F7",
        "LD M,F8"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    auto check_has_dot_or_e = [&](const std::string & s) {
        CHECK(((s.find('.') != std::string::npos) ||
               (s.find('e') != std::string::npos) ||
               (s.find('E') != std::string::npos)));
    };

    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F1
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F2
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F3
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F4
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F5
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F6
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F7
    REQUIRE(preproc.next_line(out_line, out_loc));
    check_has_dot_or_e(out_line); // F8

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// New DEFL tests: verify text-substitution semantics and accumulation of previous value

TEST_CASE("Preprocessor: DEFL creates text macro using previous (undefined -> accumulates)",
          "[preprocessor][defl]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Start with var undefined. DEFL should substitute previous (empty) -> becomes "+1"
    // Second DEFL concatenates previous "+1" -> "+1+1"
    std::vector<std::string> lines = {
        "#defl var = var+1",
        "LD A,var",
        "#defl var = var+1",
        "LD B,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,+1");       // first DEFL produced "+1"
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD B,+1+1");     // second DEFL produced "+1+1"
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: DEFL can extend an existing DEFINE value",
          "[preprocessor][defl]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Start with var defined as "2". DEFL should paste previous "2" producing "2+1".
    std::vector<std::string> lines = {
        "#define var 2",
        "#defl var = var+1",
        "LD A,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First emitted line is the result of expansion
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,2+1");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}
