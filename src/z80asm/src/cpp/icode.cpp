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
#include <iostream>
#include <memory>
#include <sstream>
#include <cctype>
using namespace std;

// Encoding for C_LINE and ASM_LINE
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

Instr::Instr(Section* section)
	: m_section(section), m_location(g_preproc.location()) {
	Assert(section);
	m_asmpc = m_section->asmpc();
	m_asmpc_phased = m_section->asmpc_phased();
}

void Instr::add_patch(shared_ptr<Patch> patch) {
	// add patch
	m_patches.push_back(patch);

	// add placeholder zeros
	patch->set_offset(size());
	for (int i = 0; i < patch->size(); i++)
		m_bytes.push_back(0);
}

void Instr::add_byte(int n) {
	m_bytes.push_back(n & 0xff);
}

bool Instr::is_relative_jump() const {
	return m_patches.size() == 1 && m_patches[0]->type() == Patch::Type::JrOffset;
}

//-----------------------------------------------------------------------------

Section::Section(const string& name, Module* module)
	: m_name(name), m_module(module) {
	Assert(module);
}

void Section::add_instr(shared_ptr<Instr> instr) {
	instr->set_asmpc(asmpc());
	instr->set_asmpc_phased(asmpc_phased());
	m_instrs.push_back(instr);
}

int Section::asmpc() const {
	if (m_instrs.empty())
		return 0;
	else
		return m_instrs.back()->asmpc() + m_instrs.back()->size();
}

int Section::asmpc_phased() const {
	if (m_instrs.empty())
		return Instr::UndefinedAsmpc;
	else if (m_instrs.back()->asmpc_phased() == Instr::UndefinedAsmpc)
		return Instr::UndefinedAsmpc;
	else
		return m_instrs.back()->asmpc_phased() + m_instrs.back()->size();
}

bool Section::is_phased() const {
	return asmpc_phased() != Instr::UndefinedAsmpc;
}

int Section::pc() const {
	return is_phased() ? asmpc_phased() : asmpc();
}

string Section::autolabel() {
	static int n;
	ostringstream ss;
	ss << "__autolabel_" << setfill('0') << setw(4) << ++n;
	return ss.str();
}

shared_ptr<Instr> Section::add_asmpc() {
	auto instr = make_shared<Instr>(this);
	add_instr(instr);
	return instr;
}

shared_ptr<Instr> Section::add_label_(const string& name) {
	auto instr = make_shared<Instr>(this);

	shared_ptr<Symbol> symbol;
	if (is_phased())
		symbol = make_shared<Symbol>(Symbol::MakeAsmpcPhased(), name, instr);
	else
		symbol = make_shared<Symbol>(Symbol::MakeAsmpc(), name, instr);

	shared_ptr<Symbol> label = g_symbols.add(symbol);
	if (label)			// not duplicate symbol
		label->set_touched();

	add_instr(instr);
	return instr;
}

shared_ptr<Instr> Section::add_label(const string& name) {
	auto ret = add_label_(name);

	// add debug label
	if (g_args.debug() && g_preproc.is_c_source()) {
		ostringstream ss;
		ss << "__ASM_LINE_" << g_preproc.location().line_num
			<< "_" << url_encode(g_preproc.location().filename);
		string debug_name = ss.str();
		if (!g_symbols.find_local(debug_name))
			add_label_(debug_name);
	}

	return ret;
}

shared_ptr<Instr> Section::add_opcode(unsigned bytes) {
	auto instr = make_shared<Instr>(this);

	bool found = false;
	if (found || (bytes & 0xff000000) != 0) {
		instr->add_byte((bytes >> 24) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff0000) != 0) {
		instr->add_byte((bytes >> 16) & 0xff);
		found = true;
	}
	if (found || (bytes & 0xff00) != 0) {
		instr->add_byte((bytes >> 8) & 0xff);
		found = true;
	}
	instr->add_byte(bytes & 0xff);

	add_instr(instr);
	return instr;
}

