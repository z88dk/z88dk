//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "strpool.h"
#include "utils.h"
#include "xassert.h"
#include <iostream>
#include <sstream>
using namespace std;

//-----------------------------------------------------------------------------

Errors g_errors;

//-----------------------------------------------------------------------------

Location::Location(const string& filename_, int line_num_)
    : filename(filename_), line_num(line_num_) {
}

void Location::clear() {
    filename.clear();
    line_num = 0;
    source_line.clear();
    expanded_line.clear();
}

void Location::set_filename(const string& filename_) {
    filename = filename_;
    source_line.clear();
    expanded_line.clear();
}

void Location::set_prev_line_num(int prev_line_num) {
    line_num = prev_line_num;
    if (!is_c_source)
        line_num--;
    source_line.clear();
    expanded_line.clear();
}

void Location::set_line_num(int line_num_) {
    line_num = line_num_;
    source_line.clear();
    expanded_line.clear();
}

void Location::set_source_line(const string& line) {
    source_line = line;
    expanded_line.clear();
}

void Location::set_expanded_line(const string& line) {
    expanded_line = line;
}

bool Location::empty() const {
    return filename.empty() && line_num == 0;
}

void Location::inc_line_num() {
    if (!is_c_source)
        line_num++;
}

//-----------------------------------------------------------------------------

static const char* err_messages[] = {
#define X(code, message)		message,
#include "errors.def"
};

void Errors::error(ErrCode err_code, const string& arg) {
    count++;
    show_error("error", err_code, arg);
}

void Errors::warning(ErrCode err_code, const string& arg) {
    show_error("warning", err_code, arg);
}

void Errors::show_error(const string& prefix, ErrCode err_code, const string& arg_) {
    string arg = str_chomp(arg_);

    // error message
    if (!location.filename.empty()) {
        cerr << location.filename << ":";
        if (location.line_num)
            cerr << location.line_num << ":";
        cerr << " ";
    }
    cerr << prefix << ": " << err_messages[err_code];
    if (!arg.empty())
        cerr << ": " << arg;
    cerr << endl;

    // source line - remove extra spaces
    string striped_source_line = str_remove_extra_blanks(location.source_line);
    string striped_expanded_line = str_remove_extra_blanks(location.expanded_line);

    if (!striped_source_line.empty()) {
        cerr << "  ^---- " << striped_source_line << endl;

        // only show expanded line if it differs from source, ignoring blanks
        if (!striped_expanded_line.empty())
            if (str_remove_all_blanks(striped_source_line)
                != str_remove_all_blanks(striped_expanded_line))
                cerr << "      ^---- " << striped_expanded_line << endl;
    }
}

//-----------------------------------------------------------------------------

int get_error_count() {
    return g_errors.count;
}

void clear_error_location() {
    g_errors.location = Location();
}

void set_error_location(const char* filename, int line_num) {
    g_errors.location.set_filename(filename);
    g_errors.location.set_line_num(line_num);
}

const char* get_error_filename() {
    string filename = g_errors.location.filename;
    return spool_add(filename.c_str());
}

int get_error_line_num() {
    return g_errors.location.line_num;
}

void set_error_source_line(const char* line) {
    g_errors.location.set_source_line(line);
}

void set_error_expanded_line(const char* line) {
    g_errors.location.set_expanded_line(line);
}

int get_error_is_c_source() {
    return g_errors.location.is_c_source;
}

void error(int err_code, const char* arg) {
    g_errors.error((ErrCode)err_code, arg ? arg : "");
}

void error_hex2(int err_code, int hex_value) {
    g_errors.error((ErrCode)err_code, int_to_hex(hex_value, 2));
}

void error_hex4(int err_code, int hex_value) {
    g_errors.error((ErrCode)err_code, int_to_hex(hex_value, 4));
}

void error_file_not_found(const char* filename) {
    g_errors.error(ErrFileNotFound, filename);
}

void error_file_open(const char* filename) {
    g_errors.error(ErrFileOpen, filename);
    perror(filename);
}

void error_duplicate_definition_module(const char* modulename, const char* name) {
    g_errors.error(ErrDuplicateDefinition,
        string(modulename) + "::" + string(name));
}

void error_invalid_object_file(const char* filename) {
    g_errors.error(ErrNotObjFile, filename);
}

void error_invalid_library_file(const char* filename) {
    g_errors.error(ErrNotLibFile, filename);
}

void error_org_not_aligned(int origin, int align) {
    g_errors.error(ErrOrgNotAligned,
        "origin=" + int_to_hex(origin, 4) + ", align=" + int_to_hex(align, 2));
}

void error_invalid_object_file_version(const char* filename, int found_version, int expected_version) {
    g_errors.error(ErrObjFileVersion,
        "file=" + string(filename) +
        ", found=" + to_string(found_version) +
        ", expected=" + to_string(expected_version));
}

void error_invalid_library_file_version(const char* filename, int found_version, int expected_version) {
    g_errors.error(ErrLibFileVersion,
        "file=" + string(filename) +
        ", found=" + to_string(found_version) +
        ", expected=" + to_string(expected_version));
}

void error_incompatible_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    const char* cpu_str = cpu_name(got_cpu_id);
    if (cpu_str == NULL)
        error_illegal_cpu(filename, got_cpu_id);
    else {
        error << "file " << filename << " compiled for " << cpu_str
            << ", incompatible with " << cpu_name(option_cpu());
        g_errors.error(ErrCPUIncompatible, error.str());
    }
}

void error_illegal_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    error << "file " << filename << ", cpu_id = " << got_cpu_id;
    g_errors.error(ErrCPUInvalid, error.str());
}

static const char* ixiy_to_string(swap_ixiy_t swap_ixiy) {
    switch (swap_ixiy) {
    case IXIY_NO_SWAP: return "(no option)";
    case IXIY_SWAP: return "-IXIY";
    case IXIY_SOFT_SWAP: return "-IXIY-soft";
    default: xassert(0); return "";
    }
}

void error_incompatible_ixiy(const char* filename, swap_ixiy_t swap_ixiy) {
    ostringstream error;
    error << "file " << filename << " compiled with " << ixiy_to_string(swap_ixiy)
        << ", incompatible with " << ixiy_to_string(g_options.get_swap_ixiy());
    g_errors.error(ErrIXIYIncompatible, error.str());
}

void warning(int err_code, const char* arg) {
    g_errors.warning((ErrCode)err_code, arg ? arg : "");
}

void warning_hex2(int err_code, int hex_value) {
    g_errors.warning((ErrCode)err_code, int_to_hex(hex_value, 2));
}

void warning_org_ignored(const char* filename, const char* section) {
    g_errors.warning(ErrOrgIgnored,
        string("file ") + string(filename) + ", section " + string(section));
}
