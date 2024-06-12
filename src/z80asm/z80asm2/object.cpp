//-----------------------------------------------------------------------------
// z80asm - object file model
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "files.h"
#include "object.h"
#include "ofiles.h"
#include "xassert.h"
#include <cstring>
using namespace std;

//-----------------------------------------------------------------------------

Instr::Instr(int offset_asmpc, int phased_asmpc)
    : offset_asmpc_(offset_asmpc), phased_asmpc_(phased_asmpc) {
}

Instr::~Instr() {
    clear();
}

void Instr::clear() {
    offset_asmpc_ = 0;
    phased_asmpc_ = ORG_NOT_DEFINED;
    for (auto& patch : patches_)
        delete patch;
    patches_.clear();
    label_ = nullptr;
}

void Instr::set_bytes(int opcode) {
    bytes_.clear();
    if ((opcode & 0xff000000) != 0 || bytes_.size() > 0)
        bytes_.push_back((opcode >> 24) & 0xff);
    if ((opcode & 0x00ff0000) != 0 || bytes_.size() > 0)
        bytes_.push_back((opcode >> 16) & 0xff);
    if ((opcode & 0x0000ff00) != 0 || bytes_.size() > 0)
        bytes_.push_back((opcode >> 8) & 0xff);
    bytes_.push_back(opcode & 0xff);
}

int Instr::offset_asmpc() const {
    return offset_asmpc_;
}

int Instr::phased_asmpc() const {
    return phased_asmpc_;
}

int Instr::asmpc() const {
    if (phased_asmpc_ != ORG_NOT_DEFINED)
        return phased_asmpc_;
    else
        return offset_asmpc_;
}

int Instr::size() const {
    return (int)bytes_.size();
}

Bytes& Instr::bytes() {
    return bytes_;
}

vector<Patch*>& Instr::patches() {
    return patches_;
}

void Instr::do_patch(Patch* patch) {
    size_t offset_patch = patch->offset_patch();
    xassert(offset_patch + patch->patch_size() <= bytes_.size());

    ExprResult res = patch->expr()->eval();
    if (!res.ok())
        res.error();
    else {
        int value = res.value();
        int jump_value;

        switch (patch->range()) {
        case RANGE_UNDEFINED:
            xassert(0);
            break;
        case RANGE_JR_OFFSET:
            jump_value = value - (patch->asmpc() + patch->opcode_size());
            if (jump_value >= -128 && jump_value <= 127)
                bytes_[offset_patch] = jump_value & 0xff;
            else
                g_errors.error(ErrIntRange, jump_value);
            break;
        case RANGE_BYTE_UNSIGNED:
            if (value < -128 || value > 255)
                g_errors.warning(ErrIntRange, value);
            bytes_[offset_patch] = value & 0xff;
            break;
        case RANGE_BYTE_SIGNED:
            if (value < -128 || value > 127)
                g_errors.warning(ErrIntRange, value);
            bytes_[offset_patch] = value & 0xff;
            break;
        case RANGE_WORD:
            bytes_[offset_patch + 0] = value & 0xff;
            bytes_[offset_patch + 1] = (value >> 8) & 0xff;
            break;
        case RANGE_WORD_BE:
            bytes_[offset_patch + 0] = (value >> 8) & 0xff;
            bytes_[offset_patch + 1] = value & 0xff;
            break;
        case RANGE_DWORD:
            bytes_[offset_patch + 0] = value & 0xff;
            bytes_[offset_patch + 1] = (value >> 8) & 0xff;
            bytes_[offset_patch + 2] = (value >> 16) & 0xff;
            bytes_[offset_patch + 3] = (value >> 24) & 0xff;
            break;
        case RANGE_BYTE_TO_WORD_UNSIGNED:
            if (value < 0 || value > 255)
                g_errors.warning(ErrIntRange, value);
            bytes_[offset_patch + 0] = value & 0xff;
            bytes_[offset_patch + 1] = 0;
            break;
        case RANGE_BYTE_TO_WORD_SIGNED:
            if (value < -128 || value > 127)
                g_errors.warning(ErrIntRange, value);
            bytes_[offset_patch + 0] = value & 0xff;
            bytes_[offset_patch + 1] = (value & 0x80) ? 0xff : 0;
            break;
        case RANGE_PTR24:
            bytes_[offset_patch + 0] = value & 0xff;
            bytes_[offset_patch + 1] = (value >> 8) & 0xff;
            bytes_[offset_patch + 2] = (value >> 16) & 0xff;
            break;
        case RANGE_HIGH_OFFSET:
            if ((value & 0xff00) != 0) {
                if ((value & 0xff00) != 0xff00)
                    g_errors.warning(ErrIntRange, value);
            }
            bytes_[offset_patch] = value & 0xff;
            break;
        case RANGE_ASSIGNMENT:
            xassert(0);
            break;
        case RANGE_JRE_OFFSET:
            jump_value = value - (patch->asmpc() + patch->opcode_size());
            bytes_[offset_patch + 0] = jump_value & 0xff;
            bytes_[offset_patch + 1] = (jump_value >> 8) & 0xff;
            break;
        default:
            xassert(0);
        }
    }
}

