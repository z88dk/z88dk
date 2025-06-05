//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "symbol.h"
#include <list>
#include <vector>
using namespace std;

class Expr;

using Byte = unsigned char;

// Patch Type

enum class PatchType {
    //@@BEGIN: patch
    NONE,
    JR,
    N,
    NN,
    //@@END
};

// Patch

class Patch {
public:
    Patch(PatchType patch_type, Expr* expr, int offset);
    Patch(const Patch& other) = delete;
    virtual ~Patch();
    Patch& operator=(const Patch& other) = delete;

    PatchType get_patch_type() const { return m_patch_type; }
    Expr* get_expr() { return m_expr; }
    int get_offset() const { return m_offset; }
    int size() const;

private:
    PatchType m_patch_type;
    Expr* m_expr;
    int m_offset;
};

// Instruction

class Instruction {
public:
    Instruction() {}
    Instruction(const Instruction& other) = delete;
    virtual ~Instruction();
    Instruction& operator=(const Instruction& other) = delete;

    int get_offset() const { return m_offset; }
    void set_offset(int offset) { m_offset = offset; }
    Byte* data() { return m_bytes.data(); }
    int size() const { return static_cast<int>(m_bytes.size()); }
    list<Patch*>& get_patches() { return m_patches; }
    Symbol* get_label() const { return m_label; }
    void set_label(Symbol* label) { m_label = label; }

    void add_byte(Byte byte) { m_bytes.push_back(byte); }
    void add_opcode(long long opcode);
    void add_patch(Patch* patch);

private:
    int m_offset{ 0 };
    vector<Byte> m_bytes;
    list<Patch*> m_patches;
    Symbol* m_label{ nullptr };
};

// Section

class Section {
public:
    Section(const string& name);
    Section(const Section& other) = delete;
    virtual ~Section();
    Section& operator=(const Section& other) = delete;

    const string& get_name() const { return m_name; }
    int get_asmpc() const { return m_asmpc; }
    void set_asmpc(int asmpc) { m_asmpc = asmpc; }

    void add_instruction(Instruction* instruction) { m_instructions.push_back(instruction); }
    list<Instruction*>& get_instructions() { return m_instructions; }

private:
    string m_name;
    int m_asmpc{ 0 };
    list<Instruction*> m_instructions;
};

// Object Module

class ObjModule {
public:
    ObjModule();
    ObjModule(const ObjModule& other) = delete;
    virtual ~ObjModule();
    ObjModule& operator=(const ObjModule& other) = delete;
    void clear();

    Symtab* get_symtab() { return &m_symtab; }
    void next_opcode();
    void add_constant(const string& name, Expr* expr);
    void add_label(const string& name);
    void set_assume(int value) { m_assume = value; }
    void add_opcode_void(long long opcode);
    void add_opcode_jr(long long opcode, Expr* expr);
    void add_opcode_n(long long opcode, Expr* expr);
    void add_opcode_nn(long long opcode, Expr* expr);

private:
    Symtab m_symtab;
    list<Section*> m_sections;
    Section* m_cur_section{ nullptr };
    int m_assume{ 0 };
};

extern ObjModule g_obj_module;
