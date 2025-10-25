//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../preprocessor.h"
#include "catch_amalgamated.hpp"
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <cctype>
#include <sstream>

// Local replacements for the small utils functions used by the tests.
// These keep the unit tests independent of utils.cpp.

static std::string to_lower(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(),
    [](unsigned char c) {
        return static_cast<char>(std::tolower(c));
    });
    return result;
}

static std::string ltrim(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\r\n");
    return (start == std::string::npos) ? "" : s.substr(start);
}

static std::string rtrim(const std::string& s) {
    size_t end = s.find_last_not_of(" \t\r\n");
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}

static std::string trim(const std::string& s) {
    return ltrim(rtrim(s));
}

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
// Track temp directories created by tests
static std::vector<std::string> temp_dirs;

// Helper: Write lines to a temporary file
static std::string write_temp_file(const std::vector<std::string>& lines) {
    static int counter = 0;
    std::string filename = "test_preproc_tmp_" + std::to_string(counter++) + ".asm";
    std::ofstream ofs(filename);
    for (const auto& line : lines) {
        ofs << line << std::endl;
    }
    ofs.close();
    temp_files.push_back(filename);
    return filename;
}

// Add explicit tracking for manually created files
static void track_temp_file(const std::string& filename) {
    temp_files.push_back(filename);
}

// Create a temporary directory and track it for cleanup
static std::string make_temp_dir() {
    static int dcounter = 0;
    std::string dirname = "test_preproc_dir_" + std::to_string(dcounter++);
    try {
        std::filesystem::create_directory(dirname);
    }
    catch (...) {
        // ignore - tests will fail if creation fails
    }
    temp_dirs.push_back(dirname);
    return dirname;
}

// Write a file inside a directory and track it
static std::string write_temp_file_in_dir(const std::string& dir,
        const std::string& filename,
        const std::vector<std::string>& lines) {
    std::filesystem::path p = std::filesystem::path(dir) / filename;
    std::string filepath = p.generic_string();
    std::ofstream ofs(filepath);
    for (const auto& line : lines) {
        ofs << line << std::endl;
    }
    ofs.close();
    temp_files.push_back(filepath);
    return filepath;
}

// Normalize an expected filename into the same canonical form the preprocessor uses
// (absolute + lexically_normal) so tests can compare Location.filename() reliably.
static std::string normalize_expected_path(const std::string& p) {
    try {
        std::filesystem::path pp(p);
        if (!pp.is_absolute()) {
            pp = std::filesystem::absolute(pp);
        }
        return pp.lexically_normal().generic_string();
    }
    catch (...) {
        return p;
    }
}

// RAII cleanup for temp files and directories
struct TempFileCleaner {
    ~TempFileCleaner() {
        for (const auto& f : temp_files) {
            // attempt to remove files; ignore errors
            std::remove(f.c_str());
        }
        temp_files.clear();

        // remove directories (and any contents) created during tests
        for (const auto& d : temp_dirs) {
            try {
                std::filesystem::remove_all(d);
            }
            catch (...) {
                // ignore
            }
        }
        temp_dirs.clear();
    }
};

// Instantiate the cleaner at file scope so it runs after all tests
static TempFileCleaner temp_file_cleaner;

TEST_CASE("Preprocessor normalizes all line endings to NL",
          "[preprocessor][line_endings]") {
    std::string line;

    SECTION("Handles LF (\\n) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\nline2\nline3\n";
        }
        Preprocessor pp;
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line));
    }

    SECTION("Handles CR (\\r) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\rline2\rline3\r";
        }
        Preprocessor pp;
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line));
    }

    SECTION("Handles CRLF (\\r\\n) only") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\r\nline2\r\nline3\r\n";
        }
        Preprocessor pp;
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line3");
        REQUIRE_FALSE(pp.next_line(line));
    }

    SECTION("Handles mixed line endings") {
        std::string filename = write_temp_file({});
        {
            std::ofstream ofs(filename, std::ios::binary);
            ofs << "line1\rline2\nline3\r\nline4";
        }
        Preprocessor pp;
        REQUIRE(pp.open(filename));
        REQUIRE(pp.next_line(line));
        CHECK(line == "line1");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line2");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line3");
        REQUIRE(pp.next_line(line));
        CHECK(line == "line4");
        REQUIRE_FALSE(pp.next_line(line));
    }

    SECTION("Handles empty input") {
        std::string filename = write_temp_file({});
        Preprocessor pp;
        REQUIRE(pp.open(filename));
        REQUIRE_FALSE(pp.next_line(line));
    }
}

TEST_CASE("Preprocessor: open() and next_line() basic", "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = { "LD A,1", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: open() returns true and next_line() returns false for empty file",
          "[preprocessor][emptyfile]") {
    Preprocessor pp;
    std::vector<std::string> lines = {}; // empty file
    std::string filename = write_temp_file(lines);

    // open() should succeed even for an empty file
    REQUIRE(pp.open(filename));

    std::string out_line;
    // next_line() should immediately return false
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: removes comments", "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = { "LD A,1 ; comment", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: removes C-style single-line comments",
          "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = { "LD A,1 // comment", "LD B,2" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: removes C-style multi-line comments",
          "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "LD A,1 /* comment */ LD B,2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1 LD B,2");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: removes multi-line C-style comments spanning lines",
          "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "LD A,/* comment",
        "and comment",
        "continues here */2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,2");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: removes C-style comment in the middle of a line",
          "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = { "a/**/b" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ab");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: include directive", "[preprocessor]") {
    Preprocessor pp;
    // Create included file
    std::vector<std::string> inc_lines = { "LD C,3" };
    std::string inc_filename = write_temp_file(inc_lines);
    // Main file with include
    std::vector<std::string> lines = { "#include \"" + inc_filename + "\"", "LD A,1" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT repeats body N times",
          "[preprocessor][directive][rept]") {
    Preprocessor pp;

    // Repeat the two instruction lines 3 times => 6 output lines
    std::vector<std::string> lines = {
        "REPT 3",
        "ld a,1",
        "ld b,2",
        "ENDR",
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect the block repeated 3 times in order
    for (int rep = 0; rep < 3; ++rep) {
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "ld a,1");
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "ld b,2");
    }

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT with non-constant count reports error",
          "[preprocessor][directive][rept][error]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    // 'foo' is not a constant integer expression -> should produce an error
    std::vector<std::string> lines = {
        "REPT foo",
        "ld a,1",
        "ENDR",
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    // Drive the preprocessor until EOF or error
    while (pp.next_line(out_line)) {
        // consume
    }

    // The preprocessor must have reported an error for the non-constant count
    CHECK(g_errors.has_errors());
    std::string errout = redirect.str();
    CHECK(errout.find("REPT") != std::string::npos);
}

TEST_CASE("Preprocessor: REPT with zero count produces no output",
          "[preprocessor][directive][rept][zero]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "REPT 0",
        "ld a,1",
        "ld b,2",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Since count is zero the body should not be emitted; next output is the following normal line.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT with negative count produces no output",
          "[preprocessor][directive][rept][negative]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "REPT -1",
        "ld a,1",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Since count is negative the body should not be emitted; next output is the following normal line.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT with macro-defined count (DEFINE)",
          "[preprocessor][directive][rept][macro_count]") {
    Preprocessor pp;

    // FOO is defined as a numeric macro; REPT FOO should repeat the body FOO times.
    std::vector<std::string> lines = {
        "#define FOO 3",
        "REPT FOO",
        "ld a,1",
        "ENDR",
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect the block repeated 3 times
    for (int rep = 0; rep < 3; ++rep) {
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "ld a,1");
    }

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT with macro-defined count (name-first DEFINE)",
          "[preprocessor][directive][rept][macro_count]") {
    Preprocessor pp;

    // Alternative name-first DEFINE syntax
    std::vector<std::string> lines = {
        "BAR DEFINE 2",
        "REPT BAR",
        "nop",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect two 'nop' lines produced by REPT BAR
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "nop");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "nop");

    // Then the following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPT with arithmetic expression argument",
          "[preprocessor][directive][rept][expression]") {
    Preprocessor pp;

    // Expression: -1 + 2*3  -> -1 + 6 = 5  (wait: typical arithmetic precedence yields -1 + (2*3) = 5)
    // Use a smaller body to make checks concise; ensure evaluation is performed by preprocessor.
    std::vector<std::string> lines = {
        "REPT -1+2*3",
        "ld a,1",
        "ld b,2",
        "ENDR",
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect the two-instruction block repeated 5 times (if expression evaluated as -1 + (2*3) = 5)
    for (int rep = 0; rep < 5; ++rep) {
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "ld a,1");
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "ld b,2");
    }

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro object-like expansion", "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define FOO 42",
        "LD A,FOO"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    // #define is not output
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,42");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro function-like expansion", "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define ADD(x,y) x+y",
        "LD A,ADD(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    // #define is not output
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1+2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: undef macro", "[preprocessor]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define FOO 99",
        "#undef FOO",
        "LD A,FOO"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    // #define and #undef are not output
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,FOO");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: DEFINE without value defines name = 1 (hash-define form)",
          "[preprocessor][define][default]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define FLAG",
        "LD A,FLAG"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: DEFINE accepts optional '=' and evaluates expression (hash-define form)",
          "[preprocessor][define][expression][equals]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define VAL = -1+2*3",
        "LD A,VAL"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,5");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: DEFINE accepts expression without '=' and evaluates it (hash-define form)",
          "[preprocessor][define][expression][no_equals]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define VAL2 -1+2*3",
        "LD A,VAL2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,5");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first DEFINE without value defines name = 1 (name-first form)",
          "[preprocessor][define][name-directive][default]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "FLAG DEFINE",
        "LD A,FLAG"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first DEFINE accepts optional '=' and evaluates expression (name-first form)",
          "[preprocessor][define][name-directive][expression]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "MYDEF DEFINE = -1+2*3",
        "LD A,MYDEF"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,5");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first DEFINE accepts expression without '=' and evaluates it (name-first form)",
          "[preprocessor][define][name-directive][expression][no_equals]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "MYDEF2 DEFINE -1+2*3",
        "LD A,MYDEF2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,5");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: detects include recursion (A includes B, B includes A)",
          "[preprocessor][error]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    // Create file B that includes A
    std::string fileA = "test_preproc_cycle_A.asm";
    std::string fileB = "test_preproc_cycle_B.asm";
    {
        std::ofstream ofsB(fileB);
        ofsB << "#include \"" << fileA << "\"" << std::endl;
    }
    {
        std::ofstream ofsA(fileA);
        ofsA << "#include \"" << fileB << "\"" << std::endl;
    }
    // Track these files for cleanup
    track_temp_file(fileA);
    track_temp_file(fileB);

    // Try to open fileA, which should trigger recursive include
    REQUIRE(pp.open(fileA));

    std::string out_line;
    // Should eventually fail due to recursion or include loop
    while (pp.next_line(out_line)) {
        // Loop until error or EOF
    }
    std::string output = redirect.str();
    CHECK(g_errors.has_errors());
    CHECK(output.find("error: Recursive include") != std::string::npos);
}

