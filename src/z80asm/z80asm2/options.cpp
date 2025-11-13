//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "utils.h"
#include <filesystem>
#include <iostream>

Options g_options;
std::vector<std::string> g_input_files;

static const std::string copyright =
    "Usage: z88dk-z80asm [options] files...\n"
    "Copyright (C) Paulo Custodio, 2011-2025\n";

static const std::string asm_extension = ".asm";
static const std::string d_extension = ".d";
static const std::string o_extension = ".o";
static const std::string m4_extension = ".m4";
static const std::string perl_extension = ".pl";
static const std::string i_extension = ".i";

void exit_show_copyright(int exit_code) {
    std::cout << copyright;
    exit(exit_code);
}

void exit_show_usage(int exit_code) {
    std::cout
            << copyright
            << "Assembles Z80 assembly source files into binary output.\n\n"
            << "Options:\n"
            // #-------#-------#-------#-------#-------#-------#-------#-------#
            << "  -d           Do not assemble if .o is newer\n"
            << "  -E           Only run the preprocessor, generate file.i\n"
            << "  -h           Show this screen\n"
            << "  -Ipath       Add path to search for source/include files\n"
            << "  -IXIY        Swap IX and IY registers\n"
            << "  -m4OPTS      Options when calling m4\n"
            << "  -MD          Generate Makefile dependency file.d\n"
            << "  -perlOPTS    Options when calling perl\n"
            << "  -ucase       Convert labels to uppercase\n"
            << "  -v           Enable verbose output\n"
            ;
    exit(exit_code);
}

void exit_invalid_option(const std::string& option) {
    g_errors.error(ErrorCode::InvalidOption, option);
    exit(EXIT_FAILURE);
}

static std::string replace_extension(const std::string& filename,
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

static std::string prepend_output_dir(const std::string& filename) {
    namespace fs = std::filesystem;

    if (g_options.output_dir.empty()) {
        return filename;
    }
    else if (filename.substr(0, g_options.output_dir.size() + 1)
             == g_options.output_dir + "/") {
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
            file += g_options.output_dir + "/";
            file += std::string(1, filename[0]) + "/";
            file += std::string(filename.substr(2));
        }
        else {
            file += g_options.output_dir + "/";
            file += filename;
        }
        fs::path path{ file };
        return path.lexically_normal().generic_string();
    }
}

std::string get_asm_filename(const std::string& filename) {
    return replace_extension(filename, asm_extension);
}

std::string get_d_filename(const std::string& filename) {
    return replace_extension(filename, d_extension);
}

std::string get_o_filename(const std::string& filename) {
    return prepend_output_dir(replace_extension(filename, o_extension));
}

std::string get_i_filename(const std::string& filename) {
    return replace_extension(filename, i_extension);
}

bool is_asm_filename(const std::string& filename) {
    return str_ends_with(filename, asm_extension);
}

