//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "../config.h"
#include "args.h"
#include "errors.h"
#include "files.h"
#include "model.h"
#include "scan.h"
#include "stack_trace.h"
#include "utils.h"
#include "xassert.h"
#include <algorithm>
#include <array>
#include <cctype>
#include <climits>
#include <cstdlib>
#include <cstring>
#include <cstring>
#include <fstream>
#include <iostream>
#include <iterator>
#include <list>
#include <map>
#include <regex>
#include <set>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
using namespace std;

// default file name extensions
#define EXT_ASM     ".asm"    
#define EXT_LIS		".lis"    
#define EXT_O		".o"	  
#define EXT_DEF     ".def"    
#define EXT_BIN     ".bin"    
#define EXT_LIB     ".lib"    
#define EXT_SYM     ".sym"    
#define EXT_MAP     ".map"    
#define EXT_RELOC   ".reloc"  
#define EXT_M4      ".m4"

// program and library names
#define Z80ASM_PROG	    "z88dk-z80asm"
#define Z80ASM_LIB  	Z80ASM_PROG EXT_LIB

// environment variables
#define Z80ASM_ENVVAR	"Z80ASM"
#define ZCCCFG_ENVVAR   "ZCCCFG"

//-----------------------------------------------------------------------------
// version
//-----------------------------------------------------------------------------
#ifndef Z88DK_VERSION
#define Z88DK_VERSION "build " __DATE__
#endif

#define COPYRIGHT		"InterLogic 1993-2009, Paulo Custodio 2011-2024"

#define COPYRIGHT_MSG	"Z80 Macro Assembler " Z88DK_VERSION "\n(c) " COPYRIGHT

#if 0
//-----------------------------------------------------------------------------
// Expressions
//-----------------------------------------------------------------------------

class Expr {
public:
    Expr(Tokens tokens);
    Expr(const Expr& other);
    Expr& operator=(const Expr& other);
    virtual ~Expr();

private:
    string m_text;              // original expression text
    vector<Token> m_rpn;        // Reverse Polish Notation of expression
};

//-----------------------------------------------------------------------------
// Application
//-----------------------------------------------------------------------------

// one patch into object code
class Patch {
public:

};

// one instruction
class Instr {
public:

private:
    Location m_location;
    /*
    int m_addr{ 0 };
    int m_phased_addr{ -1 };
    */
    vector<byte_t> m_bytes;
    list<Patch*> m_patches;
};

// one named section of code
class Section {
public:
    Section(const string& section_name);
    virtual ~Section();
    Section& operator=(const Section& other) = delete;
    Section(const Section& other) = delete;

    // list access
    auto begin() { return m_instrs.begin(); }
    auto end() { return m_instrs.end(); }
    auto cbegin() const { return m_instrs.cbegin(); }
    auto cend() const { return m_instrs.cend(); }
    auto size() const { return m_instrs.size(); }
    auto empty() const { return m_instrs.empty(); }

    // attributes
    string get_section_name() const { return m_section_name; }

private:
    string m_section_name;
    list<Instr*> m_instrs;
};

// module - minimum quantity that can be linked
class Module {
public:
    Module(const string& module_name);
    virtual ~Module();
    Module& operator=(const Module& other) = delete;
    Module(const Module& other) = delete;

    // list access
    auto begin() { return m_sections.begin(); }
    auto end() { return m_sections.end(); }
    auto cbegin() const { return m_sections.cbegin(); }
    auto cend() const { return m_sections.cend(); }
    auto size() const { return m_sections.size(); }
    auto empty() const { return m_sections.empty(); }

    // attributes
    string get_module_name() const { return m_module_name; }
    Section* get_current_section();
    Section* get_new_section(const string& section_name);

private:
    string m_module_name;
    list<Section*> m_sections;
    Section* m_current_section{ nullptr };
};

