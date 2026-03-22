//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_expr.h"
#include "errors.h"
#include "options.h"
#include "source.h"
#include "source_loc.h"
#include "utils.h"
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <initializer_list>
#include <iomanip>
#include <ios>
#include <iostream>
#include <set>
#include <string>
#include <vector>

Options g_options;
std::vector<std::string> g_input_files;   // command line input files

static constexpr std::string_view copyright =
    "Usage: z88dk-z80asm [options] files...\n"
    "Copyright (C) Paulo Custodio, 2011-2026\n";

static constexpr std::string_view asm_extension = ".asm";
static constexpr std::string_view o_extension = ".o";
static constexpr std::string_view m4_extension = ".m4";
static constexpr std::string_view perl_extension = ".pl";
static constexpr std::string_view cpp_extension = ".cpp";

// option types
enum class OptionType : uint8_t {
#define X(name, str, arg, usage) name,
#include "options.def"
};

// option specification
struct OptionSpec {
    const char* name;
    OptionType  type;
    bool        takes_arg;
    const char* usage;
};

static const OptionSpec g_option_specs[] = {
#define X(name, str, arg, usage) { str, OptionType::name, arg, usage },
#include "options.def"
};

// options usage gropuing for presentation in usage screen
struct UsageGroup {
    const char* title;
    std::initializer_list<OptionType> options;
};

static const UsageGroup usage_layout[] = {
    {
        "Help Options",
        { OptionType::HELP, OptionType::VERBOSE }
    },
    {
        "File and Directory Options",
        { OptionType::INCLUDE, OptionType::OUTPUT }
    },
    {
        "External Preprocessor Options",
        { OptionType::CPP, OptionType::M4, OptionType::PERL }
    },
    {
        "Preprocessor Options",
        {
            OptionType::IXIY, OptionType::DEFINE, OptionType::UCASE,
            OptionType::PREPROC
        }
    },
    {
        "Assembly Options",
        { OptionType::DATESTAMP }
    },
};

[[noreturn]]
void exit_show_copyright(int exit_code) {
    std::cout << copyright;
    exit(exit_code);
}

static void show_option_usage(const OptionSpec& spec) {
    static const int option_col_width = 10;

    std::cout << "  " << std::left << std::setw(option_col_width) << std::setfill(' ')
              << (std::string(spec.name) + (spec.takes_arg ? "=ARG" : ""))
              << spec.usage << "\n";
}

[[noreturn]]
void exit_show_usage(int exit_code) {
    // check that usage_layout covers all options
    std::set<OptionType> covered_options;
    for (auto& group : usage_layout) {
        for (auto& option_type : group.options) {
            covered_options.insert(option_type);
        }
    }
    for (size_t i = 0; i < sizeof(g_option_specs) / sizeof (OptionSpec); ++i) {
        OptionType option_type = g_option_specs[i].type;
        if (covered_options.find(option_type) == covered_options.end()) {
            std::cerr << "Error: option " << g_option_specs[i].name
                      << " is not covered in usage layout\n";
            std::exit(EXIT_FAILURE);
        }
    }

    // output usage
    std::cout
            << copyright << "\n"
            << "Assembles Z80 assembly source files into binary output.\n";

    for (auto& group : usage_layout) {
        std::cout << "\n" << group.title << ":\n";
        for (auto& option_type : group.options) {
            const OptionSpec& spec = g_option_specs[static_cast<size_t>(option_type)];
            show_option_usage(spec);
        }
    }
    exit(exit_code);
}

[[noreturn]]
void exit_invalid_option(const std::string_view option) {
    error("Invalid option: " + std::string(option));
    exit(EXIT_FAILURE);
}

static void append_with_space(std::string& dst, std::string_view src) {
    if (!dst.empty()) {
        dst.push_back(' ');
    }
    dst.append(src);
}

