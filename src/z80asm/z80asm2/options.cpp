//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "environment.h"
#include "file_mgr.h"
#include "options.h"
#include "pathnames.h"
#include "string_utils.h"
#include <algorithm>
#include <cassert>
#include <filesystem>
#include <iomanip>
#include <iostream>
#include <set>
#include <string>
#include <vector>

Args g_args;

static const int option_col_width = 16 - 2;

static constexpr std::string_view copyright =
    "Usage: z88dk-z80asm [options] files...\n"
    "Copyright (C) Paulo Custodio, 2011-2026\n";

// option types
enum class OptionType {
#define X(name, str, takes_arg, arg_text, usage) name,
#include "options.def"
};

// option specification
struct OptionSpec {
    const char* name;
    OptionType  type;
    bool        takes_arg;
    const char* arg_text;
    const char* usage;
};

static const OptionSpec g_option_specs[] = {
#define X(name, str, takes_arg, arg_text, usage) \
        { str, OptionType::name, takes_arg, arg_text, usage },
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
            OptionType::DEFINE, OptionType::PREPROC
        }
    },
    {
        "Assembly Options",
        { OptionType::IXIY, OptionType::UCASE, OptionType::DATESTAMP }
    },
    {
        "Diagnostic Options",
        {
            OptionType::DUMP_AFTER_CMDLINE,
            OptionType::DUMP_AFTER_TOKENIZATION,
            OptionType::DUMP_AFTER_DIRECTIVES,
            OptionType::DUMP_AFTER_MACRO_EXPANSION,
            OptionType::DUMP_AFTER_PREPROCESSING,
        }
    }
};

[[noreturn]]
void exit_show_copyright(int exit_code) {
    std::cout << copyright;
    exit(exit_code);
}

static void show_option_usage(const OptionSpec& spec) {
    std::string option_text = std::string(spec.name) +
                              (spec.takes_arg ? spec.arg_text : "");

    if (option_text.size() > option_col_width) {
        std::cout << "  " << option_text << "\n";
        option_text = "";
    }

    std::cout << "  "
              << std::left << std::setw(option_col_width)
              << std::setfill(' ') << option_text
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
            const OptionSpec& spec =
                g_option_specs[static_cast<size_t>(option_type)];
            show_option_usage(spec);
        }
    }
    exit(exit_code);
}

static void append_with_space(std::string& dst, std::string_view src) {
    if (!dst.empty()) {
        dst.push_back(' ');
    }
    dst.append(src);
}

