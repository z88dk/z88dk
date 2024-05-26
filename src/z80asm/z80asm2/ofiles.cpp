//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "ofiles.h"
#include "xassert.h"
using namespace std;


OFileWriter::OFileWriter(const string& o_filename)
    : o_filename_(o_filename) {
}

bool OFileWriter::write() {
    if (g_options().verbose())
        cout << "Writing object file '" << o_filename_ << "'" << endl;

    // create temp file
    string temp_filename = o_filename_ + "~";
    ofstream os{ temp_filename, ios::binary };
    if (!os.is_open()) {
        g_errors().error(ErrFileCreate, temp_filename);
        perror(temp_filename.c_str());
        return false;
    }

    // write contents
    write(os);

    // delete old object and rename temp file
    os.close();
    std::remove(o_filename_.c_str());
    int rv = std::rename(temp_filename.c_str(), o_filename_.c_str());
    if (rv != 0) {
        g_errors().error(ErrFileRename, temp_filename);
        perror(temp_filename.c_str());
        return false;
    }

    return true;
}

streampos OFileWriter::write(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write header
    os.write(OBJ_FILE_HEADER, sizeof(OBJ_FILE_HEADER) - 1);

    // write CPU
    swrite_int32(g_options().cpu(), os);
    swrite_int32(g_options().swap_ixiy(), os);

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
    streampos string_table_fpos = string_table_.write(os);
    streampos end_fpos = os.tellp();

    // write pointers to areas
    os.seekp(header_fpos);
#define WRITE_PTR(x, os)	swrite_int32((x) == -1 ? -1 : (int)((x) - start_fpos), os)
    WRITE_PTR(modname_fpos, os);        // 0
    WRITE_PTR(expr_fpos, os);           // 1
    WRITE_PTR(symbols_fpos, os);        // 2
    WRITE_PTR(externs_fpos, os);        // 3
    WRITE_PTR(sections_fpos, os);       // 4
    WRITE_PTR(string_table_fpos, os);   // 5
#undef WRITE_PTR

    os.seekp(end_fpos);

    return start_fpos;
}

streampos OFileWriter::write_exprs(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write patch expressions
    for (auto& section : g_module().sections()) {
        for (auto& instr : section->instrs()) {
            for (auto& patch : instr->patches()) {
                write_patch_expr(instr, patch, os);
            }
        }
    }

    // write expressions of DEFC symbols
    write_exprs(g_symtab(), os);

    // return -1 if no expressions written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(RANGE_UNDEFINED, os);  // write expressions terminator
        return start_fpos;
    }
}

void OFileWriter::write_exprs(Symtab& symtab, ofstream& os) {
    for (auto& symbol : symtab) {
        if (symbol->is_touched() && !symbol->is_global_def()) {
            if (symbol->type() == TYPE_COMPUTED) {
                Patch* patch = new Patch(RANGE_WORD, 0, symbol->expr()->clone());
                write_expr(symbol->name(), nullptr, patch, os);
                delete patch;
            }
        }
    }
}

void OFileWriter::write_patch_expr(Instr* instr, Patch* patch, ofstream& os) {
    write_expr("", instr, patch, os);
}

void OFileWriter::write_expr(const string& target_name, Instr* instr, Patch* patch, ofstream& os) {
    // store type
    if (target_name.empty())
        swrite_int32(patch->range(), os);
    else
        swrite_int32(RANGE_ASSIGNMENT, os);

    // store file name folowed by source line number
    swrite_int32(string_table_.add_string(patch->expr()->location().filename()), os);
    swrite_int32(patch->expr()->location().line_num(), os);

    // store section name
    swrite_int32(string_table_.add_string(patch->expr()->section()->name()), os);

    if (instr) {
        swrite_int32(instr->asmpc(), os);			        // ASMPC
        swrite_int32(instr->asmpc() + patch->offset(), os); // code position
        swrite_int32(instr->size(), os);            // opcode size
    }
    else {
        swrite_int32(0, os);			            // ASMPC
        swrite_int32(0, os);			            // code position
        swrite_int32(0, os);                        // opcode size
    }

    // target symbol for expression
    swrite_int32(string_table_.add_string(target_name), os);

    // expression
    swrite_int32(string_table_.add_string(patch->expr()->text()), os);
}

streampos OFileWriter::write_symbols(ofstream& os) {
    streampos start_fpos = os.tellp();

    write_symbols(g_symtab(), os);

    // return -1 if no symbols written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(SCOPE_NONE, os);   // write expressions terminator
        return start_fpos;
    }
}

void OFileWriter::write_symbols(Symtab& symtab, ofstream& os) {
    for (auto& symbol : symtab) {
        if (symbol->type() != TYPE_UNDEFINED) {
            // write scope
            swrite_int32((int)symbol->scope(), os);

            // write type
            swrite_int32((int)symbol->type(), os);

            // write section
            swrite_int32(string_table_.add_string(symbol->section()->name()), os);

            // write value
            ExprResult res = symbol->eval();
            if (res.ok())
                swrite_int32(res.value(), os);
            else
                swrite_int32(0, os);

            // name
            swrite_int32(string_table_.add_string(symbol->name()), os);

            // location
            swrite_int32(string_table_.add_string(symbol->location().filename()), os);
            swrite_int32(symbol->location().line_num(), os);
        }
    }
}

streampos OFileWriter::write_externs(ofstream& os) {
    streampos start_fpos = os.tellp();

    write_externs(g_symtab(), os);

    // return -1 if no symbols written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(string_table_.add_string(""), os);        // write terminator
        return start_fpos;
    }
}

void OFileWriter::write_externs(Symtab& symtab, ofstream& os) {
    for (auto& symbol : symtab) {
        if (symbol->scope() == SCOPE_EXTERN ||
            (symbol->scope() == SCOPE_GLOBAL && symbol->type() == TYPE_UNDEFINED)) {
            swrite_int32(string_table_.add_string(symbol->name()), os);
        }
    }
}

streampos OFileWriter::write_modname(ofstream& os) {
    streampos start_fpos = os.tellp();
    swrite_int32(string_table_.add_string(g_module().name()), os);
    return start_fpos;
}

streampos OFileWriter::write_sections(ofstream& os) {
    streampos start_fpos = os.tellp();

    for (auto& section : g_module().sections()) {
        write_sections(section, os);
    }

    // return -1 if no symbols written
    streampos end_fpos = os.tellp();
    if (start_fpos == end_fpos)
        return -1;
    else {
        swrite_int32(-1, os);        // write end marker
        return start_fpos;
    }
}

void OFileWriter::write_sections(Section* section, ofstream& os) {
    // alignment data
    static const char align[sizeof(int32_t)] = { 0 };

    // write size
    unsigned size = section->size();
    swrite_int32(size, os);

    // write section name
    swrite_int32(string_table_.add_string(section->name()), os);

    // write ORG and ALIGN
    swrite_int32(section->origin(), os);
    swrite_int32(section->align(), os);

    // write bytes
    for (auto& instr : section->instrs()) {
        if (instr->size() > 0) {
            os.write((const char*)&instr->bytes()[0], instr->size());
        }
    }

    // align to dword size
    size_t aligned_size = (size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1);
    size_t extra_bytes = aligned_size - size;
    os.write(align, extra_bytes);
}
