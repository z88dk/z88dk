//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "cpu.h"
#include "icode.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <iostream>
#include <memory>
#include <sstream>
#include <cctype>
using namespace std;

// Encoding for C_LINEand ASM_LINE
static string url_encode(const string& text) {
	ostringstream ss;
	for (auto c : text) {
		if (isalnum(c))
			ss << c;
		else
			ss << '_' << setfill('0') << setw(2) << hex << static_cast<unsigned int>(c) << dec;
	}
	return ss.str();
}

//-----------------------------------------------------------------------------

Icode::Icode(Section* parent, Type type)
	: m_parent(parent), m_type(type)
	, m_location(g_preproc.location()) {
	m_asmpc = parent->asmpc();
	m_asmpc_phased = parent->asmpc_phased();
}

void Icode::set_asmpc(int n) {
	m_asmpc = n;
}

//-----------------------------------------------------------------------------

Section::Section(const string& name, Module* module)
	: m_name(name), m_module(module) {
}

void Section::add_instr(shared_ptr<Icode> instr) {
	instr->set_asmpc(asmpc());
	instr->set_asmpc_phased(asmpc_phased());
	m_icode.push_back(instr);
}

int Section::asmpc() const {
	if (m_icode.empty())
		return 0;
	else
		return m_icode.back()->asmpc() + m_icode.back()->size();
}

int Section::asmpc_phased() const {
	if (m_icode.empty())
		return Icode::UndefinedAsmpc;
	else if (m_icode.back()->asmpc_phased() == Icode::UndefinedAsmpc)
		return Icode::UndefinedAsmpc;
	else
		return m_icode.back()->asmpc_phased() + m_icode.back()->size();
}

bool Section::is_phased() const {
	return asmpc_phased() != Icode::UndefinedAsmpc;
}

int Section::pc() const {
	return is_phased() ? asmpc_phased() : asmpc();
}

shared_ptr<Icode> Section::add_asmpc() {
	auto instr = make_shared<Icode>(this, Icode::Type::Asmpc);
	add_instr(instr);
	return instr;
}

void Section::add_label(const string& name) {
	add_label_(name);

	// add debug label
	if (g_args.debug() && g_preproc.is_c_source()) {
		ostringstream ss;
		ss << "__ASM_LINE_" << g_preproc.location().line_num
			<< "_" << url_encode(g_preproc.location().filename);
		string debug_name = ss.str();
		if (!g_symbols.find_local(debug_name))
			add_label_(debug_name);
	}
}

string Section::autolabel() {
	static int n;
	ostringstream ss;
	ss << "__autolabel_" << setfill('0') << setw(4) << ++n;
	return ss.str();
}

void Section::add_label_(const string& name) {
	auto instr = make_shared<Icode>(this, Icode::Type::Label);

	shared_ptr<Symbol> label = g_symbols.add(name, 0, Symbol::Type::Label);
	if (label) {		// not duplicate symbol
		label->set_touched();
		label->set_instr(instr);

		instr->set_label(label);
		add_instr(instr);
	}
}

void Section::add_opcode(unsigned bytes) {
	auto instr = make_shared<Icode>(this, Icode::Type::Opcode);

	bool found = false;
	if (found || (bytes & 0xff000000) != 0) {
		instr->bytes().push_back((bytes >> 24) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff0000) != 0) {
		instr->bytes().push_back((bytes >> 16) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff00) != 0) {
		instr->bytes().push_back((bytes >> 8) & 0xff);
		found = true;
	}
	instr->bytes().push_back(bytes & 0xff);

	add_instr(instr);
}

void Section::add_opcode_n(unsigned bytes, shared_ptr<Expr> n, PatchExpr::Type type) {
	// add bytes
	add_opcode(bytes);
	shared_ptr<Icode> instr = m_icode.back();

	// add patch
	auto patch = make_shared<PatchExpr>(n, type, instr->size());
	instr->bytes().push_back(0);
	instr->patches().push_back(patch);
}

void Section::add_opcode_nn(unsigned bytes, shared_ptr<Expr> nn, PatchExpr::Type type) {
	// add bytes
	add_opcode(bytes);
	shared_ptr<Icode> instr = m_icode.back();

	// add patch
	auto patch = make_shared<PatchExpr>(nn, type, instr->size());
	instr->bytes().push_back(0);
	instr->bytes().push_back(0);
	instr->patches().push_back(patch);
}

