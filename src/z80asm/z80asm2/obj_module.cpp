//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "options.h"
#include "symbol.h"
#include "utils.h"
#include <cassert>
#include <iostream>
#include <unordered_map>
using namespace std;

ObjModule* g_obj_module{ nullptr };

Patch::Patch(Instr* parent, PatchType patch_type, Expr* expr, int offset)
    : m_parent(parent), m_patch_type(patch_type), m_expr(expr), m_offset(offset) {
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

void Patch::resolve(int value) {
    *g_location = m_expr->location();    // prepare for errors
    switch (m_patch_type)
    {
    case PatchType::NONE:
        assert(false && "PatchType::NONE should not be used");
        break;

    case PatchType::ASSIGN:
        assert(false && "PatchType::ASSIGN should not be used here");
        break;

    case PatchType::D:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::D2DD:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, value < 0 || value > 127 ? 0xFF : 0);
        break;

    case PatchType::D2DDD:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, value < 0 || value > 127 ? 0xFF : 0);
        m_parent->patch_byte(m_offset + 2, value < 0 || value > 127 ? 0xFF : 0);
        break;

    case PatchType::HOFFSET:
        if ((value & 0xFF00) != 0) {
            if ((value & 0xFF00) != 0xFF00)
                g_error->warning_int_range(int_to_hex(value, 2));
        }
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::JR:
        value -= m_parent->offset() + m_parent->size(); // relative to the next instruction
        if (value < -128 || value > 127)
            g_error->error_int_range(int_to_hex(value, 2));
        else
            m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::JRE:
        value -= m_parent->offset() + m_parent->size(); // relative to the next instruction
        if (value < -0x8000 || value > 0x7FFF)
            g_error->error_int_range(int_to_hex(value, 4));
        else {
            m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
            m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        }
        break;

    case PatchType::N:
        if (value < -128 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::N2NN:
        if (value < 0 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, 0);
        break;

    case PatchType::N2NNN:
        if (value < 0 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, 0);
        m_parent->patch_byte(m_offset + 2, 0);
        break;

    case PatchType::NN:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        break;

    case PatchType::NNN:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        m_parent->patch_byte(m_offset + 2, (value >> 16) & 0xFF);
        break;

    case PatchType::NNNN:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        m_parent->patch_byte(m_offset + 2, (value >> 16) & 0xFF);
        m_parent->patch_byte(m_offset + 3, (value >> 24) & 0xFF);
        break;

    case PatchType::NN_BE:
        m_parent->patch_byte(m_offset + 0, (value >> 8) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 0) & 0xFF);
        break;

    default:
        assert(false && "Unknown patch type");
    }
    g_location->clear();
}

Instr::Instr(Section* parent)
    : m_parent(parent) {
    m_location = *g_location;
}

Instr::~Instr() {
    for (auto& patch : m_patches)
        delete patch;
    m_patches.clear();
}

void Instr::patch_byte(int index, uint8_t byte) {
    assert(index >= 0 && index < static_cast<int>(m_bytes.size()) && "Index out of bounds");
    m_bytes[index] = byte;
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
    // reserve space for the patch
    int size = patch->size();
    for (int i = 0; i < size; ++i) {
        add_byte(0); 
    }

    // If the expression evaluates to a constant, replace it with the value
    int value = 0;
    if (patch->expr()->eval_const(value)) {
        patch->resolve(value);
        delete patch; // No need to keep the patch if it's resolved
    }
    else {
        m_patches.push_back(patch);
    }
}

