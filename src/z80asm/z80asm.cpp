//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "z80asm.h"

#if 0
Asm g_asm;

//-----------------------------------------------------------------------------
// Expressions
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// one named section of code
//-----------------------------------------------------------------------------

Section::Section(const string& section_name)
    : m_section_name(section_name) {
}

Section::~Section() {
    for (auto& instr : m_instrs)
        delete instr;
}

//-----------------------------------------------------------------------------
// Module - minimum quantity that can be linked
//-----------------------------------------------------------------------------

Module::Module(const string& module_name)
    : m_module_name(module_name) {

}

Module::~Module() {
    for (auto& section : m_sections)
        delete section;
}

Section* Module::get_current_section() {
    xassert(m_current_section);
    return m_current_section;
}

Section* Module::get_new_section(const string& section_name) {
    for (auto& section : m_sections) {
        if (section->get_section_name() == section_name) {
            m_current_section = section;
            return m_current_section;
        }
    }

    m_current_section = new Section(section_name);
    return m_current_section;
}

//-----------------------------------------------------------------------------
// Assembly Unit
//-----------------------------------------------------------------------------

AsmUnit::AsmUnit(const string& filename)
    : m_filename(filename) {
    string module_name = fs::path(filename).stem().generic_string();
    m_current_module = new Module(module_name);
    m_modules.push_back(m_current_module);
}

AsmUnit::~AsmUnit() {
    for (auto& module : m_modules)
        delete module;
    m_modules.clear();
}

Module* AsmUnit::get_current_module() {
    xassert(m_current_module);
    return m_current_module;
}

Module* AsmUnit::get_new_module(const string& module_name) {
    for (auto& module : m_modules) {
        if (module->get_module_name() == module_name) {
            m_current_module = module;
            return m_current_module;
        }
    }

    // not found, create new
    m_current_module = new Module(module_name);
    m_modules.push_back(m_current_module);
    return m_current_module;
}

//-----------------------------------------------------------------------------
// Application
//-----------------------------------------------------------------------------

Asm::~Asm() {
    for (auto& asm_unit : m_asm_units)
        delete asm_unit;
    m_asm_units.clear();
}

AsmUnit* Asm::get_current_asm_unit() {
    xassert(m_current_asm_unit);
    return m_current_asm_unit;
}

string Asm::get_asmpc_label() const {
    xassert(!m_asmpc_label.empty());
    return m_asmpc_label;
}

void Asm::set_asmpc_label(const string& label) {
    m_asmpc_label = label;
}

bool Asm::assemble(const string& asm_filename) {
    m_current_asm_unit = new AsmUnit(asm_filename);
    m_asm_units.push_back(m_current_asm_unit);

    // TODO

    return false;
}

bool Asm::append_object(const string& o_filename) {
    m_current_asm_unit = new AsmUnit(o_filename);
    m_asm_units.push_back(m_current_asm_unit);

    // TODO

    return false;
}


string Asm::genlabel() {
    static int n = 0;
    return "z80asm$" + to_string(n++);
}
#endif

//-----------------------------------------------------------------------------
// Object and library files
//-----------------------------------------------------------------------------

ObjLibFileReader::ObjLibFileReader(ifstream& ifs)
    : m_ifs(ifs), m_fpos(ifs.tellg()) {
}

bool ObjLibFileReader::check_signature() {
    if (m_header_checked)
        return true;

    if (!m_ifs.is_open())
        return false;

    // go to start of header
    m_ifs.seekg(m_fpos);

    // create buffer read signature
    string buffer;
    buffer.resize(get_signature_size());

    m_ifs.read(&buffer[0], buffer.size());
    size_t num_read = static_cast<size_t>(m_ifs.gcount());
    if (num_read != buffer.size())
        return false;

    string signature_base = get_signature_base();
    if (0 != memcmp(&buffer[0], signature_base.c_str(), signature_base.size()))
        return false;

    string version = buffer.substr(signature_base.size());
    if (atoi(version.c_str()) != OBJ_FILE_VERSION)
        return false;

    return true;
}

//-----------------------------------------------------------------------------
// Object files
//-----------------------------------------------------------------------------

ObjFileReader::ObjFileReader(ifstream& ifs)
    : ObjLibFileReader(ifs) {
}

bool ObjFileReader::check_header() {
    if (m_header_checked)
        return true;

    if (!check_signature())
        return false;

    // create buffer to read file pointers
    vector<byte_t> buffer;
    buffer.resize(get_header_size());

    m_ifs.read(reinterpret_cast<char*>(&buffer[0]), buffer.size());
    size_t num_read = static_cast<size_t>(m_ifs.gcount());
    if (num_read != buffer.size()) 
        return false;

    byte_t* p = &buffer[0];
    int cpu_id = parse_le_int32(p); p += sizeof(int32_t);
    m_cpu = cpu_lookup(cpu_id);

    if (m_cpu == CpuId::undef) {
        g_errors.error(Errors::Code::illegal_cpu, int_to_hex(cpu_id, 2));
        return false;
    }

    if (!cpu_compatible(g_args.opt_cpu, m_cpu)) {
        g_errors.error(Errors::Code::incompatible_cpu, cpu_name(m_cpu));
        return false;
    }

    int swap_ixiy_id = parse_le_int32(p); p += sizeof(int32_t);
    m_swap_ixiy = swap_ixiy_lookup(swap_ixiy_id);

    if (m_swap_ixiy == SwapIXIY::undef) {
        g_errors.error(Errors::Code::illegal_IXIY, int_to_hex(swap_ixiy_id, 2));
        return false;
    }

    if (!swap_ixiy_compatible(g_args.opt_swap_ixiy, m_swap_ixiy)) {
        g_errors.error(Errors::Code::incompatible_ixiy, swap_ixiy_name(m_swap_ixiy));
        return false;
    }

    m_fpos_modname = parse_le_int32(p); p += sizeof(int32_t);
    m_fpos_exprs = parse_le_int32(p); p += sizeof(int32_t);
    m_fpos_symbols = parse_le_int32(p); p += sizeof(int32_t);
    m_fpos_externs = parse_le_int32(p); p += sizeof(int32_t);
    m_fpos_sections = parse_le_int32(p); p += sizeof(int32_t);
    m_fpos_strtable = parse_le_int32(p); p += sizeof(int32_t);

    m_header_checked = true;
    return true;
}

bool ObjFileReader::check_file_header(const string& filename) {
    ifstream ifs(filename, ios::binary);
    ObjFileReader obj(ifs);
    return obj.check_header();
}

//-----------------------------------------------------------------------------
// Library files
//-----------------------------------------------------------------------------

LibFileReader::LibFileReader(ifstream& ifs)
    : ObjLibFileReader(ifs) {
}

bool LibFileReader::check_header() {
    if (m_header_checked)
        return true;

    if (!check_signature())
        return false;

    m_header_checked = true;
    return true;
}

bool LibFileReader::check_file_header(const string& filename) {
    ifstream ifs(filename, ios::binary);
    LibFileReader lib(ifs);
    return lib.check_header();
}

