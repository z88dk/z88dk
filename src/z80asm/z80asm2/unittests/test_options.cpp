//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../options.h"
#include "../utils.h"
#include "catch_amalgamated.hpp"
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace fs = std::filesystem;

// Small helper to write a file with given contents.
static std::string write_text_file(const std::filesystem::path& path,
                                   const std::string& contents = "") {
    std::ofstream ofs(path.generic_string(), std::ios::binary);
    ofs << contents;
    ofs.close();
    return path.generic_string();
}

static void write_file(const fs::path& p, const char* txt) {
    fs::create_directories(p.parent_path());
    std::ofstream ofs(p, std::ios::binary);
    REQUIRE(ofs.is_open());
    ofs << txt;
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

// Global capture for this translation unit to prevent tests from printing to the console.
static CerrRedirect g_cerr_silencer;

TEST_CASE("get_asm_filename and get_i_filename replace extensions",
          "[options][replace_extension]") {
    g_options = Options();

    // simple cases
    CHECK(g_options.get_asm_filename("foo.o") ==
          std::filesystem::path("foo.o").replace_extension(".asm").generic_string());
    CHECK(g_options.get_i_filename("bar.asm") ==
          std::filesystem::path("bar.asm").replace_extension(".i").generic_string());

    // filenames without extension -> .asm/.i appended
    CHECK(g_options.get_asm_filename("baz") ==
          std::filesystem::path("baz").replace_extension(".asm").generic_string());
    CHECK(g_options.get_i_filename("qux") ==
          std::filesystem::path("qux").replace_extension(".i").generic_string());
}

TEST_CASE("get_o_filename prepends output_dir and avoids double-prepend",
          "[options][output_dir][get_o_filename]") {
    // reset global options
    g_options = Options();

    // set output directory
    g_options.output_dir = "outdir";

    // relative asm filename
    std::string input = "src/hello.asm";
    std::filesystem::path expected = std::filesystem::path("outdir") /
                                     std::filesystem::path("src/hello.o");
    CHECK(g_options.get_o_filename(input) ==
          expected.lexically_normal().generic_string());

    // if the filename already has output_dir prefix, it must be returned unchanged
    std::string already = expected.generic_string();
    CHECK(g_options.get_o_filename(already) == already);

    // Windows-style drive-letter input should be handled (code path exercised even on POSIX)
    g_options.output_dir = "build";
    std::string win_input = "C:folder/file.asm";
    std::string win_out = g_options.get_o_filename(win_input);
    // It should start with build/ and contain "C"
    CHECK(win_out.find("build/") != std::string::npos);
    CHECK(win_out.find("C") != std::string::npos);
}

TEST_CASE("search_source_file finds files in include_paths and returns normalized path",
          "[options][search_source_file][include_paths]") {
    // reset global state
    g_options = Options();
    g_errors.reset();

    // create include directory and file
    std::filesystem::path inc_dir = std::filesystem::temp_directory_path() /
                                    "z80asm_test_inc";
    std::filesystem::remove_all(inc_dir);
    std::filesystem::create_directories(inc_dir);
    std::string inc_name = "common.inc";
    std::filesystem::path inc_file = inc_dir / inc_name;
    write_text_file(inc_file, "LD A,1");

    // add include path and search
    g_options.include_paths.clear();
    g_options.include_paths.push_back(inc_dir.generic_string());

    g_options.search_source_file(inc_name);
    REQUIRE(g_options.input_files.size() == 1);

    // result should be the absolute lexically-normal path to the file we created
    std::string expected = inc_file.lexically_normal().generic_string();
    CHECK(g_options.input_files.front() == expected);

    // cleanup
    std::filesystem::remove_all(inc_dir);
}

TEST_CASE("search_source_file reports FileNotFound when file missing",
          "[options][search_source_file][error]") {
    // reset global state
    g_options = Options();
    g_errors.reset();

    // choose a filename that (very likely) doesn't exist
    std::string missing = "this_file_should_not_exist_12345.inc";

    // ensure file absent
    std::filesystem::remove(missing);

    g_options.search_source_file(missing);
    CHECK(g_options.input_files.empty());
    std::string msg = g_errors.last_error_message();
    CHECK(msg.find("File not found: " + missing) != std::string::npos);
    CHECK(g_errors.has_errors());
}

TEST_CASE("is_asm_filename and is_o_filename detect extensions",
          "[options][is_filename]") {
    g_options = Options();

    CHECK(g_options.is_asm_filename("foo.asm"));
    CHECK_FALSE(g_options.is_asm_filename("foo.o"));
    CHECK_FALSE(g_options.is_asm_filename("foo"));

    CHECK(g_options.is_o_filename("foo.o"));
    CHECK_FALSE(g_options.is_o_filename("foo.asm"));
    CHECK_FALSE(g_options.is_o_filename("foo"));
}

TEST_CASE("resolve_include_candidate picks absolute path directly",
          "[options][resolve_include_candidate][absolute]") {
    g_options = Options();

    // create a temporary file with an absolute path
    auto tmp = std::filesystem::temp_directory_path() / ("z80asm_opts_abs_" +
               std::to_string(std::rand()) + ".inc");
    std::string abs_path = write_text_file(tmp, "LD A,1");
    // resolve should return the normalized absolute path when given an absolute path
    std::string resolved = g_options.resolve_include_candidate(abs_path, "", false);
    REQUIRE_FALSE(resolved.empty());
    CHECK(std::filesystem::absolute(tmp).lexically_normal().generic_string() ==
          resolved);

    // cleanup
    std::filesystem::remove(tmp);
}

TEST_CASE("resolve_include_candidate honors include_paths order for angle includes",
          "[options][resolve_include_candidate][include_paths][angle]") {
    // reset global state
    g_options = Options();
    g_errors.reset();

    auto base = std::filesystem::temp_directory_path();
    auto inc1 = base / ("z80asm_inc1_" + std::to_string(std::rand()));
    auto inc2 = base / ("z80asm_inc2_" + std::to_string(std::rand()));
    std::filesystem::create_directories(inc1);
    std::filesystem::create_directories(inc2);

    std::string name = "shared.inc";
    write_text_file(inc1 / name, "LD C,DIR1");
    write_text_file(inc2 / name, "LD C,DIR2");

    // Add include paths in order: inc2 first, then inc1.
    g_options.include_paths.clear();
    g_options.include_paths.push_back(inc2.generic_string());
    g_options.include_paths.push_back(inc1.generic_string());

    // Angle include: should search include_paths in order and pick inc2
    std::string resolved = g_options.resolve_include_candidate(name, "", true);
    REQUIRE_FALSE(resolved.empty());
    CHECK(resolved == std::filesystem::absolute(inc2 /
            name).lexically_normal().generic_string());

    // cleanup
    std::filesystem::remove_all(inc1);
    std::filesystem::remove_all(inc2);
}

TEST_CASE("search_source_file respects -d (date_stamp) behavior for .asm/.o pair",
          "[options][search_source_file][date_stamp]") {
    // reset global state
    g_options = Options();
    g_errors.reset();

    auto tmpdir = std::filesystem::temp_directory_path() / ("z80asm_opts_date_" +
                  std::to_string(std::rand()));
    std::filesystem::remove_all(tmpdir);
    std::filesystem::create_directories(tmpdir);

    std::string base = (tmpdir / "modtest").generic_string();
    std::filesystem::path asm_path = tmpdir / "modtest.asm";
    std::filesystem::path o_path = tmpdir / "modtest.o";

    // create both files
    write_text_file(asm_path, "asm");
    write_text_file(o_path, "obj");

    // Ensure two distinct timestamps: make .o newer than .asm
    auto now = std::filesystem::file_time_type::clock::now();
    std::filesystem::last_write_time(asm_path, now - std::chrono::seconds(10));
    std::filesystem::last_write_time(o_path, now);

    // Case 1: date_stamp == false -> prefer .asm when calling search_source_file("modtest")
    g_options.date_stamp = false;
    g_options.search_source_file(base);
    REQUIRE(g_options.input_files.size() == 1);
    CHECK(g_options.input_files.front() == std::filesystem::absolute(
              asm_path).lexically_normal().generic_string());

    // Case 2: date_stamp == true and .o is newer -> should return .o
    g_options.date_stamp = true;
    g_options.input_files.clear();
    g_options.search_source_file(base);
    REQUIRE(g_options.input_files.size() == 1);
    CHECK(g_options.input_files.front() == std::filesystem::absolute(
              o_path).lexically_normal().generic_string());

    // cleanup
    std::filesystem::remove_all(tmpdir);
}

TEST_CASE("get_i_filename returns filename with .i extension",
          "[options][get_i_filename]") {
    g_options = Options();

    CHECK(g_options.get_i_filename("foo.asm") ==
          std::filesystem::path("foo.asm").replace_extension(".i").generic_string());
    CHECK(g_options.get_i_filename("bar") ==
          std::filesystem::path("bar").replace_extension(".i").generic_string());
}

//-----------------------------------------------------------------------------
// options wildcard unit tests (simple '*' and '?' patterns)
//-----------------------------------------------------------------------------

TEST_CASE("search_source_file: '*' matches multiple files in one directory",
          "[options][wildcards][star]") {
    g_options = Options();
    g_errors.reset();

    // Create a temp dir with three asm files.
    fs::path base = fs::path("wild_star_test");
    fs::remove_all(base);
    fs::create_directories(base);

    write_file(base / "a1.asm", "nop\n");
    write_file(base / "a2.asm", "nop\n");
    write_file(base / "bX.asm", "nop\n");

    // Pattern: *.asm
    g_options.search_source_file((base.string() + "/*.asm"));

    // Expect i files for each asm, same directory
    REQUIRE(g_options.input_files.size() == 3);
    // Normalize to paths for stable checks
    std::sort(g_options.input_files.begin(), g_options.input_files.end());
    REQUIRE(g_options.input_files[0] == normalize_path((base /
            "a1.asm").generic_string()));
    REQUIRE(g_options.input_files[1] == normalize_path((base /
            "a2.asm").generic_string()));
    REQUIRE(g_options.input_files[2] == normalize_path((base /
            "bX.asm").generic_string()));

    fs::remove_all(base);
}

TEST_CASE("search_source_file: '?' matches a single character",
          "[options][wildcards][question]") {
    g_options = Options();
    g_errors.reset();

    fs::path base = fs::path("wild_qmark_test");
    fs::remove_all(base);
    fs::create_directories(base);

    write_file(base / "bX.asm", "nop\n");
    write_file(base / "bY.asm", "nop\n");
    write_file(base / "bb.asm", "nop\n"); // should not match 'b?.asm'

    // Pattern: b?.asm
    g_options.search_source_file((base.string() + "/b?.asm"));

    // Expect two i files for bX.asm and bY.asm
    std::sort(g_options.input_files.begin(), g_options.input_files.end());
    REQUIRE(g_options.input_files.size() == 3);
    REQUIRE(g_options.input_files[0] == normalize_path((base /
            "bX.asm").generic_string()));
    REQUIRE(g_options.input_files[1] == normalize_path((base /
            "bY.asm").generic_string()));
    REQUIRE(g_options.input_files[2] == normalize_path((base /
            "bb.asm").generic_string()));

    fs::remove_all(base);
}

TEST_CASE("search_source_file: '**' matches specific subdirectory file",
          "[options][wildcards][recursive][double_star]") {
    g_options = Options();
    g_errors.reset();

    fs::path base = fs::path("wild_recursive_test");
    fs::remove_all(base);
    fs::create_directories(base / "sub1" / "deeper");
    fs::create_directories(base / "sub2");

    write_file(base / "a.asm", "nop\n");
    write_file(base / "sub1" / "b.asm", "nop\n");
    write_file(base / "sub1" / "deeper" / "c.asm", "nop\n");
    write_file(base / "sub2" / "d.asm", "nop\n");

    // Pattern: base/**/b.asm (should match only sub1/b.asm)
    g_options.search_source_file((base.string() + "/**/b.asm"));
    REQUIRE(g_options.input_files.size() == 1);
    REQUIRE(g_options.input_files[0] == normalize_path((base / "sub1" /
            "b.asm").generic_string()));

    // Pattern: base/**/deeper/c.asm (should match only deeper/c.asm)
    g_options.input_files.clear();
    g_options.search_source_file((base.string() + "/**/deeper/c.asm"));
    REQUIRE(g_options.input_files.size() == 1);
    REQUIRE(g_options.input_files[0] == normalize_path((base / "sub1" / "deeper" /
            "c.asm").generic_string()));

    // Pattern: base/**/*.asm (should match all four .asm files)
    g_options.input_files.clear();
    g_options.search_source_file((base.string() + "/**/*.asm"));
    std::sort(g_options.input_files.begin(), g_options.input_files.end());
    REQUIRE(g_options.input_files.size() == 4);
    REQUIRE(g_options.input_files[0] == normalize_path((base /
            "a.asm").generic_string()));
    REQUIRE(g_options.input_files[1] == normalize_path((base / "sub1" /
            "b.asm").generic_string()));
    REQUIRE(g_options.input_files[2] == normalize_path((base / "sub1" / "deeper" /
            "c.asm").generic_string()));
    REQUIRE(g_options.input_files[3] == normalize_path((base / "sub2" /
            "d.asm").generic_string()));

    // Pattern: base/**/nonexistent.asm (no matches -> error)
    g_errors.reset();
    g_options.input_files.clear();
    g_options.search_source_file((base.string() + "/**/nonexistent.asm"));
    REQUIRE(g_options.input_files.empty());
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("File not found") !=
            std::string::npos);

    fs::remove_all(base);
}

