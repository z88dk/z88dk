//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "cpp/float.h"
#include "if.h"

int get_num_errors() {
    return g_errors.count;
}

void clear_error_location() {
    g_errors.clear();
}

void set_error_location(const char* filename, int line_num) {
    if (filename) {
        g_errors.location.filename = filename;
        g_errors.location.line_num = line_num;
    }
    else
        g_errors.clear();
}

const char* get_error_filename() {
    string filename = g_errors.location.filename;
    return spool_add(filename.c_str());
}

int get_error_line_num() {
    return g_errors.location.line_num;
}

void set_error_source_line(const char* line) {
    g_errors.source_line = line;
    g_errors.expanded_line.clear();
}

void set_error_expanded_line(const char* line) {
    g_errors.expanded_line = line;
}

void error_file_not_found(const char* filename) {
    g_errors.error(Errors::Code::file_not_found, filename);
}

void error_file_open(const char* filename) {
    g_errors.os_error(Errors::Code::file_open, filename);
}

void error_file_rename(const char* filename) {
    g_errors.os_error(Errors::Code::file_rename, filename);
}

void error_duplicate_definition(const char* name) {
    g_errors.error(Errors::Code::duplicate_definition, name);
}

void error_duplicate_definition_module(const char* modulename, const char* name) {
    g_errors.error(Errors::Code::duplicate_definition, string(modulename) + "::" + string(name));
}

void error_missing_quote() {
    g_errors.error(Errors::Code::missing_quote);
}

void error_invalid_char_const() {
    g_errors.error(Errors::Code::invalid_character_constant);
}

void error_syntax_error() {
    g_errors.error(Errors::Code::syntax_error);
}

void error_syntax_error_in_expression() {
    g_errors.error(Errors::Code::syntax_in_expression);
}

void error_segment_overflow() {
    g_errors.error(Errors::Code::segment_overflow);
}

void warning_org_ignored(const char* filename, const char* section) {
    g_errors.warning(Errors::Code::org_ignored, string("file ") + string(filename) + ", section " + string(section));
}

void error_org_redefined() {
    g_errors.error(Errors::Code::org_redefined);
}

void error_integer_range(int value) {
    g_errors.error(Errors::Code::integer_range, int_to_hex(value, 2));
}

void warning_integer_range(int value) {
    g_errors.warning(Errors::Code::integer_range, int_to_hex(value, 2));
}

void error_invalid_object_file(const char* filename) {
    g_errors.error(Errors::Code::invalid_object_file, filename);
}

void error_invalid_library_file(const char* filename) {
    g_errors.error(Errors::Code::invalid_library_file, filename);
}

void warning_expr_in_parens() {
    g_errors.warning(Errors::Code::expr_in_parens);
}

void error_string_longer_than_reserved_space() {
    g_errors.error(Errors::Code::string_longer_than_reserved_space);
}

void error_division_by_zero() {
    g_errors.error(Errors::Code::division_by_zero);
}

void error_missing_bracket_block() {
    g_errors.error(Errors::Code::missing_bracket_block);
}

void error_bracket_block_not_closed() {
    g_errors.error(Errors::Code::bracket_block_not_closed);
}

void error_undefined_symbol(const char* name) {
    g_errors.error(Errors::Code::undefined_symbol, name);
}

void error_illegal_identifier() {
    g_errors.error(Errors::Code::illegal_identifier);
}

void error_constant_expression_expected() {
    g_errors.error(Errors::Code::constant_expression_expected);
}

void error_symbol_redeclaration(const char* name) {
    g_errors.error(Errors::Code::symbol_redeclaration, name);
}

void error_recursive_expression() {
    g_errors.error(Errors::Code::recursive_expression);
}

void error_align_redefined() {
    g_errors.error(Errors::Code::align_redefined);
}

void error_org_not_aligned(int origin, int align) {
    g_errors.error(Errors::Code::org_not_aligned, 
        "origin=" + int_to_hex(origin, 4) + ", align=" + int_to_hex(align, 2));
}

void error_invalid_org(int origin) {
    g_errors.error(Errors::Code::invalid_org, int_to_hex(origin, 4));
}

void error_invalid_object_file_version(const char* filename, int found_version, int expected_version) {
    g_errors.error(Errors::Code::invalid_object_file_version, 
        "file=" + string(filename) +
        ", found=" + to_string(found_version) +
        ", expected=" + to_string(expected_version));
}