bool is_o_filename(const std::string& filename) {
    return str_ends_with(filename, o_extension);
}

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
std::string resolve_include_candidate(const std::string& filename,
                                      bool is_angle) {
    namespace fs = std::filesystem;

    std::vector<fs::path> candidates;

    std::string current_dir = parent_dir(filename);
    fs::path fname(filename);

    // If the filename is absolute, try it directly
    if (fname.is_absolute()) {
        candidates.push_back(fname);
    }
    else {
        // For quoted includes: search current file directory first,
        // then include_paths, then CWD
        if (!is_angle) {
            if (!current_dir.empty()) {
                candidates.push_back(fs::path(current_dir) / fname);
            }
            for (const auto& p : g_options.include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            // finally try as given (relative to caller)
            candidates.push_back(fname);
        }
        else {
            // For angle includes: search include_paths, then CWD, then as-given
            for (const auto& p : g_options.include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            candidates.push_back(fname);
        }
    }

    // check candidates
    for (const auto& c : candidates) {
        try {
            fs::path norm = c;
            // Do not require file to be accessible by canonical
            // (it may throw), use exists
            if (fs::exists(norm) && fs::is_regular_file(norm)) {
                try {
                    return norm.lexically_normal().generic_string();
                }
                catch (...) {
                    return norm.generic_string();
                }
            }
        }
        catch (...) {
            // ignore path errors and move on
        }
    }

    return std::string();
}

static std::string check_source(const std::string& filename) {
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
        if (!g_options.date_stamp) {
            // no -d
            if (got_obj) {
                return normalize_path(obj_file.generic_string());
            }
            else {
                return normalize_path(src_file.generic_string());
            }
        }
        else if (fs::last_write_time(obj_file)
                 >= fs::last_write_time(src_file)) {
            // -d and .o is up-to-date
            return normalize_path(obj_file.generic_string());
        }
        else {
            // -d and .o is old
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

// run m4 preprocessor
static std::string run_m4(const std::string& filename) {
    std::string m4_full_path = resolve_include_candidate(filename);
    if (m4_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
        return std::string();
    }

    // file.asm
    std::string asm_filename =
        m4_full_path.substr(0, m4_full_path.size() - m4_extension.size());

    // build m4 command
    std::string m4_cmd = "m4 " + g_options.m4_options +
                         " \"" + m4_full_path + "\" > \"" + asm_filename + "\"";
    if (g_options.verbose) {
        std::cout << "% " << m4_cmd << std::endl;
    }

    if (0 != system(m4_cmd.c_str())) {
        g_errors.error(ErrorCode::CommandFailed, m4_cmd);
        perror("m4");
        return std::string();
    }
    else {
        return search_source_file(asm_filename);
    }
}

// run perl preprocessor
static std::string run_perl(const std::string& filename) {
    std::string perl_full_path = resolve_include_candidate(filename);
    if (perl_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
        return std::string();
    }

    // file.asm
    std::string asm_filename =
        perl_full_path.substr(0, perl_full_path.size() - perl_extension.size());

    // build perl command
    std::string perl_cmd = "perl " + g_options.perl_options +
                           " \"" + perl_full_path + "\" > \"" + asm_filename + "\"";
    if (g_options.verbose) {
        std::cout << "% " << perl_cmd << std::endl;
    }

    if (0 != system(perl_cmd.c_str())) {
        g_errors.error(ErrorCode::CommandFailed, perl_cmd);
        perror("perl");
        return std::string();
    }
    else {
        return search_source_file(asm_filename);
    }
}

// search source file in path, return empty string if not found
std::string search_source_file(const std::string& filename) {
    std::string out_filename;

    if (str_ends_with(filename, m4_extension)) {
        return run_m4(filename);
    }
    else if (str_ends_with(filename, perl_extension)) {
        return run_perl(filename);
    }
    else {
        // check plain filename
        out_filename = check_source(filename);
        if (!out_filename.empty()) {
            return out_filename;
        }

        // check plain file in include path
        out_filename = resolve_include_candidate(filename);
        if (!out_filename.empty()) {
            out_filename = check_source(out_filename);
            if (!out_filename.empty()) {
                return out_filename;
            }
        }

        // check filename with .asm extension
        std::string asm_filename = filename + asm_extension;
        out_filename = check_source(asm_filename);
        if (!out_filename.empty()) {
            return out_filename;
        }

        // check filename with .asm extension in include path
        out_filename = resolve_include_candidate(asm_filename);
        if (!out_filename.empty()) {
            out_filename = check_source(out_filename);
            if (!out_filename.empty()) {
                return out_filename;
            }
        }

        // check filename with .o extension
        std::string o_filename = filename + o_extension;
        out_filename = check_source(o_filename);
        if (!out_filename.empty()) {
            return out_filename;
        }

        // check filename with .o extension in include path
        out_filename = resolve_include_candidate(o_filename);
        if (!out_filename.empty()) {
            out_filename = check_source(out_filename);
            if (!out_filename.empty()) {
                return out_filename;
            }
        }

        // check source file
        asm_filename = get_asm_filename(filename);
        out_filename = check_source(asm_filename);
        if (!out_filename.empty()) {
            return out_filename;
        }

        // check filename with .asm extension in include path
        out_filename = resolve_include_candidate(asm_filename);
        if (!out_filename.empty()) {
            out_filename = check_source(out_filename);
            if (!out_filename.empty()) {
                return out_filename;
            }
        }

        // check object file in output_dir
        o_filename = get_o_filename(filename);
        out_filename = check_source(o_filename);
        if (!out_filename.empty()) {
            return out_filename;
        }

        // check obejct file in output_dir in include path
        out_filename = resolve_include_candidate(o_filename);
        if (!out_filename.empty()) {
            out_filename = check_source(out_filename);
            if (!out_filename.empty()) {
                return out_filename;
            }
        }

        // not found, avoid cascade of errors
        if (!g_errors.has_errors()) {
            g_errors.error(ErrorCode::FileNotFound, filename);
        }

        return std::string();
    }
}
