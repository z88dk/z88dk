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

TEST_CASE("get_asm_filename and get_i_filename replace extensions",
          "[options][replace_extension]") {
    g_options = Options();

    // simple cases
    CHECK(g_options.get_asm_filename("foo.o") ==
          fs::path("foo.o").replace_extension(".asm").generic_string());
    CHECK(g_options.get_i_filename("bar.asm") ==
          fs::path("bar.asm").replace_extension(".i").generic_string());

    // filenames without extension -> .asm/.i appended
    CHECK(g_options.get_asm_filename("baz") ==
          fs::path("baz").replace_extension(".asm").generic_string());
    CHECK(g_options.get_i_filename("qux") ==
          fs::path("qux").replace_extension(".i").generic_string());
}

TEST_CASE("get_o_filename prepends output_dir and avoids double-prepend",
          "[options][output_dir][get_o_filename]") {
    // reset global options
    g_options = Options();

    // set output directory
    g_options.output_dir = "outdir";

    // relative asm filename
    std::string input = "src/hello.asm";
    fs::path expected = fs::path("outdir") /
                        fs::path("src/hello.o");
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

TEST_CASE("get_i_filename returns filename with .i extension",
          "[options][get_i_filename]") {
    g_options = Options();

    CHECK(g_options.get_i_filename("foo.asm") ==
          fs::path("foo.asm").replace_extension(".i").generic_string());
    CHECK(g_options.get_i_filename("bar") ==
          fs::path("bar").replace_extension(".i").generic_string());
}

TEST_CASE("parse_arg sets preprocess_only when -E is provided",
          "[options][parse_arg][preprocess_only]") {
    g_options = Options();

    REQUIRE(g_options.parse_arg("-E"));
    CHECK(g_options.preprocess_only);
    g_options = Options(); // reset side effects
}

TEST_CASE("parse_arg sets gen_dependencies when -MD is provided",
          "[options][parse_arg][gen_dependencies]") {
    g_options = Options();

    REQUIRE(g_options.parse_arg("-MD"));
    CHECK(g_options.gen_dependencies);
    g_options = Options(); // reset side effects
}

TEST_CASE("parse_arg sets verbose when -v is provided",
          "[options][parse_arg][verbose]") {
    g_options = Options();

    REQUIRE(g_options.parse_arg("-v"));
    CHECK(g_options.verbose);
    g_options = Options(); // reset side effects
}

TEST_CASE("parse_arg returns false for invalid options",
          "[options][parse_arg][invalid_option]") {
    g_options = Options();

    REQUIRE_FALSE(g_options.parse_arg("-invalid"));
    REQUIRE_FALSE(g_options.parse_arg("-cpp")); // missing argument
    REQUIRE_FALSE(g_options.parse_arg("-m4"));  // missing argument
    REQUIRE_FALSE(g_options.parse_arg("-perl")); // missing argument
    REQUIRE_FALSE(g_options.parse_arg("-I"));    // missing argument
    g_options = Options(); // reset side effects
}

TEST_CASE("parse_arg collects include paths from -Ipath and -I=path",
          "[options][parse_arg][include_paths]") {
    g_options = Options();

    REQUIRE(g_options.parse_arg("-Ifoo"));
    REQUIRE(g_options.parse_arg("-I=bar/baz"));

    REQUIRE(g_options.include_paths.size() == 2);
    CHECK(g_options.include_paths[0] == "foo");
    CHECK(g_options.include_paths[1] == "bar/baz");

    g_options = Options();
}

TEST_CASE("parse_arg evaluates -f expression and assigns filler_byte when in range",
          "[options][parse_arg][filler_byte][expr]") {
    g_options = Options();

    // Expression 0x10 + 5 = 0x15 (21)
    REQUIRE(g_options.parse_arg("-f=0x10+5"));
    CHECK(g_options.filler_byte == static_cast<uint8_t>(0x15));

    g_options = Options(); // reset side effects
}