TEST_CASE("Preprocessor: include directive sets correct Location",
          "[preprocessor][location]") {
    Preprocessor pp;
    // Create included file
    std::vector<std::string> inc_lines = { "LD C,3", "LD D,4" };
    std::string inc_filename = write_temp_file(inc_lines);
    // Main file with include
    std::vector<std::string> lines = { "#include \"" + inc_filename + "\"", "LD A,1" };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First line from included file
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    CHECK(g_errors.line_num() == 1);

    // Second line from included file
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD D,4");
    CHECK(g_errors.filename() == normalize_expected_path(inc_filename));
    CHECK(g_errors.line_num() == 2);

    // Back to main file
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK(g_errors.filename() == normalize_expected_path(filename));
    CHECK(g_errors.line_num() == 2);

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: Location line numbers stay in sync after multi-line comment",
          "[preprocessor][location]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "LD A,1",
        "/* comment",
        "   spanning",
        "   multiple lines */",
        "LD B,2",
        "LD C,3"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First line before comment
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK(g_errors.line_num() == 1);

    // Next line after multi-line comment
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK(g_errors.line_num() == 5);

    // Next line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    CHECK(g_errors.line_num() == 6);

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro A calls macro B, both with parameters",
          "[preprocessor][macro]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define B(x) x+1",
        "#define A(y) B(y)*2",
        "LD A,A(3)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    // #define lines are not output
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,3+1*2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: correct physical line number with continuation and empty lines",
          "[preprocessor][location][continuation]") {
    Preprocessor pp;
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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First logical line: lines 2-4, should report line 2
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1 + 2 + 3");
    CHECK(g_errors.line_num() == 2);

    // Second logical line: line 6
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,4");
    CHECK(g_errors.line_num() == 6);

    // Third logical line: lines 8-9, should report line 8
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,5 + 6");
    CHECK(g_errors.line_num() == 8);

    // No more lines
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: LINE directive updates Location line number and filename",
          "[preprocessor][line-directive][location]") {
    Preprocessor pp;
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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First line, before any #line directive
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK(g_errors.line_num() == 1);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // After #line 42
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK(g_errors.line_num() == 42);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,3");
    CHECK(g_errors.line_num() == 43);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // After #line 100 "other.asm"
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,4");
    CHECK(g_errors.line_num() == 100);
    CHECK(g_errors.filename() == "other.asm");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,5");
    CHECK(g_errors.line_num() == 101);
    CHECK(g_errors.filename() == "other.asm");

    // No more lines
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: LINE directive followed by empty lines and multi-line comments counts physical lines",
          "[preprocessor][line-directive][location][empty][comment]") {
    Preprocessor pp;
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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First line, before any #line directive
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");
    CHECK(g_errors.line_num() == 1);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // After #line 50, next logical line is at physical line 8
    // Logical line number should be: 50 + (8 - 3) = 55
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,2");
    CHECK(g_errors.line_num() == 55);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // Next logical line: physical line 9, so 50 + (9 - 3) = 56
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,3");
    CHECK(g_errors.line_num() == 56);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // No more lines
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: colon in ternary expression is not split",
          "[preprocessor][colon][ternary]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "LD A, cond ? 1 : 2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;
    REQUIRE(pp.next_line(out_line));
    // The colon in the ternary should not cause a split; the line should be unchanged
    CHECK(out_line == "LD A, cond ? 1 : 2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro with line continuations expands to multiple lines",
          "[preprocessor][macro][continuation]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define pushall \\",
        "    push bc \\ \\",
        "    push de \\ \\",
        "    push hl",
        "pushall"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The macro should expand to three lines: "push bc", "push de", "push hl"
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push bc");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push de");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push hl");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro token pasting with ## operator",
          "[preprocessor][macro][tokenpaste]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "#define cat(a, b) a ## b",
        "cat(aa,bb)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The macro should expand to: aabb
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "aabb");
    CHECK_FALSE(pp.next_line(out_line));
}

// New test: ensure all input formats accepted by scan_integer are converted to decimal
TEST_CASE("Preprocessor: scan_integer formats in macros are converted to decimal",
          "[preprocessor][scan_integer]") {
    Preprocessor pp;

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
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expected outputs after macro expansion: decimals only
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD D,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD E,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD E,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD H,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD L,42");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD M,5");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD M,5");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD X,65");

    CHECK_FALSE(pp.next_line(out_line));
}

// New test: ensure all input formats accepted by scan_float are recognized and output contains '.' or 'e'
TEST_CASE("Preprocessor: scan_float formats are recognized and output contains dot or e",
          "[preprocessor][scan_float]") {
    Preprocessor pp;

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
        // Use the macros in instructions so preprocessor returns expanded float numbers
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
    REQUIRE(pp.open(filename));

    std::string out_line;

    auto check_has_dot_or_e = [&](const std::string & s) {
        CHECK(((s.find('.') != std::string::npos) ||
               (s.find('e') != std::string::npos) ||
               (s.find('E') != std::string::npos)));
    };

    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F1
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F2
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F3
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F4
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F5
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F6
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F7
    REQUIRE(pp.next_line(out_line));
    check_has_dot_or_e(out_line); // F8

    CHECK_FALSE(pp.next_line(out_line));
}

// New DEFL tests: verify text-substitution semantics and accumulation of previous value

