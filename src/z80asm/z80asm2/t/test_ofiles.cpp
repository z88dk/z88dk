//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "ofiles.h"
#include "z80asm_defs.h"
#include "t/test.h"
#include <iostream>
#include <fstream>
using namespace std;

void test_file_is_object_file1() {
    ostringstream oss;
    g_errors.set_output(oss);

    remove("test~.o");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: file open: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file2() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.o", "");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: not an object file: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file3() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.o", "12345678");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: not an object file: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file4() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.o", OBJ_FILE_SIGNATURE "00" "xx");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: invalid object file version: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file5() {
    ostringstream oss;
    g_errors.set_output(oss);

    char cpu_ixiy_data[] = { -1,-1,-1,-1, -1,-1,-1,-1 };
    test_spew("test~.o",
        string(OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)) +
        string(std::begin(cpu_ixiy_data), std::end(cpu_ixiy_data)));
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: CPU incompatible: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file6() {
    ostringstream oss;
    g_errors.set_output(oss);

    char cpu_ixiy_data[] = { 1,0,0,0, -1,-1,-1,-1 };
    test_spew("test~.o",
        string(OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)) +
        string(std::begin(cpu_ixiy_data), std::end(cpu_ixiy_data)));
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    NOK(file_is_object_file("test~.o", true));
    IS(oss.str(), "error: -IXIY incompatible: test~.o\n");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file7() {
    ostringstream oss;
    g_errors.set_output(oss);

    char cpu_ixiy_data[] = { 1,0,0,0, 0,0,0,0 };
    test_spew("test~.o",
        string(OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)) +
        string(std::begin(cpu_ixiy_data), std::end(cpu_ixiy_data)));
    OK(0 == system("perl -e 'sleep(1)'"));

    OK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    OK(file_is_object_file("test~.o", true));
    IS(oss.str(), "");

    g_errors.clear();
    remove("test~.o");
}

void test_file_is_object_file8() {
    ostringstream oss;
    g_errors.set_output(oss);
    g_options.set_cpu("*");

    char cpu_ixiy_data[] = { -1,-1,-1,-1, -1,-1,-1,-1 };
    test_spew("test~.o",
        string(OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)) +
        string(std::begin(cpu_ixiy_data), std::end(cpu_ixiy_data)));
    OK(0 == system("perl -e 'sleep(1)'"));

    OK(file_is_object_file("test~.o"));
    IS(oss.str(), "");

    OK(file_is_object_file("test~.o", true));
    IS(oss.str(), "");

    g_options.clear();
    g_errors.clear();
    remove("test~.o");
}

void test_file_is_library_file1() {
    ostringstream oss;
    g_errors.set_output(oss);

    remove("test~.lib");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_library_file("test~.lib"));
    IS(oss.str(), "");

    NOK(file_is_library_file("test~.lib", true));
    IS(oss.str(), "error: file open: test~.lib\n");

    g_errors.clear();
    remove("test~.lib");
}

void test_file_is_library_file2() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.lib", "");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_library_file("test~.lib"));
    IS(oss.str(), "");

    NOK(file_is_library_file("test~.lib", true));
    IS(oss.str(), "error: not a library file: test~.lib\n");

    g_errors.clear();
    remove("test~.lib");
}

void test_file_is_library_file3() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.lib", "12345678");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_library_file("test~.lib"));
    IS(oss.str(), "");

    NOK(file_is_library_file("test~.lib", true));
    IS(oss.str(), "error: not a library file: test~.lib\n");

    g_errors.clear();
    remove("test~.lib");
}

void test_file_is_library_file4() {
    ostringstream oss;
    g_errors.set_output(oss);

    test_spew("test~.lib", LIB_FILE_SIGNATURE "00" "xx");
    OK(0 == system("perl -e 'sleep(1)'"));

    NOK(file_is_library_file("test~.lib"));
    IS(oss.str(), "");

    NOK(file_is_library_file("test~.lib", true));
    IS(oss.str(), "error: invalid library file version: test~.lib\n");

    g_errors.clear();
    remove("test~.lib");
}

void test_file_is_library_file5() {
    ostringstream oss;
    g_errors.set_output(oss);

    char cpu_ixiy_data[] = { -1,-1,-1,-1, -1,-1,-1,-1 };
    test_spew("test~.lib",
        string(LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)) +
        string(std::begin(cpu_ixiy_data), std::end(cpu_ixiy_data)));
    OK(0 == system("perl -e 'sleep(1)'"));

    OK(file_is_library_file("test~.lib"));
    IS(oss.str(), "");

    OK(file_is_library_file("test~.lib", true));
    IS(oss.str(), "");

    g_errors.clear();
    remove("test~.lib");
}