static bool parse_define(std::string_view arg, std::string_view opt_name) {
    SourceLoc loc("<command-line>", 1, 1);

    // Strip the "-D" prefix
    if (!starts_with(arg, opt_name)) {
        return false;
    }

    std::string_view rest = arg.substr(opt_name.size());

    // Optional '=' after -D
    if (starts_with(rest, "=")) {
        rest.remove_prefix(1);
    }

    // Split NAME and EXPR
    std::string_view name, expr;
    size_t eq = rest.find('=');

    if (eq == std::string_view::npos) {
        // -DNAME  -> NAME=1
        name = rest;
        expr = "1";
    }
    else {
        name = rest.substr(0, eq);
        expr = rest.substr(eq + 1);
        if (expr.empty()) {
            error(loc, "Expression missing in option: " + std::string(arg));
            return false;
        }
    }

    // Convert to std::string for your symbol table
    std::string name_s(name);
    std::string expr_s(expr);

    // evaluate the expression as a constant expression
    int value = 1;
    if (!eval_const_expr(expr_s, loc, g_options.global_defs, value)) {
        return false;   // error already reported by eval_const_expr
    }

    // Hand off to your assembler’s define mechanism
    g_options.global_defs.set(name_s, value, loc);

    return true;
}

// match longest option prefix in arg, return nullptr if no match
const OptionSpec* match_option(std::string_view arg) {
    const OptionSpec* best = nullptr;
    size_t best_len = 0;

    for (const auto& spec : g_option_specs) {
        std::string_view name = spec.name;
        if (starts_with(arg, name)) {
            if (name.size() > best_len) {
                best = &spec;
                best_len = name.size();
            }
        }
    }

    return best; // nullptr if no match
}

static bool split_option_arg(std::string_view arg,
                             std::string_view opt_name,
                             std::string& out) {
    // Must start with the option prefix
    if (arg.size() < opt_name.size()) {
        return false;
    }

    if (!starts_with(arg, opt_name)) {
        return false;
    }

    // Slice off the prefix
    std::string_view rest = arg.substr(opt_name.size());

    // Optional '=' after the option name
    if (!rest.empty() && rest.front() == '=') {
        rest.remove_prefix(1);
    }

    // No argument provided
    if (rest.empty()) {
        return false;
    }

    // Convert to std::string for storage
    out.assign(rest.begin(), rest.end());
    return true;
}

bool parse_arg(const std::string_view arg, bool& found_dash_dash) {
    if (arg.empty()) {
        return true;
    }

    // ------------------------------------------------------------
    // 1. Handle options (unless we've seen "--")
    // ------------------------------------------------------------
    if (!found_dash_dash && (arg[0] == '-' || arg[0] == '+')) {
        // Special cases first
        if (arg == "-?") {
            exit_show_usage(EXIT_SUCCESS);
        }

        if (arg == "--") {
            found_dash_dash = true;
            return true;
        }

        if (arg == "--help") {
            exit_show_usage(EXIT_SUCCESS);
        }

        // --------------------------------------------------------
        // 2. Match against the option table (longest-first)
        // --------------------------------------------------------
        const OptionSpec* spec = match_option(arg);
        if (!spec) {
            return false;
        }

        std::string opt_arg;

        // --------------------------------------------------------
        // 3. Dispatch based on OptionType
        // --------------------------------------------------------
        switch (spec->type) {
        case OptionType::CPP:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                return false;
            }
            append_with_space(g_options.cpp_options, opt_arg);
            return true;

        case OptionType::DATESTAMP:
            g_options.date_stamp = true;
            return true;

        case OptionType::DEFINE:
            return parse_define(arg, spec->name);

        case OptionType::HELP:
            exit_show_usage(EXIT_SUCCESS);

        case OptionType::INCLUDE:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                return false;
            }
            g_options.include_paths.push_back(opt_arg);
            return true;

        case OptionType::IXIY:
            g_options.swap_ix_iy = true;
            return true;

        case OptionType::M4:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                return false;
            }
            append_with_space(g_options.m4_options, opt_arg);
            return true;

        case OptionType::OUTPUT:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                return false;
            }
            g_options.output_dir = opt_arg;
            return true;

        case OptionType::PERL:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                return false;
            }
            append_with_space(g_options.perl_options, opt_arg);
            return true;

        case OptionType::PREPROC:
            g_options.preprocess_only = true;
            return true;

        case OptionType::UCASE:
            g_options.ucase_labels = true;
            return true;

        case OptionType::VERBOSE:
            g_options.verbose = true;
            return true;

        default:
            assert(0);
            return false;
        }
    }

    // ------------------------------------------------------------
    // 4. Not an option -> treat as input file
    // ------------------------------------------------------------
    search_source_file(arg, SourceLoc());
    return true;
}



