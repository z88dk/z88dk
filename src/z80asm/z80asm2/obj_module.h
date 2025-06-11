//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "symbol.h"
#include <vector>
using namespace std;

class Expr;
class ObjModule;
class Section;

using Byte = unsigned char;

// Patch Type

enum class PatchType {
    //@@BEGIN: patch
    NONE = 0,
    ASSIGN = 11,
    D = 3,
    D2DD = 8,
    D2DDD = 14,
    HOFFSET = 10,
    JR = 1,
    JRE = 12,
    N = 2,
    N2NN = 7,
    N2NNN = 13,
    NN = 4,
    NNN = 9,
    NNNN = 6,
    NN_BE = 5,
    //@@END
};

// Patch

class Patch {
public:
    Patch(PatchType patch_type, Expr* expr, int offset);
    Patch(const Patch& other) = delete;
    virtual ~Patch();
    Patch& operator=(const Patch& other) = delete;

    PatchType patch_type() const { return m_patch_type; }
    Expr* expr() { return m_expr; }
    int offset() const { return m_offset; }
    int size() const;
    int resolve(int value) const;

private:
    PatchType m_patch_type;
    Expr* m_expr;
    int m_offset;
};

// Instr

class Instr {
public:
    Instr(Section* parent) : m_parent(parent) {}
    Instr(const Instr& other) = delete;
    virtual ~Instr();
    Instr& operator=(const Instr& other) = delete;

    int offset() const { return m_offset; }
    void set_offset(int offset) { m_offset = offset; }
    Byte* data() { return m_bytes.data(); }
    int size() const { return static_cast<int>(m_bytes.size()); }
    vector<Patch*>& patches() { return m_patches; }
    Symbol* label() const { return m_label; }
    void set_label(Symbol* label) { m_label = label; }
    Symtab* symtab();

    void add_byte(Byte byte) { m_bytes.push_back(byte); }
    void add_opcode(long long opcode);
    void add_patch(Patch* patch);

private:
    Section* m_parent{ nullptr };
    int m_offset{ 0 };
    vector<Byte> m_bytes;
    vector<Patch*> m_patches;
    Symbol* m_label{ nullptr };
};

// Section

class Section {
public:
    Section(ObjModule* parent, const string& name);
    Section(const Section& other) = delete;
    virtual ~Section();
    Section& operator=(const Section& other) = delete;
    void clear();

    const string& name() const { return m_name; }

    int origin() const { return m_origin; }
    void set_origin(int origin) { m_origin = origin; }

    int asmpc() const;
    int size() const;

    Symtab* symtab();

    Instr* add_instr();
    Instr* cur_instr();
    vector<Instr*>& instrs() { return m_instrs; }

private:
    ObjModule* m_parent{ nullptr };
    string m_name;
    int m_origin{ 0 };
    vector<Instr*> m_instrs;
};

// Object Module

class ObjModule {
public:
    ObjModule();
    ObjModule(const ObjModule& other) = delete;
    virtual ~ObjModule();
    ObjModule& operator=(const ObjModule& other) = delete;
    void clear();

    Symtab* symtab() { return &m_symtab; }

    Section* cur_section() { return m_cur_section; }
    void set_cur_section(const string& name);
    int asmpc();

    void add_label(const string& name);
    void add_define(const string& name, int value);
    void add_define(const string& name, Expr* expr);
    void remove_define(const string& name);

    void add_equ(const string& name, Expr* expr);
    void set_assume(int value) { m_assume = value; }
    void add_opcode_void(long long opcode);
    void add_opcode_jr(long long opcode, Expr* expr);
    void add_opcode_n(long long opcode, Expr* expr);
    void add_opcode_nn(long long opcode, Expr* expr);

    bool write_file(const string& filename) const;

private:
    Symtab m_symtab;
    vector<Section*> m_sections;
    Section* m_cur_section{ nullptr };
    int m_assume{ 0 };
};

extern ObjModule* g_obj_module;