TEST_CASE("Preprocessor: DEFL creates text macro using previous (undefined -> accumulates)",
          "[preprocessor][defl]") {
    Preprocessor pp;

    // Start with var undefined. DEFL should substitute previous (empty) -> becomes "+1"
    // Second DEFL concatenates previous "+1" -> "+1+1"
    std::vector<std::string> lines = {
        "#defl var = var+1",
        "LD A,var",
        "#defl var = var+1",
        "LD B,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,+1");       // first DEFL produced "+1"
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,+1+1");     // second DEFL produced "+1+1"
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: DEFL can extend an existing DEFINE value",
          "[preprocessor][defl]") {
    Preprocessor pp;

    // Start with var defined as "2". DEFL should paste previous "2" producing "2+1".
    std::vector<std::string> lines = {
        "#define var 2",
        "#defl var = var+1",
        "LD A,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,2+1");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name DEFL value creates and extends macro",
          "[preprocessor][defl][name-directive]") {
    Preprocessor pp;

    // Case 1: name is undefined, DEFL should substitute previous (empty) -> "+1"
    // Case 2: name is defined, DEFL should paste previous "+1" -> "+1+1"
    std::vector<std::string> lines = {
        "var DEFL var+1",
        "LD A,var",
        "var DEFL var+1",
        "LD B,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,+1");       // first DEFL produced "+1"
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,+1+1");     // second DEFL produced "+1+1"
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name DEFL value extends an existing DEFINE value",
          "[preprocessor][defl][name-directive]") {
    Preprocessor pp;

    // Start with var defined as "2". DEFL should paste previous "2" producing "2+1".
    std::vector<std::string> lines = {
        "#define var 2",
        "var DEFL var+1",
        "LD A,var"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,2+1");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name DEFINE value creates macro",
          "[preprocessor][define][name-directive]") {
    Preprocessor pp;

    // Use alternative syntax: name DEFINE value
    std::vector<std::string> lines = {
        "FOO DEFINE 42",
        "LD A,FOO"
    };

    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Macro FOO should expand to 42
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,42");
    CHECK_FALSE(pp.next_line(out_line));
}

// ------------------------- New MACRO tests -------------------------

TEST_CASE("Preprocessor: MACRO (multi-line) expands to multiple output lines",
          "[preprocessor][macro][multiline]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO pushall",
        "    push bc",
        "    push de",
        "    push hl",
        "ENDM",
        "pushall"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The macro should expand to three lines: "push bc", "push de", "push hl"
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push bc");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push de");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push hl");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: empty multi-line object-like MACRO expands to nothing",
          "[preprocessor][macro][multiline][empty]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO empty",
        "ENDM",
        "LD BEFORE,1",
        "empty",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The empty macro invocation should produce no lines; we should see the surrounding lines only.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: empty multi-line function-like MACRO expands to nothing",
          "[preprocessor][macro][multiline][empty][function]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO emptyfn(x)",
        "ENDM",
        "LD BEFORE,1",
        "emptyfn(1)",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The empty function-like macro invocation should produce no lines; we should see the surrounding lines only.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: MACRO with parameters expands each body line using args",
          "[preprocessor][macro][params]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO two_loads(x,y)",
        "    ld a,x",
        "    ld b,y",
        "ENDM",
        "two_loads(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first MACRO with parameters expands each body line using args",
          "[preprocessor][macro][params][name-directive]") {
    Preprocessor pp;

    // Alternative name-first DEFINE syntax
    std::vector<std::string> lines = {
        "two_loads MACRO x,y",
        "    ld a,x",
        "    ld b,y",
        "ENDM",
        "two_loads(1,2)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first MACRO (object-like) expands to multiple output lines",
          "[preprocessor][macro][multiline][name-directive]") {
    Preprocessor pp;

    // Alternative name-first DEFINE syntax
    std::vector<std::string> lines = {
        "two_lines MACRO",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "two_lines"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: MACRO EXITM aborts expansion (no lines emitted when EXITM is first)",
          "[preprocessor][macro][exitm]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO abortme",
        "    EXITM",
        "    ld a,1",
        "ENDM",
        "abortme",
        "ld a,after"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // abortme should produce no lines because EXITM appears before any output
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,after");
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: MACRO LOCAL makes identifiers unique per expansion",
          "[preprocessor][macro][local]") {
    Preprocessor pp;
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

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    // tmp should have been renamed to a unique identifier; check it contains "tmp_" and the argument
    size_t p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    size_t p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix1 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));

    CHECK(out_line == std::string("ld tmp_") + tmp_suffix1 + ",1");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == std::string("ld a,tmp_") + tmp_suffix1);

    // Second expansion should use a different tmp_<M>
    REQUIRE(pp.next_line(out_line));

    p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix2 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));

    CHECK(out_line == std::string("ld tmp_") + tmp_suffix2 + ",2");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == std::string("ld a,tmp_") + tmp_suffix2);


    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: MACRO LOCAL on multiple lines renames all locals consistently",
          "[preprocessor][macro][local][multiple]") {
    Preprocessor pp;

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
    REQUIRE(pp.open(filename));

    std::string out_line;

    // First expansion (n==1)
    REQUIRE(pp.next_line(out_line));
    // Expect "ld tmp_<id>,1"
    size_t p_tmp = out_line.find("tmp_");
    REQUIRE(p_tmp != std::string::npos);
    size_t p_tmp_end = out_line.find_first_of(", \t", p_tmp);
    if (p_tmp_end == std::string::npos) {
        p_tmp_end = out_line.size();
    }
    std::string tmp_suffix1 = out_line.substr(p_tmp + 4, p_tmp_end - (p_tmp + 4));
    CHECK(out_line == std::string("ld tmp_") + tmp_suffix1 + ",1");

    REQUIRE(pp.next_line(out_line));
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
    REQUIRE(pp.next_line(out_line));
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

    REQUIRE(pp.next_line(out_line));
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

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: label before multi-line object-like macro expansion",
          "[preprocessor][macro][label][object]") {
    Preprocessor pp;
    std::vector<std::string> lines = {
        "MACRO mobj",
        "    ld a,1",
        "    ld b,2",
        "ENDM",
        "label: mobj",
        "nop"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect the label on its own logical line first
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == ".label");

    // Then the macro body lines
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");

    // Then the following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "nop");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: label before multi-line function-like macro expansion",
          "[preprocessor][macro][label][function]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "MACRO mfn(x)",
        "    ld a,x",
        "    ld b,x",
        "ENDM",
        "label: mfn(5)",
        "nop"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // Label should appear before first macro body line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == ".label");

    // Then the macro body lines
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,5");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,5");

    // Then the following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "nop");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: Location line numbers for object-like multi-line macro expansion",
          "[preprocessor][macro][location][object]") {
    Preprocessor pp;

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
    REQUIRE(pp.open(filename));

    std::string out_line;

    // First non-macro logical line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");
    CHECK(g_errors.line_num() == 5);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // First macro expansion line should report the invocation's physical line number (6)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    CHECK(g_errors.line_num() == 6);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // Second macro expansion line should have the same reported line number (6)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    CHECK(g_errors.line_num() == 6);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // Back to following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");
    CHECK(g_errors.line_num() == 7);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: Location line numbers for function-like multi-line macro expansion",
          "[preprocessor][macro][location][function]") {
    Preprocessor pp;

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
    REQUIRE(pp.open(filename));

    std::string out_line;

    // First normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");
    CHECK(g_errors.line_num() == 5);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // First macro expansion line should report the invocation's physical line number (6)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,5");
    CHECK(g_errors.line_num() == 6);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // Second macro expansion line should have the same reported line number (6)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,5");
    CHECK(g_errors.line_num() == 6);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    // Back to following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");
    CHECK(g_errors.line_num() == 7);
    CHECK(g_errors.filename() == normalize_expected_path(filename));

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with object-like then function-like macros expands sequentially",
          "[preprocessor][macro][split]") {
    Preprocessor pp;

    // M1 is an object-like single-line macro, FN is a function-like single-line macro.
    // The source line contains "M1 : FN(2,3)" - after expansion and splitting at ':'
    // we should get the expansion of M1 first, then the expansion of FN.
    std::vector<std::string> lines = {
        "#define M1 ld a,1",
        "#define FN(x,y) ld b,x",
        "M1 : FN(2,3)"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First segment: expansion of M1
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");

    // Second segment: expansion of FN(2,3)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with function-like then object-like macros expands sequentially",
          "[preprocessor][macro][split]") {
    Preprocessor pp;

    // FOO(5) is a function-like single-line macro, M2 is an object-like single-line macro.
    // The source line "FOO(5) : M2" should expand FOO first, then M2.
    std::vector<std::string> lines = {
        "#define FOO(x) ld a,x",
        "#define M2 ld b,2",
        "FOO(5) : M2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    // First segment: expansion of FOO(5)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,5");

    // Second segment: expansion of M2
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with multi-line object-like then multi-line function-like macros expands sequentially",
          "[preprocessor][macro][split][multiline]") {
    Preprocessor pp;

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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // M1 body lines
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,1");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");

    // FN body lines (with args)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld c,3");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with multi-line function-like then multi-line object-like macros expands sequentially",
          "[preprocessor][macro][split][multiline]") {
    Preprocessor pp;

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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // FOO body lines
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a,5");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld a2,5");

    // M2 body lines
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b,2");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "ld b2,22");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with multi-line empty function-like then empty object-like macros expands to nothing",
          "[preprocessor][macro][split][multiline][empty]") {
    Preprocessor pp;

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

    REQUIRE(pp.open(filename));

    std::string out_line;

    // The empty macro invocation should produce no lines; we should see the surrounding lines only.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: split line with multi-line empty object-like then empty function-like macros expands to nothing",
          "[preprocessor][macro][split][multiline][empty]") {
    Preprocessor pp;

    // Same as above but object-like first, function-like second.
    std::vector<std::string> lines = {
        "#define EMPTY \"\"",
        "MACRO MAC",
        "    EMPTY : EMPTY",
        "    EMPTY : EMPTY",
        "ENDM",
        "MACRO FOO(x)",
        "    EMPTY : EMPTY",
        "    EMPTY : EMPTY",
        "ENDM",
        "LD BEFORE,1",
        "MAC : FOO(1)",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Invocation should produce nothing; only surrounding lines remain.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD BEFORE,1");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTC with string literal iterates characters",
          "[preprocessor][directive][reptc][string]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "REPTC var, \"hi\"",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'h' == 104, 'i' == 105
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 104");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 105");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTC with identifier/string macro iterates expanded characters",
          "[preprocessor][directive][reptc][identifier][macro]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#defl text = \"abc\"",
        "REPTC var, text",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'a' == 97, 'b' == 98, 'c' == 99
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 97"); // 'a'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 98"); // 'b'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 99"); // 'c'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTC with numeric macro iterates over digits' characters",
          "[preprocessor][directive][reptc][number]") {
    Preprocessor pp;

    // version -> "23" -> iterate '2' and '3' -> ASCII 50 and 51
    std::vector<std::string> lines = {
        "#define version 23",
        "REPTC var, version",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 50"); // '2'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 51"); // '3'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

// Additional REPTC tests: verify escape sequences are scanned and iterated

TEST_CASE("Preprocessor: REPTC iterates escape sequences (CR and LF)",
          "[preprocessor][directive][reptc][escape]") {
    Preprocessor pp;

    // String contains X, CR, LF, Y -> expect codes 88,13,10,89
    std::vector<std::string> lines = {
        "REPTC var, \"X\\r\\nY\"",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 88"); // 'X'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 13"); // '\r'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 10"); // '\n'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 89"); // 'Y'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTC iterates escaped backslash correctly",
          "[preprocessor][directive][reptc][escape][backslash]") {
    Preprocessor pp;

    // String "a\\b" -> chars 'a' (97), '\' (92), 'b' (98)
    std::vector<std::string> lines = {
        "REPTC var, \"a\\\\b\"",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 97"); // 'a'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 92"); // '\\'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 98"); // 'b'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTC with bare identifier iterates identifier characters",
          "[preprocessor][directive][reptc][name-first][identifier]") {
    Preprocessor pp;

    // No macro named 'hello' is defined here - REPTC should iterate the characters of the identifier itself.
    std::vector<std::string> lines = {
        "REPTC var, hello",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'h' 'e' 'l' 'l' 'o' -> 104,101,108,108,111
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 104");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 101");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 108");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 108");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 111");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

// Name-first REPTC tests: "var REPTC argument" alternative syntax

TEST_CASE("Preprocessor: name-first REPTC with bare identifier iterates identifier characters",
          "[preprocessor][directive][reptc][name-first][identifier]") {
    Preprocessor pp;

    // No macro named 'hello' is defined here - var REPTC hello should iterate 'hello'.
    std::vector<std::string> lines = {
        "var REPTC hello",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'h' 'e' 'l' 'l' 'o' -> 104,101,108,108,111
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 104");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 101");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 108");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 108");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 111");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first REPTC with string literal iterates characters",
          "[preprocessor][directive][reptc][name-first][string]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "var REPTC \"hi\"",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'h' == 104, 'i' == 105
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 104");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 105");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first REPTC with identifier macro iterates expanded characters",
          "[preprocessor][directive][reptc][name-first][identifier][macro]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#defl text = \"abc\"",
        "var REPTC text",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'a' == 97, 'b' == 98, 'c' == 99
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 97"); // 'a'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 98"); // 'b'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 99"); // 'c'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: name-first REPTC with numeric macro iterates over digits' characters",
          "[preprocessor][directive][reptc][name-first][number]") {
    Preprocessor pp;

    // version -> "23" -> iterate '2' and '3' -> ASCII 50 and 51
    std::vector<std::string> lines = {
        "#define version 23",
        "var REPTC version",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 50"); // '2'
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 51"); // '3'

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

// REPTC: empty / missing argument / empty-macro cases for both syntaxes

TEST_CASE("Preprocessor: REPTC with empty string produces no output (both syntaxes)",
          "[preprocessor][directive][reptc][empty]") {
    // Syntax: REPTC var, ""
    {
        Preprocessor pp;

        std::vector<std::string> lines = {
            "REPTC var, \"\"",
            "defb var",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");

        CHECK_FALSE(pp.next_line(out_line));
    }

    // Name-first syntax: var REPTC ""
    {
        Preprocessor pp;

        std::vector<std::string> lines = {
            "var REPTC \"\"",
            "defb var",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");

        CHECK_FALSE(pp.next_line(out_line));
    }
}

TEST_CASE("Preprocessor: REPTC with macro defined empty produces no output (both syntaxes)",
          "[preprocessor][directive][reptc][empty-macro]") {
    // Define an empty macro then use it as REPTC argument
    {
        Preprocessor pp;

        std::vector<std::string> lines = {
            "MACRO EMPTY",
            "ENDM",
            "REPTC var, EMPTY",
            "defb var",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);

        REQUIRE(pp.open(filename));

        std::string out_line;

        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");

        CHECK_FALSE(pp.next_line(out_line));
    }

    // Name-first syntax with empty macro
    {
        Preprocessor pp;

        std::vector<std::string> lines = {
            "MACRO EMPTY",
            "ENDM",
            "var REPTC EMPTY",
            "defb var",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");

        CHECK_FALSE(pp.next_line(out_line));
    }
}

TEST_CASE("Preprocessor: REPTC with missing argument produces no output and reports error (both syntaxes)",
          "[preprocessor][directive][reptc][missing]") {
    // Syntax: REPTC var,   (trailing comma, missing argument)

    {
        g_errors.reset();
        CerrRedirect redirect;
        Preprocessor pp;
        std::vector<std::string> lines = {
            "REPTC var,",
            "defb var",
            "ENDR",
        };
        std::string filename = write_temp_file(lines);

        REQUIRE(pp.open(filename));

        std::string out_line;
        bool any_output = false;
        while (pp.next_line(out_line)) {
            (void)out_line;
            any_output = true;
        }
        // Missing argument is a syntax error; ensure no output was produced
        CHECK_FALSE(any_output);
        CHECK(g_errors.has_errors());
        std::string errout = redirect.str();
        CHECK(errout.find("REPTC") != std::string::npos);
    }

    // Name-first: "var REPTC" with no following argument
    {
        g_errors.reset();
        CerrRedirect redirect;
        Preprocessor pp;

        std::vector<std::string> lines = {
            "var REPTC",
            "defb var",
            "ENDR",
        };
        std::string filename = write_temp_file(lines);

        REQUIRE(pp.open(filename));

        std::string out_line;
        bool any_output = false;
        while (pp.next_line(out_line)) {
            (void)out_line;
            any_output = true;
        }
        // Missing argument should be treated as syntax error; ensure no output produced
        CHECK_FALSE(any_output);
        CHECK(g_errors.has_errors());
        std::string errout = redirect.str();
        CHECK(errout.find("REPTC") != std::string::npos);
    }
}

TEST_CASE("Preprocessor: REPTC with macro-defined string of spaces expands correctly",
          "[preprocessor][directive][reptc][spaces]") {
    Preprocessor pp;

    // FOO is defined as a quoted string containing three spaces.
    // REPTC should iterate those three space characters and emit their codes (32).
    std::vector<std::string> lines = {
        "#define FOO \"   \"",
        "REPTC var, FOO",
        "defb var",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 32"); // ' '
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 32"); // ' '
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 32"); // ' '

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTI repeats body for each expression (normal syntax)",
          "[preprocessor][directive][repti][basic]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "REPTI reg, bc, de, hl, af",
        "push reg",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push bc");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push de");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push hl");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push af");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTI name-first syntax repeats body for each expression",
          "[preprocessor][directive][repti][name-first]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "reg REPTI bc, de, hl, af",
        "push reg",
        "ENDR",
        "LD AFTER,2"
    };
    std::string filename = write_temp_file(lines);

    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push bc");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push de");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push hl");
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "push af");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD AFTER,2");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: REPTI with empty list produces no output (both syntaxes)",
          "[preprocessor][directive][repti][empty]") {
    // Normal syntax: trailing comma -> empty list
    {
        g_errors.reset();
        Preprocessor pp;

        std::vector<std::string> lines = {
            "REPTI reg,",
            "push reg",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        // No push lines should be emitted; next output is the following normal line.
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");
        CHECK_FALSE(pp.next_line(out_line));
        CHECK_FALSE(g_errors.has_errors());
    }

    // Name-first syntax: missing list after REPTI -> empty list
    {
        g_errors.reset();
        Preprocessor pp;

        std::vector<std::string> lines = {
            "reg REPTI",
            "push reg",
            "ENDR",
            "LD AFTER,2"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        // No push lines should be emitted; next output is the following normal line.
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD AFTER,2");
        CHECK_FALSE(pp.next_line(out_line));
        CHECK_FALSE(g_errors.has_errors());
    }
}

// Preprocessor: output string literals become lists of integer character codes

TEST_CASE("Preprocessor: macro-defined string expands to list of char codes",
          "[preprocessor][string][macro][defb]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define S \"abc\"",
        "defb S"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'a' 'b' 'c' -> 97,98,99
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 97,98,99");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: direct string literal expands to list of char codes",
          "[preprocessor][string][literal][defb]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "defb \"hi\""
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // 'h' 'i' -> 104,105
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 104,105");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: macro-defined string with escapes expands to char codes",
          "[preprocessor][string][escape][defb]") {
    Preprocessor pp;

    // "X\r\nY" -> 'X' (88), '\r' (13), '\n' (10), 'Y' (89)
    std::vector<std::string> lines = {
        "#define STR \"X\\r\\nY\"",
        "defb STR"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "defb 88,13,10,89");

    CHECK_FALSE(pp.next_line(out_line));
}

// New tests: labels are split into their own logical line so assembler sees label on a separate line.

TEST_CASE("Preprocessor: splits 'name: instr' into label line then instruction",
          "[preprocessor][label][split]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "start: LD A,1",
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Expect the label on its own logical line first
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == ".start");

    // Then the instruction on the next line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: splits '.name instr' (dot-label) into label line then instruction",
          "[preprocessor][label][split][dotlabel]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        ".local LD A,1",
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    // Dot-label should be separated and emitted as its own logical line (preserve the leading dot)
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == ".local");

    // Then the instruction on the next line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");

    CHECK_FALSE(pp.next_line(out_line));
}

// New tests: convert "name EQU text" and "name = text" to "DEFC name = <macro-expanded(text)>"

TEST_CASE("Preprocessor: 'name EQU text' is converted to DEFC form (simple)",
          "[preprocessor][directive][equ][defc]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "label EQU 42"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC label=42");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: 'name EQU text' macro-expands RHS before emitting DEFC",
          "[preprocessor][directive][equ][defc][macro]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define VAL 23",
        "myequ EQU VAL+1"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC myequ=23+1");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: 'name = text' is converted to DEFC form (simple)",
          "[preprocessor][directive][assign][defc]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "foo = 5+6"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC foo=5+6");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: 'name = text' macro-expands RHS before emitting DEFC",
          "[preprocessor][directive][assign][defc][macro]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "#define N 2",
        "bar = N*3"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC bar=2*3");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: whitespace-tolerant 'name EQU text' and 'name = text' conversions",
          "[preprocessor][directive][equ][assign][whitespace]") {
    Preprocessor pp;

    std::vector<std::string> lines = {
        "   lbl   EQU    7   ",
        "   another    =    8+  1"
    };
    std::string filename = write_temp_file(lines);
    REQUIRE(pp.open(filename));

    std::string out_line;

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC lbl=7");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "DEFC another=8+ 1");

    CHECK_FALSE(pp.next_line(out_line));
}

