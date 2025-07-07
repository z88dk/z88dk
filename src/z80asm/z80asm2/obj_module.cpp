//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "expr.h"
#include "obj_module.h"
#include "options.h"
#include "symbol.h"
#include "utils.h"
#include <cassert>
#include <fstream>
#include <iostream>
#include <unordered_map>
using namespace std;

ObjModule* g_obj_module{ nullptr };

Patch::Patch(Instr* parent, PatchType patch_type, const Expr& expr, int offset)
    : m_parent(parent), m_patch_type(patch_type), m_expr(expr), m_offset(offset) {
}

Patch::Patch(const Patch& other) {
    m_parent = other.m_parent;
    m_patch_type = other.m_patch_type;
    m_expr = other.m_expr;
    m_offset = other.m_offset;
    m_target_name = other.m_target_name; 
}

Patch::~Patch() {
}

Patch& Patch::operator=(const Patch& other) {
    if (this != &other) {
        m_parent = other.m_parent;
        m_patch_type = other.m_patch_type;
        m_expr = other.m_expr;
        m_offset = other.m_offset;
        m_target_name = other.m_target_name;
    }
    return *this;
}

int Patch::size() const {
    static unordered_map<PatchType, int> patch_sizes = {
        //@@BEGIN: patch_sizes
        { PatchType::UNDEFINED, -1 },
        { PatchType::JR_OFFSET, 1 },
        { PatchType::BYTE_UNSIGNED, 1 },
        { PatchType::BYTE_SIGNED, 1 },
        { PatchType::WORD, 2 },
        { PatchType::WORD_BE, 2 },
        { PatchType::DWORD, 4 },
        { PatchType::BYTE_TO_WORD_UNSIGNED, 2 },
        { PatchType::BYTE_TO_WORD_SIGNED, 2 },
        { PatchType::PTR24, 3 },
        { PatchType::HIGH_OFFSET, 1 },
        { PatchType::ASSIGNMENT, 0 },
        { PatchType::JRE_OFFSET, 2 },
        { PatchType::BYTE_TO_PTR_UNSIGNED, 3 },
        { PatchType::BYTE_TO_PTR_SIGNED, 3 },
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

void Patch::resolve(int value) const {
    *g_location = m_expr.location();    // prepare for errors

    switch (m_patch_type)
    {
    case PatchType::UNDEFINED:
        assert(false && "PatchType::UNDEFINED should not be used");
        break;

    case PatchType::ASSIGNMENT:
        // nothing to do
        break;

    case PatchType::BYTE_SIGNED:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::BYTE_TO_WORD_SIGNED:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, value < 0 || value > 127 ? 0xFF : 0);
        break;

    case PatchType::BYTE_TO_PTR_SIGNED:
        if (value < -128 || value > 127)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, value < 0 || value > 127 ? 0xFF : 0);
        m_parent->patch_byte(m_offset + 2, value < 0 || value > 127 ? 0xFF : 0);
        break;

    case PatchType::HIGH_OFFSET:
        if ((value & 0xFF00) != 0) {
            if ((value & 0xFF00) != 0xFF00)
                g_error->warning_int_range(int_to_hex(value, 2));
        }
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::JR_OFFSET:
        if (value < -128 || value > 127)
            g_error->error_int_range(int_to_hex(value, 2));
        else
            m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::JRE_OFFSET:
        if (value < -0x8000 || value > 0x7FFF)
            g_error->error_int_range(int_to_hex(value, 4));
        else {
            m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
            m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        }
        break;

    case PatchType::BYTE_UNSIGNED:
        if (value < -128 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::BYTE_TO_WORD_UNSIGNED:
        if (value < 0 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, 0);
        break;

    case PatchType::BYTE_TO_PTR_UNSIGNED:
        if (value < 0 || value > 255)
            g_error->warning_int_range(int_to_hex(value, 2));
        m_parent->patch_byte(m_offset + 0, value & 0xFF);
        m_parent->patch_byte(m_offset + 1, 0);
        m_parent->patch_byte(m_offset + 2, 0);
        break;

    case PatchType::WORD:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        break;

    case PatchType::PTR24:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        m_parent->patch_byte(m_offset + 2, (value >> 16) & 0xFF);
        break;

    case PatchType::DWORD:
        m_parent->patch_byte(m_offset + 0, (value >> 0) & 0xFF);
        m_parent->patch_byte(m_offset + 1, (value >> 8) & 0xFF);
        m_parent->patch_byte(m_offset + 2, (value >> 16) & 0xFF);
        m_parent->patch_byte(m_offset + 3, (value >> 24) & 0xFF);
        break;

    case PatchType::WORD_BE:
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

bool Instr::empty() const {
    return m_bytes.empty() && m_patches.empty();
}

void Instr::add_word(uint16_t word) {
    add_byte(word & 0xFF);
    add_byte((word >> 8) & 0xFF);
}

void Instr::add_word_be(uint16_t word) {
    add_byte((word >> 8) & 0xFF);
    add_byte(word & 0xFF);
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

void Instr::add_patch(const Patch& patch) {
    // reserve space for the patch
    int size = patch.size();
    for (int i = 0; i < size; ++i) {
        add_byte(0); 
    }

    // If the expression evaluates to a constant, replace it with the value
    int value = 0;
    if (patch.patch_type() != PatchType::ASSIGNMENT &&
        patch.expr().eval_const(value)) {
        patch.resolve(value);
        // No need to keep the patch if it's resolved
    }
    else {
        m_patches.push_back(patch);
    }
}

void Instr::include_binary(const string& filename_) {
    string filename = sanitize_pathname(filename_);
    ifstream ifs(filename, ios::binary);
    if (!ifs.is_open())
        g_error->error_open_file(filename);
    else {
        // find the size of the file
        ifs.seekg(0, ios::end);
        auto size = ifs.tellg();
        ifs.seekg(0, ios::beg);

        // append to bytes
        if (size > 0) {
            vector<uint8_t> buffer(static_cast<size_t>(size));
            ifs.read(reinterpret_cast<char*>(buffer.data()), size);
            m_bytes.insert(m_bytes.end(), buffer.begin(), buffer.end());
        }
    }
}

void Instr::expand_jr() {
    assert(m_patches.size() == 1
        && "Only one patch expected for expansion");
    assert(m_patches[0].patch_type() == PatchType::JR_OFFSET
        && "Only JR patch expected for expansion");
    int opcode_index = m_patches[0].offset() - 1;
    assert(opcode_index >= 0 && opcode_index < size()
        && "Opcode index out of bounds");
    int opcode = m_bytes[opcode_index];

    switch (opcode) {
    case 0x10: // DJNZ
        m_bytes[opcode_index] = 0x05; // Change to DEC B
        m_bytes[opcode_index + 1] = 0xC2; // Change to JP NZ
        m_patches[0].set_patch_type(PatchType::WORD);
        m_patches[0].set_offset(opcode_index + 2);
        m_bytes.push_back(0x00); // two more bytes
        m_bytes.push_back(0x00); 
        break;
    case 0x18: // JR
        m_bytes[opcode_index] = 0xC3; // Change to JP
        m_patches[0].set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x20: // JR NZ
        m_bytes[opcode_index] = 0xC2; // Change to JP NZ
        m_patches[0].set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x28: // JR Z
        m_bytes[opcode_index] = 0xCA; // Change to JP Z
        m_patches[0].set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x30: // JR NC
        m_bytes[opcode_index] = 0xD2; // Change to JP NC
        m_patches[0].set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x38: // JR C
        m_bytes[opcode_index] = 0xDA; // Change to JP C
        m_patches[0].set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    default:
        assert(false && "Unexpected opcode for JR expansion");
    }
}

void Instr::resolve_local_exprs() {
    for (auto it = m_patches.begin(); it != m_patches.end();) {
        Patch& patch = *it;
        const Expr& expr = patch.expr();

        *g_location = expr.location(); // prepare for errors

        if (!patch.target_name().empty()) {     // DEFC
            assert(patch.patch_type() == PatchType::ASSIGNMENT && "assignment expected");
            auto symbol = g_obj_module->symtab()->get_symbol(patch.target_name());
            assert(symbol && "symbol must be defined");
            if (symbol->set_expr(expr))         // resolve constants and labels
                it = m_patches.erase(it);
            else
                ++it;
        }
        else {                                  // patch
            int value = 0;
            if (resolve_local_jrs(patch)) {
                // If the patch was resolved as a local jump, remove it
                it = m_patches.erase(it);
            }
            else if (expr.eval_const(value)) {
                // If the expression is local, resolve it
                patch.resolve(value);
                it = m_patches.erase(it); // Remove the patch
            }
            else {
                // If the expression is not local, keep it for later resolution
                ++it;
            }
        }
        

        g_location->clear();
    }
}

bool Instr::resolve_local_jrs(const Patch& patch) {
    // Check if the patch is a local jump and resolve it
    if (patch.patch_type() == PatchType::JR_OFFSET) {
    
        int distance = 0;
        if (patch.expr().eval_local_jr_distance(distance)) {
            if (distance >= -128 && distance <= 127) {
                patch.resolve(distance);
                return true; // Resolved as a local jump
            }
        }
    }
    return false; // Not resolved
}

Section::Section(ObjModule* parent, const string& name)
    : m_parent(parent), m_name(name) {
    auto instr = new Instr(this);
    m_instrs.push_back(instr);
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
    if (g_options->origin() != ORG_NOT_DEFINED) {
        m_origin = g_options->origin();
        m_origin_option = true;
        check_org_align();
    }
    else {
        m_origin = ORG_NOT_DEFINED;
    }
    m_align = 1;

    auto instr = new Instr(this);
    m_instrs.push_back(instr);
}

void Section::set_origin(int origin) {
    if (m_origin_defined) {
        g_error->error_origin_redefined();
    }
    else {
        m_origin_defined = true;
        if (origin == -1)
            m_section_split = true;
        else if (origin >= 0) {
            if (m_origin_option && m_origin != ORG_NOT_DEFINED)
                ; // ignore ORG as command line overrides
            else {
                m_origin = origin;
                check_org_align();
            }
        }
        else
            g_error->error_int_range(int_to_hex(origin, 4));
    }
}

void Section::set_align(int align, int filler) {
    if (align < 1 || align > 0xFFFF) {
        g_error->error_int_range(int_to_hex(align, 2));
    }
    else if (filler < 0 || filler > 0xFF) {
        g_error->error_int_range(int_to_hex(filler, 2));
    }
    else if (size() == 0) {     // define section alignment
        if (m_align_found)
            g_error->error_align_redefined();
        else {
            m_align_found = true;
            m_align = align;
            check_org_align();
        }
    }
    else {                      // reserve space
        int pc = size();
        int next = (pc + align - 1) / align * align;
        int fill = next - pc;
        if (fill > 0) {
            Instr* instr = add_instr();
            for (int i = 0; i < fill; ++i)
                instr->add_byte(filler);
        }
    }
}

void Section::check_org_align() {
    if (m_origin >= 0 && m_align > 1 && (m_origin % m_align) != 0)
        g_error->error_org_not_aligned();
}

Instr* Section::asmpc() const {
    assert(!m_instrs.empty() && "instrs empty");
    return m_instrs.back();
}

int Section::size() const {
    assert(!m_instrs.empty() && "instrs empty");
    return asmpc()->offset() + asmpc()->size();
}

Symtab* Section::symtab() {
    return m_parent->symtab();
}

Instr* Section::add_instr() {
    auto instr = asmpc();
    if (!instr->empty()) {
        instr = new Instr(this);
        instr->set_offset(size());
        m_instrs.push_back(instr);
    }
    instr->set_location(*g_location);
    return instr;
}

void Section::include_binary(const string& filename) {
    auto instr = add_instr();
    instr->include_binary(filename);
}

void Section::expand_jrs() {
    bool did_expand;
    do {
        did_expand = false;
        for (auto& instr : m_instrs) {
            for (auto& patch : instr->patches()) {
                if (patch.patch_type() == PatchType::JR_OFFSET) {
                    int distance = 0;
                    if (patch.expr().eval_local_jr_distance(distance)) {
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

Section* ObjModule::cur_section() const {
    assert(m_cur_section != nullptr && "cur_section cannot be nullptr");
    return m_cur_section;
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

Instr* ObjModule::asmpc() const {
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

    switch (cpu_id) {
    case Cpu::EZ80:
    case Cpu::EZ80_STRICT:
        m_assume = 1;
        break;
    case Cpu::EZ80_Z80:
    case Cpu::EZ80_Z80_STRICT:
        m_assume = 0;
        break;
    default:;
    }
}

void ObjModule::define_arch_defs(Arch arch) {
    for (auto& define : g_arch_table->all_defines()) {
        g_global_defines->remove_symbol(define);
        m_symtab.remove_symbol(define);
    }

    for (auto& define : g_arch_table->arch_defines(arch)) {
        g_global_defines->add_global_def(define);
        m_symtab.add_global_def(define);
    }
}

// replace jr to distances too far with jp
void ObjModule::expand_jrs() {
    for (auto& section : m_sections)
        section->expand_jrs();
}

void ObjModule::convert_global_to_extern_public() {
    m_symtab.convert_global_to_extern_public();
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

void ObjModule::add_equ(const string& name, const Expr& expr) {
    m_symtab.add_equ(name, expr);
    Instr* instr = cur_section()->add_instr();
    Patch patch{ instr, PatchType::ASSIGNMENT, expr, instr->size() };
    patch.set_target_name(name);
    instr->add_patch(patch);
}

void ObjModule::declare_extern(const string& name) {
    m_symtab.declare_extern(name);
}

void ObjModule::declare_public(const string& name) {
    m_symtab.declare_public(name);
}

void ObjModule::declare_global(const string& name) {
    m_symtab.declare_global(name);
}

void ObjModule::set_origin(int origin) {
    m_cur_section->set_origin(origin);
}

void ObjModule::set_align(int align, int filler) {
    m_cur_section->set_align(align, filler);
}

void ObjModule::assert_(bool ok, const string& message) {
    if (!ok) 
        g_error->error_assertion_failed(message);
}

void ObjModule::set_assume(int value) {
    if (value < 0 || value > 1) {
        g_error->error_int_range(int_to_hex(value, 1));
    }
    else {
        m_assume = value;
        switch (g_options->cpu_id()) {
        case Cpu::EZ80:
            if (m_assume == 0) {
                g_options->set_cpu_id(Cpu::EZ80_Z80);
                define_cpu_defs(g_options->cpu_id());
            }
            break;

        case Cpu::EZ80_STRICT:
            if (m_assume == 0) {
                g_options->set_cpu_id(Cpu::EZ80_Z80_STRICT);
                define_cpu_defs(g_options->cpu_id());
            }
            break;

        case Cpu::EZ80_Z80:
            if (m_assume == 1) {
                g_options->set_cpu_id(Cpu::EZ80);
                define_cpu_defs(g_options->cpu_id());
            }
            break;

        case Cpu::EZ80_Z80_STRICT:
            if (m_assume  == 1) {
                g_options->set_cpu_id(Cpu::EZ80_STRICT);
                define_cpu_defs(g_options->cpu_id());
            }
            break;

        default:
            g_error->error_illegal_opcode();
        }
    }
}

void ObjModule::include_binary(const string& filename) {
    cur_section()->include_binary(filename);
}

void ObjModule::call_oz(int value) {
    if (g_options->arch() != Arch::Z88)
        g_error->error_illegal_opcode();
    else if (value > 0 && value <= 255) {
        auto instr = cur_section()->add_instr();
        instr->add_opcode(Z80_RST(0x20));
        instr->add_byte(value);
    }
    else if (value > 255) {
        auto instr = cur_section()->add_instr();
        instr->add_opcode(Z80_RST(0x20));
        instr->add_word(value);
    }
    else
        g_error->error_int_range(int_to_hex(value, 4));
}

void ObjModule::call_pkg(int value) {
    if (g_options->arch() != Arch::Z88)
        g_error->error_illegal_opcode();
    else if (value >= 0) {
        auto instr = cur_section()->add_instr();
        instr->add_opcode(Z80_RST(0x08));
        instr->add_word(value);
    }
    else
        g_error->error_int_range(int_to_hex(value, 4));
}

void ObjModule::add_cu_wait(int ver, int hor) {
    if (g_options->arch() != Arch::ZXN &&
        g_options->cpu_id() != Cpu::Z80N &&
        g_options->cpu_id() != Cpu::Z80N_STRICT)
        g_error->error_illegal_opcode();
    else if (ver < 0 || ver > 311)
        g_error->error_int_range(int_to_hex(ver, 4));
    else if (hor < 0 || hor > 55)
        g_error->error_int_range(int_to_hex(hor, 4));
    else {
        auto instr = cur_section()->add_instr();
        instr->add_word_be(0x8000 + (hor << 9) + ver);
    }
}

void ObjModule::add_cu_move(int reg, int val) {
    if (g_options->arch() != Arch::ZXN &&
        g_options->cpu_id() != Cpu::Z80N &&
        g_options->cpu_id() != Cpu::Z80N_STRICT)
        g_error->error_illegal_opcode();
    else if (reg < 0 || reg > 127)
        g_error->error_int_range(int_to_hex(reg, 4));
    else if (val < 0 || val > 255)
        g_error->error_int_range(int_to_hex(val, 4));
    else {
        auto instr = cur_section()->add_instr();
        instr->add_word_be((reg << 8) + val);
    }
}

void ObjModule::add_cu_stop() {
    if (g_options->arch() != Arch::ZXN &&
        g_options->cpu_id() != Cpu::Z80N &&
        g_options->cpu_id() != Cpu::Z80N_STRICT)
        g_error->error_illegal_opcode();
    else {
        auto instr = cur_section()->add_instr();
        instr->add_word_be(0xFFFF);
    }
}

void ObjModule::add_cu_nop() {
    if (g_options->arch() != Arch::ZXN &&
        g_options->cpu_id() != Cpu::Z80N &&
        g_options->cpu_id() != Cpu::Z80N_STRICT)
        g_error->error_illegal_opcode();
    else {
        auto instr = cur_section()->add_instr();
        instr->add_word_be(0x0000);
    }
}

void ObjModule::add_byte_list(const vector<Expr>& exprs) {
    Instr* instr = cur_section()->add_instr();
    for (auto& expr : exprs) {
        instr->add_patch(Patch(instr, PatchType::BYTE_UNSIGNED, expr, instr->size()));
    }
}

void ObjModule::add_word_list(const vector<Expr>& exprs) {
    Instr* instr = cur_section()->add_instr();
    for (auto& expr : exprs) {
        instr->add_patch(Patch(instr, PatchType::WORD, expr, instr->size()));
    }
}

void ObjModule::add_word_be_list(const vector<Expr>& exprs) {
    Instr* instr = cur_section()->add_instr();
    for (auto& expr : exprs) {
        instr->add_patch(Patch(instr, PatchType::WORD_BE, expr, instr->size()));
    }
}

void ObjModule::add_ptr_list(const vector<Expr>& exprs) {
    Instr* instr = cur_section()->add_instr();
    for (auto& expr : exprs) {
        instr->add_patch(Patch(instr, PatchType::PTR24, expr, instr->size()));
    }
}

void ObjModule::add_dword_list(const vector<Expr>& exprs) {
    Instr* instr = cur_section()->add_instr();
    for (auto& expr : exprs) {
        instr->add_patch(Patch(instr, PatchType::DWORD, expr, instr->size()));
    }
}

void ObjModule::add_defs(int size, int filler) {
    if (size < 0)
        g_error->error_int_range(int_to_hex(size, 4));
    else if (filler < 0 || filler > 0xFF)
        g_error->error_int_range(int_to_hex(filler, 2));
    else {
        Instr* instr = cur_section()->add_instr();
        for (int i = 0; i < size; ++i)
            instr->add_byte(filler);
    }
}

void ObjModule::add_defs(int size, const string& str) {
    if (size < 0)
        g_error->error_int_range(int_to_hex(size, 4));
    else if (static_cast<int>(str.size()) > size)
        g_error->error_string_too_long(str);
    else {
        Instr* instr = cur_section()->add_instr();
        for (int i = 0; i < size; ++i) {
            if (i < static_cast<int>(str.size()))
                instr->add_byte(str[i]);
            else
                instr->add_byte(g_options->filler());
        }
    }
}

bool ObjModule::get_dma_byte(deque<int>& params, int& value) {
    if (params.empty()) {
        g_error->error_dma_missing_argument();
        return false;
    }

    value = params.front(); params.pop_front();
    if (value < 0 || value > 0xFF) {
        g_error->error_int_range(int_to_hex(value, 2));
        return false;
    }

    return true;
}

bool ObjModule::get_dma_word(deque<int>& params, int& value) {
    if (params.empty()) {
        g_error->error_dma_missing_argument();
        return false;
    }

    value = params.front(); params.pop_front();
    if (value < 0 || value > 0xFFFF) {
        g_error->error_int_range(int_to_hex(value, 4));
        return false;
    }

    return true;
}

void ObjModule::add_dma_cmd(Keyword cmd, const vector<int>& params_) {
    if (g_options->arch() != Arch::ZXN &&
        g_options->cpu_id() != Cpu::Z80N &&
        g_options->cpu_id() != Cpu::Z80N_STRICT) {
        g_error->error_illegal_opcode();
        return;
    }

    Instr* instr = cur_section()->add_instr();

    int N, W;
    deque<int> params(params_.begin(), params_.end());

    // retrieve first constant expression
    if (!get_dma_byte(params, N))
        return;

    // retrieve next arguments
    switch (cmd) {
    case Keyword::WR0:
        /*
        dma.wr0 n [, w, x, y, z] with whitespace following comma including newline and
        maybe comment to the end of the line so params can be listed on following lines
        n: bit 7 must be 0, bits 1..0 must be 01 else error "base register byte is illegal"

        If bit 3 of n is set then accept one following byte\
        If bit 4 of n is set then accept one following byte/ set together, expect word instead
        If bit 5 of n is set then accept one following byte\
        If bit 6 of n is set then accept one following byte/ set together, expect word instead
        */
        if ((N & 0x83) != 0x01) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }

        // add command byte
        instr->add_byte(N & 0xFF);

        // parse WR0 parameters: check bits 3,4
        switch (N & 0x18) {
        case 0:
            break;

        case 0x08:      // bit 3
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
            break;

        case 0x10:      // bit 4
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
            break;

        case 0x18:      // bits 3,4
            if (!get_dma_word(params, W))
                return;
            instr->add_word(W & 0xFFFF);
            break;

        default:
            assert(false && "Unexpected WR0 parameter bits");
        }

        // parse WR0 parameters: check bits 5,6
        switch (N & 0x60) {
        case 0:
            break;

        case 0x20:      // bit 5
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
            break;

        case 0x40:      // bit 6
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
            break;

        case 0x60:      // bits 5,6
            if (!get_dma_word(params, W))
                return;
            instr->add_word(W & 0xFFFF);
            break;

        default:
            assert(false && "Unexpected WR0 parameter bits");
        }

        break;

    case Keyword::WR1:
        /*
        dma.wr1 n [,w]
        or 0x04 into n
        n: bit 7 must be 0, bits 2..0 must be 100 else error "base register byte is illegal"
        If bit 6 of n is set then accept one following byte w.

        In w bits 5..4 must be 0, bits 1..0 must not be 11 error "port A timing is illegal"
        In w if any of bits 7,6,3,2 are set warning "dma does not support half cycle timing"
        */
        if (((N & 0x87) | 0x04) != 0x04) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }
        N |= 0x04;

        // add command byte
        instr->add_byte(N & 0xFF);

        if (N & 0x40) {
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);

            if ((W & 0x30) != 0 || (W & 0x03) == 0x03) {
                g_error->error_dma_illegal_port_a_timing();
                return;
            }

            if (W & 0xCC)
                g_error->warning_dma_half_cycle_timing();
        }

        break;

    case Keyword::WR2:
        /*
        dma.wr2 n [,w,x]
        n: bit 7 must be 0, bits 2..0 must be 000 else error "base register byte is illegal"
        If bit 6 of n is set then accept one following byte w

        In w bit 4 must be 0, bits 1..0 must not be 11 error "port B timing is illegal"
        In w if any of bits 7,6,3,2 are set warning "dma does not support half cycle timing"
        If bit 5 of w is set then accept one following byte x that can be anything.
        */
        if ((N & 0x87) != 0x00) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }

        // add command byte
        instr->add_byte(N & 0xFF);

        if (N & 0x40) {
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);

            if ((W & 0x10) != 0 || (W & 0x03) == 0x03) {
                g_error->error_dma_illegal_port_b_timing();
                return;
            }

            if (W & 0xCC)
                g_error->warning_dma_half_cycle_timing();

            if (W & 0x20) {
                if (!get_dma_byte(params, W))
                    return;
                instr->add_byte(W & 0xFF);
            }
        }

        break;

    case Keyword::WR3:
        /*
        dma.wr3 n [,w,x]
        or 0x80 into n
        n: bit 7 must be 1, bits 1..0 must be 00 else error "base register byte is illegal"
        If any of bits 6,5,2 of n are set then warning "dma does not support some features"

        If bit 3 of n is set then accept one following byte that can be anything.
        If bit 4 of n is set then accept one following byte that can be anything.
        */
        if (((N & 0x83) | 0x80) != 0x80) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }
        N |= 0x80;

        // add command byte
        instr->add_byte(N & 0xFF);

        if (N & 0x64)
            g_error->warning_dma_unsupported_features();

        if (N & 0x08) {
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
        }

        if (N & 0x10) {
            if (!get_dma_byte(params, W))
                return;
            instr->add_byte(W & 0xFF);
        }

        break;

    case Keyword::WR4:
        /*
        dma.wr4 n, [w,x]
        or 0x81 into n
        n: bit 7 must be 1, bits 1..0 must be 01 else error "base register byte is illegal"
        If bit 4 of n is set then error "dma does not support interrupts"
        If bits 6..5 of n are 00 or 11 error "dma mode is illegal"
        If bit 2 of n is set then accept one following byte\
        If bit 3 of n is set then accept one following byte/ set together, expect word instead

        Again if both bits 2 & 3 are set, w,x must be combined into a single word parameter.
        */
        if (((N & 0x83) | 0x81) != 0x81) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }

        if (N & 0x10) {
            g_error->error_dma_unsupported_interrupts();
            return;
        }

        if ((N & 0x60) == 0 || (N & 0x60) == 0x60) {
            g_error->error_dma_illegal_mode();
            return;
        }

        N |= 0x81;

        // add command byte
        instr->add_byte(N & 0xFF);

        if ((N & 0x0C) == 0x0C) {
            if (!get_dma_word(params, W))
                return;
            instr->add_word(W & 0xFFFF);
        }
        else {
            if (N & 0x04) {
                if (!get_dma_byte(params, W))
                    return;
                instr->add_byte(W & 0xFF);
            }

            if (N & 0x08) {
                if (!get_dma_byte(params, W))
                    return;
                instr->add_byte(W & 0xFF);
            }
        }

        break;

    case Keyword::WR5:
        /*
        dma.wr5 n
        or 0x82 into n
        n: bits 7..6 must be 10, bits 2..0 must be 010 else error "base register byte is illegal"
        If bit 3 of n is set then warning "dma does not support ready signals"
        */
        if (((N & 0xC7) | 0x82) != 0x82) {
            g_error->error_dma_base_register_illegal(int_to_hex(N, 2));
            return;
        }

        N |= 0x82;

        if (N & 0x08)
            g_error->warning_dma_unsupported_ready_signal();

        // add command byte
        instr->add_byte(N & 0xFF);

        break;

    case Keyword::WR6:
        /*
        dma.wr6 n [,w] or dma.cmd n [,w]
        n:
        accept 0xcf, 0xd3, 0x87, 0x83, 0xbb
        warning on 0xc3, 0xc7, 0xcb, 0xaf, 0xab, 0xa3, 0xb7, 0xbf, 0x8b, 0xa7, 0xb3
        "dma does not implement this command"
        anything else error "illegal dma command"

        if n = 0xbb accept a following byte w
        If bit 7 of w is set error "read mask is illegal"

        If any of these are missing following bytes in the comma list then maybe error
        "missing register group member(s)".
        if there are too many bytes "too many arguments".
        */
        switch (N) {
        case 0x83:
        case 0x87:
        case 0xBB:
        case 0xCF:
        case 0xD3:
            break;

        case 0x8B:
        case 0xA3:
        case 0xA7:
        case 0xAB:
        case 0xAF:
        case 0xB3:
        case 0xB7:
        case 0xBF:
        case 0xC3:
        case 0xC7:
        case 0xCB:
            g_error->warning_dma_unsupported_command();
            break;

        default:
            g_error->error_dma_illegal_command();
            return;
        }

        // add command byte
        instr->add_byte(N & 0xFF);

        if (N == 0xBB) {
            if (!get_dma_byte(params, W))
                return;

            if (W & 0x80) {
                g_error->error_dma_illegal_read_mask();
                return;
            }

            instr->add_byte(W & 0xFF);
        }

        break;

    default:
        assert(false && "invalid DMA command");
    }

    // check for extra arguments
    if (!params.empty())
        g_error->error_dma_too_many_arguments();
}

void ObjModule::add_opcode_void(long long opcode) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
}

void ObjModule::add_opcode_jr(long long opcode, const Expr& expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(Patch(instr, PatchType::JR_OFFSET, expr, instr->size()));
}

void ObjModule::add_opcode_n(long long opcode, const Expr& expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(Patch(instr, PatchType::BYTE_UNSIGNED, expr, instr->size()));
}

void ObjModule::add_opcode_nn(long long opcode, const Expr& expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(Patch(instr, PatchType::WORD, expr, instr->size()));
}

bool ObjModule::write_file(const string& filename) const {
	FileWriter fw;
	return fw.write_file(filename);
}

bool ObjModule::FileWriter::write_file(const string& filename) {
    // write header
    write_signature();

    // write CPU
    m_mem.write_long(static_cast<int>(g_options->cpu_id()));
    m_mem.write_long(static_cast<int>(g_options->swap_ixiy()));

    // write placeholders for 6 pointers
	int header_ptr = m_mem.pos();
	for (int i = 0; i < 6; i++)
		m_mem.write_long(-1);

	// write blocks, return pointers
	int expr_ptr = write_exprs();           
	int symbols_ptr = write_symbols();      
	int externs_ptr = write_externs();      
	int modname_ptr = write_modname();      
	int sections_ptr = write_sections();    
    int st_ptr = m_mem.pos();
    m_str_table.write(m_mem);
	int end_ptr = m_mem.pos();

	// write pointers to areas
	m_mem.set_pos(header_ptr);
	m_mem.write_long(modname_ptr);
	m_mem.write_long(expr_ptr);
	m_mem.write_long(symbols_ptr);
	m_mem.write_long(externs_ptr);
	m_mem.write_long(sections_ptr);
	m_mem.write_long(st_ptr);
	m_mem.set_pos(end_ptr);

	// dump object file
    return m_mem.write_file(filename);
}

string ObjModule::FileWriter::file_signature() {
    ostringstream oss;
    oss << OBJ_FILE_SIGNATURE
        << setw(SIGNATURE_SIZE - OBJ_FILE_SIGNATURE.size()) << setfill('0')
        << OBJ_FILE_VERSION,
    assert(oss.str().length() == SIGNATURE_SIZE);
    return oss.str();
}

void ObjModule::FileWriter::write_signature() {
    string signature = file_signature();
    m_mem.write_data(reinterpret_cast<const uint8_t*>(signature.c_str()), SIGNATURE_SIZE);
}

int ObjModule::FileWriter::write_exprs() {
    int pos0 = m_mem.pos();
    bool has_exprs = false;

    for (auto& section : g_obj_module->sections()) {
        for (auto& instr : section->instrs()) {
            for (auto& patch : instr->patches()) {
                has_exprs = true;
                const Expr& expr = patch.expr();
                Instr* instr = patch.parent();
                Section* section = instr->parent();
                Location location = expr.location();
                int asmpc = instr->offset();
                int code_pos = asmpc + patch.offset();
                int opcode_size = instr->size();

                // store type
                m_mem.write_long(static_cast<int>(patch.patch_type()));

                // store file name folowed by source line number
                int str_id = m_str_table.add_string(location.filename());
                m_mem.write_long(str_id);
                m_mem.write_long(location.line_num());

                // store section name
                str_id = m_str_table.add_string(section->name());
                m_mem.write_long(str_id);

                m_mem.write_long(asmpc);
                m_mem.write_long(code_pos);
                m_mem.write_long(opcode_size);

                // target symbol for expression
                str_id = m_str_table.add_string(patch.target_name());
                m_mem.write_long(str_id);

                // expression
                str_id = m_str_table.add_string(expr.to_string());
                m_mem.write_long(str_id);
            }
        }
    }

    if (has_exprs) {
        m_mem.write_long(static_cast<int>(PatchType::UNDEFINED)); // store end-terminator
        return pos0;
    }
    else
        return -1;
}

int ObjModule::FileWriter::write_symbols() {
    int pos0 = m_mem.pos();
    bool has_symbols = false;

    for (auto& it : *(g_obj_module->symtab())) {
        Symbol* symbol = it.second;
        const Section* section = symbol->section();
        Location location = symbol->location();

        if (symbol->sym_type() != SymType::UNDEFINED && symbol->touched()) {
            has_symbols = true;
            m_mem.write_long(static_cast<int>(symbol->sym_scope()));
            m_mem.write_long(static_cast<int>(symbol->sym_type()));
            int str_id = m_str_table.add_string(section->name());
            m_mem.write_long(str_id);
            m_mem.write_long(symbol->value());
            str_id = m_str_table.add_string(symbol->name());
            m_mem.write_long(str_id);
            str_id = m_str_table.add_string(location.filename());
            m_mem.write_long(str_id);
            m_mem.write_long(location.line_num());
        }
    }

    if (has_symbols) {
        m_mem.write_long(static_cast<int>(SymType::UNDEFINED)); // store end-terminator
        return pos0;
    }
    else
        return -1;

}

int ObjModule::FileWriter::write_externs() {
    int pos0 = m_mem.pos();
    bool has_externs = false;

    for (auto& it : *(g_obj_module->symtab())) {
        Symbol* symbol = it.second;

        if (symbol->sym_type() == SymType::UNDEFINED &&
            symbol->sym_scope() == SymScope::EXTERN &&
            symbol->touched()) {
            has_externs = true;

            int str_id = m_str_table.add_string(symbol->name());
            m_mem.write_long(str_id);
        }
    }

    if (has_externs) {
        int str_id = m_str_table.add_string("");
        m_mem.write_long(str_id);           // store "" as end terminator
        return pos0;
    }
    else
        return -1;
}

int ObjModule::FileWriter::write_modname() {
	int pos0 = m_mem.pos();
	int str_id = m_str_table.add_string(g_obj_module->name());
	m_mem.write_long(str_id);
	return pos0;
}

int ObjModule::FileWriter::write_sections() {
    int pos0 = m_mem.pos();
    for (auto& section : g_obj_module->sections()) {
        m_mem.write_long(section->size());
        int str_id = m_str_table.add_string(section->name());
        m_mem.write_long(str_id);
        if (section->section_split())
            m_mem.write_long(Section::ORG_SECTION_SPLIT);
        else
            m_mem.write_long(section->origin());
        m_mem.write_long(section->align());
        for (auto& instr : section->instrs()) {
            m_mem.write_data(instr->data(), instr->size());
        }
        m_mem.align();
    }
    m_mem.write_long(-1);   // end marker
    return pos0;
}
