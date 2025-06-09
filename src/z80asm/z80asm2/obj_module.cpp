//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "symbol.h"
#include <cassert>
#include <unordered_map>
using namespace std;

ObjModule* g_obj_module{ nullptr };

Patch::Patch(PatchType patch_type, Expr* expr, int offset)
    : m_patch_type(patch_type), m_expr(expr), m_offset(offset) {
}

Patch::~Patch() {
    delete m_expr;
}

int Patch::size() const {
    static unordered_map<PatchType, int> patch_sizes = {
        //@@BEGIN: patch_sizes
        { PatchType::ASSIGN, 0 },
        { PatchType::D, 1 },
        { PatchType::D2DD, 2 },
        { PatchType::D2DDD, 3 },
        { PatchType::HOFFSET, 1 },
        { PatchType::JR, 1 },
        { PatchType::JRE, 2 },
        { PatchType::N, 1 },
        { PatchType::N2NN, 2 },
        { PatchType::N2NNN, 3 },
        { PatchType::NN, 2 },
        { PatchType::NNN, 3 },
        { PatchType::NNNN, 4 },
        { PatchType::NN_BE, 2 },
        //@@END
    };

    auto it = patch_sizes.find(m_patch_type);
    if (it != patch_sizes.end()) {
        return it->second;
    }
    else {
        assert(false && "Unknown patch type");
        return 0; // Should never reach here
    }
}

int Patch::resolve(int value) const {
    switch (m_patch_type) {
        case PatchType::JR:
            return value & 0xFF;
        case PatchType::N:
            return value & 0xFF; // Ensure it's a byte
        case PatchType::NN:
            return value & 0xFFFF; // Ensure it's a word
        default:
            assert(false && "Unknown patch type");
            return 0; // Should never reach here
    }
}

Instr::~Instr() {
    for (auto& patch : m_patches)
        delete patch;
    m_patches.clear();
}

Symtab* Instr::symtab() {
    return m_parent->symtab();
}

void Instr::add_opcode(long long opcode) {
    bool out = false;
    // add bytes in reverse order
    for (int byte = 7; byte > 0; --byte) {
        if (out || (opcode & (0xFFLL << (byte * 8))) != 0) {
            out = true;
            add_byte((opcode >> (byte * 8)) & 0xFF);
        }
    }

    // add last byte
    add_byte(opcode & 0xFF);
}

void Instr::add_patch(Patch* patch) {
    int value = 0;
    if (patch->expr()->eval_const(m_parent->symtab(), value)) {
        // If the expression evaluates to a constant, replace it with the value
        value = patch->resolve(value);
        int size = patch->size();
        for (int i = 0; i < size; ++i) {
            add_byte((value >> (i * 8)) & 0xFF);
        }
        delete patch; // No need to keep the patch if it's resolved
    }
    else {
        m_patches.push_back(patch);
        int size = patch->size();
        for (int i = 0; i < size; ++i) {
            add_byte(0); // reserve space for the patch
        }
    }
}

Section::Section(ObjModule* parent, const string& name)
    : m_parent(parent), m_name(name) {
}

Section::~Section() {
    for (auto& instr : m_instrs)
        delete instr;
    m_instrs.clear();
}

void Section::clear() {
    for (auto& instr : m_instrs)
        delete instr;
    m_instrs.clear();
    m_origin = 0;
}

int Section::asmpc() const {
    if (m_instrs.empty())
        return 0;
    else
        return m_instrs.back()->offset();
}

int Section::size() const {
    if (m_instrs.empty())
        return 0;
    else
        return m_instrs.back()->offset() + m_instrs.back()->size();
}

Symtab* Section::symtab() {
    return m_parent->symtab();
}

Instr* Section::add_instr() {
    auto instr = new Instr(this);
    instr->set_offset(size());
    m_instrs.push_back(instr);
    return instr;
}

Instr* Section::cur_instr() {
    if (m_instrs.empty())
        add_instr();
    return m_instrs.back();
}

ObjModule::ObjModule() {
    m_cur_section = new Section(this, "");
    m_sections.push_back(m_cur_section);
}

ObjModule::~ObjModule() {
    m_symtab.clear();
    for (auto& section : m_sections) {
        delete section;
    }
    m_sections.clear();
    m_cur_section = nullptr;
}

void ObjModule::clear() {
    m_symtab.clear();
    for (size_t i = 1; i < m_sections.size(); ++i)
        delete m_sections[i];
    m_sections.resize(1);
    m_cur_section = m_sections[0];
    m_cur_section->clear();
    m_assume = 0;

    // copy global symbols to the symbol table
    for (const auto& it : *g_global_defines) {
        assert(it.second->sym_type() == SymType::GLOBAL_DEF);
        Symbol* symbol = m_symtab.add_symbol(it.first);
        symbol->set_global_def(it.second->value());
    }
}

void ObjModule::set_cur_section(const string& name) {
    if (m_cur_section && m_cur_section->name() == name) {
        return; // already set
    }

    // Find existing section or create a new one
    for (auto& section : m_sections) {
        if (section->name() == name) {
            m_cur_section = section;
            return;
        }
    }

    // Create a new section if not found
    m_cur_section = new Section(this, name);
    m_sections.push_back(m_cur_section);
}

int ObjModule::asmpc() {
    return cur_section()->asmpc();
}

void ObjModule::add_label(const string& name) {
    Symbol* symbol = m_symtab.add_symbol(name);
    if (symbol) {
        Instr* instr = cur_section()->add_instr();
        instr->set_label(symbol);
        symbol->set_instr(instr);
    }
}

void ObjModule::add_define(const string& name, int value) {
    Symbol* symbol = m_symtab.add_symbol(name);
    if (symbol) {
        symbol->set_const(value);
    }
}

void ObjModule::add_define(const string& name, Expr* expr) {
    Symbol* symbol = m_symtab.add_symbol(name);
    if (symbol) {
        symbol->set_const(expr);
    }
}

void ObjModule::remove_define(const string& name) {
    m_symtab.remove_symbol(name);
}

void ObjModule::add_equ(const string& name, Expr* expr) {
    Symbol* symbol = m_symtab.add_symbol(name);
    if (symbol) {
        int value = 0;
        if (expr->eval_const(&m_symtab, value)) {
            symbol->set_const(value);
            delete expr;
        }
        else {
            symbol->set_expr(expr);
        }
    }
}

void ObjModule::add_opcode_void(long long opcode) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::JR, expr, instr->size()));
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::N, expr, instr->size()));
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::NN, expr, instr->size()));
}