// one assembly file with its includes
class AsmUnit {
public:
    AsmUnit(const string& filename);
    virtual ~AsmUnit();
    AsmUnit& operator=(const AsmUnit& other) = delete;
    AsmUnit(const AsmUnit& other) = delete;

    // list access
    auto begin() { return m_modules.begin(); }
    auto end() { return m_modules.end(); }
    auto cbegin() const { return m_modules.cbegin(); }
    auto cend() const { return m_modules.cend(); }
    auto size() const { return m_modules.size(); }
    auto empty() const { return m_modules.empty(); }

    // attributes
    string get_filename() const { return m_filename; }
    Module* get_current_module();
    Module* get_new_module(const string& module_name);

private:
    string m_filename;
    list<Module*> m_modules;
    Module* m_current_module{ nullptr };
};

// the assembler
class Asm {
public:
    Asm() {}
    virtual ~Asm();
    Asm& operator=(const Asm& other) = delete;
    Asm(const Asm& other) = delete;

    // list access
    auto begin() { return m_asm_units.begin(); }
    auto end() { return m_asm_units.end(); }
    auto cbegin() const { return m_asm_units.cbegin(); }
    auto cend() const { return m_asm_units.cend(); }
    auto size() const { return m_asm_units.size(); }
    auto empty() const { return m_asm_units.empty(); }

    // attributes
    AsmUnit* get_current_asm_unit();
    string get_asmpc_label() const;
    void set_asmpc_label(const string& label);

    bool assemble(const string& asm_filename);
    bool append_object(const string& o_filename);

    static string genlabel();
private:
    list<AsmUnit*> m_asm_units;
    AsmUnit* m_current_asm_unit{ nullptr };
    string m_asmpc_label;         // generated label ay each instruction
};

extern Asm g_asm;
#endif

//-----------------------------------------------------------------------------
// Object and lib files
//-----------------------------------------------------------------------------

#define OBJ_FILE_VERSION        18
#define OBJ_FILE_SIGNATURE_BASE "Z80RMF"
#define LIB_FILE_SIGNATURE_BASE "Z80LMF"
#define FILE_SIGNATURE_SIZE     8
#define FILE_VERSION_SIZE       2

class ObjLibFileReader {
protected:
    ObjLibFileReader(ifstream& ifs);

    ifstream& m_ifs;
    streampos m_fpos{ 0 };
    bool m_header_checked{ false };

    bool check_signature();
    virtual string get_signature_base() const = 0;
    size_t get_signature_size() const {
        return get_signature_base().size() + FILE_VERSION_SIZE;
    }
};

//-----------------------------------------------------------------------------
// Object files
//-----------------------------------------------------------------------------

class ObjFileReader : private ObjLibFileReader {
public:
    ObjFileReader(ifstream& ifs);
    bool check_header();

    static bool check_file_header(const string& filename);

private:
    static inline const string File_Signature_Base = OBJ_FILE_SIGNATURE_BASE;

    CpuId     m_cpu{ CpuId::undef };
    SwapIXIY  m_swap_ixiy{ SwapIXIY::undef };
    streampos m_fpos_modname{ 0 };
    streampos m_fpos_exprs{ 0 };
    streampos m_fpos_symbols{ 0 };
    streampos m_fpos_externs{ 0 };
    streampos m_fpos_sections{ 0 };
    streampos m_fpos_strtable{ 0 };

    virtual string get_signature_base() const { return OBJ_FILE_SIGNATURE_BASE; }
    size_t get_header_size() const {
        // cpu, ixiy, 6 pointers to data (modname, exprs, symbols, externs, sections, strtable)
        return (2 + 6) * sizeof(int32_t);
    }
};

//-----------------------------------------------------------------------------
// Library files
//-----------------------------------------------------------------------------

class LibFileReader : private ObjLibFileReader {
public:
    LibFileReader(ifstream& ifs);
    bool check_header();

    static bool check_file_header(const string& filename);

private:
    virtual string get_signature_base() const { return LIB_FILE_SIGNATURE_BASE; }
};
