//-----------------------------------------------------------------------------
// z80asm
// object file format
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "expr.h"
#include "if.h"
#include "ofile.h"
#include "utils.h"
#include "xassert.h"
#include <iostream>
#include <fstream>

OFileWriter::OFileWriter(const string& filename)
    : m_filename(filename), m_start_errors(g_errors.count()) {
}

bool OFileWriter::write() {
    if (got_errors())
        return false;

    if (g_args.verbose())
        cout << "Writing object file '" << m_filename << "'" << endl;

    // create temp file
    string temp_filename = m_filename + "~";
    ofstream os{ temp_filename, ios::binary };
    if (!os.is_open()) {
        g_errors.error(ErrCode::FileCreate, temp_filename);
        perror(temp_filename.c_str());
        return false;
    }

    // write contents
    write(os);

    // delete old object and rename temp file
    os.close();

    if (got_errors()) {
        std::remove(temp_filename.c_str());
        std::remove(m_filename.c_str());
        return false;
    }
    else {
        std::remove(m_filename.c_str());
        int rv = std::rename(temp_filename.c_str(), m_filename.c_str());
        if (rv != 0) {
            g_errors.error(ErrCode::FileRename, temp_filename);
            perror(temp_filename.c_str());
            return false;
        }
        return true;
    }
}

streampos OFileWriter::write(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write header
    os.write(O_FILE_HEADER, sizeof(O_FILE_HEADER) - 1);

    // write CPU
    swrite_int32(g_args.cpu(), os);
    swrite_int32(g_args.swap_ixiy(), os);

    // write placeholders for 6 pointers
    streampos header_fpos = os.tellp();
    for (int i = 0; i < 6; i++)
        swrite_int32(-1, os);

    // write blocks, return pointers
    streampos expr_fpos = write_exprs(os);
    streampos symbols_fpos = write_symbols(os);
    streampos externs_fpos = write_externs(os);
    streampos modname_fpos = write_modname(os);
    streampos sections_fpos = write_sections(os);
    streampos string_table_fpos = m_string_table.write(os);
    streampos end_fpos = os.tellp();

    // write pointers to areas
    os.seekp(header_fpos);
#define Write_ptr(x, os)	swrite_int32((x) == -1 ? -1 : static_cast<int>((x) - start_fpos), os)
    Write_ptr(modname_fpos, os);        // 0
    Write_ptr(expr_fpos, os);           // 1
    Write_ptr(symbols_fpos, os);        // 2
    Write_ptr(externs_fpos, os);        // 3
    Write_ptr(sections_fpos, os);       // 4
    Write_ptr(string_table_fpos, os);   // 5
#undef Write_ptr

    os.seekp(end_fpos);

    return start_fpos;
}

streampos OFileWriter::write_exprs(ofstream& os) {
	streampos start_fpos = os.tellp();

	// write patch expressions
	for (auto& section : g_asm.cur_module()->sections()) {
		for (auto& instr : section->instrs()) {
			for (auto& patch : instr->patches()) {
				write_patch_expr(instr, patch, os);
			}
		}
	}

	// write expressions of DEFC symbols
    write_exprs(g_symbols.globals(), os);
    write_exprs(g_asm.cur_module()->symtab(), os);

	// return -1 if no expressions written
	streampos end_fpos = os.tellp();
	if (start_fpos == end_fpos)
		return -1;
	else {
        swrite_int32(static_cast<int>(Patch::Type::UNKNOWN), os);   // write expressions terminator
		return start_fpos;
	}
}

void OFileWriter::write_exprs(Symtab& symtab, ofstream& os) {
    for (auto& it : symtab) {
        shared_ptr<Symbol> symbol = it.second;
        if (symbol->is_touched() && !symbol->is_global_def()) {
            if (symbol->type() == Symbol::Type::Computed) {
                auto patch = make_shared<WordPatch>(symbol->expr());
                write_expr(symbol->name(), nullptr, patch, os);
            }
        }
    }
}

void OFileWriter::write_patch_expr(shared_ptr<Instr> instr, shared_ptr<Patch> patch, ofstream& os) {
    write_expr("", instr, patch, os);
}

void OFileWriter::write_expr(const string& target_name, shared_ptr<Instr> instr, shared_ptr<Patch> patch, ofstream& os) {
    // store type
    if (!target_name.empty())
        swrite_int32(static_cast<int>(Patch::Type::ASSIGNMENT), os);
    else
        swrite_int32(static_cast<int>(patch->type()), os);

    // store file name folowed by source line number
    swrite_int32(m_string_table.add_string(patch->expr()->location().filename()), os);
    swrite_int32(patch->expr()->location().line_num(), os);

    // store section name
    swrite_int32(m_string_table.add_string(patch->expr()->section()->name()), os);

    if (instr) {
        swrite_int32(instr->asmpc(), os);			        // ASMPC
        swrite_int32(instr->asmpc() + patch->offset(), os); // code position
        swrite_int32(instr->size(), os);                    // opcode size
    }
    else {
        swrite_int32(0, os);			            // ASMPC
        swrite_int32(0, os);			            // code position
        swrite_int32(0, os);                        // opcode size
    }

    // target symbol for expression
    swrite_int32(m_string_table.add_string(target_name), os);

    // expression
    swrite_int32(m_string_table.add_string(patch->expr()->text()), os);
}

