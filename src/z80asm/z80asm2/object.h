//-----------------------------------------------------------------------------
// z80asm - object file model
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
#include "location.h"
#include "parser.h"
#include "symtab.h"
#include <cstdint>
#include <list>
#include <string>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------

typedef uint8_t Byte;
typedef vector<Byte> Bytes;
class Assembler;

//-----------------------------------------------------------------------------

class Instr : public HasLocation {
public:
    Instr(int offset_asmpc, int phased_asmpc);
    virtual ~Instr();
    Instr(const Instr& other) = delete;
    Instr& operator=(const Instr& other) = delete;
    void clear();

    int offset_asmpc() const;
    int phased_asmpc() const;
    int asmpc() const;                      // get offset or phased_asmpc
    int size() const;
    Bytes& bytes();
    list<Patch*>& patches();
    Symbol* label() const;

    void set_offset_asmpc(int asmpc);
    void set_phased_asmpc(int asmpc);
    void set_bytes(int opcode);             // decompose 0xfd213412 in 4 bytes
    void do_patch(Patch* patch);
    void set_label(Symbol* label);
    void add_byte(int byte);
    void add_patch(Patch* patch);

private:
    int offset_asmpc_{ 0 };                 // offset in bytes from start of section
    int phased_asmpc_{ ORG_NOT_DEFINED };   // address inside ASMPC phase
    Bytes bytes_;                           // bytes of the instruction
                                            // with placeholders for patches
    list<Patch*> patches_;                  // patches for each variable expression
    Symbol* label_{ nullptr };              // weak pointer to label if any
};

//-----------------------------------------------------------------------------

class Section {
public:
    Section(const string& name);
    virtual ~Section();
    Section(const Section& other) = delete;
    Section& operator=(const Section& other) = delete;
    void clear();

    const string& name() const;
    int origin() const;
    int align() const;
    list<Instr*>& instrs();
    int size() const;

    void set_origin(int origin);
    void set_align(int align);

    Instr* add_instr();
    Instr* add_instr(int opcode);
    void check_relative_jumps();
    void compute_addresses();
    void patch_local_exprs();

private:
    string name_;                           // name of section, may be ""
    int origin_{ ORG_NOT_DEFINED };         // ORG value
    int align_{ 1 };                        // ALIGN value
    list<Instr*> instrs_;                   // list of assembled instructions

    int phased_asmpc() const;
};

//-----------------------------------------------------------------------------

class Module {
public:
    Module(const string& name);
    virtual ~Module();
    Module(const Module& other) = delete;
    Module& operator=(const Module& other) = delete;
    void clear();

    const string& name() const;

    list<Section*>& sections();
    void select_section(const string& name);
    Section& cur_section() const;
    Symtab& symtab();
    void check_relative_jumps();
    void compute_addresses();
    void patch_local_exprs();
    void check_undefined_symbols();

private:
    string name_;                           // name based on filename, or given by directive
    list<Section*> sections_;               // list of sections in this module
    unordered_map<string, Section*> section_by_name_;   // index sections by name
    Section* cur_section_{ nullptr };       // current section
    Symtab symtab_;                         // all symbols

    void clear_all();
    void create_default_section();          // create default section (named "")
};

//-----------------------------------------------------------------------------

class Object {
public:
    Object(const string& filename);
    virtual ~Object();
    Object(const Object& other) = delete;
    Object& operator=(const Object& other) = delete;
    void clear();

    const string& filename() const;

    list<Module*>& modules();
    void select_module(const string& name);
    Module& cur_module() const;

    bool parse();
    void check_relative_jumps();
    void compute_addresses();
    void patch_local_exprs();
    void check_undefined_symbols();
    void write_obj_file(const string& o_filename);

private:
    Parser parser_;                         // parser of input
    string filename_;                       // name based on filename
    list<Module*> modules_;                 // list of modules in this object
    unordered_map<string, Module*> module_by_name_; // index modules by name
    Module* cur_module_{ nullptr };         // current module

    void clear_all();
    void create_default_module();           // create default module
};