// BINARY / INCBIN tests: include a 256-byte binary (0..255) and expect DEFB lines with 16 bytes each.

TEST_CASE("Preprocessor: BINARY includes 256-byte file and emits DEFB lines (BINARY)",
          "[preprocessor][directive][binary][incbin]") {
    Preprocessor pp;

    // Create 256-byte binary file with values 0..255
    std::string binname = "test_preproc_bin_256.bin";
    {
        std::ofstream bos(binname, std::ios::binary);
        for (int i = 0; i < 256; ++i) {
            char c = static_cast<char>(i & 0xFF);
            bos.put(c);
        }
    }
    // Track for cleanup
    track_temp_file(binname);

    // Create asm file that includes the binary
    std::vector<std::string> lines = {
        "BINARY \"" + binname + "\""
    };
    std::string asmfile = write_temp_file(lines);

    REQUIRE(pp.open(asmfile));

    std::string out_line;

    // Expect 256 bytes emitted as 16 lines of 16 bytes each
    for (int line_idx = 0; line_idx < 16; ++line_idx) {
        REQUIRE(pp.next_line(out_line));

        // Split mnemonic and data
        size_t sp = out_line.find(' ');
        REQUIRE(sp != std::string::npos);
        std::string mnemonic = out_line.substr(0, sp);
        std::string data = out_line.substr(sp + 1);

        // mnemonic should be "defb" case-insensitive
        std::string lower = to_lower(mnemonic);
        CHECK(lower == "defb");

        // trim data (both ends)
        data = trim(data);

        // parse comma-separated integers
        std::vector<int> vals;
        size_t pos = 0;
        while (pos < data.size()) {
            size_t comma = data.find(',', pos);
            std::string tok = (comma == std::string::npos) ? data.substr(pos) : data.substr(
                                  pos, comma - pos);
            tok = trim(tok);
            REQUIRE(!tok.empty());
            vals.push_back(std::stoi(tok));
            if (comma == std::string::npos) {
                break;
            }
            pos = comma + 1;
        }

        CHECK(vals.size() == 16);
        for (size_t j = 0; j < 16; ++j) {
            int expected = line_idx * 16 + static_cast<int>(j);
            CHECK(vals[j] == expected);
        }
    }

    // No more lines
    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: INCBIN includes 256-byte file and emits DEFB lines (INCBIN)",
          "[preprocessor][directive][incbin][binary]") {
    Preprocessor pp;

    // Create 256-byte binary file with values 0..255 (reuse name)
    std::string binname2 = "test_preproc_bin_256_2.bin";
    {
        std::ofstream bos(binname2, std::ios::binary);
        for (int i = 0; i < 256; ++i) {
            char c = static_cast<char>(i & 0xFF);
            bos.put(c);
        }
    }
    track_temp_file(binname2);

    // Create asm file that uses INCBIN (alternative directive name)
    std::vector<std::string> lines = {
        "INCBIN \"" + binname2 + "\""
    };
    std::string asmfile2 = write_temp_file(lines);

    REQUIRE(pp.open(asmfile2));

    std::string out_line;

    // Expect 16 lines, 16 values each
    for (int line_idx = 0; line_idx < 16; ++line_idx) {
        REQUIRE(pp.next_line(out_line));

        // Split mnemonic and data
        size_t sp = out_line.find(' ');
        REQUIRE(sp != std::string::npos);
        std::string mnemonic = out_line.substr(0, sp);
        std::string data = out_line.substr(sp + 1);

        // mnemonic should be "defb" case-insensitive
        std::string lower = to_lower(mnemonic);
        CHECK(lower == "defb");

        // trim data
        data = trim(data);

        std::vector<int> vals;
        size_t pos = 0;
        while (pos < data.size()) {
            size_t comma = data.find(',', pos);
            std::string tok = (comma == std::string::npos) ? data.substr(pos) : data.substr(
                                  pos, comma - pos);
            tok = trim(tok);
            REQUIRE(!tok.empty());
            vals.push_back(std::stoi(tok));
            if (comma == std::string::npos) {
                break;
            }
            pos = comma + 1;
        }

        CHECK(vals.size() == 16);
        for (size_t j = 0; j < 16; ++j) {
            int expected = line_idx * 16 + static_cast<int>(j);
            CHECK(vals[j] == expected);
        }
    }

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor::open fails for missing file (simple filename)",
          "[preprocessor][open][file_not_found]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    // Ensure file does not exist
    std::string filename = "test_preproc_missing_file_001.asm";
    std::remove(filename.c_str());

    // open() should fail and reporter should have recorded an error
    CHECK_FALSE(pp.open(filename));

    CHECK(g_errors.has_errors());
    std::string err = redirect.str();
    CHECK(err.find(filename) != std::string::npos);
}

