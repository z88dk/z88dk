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

static const std::string copyright =
    "Usage: z88dk-z80asm [options] files...\n"
    "Copyright (C) Paulo Custodio, 2011-2026\n";

static const std::string asm_extension = ".asm";
static const std::string d_extension = ".d";
static const std::string o_extension = ".o";
static const std::string m4_extension = ".m4";
static const std::string perl_extension = ".pl";
static const std::string cpp_extension = ".cpp";
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
            << "  -cpp=OPTS    Options when calling cpp\n"
            << "  -d           Do not assemble if .o is newer\n"
            << "  -E           Only run the preprocessor, generate file.i\n"
            << "  -h           Show this screen\n"
            << "  -Ipath       Add path to search for source/include files\n"
            << "  -IXIY        Swap IX and IY registers\n"
            << "  -m4=OPTS     Options when calling m4\n"
            << "  -MD          Generate Makefile dependency file.d\n"
            << "  -perl=OPTS   Options when calling perl\n"
            << "  -ucase       Convert labels to uppercase\n"
            << "  -v           Enable verbose output\n"
            ;
    exit(exit_code);
}

void exit_invalid_option(const std::string& option) {
    g_errors.error(ErrorCode::InvalidOption, option);
    exit(EXIT_FAILURE);
}

bool Options::parse_arg(const std::string& arg, bool& found_dash_dash) {
    if (arg.empty()) {
        return true;
    }

    std::string option_arg;
    if (!found_dash_dash && (arg[0] == '-' || arg[0] == '+')) {
        switch (arg[1]) {
        case '-':
            if (arg == "--") {
                found_dash_dash = true;
            }
            else {
                return false;
            }
            break;
        case 'E':
            if (arg == "-E") {
                preprocess_only = true;
            }
            else {
                return false;
            }
            break;
        case 'I':
            if (arg == "-IXIY") {
                swap_ix_iy = true;
            }
            else if (is_option_arg(arg, "-I", option_arg)) {
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
        case 'c':
            if (is_option_arg(arg, "-cpp", option_arg)) {
                if (!cpp_options.empty()) {
                    cpp_options.push_back(' ');
                }
                cpp_options += option_arg;
            }
            else {
                return false;
            }
            break;
        case 'd':
            if (arg == "-d") {
                date_stamp = true;
            }
            else {
                return false;
            }
            break;
        case 'h':
            if (arg == "-h") {
                exit_show_usage(EXIT_SUCCESS);
            }
            else {
                return false;
            }
            break;
        case 'm':
            if (is_option_arg(arg, "-m4", option_arg)) {
                if (!m4_options.empty()) {
                    m4_options.push_back(' ');
                }
                m4_options += option_arg;
            }
            else {
                return false;
            }
            break;
        case 'p':
            if (is_option_arg(arg, "-perl", option_arg)) {
                if (!perl_options.empty()) {
                    perl_options.push_back(' ');
                }
                perl_options += option_arg;
            }
            else {
                return false;
            }
            break;
        case 'u':
            if (arg == "-ucase") {
                ucase_labels = true;
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

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
// including_filename: the file which contains the include directive (can be empty if unknown)
std::string Options::resolve_include_candidate(const std::string& filename,
        const std::string& including_filename, bool is_angle) {
    namespace fs = std::filesystem;

    std::vector<fs::path> candidates;

    fs::path fname(filename);

    // If the filename is absolute, try it directly
    if (fname.is_absolute()) {
        candidates.push_back(fname);
    }
    else {
        // Determine including file directory, if provided
        std::string including_dir = parent_dir(including_filename);
        if (including_dir.empty()) {
            including_dir = ".";
        }

        if (!is_angle) {
            // Quoted or plain include: try including file directory first (if known)
            if (!including_dir.empty()) {
                candidates.push_back(fs::path(including_dir) / fname);
            }
            // Then user-provided include paths
            for (const auto& p : include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            // Finally as-given (relative to current working dir of the process)
            candidates.push_back(fname);
        }
        else {
            // Angle includes: search include paths, then as-given
            for (const auto& p : include_paths) {
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
        if (!date_stamp) {
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
void Options::run_m4(const std::string& filename) {
    std::string m4_full_path = resolve_include_candidate(filename, "", false);
    if (m4_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
        return;
    }

    // file.asm
    std::string asm_filename =
        m4_full_path.substr(0, m4_full_path.size() - m4_extension.size());

    // build m4 command
    std::string m4_cmd = "m4 " + m4_options +
                         " \"" + m4_full_path + "\" > \"" + asm_filename + "\"";
    if (verbose) {
        std::cout << "% " << m4_cmd << std::endl;
    }

    if (0 != system(m4_cmd.c_str())) {
        g_errors.error(ErrorCode::CommandFailed, m4_cmd);
        perror("m4");
        return;
    }

    // process generated asm file
    search_source_file(asm_filename);
}

// run perl preprocessor
void Options::run_perl(const std::string& filename) {
    std::string perl_full_path = resolve_include_candidate(filename, "", false);
    if (perl_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
        return;
    }

    // file.asm
    std::string asm_filename =
        perl_full_path.substr(0, perl_full_path.size() - perl_extension.size());

    // build perl command
    std::string perl_cmd = "perl " + perl_options +
                           " \"" + perl_full_path + "\" > \"" + asm_filename + "\"";
    if (verbose) {
        std::cout << "% " << perl_cmd << std::endl;
    }

    if (0 != system(perl_cmd.c_str())) {
        g_errors.error(ErrorCode::CommandFailed, perl_cmd);
        perror("perl");
        return;
    }

    // process generated asm file
    search_source_file(asm_filename);
}

// run cpp preprocessor
void Options::run_cpp(const std::string& filename) {
    std::string cpp_full_path = resolve_include_candidate(filename, "", false);
    if (cpp_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, filename);
        return;
    }

    // file.asm
    std::string asm_filename =
        cpp_full_path.substr(0, cpp_full_path.size() - cpp_extension.size());

    // build cpp command
    std::string cpp_cmd = "cpp " + cpp_options +
                          " \"" + cpp_full_path + "\" > \"" + asm_filename + "\"";
    if (verbose) {
        std::cout << "% " << cpp_cmd << std::endl;
    }

    if (0 != system(cpp_cmd.c_str())) {
        g_errors.error(ErrorCode::CommandFailed, cpp_cmd);
        perror("cpp");
        return;
    }

    // process generated asm file
    search_source_file(asm_filename);
}

// search list files
void Options::search_list_file(const std::string& list_filename) {
    std::string list_full_path = resolve_include_candidate(list_filename, "",
                                 false);
    if (list_full_path.empty()) {
        g_errors.error(ErrorCode::FileNotFound, list_filename);
        return;
    }

    // read list file
    std::string content;
    try {
        content = read_file_to_string(list_full_path);
    }
    catch (std::exception& e) {
        g_errors.error(ErrorCode::FileOpenError, e.what());
        return;
    }

    // process each line
    std::vector<std::string> lines = split_lines(content);
    for (size_t i = 0; i < lines.size(); ++i) {
        g_errors.set_location(Location(list_full_path, static_cast<int>(i + 1)));
        std::string inc_filename = lines[i];

        // remove comments and trim
        size_t comment_pos = inc_filename.find_first_of(";#");
        if (comment_pos != std::string::npos) {
            inc_filename = inc_filename.substr(0, comment_pos);
        }
        inc_filename = trim(inc_filename);

        if (inc_filename.empty()) {
            continue;
        }

        if (inc_filename[0] == ';' || inc_filename[0] == '#') { // comment line
            continue;
        }

        search_source_file(inc_filename);
    }

    g_errors.set_location(Location());
}

// Helper: does the pattern contain any wildcard characters?
static bool has_wildcards(const std::string& pat) {
    return pat.find('*') != std::string::npos || pat.find('?') != std::string::npos;
}

// Helper: split a path string into components, preserving "**" segments
static std::vector<std::string> split_path_components(const std::string& path) {
    std::vector<std::string> comps;
    std::string cur;
    for (char c : path) {
        if (c == '/' || c == '\\') {
            if (!cur.empty()) {
                comps.push_back(cur);
                cur.clear();
            }
        }
        else {
            cur.push_back(c);
        }
    }
    if (!cur.empty()) {
        comps.push_back(cur);
    }
    return comps;
}

// Helper: match a single name with '*' and '?' wildcards (non-recursive, no directory separators)
static bool match_name_glob(const std::string& name, const std::string& pat) {
    size_t n = name.size(), p = pat.size();
    size_t i = 0, j = 0;
    size_t star_i = std::string::npos, star_j = std::string::npos;

    while (i < n) {
        if (j < p && (pat[j] == '?' || pat[j] == name[i])) {
            ++i;
            ++j;
        }
        else if (j < p && pat[j] == '*') {
            star_j = j++;
            star_i = i;
        }
        else if (star_j != std::string::npos) {
            j = star_j + 1;
            i = ++star_i;
        }
        else {
            return false;
        }
    }
    while (j < p && pat[j] == '*') {
        ++j;
    }
    return j == p;
}

// Helper: recursive matcher over path components supporting "**" for subdirectory sequences.
// anchor keeps the textual base path as given by the pattern prefix, so results remain relative
static void glob_walk(const std::filesystem::path& base_fs,
                      const std::filesystem::path& anchor,
                      const std::vector<std::string>& comps,
                      size_t idx,
                      std::vector<std::filesystem::path>& out) {
    namespace fs = std::filesystem;

    if (idx == comps.size()) {
        // terminal: record files only (regular_file) using the anchor to preserve relativeness
        if (fs::exists(base_fs) && fs::is_regular_file(base_fs)) {
            out.push_back(anchor.lexically_normal().generic_string());
        }
        return;
    }

    const std::string& pat = comps[idx];

    if (pat == "**") {
        // "**" consumes zero or more directory levels
        // 1) zero levels: continue matching next component at current base
        glob_walk(base_fs, anchor, comps, idx + 1, out);

        // 2) recurse into all subdirectories
        if (fs::exists(base_fs) && fs::is_directory(base_fs)) {
            std::error_code ec;
            for (fs::recursive_directory_iterator it(base_fs, ec), end; it != end; ++it) {
                if (ec) {
                    break;
                }
                if (it->is_directory()) {
                    // compute relative subdir path to append to anchor
                    std::error_code ec2;
                    fs::path rel = fs::relative(it->path(), base_fs, ec2);
                    if (ec2) {
                        rel = it->path().filename();
                    }
                    glob_walk(it->path(), anchor / rel, comps, idx + 1, out);
                }
            }
        }
        return;
    }

    // normal component (with '*'/'?' wildcards) matched against entries in current directory
    if (!fs::exists(base_fs) || !fs::is_directory(base_fs)) {
        // Not a directory: nothing to do here (wildcard cannot match)
        return;
    }

    std::error_code ec;
    for (fs::directory_iterator it(base_fs, ec), end; it != end; ++it) {
        if (ec) {
            break;
        }
        const std::string name = it->path().filename().string();
        if (!match_name_glob(name, pat)) {
            continue;
        }

        if (idx == comps.size() - 1) {
            // last component: collect files only, keep relative anchor + filename
            if (it->is_regular_file()) {
                out.push_back((anchor /
                               it->path().filename()).lexically_normal().generic_string());
            }
        }
        else {
            // continue with next component; advance both filesystem and textual anchors
            glob_walk(it->path(), anchor / it->path().filename(), comps, idx + 1, out);
        }
    }
}

// Expand wildcards using std::filesystem only: supports '*', '?', and '**'
static std::vector<std::string> expand_wildcards(const std::string& pattern) {
    namespace fs = std::filesystem;

    std::vector<std::string> results;

    // If no wildcards, return as-is (normalized)
    if (!has_wildcards(pattern)) {
        results.push_back(normalize_path(pattern));
        return results;
    }

    // Split pattern into components preserving "**"
    std::vector<std::string> comps = split_path_components(pattern);

    // Build non-wildcard prefix as base (textual) until first wildcard segment
    fs::path base_prefix;
    size_t wildcard_idx = 0;
    for (; wildcard_idx < comps.size(); ++wildcard_idx) {
        const std::string& seg = comps[wildcard_idx];
        const bool seg_has_wildcard = (seg == "**") ||
                                      seg.find('*') != std::string::npos ||
                                      seg.find('?') != std::string::npos;
        if (seg_has_wildcard) {
            break;
        }

        if (base_prefix.empty()) {
            base_prefix = fs::path(seg);
        }
        else {
            base_prefix /= seg;
        }
    }

    // Filesystem base for walking; if no prefix, use "." (current directory) but keep anchor empty
    fs::path base_fs = base_prefix.empty() ? fs::path(".") : base_prefix;
    fs::path anchor  =
        base_prefix; // textual anchor as given by the pattern prefix (may be relative)

    // Remaining components to match from the first wildcard segment
    std::vector<std::string> rest(comps.begin() + wildcard_idx, comps.end());

    // Walk and collect; ensure we keep relative paths based on the pattern prefix (anchor)
    std::vector<fs::path> paths;
    glob_walk(base_fs, anchor, rest, 0, paths);

    for (const auto& ph : paths) {
        try {
            results.push_back(ph.lexically_normal().generic_string());
        }
        catch (...) {
            results.push_back(ph.generic_string());
        }
    }

    return results;
}

// search source file in path, return empty string if not found
void Options::search_source_file(const std::string& filename_) {
    std::string filename = trim(filename_);
    filename = expand_env_vars(filename);
    std::string out_filename;

    // Expand wildcards first: process each matched file independently
    if (has_wildcards(filename)) {
        std::vector<std::string> matches;

        // 1) Expand relative/absolute pattern as provided (CWD or explicit base)
        {
            std::vector<std::string> m = expand_wildcards(filename);
            matches.insert(matches.end(), m.begin(), m.end());
        }

        // 2) Also expand from each include path when the pattern is not absolute.
        // This enables: z88dk-z80asm -Ipath "*.asm"
        std::filesystem::path pat_path(filename);
        if (!pat_path.is_absolute()) {
            for (const auto& inc : include_paths) {
                std::string combined = (std::filesystem::path(inc) / filename).generic_string();
                std::vector<std::string> m = expand_wildcards(combined);
                matches.insert(matches.end(), m.begin(), m.end());
            }
        }

        // Deduplicate while preserving order
        std::set<std::string> seen;
        std::vector<std::string> unique_matches;
        unique_matches.reserve(matches.size());
        for (const auto& m : matches) {
            if (seen.insert(m).second) {
                unique_matches.push_back(m);
            }
        }

        if (unique_matches.empty()) {
            // no matches -> report not found unless an error already exists
            if (!g_errors.has_errors()) {
                g_errors.error(ErrorCode::FileNotFound, filename);
            }
            return;
        }

        for (const auto& m : unique_matches) {
            search_source_file(m);
        }
        return;
    }

    // check list files
    if (!filename.empty() && filename[0] == '@') {
        search_list_file(filename.substr(1));
        return;
    }

    // check m4 preprocessing
    if (str_ends_with(filename, m4_extension)) {
        run_m4(filename);
        return;
    }

    // check perl preprocessing
    if (str_ends_with(filename, perl_extension)) {
        run_perl(filename);
        return;
    }

    // check cpp preprocessing
    if (str_ends_with(filename, cpp_extension)) {
        run_cpp(filename);
        return;
    }

    // check plain filename
    out_filename = check_source(filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check plain file in include path (and CWD)
    out_filename = resolve_include_candidate(filename, "", false);
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
    out_filename = resolve_include_candidate(asm_filename, "", false);
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
    out_filename = resolve_include_candidate(o_filename, "", false);
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
    out_filename = resolve_include_candidate(asm_filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            input_files.push_back(out_filename);
            return;
        }
    }

    // check object file in output_dir
    o_filename = get_o_filename(filename);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        input_files.push_back(out_filename);
        return;
    }

    // check obejct file in output_dir in include path
    out_filename = resolve_include_candidate(o_filename, "", false);
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
