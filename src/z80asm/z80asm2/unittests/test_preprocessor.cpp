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
#include <cstdio>

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

TEST_CASE("Preprocessor: REPT repeats body N times",
          "[preprocessor][directive][rept]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Repeat the two instruction lines 3 times => 6 output lines
    std::vector<std::string> lines = {
        "REPT 3",
        "ld a,1",
        "ld b,2",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect the block repeated 3 times in order
    for (int rep = 0; rep < 3; ++rep) {
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "ld a,1");
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "ld b,2");
    }

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPT with non-constant count reports error",
          "[preprocessor][directive][rept][error]") {
    CerrRedirect redirect;
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // 'foo' is not a constant integer expression -> should produce an error
    std::vector<std::string> lines = {
        "REPT foo",
        "ld a,1",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;
    // Drive the preprocessor until EOF or error
    while (preproc.next_line(out_line, out_loc)) {
        // consume
    }

    // The preprocessor must have reported an error for the non-constant count
    CHECK(reporter.has_error());
    std::string errout = redirect.str();
    CHECK(((errout.find("REPT") != std::string::npos) || reporter.has_error()));
}

TEST_CASE("Preprocessor: REPT with zero count produces no output",
          "[preprocessor][directive][rept][zero]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "REPT 0",
        "ld a,1",
        "ld b,2",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Since count is zero the body should not be emitted; next output is the following normal line.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPT with negative count produces no output",
          "[preprocessor][directive][rept][negative]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "REPT -1",
        "ld a,1",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Since count is negative the body should not be emitted; next output is the following normal line.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPT with macro-defined count (DEFINE)",
          "[preprocessor][directive][rept][macro_count]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // FOO is defined as a numeric macro; REPT FOO should repeat the body FOO times.
    std::vector<std::string> lines = {
        "#define FOO 3",
        "REPT FOO",
        "ld a,1",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect the block repeated 3 times
    for (int rep = 0; rep < 3; ++rep) {
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "ld a,1");
    }

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPT with macro-defined count (name-first DEFINE)",
          "[preprocessor][directive][rept][macro_count]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Alternative name-first DEFINE syntax
    std::vector<std::string> lines = {
        "BAR DEFINE 2",
        "REPT BAR",
        "nop",
        "ENDR",
        "LD AFTER,1"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect two 'nop' lines produced by REPT BAR
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "nop");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "nop");

    // Then the following normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,1");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPT with arithmetic expression argument",
          "[preprocessor][directive][rept][expression]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Expression: -1 + 2*3  -> -1 + 6 = 5  (wait: typical arithmetic precedence yields -1 + (2*3) = 5)
    // Use a smaller body to make checks concise; ensure evaluation is performed by preprocessor.
    std::vector<std::string> lines = {
        "REPT -1+2*3",
        "ld a,1",
        "ld b,2",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect the two-instruction block repeated 5 times (if expression evaluated as -1 + (2*3) = 5)
    for (int rep = 0; rep < 5; ++rep) {
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "ld a,1");
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "ld b,2");
    }

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

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,2+1");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name DEFL value creates and extends macro",
          "[preprocessor][defl][name-directive]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Case 1: name is undefined, DEFL should substitute previous (empty) -> "+1"
    // Case 2: name is defined, DEFL should paste previous "+1" -> "+1+1"
    std::vector<std::string> lines = {
        "var DEFL var+1",
        "LD A,var",
        "var DEFL var+1",
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

TEST_CASE("Preprocessor: name DEFL value extends an existing DEFINE value",
          "[preprocessor][defl][name-directive]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Start with var defined as "2". DEFL should paste previous "2" producing "2+1".
    std::vector<std::string> lines = {
        "#define var 2",
        "var DEFL var+1",
        "LD A,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,2+1");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name DEFINE value creates macro",
          "[preprocessor][define][name-directive]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Use alternative syntax: name DEFINE value
    std::vector<std::string> lines = {
        "FOO DEFINE 42",
        "LD A,FOO"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Macro FOO should expand to 42
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD A,42");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// ------------------------- New MACRO tests -------------------------

TEST_CASE("Preprocessor: MACRO (multi-line) expands to multiple output lines",
          "[preprocessor][macro][multiline]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO pushall",
        "    push bc",
        "    push de",
        "    push hl",
        "ENDM",
        "pushall"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect the three push instructions produced by the macro expansion
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push bc");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push de");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push hl");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: empty multi-line object-like MACRO expands to nothing",
          "[preprocessor][macro][multiline][empty]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO empty",
        "ENDM",
        "LD BEFORE,1",
        "empty",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // The empty macro invocation should produce no lines; we should see the surrounding lines only.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: empty multi-line function-like MACRO expands to nothing",
          "[preprocessor][macro][multiline][empty][function]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO emptyfn(x)",
        "ENDM",
        "LD BEFORE,1",
        "emptyfn(1)",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // The empty function-like macro invocation should produce no lines; we should see the surrounding lines only.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: MACRO with parameters expands each body line using args",
          "[preprocessor][macro][params]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO two_loads(x,y)",
        "    ld a,x",
        "    ld b,y",
        "ENDM",
        "two_loads(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name-first MACRO with parameters expands each body line using args",
          "[preprocessor][macro][params][name-directive]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    // Alternative syntax: "name MACRO arg1,arg2,..."
    std::vector<std::string> lines = {
        "two_loads MACRO x,y",
        "    ld a,x",
        "    ld b,y",
        "ENDM",
        "two_loads(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name-first MACRO (object-like) expands to multiple output lines",
          "[preprocessor][macro][multiline][name-directive]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Alternative syntax: "name MACRO" (object-like multi-line macro)
    std::vector<std::string> lines = {
        "two_lines MACRO",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "two_lines"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: MACRO EXITM aborts expansion (no lines emitted when EXITM is first)",
          "[preprocessor][macro][exitm]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO abortme",
        "    EXITM",
        "    ld a,1",
        "ENDM",
        "abortme",
        "ld a,after"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // abortme should produce no lines because EXITM appears before any output
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,after");
    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: MACRO LOCAL makes identifiers unique per expansion",
          "[preprocessor][macro][local]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);
    std::vector<std::string> lines = {
        "MACRO inc(n)",
        "    LOCAL tmp",
        "    ld tmp,n",
        "    ld a,tmp",
        "ENDM",
        "inc(1)",
        "inc(2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    // tmp should have been renamed to a unique identifier; check it contains "tmp_" and the argument
    size_t p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    size_t p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix1 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));

    CHECK(out_line == std::string("ld tmp_") + tmp_suffix1 + ",1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == std::string("ld a,tmp_") + tmp_suffix1);

    // Second expansion should use a different tmp_<M>
    REQUIRE(preproc.next_line(out_line, out_loc));

    p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix2 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));

    CHECK(out_line == std::string("ld tmp_") + tmp_suffix2 + ",2");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == std::string("ld a,tmp_") + tmp_suffix2);


    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: MACRO LOCAL on multiple lines renames all locals consistently",
          "[preprocessor][macro][local][multiple]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "MACRO multi_local(n)",
        "    LOCAL tmp",
        "    ld tmp,n",
        "    LOCAL tmp2, tmp3",
        "    ld tmp2,tmp3",
        "ENDM",
        "multi_local(1)",
        "multi_local(2)"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First expansion (n==1)
    REQUIRE(preproc.next_line(out_line, out_loc));
    // Expect "ld tmp_<id>,1"
    size_t p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    size_t p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix1 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));
    CHECK(out_line == std::string("ld tmp_") + tmp_suffix1 + ",1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    // Expect "ld tmp2_<id>,tmp3_<id>" with same suffix as tmp_
    size_t p_tmp2 = out_line.find("tmp2_");
    size_t p_tmp3 = out_line.find("tmp3_");
    REQUIRE(p_tmp2 != std::string::npos);
    REQUIRE(p_tmp3 != std::string::npos);
    size_t p_tmp2_end = out_line.find_first_of(", \t", p_tmp2);
    if (p_tmp2_end == std::string::npos) {
        p_tmp2_end = out_line.size();
    }
    size_t p_tmp3_end = out_line.find_first_of(", \t", p_tmp3);
    if (p_tmp3_end == std::string::npos) {
        p_tmp3_end = out_line.size();
    }
    std::string tmp2_suffix1 = out_line.substr(p_tmp2 + 5,
                               p_tmp2_end - (p_tmp2 + 5));
    std::string tmp3_suffix1 = out_line.substr(p_tmp3 + 5,
                               p_tmp3_end - (p_tmp3 + 5));
    // tmp2/tmp3 should share the same expansion suffix (within the same macro expansion)
    CHECK(tmp2_suffix1 == tmp3_suffix1);
    // Suffixes for tmp and tmp2/tmp3 should be the same base id (they may be different names but the unique id must match per expansion)
    CHECK(tmp_suffix1 == tmp2_suffix1);

    CHECK(out_line == std::string("ld tmp2_") + tmp_suffix1 + ",tmp3_" +
          tmp_suffix1);

    // Second expansion (n==2)
    REQUIRE(preproc.next_line(out_line, out_loc));
    // Expect "ld tmp_<id2>,2"
    size_t p_tmp_b = out_line.find("tmp_");
    REQUIRE(p_tmp_b != std::string::npos);
    size_t p_tmp_b_end = out_line.find_first_of(", \t", p_tmp_b);
    if (p_tmp_b_end == std::string::npos) {
        p_tmp_b_end = out_line.size();
    }
    std::string tmp_suffix2 = out_line.substr(p_tmp_b + 4,
                              p_tmp_b_end - (p_tmp_b + 4));
    CHECK(out_line == std::string("ld tmp_") + tmp_suffix2 + ",2");

    // New expansion must use a different unique id than the first
    CHECK(tmp_suffix2 != tmp_suffix1);

    REQUIRE(preproc.next_line(out_line, out_loc));
    // Expect "ld tmp2_<id2>,tmp3_<id2>"
    size_t p_tmp2_b = out_line.find("tmp2_");
    size_t p_tmp3_b = out_line.find("tmp3_");
    REQUIRE(p_tmp2_b != std::string::npos);
    REQUIRE(p_tmp3_b != std::string::npos);
    size_t p_tmp2_b_end = out_line.find_first_of(", \t", p_tmp2_b);
    if (p_tmp2_b_end == std::string::npos) {
        p_tmp2_b_end = out_line.size();
    }
    size_t p_tmp3_b_end = out_line.find_first_of(", \t", p_tmp3_b);
    if (p_tmp3_b_end == std::string::npos) {
        p_tmp3_b_end = out_line.size();
    }
    std::string tmp2_suffix2 = out_line.substr(p_tmp2_b + 5,
                               p_tmp2_b_end - (p_tmp2_b + 5));
    std::string tmp3_suffix2 = out_line.substr(p_tmp3_b + 5,
                               p_tmp3_b_end - (p_tmp3_b + 5));
    CHECK(tmp2_suffix2 == tmp3_suffix2);
    CHECK(tmp2_suffix2 == tmp_suffix2);

    CHECK(out_line == std::string("ld tmp2_") + tmp_suffix2 + ",tmp3_" +
          tmp_suffix2);

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: label before multi-line object-like macro expansion",
          "[preprocessor][macro][label][object]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "MACRO mobj",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "label: mobj",
        "nop"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Label should appear before first macro body line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "label: ld a,1");

    // Second macro line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");

    // Then the following normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "nop");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: label before multi-line function-like macro expansion",
          "[preprocessor][macro][label][function]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "MACRO mfn(x)",
        "    ld a,x",
        "    ld b,x",
        "ENDM",
        "label: mfn(5)",
        "nop"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Label should be preserved and placed before the first expanded macro line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "label: ld a,5");

    // Second macro line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,5");

    // Then the following normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "nop");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: Location line numbers for object-like multi-line macro expansion",
          "[preprocessor][macro][location][object]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "MACRO mobj",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "LD BEFORE,1", // physical line 5
        "mobj",         // physical line 6 -> invocation
        "LD AFTER,2"   // physical line 7
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First non-macro logical line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");
    CHECK(out_loc.line_num() == 5);

    // First macro expansion line should report the invocation's physical line number (6)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");
    CHECK(out_loc.line_num() == 6);

    // Second macro expansion line should have the same reported line number (6)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    CHECK(out_loc.line_num() == 6);

    // Back to following normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");
    CHECK(out_loc.line_num() == 7);

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: Location line numbers for function-like multi-line macro expansion",
          "[preprocessor][macro][location][function]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "MACRO mfn(x)",
        "    ld a,x",
        "    ld b,x",
        "ENDM",
        "LD BEFORE,1", // physical line 5
        "mfn(5)",       // physical line 6 -> invocation
        "LD AFTER,2"   // physical line 7
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");
    CHECK(out_loc.line_num() == 5);

    // First macro expansion line should report the invocation's physical line number (6)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,5");
    CHECK(out_loc.line_num() == 6);

    // Second macro expansion line should have the same reported line number (6)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,5");
    CHECK(out_loc.line_num() == 6);

    // Back to following normal line
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");
    CHECK(out_loc.line_num() == 7);

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with object-like then function-like macros expands sequentially",
          "[preprocessor][macro][split]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // M1 is an object-like single-line macro, FN is a function-like single-line macro.
    // The source line contains "M1 : FN(2,3)" - after expansion and splitting at ':'
    // we should get the expansion of M1 first, then the expansion of FN.
    std::vector<std::string> lines = {
        "#define M1 ld a,1",
        "#define FN(x,y) ld b,x",
        "M1 : FN(2,3)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First segment: expansion of M1
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");

    // Second segment: expansion of FN(2,3)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with function-like then object-like macros expands sequentially",
          "[preprocessor][macro][split]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // FOO(5) is a function-like single-line macro, M2 is an object-like single-line macro.
    // The source line "FOO(5) : M2" should expand FOO first, then M2.
    std::vector<std::string> lines = {
        "#define FOO(x) ld a,x",
        "#define M2 ld b,2",
        "FOO(5) : M2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // First segment: expansion of FOO(5)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,5");

    // Second segment: expansion of M2
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with multi-line object-like then multi-line function-like macros expands sequentially",
          "[preprocessor][macro][split][multiline]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // M1 is a multi-line object-like macro; FN is a multi-line function-like macro.
    // The source line contains "M1 : FN(2,3)" - after expansion we expect M1's body lines
    // followed by FN's body lines (with arguments substituted).
    std::vector<std::string> lines = {
        "MACRO M1",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "MACRO FN(x,y)",
        "    ld b,x",
        "    ld c,y",
        "ENDM",
        "M1 : FN(2,3)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // M1 body lines
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,1");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");

    // FN body lines (with args)
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld c,3");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with multi-line function-like then multi-line object-like macros expands sequentially",
          "[preprocessor][macro][split][multiline]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // FOO is a multi-line function-like macro; M2 is a multi-line object-like macro.
    // The source line "FOO(5) : M2" should expand FOO first, then M2.
    std::vector<std::string> lines = {
        "MACRO FOO(x)",
        "    ld a,x",
        "    ld a2,x",
        "ENDM",
        "MACRO M2",
        "    ld b,2",
        "    ld b2,22",
        "ENDM",
        "FOO(5) : M2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // FOO body lines
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a,5");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld a2,5");

    // M2 body lines
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b,2");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "ld b2,22");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with multi-line empty function-like then empty object-like macros expands to nothing",
          "[preprocessor][macro][split][multiline][empty]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Both macros contain two blank body lines -> effectively empty expansions.
    // Surround with lines to ensure the invocation produces no intermediate output.
    std::vector<std::string> lines = {
        "MACRO FOO(x)",
        "    ",
        "    ",
        "ENDM",
        "MACRO MAC",
        "    ",
        "    ",
        "ENDM",
        "LD BEFORE,1",
        "FOO(1) : MAC",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Only the surrounding lines should be present; the invocation produces no intermediate output.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: split line with multi-line empty object-like then empty function-like macros expands to nothing",
          "[preprocessor][macro][split][multiline][empty]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // Same as above but object-like first, function-like second.
    std::vector<std::string> lines = {
        "#define EMPTY_MACRO", // single-line empty macro
        "MACRO MAC",
        "    EMPTY_MACRO : EMPTY_MACRO",
        "    EMPTY_MACRO : EMPTY_MACRO",
        "ENDM",
        "MACRO FOO(x)",
        "    EMPTY_MACRO : EMPTY_MACRO",
        "    EMPTY_MACRO : EMPTY_MACRO",
        "ENDM",
        "LD BEFORE,1",
        "MAC : FOO(1)",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Invocation should produce nothing; only surrounding lines remain.
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// REPTC tests: repeat a block for each character of a string, identifier or number

TEST_CASE("Preprocessor: REPTC with string literal iterates characters",
          "[preprocessor][directive][reptc][string]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "REPTC var, \"hi\"",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'h' == 104, 'i' == 105
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 104");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 105");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTC with identifier/string macro iterates expanded characters",
          "[preprocessor][directive][reptc][identifier]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "#defl text = \"abc\"",
        "REPTC var, text",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'a' == 97, 'b' == 98, 'c' == 99
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 97");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 98");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 99");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTC with numeric macro iterates over digits' characters",
          "[preprocessor][directive][reptc][number]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // version -> "23" -> iterate '2' and '3' -> ASCII 50 and 51
    std::vector<std::string> lines = {
        "#define version 23",
        "REPTC var, version",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 50"); // '2'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 51"); // '3'

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// Additional REPTC tests: verify escape sequences are scanned and iterated

TEST_CASE("Preprocessor: REPTC iterates escape sequences (CR and LF)",
          "[preprocessor][directive][reptc][escape]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // String contains X, CR, LF, Y -> expect codes 88,13,10,89
    std::vector<std::string> lines = {
        "REPTC var, \"X\\r\\nY\"",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 88"); // 'X'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 13"); // '\r'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 10"); // '\n'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 89"); // 'Y'

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTC iterates escaped backslash correctly",
          "[preprocessor][directive][reptc][escape][backslash]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // String "a\\b" -> chars 'a' (97), '\' (92), 'b' (98)
    std::vector<std::string> lines = {
        "REPTC var, \"a\\\\b\"",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 97"); // 'a'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 92"); // '\\'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 98"); // 'b'

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTC with bare identifier iterates identifier characters",
          "[preprocessor][directive][reptc][identifier][bare]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // No macro named 'hello' is defined here - REPTC should iterate the characters of the identifier itself.
    std::vector<std::string> lines = {
        "REPTC var, hello",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'h' 'e' 'l' 'l' 'o' -> 104,101,108,108,111
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 104");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 101");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 108");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 108");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 111");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// Name-first REPTC tests: "var REPTC argument" alternative syntax

TEST_CASE("Preprocessor: name-first REPTC with bare identifier iterates identifier characters",
          "[preprocessor][directive][reptc][name-first][identifier]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // No macro named 'hello' is defined here - var REPTC hello should iterate 'hello'.
    std::vector<std::string> lines = {
        "var REPTC hello",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'h' 'e' 'l' 'l' 'o' -> 104,101,108,108,111
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 104");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 101");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 108");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 108");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 111");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name-first REPTC with string literal iterates characters",
          "[preprocessor][directive][reptc][name-first][string]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "var REPTC \"hi\"",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'h' == 104, 'i' == 105
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 104");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 105");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name-first REPTC with identifier macro iterates expanded characters",
          "[preprocessor][directive][reptc][name-first][identifier][macro]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "#defl text = \"abc\"",
        "var REPTC text",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'a' == 97, 'b' == 98, 'c' == 99
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 97");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 98");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 99");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: name-first REPTC with numeric macro iterates over digits' characters",
          "[preprocessor][directive][reptc][name-first][number]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // version -> "23" -> iterate '2' and '3' -> ASCII 50 and 51
    std::vector<std::string> lines = {
        "#define version 23",
        "var REPTC version",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 50"); // '2'
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 51"); // '3'

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

// REPTC: empty / missing argument / empty-macro cases for both syntaxes

TEST_CASE("Preprocessor: REPTC with empty string produces no output (both syntaxes)",
          "[preprocessor][directive][reptc][empty]") {
    // Syntax: REPTC var, ""
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "REPTC var, \"\"",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        // No iterations -> no output
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
    }

    // Name-first syntax: var REPTC ""
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "var REPTC \"\"",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        // No iterations -> no output
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
    }
}

