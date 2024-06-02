//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "utils.h"
#include "t/test.h"
#include <algorithm>
#include <iostream>
#include <exception>
using namespace std;

#if __has_include(<filesystem>)
// std::filesystem from C++17
#include <filesystem>
namespace fs = std::filesystem;
#else
// boost::filesystem from Boost
#include <boost/filesystem.hpp>
namespace fs = boost::filesystem;
#endif

void test_file_norm_path() {
    IS(file_norm_path(""), "");
    IS(file_norm_path("/"), "/");
    IS(file_norm_path("//"), "/");
    IS(file_norm_path("///"), "/");
    IS(file_norm_path("\\"), "/");
    IS(file_norm_path("\\\\"), "/");
    IS(file_norm_path("\\\\\\"), "/");
    IS(file_norm_path("//a\\\\b//c"), "/a/b/c");
}

void test_file_search_path() {
    fs::create_directories("test/x");
    test_spew("test/x/test~.asm", "");
    remove("test~.asm");

    g_options().include_path().clear();
    IS(file_search_path("test~.asm", g_options().include_path()), "test~.asm");
    g_options().include_path().push_back("test/x");
    IS(file_search_path("test~.asm", g_options().include_path()), "test/x/test~.asm");

    g_options().include_path().clear();
    fs::remove_all("test");
}

void test_file_basename() {
    IS(file_basename(""), "");
    IS(file_basename("x"), "x");
    IS(file_basename("x.asm"), "x");
    IS(file_basename("x.c.asm"), "x.c");
    IS(file_basename("dir/x.asm"), "x");
    IS(file_basename("/dir/x.asm"), "x");
    IS(file_basename("\\dir\\x.asm"), "x");
    IS(file_basename("c:\\dir\\x.asm"), "x");
}

void test_file_extension() {
    IS(file_extension(""), "");
    IS(file_extension("x"), "");
    IS(file_extension("x.asm"), ".asm");
    IS(file_extension("x.c.asm"), ".asm");
    IS(file_extension("dir/x.asm"), ".asm");
    IS(file_extension("/dir/x.asm"), ".asm");
    IS(file_extension("\\dir\\x.asm"), ".asm");
    IS(file_extension("c:\\dir\\x.asm"), ".asm");
}

void test_file_replace_extension() {
    IS(file_replace_extension("", ""), "");
    IS(file_replace_extension("x", ""), "x");
    IS(file_replace_extension("x.o", ""), "x");
    IS(file_replace_extension("dir/x.o", ""), "dir/x");
    IS(file_replace_extension("/dir/x.o", ""), "/dir/x");
    IS(file_replace_extension("\\dir\\x.o", ""), "/dir/x");
    IS(file_replace_extension("c:\\dir\\x.o", ""), "c:/dir/x");

    IS(file_replace_extension("", ".asm"), ".asm");
    IS(file_replace_extension("x", ".asm"), "x.asm");
    IS(file_replace_extension("x.o", ".asm"), "x.asm");
    IS(file_replace_extension("dir/x.o", ".asm"), "dir/x.asm");
    IS(file_replace_extension("/dir/x.o", ".asm"), "/dir/x.asm");
    IS(file_replace_extension("\\dir\\x.o", ".asm"), "/dir/x.asm");
    IS(file_replace_extension("c:\\dir\\x.o", ".asm"), "c:/dir/x.asm");
}