void error_invalid_library_file_version(const char* filename, int found_version, int expected_version) {
    g_errors.error(Errors::Code::invalid_library_file_version, 
        "file=" + string(filename) +
        ", found=" + to_string(found_version) +
        ", expected=" + to_string(expected_version));
}

void error_dma_base_register_byte_illegal(int value) {
    g_errors.error(Errors::Code::dma_base_register_byte_illegal, int_to_hex(value, 2));
}

void error_dma_missing_register_group_members() {
    g_errors.error(Errors::Code::dma_missing_register_group_members);
}

void error_dma_too_many_arguments() {
    g_errors.error(Errors::Code::dma_too_many_arguments);
}

void error_dma_illegal_port_a_timing() {
    g_errors.error(Errors::Code::dma_illegal_port_a_timing);
}

void error_dma_illegal_port_b_timing() {
    g_errors.error(Errors::Code::dma_illegal_port_b_timing);
}

void error_dma_does_not_support_interrupts() {
    g_errors.error(Errors::Code::dma_does_not_support_interrupts);
}

void warning_dma_does_not_support_some_features() {
    g_errors.warning(Errors::Code::dma_does_not_support_some_features);
}

void warning_dma_does_not_implement_this_command() {
    g_errors.warning(Errors::Code::dma_does_not_implement_this_command);
}

void error_dma_illegal_mode() {
    g_errors.error(Errors::Code::dma_illegal_mode);
}

void error_dma_illegal_command() {
    g_errors.error(Errors::Code::dma_illegal_command);
}

void error_dma_illegal_read_mask() {
    g_errors.error(Errors::Code::dma_illegal_read_mask);
}

void warning_dma_does_not_support_half_cycle_timing() {
    g_errors.warning(Errors::Code::dma_does_not_support_half_cycle_timing);
}

void warning_dma_does_not_support_ready_signals() {
    g_errors.warning(Errors::Code::dma_does_not_support_ready_signals);
}

void error_command_failed(const char* cmd) {
    g_errors.error(Errors::Code::command_failed, cmd);
}

void error_assertion_failed() {
    g_errors.error(Errors::Code::assertion_failed);
}

void error_incompatible_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    const char* cpu_str = cpu_name(got_cpu_id);
    if (cpu_str == NULL)
        error_illegal_cpu(filename, got_cpu_id);
    else {
        error << "file " << filename << " compiled for " << cpu_str
            << ", incompatible with " << cpu_name(static_cast<cpu_t>(option_cpu()));
        g_errors.error(Errors::Code::incompatible_cpu, error.str());
    }
}

void error_illegal_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    error << "file " << filename << ", cpu_id = " << got_cpu_id;
    g_errors.error(Errors::Code::illegal_cpu, error.str());
}

void error_incompatible_ixiy(const char* filename, swap_ixiy_t swap_ixiy) {
    ostringstream error;
    error << "file " << filename << " compiled with "
        << swap_ixiy_name(static_cast<SwapIXIY>(swap_ixiy))
        << ", incompatible with "
        << swap_ixiy_name(g_args.opt_swap_ixiy);
    g_errors.error(Errors::Code::incompatible_ixiy, error.str());
}

bool option_verbose() {
    return g_args.opt_verbose;
}

int option_swap_ixiy() {
    return static_cast<int>(g_args.opt_swap_ixiy);
}

void set_swap_ixiy_option(int swap_ixiy) {
    g_args.set_swap_ixiy(swap_ixiy);
    for (auto& define : swap_ixiy_all_defines()) {
        undefine_static_def_sym(define.c_str());
        undefine_local_def_sym(define.c_str());
    }
    for (auto& define : swap_ixiy_defines(g_args.opt_swap_ixiy)) {
        define_static_def_sym(define.c_str(), 1);
        define_local_def_sym(define.c_str(), 1);
    }
}

void push_includes(const char* dir) {
    g_args.opt_include_path.push_back(dir);
}

void pop_includes() {
    g_args.opt_include_path.pop_back();
}

const char* search_includes(const char* filename) {
    string searched_file = g_args.search_include_path(filename);
    return spool_add(searched_file.c_str());
}

int option_cpu() {
    return static_cast<int>(g_args.opt_cpu);
}

void set_cpu_option(int cpu_id) {
    if (!g_args.set_cpu(cpu_id))
        g_errors.error(Errors::Code::illegal_cpu, to_string(cpu_id));
    else {
        for (auto& define : cpu_all_defines()) {
            undefine_static_def_sym(define.c_str());
            undefine_local_def_sym(define.c_str());
        }

        for (auto& define : cpu_defines(g_args.opt_cpu)) {
            define_static_def_sym(define.c_str(), 1);
            define_local_def_sym(define.c_str(), 1);
        }
    }
}