void Section::add_opcode_idx_(unsigned bytes) {
	// add bytes
	if (bytes & 0xFF0000) 			// 3 bytes, insert dis at second byte
		bytes = (((bytes >> 8) & 0xFFFF) << 16) | (bytes & 0xFF);
	else							// 2 bytes, insert 0 for dis
		bytes <<= 8;
	add_opcode(bytes);
}

void Section::check_relative_jumps() {
	// decrement B instruction
	auto dec_b = make_shared<Icode>(this, Icode::Type::Opcode);
	dec_b->bytes().push_back(Z80_DEC(REG_B));

	bool modified;
	do {
		modified = false;
		update_asmpc();

		for (auto it = m_icode.begin(); it != m_icode.end(); ++it) {
			shared_ptr<Icode> instr = *it;
			if (instr->type() == Icode::Type::JumpRelative) {
				shared_ptr<PatchExpr> patch = instr->patches().front();
				shared_ptr<Expr> expr = patch->expr();
				if (expr->eval_silent()) {
					int target = expr->value();
					int distance = target - (instr->pc() + 2);
					if (distance < -128 || distance >127) {
						// convert short to long jump
						switch (instr->bytes()[0]) {
						case Z80_JR:
							instr->set_type(Icode::Type::Opcode);
							instr->bytes()[0] = Z80_JP;
							instr->bytes().push_back(0);
							patch->set_type(PatchExpr::Type::Word);
							modified = true;
							continue;
						case Z80_JR_FLAG(FLAG_NZ):
						case Z80_JR_FLAG(FLAG_Z):
						case Z80_JR_FLAG(FLAG_NC):
						case Z80_JR_FLAG(FLAG_C):
							instr->set_type(Icode::Type::Opcode);
							instr->bytes()[0] += Z80_JP_FLAG(0) - Z80_JR_FLAG(0);
							instr->bytes().push_back(0);
							patch->set_type(PatchExpr::Type::Word);
							modified = true;
							continue;
						case Z80_DJNZ:	// dec b; jp nz, target
							m_icode.insert(it, dec_b);
							instr->set_type(Icode::Type::Opcode);
							instr->bytes()[0] = Z80_JP_FLAG(FLAG_NZ);
							instr->bytes().push_back(0);
							patch->set_type(PatchExpr::Type::Word);
							modified = true;
							continue;
						default:
							Assert(0);
						}
					}
				}
			}
		}
	} while (modified);
}

void Section::patch_local_exprs() {
	/*
	for (auto& instr : m_icode) {

	}
	*/
}

void Section::update_asmpc(int start) {
	int asmpc = start;
	int asmpc_phased = Icode::UndefinedAsmpc;
	for (auto& instr : m_icode) {
		// set asmpc of instruction
		instr->set_asmpc(asmpc);
		if (asmpc_phased == Icode::UndefinedAsmpc &&
			instr->asmpc_phased() != Icode::UndefinedAsmpc)
			asmpc_phased = instr->asmpc_phased();
		else
			instr->set_asmpc(asmpc_phased);

		// advance to next address
		int size = instr->size();
		asmpc += size;
		if (asmpc_phased != Icode::UndefinedAsmpc)
			asmpc_phased += size;
	}
}

void Section::add_opcode_idx(unsigned bytes, shared_ptr<Expr> dis) {
	// add bytes
	add_opcode_idx_(bytes);
	shared_ptr<Icode> instr = m_icode.back();

	// add patch
	auto patch = make_shared<PatchExpr>(dis, PatchExpr::Type::SByte, 2);
	instr->patches().push_back(patch);
}

void Section::add_opcode_idx_n(unsigned bytes, shared_ptr<Expr> dis, shared_ptr<Expr> n) {
	// add bytes
	add_opcode_idx_(bytes);
	shared_ptr<Icode> instr = m_icode.back();

	// add patches
	auto dis_patch = make_shared<PatchExpr>(dis, PatchExpr::Type::SByte, 2);
	instr->patches().push_back(dis_patch);

	auto n_patch = make_shared<PatchExpr>(n, PatchExpr::Type::UByte, instr->size());
	instr->patches().push_back(n_patch);
}

void Section::add_opcode_n_n(unsigned bytes, shared_ptr<Expr> n1, shared_ptr<Expr> n2) {
	// add bytes
	add_opcode(bytes);
	shared_ptr<Icode> instr = m_icode.back();

	// add patches
	auto n1_patch = make_shared<PatchExpr>(n1, PatchExpr::Type::UByte, instr->size());
	instr->patches().push_back(n1_patch);

	auto n2_patch = make_shared<PatchExpr>(n2, PatchExpr::Type::UByte, instr->size());
	instr->patches().push_back(n2_patch);
}

