//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../options.h"
#include "catch_amalgamated.hpp"
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>
#include <cstdio>

// Small helper to write a file with given contents.
static std::string write_text_file(const std::filesystem::path& path,
                                   const std::string& contents = "") {
    std::ofstream ofs(path.generic_string(), std::ios::binary);
    ofs << contents;
    ofs.close();
    return path.generic_string();
}

TEST_CASE("get_asm_filename and get_i_filename replace extensions",
          "[options][replace_extension]") {
    // simple cases
    CHECK(get_asm_filename("foo.o") ==
          std::filesystem::path("foo.o").replace_extension(".asm").generic_string());
    CHECK(get_i_filename("bar.asm") ==
          std::filesystem::path("bar.asm").replace_extension(".i").generic_string());

    // filenames without extension -> .asm/.i appended
    CHECK(get_asm_filename("baz") ==
          std::filesystem::path("baz").replace_extension(".asm").generic_string());
    CHECK(get_i_filename("qux") ==
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
    CHECK(get_o_filename(input) == expected.lexically_normal().generic_string());

    // if the filename already has output_dir prefix, it must be returned unchanged
    std::string already = expected.generic_string();
    CHECK(get_o_filename(already) == already);

    // Windows-style drive-letter input should be handled (code path exercised even on POSIX)
    g_options.output_dir = "build";
    std::string win_input = "C:folder/file.asm";
    std::string win_out = get_o_filename(win_input);
    // It should start with build/ and contain "C"
    CHECK(win_out.find("build/") != std::string::npos);
    CHECK(win_out.find("C") != std::string::npos);
}

TEST_CASE("normalize_path returns absolute lexically-normal path and parent_dir returns parent",
          "[options][normalize_path][parent_dir]") {
    // create nested temp directory and file
    std::filesystem::path tmpdir = std::filesystem::temp_directory_path() /
                                   "z80asm_test_opts_tmp";
    std::filesystem::remove_all(tmpdir);
    std::filesystem::create_directories(tmpdir / "sub");
    std::filesystem::path file = tmpdir / "sub" / "file.asm";
    write_text_file(file, "dummy");

    // normalize_path should return an absolute lexically_normal generic string
    std::string norm = normalize_path(file.generic_string());
    std::string expected = file.lexically_normal().generic_string();
    CHECK(norm == expected);

    // parent_dir should return the parent directory (absolute)
    std::string parent = parent_dir(file.generic_string());
    std::string expected_parent = file.parent_path().generic_string();
    CHECK(parent == expected_parent);

    // cleanup
    std::filesystem::remove_all(tmpdir);
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

    std::string result = search_source_file(inc_name);
    REQUIRE_FALSE(result.empty());

    // result should be the absolute lexically-normal path to the file we created
    std::string expected = inc_file.lexically_normal().generic_string();
    CHECK(result == expected);

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

    std::string result = search_source_file(missing);
    CHECK(result.empty());
    CHECK(g_errors.has_errors());
}