bool is_asm_filename(const std::string_view filename) {
    return ends_with(filename, asm_extension);
}

bool is_o_filename(const std::string_view filename) {
    return ends_with(filename, o_extension);
}

std::string get_asm_filename(const std::string_view filename) {
    return replace_extension(filename, asm_extension);
}

std::string get_o_filename(const std::string_view filename) {
    return prepend_output_dir(replace_extension(filename, o_extension), g_options.output_dir);
}

// Try candidates according to include semantics and include_paths,
// return resolved path if found or empty string if not found.
// including_filename: the file which contains the include directive (can be empty if unknown)
std::string resolve_include_candidate(const std::string_view filename,
                                      const std::string_view including_filename, bool is_angle) {
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
            for (const auto& p : g_options.include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            // Finally as-given (relative to current working dir of the process)
            candidates.push_back(fname);
        }
        else {
            // Angle includes: search include paths, then as-given
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
                    return normalize_path(norm.lexically_normal().generic_string());
                }
                catch (...) {
                    return normalize_path(norm.generic_string());
                }
            }
        }
        catch (...) {
            // ignore path errors and move on
        }
    }

    return std::string();
}

static std::string check_source(const std::string_view filename) {
    namespace fs = std::filesystem;

    // avoid cascade of errors
    if (error_count()) {
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
        else if (fs::last_write_time(obj_file) >= fs::last_write_time(src_file)) {
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

// run tool preprocessor
static void run_tool(const std::string_view filename,
                     const std::string_view extension,
                     const std::string_view tool_name_,
                     const std::string_view tool_options,
                     const SourceLoc& loc) {
    std::string tool_name(tool_name_);

    std::string full_path = resolve_include_candidate(filename, "", false);
    if (full_path.empty()) {
        error(loc, "File not found: " + std::string(filename));
        return;
    }

    // file.asm
    std::string asm_filename = full_path.substr(0, full_path.size() - extension.size());

    // build tool command
    std::string cmd = tool_name;
    if (!tool_options.empty()) {
        cmd += " " + std::string(tool_options);
    }
    cmd += " \"" + full_path + "\" > \"" + asm_filename + "\"";

    if (g_options.verbose) {
        std::cout << "% " << cmd << std::endl;
    }

    if (0 != system(cmd.c_str())) {
        error(loc, "Command failed: " + cmd);
        perror(tool_name.c_str());
        return;
    }

    // process generated asm file
    search_source_file(asm_filename, loc);
}

// run m4 preprocessor
static void run_m4(const std::string_view filename, const SourceLoc& loc) {
    run_tool(filename, m4_extension, "m4", g_options.m4_options, loc);
}

// run perl preprocessor
static void run_perl(const std::string_view filename, const SourceLoc& loc) {
    run_tool(filename, perl_extension, "perl", g_options.perl_options, loc);
}

// run cpp preprocessor
static void run_cpp(const std::string_view filename, const SourceLoc& loc) {
    run_tool(filename, cpp_extension, "cpp", g_options.cpp_options, loc);
}

// search list files
static void search_list_file(const std::string_view list_filename, const SourceLoc& loc) {
    std::string list_full_path = resolve_include_candidate(list_filename, "", false);
    if (list_full_path.empty()) {
        error(loc, "File not found: " + std::string(list_filename));
        return;
    }

    // read list file
    uint32_t file_id = register_virtual_file(list_full_path);
    std::string content;
    if (!read_file_to_string(list_full_path, loc, content)) {
        return;
    }

    // process each line
    std::vector<RawLine> lines = split_into_lines(content, file_id, 1);
    for (auto& line : lines) {
        std::string inc_filename = line.text;

        // remove comments and trim
        uint32_t comment_pos = static_cast<uint32_t>(inc_filename.find_first_of(";#"));
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

        search_source_file(inc_filename, line.loc);
    }
}

// Helper: does the pattern contain any wildcard characters?
static bool has_wildcards(const std::string_view pat) {
    return pat.find('*') != std::string::npos || pat.find('?') != std::string::npos;
}

// Helper: split a path string into components, preserving "**" segments
static std::vector<std::string> split_path_components(const std::string_view path) {
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
static bool match_name_glob(const std::string_view name, const std::string_view pat) {
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
                      uint32_t idx,
                      std::vector<std::filesystem::path>& out) {
    namespace fs = std::filesystem;

    if (idx == comps.size()) {
        // terminal: record files only (regular_file) using the anchor to preserve relativeness
        if (fs::exists(base_fs) && fs::is_regular_file(base_fs)) {
            out.push_back(anchor.lexically_normal().generic_string());
        }
        return;
    }

    const std::string_view pat = comps[idx];

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
static std::vector<std::string> expand_wildcards(const std::string_view pattern) {
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
    uint32_t wildcard_idx = 0;
    for (; wildcard_idx < comps.size(); ++wildcard_idx) {
        const std::string_view seg = comps[wildcard_idx];
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
void search_source_file(const std::string_view filename_, const SourceLoc& loc) {
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
            for (const auto& inc : g_options.include_paths) {
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
            if (!error_count()) {
                error(loc, "File not found: " + filename);
            }
            return;
        }

        for (const auto& m : unique_matches) {
            search_source_file(m, loc);
        }
        return;
    }

    // check list files
    if (!filename.empty() && filename[0] == '@') {
        search_list_file(filename.substr(1), loc);
        return;
    }

    // check m4 preprocessing
    if (ends_with(filename, m4_extension)) {
        run_m4(filename, loc);
        return;
    }

    // check perl preprocessing
    if (ends_with(filename, perl_extension)) {
        run_perl(filename, loc);
        return;
    }

    // check cpp preprocessing
    if (ends_with(filename, cpp_extension)) {
        run_cpp(filename, loc);
        return;
    }

    // check plain filename
    out_filename = check_source(filename);
    if (!out_filename.empty()) {
        g_input_files.push_back(out_filename);
        return;
    }

    // check plain file in include path (and CWD)
    out_filename = resolve_include_candidate(filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .asm extension
    std::string asm_filename = filename + std::string(asm_extension);
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        g_input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = resolve_include_candidate(asm_filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .o extension
    std::string o_filename = filename + std::string(o_extension);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        g_input_files.push_back(out_filename);
        return;
    }

    // check filename with .o extension in include path
    out_filename = resolve_include_candidate(o_filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_input_files.push_back(out_filename);
            return;
        }
    }

    // check source file
    asm_filename = get_asm_filename(filename);
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        g_input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = resolve_include_candidate(asm_filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_input_files.push_back(out_filename);
            return;
        }
    }

    // check object file in output_dir
    o_filename = get_o_filename(filename);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        g_input_files.push_back(out_filename);
        return;
    }

    // check obejct file in output_dir in include path
    out_filename = resolve_include_candidate(o_filename, "", false);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_input_files.push_back(out_filename);
            return;
        }
    }

    // not found, avoid cascade of errors
    if (!error_count()) {
        error(loc, "File not found: " + filename);
    }
}
