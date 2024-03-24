//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "t/test.h"
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

void test_search_path() {
    fs::create_directories("test/x");
    test_spew("test/x/test.asm", "");
    remove("test.asm");

    g_include_path.clear();
    IS(search_path("test.asm", g_include_path), "test.asm");
    g_include_path.push_back("test/x");
    IS(search_path("test.asm", g_include_path), "test/x/test.asm");

    g_include_path.clear();
    fs::remove_all("test");
}

void test_open_file_non_existent() {
    ostringstream oss;
    g_include_path.clear();
    g_errors.set_output(oss);
    remove("test.asm");
    {
        OpenFile of;
        NOK(of.open("test.asm"));
        IS(oss.str(), "error: file open: test.asm\n");
        IS(g_include_path.size(), 0);
    }
    IS(g_include_path.size(), 0);
}

#define T_LOCATION(fn, n, line)    \
        IS(of.location().filename(), fn);   \
        IS(of.location().line_num(), n);    \
        IS(g_errors.location().filename(), fn); \
        IS(g_errors.location().line_num(), n);  \
        IS(g_errors.source_line(), line);   \
        IS(g_errors.expanded_line(), "")

void test_open_file_ok() {
    test_spew("test.asm",
        "hello\n"
        "world\r"
        "\r"
        "Hello\r\n"
        "World");

    g_include_path.clear();
    {
        OpenFile of;
        OK(of.open("test.asm"));
        IS(g_include_path.size(), 0);
        IS(of.filename(), "test.asm");
        T_LOCATION("test.asm", 0, "");

        string line;
        OK(of.getline(line));
        IS(line, "hello");
        T_LOCATION("test.asm", 1, "hello");

        OK(of.getline(line));
        IS(line, "world");
        T_LOCATION("test.asm", 2, "world");

        OK(of.getline(line));
        IS(line, "");
        T_LOCATION("test.asm", 3, "");

        OK(of.getline(line));
        IS(line, "Hello");
        T_LOCATION("test.asm", 4, "Hello");

        OK(of.getline(line));
        IS(line, "World");
        T_LOCATION("test.asm", 5, "World");

        NOK(of.getline(line));
        T_LOCATION("test.asm", 5, "World");
    }
    {
        OpenFile of;
        OK(of.open("./test.asm"));
        IS(g_include_path.size(), 1);
        IS(g_include_path[0], ".");
        IS(of.filename(), "./test.asm");
    }
    IS(g_include_path.size(), 0);
    g_errors.clear_location();
    remove("test.asm");
}

#undef T_LOCATION

void test_file_reader_non_existent() {
    ostringstream oss;
    g_include_path.clear();
    g_errors.set_output(oss);
    remove("test.asm");
    {
        FileReader fr;
        NOK(fr.open("test.asm"));
        IS(oss.str(), "error: file open: test.asm\n");
        IS(g_include_path.size(), 0);
    }
    IS(g_include_path.size(), 0);
    g_errors.clear_location();
    remove("test.asm");
}

void test_file_reader_recursive() {
    ostringstream oss;
    g_include_path.clear();
    g_errors.set_output(oss);
    test_spew("test.asm", "");
    {
        FileReader fr;
        OK(fr.open("test.asm"));
        NOK(fr.open("test.asm"));
        IS(oss.str(), "test.asm: error: include recursion: test.asm\n");
    }
    g_include_path.clear();
    g_errors.clear_location();
    remove("test.asm");
}

#define T_LOCATION(fn, n, line)    \
        IS(fr.location().filename(), fn);   \
        IS(fr.location().line_num(), n);    \
        IS(g_errors.location().filename(), fn); \
        IS(g_errors.location().line_num(), n);  \
        IS(g_errors.source_line(), line);   \
        IS(g_errors.expanded_line(), "")

void test_file_reader_ok() {
    fs::create_directories("test/x");
    test_spew("test1.asm",
        "hello\n"
        "world\n");
    test_spew("test/x/test2.asm",
        "Hello\n"
        "World\n");
    g_include_path.clear();
    g_include_path.push_back("test/x");

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
    g_include_path.clear();
    g_errors.clear_location();
}

#undef T_LOCATION

#define T_LOCATION(fn, n, line)    \
        IS(sr.location().filename(), fn);   \
        IS(sr.location().line_num(), n);    \
        IS(g_errors.location().filename(), fn); \
        IS(g_errors.location().line_num(), n);  \
        IS(g_errors.source_line(), line);   \
        IS(g_errors.expanded_line(), "")

void test_source_reader_ok() {
    test_spew("test.asm",
        "hello\\\n"
        "world\\");
    {
        SourceReader sr;
        OK(sr.open("test.asm"));
        T_LOCATION("test.asm", 0, "");

        string line;
        OK(sr.getline(line));
        IS(line, "hello world ");
        T_LOCATION("test.asm", 2, "hello world ");

        NOK(sr.getline(line));
        T_LOCATION("", 0, "");
    }
    remove("test.asm");
    g_errors.clear_location();
}

#undef T_LOCATION
