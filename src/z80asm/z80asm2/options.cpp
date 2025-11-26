//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "utils.h"
#include <filesystem>
#include <iostream>
#include <set>

Options g_options;

static const std::string asm_extension = ".asm";
static const std::string d_extension = ".d";
static const std::string o_extension = ".o";
static const std::string m4_extension = ".m4";
static const std::string perl_extension = ".pl";
static const std::string cpp_extension = ".cpp";
static const std::string i_extension = ".i";

void exit_invalid_option(const std::string& option) {
    g_errors.error(ErrorCode::InvalidOption, option);
    exit(EXIT_FAILURE);
}

bool Options::parse_arg(const std::string& arg) {
    if (arg.empty()) {
        return true;
    }

    std::string option_arg;
    if (arg[0] == '-' || arg[0] == '+') {
        switch (arg[1]) {
        case 'M':
            if (arg == "-MD") {
                gen_dependencies = true;
            }
            else {
                return false;
            }
            break;
        default:
            return false;
        }
    }
    else {
        // input file
        search_source_file(arg);
    }

    return true;
}

bool Options::is_option_arg(const std::string& arg, const std::string& option,
                            std::string& option_arg) {
    option_arg.clear();

    if (arg.size() > option.size() &&
            arg.substr(0, option.size()) == option) {
        option_arg = arg.substr(option.size());
        if (!option_arg.empty() && option_arg.front() == '=') {
            option_arg = option_arg.substr(1);
        }
    }

    return !option_arg.empty();
}

std::string Options::replace_extension(const std::string& filename,
                                       const std::string& extension) {
    try {
        std::filesystem::path p(filename);
        p.replace_extension(extension);
        return p.lexically_normal().generic_string();
    }
    catch (...) {
        return filename;
    }
}

std::string Options::get_asm_filename(const std::string& filename) {
    return replace_extension(filename, asm_extension);
}

std::string Options::get_d_filename(const std::string& filename) {
    return replace_extension(filename, d_extension);
}

std::string Options::get_o_filename(const std::string& filename) {
    return replace_extension(filename, o_extension);
}

std::string Options::get_i_filename(const std::string& filename) {
    return replace_extension(filename, i_extension);
}

bool Options::is_asm_filename(const std::string& filename) {
    return str_ends_with(filename, asm_extension);
}

bool Options::is_o_filename(const std::string& filename) {
    return str_ends_with(filename, o_extension);
}

std::string Options::check_source(const std::string& filename) {
    namespace fs = std::filesystem;

    // avoid cascade of errors
    if (g_errors.has_errors()) {
        return normalize_path(filename);
    }

    fs::path file_path(filename);
    fs::path src_file, obj_file;
    bool got_obj = false;

    if (is_o_filename(filename)) {
        got_obj = true;
        obj_file = file_path;
        src_file = replace_extension(filename, asm_extension);
    }
    else if (is_asm_filename(filename)) {
        got_obj = false;
        src_file = file_path;
        obj_file = replace_extension(filename, o_extension);
    }
    else if (fs::is_regular_file(file_path)) {  // ASM with different extension
        got_obj = false;
        src_file = file_path;
        obj_file = replace_extension(filename, o_extension);
    }
    else {
        return std::string();
    }

    bool src_ok = fs::is_regular_file(src_file);
    bool obj_ok = fs::is_regular_file(obj_file);

    // if both .o and .asm exist, return .asm or .o if -d and .o is newer
    // NOTE: -d must come before the file to have effect
    if (src_ok && obj_ok) {
        // no -d
        if (got_obj) {
            return normalize_path(obj_file.generic_string());
        }
        else {
            return normalize_path(src_file.generic_string());
        }
    }
    else if (!got_obj && src_ok) {
        return normalize_path(src_file.generic_string());
    }
    else if (got_obj && obj_ok) {
        return normalize_path(obj_file.generic_string());
    }
    else {
        return std::string();
    }
}

// search source file in path, return empty string if not found
void Options::search_source_file(const std::string& filename_) {
    std::string filename = trim(filename_);
    std::string out_filename;

    // check plain filename
    out_filename = check_source(filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check plain file in include path (and CWD)
    out_filename = filename;
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .asm extension
    std::string asm_filename = filename + asm_extension;
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = asm_filename;
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .o extension
    std::string o_filename = filename + o_extension;
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check filename with .o extension in include path
    out_filename = o_filename;
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // check source file
    asm_filename = get_asm_filename(filename);
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = asm_filename;
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // check object file in include path
    o_filename = get_o_filename(filename);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check object file in include path
    out_filename = o_filename;
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // not found, avoid cascade of errors
    if (!g_errors.has_errors()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
    }
}
