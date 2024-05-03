//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "options.h"
#include <string>
#include <vector>
#include <iostream>
using namespace std;

void Options::parse_args(const vector<string>& args) {
    for (auto& arg : args)
        cout << arg << endl;
}

cpu_t Options::cpu() const {
    return cpu_;
}

bool Options::ti83() const {
    return ti83_;
}

bool Options::ti83plus() const {
    return ti83plus_;
}

swap_ixiy_t Options::swap_ixiy() const {
    return swap_ixiy_;
}

bool Options::verbose() const {
    return verbose_;
}

bool Options::upper_case() const {
    return upper_case_;
}

bool Options::raw_strings() const {
    return raw_strings_;
}

bool Options::opt_speed() const {
    return opt_speed_;
}

bool Options::debug() const {
    return debug_;
}

const string& Options::lib_file() const {
    return lib_file_;
}

bool Options::lib_for_all_cpus() const {
    return lib_for_all_cpus_;
}

const string& Options::output_dir() const {
    return output_dir_;
}

const string& Options::bin_filename() const {
    return bin_filename_;
}

bool Options::make_bin() const {
    return make_bin_;
}

bool Options::split_bin() const {
    return split_bin_;
}

bool Options::date_stamp() const {
    return date_stamp_;
}

bool Options::relocatable() const {
    return relocatable_;
}

bool Options::reloc_info() const {
    return reloc_info_;
}

int Options::filler() const {
    return filler_;
}

bool Options::symtable() const {
    return symtable_;
}

bool Options::list_file() const {
    return list_file_;
}

bool Options::map_file() const {
    return map_file_;
}

bool Options::global_def() const {
    return global_def_;
}

appmake_t Options::appmake() const {
    return appmake_;
}

bool Options::debug_z80asm() const {
    return debug_z80asm_;
}

const string& Options::m4_options() const {
    return m4_options_;
}

vector<string>& Options::include_path() {
    return include_path_;
}

vector<string>& Options::library_path() {
    return library_path_;
}

const string& Options::consol_obj_filename() const {
    return consol_obj_filename_;
}

void Options::set_cpu(cpu_t cpu) {
    cpu_ = cpu;
}

void Options::set_swap_ixiy(swap_ixiy_t swap) {
    swap_ixiy_ = swap;
}

void Options::set_upper_case(bool f) {
    upper_case_ = f;
}

void Options::set_raw_strings(bool f) {
    raw_strings_ = f;
}

void Options::set_output_dir(const string& dir) {
    output_dir_ = dir;
}

void Options::set_bin_filename(const string& filename) {
    bin_filename_ = filename;
}