TEST_CASE("Preprocessor: REPTC with macro defined empty produces no output (both syntaxes)",
          "[preprocessor][directive][reptc][empty-macro]") {
    // Define an empty macro then use it as REPTC argument
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "#define EMPTY",
            "REPTC var, EMPTY",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        // EMPTY expands to empty string -> no iterations -> no output
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
    }

    // Name-first syntax with empty macro
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "#define EMPTY",
            "var REPTC EMPTY",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
    }
}

TEST_CASE("Preprocessor: REPTC with missing argument produces no output and reports error (both syntaxes)",
          "[preprocessor][directive][reptc][missing]") {
    // Syntax: REPTC var,   (trailing comma, missing argument)
    {
        CerrRedirect redirect;
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "REPTC var,",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        bool any_output = false;
        while (preproc.next_line(out_line, out_loc)) {
            (void)out_line;
            any_output = true;
        }
        // Missing argument is a syntax error; ensure no output was produced
        CHECK_FALSE(any_output);
        CHECK(reporter.has_error());
        std::string errout = redirect.str();
        CHECK(((errout.find("REPTC") != std::string::npos) || reporter.has_error()));
    }

    // Name-first: "var REPTC" with no following argument
    {
        CerrRedirect redirect;
        ErrorReporter reporter;
        Preprocessor preproc(reporter);
        std::vector<std::string> lines = {
            "var REPTC",
            "defb var",
            "ENDR"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;
        bool any_output = false;
        while (preproc.next_line(out_line, out_loc)) {
            (void)out_line;
            any_output = true;
        }
        // Missing argument should be treated as syntax error; ensure no output produced
        CHECK_FALSE(any_output);
        CHECK(reporter.has_error());
        std::string errout = redirect.str();
        CHECK(((errout.find("REPTC") != std::string::npos) || reporter.has_error()));
    }
}

TEST_CASE("Preprocessor: REPTC with macro-defined string of spaces expands correctly",
          "[preprocessor][directive][reptc][spaces]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // FOO is defined as a quoted string containing three spaces.
    // REPTC should iterate those three space characters and emit their codes (32).
    std::vector<std::string> lines = {
        "#define FOO \"   \"",
        "REPTC var, FOO",
        "defb var",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // Expect three bytes with value 32
    for (int i = 0; i < 3; ++i) {
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "defb 32");
    }

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTI repeats body for each expression (normal syntax)",
          "[preprocessor][directive][repti][basic]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "REPTI reg, bc, de, hl, af",
        "push reg",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push bc");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push de");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push hl");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push af");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTI name-first syntax repeats body for each expression",
          "[preprocessor][directive][repti][name-first]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "reg REPTI bc, de, hl, af",
        "push reg",
        "ENDR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push bc");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push de");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push hl");
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "push af");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: REPTI with empty list produces no output (both syntaxes)",
          "[preprocessor][directive][repti][empty]") {
    // Normal syntax: trailing comma -> empty list
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);

        std::vector<std::string> lines = {
            "REPTI reg,",
            "push reg",
            "ENDR",
            "LD AFTER,1"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;

        // No push lines should be emitted; next output is the following normal line.
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "LD AFTER,1");
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
        CHECK_FALSE(reporter.has_error());
    }

    // Name-first syntax: missing list after REPTI -> empty list
    {
        ErrorReporter reporter;
        Preprocessor preproc(reporter);

        std::vector<std::string> lines = {
            "reg REPTI",
            "push reg",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(preproc.open(filename));

        std::string out_line;
        Location out_loc;

        // No push lines should be emitted; next output is the following normal line.
        REQUIRE(preproc.next_line(out_line, out_loc));
        CHECK(out_line == "LD AFTER,2");
        CHECK_FALSE(preproc.next_line(out_line, out_loc));
        CHECK_FALSE(reporter.has_error());
    }
}

// Preprocessor: output string literals become lists of integer character codes

TEST_CASE("Preprocessor: macro-defined string expands to list of char codes",
          "[preprocessor][string][macro][defb]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "#define S \"abc\"",
        "defb S"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'a' 'b' 'c' -> 97,98,99
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 97,98,99");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: direct string literal expands to list of char codes",
          "[preprocessor][string][literal][defb]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    std::vector<std::string> lines = {
        "defb \"hi\""
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    // 'h' 'i' -> 104,105
    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 104,105");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}

TEST_CASE("Preprocessor: macro-defined string with escapes expands to char codes",
          "[preprocessor][string][escape][defb]") {
    ErrorReporter reporter;
    Preprocessor preproc(reporter);

    // "X\r\nY" -> 'X' (88), '\r' (13), '\n' (10), 'Y' (89)
    std::vector<std::string> lines = {
        "#define STR \"X\\r\\nY\"",
        "defb STR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(preproc.open(filename));

    std::string out_line;
    Location out_loc;

    REQUIRE(preproc.next_line(out_line, out_loc));
    CHECK(out_line == "defb 88,13,10,89");

    CHECK_FALSE(preproc.next_line(out_line, out_loc));
}
