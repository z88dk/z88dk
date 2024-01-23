//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void test_file_reader1() {
    fs::create_directories("t1");
    test_file_spew("f1.asm",
        "line 1\r"
        "line 2\n"
        "line 3\r\n"
        "line 4");
    test_file_spew("t1/f2.asm",
        "LINE\\\n1\r"
        "LINE 2\\");
    g_args.opt_include_path.push_back("t1");
    {
        FileReader fr;
        string line;

        NOK(fr.is_open());
        STR_IS(fr.get_location().filename, "");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        NOK(fr.is_open());
        STR_IS(fr.get_location().filename, "");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        NOK(fr.getline(line));
        STR_IS(line, "");
        NOK(fr.is_pushed_back());

        NOK(fr.is_open());
        STR_IS(fr.get_location().filename, "");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        OK(fr.open("f1.asm"));

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "line 1");
        NOK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 1);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        fr.get_location().is_c_source = true;

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "line 2");
        NOK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 1);
        IS(fr.get_location().line_inc, 1);
        OK(fr.get_location().is_c_source);

        OK(fr.open("f2.asm"));

        fr.get_location().is_c_source = false;
        fr.get_location().line_inc = 2;

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "t1/f2.asm");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 2);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "LINE 1");
        NOK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "t1/f2.asm");
        IS(fr.get_location().line_num, 4);
        IS(fr.get_location().line_inc, 2);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "LINE 2");
        NOK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "t1/f2.asm");
        IS(fr.get_location().line_num, 6);
        IS(fr.get_location().line_inc, 2);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "line 3");
        NOK(fr.is_pushed_back());

        fr.get_location().is_c_source = false;
        fr.get_location().line_inc = 1;
    
        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 1);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        fr.push_back("Line 3.2");
        fr.push_back("Line 3.1");

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "Line 3.1");
        OK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 1);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "Line 3.2");
        OK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 1);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        OK(fr.getline(line));
        STR_IS(line, "line 4");
        NOK(fr.is_pushed_back());

        OK(fr.is_open());
        STR_IS(fr.get_location().filename, "f1.asm");
        IS(fr.get_location().line_num, 2);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);

        line = "xxxxx";
        NOK(fr.getline(line));
        STR_IS(line, "");
        NOK(fr.is_pushed_back());

        NOK(fr.is_open());
        STR_IS(fr.get_location().filename, "");
        IS(fr.get_location().line_num, 0);
        IS(fr.get_location().line_inc, 1);
        NOK(fr.get_location().is_c_source);
    }
    g_args.opt_include_path.pop_back();
    OK(0 == remove("f1.asm"));
    OK(0 == remove("t1/f2.asm"));
    fs::remove_all("t1");
}

void test_file_reader2() {
    test_file_spew("f1.asm", "");
    test_file_spew("f2.asm", "");

    RUN_OK("exec_file_reader2");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "f2.asm: error: include recursion: f1.asm\n");

    OK(0 == remove("f1.asm"));
    OK(0 == remove("f2.asm"));
}

int exec_file_reader2() {
    FileReader fr;
    xassert(fr.open("f1.asm"));
    xassert(fr.open("f2.asm"));
    xassert(!fr.open("f1.asm"));
    return EXIT_SUCCESS;
}

void test_file_reader3() {
    remove("f1.asm");

    RUN_OK("exec_file_reader3");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err,
        "error: file open: f1.asm\n"
        "f1.asm: No such file or directory\n");

    remove("f1.asm");
}

int exec_file_reader3() {
    FileReader fr;
    xassert(!fr.open("f1.asm"));
    return EXIT_SUCCESS;
}
