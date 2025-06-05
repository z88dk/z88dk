//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include "obj_module.h"
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

Instruction::~Instruction() {
    for (auto& patch : m_patches)
        delete patch;
}

void Instruction::add_opcode(long long opcode) {
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

void Instruction::add_patch(Patch* patch) {
    m_patches.push_back(patch);
    for (int i = 0; i < patch->size(); ++i) {
        add_byte(0); // reserve space for the patch
    }
}

Section::Section(const string& name)
    : m_name(name) {
}

Section::~Section() {
    for (auto& instr : m_instructions)
        delete instr;
    m_instructions.clear();
}

