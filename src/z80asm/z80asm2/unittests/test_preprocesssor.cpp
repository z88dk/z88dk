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

// Helper to capture std::cerr output
class CerrRedirect {
    std::streambuf* old;
    std::ostringstream ss;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

// Helper: Write lines to a temporary file
static std::string write_temp_file(const std::vector<std::string>& lines) {
    static int counter = 0;
    std::string filename = "test_preproc_tmp_" + std::to_string(counter++) + ".asm";
    std::ofstream ofs(filename);
    for (const auto& line : lines) ofs << line << "\n";
    ofs.close();
    return filename;
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

TEST_CASE("Preprocessor: open() returns true and next_line() returns false for empty file", "[preprocessor][emptyfile]") {
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

TEST_CASE("Preprocessor: removes C-style single-line comments", "[preprocessor]") {
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

TEST_CASE("Preprocessor: removes C-style multi-line comments", "[preprocessor]") {
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

TEST_CASE("Preprocessor: removes multi-line C-style comments spanning lines", "[preprocessor]") {
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

TEST_CASE("Preprocessor: removes C-style comment in the middle of a line", "[preprocessor]") {
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

TEST_CASE("Preprocessor: detects include recursion (A includes B, B includes A)", "[preprocessor][error]") {
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
    // Create file A that includes B
    {
        std::ofstream ofsA(fileA);
        ofsA << "#include \"" << fileB << "\"\n";
    }

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

TEST_CASE("Preprocessor: include directive sets correct Location", "[preprocessor][location]") {
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

TEST_CASE("Preprocessor: Location line numbers stay in sync after multi-line comment", "[preprocessor][location]") {
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

TEST_CASE("Preprocessor: macro A calls macro B, both with parameters", "[preprocessor][macro]") {
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

TEST_CASE("Preprocessor: correct physical line number with continuation and empty lines", "[preprocessor][location][continuation]") {
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

TEST_CASE("Preprocessor: LINE directive updates Location line number and filename", "[preprocessor][line-directive][location]") {
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