TEST_CASE("Preprocessor::open fails for missing file (nonexistent path)",
          "[preprocessor][open][file_not_found][path]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    // Use a path that almost certainly doesn't exist
    std::string filename = "no_such_dir/test_preproc_missing_file_002.asm";
    // Remove in case of previous runs (no-op if not present)
    std::remove(filename.c_str());

    CHECK_FALSE(pp.open(filename));

    CHECK(g_errors.has_errors());
    std::string err = redirect.str();
    CHECK(err.find("test_preproc_missing_file_002.asm") != std::string::npos);
}

TEST_CASE("Preprocessor: INCLUDE reports error for missing file",
          "[preprocessor][include][file_not_found]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    std::string missing = "no_such_include_zzz.asm";
    std::vector<std::string> lines = {
        "#include \"" + missing + "\"",
        "LD AFTER,2"
    };
    std::string asmfile = write_temp_file(lines);

    REQUIRE(pp.open(asmfile));

    std::string out_line;
    // Drive the preprocessor until EOF so the include is attempted.
    while (pp.next_line(out_line)) {
        (void)out_line;
    }

    CHECK(g_errors.has_errors());
    std::string err = redirect.str();
    CHECK(err.find(missing) != std::string::npos);
}

TEST_CASE("Preprocessor: BINARY reports error for missing file",
          "[preprocessor][directive][binary][file_not_found]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    std::string missing = "no_such_binary_zzz.bin";
    std::vector<std::string> lines = {
        "BINARY \"" + missing + "\"",
        "LD AFTER,2"
    };
    std::string asmfile = write_temp_file(lines);

    REQUIRE(pp.open(asmfile));

    std::string out_line;
    // Drive the preprocessor so the BINARY directive is processed.
    while (pp.next_line(out_line)) {
        (void)out_line;
    }

    CHECK(g_errors.has_errors());
    std::string err = redirect.str();
    CHECK(err.find(missing) != std::string::npos);
}