void test_simplest_file() {
    g_asm.clear();
    g_asm.add_object("test~.asm");

    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[1024];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);               
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer)+ SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16
    IS(sread_int32(ifs), 40);           // modname
    IS(sread_int32(ifs), -1);           // exprs
    IS(sread_int32(ifs), -1);           // symbols
    IS(sread_int32(ifs), -1);           // externs
    IS(sread_int32(ifs), 44);           // sections
    IS(sread_int32(ifs), 64);           // string table

    // fpos=40: modname
    IS(sread_int32(ifs), 1);            // string 1="test~"

    // fpos=44: sections
    IS(sread_int32(ifs), 0);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), -1);           // section org - not defined
    IS(sread_int32(ifs), 1);            // section align
    // no bytes

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=64: string table
    IS(sread_int32(ifs), 2);            // count of strings
    IS(sread_int32(ifs), 8);            // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~"

    ifs.read(buffer, 8);                // all strings
    IS(ifs.gcount(), 8);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~");    // string 1

    ifs.close();

    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), ORG_NOT_DEFINED);
    IS(g_section().align(), 1);
    IS(g_section().size(), 0);

    g_asm.clear();
    remove("test~.o");
}

void test_changed_cpu() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_options.set_cpu(CPU_Z180);
    g_options.set_swap_ixiy(IXIY_SWAP);

    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[1024];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);               
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer)+ SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z180);     // CPU
    IS(sread_int32(ifs), IXIY_SWAP);    // swap

    // fpos=16
    IS(sread_int32(ifs), 40);           // modname
    IS(sread_int32(ifs), -1);           // exprs
    IS(sread_int32(ifs), -1);           // symbols
    IS(sread_int32(ifs), -1);           // externs
    IS(sread_int32(ifs), 44);           // sections
    IS(sread_int32(ifs), 64);           // string table

    // fpos=40: modname
    IS(sread_int32(ifs), 1);            // string 1="test~"

    // fpos=44: sections
    IS(sread_int32(ifs), 0);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), -1);           // section org - not defined
    IS(sread_int32(ifs), 1);            // section align
    // no bytes

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=64: string table
    IS(sread_int32(ifs), 2);            // count of strings
    IS(sread_int32(ifs), 8);            // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~"

    ifs.read(buffer, 8);                // all strings
    IS(ifs.gcount(), 8);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~");    // string 1

    ifs.close();
    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), ORG_NOT_DEFINED);
    IS(g_section().align(), 1);
    IS(g_section().size(), 0);

    g_options.clear();
    g_asm.clear();
    remove("test~.o");
}

void test_add_1_byte_of_code() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_section().add_instr(0xc9);

    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[1024];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer) + SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16
    IS(sread_int32(ifs), 40);           // modname
    IS(sread_int32(ifs), -1);           // exprs
    IS(sread_int32(ifs), -1);           // symbols
    IS(sread_int32(ifs), -1);           // externs
    IS(sread_int32(ifs), 44);           // sections
    IS(sread_int32(ifs), 68);           // string table

    // fpos=40: modname
    IS(sread_int32(ifs), 1);            // string 1="test~"

    // fpos=44: sections
    IS(sread_int32(ifs), 1);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), ORG_NOT_DEFINED); // section org
    IS(sread_int32(ifs), 1);            // section align
    ifs.read(buffer, 4);                // 1 byte + 3 alignment
    IS(ifs.gcount(), 4);
    IS((buffer[0] & 0xff), 0xc9);       // byte
    IS((buffer[1] & 0xff), 0);          // alignment
    IS((buffer[2] & 0xff), 0);          // alignment
    IS((buffer[3] & 0xff), 0);          // alignment

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=68: string table
    IS(sread_int32(ifs), 2);            // count of strings
    IS(sread_int32(ifs), 8);            // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~"

    ifs.read(buffer, 8);                // all strings
    IS(ifs.gcount(), 8);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~");    // string 1

    ifs.close();

    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), ORG_NOT_DEFINED);
    IS(g_section().align(), 1);
    IS(g_section().size(), 1);
    IS(g_section().instrs().size(), 1);
    IS(g_section().instrs()[0]->bytes().size(), 1);
    IS(g_section().instrs()[0]->bytes()[0], 0xc9);

    g_asm.clear();
    remove("test~.o");
}