static void parse_define(std::string_view arg, std::string_view opt_name,
                         SourceLoc loc) {
    // Strip the "-D" prefix
    if (!starts_with(arg, opt_name)) {
        return;
    }

    std::string_view rest = arg.substr(opt_name.size());
    loc.column += static_cast<uint16_t>(opt_name.size());

    // Optional '=' after -D
    if (starts_with(rest, "=")) {
        rest.remove_prefix(1);
        loc.column += 1;
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
        loc.column += static_cast<uint16_t>(name.size());
        expr = rest.substr(eq + 1);
        loc.column += 1; // for the '=' character
        if (expr.empty()) {
            g_diag.error(loc, "Expression missing in option: " + std::string(arg));
            return;
        }
    }

    // Convert to std::string for your symbol table
    std::string name_s(name);
    std::string expr_s(expr);

    // evaluate the expression as a constant expression
    int value = 1;
    if (!eval_const_expr(expr_s, loc, g_args.options.global_defs,
                         value, /*silent=*/false)) {
        return;   // error already reported by eval_const_expr
    }

    // Hand off to your assembler's define mechanism
    g_args.options.global_defs.set(name_s, value, loc);
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

void parse_arg(std::string_view arg,
               bool& found_dash_dash, const SourceLoc& loc) {
    if (arg.empty()) {
        return;
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
            return;
        }

        if (arg == "--help") {
            exit_show_usage(EXIT_SUCCESS);
        }

        // --------------------------------------------------------
        // 2. Match against the option table (longest-first)
        // --------------------------------------------------------
        const OptionSpec* spec = match_option(arg);
        if (!spec) {
            g_diag.error(loc, "Invalid option: " + std::string(arg));
            return;
        }

        std::string opt_arg;

        // --------------------------------------------------------
        // 3. Dispatch based on OptionType
        // --------------------------------------------------------
        switch (spec->type) {
        case OptionType::HELP:
            exit_show_usage(EXIT_SUCCESS);

        case OptionType::VERBOSE:
            g_args.options.verbose = true;
            return;

        case OptionType::INCLUDE:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                g_diag.error(loc, "Invalid option: " + std::string(arg));
                return;
            }
            g_args.options.include_paths.push_back(normalize_path(opt_arg));
            return;

        case OptionType::OUTPUT:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                g_diag.error(loc, "Invalid option: " + std::string(arg));
                return;
            }
            g_args.options.output_dir = opt_arg;
            return;

        case OptionType::CPP:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                g_diag.error(loc, "Invalid option: " + std::string(arg));
                return;
            }
            append_with_space(g_args.options.cpp_options, opt_arg);
            return;

        case OptionType::M4:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                g_diag.error(loc, "Invalid option: " + std::string(arg));
                return;
            }
            append_with_space(g_args.options.m4_options, opt_arg);
            return;

        case OptionType::PERL:
            if (!split_option_arg(arg, spec->name, opt_arg)) {
                g_diag.error(loc, "Invalid option: " + std::string(arg));
                return;
            }
            append_with_space(g_args.options.perl_options, opt_arg);
            return;

        case OptionType::DEFINE:
            parse_define(arg, spec->name, loc);
            return;

        case OptionType::PREPROC:
            g_args.options.preprocess_only = true;
            return;

        case OptionType::IXIY:
            g_args.options.swap_ix_iy = true;
            return;

        case OptionType::UCASE:
            g_args.options.ucase_labels = true;
            return;

        case OptionType::DATESTAMP:
            g_args.options.date_stamp = true;
            return;

        case OptionType::DUMP_AFTER_CMDLINE:
            g_args.options.dump_after_cmdline = true;
            return;

        case OptionType::DUMP_AFTER_TOKENIZATION:
            g_args.options.dump_after_tokenization = true;
            return;

        case OptionType::DUMP_AFTER_DIRECTIVES:
            g_args.options.dump_after_directives = true;
            return;

        case OptionType::DUMP_AFTER_MACRO_EXPANSION:
            g_args.options.dump_after_macro_expansion = true;
            return;

        case OptionType::DUMP_AFTER_PREPROCESSING:
            g_args.options.dump_after_preprocessing = true;
            return;

        default:
            assert(0);
        }
    }

    // ------------------------------------------------------------
    // 4. Not an option -> treat as input file
    // ------------------------------------------------------------
    std::vector<SourceLoc> empty_stack;
    search_source_file(arg, "", loc, empty_stack);
}

