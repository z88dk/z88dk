//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "ofiles.h"
#include "xassert.h"
#include <iostream>
using namespace std;

//-----------------------------------------------------------------------------

static bool check_signature(const string& filename, const string& signature_base, int version,
                            bool do_error, bool is_lib) {
    ifstream ifs(filename, ios::binary);

    // open file
    if (!ifs.is_open()) {
        if (do_error) {
            g_errors.error(ErrFileOpen, filename);
            perror(filename.c_str());
        }
        return false;
    }

    // read signature
    char buffer[SIGNATURE_SIZE];
    ifs.read(buffer, sizeof(buffer));
    if (ifs.gcount() != sizeof(buffer)) {
        if (do_error) 
            g_errors.error(is_lib ? ErrNotLibFile : ErrNotObjFile, filename);
        return false;
    }

    // check signature_base
    string got_signature_base = string(buffer, buffer + SIGNATURE_BASE_SIZE);
    if (got_signature_base != signature_base) {
        if (do_error) 
            g_errors.error(is_lib ? ErrNotLibFile : ErrNotObjFile, filename);
        return false;
    }

    // check version
    int got_version = atoi(buffer + SIGNATURE_BASE_SIZE);
    if (got_version != version) {
        if (do_error) 
            g_errors.error(is_lib ? ErrLibFileVersion : ErrObjFileVersion, filename);
        return false;
    }

    // libraries may contain multiple cpu-ixiy combinations
    if (is_lib || g_options.lib_for_all_cpus()) 
        return true;

    // only for object files...

    // has right CPU?
    cpu_t cpu_id = (cpu_t)sread_int32(ifs);
    if (!cpu_compatible(g_options.cpu(), cpu_id)) {
        if (do_error)
            g_errors.error(ErrCPUIncompatible, filename);
        return false;
    }

    // has right -XIIY?
    swap_ixiy_t swap_ixiy = (swap_ixiy_t)sread_int32(ifs);
    if (!ixiy_compatible(g_options.swap_ixiy(), swap_ixiy)) {
        if (do_error)
            g_errors.error(ErrIXIYIncompatible, filename);
        return false;
    }

    // ok
    return true;
}

bool file_is_object_file(const string& filename, bool do_error) {
    return check_signature(filename, OBJ_FILE_SIGNATURE, OBJ_FILE_VERSION, do_error, false);
}

bool file_is_library_file(const string& filename, bool do_error) {
    return check_signature(filename, LIB_FILE_SIGNATURE, OBJ_FILE_VERSION, do_error, true);
}

//-----------------------------------------------------------------------------

OFileWriter::OFileWriter(const string& o_filename)
    : o_filename_(o_filename) {
}

void OFileWriter::write() {
    if (g_options.verbose())
        cout << "Writing object file '" << o_filename_ << "'" << endl;

    // create temp file
    string temp_filename = o_filename_ + "~";
    ofstream os{ temp_filename, ios::binary };
    if (!os.is_open()) {
        g_errors.error(ErrFileCreate, temp_filename);
        perror(temp_filename.c_str());
        return;
    }

    // write contents
    write(os);

    // delete old object and rename temp file
    os.close();
    std::remove(o_filename_.c_str());
    int rv = std::rename(temp_filename.c_str(), o_filename_.c_str());
    if (rv != 0) {
        g_errors.error(ErrFileRename, temp_filename);
        perror(temp_filename.c_str());
        return;
    }
}

void OFileWriter::write(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write header
    os.write(OBJ_FILE_HEADER, sizeof(OBJ_FILE_HEADER) - 1);

    // write CPU
    swrite_int32(g_options.cpu(), os);
    swrite_int32(g_options.swap_ixiy(), os);

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
    write_exprs(g_local_symbols(), os);

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

    write_symbols(g_local_symbols(), os);

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

    write_externs(g_local_symbols(), os);

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

//-----------------------------------------------------------------------------

OFileReader::OFileReader(const string& o_filename)
    : o_filename_(o_filename) {
}