bool option_ti83() {
    return g_args.opt_ti83;
}

bool option_ti83plus() {
    return g_args.opt_ti83plus;
}

bool option_speed() {
    return g_args.opt_speed;
}

bool option_debug() {
    return g_args.opt_debug;
}

const char* search_libraries(const char* filename) {
    string searched_file = g_args.search_library_path(filename);
    return spool_add(searched_file.c_str());
}

const char* option_lib_file() {
    string filename = g_args.opt_lib_file;
    if (filename.empty())
        return nullptr;
    else
        return spool_add(filename.c_str());
}

bool option_lib_for_all_cpus() {
    return !g_args.opt_lib_file.empty() && g_args.opt_lib_for_all_cpus;
}

const char* option_bin_file() {
    string filename = g_args.opt_bin_file;
    if (filename.empty())
        return nullptr;
    else
        return spool_add(filename.c_str());
}

bool option_make_bin() {
    return g_args.opt_make_bin;
}

bool option_split_bin() {
    return g_args.opt_split_bin;
}

bool option_date_stamp() {
    return g_args.opt_date_stamp;
}

bool option_relocatable() {
    return g_args.opt_relocatable;
}

bool option_reloc_info() {
    return g_args.opt_reloc_info;
}

int option_filler() {
    return g_args.opt_filler;
}

bool option_symtable() {
    return g_args.opt_symtable;
}

bool option_list_file() {
    return g_args.opt_list_file;
}

bool option_map() {
    return g_args.opt_map_file;
}

bool option_globaldef() {
    return g_args.opt_globaldef;
}

bool option_consol_obj_file() {
    return !g_args.opt_consol_obj_file.empty();
}

const char* option_consol_obj_file_name() {
    string filename = g_args.opt_consol_obj_file;
    if (filename.empty())
        return nullptr;
    else 
        return spool_add(get_o_filename(filename.c_str()));
}

int option_appmake() {
    return static_cast<int>(g_args.opt_appmake);
}

const char* path_parent_dir(const char* filename) {
    fs::path file_path{ filename };
    string parent;

    if (!file_path.has_parent_path())
        parent = ".";
    else
        parent = file_path.parent_path().generic_string();

    return spool_add(parent.c_str());
}

bool path_file_exists(const char* filename) {
    fs::path file_path{ filename };

    if (fs::is_regular_file(file_path))
        return true;
    else
        return false;
}

const char* path_replace_ext(const char* filename, const char* ext) {
    fs::path file_path{ filename };
    file_path.replace_extension(ext);
    string new_file = file_path.generic_string();
    return spool_add(new_file.c_str());
}

const char* get_asm_filename(const char* filename) {
    return spool_add(g_args.asm_filename(filename).c_str());
}

const char* get_lis_filename(const char* filename) {
    return spool_add(g_args.lis_filename(filename).c_str());
}

const char* get_o_filename(const char* filename) {
    return spool_add(g_args.o_filename(filename).c_str());
}

const char* get_def_filename(const char* filename) {
    return spool_add(g_args.def_filename(filename).c_str());
}

const char* get_bin_filename(const char* filename, const char* section) {
    return spool_add(g_args.bin_filename(filename, section).c_str());
}

const char* get_lib_filename(const char* filename) {
    return spool_add(g_args.lib_filename(filename).c_str());
}

const char* get_sym_filename(const char* filename) {
    return spool_add(g_args.sym_filename(filename).c_str());
}

const char* get_map_filename(const char* filename) {
    return spool_add(g_args.map_filename(filename).c_str());
}

const char* get_reloc_filename(const char* bin_filename) {
    return spool_add(g_args.reloc_filename(bin_filename).c_str());
}

size_t option_files_size() {
    return g_args.files.size();
}

const char* option_file(size_t n) {
    return spool_add(g_args.files[n].c_str());
}

bool option_debug_z80asm() {
    return g_args.opt_debug_z80asm;
}

void copy_static_defines() {
    for (auto& define : g_static_defines) {
        define_local_def_sym(define.first.c_str(), define.second);
    }
}

int option_origin() {
    return g_args.opt_origin;
}

void append_option_libraries() {
    for (auto& library : g_args.opt_libraries)
        library_file_append(library.c_str());
}

void set_global_float_format() {
    g_float_format.set(static_cast<FloatFormat::Format>(g_args.opt_zfloat));
}