Symbol* Instr::label() const {
    return label_;
}

void Instr::set_offset_asmpc(int offset_asmpc) {
    int delta = offset_asmpc - offset_asmpc_;
    offset_asmpc_ += delta;
    for (auto& patch : patches_) {
        patch->set_asmpc(asmpc());
        patch->set_offset_patch(patch->offset_patch() + delta);
    }
}

void Instr::set_phased_asmpc(int phased_asmpc) {
    phased_asmpc_ = phased_asmpc;
    for (auto& patch : patches_)
        patch->set_asmpc(asmpc());
}

void Instr::set_label(Symbol* label) {
    label_ = label;
}

void Instr::add_byte(int byte) {
    bytes_.push_back(byte);
}

void Instr::add_patch(Patch* patch) {
    patches_.push_back(patch);
    for (int i = 0; i < patch->patch_size(); i++)
        add_byte(0);
}

//-----------------------------------------------------------------------------

Section::Section(const string& name)
    : name_(name) {
}

Section::~Section() {
    clear();
}

void Section::clear() {
    for (auto& instr : instrs_)
        delete instr;
}

const string& Section::name() const {
    return name_;
}

int Section::origin() const {
    return origin_;
}

int Section::align() const {
    return align_;
}

bool Section::section_split() const {
    return section_split_;
}

vector<Instr*>& Section::instrs() {
    return instrs_;
}

int Section::size() const {
    if (instrs_.empty())
        return 0;
    else
        return instrs_.back()->offset_asmpc() + (int)instrs_.back()->bytes().size();
}

void Section::set_origin(int origin) {
    if (origin >= 0 || origin == ORG_NOT_DEFINED) {
        origin_ = origin;
        section_split_ = false;
    }
    else if (origin == ORG_SECTION_SPLIT) {
        origin_ = ORG_NOT_DEFINED;
        section_split_ = true;
    }
    else {
        xassert(0);
    }
}

void Section::set_align(int align) {
    align_ = align;
}

void Section::set_section_split(bool f) {
    section_split_ = f;
}

Instr* Section::add_instr() {
    Instr* instr = new Instr(size(), phased_asmpc());
    instrs_.push_back(instr);
    return instr;
}

Instr* Section::add_instr(int opcode) {
    Instr* instr = add_instr();
    instr->set_bytes(opcode);
    return instr;
}

void Section::check_relative_jumps() {
    // TODO
}

void Section::compute_addresses() {
    int offset_asmpc = 0;
    int phased_asmpc = ORG_NOT_DEFINED;
    for (auto& instr : instrs_) {
        if (instr->phased_asmpc() != ORG_NOT_DEFINED)
            phased_asmpc = instr->phased_asmpc();

        instr->set_offset_asmpc(offset_asmpc);
        instr->set_phased_asmpc(phased_asmpc);

        int instr_size = instr->size();
        offset_asmpc += instr_size;
        if (phased_asmpc != ORG_NOT_DEFINED)
            phased_asmpc += instr_size;
    }
}