void Section::add_jump_relative(unsigned bytes, shared_ptr<Expr> nn) {
	if (g_args.opt_speed()) {			// convert short to long jumps
		switch (bytes) {
		case Z80_JR:
			add_opcode_nn(Z80_JP, nn, PatchExpr::Type::Word);
			break;
		case Z80_JR_FLAG(FLAG_NZ):
		case Z80_JR_FLAG(FLAG_Z):
		case Z80_JR_FLAG(FLAG_NC):
		case Z80_JR_FLAG(FLAG_C):
			add_opcode_nn(bytes - Z80_JR_FLAG(0) + Z80_JP_FLAG(0), nn, PatchExpr::Type::Word);
			break;
		case Z80_DJNZ:					// "dec b; jp nz" is always slower
			add_jump_relative_(bytes, nn);
			break;
		default:
			Assert(0);
		}
	}
	else {
		add_jump_relative_(bytes, nn);
	}
}

void Section::add_jump_relative_(unsigned bytes, shared_ptr<Expr> nn) {
	auto instr = make_shared<Icode>(this, Icode::Type::JumpRelative);
	instr->bytes().push_back(bytes & 0xff);

	auto patch = make_shared<PatchExpr>(nn, PatchExpr::Type::JrOffset, instr->size());
	instr->patches().push_back(patch);

	add_instr(instr);
}

//-----------------------------------------------------------------------------

Group::Group(const string& name, Module* module)
	: m_name(name), m_module(module) {
	insert_section("");		// create default section with empty name
}

shared_ptr<Section> Group::section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())			// found
		return it->second;
	else
		return nullptr;
}

shared_ptr<Section> Group::insert_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())			// found
		return it->second;	
	else {								// not found
		auto section = make_shared<Section>(name, m_module);
		m_sections.push_back(section);
		m_sections_map[name] = section;
		return section;
	}
}

//-----------------------------------------------------------------------------

Module::Module(const string& name, Object* object)
	: m_name(name), m_object(object) {
	// create default section and group
	insert_section("");
	insert_group("");
}

shared_ptr<Section> Module::section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end()) {	// found
		shared_ptr<Section> section = it->second;
		m_cur_section = section;
		return section;
	}
	else
		return nullptr;
}

shared_ptr<Section> Module::insert_section(const string& name) {
	auto it = m_sections_map.find(name);
	if (it != m_sections_map.end())		// found
		return it->second;
	else {								// not found
		auto section = make_shared<Section>(name, this);
		m_sections.push_back(section);
		m_sections_map[name] = section;
		m_cur_section = section;
		return section;
	}
}

shared_ptr<Group> Module::group(const string& name) {
	auto it = m_groups_map.find(name);
	if (it != m_groups_map.end()) {			// found
		shared_ptr<Group> group = it->second;
		m_cur_group = group;
		return group;
	}
	else
		return nullptr;
}

shared_ptr<Group> Module::insert_group(const string& name) {
	auto it = m_groups_map.find(name);
	if (it != m_groups_map.end())			// found
		return it->second;
	else {								// not found
		auto group = make_shared<Group>(name, this);
		m_groups.push_back(group);
		m_groups_map[name] = group;
		m_cur_group = group;
		return group;
	}
}

void Module::check_relative_jumps() {
	for (auto& section : m_sections)
		section->check_relative_jumps();
}

void Module::patch_local_exprs() {
	for (auto& section : m_sections)
		section->patch_local_exprs();
}

//-----------------------------------------------------------------------------

Object::Object(const string& filename) {
	insert_module("");		// create default module with empty name
	m_filename = fs::path(filename).replace_extension(EXT_O).generic_string();
}

shared_ptr<Module> Object::module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end()) {		// found
		shared_ptr<Module> module = it->second;
		m_cur_module = module;
		return module;
	}
	else
		return nullptr;
}

shared_ptr<Module> Object::insert_module(const string& name) {
	auto it = m_modules_map.find(name);
	if (it != m_modules_map.end())		// found
		return it->second;
	else {								// not found
		auto module = make_shared<Module>(name, this);
		m_modules.push_back(module);
		m_modules_map[name] = module;
		m_cur_module = module;
		return module;
	}
}

const string Object::name() const {
	return fs::path(m_filename).stem().generic_string();
}

void Object::check_relative_jumps() {
	for (auto& module : m_modules)
		module->check_relative_jumps();
}

void Object::patch_local_exprs() {
	for (auto& module : m_modules)
		module->patch_local_exprs();
}