void Section::check_relative_jumps() {
#if 0
	// decrement B instruction
	auto dec_b = make_shared<Instr>(this, Instr::Type::Opcode);
	dec_b->add_byte(Z80_DEC(REG_B));

	bool modified;
	do {
		modified = false;
		update_asmpc();

		for (auto it = m_instrs.begin(); it != m_instrs.end(); ++it) {
			shared_ptr<Instr> instr = *it;
			if (instr->type() == Instr::Type::JumpRelative) {
				shared_ptr<Patch> patch = instr->patches().front();
				shared_ptr<Expr> expr = patch->expr();
				if (expr->eval_silent()) {
					int target = expr->value();
					int distance = target - (instr->pc() + 2);
					if (distance < -128 || distance >127) {
						// convert short to long jump
						switch (instr->bytes()[0]) {
						case Z80_JR:
							instr->set_type(Instr::Type::Opcode);
							instr->bytes()[0] = Z80_JP;
							instr->add_byte(0);
							patch->set_type(Patch::Type::Word);
							modified = true;
							continue;
						case Z80_JR_FLAG(FLAG_NZ):
						case Z80_JR_FLAG(FLAG_Z):
						case Z80_JR_FLAG(FLAG_NC):
						case Z80_JR_FLAG(FLAG_C):
							instr->set_type(Instr::Type::Opcode);
							instr->bytes()[0] += Z80_JP_FLAG(0) - Z80_JR_FLAG(0);
							instr->add_byte(0);
							patch->set_type(Patch::Type::Word);
							modified = true;
							continue;
						case Z80_DJNZ:	// dec b; jp nz, target
							m_instrs.insert(it, dec_b);
							instr->set_type(Instr::Type::Opcode);
							instr->bytes()[0] = Z80_JP_FLAG(FLAG_NZ);
							instr->add_byte(0);
							patch->set_type(Patch::Type::Word);
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
#endif
}

void Section::patch_local_exprs() {
	/*
	for (auto& instr : m_instrs) {

	}
	*/
}

void Section::update_asmpc(int start) {
	int asmpc = start;
	int asmpc_phased = Instr::UndefinedAsmpc;
	for (auto& instr : m_instrs) {
		// set asmpc of instruction
		instr->set_asmpc(asmpc);
		if (asmpc_phased == Instr::UndefinedAsmpc &&
			instr->asmpc_phased() != Instr::UndefinedAsmpc)
			asmpc_phased = instr->asmpc_phased();
		else if (asmpc_phased != Instr::UndefinedAsmpc &&
			instr->asmpc_phased() == Instr::UndefinedAsmpc)
			asmpc_phased = Instr::UndefinedAsmpc;
		else
			instr->set_asmpc(asmpc_phased);

		// advance to next address
		int size = instr->size();
		asmpc += size;
		if (asmpc_phased != Instr::UndefinedAsmpc)
			asmpc_phased += size;
	}
}

//-----------------------------------------------------------------------------

Module::Module(const string& name, Object* object)
	: m_name(name), m_object(object) {
	add_section("");			// create default section
}

shared_ptr<Section> Module::add_section(const string& name) {
	shared_ptr<Section> section = m_sections.find(name);
	if (section)
		return section;
	else
		return m_sections.add(make_shared<Section>(name, this));
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
	m_filename = fs::path(filename).replace_extension(EXT_O).generic_string();
	add_module(name());		// create default module with stem of file name
}

const string Object::name() const {
	return fs::path(m_filename).stem().generic_string();
}

shared_ptr<Module> Object::add_module(const string& name) {
	shared_ptr<Module> module = m_modules.find(name);
	if (module)
		return module;
	else
		return m_modules.add(make_shared<Module>(name, this));
}

void Object::check_relative_jumps() {
	for (auto& module : m_modules)
		module->check_relative_jumps();
}

void Object::patch_local_exprs() {
	for (auto& module : m_modules)
		module->patch_local_exprs();
}