void Instr::expand_jr() {
    assert(m_patches.size() == 1
        && "Only one patch expected for expansion");
    assert(m_patches[0]->patch_type() == PatchType::JR
        && "Only JR patch expected for expansion");
    int opcode_index = m_patches[0]->offset() - 1;
    assert(opcode_index >= 0 && opcode_index < size()
        && "Opcode index out of bounds");
    int opcode = m_bytes[opcode_index];

    switch (opcode) {
    case 0x10: // DJNZ
        m_bytes[opcode_index] = 0x05; // Change to DEC B
        m_bytes[opcode_index + 1] = 0xC2; // Change to JP NZ
        m_patches[0]->set_patch_type(PatchType::NN);
        m_patches[0]->set_offset(opcode_index + 2);
        m_bytes.push_back(0x00); // two more bytes
        m_bytes.push_back(0x00); 
        break;
    case 0x18: // JR
        m_bytes[opcode_index] = 0xC3; // Change to JP
        m_patches[0]->set_patch_type(PatchType::NN);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x20: // JR NZ
        m_bytes[opcode_index] = 0xC2; // Change to JP NZ
        m_patches[0]->set_patch_type(PatchType::NN);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x28: // JR Z
        m_bytes[opcode_index] = 0xCA; // Change to JP Z
        m_patches[0]->set_patch_type(PatchType::NN);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x30: // JR NC
        m_bytes[opcode_index] = 0xD2; // Change to JP NC
        m_patches[0]->set_patch_type(PatchType::NN);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x38: // JR C
        m_bytes[opcode_index] = 0xDA; // Change to JP C
        m_patches[0]->set_patch_type(PatchType::NN);
        m_bytes.push_back(0x00); // one more byte
        break;
    default:
        assert(false && "Unexpected opcode for JR expansion");
    }
}

void Instr::resolve_local_exprs() {
    for (auto it = m_patches.begin(); it != m_patches.end(); ) {
        Patch* patch = *it;
        Expr* expr = patch->expr();

        *g_location = expr->location(); // prepare for errors

        int value = 0;
        if (expr->eval_const(value)) {
            // If the expression is local, resolve it
            patch->resolve(value);
            it = m_patches.erase(it); // Remove the patch
        }
        else {
            // If the expression is not local, keep it for later resolution
            ++it;
        }

        g_location->clear();
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

void Section::expand_jrs() {
    bool did_expand = false;
    do {
        for (auto& instr : m_instrs) {
            for (auto& patch : instr->patches()) {
                if (patch->patch_type() == PatchType::JR) {
                    int target = 0;
                    if (patch->expr()->eval(target, true)) {
                        int pos = instr->offset() + instr->size();
                        int distance = target - pos;
                        if (distance < -128 || distance > 127) {
                            instr->expand_jr();
                            recompute_offsets();
                            did_expand = true;
                        }
                    }
                }
            }
        }
    } while (did_expand);    
}

void Section::recompute_offsets() {
    int offset = 0;
    for (auto& instr : m_instrs) {
        instr->set_offset(offset);
        offset += instr->size();
    }
}

void Section::resolve_local_exprs() {
    for (auto& instr : m_instrs) {
        instr->resolve_local_exprs();
    }
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

// copy global symbols to the symbol table
void ObjModule::define_global_defs() {
    for (const auto& it : *g_global_defines) {
        assert(it.second->is_global_def() && "Only GLOBAL_DEF expected");
        m_symtab.add_global_def(it.first, it.second->value());
    }
}

// create symbols for the current CPU
void ObjModule::define_cpu_defs(Cpu cpu_id) {
    for (auto& define : g_cpu_table->all_defines()) {
        g_global_defines->remove_symbol(define);
        m_symtab.remove_symbol(define);
    }

    for (auto& define : g_cpu_table->cpu_defines(cpu_id)) {
        g_global_defines->add_global_def(define);
        m_symtab.add_global_def(define);
    }
}

// replace jr to distances too far with jp
void ObjModule::expand_jrs() {
    for (auto& section : m_sections)
        section->expand_jrs();
}

bool ObjModule::has_undefined_symbols() const {
    return m_symtab.has_undefined_symbols();
}

void ObjModule::resolve_local_exprs() const {
    for (auto& section : m_sections) {
        section->resolve_local_exprs();
    }
}

void ObjModule::add_global_def(const string& name, int value) {
    if (g_options->parsing_command_line())
        g_global_defines->add_global_def(name, value);
    else
       m_symtab.add_global_def(name, value);
}

void ObjModule::add_label(const string& name) {
    Instr* instr = cur_section()->add_instr();
    m_symtab.add_label(name, instr);
}

void ObjModule::add_equ(const string& name, Expr* expr) {
    m_symtab.add_equ(name, expr);
}

void ObjModule::add_opcode_void(long long opcode) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::JR, expr, instr->size()));
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::N, expr, instr->size()));
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::NN, expr, instr->size()));
}

bool ObjModule::write_file(const string& filename) const {
    (void)filename;
    return false;
}

