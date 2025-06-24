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

void Patch::resolve(int value) {
    *g_location = m_expr->location();    // prepare for errors
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
        value -= m_parent->offset() + m_parent->size(); // relative to the next instruction
        if (value < -128 || value > 127)
            g_error->error_int_range(int_to_hex(value, 2));
        else
            m_parent->patch_byte(m_offset, value & 0xFF);
        break;

    case PatchType::JRE_OFFSET:
        value -= m_parent->offset() + m_parent->size(); // relative to the next instruction
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
    if (patch->patch_type() != PatchType::ASSIGNMENT &&
        patch->expr()->eval_const(value)) {
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
    assert(m_patches[0]->patch_type() == PatchType::JR_OFFSET
        && "Only JR patch expected for expansion");
    int opcode_index = m_patches[0]->offset() - 1;
    assert(opcode_index >= 0 && opcode_index < size()
        && "Opcode index out of bounds");
    int opcode = m_bytes[opcode_index];

    switch (opcode) {
    case 0x10: // DJNZ
        m_bytes[opcode_index] = 0x05; // Change to DEC B
        m_bytes[opcode_index + 1] = 0xC2; // Change to JP NZ
        m_patches[0]->set_patch_type(PatchType::WORD);
        m_patches[0]->set_offset(opcode_index + 2);
        m_bytes.push_back(0x00); // two more bytes
        m_bytes.push_back(0x00); 
        break;
    case 0x18: // JR
        m_bytes[opcode_index] = 0xC3; // Change to JP
        m_patches[0]->set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x20: // JR NZ
        m_bytes[opcode_index] = 0xC2; // Change to JP NZ
        m_patches[0]->set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x28: // JR Z
        m_bytes[opcode_index] = 0xCA; // Change to JP Z
        m_patches[0]->set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x30: // JR NC
        m_bytes[opcode_index] = 0xD2; // Change to JP NC
        m_patches[0]->set_patch_type(PatchType::WORD);
        m_bytes.push_back(0x00); // one more byte
        break;
    case 0x38: // JR C
        m_bytes[opcode_index] = 0xDA; // Change to JP C
        m_patches[0]->set_patch_type(PatchType::WORD);
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
                if (patch->patch_type() == PatchType::JR_OFFSET) {
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
    m_symtab.add_equ(name, expr->clone());
    Instr* instr = cur_section()->add_instr();
    Patch* patch = new Patch(instr, PatchType::ASSIGNMENT, expr, instr->size());
    patch->set_target_name(name);
    instr->add_patch(patch);
}

void ObjModule::declare_extern(const string& name) {
    m_symtab.declare_extern(name);
}

void ObjModule::add_opcode_void(long long opcode) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
}

void ObjModule::add_opcode_jr(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::JR_OFFSET, expr, instr->size()));
}

void ObjModule::add_opcode_n(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::BYTE_UNSIGNED, expr, instr->size()));
}

void ObjModule::add_opcode_nn(long long opcode, Expr* expr) {
    Instr* instr = cur_section()->add_instr();
    instr->add_opcode(opcode);
    instr->add_patch(new Patch(instr, PatchType::WORD, expr, instr->size()));
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
                Expr* expr = patch->expr();
                Instr* instr = patch->parent();
                Section* section = instr->parent();
                Location location = expr->location();
                int asmpc = instr->offset();
                int code_pos = asmpc + patch->offset();
                int opcode_size = instr->size();

                // store type
                m_mem.write_long(static_cast<int>(patch->patch_type()));

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
                str_id = m_str_table.add_string(patch->target_name());
                m_mem.write_long(str_id);

                // expression
                str_id = m_str_table.add_string(expr->to_string());
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
