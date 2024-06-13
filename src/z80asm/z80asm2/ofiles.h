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
class ObjFileWriter {
public:
    ObjFileWriter(const string& obj_filename);
    void write();		// write g_asm
    void write(ofstream& os);

private:
    string obj_filename_;
    StringTable string_table_;

    streampos write_exprs(ofstream& os);
    void write_exprs(Symtab& symtab, ofstream& os);
    void write_patch_expr(Patch* patch, ofstream& os);
    void write_expr(const string& target_name, Patch* patch, ofstream& os);

    streampos write_symbols(ofstream& os);
    void write_symbols(Symtab& symtab, ofstream& os);

    streampos write_externs(ofstream& os);
    void write_externs(Symtab& symtab, ofstream& os);

    streampos write_modname(ofstream& os);
    streampos write_sections(ofstream& os);
    void write_sections(Section* section, ofstream& os);
};

// write library files
class LibFileWriter {
public:
    LibFileWriter(const string& lib_filename);

    void write();		// write g_asm
    void write(ofstream& os);

private:
    string lib_filename_;           // filename
    StringTable defined_symbols_;   // list of defined symbols

    void create_objs_for_all_cpus();
    void write_all_objects(ofstream& os);
};

// binary file reader
class BinFileReader {
public:
    BinFileReader(const string& filename);

    const string& filename() const;
    size_t base_addr() const;
    void set_base_addr(size_t addr);

    void read();

    size_t tell() const;
    void seek(size_t addr);
    const byte_t* ptr() const;
    size_t size() const;
    int read_int32();

private:
    string filename_;               // filename
    vector<byte_t> bytes_;          // bytes from file
    size_t base_addr_{ 0 };         // offset from start of file
    size_t pos_{ 0 };               // current read position

};

// read object files
class ObjFileReader {
public:
    ObjFileReader(const string& obj_filename);

    void read();                    // read into g_asm

private:
    BinFileReader bin_file_;        // file reader
    StringTable string_table_;      // string table from file

    bool seek_ptr(int n);
    bool seek_modname();
    bool seek_exprs();
    bool seek_defined_names();
    bool seek_external_names();
    bool seek_sections();
    bool seek_string_table();

    int read_int32();
    string read_string();

    void read1();
    void parse_string_table();
    void parse_modname();
    void parse_sections();
    void parse_defined_names();
    void parse_external_names();
    void parse_exprs();
};