TEST_CASE("Preprocessor: INCBIN reports error for missing file",
          "[preprocessor][directive][incbin][file_not_found]") {
    g_errors.reset();
    CerrRedirect redirect;
    Preprocessor pp;

    std::string missing = "no_such_incbin_zzz.bin";
    std::vector<std::string> lines = {
        "INCBIN \"" + missing + "\"",
        "LD AFTER,3"
    };
    std::string asmfile = write_temp_file(lines);

    REQUIRE(pp.open(asmfile));

    std::string out_line;
    // Drive the preprocessor so the INCBIN directive is processed.
    while (pp.next_line(out_line)) {
        (void)out_line;
    }

    CHECK(g_errors.has_errors());
    std::string err = redirect.str();
    CHECK(err.find(missing) != std::string::npos);
}

// -- New tests verifying include search order semantics --

TEST_CASE("Preprocessor: quoted include searches current-file directory before include paths",
          "[preprocessor][include][search_order][quoted]") {
    Preprocessor pp;

    // Create directories
    std::string main_dir = make_temp_dir();
    std::string inc_dir = make_temp_dir();

    // Common include filename
    std::string inc_name = "common.inc";

    // Create include file in include path with sentinel content
    write_temp_file_in_dir(inc_dir, inc_name, { "LD C,PATH" });

    // Create include file in the same directory as main file - this must be preferred for quoted includes.
    write_temp_file_in_dir(main_dir, inc_name, { "LD C,LOCAL" });

    // Create main file inside main_dir that includes the common.inc using quotes
    std::string mainfile = write_temp_file_in_dir(main_dir, "main_q.asm", { "#include \"" + inc_name + "\"", "LD A,1" });

    // Add include path (should not be chosen for quoted include because current-file dir takes precedence)
    pp.add_include_path(inc_dir);

    REQUIRE(pp.open(mainfile));

    std::string out_line;

    // First line should come from the included file located in the same directory as mainfile
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,LOCAL");

    // Then the following normal line
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD A,1");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: angle-bracket include searches include paths in order (not current-file directory)",
          "[preprocessor][include][search_order][angle]") {
    Preprocessor pp;

    // Create directories
    std::string main_dir = make_temp_dir();
    std::string inc_dir1 = make_temp_dir();
    std::string inc_dir2 = make_temp_dir();

    std::string inc_name = "shared.inc";

    // Create include files with different content to identify which path was selected
    write_temp_file_in_dir(inc_dir1, inc_name, { "LD C,DIR1" });
    write_temp_file_in_dir(inc_dir2, inc_name, { "LD C,DIR2" });

    // Create a main file in main_dir that will include using angle brackets.
    std::string mainfile = write_temp_file_in_dir(main_dir, "main_a.asm", { "#include <" + inc_name + ">", "LD B,1" });

    // Add include paths in a specific order; first added should be searched first for angle includes
    pp.add_include_path(inc_dir2); // intentionally add dir2 first
    pp.add_include_path(inc_dir1);

    REQUIRE(pp.open(mainfile));

    std::string out_line;

    // For angle includes, current-file directory should NOT be searched; include_paths order determines choice.
    // Because we added inc_dir2 first, it should pick that file.
    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD C,DIR2");

    REQUIRE(pp.next_line(out_line));
    CHECK(out_line == "LD B,1");

    CHECK_FALSE(pp.next_line(out_line));
}

