//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

static void remove_f1() {
    remove("f1.asm");
    remove("f1.o");
}

static void make_f1_asm() {
    test_file_spew("f1.asm", "nop");
    xassert(0 == system("sleep 1"));
}

static void make_f1_o_ok() {
    byte_t obj[40] = { 0 };
    memcpy(obj, "Z80RMF18", 8);
    obj[8] = '\1';
    test_file_write("f1.o", obj, sizeof(obj));
    xassert(0 == system("sleep 1"));
}

static void make_f1_o_nok() {
    byte_t obj[40] = { 0 };
    memcpy(obj, "Z80RMF18", 8);
    obj[8] = '\0';
    test_file_write("f1.o", obj, sizeof(obj));
    xassert(0 == system("sleep 1"));
}

void test_object() {
    // **** without -d
    // only asm
    remove_f1();
    make_f1_asm();
    RUN_OK("exec_object", "f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_NOK("exec_object", "f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: file not found: f1.o\n");

    RUN_OK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // only wrong .o
    remove_f1();
    make_f1_o_nok();
    RUN_NOK("exec_object", "f1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    // only ok .o
    remove_f1();
    make_f1_o_ok();
    RUN_OK("exec_object", "f1");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    // asm and wrong .o
    remove_f1();
    make_f1_asm();
    make_f1_o_nok();
    RUN_OK("exec_object", "f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_NOK("exec_object", "f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_OK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // asm and ok .o newer
    remove_f1();
    make_f1_asm();
    make_f1_o_ok();
    RUN_OK("exec_object", "f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // asm and ok .o older
    remove_f1();
    make_f1_o_ok();
    make_f1_asm();
    RUN_OK("exec_object", "f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // **** with -d
    // only asm
    remove_f1();
    make_f1_asm();
    RUN_OK("exec_object", "-d f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_NOK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: file not found: f1.o\n");

    RUN_OK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // only wrong .o
    remove_f1();
    make_f1_o_nok();
    RUN_NOK("exec_object", "-d f1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    // only ok .o
    remove_f1();
    make_f1_o_ok();
    RUN_OK("exec_object", "-d f1");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    // asm and wrong .o
    remove_f1();
    make_f1_asm();
    make_f1_o_nok();
    RUN_NOK("exec_object", "-d f1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    RUN_NOK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal CPU: 0\nerror: invalid object file: f1.o\n");

    // asm and ok .o newer
    remove_f1();
    make_f1_asm();
    make_f1_o_ok();
    RUN_OK("exec_object", "-d f1");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    // asm and ok .o older
    remove_f1();
    make_f1_o_ok();
    make_f1_asm();
    RUN_OK("exec_object", "-d f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.o");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-d f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // **** with -m*
    // only asm
    remove_f1();
    make_f1_asm();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_NOK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: file not found: f1.o\n");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // only wrong .o
    remove_f1();
    make_f1_o_nok();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    // only ok .o
    remove_f1();
    make_f1_o_ok();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    // asm and wrong .o
    remove_f1();
    make_f1_asm();
    make_f1_o_nok();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // asm and ok .o newer
    remove_f1();
    make_f1_asm();
    make_f1_o_ok();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    // asm and ok .o older
    remove_f1();
    make_f1_o_ok();
    make_f1_asm();
    RUN_OK("exec_object", "-m* f1");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.o");
    STR_IS(test_exec_out, "f1.o\n");
    STR_IS(test_exec_err, "");

    RUN_OK("exec_object", "-m* f1.asm");
    STR_IS(test_exec_out, "f1.asm\n");
    STR_IS(test_exec_err, "");

    remove_f1();
}

int exec_object(const string& arg_) {
    string arg = unquote(arg_);
    vector<string> tokens = split(arg);
    g_args.parse("Test", tokens);
    xassert(g_errors.count == 0);
    xassert(g_args.files.size() == static_cast<size_t>(1));
    cout << g_args.files[0] << endl;
    return EXIT_SUCCESS;
}

void test_filenames() {
    Args args;
    args.opt_output_dir = "test_obj";
    string file = "d1/d2/f";

    STR_IS(args.asm_filename(file), "d1/d2/f.asm");
    STR_IS(args.lis_filename(file), "test_obj/d1/d2/f.lis");
    STR_IS(args.o_filename(file), "test_obj/d1/d2/f.o");
    STR_IS(args.o_filename("test_obj/d1/d2/f"), "test_obj/d1/d2/f.o");
    STR_IS(args.def_filename(file), "test_obj/d1/d2/f.def");
    STR_IS(args.bin_filename(file), "test_obj/d1/d2/f.bin");
    STR_IS(args.bin_filename(file, "section"), "test_obj/d1/d2/f_section.bin");
    STR_IS(args.lib_filename(file), "d1/d2/f.lib");
    STR_IS(args.sym_filename(file), "test_obj/d1/d2/f.sym");
    STR_IS(args.map_filename(file), "test_obj/d1/d2/f.map");
    STR_IS(args.reloc_filename(file), "test_obj/d1/d2/f.reloc");
}
