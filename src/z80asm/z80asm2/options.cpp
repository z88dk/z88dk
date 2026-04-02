//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "expr.h"
#include "lexer.h"
#include "options.h"
#include "preprocessor.h"
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

bool Options::parse_arg(const std::string& arg) {
    if (arg.empty()) {
        return true;
    }

    std::string option_arg;
    int option_value = 0;
    if (arg[0] == '-' || arg[0] == '+') {
        switch (arg[1]) {
        case 'E':
            if (arg == "-E") {
                preprocess_only = true;
            }
            else {
                return false;
            }
            break;
        case 'I':
            if (is_option_arg(arg, "-I", option_arg)) {
                include_paths.push_back(option_arg);
            }
            else {
                return false;
            }
            break;
        case 'M':
            if (arg == "-MD") {
                gen_dependencies = true;
            }
            else {
                return false;
            }
            break;
        case 'O':
            if (is_option_arg(arg, "-O", option_arg)) {
                output_dir = option_arg;
            }
            else {
                return false;
            }
            break;
        case 'f':
            if (is_const_expr_arg(arg, "-f", option_value)) {
                if (option_value < 0 || option_value > 255) {
                    return false;
                }
                filler_byte = static_cast<uint8_t>(option_value);
            }
            else {
                return false;
            }
            break;
        case 'v':
            if (arg == "-v") {
                verbose = true;
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

bool Options::is_const_expr_arg(const std::string& arg,
                                const std::string& opt, int& value) {
    value = 0;
    std::string option_arg;
    if (!is_option_arg(arg, opt, option_arg)) {
        return false;
    }

    Preprocessor pp;
    pp.push_virtual_file(option_arg, "<cmd-line>", 0, true);
    TokenLine line;
    if (!pp.next_line(line)) {
        return false;
    }

    Expression expr;
    size_t i = 0;
    if (!expr.parse(line, i, nullptr, nullptr)) {
        return false;
    }
    if (!expr.is_constant()) {
        return false;
    }

    value = expr.evaluate();
    return true;
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

std::string Options::prepend_output_dir(const std::string& filename) {
    namespace fs = std::filesystem;

    if (output_dir.empty()) {
        return filename;
    }
    else if (filename.substr(0, output_dir.size() + 1) == output_dir + "/") {
        // #2260: may be called with an object file already with
        // the path prepended; do not add it twice
        return filename;
    }
    else {
        // NOTE: concatenation (/) of a relative fs::path and an
        // absolute fs::path discards the first one! Do our magic
        // with strings instead.
        // is it a win32 absolute path?
        std::string file;
        if (isalpha(filename[0]) && filename[1] == ':') {	// C:
            file += output_dir + "/";
            file += std::string(1, filename[0]) + "/";
            file += std::string(filename.substr(2));
        }
        else {
            file += output_dir + "/";
            file += filename;
        }
        fs::path path{ file };
        return path.lexically_normal().generic_string();
    }
}

std::string Options::get_asm_filename(const std::string& filename) {
    return replace_extension(filename, asm_extension);
}

std::string Options::get_d_filename(const std::string& filename) {
    return replace_extension(filename, d_extension);
}

std::string Options::get_o_filename(const std::string& filename) {
    return prepend_output_dir(replace_extension(filename, o_extension));
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

// search source file in path, return empty string if not found
void Options::search_source_file(const std::string& filename) {
    input_files.push_back(filename);
}
