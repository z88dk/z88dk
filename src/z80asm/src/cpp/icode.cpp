//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "icode.h"
#include "ofile.h"
#include "preproc.h"
#include "symtab.h"
#include "xassert.h"
#include "z80asm_defs.h"
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
	xassert(section);
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

void Instr::do_patch(shared_ptr<Patch> patch) {
	g_errors.push_location(m_location);
	patch->do_patch(m_bytes, pc());
	g_errors.pop_location();
}

bool Instr::is_relative_jump() const {
	return m_patches.size() == 1 && m_patches[0]->type() == Patch::Type::JR_OFFSET;
}

ostream& operator<<(ostream& os, const Instr& instr) {
    os << indent_prefix() << "Instr:" << endl;
    {
        indent();
        os << indent_prefix() << "asmpc=" << int_to_hex(instr.m_asmpc, 4) << endl
            << indent_prefix() << "asmpc_phased=" << int_to_hex(instr.m_asmpc_phased, 4) << endl
            << indent_prefix() << "location=" << instr.m_location << endl
            << indent_prefix() << "bytes=";
        for (size_t i = 0; i < instr.m_bytes.size(); i++)
            os << int_to_hex(instr.m_bytes[i], 2) << " ";
        os << endl
            << indent_prefix() << "Patches:" << endl;
        {
            indent();
            for (size_t i = 0; i < instr.m_patches.size(); i++) {
                os << indent_prefix() << "[" << i << "]:" << endl;
                {
                    indent();
                    os << *(instr.m_patches[i]);
                    outdent();
                }
            }
            outdent();
        }
        outdent();
    }
    return os;
}

//-----------------------------------------------------------------------------

Section::Section(const string& name, Module* module)
	: m_name(name), m_module(module) {
	xassert(module);
}

shared_ptr<Instr> Section::add_instr() {
    auto instr = make_shared<Instr>(this);
    return add_instr(instr);
}

shared_ptr<Instr> Section::add_instr(shared_ptr<Instr> instr) {
	instr->set_asmpc(asmpc());
	instr->set_asmpc_phased(asmpc_phased());
	m_instrs.push_back(instr);
    return instr;
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

unsigned Section::size() const {
    unsigned sz = 0;
    for (auto& instr : m_instrs)
        sz += instr->size();
    return sz;
}

string Section::autolabel() {
	static int n;
	ostringstream ss;
	ss << "__autolabel_" << setfill('0') << setw(4) << ++n;
	return ss.str();
}

shared_ptr<Instr> Section::add_asmpc() {
    return add_instr();
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
	auto instr = add_label_(name);

	// add debug label
	if (g_args.debug() && g_preproc.is_c_source()) {
		ostringstream ss;
		ss << "__ASM_LINE_" << g_preproc.location().line_num()
			<< "_" << url_encode(g_preproc.location().filename());
		string debug_name = ss.str();
		if (!g_symbols.find_local(debug_name))
			add_label_(debug_name);
	}

	return instr;
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

shared_ptr<Instr> Section::add_defs(int count, int filler) {
    auto instr = make_shared<Instr>(this);

    if (count < 0 || count > 0x10000)
        g_errors.error(ErrCode::IntRange, int_to_hex(count, 4));
    else if (filler < -128 || filler > 255)
        g_errors.error(ErrCode::IntRange, int_to_hex(filler, 4));
    else {
        for (int i = 0; i < count; i++)
            instr->bytes().push_back(filler & 0xff);
    }

    add_instr(instr);
    return instr;
}

shared_ptr<Instr> Section::add_defs(int count, const string& filler) {
    auto instr = make_shared<Instr>(this);

    if (count < 0 || count > 0x10000)
        g_errors.error(ErrCode::IntRange, int_to_hex(count, 4));
    else if (count < static_cast<int>(filler.size()))
        g_errors.error(ErrCode::StrTooLong, filler);
    else {
        int zeros = count - static_cast<int>(filler.size());
        for (auto& c : filler)
            instr->bytes().push_back(c & 0xff);
        for (int i = 0; i < zeros; i++)
            instr->bytes().push_back(g_args.filler());
    }

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
							patch->set_type(Patch::Type::WORD);
							modified = true;
							continue;
						case Z80_JR_FLAG(FLAG_NZ):
						case Z80_JR_FLAG(FLAG_Z):
						case Z80_JR_FLAG(FLAG_NC):
						case Z80_JR_FLAG(FLAG_C):
							instr->set_type(Instr::Type::Opcode);
							instr->bytes()[0] += Z80_JP_FLAG(0) - Z80_JR_FLAG(0);
							instr->add_byte(0);
							patch->set_type(Patch::Type::WORD);
							modified = true;
							continue;
						case Z80_DJNZ:	// dec b; jp nz, target
							m_instrs.insert(it, dec_b);
							instr->set_type(Instr::Type::Opcode);
							instr->bytes()[0] = Z80_JP_FLAG(FLAG_NZ);
							instr->add_byte(0);
							patch->set_type(Patch::Type::WORD);
							modified = true;
							continue;
						default:
							xassert(0);
						}
					}
				}
			}
		}
	} while (modified);
