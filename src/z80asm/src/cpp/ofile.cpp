//-----------------------------------------------------------------------------
// z80asm
// object file format
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "if.h"
#include "ofile.h"
#include "utils.h"
#include <iostream>
#include <fstream>

#define O_FILE_HEADER	"Z80RMF" OBJ_VERSION

bool OFileWriter::write() {
	auto object = g_asm.object();
	ofstream os{ object->filename(), ios::binary };
	if (!os.is_open())
		return false;

	if (g_args.verbose())
		cout << "Writing object file '" << object->filename() << "'" << endl;

	// write header
	os << O_FILE_HEADER;

	// write placeholders for 5 pointers
	streampos header_pos = os.tellp();
	for (int i = 0; i < 5; i++)
		swrite_int32(-1, os);

	// write sections, return pointers
	streampos expr_pos = write_exprs(os);
	streampos symbols_pos = write_symbols(os);
	streampos externsym_pos = write_externsym(os);
	streampos modname_pos = write_modname(os);
	streampos code_pos = write_code(os);

	// write pointers to areas
	os.seekp(header_pos);
	swrite_int32(static_cast<int>(modname_pos), os);
	swrite_int32(static_cast<int>(expr_pos), os);
	swrite_int32(static_cast<int>(symbols_pos), os);
	swrite_int32(static_cast<int>(externsym_pos), os);
	swrite_int32(static_cast<int>(code_pos), os);

	return true;
}

streampos OFileWriter::write_exprs(ofstream& os) {
	streampos start_pos = os.tellp();

	m_last_filename.clear();

	// write expressions of DEFC symbols
	write_defc_exprs(g_symbols.globals(), os);
	write_defc_exprs(g_asm.cur_module()->symtab(), os);

	// write patch expressions
	for (auto& section : g_asm.cur_module()->sections()) {
		for (auto& instr : section->instrs()) {
			for (auto& patch : instr->patches()) {
				write_patch_expr(patch, os);
			}
		}
	}

	// return -1 if no expressions written
	streampos end_pos = os.tellp();
	if (start_pos == end_pos)
		return -1;
	else {
		os.put(0);			// write expressions terminator
		return start_pos;
	}
}

void OFileWriter::write_defc_exprs(Symtab& symtab, ofstream& os) {
	for (auto& it : symtab) {
		shared_ptr<Symbol> symbol = it.second;
		if (symbol->is_touched() && !symbol->is_global_def()) {
			if (symbol->type() == Symbol::Type::Computed) {
				auto patch = make_shared<WordPatch>(symbol->expr());
				write_expr(symbol->name(), patch, os);
			}
		}
	}
}

void OFileWriter::write_expr(const string& target_name, shared_ptr<Patch> patch,
	ofstream& os) {

	// store range
	char range = 0;
	if (!target_name.empty())
		range = '=';
	else {
		switch (patch->type()) {
		case Patch::Type::UByte: range = 'U'; break;
		case Patch::Type::SByte: range = 'S'; break;
		case Patch::Type::Word: range = 'C'; break;
		case Patch::Type::BEWord: range = 'B'; break;
		case Patch::Type::Ptr24: range = 'P'; break;
		case Patch::Type::DWord: range = 'L'; break;
		case Patch::Type::JrOffset: range = 'J'; break;
		case Patch::Type::UByte2Word: range = 'u'; break;
		case Patch::Type::SByte2Word: range = 's'; break;
		case Patch::Type::HighOffset: range = 'H'; break;
		default: Assert(0);
		}
	}
	os.put(range);

	// store file name if different from last
	string filename = patch->expr()->location().filename;
	if (filename == m_last_filename) {
		swrite_string("", os);
	}
	else {
		swrite_string(filename, os);
		m_last_filename = filename;
	}

	// line number
	int line_num = patch->expr()->location().line_num;
	swrite_int32(line_num, os);

	// section name
	string section_name = patch->expr()->section()->name();
	swrite_string(section_name, os);

	// ASMPC

}