static std::string check_source(std::string_view filename) {
    namespace fs = std::filesystem;

    // avoid cascade of errors
    if (g_diag.error_count()) {
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
        if (!g_args.options.date_stamp) {
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
static void run_tool(std::string_view filename,
                     std::string_view extension,
                     std::string_view including_filename,
                     std::string_view tool_name_,
                     std::string_view tool_options,
                     const SourceLoc& loc,
                     std::vector<SourceLoc>& loc_stack) {
    std::string tool_name(tool_name_);
    std::string full_path =
        resolve_include_candidate(filename,
                                  including_filename,
                                  false,
                                  g_args.options.include_paths);
    if (full_path.empty()) {
        g_diag.error(loc, "File not found: " + std::string(filename));
        return;
    }

    // file.asm
    std::string asm_filename =
        full_path.substr(0, full_path.size() - extension.size());

    // build tool command
    std::string cmd = tool_name;
    if (!tool_options.empty()) {
        cmd += " " + std::string(tool_options);
    }
    cmd += " \"" + full_path + "\" > \"" + asm_filename + "\"";

    if (g_args.options.verbose) {
        std::cout << "% " << cmd << std::endl;
    }

    if (0 != system(cmd.c_str())) {
        g_diag.error(loc, "Command failed: " + cmd);
        return;
    }

    // process generated asm file
    search_source_file(asm_filename, including_filename, loc, loc_stack);
}

// run m4 preprocessor
static void run_m4(std::string_view filename,
                   std::string_view including_filename,
                   const SourceLoc& loc,
                   std::vector<SourceLoc>& loc_stack) {
    run_tool(filename, m4_extension,
             including_filename,
             "m4", g_args.options.m4_options,
             loc, loc_stack);
}

// run perl preprocessor
static void run_perl(std::string_view filename,
                     std::string_view including_filename,
                     const SourceLoc& loc,
                     std::vector<SourceLoc>& loc_stack) {
    run_tool(filename, perl_extension,
             including_filename,
             "perl", g_args.options.perl_options,
             loc, loc_stack);
}

// run cpp preprocessor
static void run_cpp(std::string_view filename,
                    std::string_view including_filename,
                    const SourceLoc& loc,
                    std::vector<SourceLoc>& loc_stack) {
    run_tool(filename, cpp_extension,
             including_filename,
             "cpp", g_args.options.cpp_options,
             loc, loc_stack);
}

// parse list file line, return filename or empty string, and SourceLoc
static bool parse_filename_entry(std::string_view line_,
                                 SourceLoc& in_out_loc,
                                 std::string& out_filename) {
    out_filename.clear();

    std::string line(line_);
    const char* p = line.c_str();

    // skip leading whitespace
    while (*p && is_space(*p)) {
        ++p;
    }

    if (*p == '\0' || *p == ';' || *p == '#') {
        return true; // empty line or comment
    }

    // maybe an '@' sign
    bool has_at = false;
    if (*p == '@') {
        has_at = true;
        in_out_loc.column = static_cast<uint16_t>(p - line.c_str() + 1);
        ++p;
        while (*p && is_space(*p)) {
            ++p;
        }
    }

    if (has_at && (*p == '\0' || *p == ';' || *p == '#')) {
        SourceLoc here_loc = in_out_loc;
        here_loc.column = static_cast<uint16_t>(p - line.c_str() + 1);
        g_diag.error(here_loc, "Expected filename after '@'");
        return false;
    }

    in_out_loc.column = static_cast<uint16_t>(p - line.c_str() + 1);
    const char* start = p;
    while (*p && !is_space(*p)) {
        ++p;
    }

    std::string inc_filename =
        (has_at ? "@" : "") + std::string(start, p - start);

    // check for end of line or comment
    while(*p && is_space(*p)) {
        ++p;
    }

    if (*p != '\0' && *p != ';' && *p != '#') {
        SourceLoc here_loc = in_out_loc;
        here_loc.column = static_cast<uint16_t>(p - line.c_str() + 1);
        g_diag.error(here_loc, "Unexpected text after filename: " + std::string(p));
        return false;
    }

    out_filename = inc_filename;
    return true;
}

// search list files
static void search_list_file(std::string_view list_filename,
                             const SourceLoc& loc,
                             std::vector<SourceLoc>& loc_stack) {
    // read list file
    StringInterner::Id file_id =
        g_file_mgr.register_virtual_file(list_filename);
    std::string content;
    if (!g_file_mgr.read_file_to_string(list_filename, loc, content)) {
        return;
    }

    // process each line
    std::vector<RawLine> lines =
        g_file_mgr.split_into_lines(content, file_id, 1);
    for (auto& line : lines) {
        // column will be updated by parse_filename_entry
        SourceLoc inc_loc = line.loc;
        std::string inc_filename;
        if (!parse_filename_entry(line.text, inc_loc, inc_filename)) {
            continue; // error already reported
        }

        if (inc_filename.empty()) {
            continue; // empty line or comment
        }

        search_source_file(inc_filename, list_filename, inc_loc, loc_stack);
    }
}

// search source file in path, return empty string if not found
void search_source_file(std::string_view filename_,
                        std::string_view including_filename,
                        const SourceLoc& loc,
                        std::vector<SourceLoc>& loc_stack) {
    std::string filename = trim(filename_);
    filename = expand_env_vars(filename);
    std::string out_filename;

    // check for command line options first
    if (!filename.empty() && filename[0] == '-') {
        bool found_dash_dash = false;
        parse_arg(filename, found_dash_dash, loc);
        return;
    }

    // Expand wildcards: process each matched file independently
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
            for (const auto& inc : g_args.options.include_paths) {
                std::string combined = (std::filesystem::path(inc) / filename).generic_string();
                std::vector<std::string> m = expand_wildcards(combined);
                matches.insert(matches.end(), m.begin(), m.end());
            }
        }

        // Deduplicate and sort to make test results predictable
        std::set<std::string> seen;
        std::vector<std::string> unique_matches;
        unique_matches.reserve(matches.size());
        for (const auto& m : matches) {
            if (seen.insert(m).second) {
                unique_matches.push_back(m);
            }
        }
        std::sort(unique_matches.begin(), unique_matches.end());

        if (unique_matches.empty()) {
            // no matches -> report not found unless an error already exists
            if (!g_diag.error_count()) {
                g_diag.error(loc, "File not found: " + filename);
            }
            return;
        }

        for (const auto& m : unique_matches) {
            search_source_file(m, including_filename, loc, loc_stack);
        }
        return;
    }

    // check list files
    if (!filename.empty() && filename[0] == '@') {
        std::string list_filename = trim(filename.substr(1));
        std::string list_full_path =
            resolve_include_candidate(list_filename,
                                      including_filename,
                                      false,
                                      g_args.options.include_paths);
        if (list_full_path.empty()) {
            g_diag.error(loc, "File not found: " + list_filename);
            return;
        }
        StringInterner::Id file_id =
            g_file_mgr.register_virtual_file(list_full_path);

        // check for recursive inclusion of list files
        for (const SourceLoc& l : loc_stack) {
            if (l.file_id == file_id) {
                g_diag.error(loc, "Recursive inclusion of list file: " + list_filename);
                return;
            }
        }

        loc_stack.push_back(loc);
        search_list_file(list_full_path, loc, loc_stack);
        loc_stack.pop_back();
        return;
    }

    // check m4 preprocessing
    if (ends_with(filename, m4_extension)) {
        run_m4(filename, including_filename, loc, loc_stack);
        return;
    }

    // check perl preprocessing
    if (ends_with(filename, perl_extension)) {
        run_perl(filename, including_filename, loc, loc_stack);
        return;
    }

    // check cpp preprocessing
    if (ends_with(filename, cpp_extension)) {
        run_cpp(filename, including_filename, loc, loc_stack);
        return;
    }

    // check plain filename
    out_filename = check_source(filename);
    if (!out_filename.empty()) {
        g_args.input_files.push_back(out_filename);
        return;
    }

    // check plain file in include path (and CWD)
    out_filename = resolve_include_candidate(filename,
                   including_filename,
                   false,
                   g_args.options.include_paths);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_args.input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .asm extension
    std::string asm_filename = filename + std::string(asm_extension);
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        g_args.input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = resolve_include_candidate(asm_filename,
                   including_filename,
                   false,
                   g_args.options.include_paths);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_args.input_files.push_back(out_filename);
            return;
        }
    }

    // check filename with .o extension
    std::string o_filename = filename + std::string(o_extension);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        g_args.input_files.push_back(out_filename);
        return;
    }

    // check filename with .o extension in include path
    out_filename = resolve_include_candidate(o_filename,
                   including_filename,
                   false,
                   g_args.options.include_paths);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_args.input_files.push_back(out_filename);
            return;
        }
    }

    // check source file
    asm_filename = get_asm_filename(filename);
    out_filename = check_source(asm_filename);
    if (!out_filename.empty()) {
        g_args.input_files.push_back(out_filename);
        return;
    }

    // check filename with .asm extension in include path
    out_filename = resolve_include_candidate(asm_filename,
                   including_filename,
                   false,
                   g_args.options.include_paths);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_args.input_files.push_back(out_filename);
            return;
        }
    }

    // check object file in output_dir
    o_filename = get_o_filename(filename, g_args.options.output_dir);
    out_filename = check_source(o_filename);
    if (!out_filename.empty()) {
        g_args.input_files.push_back(out_filename);
        return;
    }

    // check obejct file in output_dir in include path
    out_filename = resolve_include_candidate(o_filename,
                   including_filename,
                   false,
                   g_args.options.include_paths);
    if (!out_filename.empty()) {
        out_filename = check_source(out_filename);
        if (!out_filename.empty()) {
            g_args.input_files.push_back(out_filename);
            return;
        }
    }

    // not found, avoid cascade of errors
    if (!g_diag.error_count()) {
        g_diag.error(loc, "File not found: " + filename);
    }
}