void test_file_prepend_output_dir() {
    g_options().set_output_dir();
    IS(file_prepend_output_dir(""), "");
    IS(file_prepend_output_dir("x"), "x");
    IS(file_prepend_output_dir("x.o"), "x.o");
    IS(file_prepend_output_dir("dir/x.o"), "dir/x.o");
    IS(file_prepend_output_dir("/dir/x.o"), "/dir/x.o");
    IS(file_prepend_output_dir("\\dir\\x.o"), "/dir/x.o");
    IS(file_prepend_output_dir("c:\\dir\\x.o"), "c:/dir/x.o");

    g_options().set_output_dir("/obj");
    IS(file_prepend_output_dir(""), "/obj/");
    IS(file_prepend_output_dir("x"), "/obj/x");
    IS(file_prepend_output_dir("x.o"), "/obj/x.o");
    IS(file_prepend_output_dir("dir/x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("/dir/x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("\\dir\\x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("c:\\dir\\x.o"), "/obj/c/dir/x.o");

    // #2260: may be called with an object file already with the path prepended; do not add it twice
    IS(file_prepend_output_dir("x.o"), "/obj/x.o");
    IS(file_prepend_output_dir("/obj/x.o"), "/obj/x.o");

    g_options().set_output_dir("/obj/");
    IS(file_prepend_output_dir(""), "/obj/");
    IS(file_prepend_output_dir("x"), "/obj/x");
    IS(file_prepend_output_dir("x.o"), "/obj/x.o");
    IS(file_prepend_output_dir("dir/x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("/dir/x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("\\dir\\x.o"), "/obj/dir/x.o");
    IS(file_prepend_output_dir("c:\\dir\\x.o"), "/obj/c/dir/x.o");

    // #2260: may be called with an object file already with the path prepended; do not add it twice
    IS(file_prepend_output_dir("x.o"), "/obj/x.o");
    IS(file_prepend_output_dir("/obj/x.o"), "/obj/x.o");

    g_options().set_output_dir("c:\\obj");
    IS(file_prepend_output_dir(""), "c:/obj/");
    IS(file_prepend_output_dir("x"), "c:/obj/x");
    IS(file_prepend_output_dir("x.o"), "c:/obj/x.o");
    IS(file_prepend_output_dir("dir/x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("/dir/x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("\\dir\\x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("c:\\dir\\x.o"), "c:/obj/c/dir/x.o");

    g_options().set_output_dir("c:\\obj\\");
    IS(file_prepend_output_dir(""), "c:/obj/");
    IS(file_prepend_output_dir("x"), "c:/obj/x");
    IS(file_prepend_output_dir("x.o"), "c:/obj/x.o");
    IS(file_prepend_output_dir("dir/x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("/dir/x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("\\dir\\x.o"), "c:/obj/dir/x.o");
    IS(file_prepend_output_dir("c:\\dir\\x.o"), "c:/obj/c/dir/x.o");

    g_options().set_output_dir();
}

void test_file_parent_path() {
    IS(file_parent_path(""), ".");
    IS(file_parent_path("x"), ".");
    IS(file_parent_path("x.o"), ".");
    IS(file_parent_path("dir/x.o"), "dir");
    IS(file_parent_path("/dir/x.o"), "/dir");
    IS(file_parent_path("\\dir\\x.o"), "/dir");
    IS(file_parent_path("c:\\dir\\x.o"), "c:/dir");
}

void test_file_is_regular_file() {
    remove("test~.x");
    NOK(file_is_regular_file("test~.x"));

    fs::create_directories("test~.x");
    NOK(file_is_regular_file("test~.x"));

    fs::remove_all("test~.x");
    NOK(file_is_regular_file("test~.x"));

    test_spew("test~.x", "");
    OK(file_is_regular_file("test~.x"));

    remove("test~.x");
}

void test_file_is_directory() {
    remove("test~.x");
    NOK(file_is_directory("test~.x"));

    fs::create_directories("test~.x");
    OK(file_is_directory("test~.x"));

    fs::remove_all("test~.x");
    NOK(file_is_directory("test~.x"));

    test_spew("test~.x", "");
    NOK(file_is_directory("test~.x"));

    remove("test~.x");
}

void test_file_create_directories() {
    fs::remove_all("test~.x");
    OK(file_create_directories("test~.x"));
    OK(file_create_directories("test~.x"));
    OK(file_create_directories("test~.x/aa/bb"));
    OK(file_is_directory("test~.x/aa/bb"));
    fs::remove_all("test~.x");

    test_spew("test~.x", "");
    NOK(file_create_directories("test~.x"));
    remove("test~.x");
}

void test_file_is_object_file() {
    remove("test~.o");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_object_file("test~.o"));

    test_spew("test~.o", "");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_object_file("test~.o"));

    test_spew("test~.o", "12345678");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_object_file("test~.o"));

    test_spew("test~.o", OBJ_FILE_SIGNATURE "00" "xx");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_object_file("test~.o"));

    test_spew("test~.o", OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    OK(0 == system("perl -e 'sleep(1)'"));
    OK(file_is_object_file("test~.o"));

    remove("test~.o");
}

void test_file_is_library_file() {
    remove("test~.lib");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_library_file("test~.lib"));

    test_spew("test~.lib", "");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_library_file("test~.lib"));

    test_spew("test~.lib", "12345678");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_library_file("test~.lib"));

    test_spew("test~.lib", LIB_FILE_SIGNATURE "00" "xx");
    OK(0 == system("perl -e 'sleep(1)'"));
    NOK(file_is_library_file("test~.lib"));

    test_spew("test~.lib", LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION) "xx");
    OK(0 == system("perl -e 'sleep(1)'"));
    OK(file_is_library_file("test~.lib"));

    remove("test~.lib");
}

void test_file_current_path() {
    IS(file_current_path(), fs::current_path().generic_string());
}

void test_file_expand_glob() {
    fs::remove_all("test~");
    fs::create_directories("test~/1/a");
    fs::create_directories("test~/2/b");
    fs::create_directories("test~/3/c");
    fs::create_directories("test~/4/d");
    test_spew("test~/1/a/test1.asm", "");
    test_spew("test~/2/b/test2.asm", "");
    test_spew("test~/3/c/test3.asm", "");
    test_spew("test~/4/d/test4.asm", "");
    test_spew("test~/1/a/test1.o", "");
    test_spew("test~/2/b/test2.o", "");
    test_spew("test~/3/c/test3.o", "");
    test_spew("test~/4/d/test4.o", "");

    vector<string> files;

    files.push_back("dummy");
    file_expand_glob(files, "test~/*.asm");
    sort(files.begin(), files.end());
    IS(files.size(), 0);

    files.push_back("dummy");
    file_expand_glob(files, "test~/*/*.asm");
    sort(files.begin(), files.end());
    IS(files.size(), 0);

    files.push_back("dummy");
    file_expand_glob(files, "test~/*/*/*.asm");
    sort(files.begin(), files.end());
    IS(files.size(), 4);
    IS(files[0], "test~/1/a/test1.asm");
    IS(files[1], "test~/2/b/test2.asm");
    IS(files[2], "test~/3/c/test3.asm");
    IS(files[3], "test~/4/d/test4.asm");

    files.push_back("dummy");
    file_expand_glob(files, "test~/**/*.asm");
    sort(files.begin(), files.end());
    IS(files.size(), 4);
    IS(files[0], "test~/1/a/test1.asm");
    IS(files[1], "test~/2/b/test2.asm");
    IS(files[2], "test~/3/c/test3.asm");
    IS(files[3], "test~/4/d/test4.asm");

    files.push_back("dummy");
    file_expand_glob(files, "test~/**/*");
    sort(files.begin(), files.end());
    IS(files.size(), 16);
    IS(files[ 0], "test~/1");
    IS(files[ 1], "test~/1/a");
    IS(files[ 2], "test~/1/a/test1.asm");
    IS(files[ 3], "test~/1/a/test1.o");
    IS(files[ 4], "test~/2");
    IS(files[ 5], "test~/2/b");
    IS(files[ 6], "test~/2/b/test2.asm");
    IS(files[ 7], "test~/2/b/test2.o");
    IS(files[ 8], "test~/3");
    IS(files[ 9], "test~/3/c");
    IS(files[10], "test~/3/c/test3.asm");
    IS(files[11], "test~/3/c/test3.o");
    IS(files[12], "test~/4");
    IS(files[13], "test~/4/d");
    IS(files[14], "test~/4/d/test4.asm");
    IS(files[15], "test~/4/d/test4.o");

    fs::remove_all("test~");
}

void test_file_newer() {
    test_spew("test~1.txt", "");
    OK(0 == system("perl -e 'sleep(1)'"));
    test_spew("test~2.txt", "");

    NOK(file_newer("test~1.txt", "test~2.txt"));
    OK(file_newer("test~1.txt", "test~1.txt"));
    OK(file_newer("test~2.txt", "test~1.txt"));

    remove("test~1.txt");
    remove("test~2.txt");
}

void test_file_asm_filename() {
    IS(file_asm_filename(""), ".asm");
    IS(file_asm_filename("x"), "x.asm");
    IS(file_asm_filename("x.o"), "x.asm");
    IS(file_asm_filename("dir/x.o"), "dir/x.asm");
    IS(file_asm_filename("/dir/x.o"), "/dir/x.asm");
    IS(file_asm_filename("\\dir\\x.o"), "/dir/x.asm");
    IS(file_asm_filename("c:\\dir\\x.o"), "c:/dir/x.asm");
}

void test_file_lis_filename() {
    g_options().set_output_dir();
    IS(file_lis_filename(""), ".lis");
    IS(file_lis_filename("x"), "x.lis");
    IS(file_lis_filename("x.asm"), "x.lis");
    IS(file_lis_filename("dir/x.asm"), "dir/x.lis");
    IS(file_lis_filename("/dir/x.asm"), "/dir/x.lis");
    IS(file_lis_filename("\\dir\\x.asm"), "/dir/x.lis");
    IS(file_lis_filename("c:\\dir\\x.asm"), "c:/dir/x.lis");

    g_options().set_output_dir("/obj");
    IS(file_lis_filename(""), "/obj/.lis");
    IS(file_lis_filename("x"), "/obj/x.lis");
    IS(file_lis_filename("x.asm"), "/obj/x.lis");
    IS(file_lis_filename("dir/x.asm"), "/obj/dir/x.lis");
    IS(file_lis_filename("/dir/x.asm"), "/obj/dir/x.lis");
    IS(file_lis_filename("\\dir\\x.asm"), "/obj/dir/x.lis");
    IS(file_lis_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.lis");

    g_options().set_output_dir("c:\\obj");
    IS(file_lis_filename(""), "c:/obj/.lis");
    IS(file_lis_filename("x"), "c:/obj/x.lis");
    IS(file_lis_filename("x.asm"), "c:/obj/x.lis");
    IS(file_lis_filename("dir/x.asm"), "c:/obj/dir/x.lis");
    IS(file_lis_filename("/dir/x.asm"), "c:/obj/dir/x.lis");
    IS(file_lis_filename("\\dir\\x.asm"), "c:/obj/dir/x.lis");
    IS(file_lis_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.lis");

    g_options().set_output_dir();
}

void test_file_o_filename() {
    g_options().set_output_dir();
    IS(file_o_filename(""), ".o");
    IS(file_o_filename("x"), "x.o");
    IS(file_o_filename("x.asm"), "x.o");
    IS(file_o_filename("dir/x.asm"), "dir/x.o");
    IS(file_o_filename("/dir/x.asm"), "/dir/x.o");
    IS(file_o_filename("\\dir\\x.asm"), "/dir/x.o");
    IS(file_o_filename("c:\\dir\\x.asm"), "c:/dir/x.o");

    g_options().set_output_dir("/obj");
    IS(file_o_filename(""), "/obj/.o");
    IS(file_o_filename("x"), "/obj/x.o");
    IS(file_o_filename("x.asm"), "/obj/x.o");
    IS(file_o_filename("dir/x.asm"), "/obj/dir/x.o");
    IS(file_o_filename("/dir/x.asm"), "/obj/dir/x.o");
    IS(file_o_filename("\\dir\\x.asm"), "/obj/dir/x.o");
    IS(file_o_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.o");

    g_options().set_output_dir("c:\\obj");
    IS(file_o_filename(""), "c:/obj/.o");
    IS(file_o_filename("x"), "c:/obj/x.o");
    IS(file_o_filename("x.asm"), "c:/obj/x.o");
    IS(file_o_filename("dir/x.asm"), "c:/obj/dir/x.o");
    IS(file_o_filename("/dir/x.asm"), "c:/obj/dir/x.o");
    IS(file_o_filename("\\dir\\x.asm"), "c:/obj/dir/x.o");
    IS(file_o_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.o");

    g_options().set_output_dir();
}

void test_file_def_filename() {
    g_options().set_output_dir();
    IS(file_def_filename(""), ".def");
    IS(file_def_filename("x"), "x.def");
    IS(file_def_filename("x.asm"), "x.def");
    IS(file_def_filename("dir/x.asm"), "dir/x.def");
    IS(file_def_filename("/dir/x.asm"), "/dir/x.def");
    IS(file_def_filename("\\dir\\x.asm"), "/dir/x.def");
    IS(file_def_filename("c:\\dir\\x.asm"), "c:/dir/x.def");

    g_options().set_output_dir("/obj");
    IS(file_def_filename(""), "/obj/.def");
    IS(file_def_filename("x"), "/obj/x.def");
    IS(file_def_filename("x.asm"), "/obj/x.def");
    IS(file_def_filename("dir/x.asm"), "/obj/dir/x.def");
    IS(file_def_filename("/dir/x.asm"), "/obj/dir/x.def");
    IS(file_def_filename("\\dir\\x.asm"), "/obj/dir/x.def");
    IS(file_def_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.def");

    g_options().set_output_dir("c:\\obj");
    IS(file_def_filename(""), "c:/obj/.def");
    IS(file_def_filename("x"), "c:/obj/x.def");
    IS(file_def_filename("x.asm"), "c:/obj/x.def");
    IS(file_def_filename("dir/x.asm"), "c:/obj/dir/x.def");
    IS(file_def_filename("/dir/x.asm"), "c:/obj/dir/x.def");
    IS(file_def_filename("\\dir\\x.asm"), "c:/obj/dir/x.def");
    IS(file_def_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.def");

    g_options().set_output_dir();
}

void test_file_bin_filename() {
    // no section
    g_options().set_output_dir();
    g_options().set_bin_filename();

    IS(file_bin_filename(""), ".bin");
    IS(file_bin_filename("x"), "x.bin");
    IS(file_bin_filename("x.asm"), "x.bin");
    IS(file_bin_filename("dir/x.asm"), "dir/x.bin");
    IS(file_bin_filename("/dir/x.asm"), "/dir/x.bin");
    IS(file_bin_filename("\\dir\\x.asm"), "/dir/x.bin");
    IS(file_bin_filename("c:\\dir\\x.asm"), "c:/dir/x.bin");

    g_options().set_output_dir();
    g_options().set_bin_filename("xxx");

    IS(file_bin_filename(""), "xxx");
    IS(file_bin_filename("x"), "xxx");
    IS(file_bin_filename("x.asm"), "xxx");
    IS(file_bin_filename("dir/x.asm"), "xxx");
    IS(file_bin_filename("/dir/x.asm"), "xxx");
    IS(file_bin_filename("\\dir\\x.asm"), "xxx");
    IS(file_bin_filename("c:\\dir\\x.asm"), "xxx");

    g_options().set_output_dir();
    g_options().set_bin_filename("x.P");

    IS(file_bin_filename(""), "x.P");
    IS(file_bin_filename("x"), "x.P");
    IS(file_bin_filename("x.asm"), "x.P");
    IS(file_bin_filename("dir/x.asm"), "x.P");
    IS(file_bin_filename("/dir/x.asm"), "x.P");
    IS(file_bin_filename("\\dir\\x.asm"), "x.P");
    IS(file_bin_filename("c:\\dir\\x.asm"), "x.P");

    g_options().set_output_dir("/obj");
    g_options().set_bin_filename();

    IS(file_bin_filename(""), "/obj/.bin");
    IS(file_bin_filename("x"), "/obj/x.bin");
    IS(file_bin_filename("x.asm"), "/obj/x.bin");
    IS(file_bin_filename("dir/x.asm"), "/obj/dir/x.bin");
    IS(file_bin_filename("/dir/x.asm"), "/obj/dir/x.bin");
    IS(file_bin_filename("\\dir\\x.asm"), "/obj/dir/x.bin");
    IS(file_bin_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.bin");

    // with section
    g_options().set_output_dir();
    g_options().set_bin_filename();

    IS(file_bin_filename("", "CODE"), "_CODE.bin");
    IS(file_bin_filename("x", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("x.asm", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("dir/x.asm", "CODE"), "dir/x_CODE.bin");
    IS(file_bin_filename("/dir/x.asm", "CODE"), "/dir/x_CODE.bin");
    IS(file_bin_filename("\\dir\\x.asm", "CODE"), "/dir/x_CODE.bin");
    IS(file_bin_filename("c:\\dir\\x.asm", "CODE"), "c:/dir/x_CODE.bin");

    g_options().set_output_dir();
    g_options().set_bin_filename("xxx");

    IS(file_bin_filename("", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("x", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("x.asm", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("dir/x.asm", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("/dir/x.asm", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("\\dir\\x.asm", "CODE"), "xxx_CODE.bin");
    IS(file_bin_filename("c:\\dir\\x.asm", "CODE"), "xxx_CODE.bin");

    g_options().set_output_dir();
    g_options().set_bin_filename("x.P");

    IS(file_bin_filename("", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("x", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("x.asm", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("dir/x.asm", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("/dir/x.asm", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("\\dir\\x.asm", "CODE"), "x_CODE.bin");
    IS(file_bin_filename("c:\\dir\\x.asm", "CODE"), "x_CODE.bin");

    g_options().set_output_dir("/obj");
    g_options().set_bin_filename();

    IS(file_bin_filename("", "CODE"), "/obj/_CODE.bin");
    IS(file_bin_filename("x", "CODE"), "/obj/x_CODE.bin");
    IS(file_bin_filename("x.asm", "CODE"), "/obj/x_CODE.bin");
    IS(file_bin_filename("dir/x.asm", "CODE"), "/obj/dir/x_CODE.bin");
    IS(file_bin_filename("/dir/x.asm", "CODE"), "/obj/dir/x_CODE.bin");
    IS(file_bin_filename("\\dir\\x.asm", "CODE"), "/obj/dir/x_CODE.bin");
    IS(file_bin_filename("c:\\dir\\x.asm", "CODE"), "/obj/c/dir/x_CODE.bin");

    g_options().set_output_dir();
    g_options().set_bin_filename();
}

void test_file_lib_filename() {
    IS(file_lib_filename(""), ".lib");
    IS(file_lib_filename("x"), "x.lib");
    IS(file_lib_filename("x.o"), "x.lib");
    IS(file_lib_filename("dir/x.o"), "dir/x.lib");
    IS(file_lib_filename("/dir/x.o"), "/dir/x.lib");
    IS(file_lib_filename("\\dir\\x.o"), "/dir/x.lib");
    IS(file_lib_filename("c:\\dir\\x.o"), "c:/dir/x.lib");
}

void test_file_sym_filename() {
    g_options().set_output_dir();
    IS(file_sym_filename(""), ".sym");
    IS(file_sym_filename("x"), "x.sym");
    IS(file_sym_filename("x.asm"), "x.sym");
    IS(file_sym_filename("dir/x.asm"), "dir/x.sym");
    IS(file_sym_filename("/dir/x.asm"), "/dir/x.sym");
    IS(file_sym_filename("\\dir\\x.asm"), "/dir/x.sym");
    IS(file_sym_filename("c:\\dir\\x.asm"), "c:/dir/x.sym");

    g_options().set_output_dir("/obj");
    IS(file_sym_filename(""), "/obj/.sym");
    IS(file_sym_filename("x"), "/obj/x.sym");
    IS(file_sym_filename("x.asm"), "/obj/x.sym");
    IS(file_sym_filename("dir/x.asm"), "/obj/dir/x.sym");
    IS(file_sym_filename("/dir/x.asm"), "/obj/dir/x.sym");
    IS(file_sym_filename("\\dir\\x.asm"), "/obj/dir/x.sym");
    IS(file_sym_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.sym");

    g_options().set_output_dir("c:\\obj");
    IS(file_sym_filename(""), "c:/obj/.sym");
    IS(file_sym_filename("x"), "c:/obj/x.sym");
    IS(file_sym_filename("x.asm"), "c:/obj/x.sym");
    IS(file_sym_filename("dir/x.asm"), "c:/obj/dir/x.sym");
    IS(file_sym_filename("/dir/x.asm"), "c:/obj/dir/x.sym");
    IS(file_sym_filename("\\dir\\x.asm"), "c:/obj/dir/x.sym");
    IS(file_sym_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.sym");

    g_options().set_output_dir();
}

void test_file_map_filename() {
    g_options().set_output_dir();
    IS(file_map_filename(""), ".map");
    IS(file_map_filename("x"), "x.map");
    IS(file_map_filename("x.asm"), "x.map");
    IS(file_map_filename("dir/x.asm"), "dir/x.map");
    IS(file_map_filename("/dir/x.asm"), "/dir/x.map");
    IS(file_map_filename("\\dir\\x.asm"), "/dir/x.map");
    IS(file_map_filename("c:\\dir\\x.asm"), "c:/dir/x.map");

    g_options().set_output_dir("/obj");
    IS(file_map_filename(""), "/obj/.map");
    IS(file_map_filename("x"), "/obj/x.map");
    IS(file_map_filename("x.asm"), "/obj/x.map");
    IS(file_map_filename("dir/x.asm"), "/obj/dir/x.map");
    IS(file_map_filename("/dir/x.asm"), "/obj/dir/x.map");
    IS(file_map_filename("\\dir\\x.asm"), "/obj/dir/x.map");
    IS(file_map_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.map");

    g_options().set_output_dir("c:\\obj");
    IS(file_map_filename(""), "c:/obj/.map");
    IS(file_map_filename("x"), "c:/obj/x.map");
    IS(file_map_filename("x.asm"), "c:/obj/x.map");
    IS(file_map_filename("dir/x.asm"), "c:/obj/dir/x.map");
    IS(file_map_filename("/dir/x.asm"), "c:/obj/dir/x.map");
    IS(file_map_filename("\\dir\\x.asm"), "c:/obj/dir/x.map");
    IS(file_map_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.map");

    g_options().set_output_dir();
}

void test_file_reloc_filename() {
    g_options().set_output_dir();
    IS(file_reloc_filename(""), ".reloc");
    IS(file_reloc_filename("x"), "x.reloc");
    IS(file_reloc_filename("x.asm"), "x.reloc");
    IS(file_reloc_filename("dir/x.asm"), "dir/x.reloc");
    IS(file_reloc_filename("/dir/x.asm"), "/dir/x.reloc");
    IS(file_reloc_filename("\\dir\\x.asm"), "/dir/x.reloc");
    IS(file_reloc_filename("c:\\dir\\x.asm"), "c:/dir/x.reloc");

    g_options().set_output_dir("/obj");
    IS(file_reloc_filename(""), "/obj/.reloc");
    IS(file_reloc_filename("x"), "/obj/x.reloc");
    IS(file_reloc_filename("x.asm"), "/obj/x.reloc");
    IS(file_reloc_filename("dir/x.asm"), "/obj/dir/x.reloc");
    IS(file_reloc_filename("/dir/x.asm"), "/obj/dir/x.reloc");
    IS(file_reloc_filename("\\dir\\x.asm"), "/obj/dir/x.reloc");
    IS(file_reloc_filename("c:\\dir\\x.asm"), "/obj/c/dir/x.reloc");

    g_options().set_output_dir("c:\\obj");
    IS(file_reloc_filename(""), "c:/obj/.reloc");
    IS(file_reloc_filename("x"), "c:/obj/x.reloc");
    IS(file_reloc_filename("x.asm"), "c:/obj/x.reloc");
    IS(file_reloc_filename("dir/x.asm"), "c:/obj/dir/x.reloc");
    IS(file_reloc_filename("/dir/x.asm"), "c:/obj/dir/x.reloc");
    IS(file_reloc_filename("\\dir\\x.asm"), "c:/obj/dir/x.reloc");
    IS(file_reloc_filename("c:\\dir\\x.asm"), "c:/obj/c/dir/x.reloc");

    g_options().set_output_dir();
}

void test_safe_getline() {
    test_spew("test~.txt",
        "line1\r"
        "line2\n"
        "line3\r\n"
        "line4");
    ifstream ifs("test~.txt", ios::binary);
    string text;

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line1");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line2");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line3");

    text = "x";
    OK(!safe_getline(ifs, text).eof());
    IS(text, "line4");

    text = "x";
    NOK(!safe_getline(ifs, text).eof());
    IS(text, "");

    text = "x";
    NOK(!safe_getline(ifs, text).eof());
    IS(text, "");

    ifs.close();
    remove("test~.txt");
}

void test_open_file_non_existent() {
    ostringstream oss;
    g_options().include_path().clear();
    g_errors().set_output(oss);
    remove("test~.asm");
    {
        OpenFile of;
        NOK(of.open("test~.asm"));
        IS(oss.str(), "error: file open: test~.asm\n");
        IS(g_options().include_path().size(), 0);
    }
    IS(g_options().include_path().size(), 0);
    g_errors().clear();
}

#define T_LOCATION(fn, n, line)    \
        IS(of.location().filename(), fn);   \
        IS(of.location().line_num(), n);    \
        IS(g_errors().location().filename(), fn); \
        IS(g_errors().location().line_num(), n);  \
        IS(g_errors().source_line(), line);   \
        IS(g_errors().expanded_line(), "")

void test_open_file_ok() {
    test_spew("test~.asm",
        "hello\n"
        "world\r"
        "\r"
        "Hello\r\n"
        "World");

    g_options().include_path().clear();
    {
        OpenFile of;
        OK(of.open("test~.asm"));
        IS(g_options().include_path().size(), 0);
        IS(of.filename(), "test~.asm");
        T_LOCATION("test~.asm", 0, "");

        string line;
        OK(of.getline(line));
        IS(line, "hello");
        T_LOCATION("test~.asm", 1, "hello");

        OK(of.getline(line));
        IS(line, "world");
        T_LOCATION("test~.asm", 2, "world");

        OK(of.getline(line));
        IS(line, "");
        T_LOCATION("test~.asm", 3, "");

        OK(of.getline(line));
        IS(line, "Hello");
        T_LOCATION("test~.asm", 4, "Hello");

        OK(of.getline(line));
        IS(line, "World");
        T_LOCATION("test~.asm", 5, "World");

        NOK(of.getline(line));
        T_LOCATION("test~.asm", 5, "World");
    }
    {
        OpenFile of;
        OK(of.open("./test~.asm"));
        IS(g_options().include_path().size(), 1);
        IS(g_options().include_path()[0], ".");
        IS(of.filename(), "./test~.asm");
    }
    IS(g_options().include_path().size(), 0);
    remove("test~.asm");
    g_errors().clear();
}

#undef T_LOCATION

void test_file_reader_non_existent() {
    ostringstream oss;
    g_options().include_path().clear();
    g_errors().set_output(oss);
    remove("test~.asm");
    {
        FileReader fr;
        NOK(fr.open("test~.asm"));
        IS(oss.str(), "error: file open: test~.asm\n");
        IS(g_options().include_path().size(), 0);
    }
    IS(g_options().include_path().size(), 0);
    remove("test~.asm");
    g_errors().clear();
}

void test_file_reader_recursive() {
    ostringstream oss;
    g_options().include_path().clear();
    g_errors().set_output(oss);
    test_spew("test~.asm", "");
    {
        FileReader fr;
        OK(fr.open("test~.asm"));
        NOK(fr.open("test~.asm"));
        IS(oss.str(), "test~.asm: error: include recursion: test~.asm\n");
    }
    g_options().include_path().clear();
    remove("test~.asm");
    g_errors().clear();
}

#define T_LOCATION(fn, n, line)    \
        IS(fr.location().filename(), fn);   \
        IS(fr.location().line_num(), n);    \
        IS(g_errors().location().filename(), fn); \
        IS(g_errors().location().line_num(), n);  \
        IS(g_errors().source_line(), line);   \
        IS(g_errors().expanded_line(), "")

void test_file_reader_ok() {
    fs::create_directories("test/x");
    test_spew("test1.asm",
        "hello\n"
        "world\n");
    test_spew("test/x/test2.asm",
        "Hello\n"
        "World\n");
    g_options().include_path().clear();
    g_options().include_path().push_back("test/x");

    {
        FileReader fr;
        OK(fr.open("test1.asm"));
        T_LOCATION("test1.asm", 0, "");

        string line;
        OK(fr.getline(line));
        IS(line, "hello");
        T_LOCATION("test1.asm", 1, "hello");

        OK(fr.open("test2.asm"));
        T_LOCATION("test/x/test2.asm", 0, "");

        OK(fr.getline(line));
        IS(line, "Hello");
        T_LOCATION("test/x/test2.asm", 1, "Hello");

        OK(fr.getline(line));
        IS(line, "World");
        T_LOCATION("test/x/test2.asm", 2, "World");

        OK(fr.getline(line));
        IS(line, "world");
        T_LOCATION("test1.asm", 2, "world");

        NOK(fr.getline(line));
        T_LOCATION("", 0, "");
    }

    fs::remove_all("test");
    remove("test1.asm");
    g_options().include_path().clear();
    g_errors().clear();
}

#undef T_LOCATION

#define T_LOCATION(fn, n, line)    \
        IS(sr.location().filename(), fn);   \
        IS(sr.location().line_num(), n);    \
        IS(g_errors().location().filename(), fn); \
        IS(g_errors().location().line_num(), n);  \
        IS(g_errors().source_line(), line);   \
        IS(g_errors().expanded_line(), "")

void test_source_reader_ok() {
    test_spew("test~.asm",
        "hello\\\n"
        "world\\");
    {
        SourceReader sr;
        OK(sr.open("test~.asm"));
        T_LOCATION("test~.asm", 0, "");

        string line;
        OK(sr.getline(line));
        IS(line, "hello world ");
        T_LOCATION("test~.asm", 2, "hello world ");

        NOK(sr.getline(line));
        T_LOCATION("", 0, "");
    }
    remove("test~.asm");
    g_errors().clear();
}

#undef T_LOCATION