streampos OFileWriter::write_symbols(ofstream& os) {
    streampos start_fpos = os.tellp();

    write_symbols(g_symbols.globals(), os);
    write_symbols(g_asm.cur_module()->symtab(), os);

    // return -1 if no symbols written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(static_cast<int>(Patch::Type::UNKNOWN), os);   // write expressions terminator
        return start_fpos;
    }
}

void OFileWriter::write_symbols(Symtab& symtab, ofstream& os) {
    for (auto& it : symtab) {
        auto symbol = it.second;

        if (symbol->type() != Symbol::Type::Undef) {
            // write scope - see objfile.c for magic numbers
            switch (symbol->scope()) {
            case Symbol::Scope::None:       xassert(0); break;
            case Symbol::Scope::Local:      swrite_int32(static_cast<int>(symbol->scope()), os); break;
            case Symbol::Scope::Public:     swrite_int32(static_cast<int>(symbol->scope()), os); break;
            case Symbol::Scope::Extern:     swrite_int32(static_cast<int>(symbol->scope()), os); break;
            case Symbol::Scope::Global:
                if (symbol->type() == Symbol::Type::Undef)
                    swrite_int32(static_cast<int>(Symbol::Scope::Extern), os);
                else
                    swrite_int32(static_cast<int>(Symbol::Scope::Public), os);
                break;
            }

            // write type - see objfile.c for magic numbers
            switch (symbol->type()) {
            case Symbol::Type::Undef:       xassert(0); break;
            case Symbol::Type::Constant:    swrite_int32(1, os); break;
            case Symbol::Type::Asmpc:       swrite_int32(2, os); break;
            case Symbol::Type::AsmpcPhased: swrite_int32(1, os); break;
            case Symbol::Type::Computed:    swrite_int32(3, os); break;
            default: xassert(0);
            }

            // write section
            swrite_int32(m_string_table.add_string(symbol->section()->name()), os);

            // write value
            swrite_int32(symbol->value().value(), os);

            // name
            swrite_int32(m_string_table.add_string(symbol->name()), os);

            // location
            swrite_int32(m_string_table.add_string(symbol->location().filename()), os);
            swrite_int32(symbol->location().line_num(), os);
        }
    }
}

streampos OFileWriter::write_externs(ofstream& os) {
    streampos start_fpos = os.tellp();

    write_externs(g_symbols.globals(), os);

    // return -1 if no symbols written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(m_string_table.add_string(""), os);        // write terminator
        return start_fpos;
    }
}

void OFileWriter::write_externs(Symtab& symtab, ofstream& os) {
    for (auto& it : symtab) {
        auto symbol = it.second;

        if (symbol->type() == Symbol::Type::Undef) {
            swrite_int32(m_string_table.add_string(symbol->name()), os);
        }
    }
}

streampos OFileWriter::write_modname(ofstream& os) {
    streampos start_fpos = os.tellp();
    swrite_int32(m_string_table.add_string(g_asm.cur_module()->name()), os);
    return start_fpos;
}

streampos OFileWriter::write_sections(ofstream& os) {
    streampos start_fpos = os.tellp();

    for (auto& section : g_asm.cur_module()->sections()) {
        write_sections(section, os);
        if (got_errors())
            break;
    }

    // return -1 if no sections written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(-1, os);        // write end marker
        return start_fpos;
    }
}

void OFileWriter::write_sections(shared_ptr<Section> section, ofstream& os) {
    // alignment data
    static const char align[sizeof(int32_t)] = { 0 };

    // write size
    unsigned size = section->size();
    if (size > 0x10000) {
        g_errors.error(ErrCode::SegmentOverflow);
    }
    else {
        swrite_int32(size, os);

        // write section name
        swrite_int32(m_string_table.add_string(section->name()), os);

        // write ORG and ALIGN
        swrite_int32(section->origin(), os);
        swrite_int32(section->align(), os);

        // write bytes
        for (auto& instr : section->instrs()) {
            if (instr->size() > 0) {
                os.write(reinterpret_cast<const char*>(&instr->bytes()[0]), instr->size());
            }
        }

        // align to dword size
        unsigned aligned_size = (size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1);
        int extra_bytes = aligned_size - size;
        os.write(align, extra_bytes);
    }
}