void test_define_org() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_section().set_origin(0x1000);
    g_section().set_align(4);
    g_section().add_instr(0xc9);

    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[1024];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer) + SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16
    IS(sread_int32(ifs), 40);           // modname
    IS(sread_int32(ifs), -1);           // exprs
    IS(sread_int32(ifs), -1);           // symbols
    IS(sread_int32(ifs), -1);           // externs
    IS(sread_int32(ifs), 44);           // sections
    IS(sread_int32(ifs), 68);           // string table

    // fpos=40: modname
    IS(sread_int32(ifs), 1);            // string 1="test~"

    // fpos=44: sections
    IS(sread_int32(ifs), 1);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), 0x1000);       // section org
    IS(sread_int32(ifs), 4);            // section align
    ifs.read(buffer, 4);                // 1 byte + 3 alignment
    IS(ifs.gcount(), 4);
    IS((buffer[0] & 0xff), 0xc9);       // byte
    IS((buffer[1] & 0xff), 0);          // alignment
    IS((buffer[2] & 0xff), 0);          // alignment
    IS((buffer[3] & 0xff), 0);          // alignment

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=68: string table
    IS(sread_int32(ifs), 2);            // count of strings
    IS(sread_int32(ifs), 8);            // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~"

    ifs.read(buffer, 8);                // all strings
    IS(ifs.gcount(), 8);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~");    // string 1

    ifs.close();
    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), 0x1000);
    IS(g_section().align(), 4);
    IS(g_section().size(), 1);
    IS(g_section().instrs().size(), 1);
    IS(g_section().instrs()[0]->bytes().size(), 1);
    IS(g_section().instrs()[0]->bytes()[0], 0xc9);

    g_asm.clear();
    remove("test~.o");
}

void test_add_expression() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_section().set_origin(0x1000);
    g_section().set_align(4);
    g_errors.set_location(Location("test~.asm", 11));
    Instr* instr = g_section().add_instr(0x3e);
    instr->add_patch(new Patch(RANGE_BYTE_UNSIGNED, 1, new Expr("3*4")));
    g_section().add_instr(0xc9);
    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[1024];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer) + SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16
    IS(sread_int32(ifs), 80);           // modname
    IS(sread_int32(ifs), 40);           // exprs
    IS(sread_int32(ifs), -1);           // symbols
    IS(sread_int32(ifs), -1);           // externs
    IS(sread_int32(ifs), 84);           // sections
    IS(sread_int32(ifs), 108);          // string table

    // fpos=40: exprs
    IS(sread_int32(ifs), RANGE_BYTE_UNSIGNED);  // range
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // asmpc
    IS(sread_int32(ifs), 1);            // offset
    IS(sread_int32(ifs), 2);            // opcode size
    IS(sread_int32(ifs), 0);            // target name string 0="" 
    IS(sread_int32(ifs), 2);            // expression string 2="3*4"

    IS(sread_int32(ifs), RANGE_UNDEFINED);  // range terminator

    // fpos=80: modname
    IS(sread_int32(ifs), 3);            // string 3="test~"

    // fpos=84: sections
    IS(sread_int32(ifs), 3);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), 0x1000);       // section org
    IS(sread_int32(ifs), 4);            // section align
    ifs.read(buffer, 4);                // 1 byte + 3 alignment
    IS(ifs.gcount(), 4);
    IS((buffer[0] & 0xff), 0x3e);       // byte
    IS((buffer[1] & 0xff), 0);          // byte
    IS((buffer[2] & 0xff), 0xc9);       // byte
    IS((buffer[3] & 0xff), 0);          // alignment

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=108: string table
    IS(sread_int32(ifs), 4);            // count of strings
    IS(sread_int32(ifs), 24);           // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // index of string 2="3*4"
    IS(sread_int32(ifs), 15);           // index of string 3="test~"

    ifs.read(buffer, 24);               // all strings
    IS(ifs.gcount(), 24);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~.asm");// string 1
    IS(string(&buffer[11]), "3*4");     // string 2
    IS(string(&buffer[15]), "test~");   // string 3

    ifs.close();
    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), 0x1000);
    IS(g_section().align(), 4);
    IS(g_section().size(), 3);
    IS(g_section().instrs().size(), 1);
    IS(g_section().instrs()[0]->bytes().size(), 3);
    IS(g_section().instrs()[0]->bytes()[0], 0x3e);
    IS(g_section().instrs()[0]->bytes()[1], 0);
    IS(g_section().instrs()[0]->bytes()[2], 0xc9);
    IS(g_section().instrs()[0]->patches().size(), 1);
    IS(g_section().instrs()[0]->patches()[0]->range(), RANGE_BYTE_UNSIGNED);
    IS(g_section().instrs()[0]->patches()[0]->offset(), 1);
    IS(g_section().instrs()[0]->patches()[0]->expr()->text(), "3*4");

    g_asm.clear();
    remove("test~.o");
}

