//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "object.h"
#include "symtab.h"
#include "utils.h"
#include <cstdint>
#include <iostream>
#include <set>
#include <string>
#include <vector>
using namespace std;

// object file signature
#define OBJ_FILE_VERSION		18
#define SIGNATURE_SIZE			8
#define SIGNATURE_BASE_SIZE		6
#define OBJ_FILE_SIGNATURE		"Z80RMF"
#define OBJ_FILE_HEADER         OBJ_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)
#define LIB_FILE_SIGNATURE		"Z80LMF"
#define LIB_FILE_HEADER         LIB_FILE_SIGNATURE TOSTR(OBJ_FILE_VERSION)

// check object files
bool file_is_object_file(const string& filename, bool do_error = false);
bool file_is_library_file(const string& filename, bool do_error = false);

// write object files
class OFileWriter {
public:
    OFileWriter(const string& o_filename);
    void write();		// write g_asm
    void write(ofstream& os);

private:
    string o_filename_;
    StringTable string_table_;

    streampos write_exprs(ofstream& os);
    void write_exprs(Symtab& symtab, ofstream& os);
    void write_patch_expr(Instr* instr, Patch* patch, ofstream& os);
    void write_expr(const string& target_name, Instr* instr, Patch* patch, ofstream& os);

    streampos write_symbols(ofstream& os);
    void write_symbols(Symtab& symtab, ofstream& os);

    streampos write_externs(ofstream& os);
    void write_externs(Symtab& symtab, ofstream& os);

    streampos write_modname(ofstream& os);
    streampos write_sections(ofstream& os);
    void write_sections(Section* section, ofstream& os);
};

// read object files
class OFileReader {
public:
    OFileReader(const string& o_filename);

    bool check_cpu_swap();      // false if for different CPU/IXIY combination
    void read_symbols();        // read defined symbols
    void read();                // read into g_asm

private:
    string o_filename_;
    StringTable string_table_;
    set<string> defined_symbols_;
    vector<uint8_t> bytes_;
};
