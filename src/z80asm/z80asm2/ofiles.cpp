//-----------------------------------------------------------------------------
// z80asm - writing of object files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "ofiles.h"
#include "xassert.h"
#include <cstring>
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

ObjFileWriter::ObjFileWriter(const string& obj_filename)
    : obj_filename_(obj_filename) {
}

void ObjFileWriter::write() {
    if (g_options.verbose())
        cout << "Writing object file '" << obj_filename_ << "'" << endl;

    // create temp file
    string temp_filename = obj_filename_ + "~";
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
    std::remove(obj_filename_.c_str());
    int rv = std::rename(temp_filename.c_str(), obj_filename_.c_str());
    if (rv != 0) {
        g_errors.error(ErrFileRename, temp_filename);
        perror(temp_filename.c_str());
        return;
    }
}

void ObjFileWriter::write(ofstream& os) {
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

streampos ObjFileWriter::write_exprs(ofstream& os) {
    streampos start_fpos = os.tellp();

    // write patch expressions
    for (auto& section : g_module().sections()) {
        for (auto& instr : section->instrs()) {
            for (auto& patch : instr->patches()) {
                write_patch_expr(patch, os);
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

void ObjFileWriter::write_exprs(Symtab& symtab, ofstream& os) {
    for (auto& symbol : symtab) {
        if (symbol->is_touched() && !symbol->is_global_def()) {
            if (symbol->type() == TYPE_COMPUTED) {
                Patch* patch = new Patch(RANGE_ASSIGNMENT, 0, 0, 0, symbol->expr()->clone());
                write_expr(symbol->name(), patch, os);
                delete patch;
            }
        }
    }
}

void ObjFileWriter::write_patch_expr(Patch* patch, ofstream& os) {
    write_expr("", patch, os);
}

void ObjFileWriter::write_expr(const string& target_name, Patch* patch, ofstream& os) {
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

    swrite_int32(patch->asmpc(), os);			// ASMPC
    swrite_int32(patch->offset_patch(), os);    // code position
    swrite_int32(patch->opcode_size(), os);     // opcode size

    // target symbol for expression
    swrite_int32(string_table_.add_string(target_name), os);

    // expression
    swrite_int32(string_table_.add_string(patch->expr()->text()), os);
}

streampos ObjFileWriter::write_symbols(ofstream& os) {
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

void ObjFileWriter::write_symbols(Symtab& symtab, ofstream& os) {
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

streampos ObjFileWriter::write_externs(ofstream& os) {
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

void ObjFileWriter::write_externs(Symtab& symtab, ofstream& os) {
    for (auto& symbol : symtab) {
        if (symbol->scope() == SCOPE_EXTERN ||
            (symbol->scope() == SCOPE_GLOBAL && symbol->type() == TYPE_UNDEFINED)) {
            swrite_int32(string_table_.add_string(symbol->name()), os);
        }
    }
}

streampos ObjFileWriter::write_modname(ofstream& os) {
    streampos start_fpos = os.tellp();
    swrite_int32(string_table_.add_string(g_module().name()), os);
    return start_fpos;
}

streampos ObjFileWriter::write_sections(ofstream& os) {
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

void ObjFileWriter::write_sections(Section* section, ofstream& os) {
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

LibFileWriter::LibFileWriter(const string& lib_filename)
    : lib_filename_(lib_filename) {
}

void LibFileWriter::write() {
    if (g_options.verbose())
        cout << "Creating library '" << lib_filename_ << "'" << endl;

    // create temp file
    string temp_filename = lib_filename_ + "~";
    ofstream os{ temp_filename, ios::binary };
    if (!os.is_open()) {
        g_errors.error(ErrFileCreate, temp_filename);
        perror(temp_filename.c_str());
        return;
    }

    // write contents
    write(os);
    if (g_errors.count()) {
        os.close();
        std::remove(temp_filename.c_str());
        return;
    }

    // delete old object and rename temp file
    os.close();
    std::remove(lib_filename_.c_str());
    int rv = std::rename(temp_filename.c_str(), lib_filename_.c_str());
    if (rv != 0) {
        g_errors.error(ErrFileRename, temp_filename);
        perror(temp_filename.c_str());
        return;
    }
}

void LibFileWriter::write(ofstream& os) {
    // write header
    os.write(LIB_FILE_HEADER, sizeof(LIB_FILE_HEADER) - 1);

    // placeholder for defined symbols table
    streampos st_ptr = os.tellp();
    swrite_int32(-1, os);                   // placeholder

    // assemble all cpu/ixiy combinations
    if (g_options.lib_for_all_cpus()) 
        create_objs_for_all_cpus();
    if (g_errors.count())
        return;

    // write object files
    write_all_objects(os);
    if (g_errors.count())
        return;

    // write end marker
    swrite_int32(-1, os);           // next = -1 - last module
    swrite_int32(0, os);            // size = 0  - deleted

    // write string table
    streampos st_pos = defined_symbols_.write(os);
    os.seekp(st_ptr);
    swrite_int32((int)st_pos, os);
    os.seekp(0, ios_base::end);
}

void LibFileWriter::create_objs_for_all_cpus() {
    // libraries have no_swap and swap object files
    // libraries built with -IXIY-soft have only soft-swap object files
    swap_ixiy_t current_swap_ixiy = g_options.swap_ixiy();
    swap_ixiy_t first_ixiy, last_ixiy;
    if (current_swap_ixiy == IXIY_SOFT_SWAP) {
        first_ixiy = last_ixiy = IXIY_SOFT_SWAP;
    }
    else {
        first_ixiy = IXIY_NO_SWAP;
        last_ixiy = IXIY_SWAP;
    }

    // assemble or include object for each cpu-ixiy combination and append to library
    for (const int* cpu = cpu_ids(); *cpu > 0; cpu++) {
        g_options.set_cpu((cpu_t)*cpu);

        for (int ixiy = (int)first_ixiy; ixiy <= (int)last_ixiy; ixiy++) {
            g_options.set_swap_ixiy((swap_ixiy_t)ixiy);

            for (size_t i = 0; i < g_options.input_files().size(); i++) {
                string filename = g_options.input_files()[i];
                string asm_filename = file_asm_filename(filename);
                g_asm.assemble(asm_filename);

                if (g_errors.count())
                    return;
            }
        }
    }
}

void LibFileWriter::write_all_objects(ofstream& os) {
    // get all assebled objects
    for (size_t i = 0; i < g_asm.objects().size(); i++) {
        g_asm.set_cur_object(i);

        if (g_options.verbose())
            cout << "Adding '" << g_object().obj_filename() << "' to library" << endl;

        // header position
        streampos header_pos = os.tellp();

        // read object file blob
        BinFileReader obj(g_object().obj_filename());
        obj.read();
        if (g_errors.count())
            return;

        // write file pointer of next file
        swrite_int32((int)header_pos + 2 * sizeof(int32_t) + (int)obj.size(), os);

        // write module size
        swrite_int32((int)obj.size(), os);

        // write object blob
        os.write((const char*)obj.ptr(), obj.size());

        // lookup defined symbols in object file
        g_object().get_defined_symbols(defined_symbols_);
    }
}

//-----------------------------------------------------------------------------

BinFileReader::BinFileReader(const string& filename)
    : filename_(filename), base_addr_(0), pos_(0) {
}

const string& BinFileReader::filename() const {
    return filename_;
}

size_t BinFileReader::base_addr() const {
    return base_addr_;
}

void BinFileReader::set_base_addr(size_t addr) {
    base_addr_ = addr;
}

void BinFileReader::read() {
    bytes_.clear();

    ifstream ifs(filename_, ios::binary);
    if (!ifs.is_open()) {
        g_errors.error(ErrFileOpen, filename_);
        perror(filename_.c_str());
        return;
    }
    ifs.seekg(0, ios_base::end);
    size_t size = ifs.tellg();
    ifs.seekg(0, std::ios_base::beg);

    bytes_.resize(size);
    ifs.read((char*) &bytes_[0], size);
    if (size != (size_t)ifs.gcount()) {
        g_errors.error(ErrFileRead, filename_);
        return;
    }
}

size_t BinFileReader::tell() const {
    return pos_ - base_addr_;
}

void BinFileReader::seek(size_t addr) {
    pos_ = base_addr_ + addr;
    xassert(pos_ - base_addr_ <= bytes_.size());
}

const byte_t* BinFileReader::ptr() const {
    xassert(pos_ - base_addr_ <= bytes_.size());
    return &bytes_[pos_ - base_addr_];
}

size_t BinFileReader::size() const {
    return bytes_.size();
}

int BinFileReader::read_int32() {
    xassert(pos_ - base_addr_ + sizeof(int32_t) <= bytes_.size());
    int n = sread_int32(ptr());
    pos_ += sizeof(int32_t);
    return n;
}

//-----------------------------------------------------------------------------

ObjFileReader::ObjFileReader(const string& obj_filename)
    : bin_file_(obj_filename) {
}

void ObjFileReader::read() {
    g_errors.push_location(Location(bin_file_.filename()));
    read1();
    g_errors.pop_location();
}

bool ObjFileReader::seek_ptr(int n) {
    bin_file_.seek(SIGNATURE_SIZE + (2 + n) * sizeof(int32_t));
    int ptr = bin_file_.read_int32();
    if (ptr < 0)
        return false;
    else {
        bin_file_.seek(ptr);
        return true;
    }
}

bool ObjFileReader::seek_modname() {
    return seek_ptr(0);
}

bool ObjFileReader::seek_exprs() {
    return seek_ptr(1);
}

bool ObjFileReader::seek_defined_names() {
    return seek_ptr(2);
}

bool ObjFileReader::seek_external_names() {
    return seek_ptr(3);
}

bool ObjFileReader::seek_sections() {
    return seek_ptr(4);
}

bool ObjFileReader::seek_string_table() {
    return seek_ptr(5);
}

int ObjFileReader::read_int32() {
    return bin_file_.read_int32();
}

string ObjFileReader::read_string() {
    int n = read_int32();
    return string_table_.lookup(n);
}

void ObjFileReader::read1() {
    int start_errors = g_errors.count();
    if (!file_is_object_file(bin_file_.filename(), true))
        return;

    bin_file_.read();
    if (start_errors != g_errors.count())
        return;

    parse_string_table();
    if (start_errors != g_errors.count())
        return;

    parse_modname();
    if (start_errors != g_errors.count())
        return;

    parse_sections();
    if (start_errors != g_errors.count())
        return;

    parse_defined_names();
    if (start_errors != g_errors.count())
        return;

    parse_external_names();
    if (start_errors != g_errors.count())
        return;

    parse_exprs();
    if (start_errors != g_errors.count())
        return;
}

void ObjFileReader::parse_string_table() {
    size_t save_pos = bin_file_.tell();
    if (!seek_string_table())
        g_errors.error(ErrNotObjFile, bin_file_.filename());
    else 
        string_table_.parse(bin_file_.ptr());
   
    bin_file_.seek(save_pos);
}

void ObjFileReader::parse_modname() {
    if (!seek_modname())
        g_errors.error(ErrNotObjFile, bin_file_.filename());
    else {
        string modname = read_string();
        g_object().select_module(modname);
    }
}

void ObjFileReader::parse_sections() {
    if (!seek_sections())
        return;

    bool first_section = true;
    while (true) {				// read sections until end marker
        int code_size = read_int32();
        if (code_size < 0)		// end marker
            break;

        // next section
        string section_name = read_string();
        g_module().select_section(section_name);

        int origin = read_int32();
        g_section().set_origin(origin);

        int align = read_int32();
        g_section().set_align(align);

        // if creating relocatable code, ignore origin 
        if (g_options.relocatable() && g_section().origin() >= 0) {
            g_errors.warning(ErrOrgIgnored,
                string("file ") + bin_file_.filename() + ", section " + section_name);

            g_section().set_origin(ORG_NOT_DEFINED);
            g_section().set_section_split(false);
        }

        // if running appmake, ignore origin except for first module
        if (g_options.appmake() && g_section().origin() >= 0 && !first_section) {
            g_errors.warning(ErrOrgIgnored,
                string("file ") + bin_file_.filename() + ", section " + section_name);

            g_section().set_origin(ORG_NOT_DEFINED);
            g_section().set_section_split(false);
        }

        // load bytes to section
        Instr* instr = g_section().add_instr();
        if (code_size > 0) {
            instr->bytes().resize(code_size);
            memcpy(&instr->bytes()[0], bin_file_.ptr(), code_size);
        }

        // align to dword size
        int aligned_size = ((code_size + (sizeof(int32_t) - 1)) & ~(sizeof(int32_t) - 1));
        bin_file_.seek(bin_file_.tell() + aligned_size);

        first_section = false;
    }
}

void ObjFileReader::parse_defined_names() {
    if (!seek_defined_names())
        return;

    while (true) {				// read symbols until end marker
        sym_scope_t scope = (sym_scope_t)read_int32();			// scope of symbol
        if (scope == SCOPE_NONE)								// end marker
            break;
        else if (scope == SCOPE_LOCAL || scope == SCOPE_PUBLIC) {
            // ok
        }
        else {
            g_errors.error(ErrNotObjFile, bin_file_.filename());
            break;
        }

        sym_type_t type = (sym_type_t)read_int32();				// type of symbol

        string section_name = read_string();                    // section
        g_module().select_section(section_name);

        int value = read_int32();					            // value
        string name = read_string();                            // symbol name

        string source_filename = read_string();                 // where defined
        int line_num = read_int32();                            // where defined

        g_errors.push_location(Location(source_filename, line_num));

        Symbol* symbol = new Symbol(name, scope, type, &g_section(), value);
        g_local_symbols().insert(symbol);

        g_errors.pop_location();
    }
}

void ObjFileReader::parse_external_names() {
    if (!seek_external_names())
        return;

    while (true) {				// read symbols until end marker
        string name = read_string();
        if (name.empty())
            break;

        Symbol* symbol = new Symbol(name, SCOPE_EXTERN, TYPE_UNDEFINED, &g_section(), 0);
        g_local_symbols().insert(symbol);
    }
}

void ObjFileReader::parse_exprs() {
    if (!seek_exprs())
        return;

    while (true) {				// read expressions until end marker
        range_t range = (range_t)read_int32();
        if (range == RANGE_UNDEFINED)         // end marker
            break;

        string source_filename = read_string();                 // where defined
        int line_num = read_int32();                            // where defined
        g_errors.push_location(Location(source_filename, line_num));

        string section_name = read_string();                    // section
        g_module().select_section(section_name);

        // patch location
        int asmpc = read_int32();
        int code_pos = read_int32();
        int opcode_size = read_int32();

        // expression
        string target_name = read_string();
        string expr_text = read_string();

        // call parser to interpret expression
        Expr* expr = new Expr;
        Lexer lexer(expr_text);                                 // parse error
        if (!expr->parse_expr(&lexer)) {
            g_errors.error(ErrSyntaxExpr, expr_text);
            delete expr;
        }
        else if (!target_name.empty()) {                        // assignment
            xassert(range == RANGE_ASSIGNMENT);
            Symbol* symbol = g_local_symbols().find(target_name);
            xassert(symbol);
            symbol->set_type(TYPE_COMPUTED);
            symbol->set_section(&g_section());
            symbol->set_expr(expr);
            symbol->set_location(g_errors.location());
        }
        else {                                                  // patch
            xassert(range != RANGE_ASSIGNMENT);
            Instr* instr = g_section().instrs().back();
            Patch* patch = new Patch(range, asmpc, code_pos, opcode_size, expr);
            instr->patches().push_back(patch);
        }

        g_errors.pop_location();
    }
}