void test_add_defc_and_extern() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_section().set_origin(0x1000);
    g_section().set_align(4);
    g_asm.declare_extern("XSIZE");
    g_errors.set_location(Location("test~.asm", 11));
    Instr* instr = g_section().add_instr(0x3e);
    instr->add_patch(new Patch(RANGE_BYTE_UNSIGNED, 1, new Expr("SIZE")));
    g_asm.add_equ("SIZE", new Expr("XSIZE"));
    g_section().add_instr(0xc9);
    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[BUFSIZ];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer) + SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16: pointers
    IS(sread_int32(ifs), 156);          // modname
    IS(sread_int32(ifs), 40);           // exprs
    IS(sread_int32(ifs), 116);          // symbols
    IS(sread_int32(ifs), 148);          // externs
    IS(sread_int32(ifs), 160);          // sections
    IS(sread_int32(ifs), 184);          // string table

    // fpos=40: exprs
    IS(sread_int32(ifs), RANGE_BYTE_UNSIGNED);  // range
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // asmpc
    IS(sread_int32(ifs), 1);            // offset
    IS(sread_int32(ifs), 2);            // opcode size
    IS(sread_int32(ifs), 0);            // target name string 0="" 
    IS(sread_int32(ifs), 2);            // expression string 2="SIZE"

    IS(sread_int32(ifs), RANGE_ASSIGNMENT);  // range
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // asmpc
    IS(sread_int32(ifs), 0);            // offset
    IS(sread_int32(ifs), 0);            // opcode size
    IS(sread_int32(ifs), 2);            // target name string 2="SIZE" 
    IS(sread_int32(ifs), 3);            // expression string 3="XSIZE"

    IS(sread_int32(ifs), RANGE_UNDEFINED);  // range terminator

    // fpos=116: symbols
    IS(sread_int32(ifs), SCOPE_LOCAL);  // scope
    IS(sread_int32(ifs), TYPE_COMPUTED);// type
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // value
    IS(sread_int32(ifs), 2);            // name string 2="SIZE" 
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number

    IS(sread_int32(ifs), SCOPE_NONE);   // scope

    // fpos=148: externs
    IS(sread_int32(ifs), 3);            // extern string 3="XSIZE"

    IS(sread_int32(ifs), 0);            // terminator string 0="" 

    // fpos=156: modname
    IS(sread_int32(ifs), 4);            // string 4="test~"

    // fpos=160: sections
    IS(sread_int32(ifs), 3);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), 0x1000);       // section org
    IS(sread_int32(ifs), 4);            // section align
    ifs.read(buffer, 4);                // 1 byte + 3 alignment
    IS(ifs.gcount(), 4);
    IS((buffer[0] & 0xff), 0x3e);       // byte
    IS((buffer[1] & 0xff), 0);          // byte
    IS((buffer[2] & 0xff), 0xc9);       // byte
    IS((buffer[3] & 0xff), 0);          // alignment

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=184: string table
    IS(sread_int32(ifs), 5);            // count of strings
    IS(sread_int32(ifs), 28);           // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // index of string 2="SIZE"
    IS(sread_int32(ifs), 16);           // index of string 3="XSIZE"
    IS(sread_int32(ifs), 22);           // index of string 4="test~"

    ifs.read(buffer, 28);               // all strings
    IS(ifs.gcount(), 28);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~.asm");// string 1
    IS(string(&buffer[11]), "SIZE");    // string 2
    IS(string(&buffer[16]), "XSIZE");   // string 3
    IS(string(&buffer[22]), "test~");   // string 4

    ifs.close();
    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), 0x1000);
    IS(g_section().align(), 4);

    OK(g_local_symbols().find("XSIZE"));
    IS(g_local_symbols().find("XSIZE")->scope(), SCOPE_EXTERN);
    IS(g_local_symbols().find("XSIZE")->type(), TYPE_UNDEFINED);
    IS(g_local_symbols().find("XSIZE")->section()->name(), "");

    OK(g_local_symbols().find("SIZE"));
    IS(g_local_symbols().find("SIZE")->scope(), SCOPE_LOCAL);
    IS(g_local_symbols().find("SIZE")->type(), TYPE_COMPUTED);
    IS(g_local_symbols().find("SIZE")->section()->name(), "");
    IS(g_local_symbols().find("SIZE")->expr()->text(), "XSIZE");

    IS(g_section().size(), 3);
    IS(g_section().instrs().size(), 1);
    IS(g_section().instrs()[0]->bytes().size(), 3);
    IS(g_section().instrs()[0]->bytes()[0], 0x3e);
    IS(g_section().instrs()[0]->bytes()[1], 0);
    IS(g_section().instrs()[0]->bytes()[2], 0xc9);
    IS(g_section().instrs()[0]->patches().size(), 1);
    IS(g_section().instrs()[0]->patches()[0]->range(), RANGE_BYTE_UNSIGNED);
    IS(g_section().instrs()[0]->patches()[0]->offset(), 1);
    IS(g_section().instrs()[0]->patches()[0]->expr()->text(), "SIZE");

    g_asm.clear();
    remove("test~.o");
}

