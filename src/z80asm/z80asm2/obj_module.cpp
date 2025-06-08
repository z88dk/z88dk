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

ObjModule g_obj_module;

Patch::Patch(PatchType patch_type, Expr* expr, int offset)
    : m_patch_type(patch_type), m_expr(expr), m_offset(offset) {
}

Patch::~Patch() {
    delete m_expr;
}

int Patch::size() const {
    static unordered_map<PatchType, int> patch_sizes = {
        //@@BEGIN: patch_sizes
        { PatchType::JR, 1 },
        { PatchType::N, 1 },
        { PatchType::NN, 2 },
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

Instr::~Instr() {
    for (auto& patch : m_patches)
        delete patch;
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
    m_patches.push_back(patch);
    for (int i = 0; i < patch->size(); ++i) {
        add_byte(0); // reserve space for the patch
    }
}

Section::Section(const string& name)
    : m_name(name) {
}

Section::~Section() {
    for (auto& instr : m_instrs)
        delete instr;
    m_instrs.clear();
}

int Section::get_asmpc() const {
    if (m_instrs.empty())
        return 0;
    else
        return m_instrs.back()->get_offset();
}

int Section::get_size() const {
    if (m_instrs.empty())
        return 0;
    else
        return m_instrs.back()->get_offset() +
        m_instrs.back()->size();
}

Instr* Section::add_instr() {
    auto instr = new Instr();
    instr->set_offset(get_size());
    m_instrs.push_back(instr);
    return instr;
}

Instr* Section::get_cur_instr() {
    if (m_instrs.empty())
        add_instr();
    return m_instrs.back();
}

ObjModule::ObjModule() {
    set_cur_section(""); // reset to default section
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
    for (auto& section : m_sections) {
        delete section;
    }
    m_sections.clear();
    set_cur_section(""); // reset to default section
    m_assume = 0;

    // copy global symbols to the symbol table
    for (const auto& it : g_global_defines) {
        assert(it.second->get_sym_type() == SymType::GLOBAL_DEF);
        Symbol* symbol = m_symtab.add_symbol(it.first);
        symbol->set_global_def(it.second->get_value());
    }
}

void ObjModule::set_cur_section(const string& name) {
    if (m_cur_section && m_cur_section->get_name() == name) {
        return; // already set
    }

    // Find existing section or create a new one
    for (auto& section : m_sections) {
        if (section->get_name() == name) {
            m_cur_section = section;
            return;
        }
    }

    // Create a new section if not found
    m_cur_section = new Section(name);
    m_sections.push_back(m_cur_section);
}

int ObjModule::get_asmpc() {
    return get_cur_section()->get_asmpc();
}

void ObjModule::add_label(const string& name) {
    Symbol* symbol = m_symtab.add_symbol(name);
    if (symbol) {
        Instr* instr = get_cur_section()->add_instr();
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
    Instr* instr = get_cur_section()->add_instr();
    instr->add_opcode(opcode);
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    Instr* instr = get_cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::JR, expr, instr->get_offset()));
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    Instr* instr = get_cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::N, expr, instr->get_offset()));
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    Instr* instr = get_cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(PatchType::NN, expr, instr->get_offset()));
}