void Section::patch_local_exprs() {
    for (auto& instr : instrs_) {
        g_errors.push_location(instr->location());

        for (auto it = instr->patches().begin(); it != instr->patches().end(); ++it) {
            Patch* patch = *it;
            Expr* expr = patch->expr();

            ExprResult res = expr->eval();

            if (!res.ok() || res.multi_section() ||
                res.type() == TYPE_UNDEFINED || res.type() == TYPE_COMPUTED) {
                // with errors or multiple sections or udefined or computed
                // keep in object file
            }
            else {
                instr->do_patch(patch);
                instr->patches().erase(it++);
            }
        }

        g_errors.pop_location();
    }
}

int Section::phased_asmpc() const {
    if (instrs_.empty())
        return ORG_NOT_DEFINED;
    else if (instrs_.back()->phased_asmpc() == ORG_NOT_DEFINED)
        return ORG_NOT_DEFINED;
    else
        return instrs_.back()->phased_asmpc() + (int)instrs_.back()->bytes().size();
}

//-----------------------------------------------------------------------------

Module::Module(const string& name)
    : name_(name) {
    create_default_section();
}

Module::~Module() {
    clear_all();
}

void Module::clear() {
    clear_all();
    create_default_section();
}

const string& Module::name() const {
    return name_;
}

void Module::clear_all() {
    for (auto& section : sections_)
        delete section;
    sections_.clear();
    section_by_name_.clear();
    cur_section_ = nullptr;
    symbols_.clear();
}

void Module::create_default_section() {
    select_section("");                     // create "" section
}

vector<Section*>& Module::sections() {
    return sections_;
}

void Module::select_section(const string& name) {
    auto it = section_by_name_.find(name);
    if (it == section_by_name_.end()) {
        cur_section_ = new Section(name);
        sections_.push_back(cur_section_);
        section_by_name_[name] = cur_section_;
    }
    else
        cur_section_ = it->second;
}

Section& Module::cur_section() const {
    xassert(cur_section_);
    return *cur_section_;
}

Symtab& Module::symbols() {
    return symbols_;
}

void Module::check_relative_jumps() {
    for (auto& section : sections_)
        section->check_relative_jumps();
}

void Module::compute_addresses() {
    for (auto& section : sections_)
        section->compute_addresses();
}

void Module::patch_local_exprs() {
    for (auto& section : sections_)
        section->patch_local_exprs();
}

void Module::check_undefined_symbols() {
    symbols_.check_undefined_symbols();
}

//-----------------------------------------------------------------------------

Object::Object(const string& asm_filename, const string& obj_filename)
    : asm_filename_(asm_filename), obj_filename_(obj_filename) {
    create_default_module();
}

Object::~Object() {
    clear();
}

void Object::clear() {
    clear_all();
    create_default_module();
}

const string& Object::asm_filename() const {
    return asm_filename_;
}

const string& Object::obj_filename() const {
    return obj_filename_;
}

void Object::clear_all() {
    for (auto& module : modules_)
        delete module;
    modules_.clear();
    module_by_name_.clear();
    cur_module_ = nullptr;
    create_default_module();
}

void Object::create_default_module() {
    select_module(file_basename(obj_filename_));
}

vector<Module*>& Object::modules() {
    return modules_;
}

void Object::select_module(const string& name) {
    auto it = module_by_name_.find(name);
    if (it == module_by_name_.end()) {
        cur_module_ = new Module(name);
        modules_.push_back(cur_module_);
        module_by_name_[name] = cur_module_;
    }
    else
        cur_module_ = it->second;
}

Module& Object::cur_module() const {
    xassert(cur_module_);
    return *cur_module_;
}

bool Object::parse() {
    return parser_.parse(asm_filename_);
}

void Object::check_relative_jumps() {
    for (auto& module1 : modules_)
        module1->check_relative_jumps();
}

void Object::compute_addresses() {
    for (auto& module1 : modules_)
        module1->compute_addresses();
}

void Object::patch_local_exprs() {
    for (auto& module1 : modules_)
        module1->patch_local_exprs();
}

void Object::check_undefined_symbols() {
    for (auto& module1 : modules_)
        module1->check_undefined_symbols();
}

void Object::write_obj_file(const string& obj_filename) {
    OFileWriter ofile(obj_filename);
    ofile.write();
}