void test_add_label() {
    g_asm.clear();
    g_asm.add_object("test~.asm");
    g_section().set_origin(0x1000);
    g_section().set_align(4);
    g_asm.declare_extern("XSIZE");
    g_errors.set_location(Location("test~.asm", 11));
    g_asm.add_label("START");
    Instr* instr = g_section().add_instr(0x3e);
    instr->add_patch(new Patch(RANGE_BYTE_UNSIGNED, 1, new Expr("SIZE")));
    g_asm.add_equ("SIZE", new Expr("XSIZE"));
    g_section().add_instr(0xc9);
    OFileWriter ofile("test~.o");
    ofile.write();

    ifstream ifs("test~.o", ios::binary);
    char buffer[BUFSIZ];
    // fpos=0
    ifs.read(buffer, SIGNATURE_SIZE);
    IS(ifs.gcount(), SIGNATURE_SIZE);
    IS(string(std::begin(buffer), std::begin(buffer) + SIGNATURE_SIZE),
        OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION));

    // fpos=8
    IS(sread_int32(ifs), CPU_Z80);      // CPU
    IS(sread_int32(ifs), IXIY_NO_SWAP); // swap

    // fpos=16: pointers
    IS(sread_int32(ifs), 184);          // modname
    IS(sread_int32(ifs), 40);           // exprs
    IS(sread_int32(ifs), 116);          // symbols
    IS(sread_int32(ifs), 176);          // externs
    IS(sread_int32(ifs), 188);          // sections
    IS(sread_int32(ifs), 212);          // string table

    // fpos=40: exprs
    IS(sread_int32(ifs), RANGE_BYTE_UNSIGNED);  // range
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // asmpc
    IS(sread_int32(ifs), 1);            // offset
    IS(sread_int32(ifs), 2);            // opcode size
    IS(sread_int32(ifs), 0);            // target name string 0="" 
    IS(sread_int32(ifs), 2);            // expression string 2="SIZE"

    IS(sread_int32(ifs), RANGE_ASSIGNMENT);  // range
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // asmpc
    IS(sread_int32(ifs), 0);            // offset
    IS(sread_int32(ifs), 0);            // opcode size
    IS(sread_int32(ifs), 2);            // target name string 2="SIZE" 
    IS(sread_int32(ifs), 3);            // expression string 3="XSIZE"

    IS(sread_int32(ifs), RANGE_UNDEFINED);  // range terminator

    // fpos=116: symbols
    IS(sread_int32(ifs), SCOPE_LOCAL);  // scope
    IS(sread_int32(ifs), TYPE_ADDRESS); // type
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // value
    IS(sread_int32(ifs), 4);            // name string 4="START" 
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number

    IS(sread_int32(ifs), SCOPE_LOCAL);  // scope
    IS(sread_int32(ifs), TYPE_COMPUTED);// type
    IS(sread_int32(ifs), 0);            // section name string 0="" 
    IS(sread_int32(ifs), 0);            // value
    IS(sread_int32(ifs), 2);            // name string 2="SIZE" 
    IS(sread_int32(ifs), 1);            // filename string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // line number

    IS(sread_int32(ifs), SCOPE_NONE);   // scope

    // fpos=176: externs
    IS(sread_int32(ifs), 3);            // extern string 3="XSIZE"

    IS(sread_int32(ifs), 0);            // terminator string 0="" 

    // fpos=184: modname
    IS(sread_int32(ifs), 5);            // string 5="test~"

    // fpos=188: sections
    IS(sread_int32(ifs), 3);            // section "" size
    IS(sread_int32(ifs), 0);            // string 0="" section name
    IS(sread_int32(ifs), 0x1000);       // section org
    IS(sread_int32(ifs), 4);            // section align
    ifs.read(buffer, 4);                // 1 byte + 3 alignment
    IS(ifs.gcount(), 4);
    IS((buffer[0] & 0xff), 0x3e);       // byte
    IS((buffer[1] & 0xff), 0);          // byte
    IS((buffer[2] & 0xff), 0xc9);       // byte
    IS((buffer[3] & 0xff), 0);          // alignment

    IS(sread_int32(ifs), -1);           // end of section list

    // fpos=212: string table
    IS(sread_int32(ifs), 6);            // count of strings
    IS(sread_int32(ifs), 36);           // aligned size of strings
    IS(sread_int32(ifs), 0);            // index of string 0=""
    IS(sread_int32(ifs), 1);            // index of string 1="test~.asm"
    IS(sread_int32(ifs), 11);           // index of string 2="SIZE"
    IS(sread_int32(ifs), 16);           // index of string 3="XSIZE"
    IS(sread_int32(ifs), 22);           // index of string 4="START"
    IS(sread_int32(ifs), 28);           // index of string 5="test~"

    ifs.read(buffer, 36);               // all strings
    IS(ifs.gcount(), 36);
    IS(string(&buffer[0]), "");         // string 0
    IS(string(&buffer[1]), "test~.asm");// string 1
    IS(string(&buffer[11]), "SIZE");    // string 2
    IS(string(&buffer[16]), "XSIZE");   // string 3
    IS(string(&buffer[22]), "START");   // string 4
    IS(string(&buffer[28]), "test~");   // string 5

    ifs.close();
    g_asm.delete_objects();

    // read it back
    g_asm.load_object("test~.o");
    IS(g_module().name(), "test~");
    IS(g_section().name(), "");
    IS(g_section().origin(), 0x1000);
    IS(g_section().align(), 4);

    OK(g_local_symbols().find("START"));
    IS(g_local_symbols().find("START")->scope(), SCOPE_LOCAL);
    IS(g_local_symbols().find("START")->type(), TYPE_ADDRESS);
    IS(g_local_symbols().find("START")->section()->name(), "");
    ExprResult res = g_local_symbols().find("START")->eval();
    OK(res.ok());
    IS(res.type(), TYPE_ADDRESS);
    IS(res.value(), 0);

    OK(g_local_symbols().find("XSIZE"));
    IS(g_local_symbols().find("XSIZE")->scope(), SCOPE_EXTERN);
    IS(g_local_symbols().find("XSIZE")->type(), TYPE_UNDEFINED);
    IS(g_local_symbols().find("XSIZE")->section()->name(), "");
    res = g_local_symbols().find("XSIZE")->eval();
    NOK(res.ok());
    IS(res.type(), TYPE_UNDEFINED);

    OK(g_local_symbols().find("SIZE"));
    IS(g_local_symbols().find("SIZE")->scope(), SCOPE_LOCAL);
    IS(g_local_symbols().find("SIZE")->type(), TYPE_COMPUTED);
    IS(g_local_symbols().find("SIZE")->section()->name(), "");
    IS(g_local_symbols().find("SIZE")->expr()->text(), "XSIZE");
    res = g_local_symbols().find("SIZE")->eval();
    NOK(res.ok());
    IS(res.type(), TYPE_UNDEFINED);

    IS(g_section().size(), 3);
    IS(g_section().instrs().size(), 1);
    IS(g_section().instrs()[0]->bytes().size(), 3);
    IS(g_section().instrs()[0]->bytes()[0], 0x3e);
    IS(g_section().instrs()[0]->bytes()[1], 0);
    IS(g_section().instrs()[0]->bytes()[2], 0xc9);
    IS(g_section().instrs()[0]->patches().size(), 1);
    IS(g_section().instrs()[0]->patches()[0]->range(), RANGE_BYTE_UNSIGNED);
    IS(g_section().instrs()[0]->patches()[0]->offset(), 1);
    IS(g_section().instrs()[0]->patches()[0]->expr()->text(), "SIZE");

    g_asm.clear();
    remove("test~.o");
}