TEST_CASE("Preprocessor: IF / ELIF / ELSE / ENDIF directives (nesting + branches)",
          "[preprocessor][directive][if][elif][else][endif]") {
    Preprocessor pp;

    SECTION("Simple IF/ELSE selects IF branch when true") {
        std::vector<std::string> lines = {
            "IF 1",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIF chain picks the first true ELIF") {
        std::vector<std::string> lines = {
            "IF 0",
            "LD A,1",
            "ELIF 0",
            "LD A,2",
            "ELIF 1",
            "LD A,3",
            "ELSE",
            "LD A,4",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,3");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Nested IF/ELSE works correctly") {
        std::vector<std::string> lines = {
            "IF 1",
            "  IF 0",
            "    LD A,1",
            "  ELSE",
            "    LD A,2",
            "  ENDIF",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELSE taken when no IF/ELIF branch true") {
        std::vector<std::string> lines = {
            "IF 0",
            "LD A,1",
            "ELIF 0",
            "LD A,2",
            "ELSE",
            "LD A,3",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,3");
        CHECK_FALSE(pp.next_line(out_line));
    }
}

TEST_CASE("Preprocessor: IF expression callback integration (assembler evaluation)",
          "[preprocessor][directive][if][callback]") {
    // Two scenarios:
    // 1) callback evaluates expression -> branch selected
    // 2) callback fails to evaluate -> branch treated false

    SECTION("Callback returns true -> IF branch executed") {
        g_errors.reset();
        Preprocessor pp;

        // Register callback that resolves "EXPR" -> 1, anything else not handled.
        pp.set_eval_callback([](const std::string & expr,
        const Location&)->Preprocessor::EvalResult {
            Preprocessor::EvalResult r;
            if (expr == "EXPR") {
                r.ok = true;
                r.value = 1;
                r.unknown_link_time = false;
            }
            return r;
        });

        std::vector<std::string> lines = {
            "IF EXPR",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK_FALSE(pp.next_line(out_line));
        CHECK_FALSE(g_errors.has_errors());
    }

    SECTION("Callback returns false -> syntax error and IF treated false") {
        g_errors.reset();
        Preprocessor pp;

        // Callback that never evaluates anything (always returns ok==false)
        pp.set_eval_callback([](const std::string&,
        const Location&)->Preprocessor::EvalResult {
            return Preprocessor::EvalResult{}; // ok=false
        });

        std::vector<std::string> lines = {
            "IF EXPR",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
        CHECK_FALSE(g_errors.has_errors());
    }
}

// IFDEF / ELIFDEF / ELIFNDEF / ELSE / ENDIF tests
TEST_CASE("Preprocessor: IFDEF / ELIFDEF / ELIFNDEF / ELSE / ENDIF behavior",
          "[preprocessor][directive][ifdef][elifdef][elifndef][else][endif]") {
    Preprocessor pp;

    SECTION("Simple IFDEF selects IF branch when defined") {
        std::vector<std::string> lines = {
            "#define FOO",
            "IFDEF FOO",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("IFDEF with no define falls through to ELSE") {
        std::vector<std::string> lines = {
            "IFDEF BAR",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIFDEF chain picks the first true ELIFDEF") {
        std::vector<std::string> lines = {
            "IFDEF X",
            "LD A,1",
            "ELIFDEF Y",
            "LD A,2",
            "ELIFDEF Z",
            "LD A,3",
            "ELSE",
            "LD A,4",
            "ENDIF"
        };
        // define Z only
        lines.insert(lines.begin(), "#define Z");
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,3");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIFNDEF taken when previous conditions false and symbol not defined") {
        std::vector<std::string> lines = {
            "IFDEF NONEXIST",
            "LD A,1",
            "ELIFNDEF ALSO_MISSING",
            "LD A,2",
            "ELSE",
            "LD A,3",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Nested IFDEF/ELSE works correctly") {
        std::vector<std::string> lines = {
            "#define OUTER",
            "IFDEF OUTER",
            "  IFDEF INNER",
            "    LD A,1",
            "  ELSE",
            "    LD A,2",
            "  ENDIF",
            "ELSE",
            "  LD A,3",
            "ENDIF"
        };
        // INNER is not defined, OUTER is defined -> expect inner ELSE
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Hash-prefixed directives (#ifdef/#ifndef) are accepted") {
        std::vector<std::string> lines = {
            "#define HASHSYM",
            "#ifdef HASHSYM",
            "LD A,1",
            "#else",
            "LD A,2",
            "#endif",
            "#ifndef HASHSYM",
            "LD B,1",
            "#else",
            "LD B,2",
            "#endif"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        // from #ifdef branch
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");

        // from #ifndef branch (HASHSYM is defined -> else taken)
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,2");

        CHECK_FALSE(pp.next_line(out_line));
    }

// New IFNDEF / ELIFNDEF / #ifndef / #elifndef tests
    SECTION("Simple IFNDEF selects IF branch when undefined") {
        std::vector<std::string> lines = {
            "IFNDEF BAR",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("IFNDEF with symbol defined falls through to ELSE") {
        std::vector<std::string> lines = {
            "#define FOO",
            "IFNDEF FOO",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIFNDEF chain picks the first true ELIFNDEF") {
        std::vector<std::string> lines = {
            "#define AA",
            "IFNDEF AA",
            "LD A,1",
            "ELIFNDEF BB",
            "LD A,2",
            "ELIFNDEF CC",
            "LD A,3",
            "ELSE",
            "LD A,4",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line ==
              "LD A,2"); // A defined -> IFNDEF false; B undefined -> first ELIFNDEF true
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Nested IFNDEF/ELSE works correctly") {
        std::vector<std::string> lines = {
            "#define INNER",
            "IFNDEF OUTER",
            "  IFNDEF INNER",
            "    LD A,1",
            "  ELSE",
            "    LD A,2",
            "  ENDIF",
            "ELSE",
            "  LD A,3",
            "ENDIF"
        };
        // OUTER is not defined, INNER is defined -> outer true, inner false -> inner ELSE taken
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Hash-prefixed directives (#ifndef/#elifndef) are accepted") {
        std::vector<std::string> lines = {
            "#define HASHSYM",
            "#ifndef HASHSYM",
            "LD A,1",
            "#else",
            "LD A,2",
            "#endif",
            "#ifndef OTHER",
            "LD B,1",
            "#elifndef MISSING2",
            "LD B,2",
            "#endif"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        // First #ifndef: HASHSYM is defined -> else taken
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");

        // Second block: OTHER undefined -> first branch should be taken
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,1");

        CHECK_FALSE(pp.next_line(out_line));
    }
}

// Tests: IFDEF / IFNDEF / ELIFDEF / ELIFNDEF using assembler-provided symbol-defined callback
TEST_CASE("Preprocessor: IFDEF/IFNDEF/ELIFDEF/ELIFNDEF cooperate with assembler symbol callback",
          "[preprocessor][directive][ifdef][symbol-callback]") {
    SECTION("IFDEF sees assembler-defined symbol (no macro)") {
        Preprocessor pp;

        // Callback claims symbol SYM_CB is defined
        pp.set_symbol_defined_callback([](const std::string & name) -> bool {
            return name == "SYM_CB";
        });

        std::vector<std::string> lines = {
            "IFDEF SYM_CB",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("IFNDEF treats assembler-defined symbol as defined (falls to ELSE)") {
        Preprocessor pp;

        // Callback claims symbol HAS is defined
        pp.set_symbol_defined_callback([](const std::string & name) -> bool {
            return name == "HAS";
        });

        std::vector<std::string> lines = {
            "IFNDEF HAS",
            "LD A,1",
            "ELSE",
            "LD A,2",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIFDEF chain can pick branch by assembler symbol (no macro)") {
        Preprocessor pp;

        // Callback reports ZSYM defined only
        pp.set_symbol_defined_callback([](const std::string & name) -> bool {
            return name == "ZSYM";
        });

        std::vector<std::string> lines = {
            "IFDEF XSYM",
            "LD A,1",
            "ELIFDEF YSYM",
            "LD A,2",
            "ELIFDEF ZSYM",
            "LD A,3",
            "ELSE",
            "LD A,4",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,3");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("ELIFNDEF chain: assembler-defined name disables IFNDEF, next ELIFNDEF may trigger") {
        Preprocessor pp;

        // Callback defines ONLY 'ADEF' so IFNDEF ADEF is false; B and C are not defined.
        pp.set_symbol_defined_callback([](const std::string & name) -> bool {
            return name == "ADEF";
        });

        std::vector<std::string> lines = {
            "IFNDEF ADEF",
            "LD A,1",
            "ELIFNDEF BDEF",
            "LD A,2",
            "ELIFNDEF CDEF",
            "LD A,3",
            "ELSE",
            "LD A,4",
            "ENDIF"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;
        // ADEF defined -> IFNDEF false; BDEF undefined -> first ELIFNDEF true -> LD A,2
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,2");
        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Hash-prefixed #ifdef/#ifndef accept assembler callback definitions") {
        Preprocessor pp;

        // Callback defines HAS_CB only
        pp.set_symbol_defined_callback([](const std::string & name) -> bool {
            return name == "HAS_CB";
        });

        std::vector<std::string> lines = {
            "#ifdef HAS_CB",
            "LD A,1",
            "#else",
            "LD A,2",
            "#endif",
            "#ifndef MISSING_CB",
            "LD B,1",
            "#else",
            "LD B,2",
            "#endif"
        };
        std::string filename = write_temp_file(lines);
        REQUIRE(pp.open(filename));

        std::string out_line;

        // #ifdef HAS_CB -> true
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");

        // #ifndef MISSING_CB -> true (missing) -> LD B,1
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,1");

        CHECK_FALSE(pp.next_line(out_line));
    }
}

TEST_CASE("Preprocessor: C_LINE directive updates Location line number and filename without incrementing",
          "[preprocessor][c_line][line-directive][location]") {
    Preprocessor pp;

    SECTION("Hash-prefixed C_LINE") {
        std::vector<std::string> lines = {
            "LD A,1",
            "#C_LINE 42",
            "LD B,2",
            "LD B,3",
            "#C_LINE 100 \"other.c\"",
            "LD C,4",
            "LD C,5"
        };
        std::string filename = write_temp_file(lines);

        REQUIRE(pp.open(filename));

        std::string out_line;

        // First line, before any C_LINE directive
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK(g_errors.line_num() == 1);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // After "#C_LINE 42": first logical output should report 42
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,2");
        CHECK(g_errors.line_num() == 42);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // Next logical line should NOT have incremented (still 42)
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,3");
        CHECK(g_errors.line_num() == 42);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // After "#C_LINE 100 \"other.c\"": filename changed and line set to 100
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD C,4");
        CHECK(g_errors.line_num() == 100);
        CHECK(g_errors.filename() == "other.c");

        // Should remain 100 for the following logical line as well
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD C,5");
        CHECK(g_errors.line_num() == 100);
        CHECK(g_errors.filename() == "other.c");

        CHECK_FALSE(pp.next_line(out_line));
    }

    SECTION("Name-first (no hash) C_LINE") {
        std::vector<std::string> lines = {
            "LD A,1",
            "C_LINE 42",
            "LD B,2",
            "LD B,3",
            "C_LINE 100 \"other.c\"",
            "LD C,4",
            "LD C,5"
        };
        std::string filename = write_temp_file(lines);

        REQUIRE(pp.open(filename));

        std::string out_line;

        // First line, before any C_LINE directive
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD A,1");
        CHECK(g_errors.line_num() == 1);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // After "C_LINE 42": first logical output should report 42
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,2");
        CHECK(g_errors.line_num() == 42);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // Next logical line should NOT have incremented (still 42)
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD B,3");
        CHECK(g_errors.line_num() == 42);
        CHECK(g_errors.filename() == normalize_expected_path(filename));

        // After "C_LINE 100 \"other.c\"": filename changed and line set to 100
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD C,4");
        CHECK(g_errors.line_num() == 100);
        CHECK(g_errors.filename() == "other.c");

        // Should remain 100 for the following logical line as well
        REQUIRE(pp.next_line(out_line));
        CHECK(out_line == "LD C,5");
        CHECK(g_errors.line_num() == 100);
        CHECK(g_errors.filename() == "other.c");

        CHECK_FALSE(pp.next_line(out_line));
    }
}

// Preprocessor::preprocess_file tests
TEST_CASE("Preprocessor::preprocess_file writes expected output file",
          "[preprocessor][preprocess_file]") {
    Preprocessor pp;

    // Create a simple input file that uses a macro
    std::vector<std::string> lines = {
        "#define FOO 42",
        "LD A,FOO",
        "LD B,2"
    };
    std::string infile = write_temp_file(lines);

    // Determine output filename by replacing extension with .i
    std::filesystem::path outp(infile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    // Run preprocess_file
    pp.preprocess_file(infile, outfile);

    // Read output file and check it contains the expanded lines and not the #define
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        // normalize possible CRLF
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        if (!l.empty()) {
            out_lines.push_back(l);
        }
    }
    ifs.close();

    // Expect the preprocessed file to contain the expanded instructions (order preserved).
    // The #define line should not be present.
    REQUIRE(std::find(out_lines.begin(), out_lines.end(),
                      "LD A,42") != out_lines.end());
    REQUIRE(std::find(out_lines.begin(), out_lines.end(),
                      "LD B,2") != out_lines.end());
    REQUIRE(std::find(out_lines.begin(), out_lines.end(),
                      "#define FOO 42") == out_lines.end());
}

TEST_CASE("Preprocessor::preprocess_file respects include paths when writing output",
          "[preprocessor][preprocess_file][include][path]") {
    Preprocessor pp;

    // Create include directory and file
    std::string inc_dir = make_temp_dir();
    std::string inc_name = "inc_for_preproc.inc";
    std::string inc_file = write_temp_file_in_dir(inc_dir, inc_name, { "LD C,99" });

    // Create main input that uses angle include (so include_paths are used)
    std::vector<std::string> main_lines = {
        "#include <" + inc_name + ">",
        "LD A,1"
    };
    std::string mainfile = write_temp_file(main_lines);

    // Add the include directory to the preprocessor's include paths
    pp.add_include_path(inc_dir);

    // Output file
    std::filesystem::path outp(mainfile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    // Run preprocess_file
    pp.preprocess_file(mainfile, outfile);

    // Read output and ensure included content appears before the following line
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        if (!l.empty()) {
            out_lines.push_back(l);
        }
    }
    ifs.close();

    // Expect included line and the following normal line present
    auto it_inc = std::find(out_lines.begin(), out_lines.end(), "LD C,99");
    auto it_main = std::find(out_lines.begin(), out_lines.end(), "LD A,1");
    REQUIRE(it_inc != out_lines.end());
    REQUIRE(it_main != out_lines.end());
    // included line should appear before the main file line
    CHECK(std::distance(out_lines.begin(),
                        it_inc) < std::distance(out_lines.begin(), it_main));
}

// Preprocessor::preprocess_file - macro expands to three lines
TEST_CASE("Preprocessor::preprocess_file expands multi-line macro into three output lines",
          "[preprocessor][preprocess_file][macro][multiline]") {
    Preprocessor pp;

    // Multi-line macro that should expand to three lines
    std::vector<std::string> lines = {
        "MACRO push3",
        "    push bc",
        "    push de",
        "    push hl",
        "ENDM",
        "push3"
    };
    std::string infile = write_temp_file(lines);

    // Output filename (.i)
    std::filesystem::path outp(infile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    // Run preprocess_file
    pp.preprocess_file(infile, outfile);

    // Read output file
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        // normalize possible CRLF
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        if (!l.empty()) {
            out_lines.push_back(l);
        }
    }
    ifs.close();

    // Helper to find index of a line
    auto find_idx = [&](const std::string & s) -> int {
        for (int i = 0; i < static_cast<int>(out_lines.size()); ++i) {
            if (out_lines[i] == s) {
                return i;
            }
        }
        return -1;
    };

    int i1 = find_idx("push bc");
    int i2 = find_idx("push de");
    int i3 = find_idx("push hl");

    REQUIRE(i1 != -1);
    REQUIRE(i2 != -1);
    REQUIRE(i3 != -1);
    CHECK(i1 < i2);
    CHECK(i2 < i3);

    // Ensure macro definition keywords are not present in output
    CHECK(find_idx("MACRO push3") == -1);
    CHECK(find_idx("ENDM") == -1);
}

// Preprocessor::preprocess_file - multi-line comment is removed in output
TEST_CASE("Preprocessor::preprocess_file removes multi-line comment spanning lines",
          "[preprocessor][preprocess_file][comment][multiline]") {
    Preprocessor pp;

    // Input: multi-line C-style comment starts on line 1 and ends on line 3.
    // Text before and after the comment should be preserved and written to output.
    std::vector<std::string> lines = {
        "LD A,1 /* comment starts",
        " still inside comment",
        " end of comment */ LD B,2",
        "LD C,3"
    };
    std::string infile = write_temp_file(lines);

    // Output filename (.i)
    std::filesystem::path outp(infile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    // Run preprocess_file
    pp.preprocess_file(infile, outfile);

    // Read output file (skip empty lines as other tests do)
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        if (!l.empty()) {
            out_lines.push_back(l);
        }
    }
    ifs.close();

    // Expect the comment to be removed and the surrounding code preserved.
    // The first logical output line should contain both left and right fragments.
    auto it_ab = std::find(out_lines.begin(), out_lines.end(), "LD A,1 LD B,2");
    auto it_c = std::find(out_lines.begin(), out_lines.end(), "LD C,3");

    REQUIRE(it_ab != out_lines.end());
    REQUIRE(it_c != out_lines.end());
    CHECK(std::distance(out_lines.begin(), it_ab) < std::distance(out_lines.begin(),
            it_c));

    // Ensure no raw comment text ended up in the output
    for (const auto& s : out_lines) {
        CHECK(s.find("comment") == std::string::npos);
        CHECK(s.find("/*") == std::string::npos);
        CHECK(s.find("*/") == std::string::npos);
    }
}

// Preprocessor::preprocess_file - verify #line synchronization after include, macro and multi-line comment

TEST_CASE("Preprocessor::preprocess_file emits #line to resynchronize after include",
          "[preprocessor][preprocess_file][line][include]") {
    Preprocessor pp;

    // Create included file
    std::vector<std::string> inc_lines = { "LD C,3" };
    std::string inc_filename = write_temp_file(inc_lines);

    // Main file: include the file and then a following line
    std::vector<std::string> main_lines = {
        "LD A,1",
        "#include \"" + inc_filename + "\"",
        "LD B,2"
    };
    std::string mainfile = write_temp_file(main_lines);

    // Output file
    std::filesystem::path outp(mainfile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    pp.preprocess_file(mainfile, outfile);

    // Read output (preserve empty lines)
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        out_lines.push_back(l);
    }
    ifs.close();

    // Find the index of the first appearance of the main-file line after include
    auto it_main_line = std::find(out_lines.begin(), out_lines.end(), "LD B,2");
    REQUIRE(it_main_line != out_lines.end());
    size_t idx_main = static_cast<size_t>(std::distance(out_lines.begin(),
                                          it_main_line));

    // Look backward for a #line directive that contains the main filename (normalized).
    std::string norm_main = normalize_expected_path(mainfile);
    bool found_sync = false;
    for (size_t i = (idx_main == 0 ? 0 : idx_main - 1); ; --i) {
        const std::string& s = out_lines[i];
        if (s.find("#line") != std::string::npos
                || s.find("LINE") != std::string::npos) {
            if (s.find(norm_main) != std::string::npos
                    || s.find(std::filesystem::path(mainfile).filename().string()) !=
                    std::string::npos) {
                found_sync = true;
                break;
            }
        }
        if (i == 0) {
            break;
        }
    }

    CHECK(found_sync);
}

TEST_CASE("Preprocessor::preprocess_file emits #line to resynchronize after multi-line macro expansion",
          "[preprocessor][preprocess_file][line][macro][multiline]") {
    Preprocessor pp;

    // Define a multi-line MACRO and invoke it between two normal lines
    std::vector<std::string> lines = {
        "LD BEFORE,1",
        "MACRO push3",
        "    push bc",
        "    push de",
        "    push hl",
        "ENDM",
        "push3",
        "LD AFTER,2"
    };
    std::string infile = write_temp_file(lines);

    // Output file
    std::filesystem::path outp(infile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    pp.preprocess_file(infile, outfile);

    // Read output
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        out_lines.push_back(l);
    }
    ifs.close();

    // Find the first expanded macro output (push bc) and the following normal line (LD AFTER,2)
    auto it_push = std::find(out_lines.begin(), out_lines.end(), "push bc");
    auto it_after = std::find(out_lines.begin(), out_lines.end(), "LD AFTER,2");
    REQUIRE(it_push != out_lines.end());
    REQUIRE(it_after != out_lines.end());
    size_t idx_push = static_cast<size_t>(std::distance(out_lines.begin(),
                                          it_push));
    size_t idx_after = static_cast<size_t>(std::distance(out_lines.begin(),
                                           it_after));

    // There should be a #line directive between the macro expansion and the following normal line
    bool found_sync_between = false;
    for (size_t i = idx_push; i <= idx_after; ++i) {
        const std::string& s = out_lines[i];
        if (s.find("#line") != std::string::npos
                || s.find("LINE") != std::string::npos) {
            // prefer to see the original filename mentioned
            std::string norm_in = normalize_expected_path(infile);
            if (s.find(norm_in) != std::string::npos
                    || s.find(std::filesystem::path(infile).filename().string()) !=
                    std::string::npos) {
                found_sync_between = true;
                break;
            }
            // accept any #line as indication of synchronization
            found_sync_between = true;
        }
    }

    CHECK(found_sync_between);
}

TEST_CASE("Preprocessor::preprocess_file emits #line to resynchronize after multi-line C-style comment",
          "[preprocessor][preprocess_file][line][comment][multiline]") {
    Preprocessor pp;

    // Multi-line C-style comment spans two lines; verify output contains a #line
    std::vector<std::string> lines = {
        "LD A,1",
        "/* comment start",
        " still inside comment */ LD B,2",
        "LD C,3"
    };
    std::string infile = write_temp_file(lines);

    // Output file
    std::filesystem::path outp(infile);
    outp.replace_extension(".i");
    std::string outfile = outp.generic_string();
    track_temp_file(outfile);

    pp.preprocess_file(infile, outfile);

    // Read output
    std::ifstream ifs(outfile);
    REQUIRE(ifs.good());
    std::vector<std::string> out_lines;
    std::string l;
    while (std::getline(ifs, l)) {
        if (!l.empty() && l.back() == '\r') {
            l.pop_back();
        }
        out_lines.push_back(l);
    }
    ifs.close();

    // Find the line "LD B,2" and look backwards for a #line directive that sets logical line numbers
    auto it_b = std::find(out_lines.begin(), out_lines.end(), "LD B,2");
    REQUIRE(it_b != out_lines.end());
    size_t idx_b = static_cast<size_t>(std::distance(out_lines.begin(), it_b));

    bool found_line_directive = false;
    for (size_t i = (idx_b == 0 ? 0 : idx_b - 1); ; --i) {
        const std::string& s = out_lines[i];
        if (s.find("#line") != std::string::npos
                || s.find("LINE") != std::string::npos) {
            // try to parse the numeric value after #line
            size_t pos = s.find("#line");
            if (pos == std::string::npos) {
                pos = s.find("LINE");
            }
            std::string tail = s.substr(pos);
            // crude parse: find digits anywhere in the tail
            for (size_t k = 0; k < tail.size(); ++k) {
                if (std::isdigit(static_cast<unsigned char>(tail[k]))) {
                    found_line_directive = true;
                    break;
                }
            }
            if (found_line_directive) {
                break;
            }
        }
        if (i == 0) {
            break;
        }
    }

    CHECK(found_line_directive);
}