TEST_CASE("search_source_file: '**/*.asm' collects all .asm files in nested subdirectories",
          "[options][wildcards][recursive][double_star_collect]") {
    g_options = Options();
    g_errors.reset();

    fs::path base = fs::path("wild_collect_test");
    fs::remove_all(base);
    fs::create_directories(base / "lvl1");
    fs::create_directories(base / "lvl1" / "lvl2");
    fs::create_directories(base / "lvl1b");
    fs::create_directories(base / "lvlX" / "lvlY" / "lvlZ");

    // Create .asm files at various depths
    write_file(base / "root.asm", "nop\n");
    write_file(base / "lvl1" / "one.asm", "nop\n");
    write_file(base / "lvl1" / "lvl2" / "two.asm", "nop\n");
    write_file(base / "lvl1b" / "other.asm", "nop\n");
    write_file(base / "lvlX" / "lvlY" / "lvlZ" / "deep.asm", "nop\n");

    // Non-matching file (different extension) to ensure it is skipped
    write_file(base / "skip.txt", "nop\n");

    // Pattern: base/**/*.asm
    g_options.search_source_file((base.string() + "/**/*.asm"));

    // Expect all five .asm files
    std::sort(g_options.input_files.begin(), g_options.input_files.end());
    REQUIRE(g_options.input_files.size() == 5);
    REQUIRE((g_options.input_files[0] == normalize_path((base / "lvl1" / "lvl2" /
             "two.asm").generic_string()) ||
             g_options.input_files[0] == normalize_path((base / "lvl1" /
                     "one.asm").generic_string()) ||
             g_options.input_files[0] == normalize_path((base / "lvl1b" /
                     "other.asm").generic_string()) ||
             g_options.input_files[0] == normalize_path((base / "lvlX" / "lvlY" / "lvlZ" /
                     "deep.asm").generic_string()) ||
             g_options.input_files[0] == normalize_path((base /
                     "root.asm").generic_string())));
    // Use set comparison for clarity
    std::set<std::string> expected = {
        normalize_path((base / "root.asm").generic_string()),
        normalize_path((base / "lvl1" / "one.asm").generic_string()),
        normalize_path((base / "lvl1" / "lvl2" / "two.asm").generic_string()),
        normalize_path((base / "lvl1b" / "other.asm").generic_string()),
        normalize_path((base / "lvlX" / "lvlY" / "lvlZ" / "deep.asm").generic_string())
    };
    std::set<std::string> actual(g_options.input_files.begin(),
                                 g_options.input_files.end());
    REQUIRE(actual == expected);

    fs::remove_all(base);
}