#endif
}

void Section::patch_local_exprs() {
	g_asm.set_cur_section(m_name);		// set section scope for expressions

	for (auto& instr : m_instrs) {
		g_errors.push_location(instr->location());	// set error scope for expression

        for (int i = 0; i < static_cast<int>(instr->patches().size()); i++) {
            shared_ptr<Patch> patch = instr->patches()[i];
			shared_ptr<Expr> expr = patch->expr();

			ExprResult r = expr->eval_silent();

			if (r.undefined_symbol() || r.cross_section()) {
				// keep in object file
			}
			else if (patch->type() == Patch::Type::JR_OFFSET) {
				// patch
				instr->do_patch(patch);
                instr->patches().erase(instr->patches().begin() + i);
                i--;
            }
			else if (r.depends_on_asmpc()) {
				// keep in object file
			}
			else {
				// patch
				instr->do_patch(patch);
                instr->patches().erase(instr->patches().begin() + i);
                i--;
			}
		}

		g_errors.pop_location();
	}
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

ostream& operator<<(ostream& os, const Section& section) {
    os << indent_prefix() << "Section:" << endl;
    {
        indent();
        os << indent_prefix() << "name=" << '"' << section.m_name << '"' << endl
            << indent_prefix() << "origin=" << int_to_hex(section.m_origin, 4) << endl
            << indent_prefix() << "align=" << int_to_hex(section.m_align, 2) << endl
            << indent_prefix() << "Instrs:" << endl;
        {
            indent();
            size_t i = 0;
            for (auto& instr : section.m_instrs) {
                os << indent_prefix() << "[" << i << "]" << endl;
                {
                    indent();
                    os << *instr;
                    outdent();
                }
                i++;
            }
            outdent();
        }
        outdent();
    }
    return os;
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

void Module::check_undefined_symbols() {
	m_symtab.check_undefined_symbols();
}

ostream& operator<<(ostream& os, const Module& module) {
    os << indent_prefix() << "Module:" << endl;
    {
        indent();
        os << indent_prefix() << "name=" << '"' << module.m_name << '"' << endl;
        os << module.m_symtab;
        os << indent_prefix() << "Sections:" << endl;
        {
            indent();
            size_t i = 0;
            for (auto it = module.m_sections.cbegin(); it != module.m_sections.cend(); ++it) {
                auto section = *it;
                os << indent_prefix() << "[" << i << "]:" << endl;
                {
                    indent();
                    os << *section;
                    outdent();
                }
                i++;
            }
            outdent();
        }
        outdent();
    }
    return os;
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

void Object::check_undefined_symbols() {
	for (auto& module : m_modules) {
		module->check_undefined_symbols();
	}
}

void Object::write_obj_file() {
    OFileWriter ofile(g_args.o_filename(m_filename));
    ofile.write();
}

ostream& operator<<(ostream& os, const Object& obj) {
    os << indent_prefix() << "Object:" << endl;
    {
        indent();
        os << indent_prefix() << "filename=" << '"' << obj.m_filename << '"' << endl;
        os << indent_prefix() << "modules:" << endl;
        {
            indent();
            size_t i = 0;
            for (auto it = obj.m_modules.cbegin(); it != obj.m_modules.cend(); ++it) {
                auto module = *it;
                os << indent_prefix() << "[" << i << "]:" << endl;
                {
                    indent();
                    os << *module;
                    outdent();
                }
                i++;
            }
            outdent();
        }
        outdent();
    }
    return os;
}
