//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../../config.h"       // Z88DK_VERSION
#include "common.h"
#include "files.h"
#include "options.h"
#include "utils.h"
#include "xassert.h"
#include <climits>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

#define COPYRIGHT		"InterLogic 1993-2009, Paulo Custodio 2011-2024"
#define COPYRIGHT_MSG	"Z80 Macro Assembler " Z88DK_VERSION "\n(c) " COPYRIGHT


void Options::parse_args(const vector<string>& args) {
    if (args.empty())
        exit_copyright();

    // set verbose, if defined in env var
    parse_env_vars();

    // check for -v to activate verbosity before other options are parsed
    for (auto& arg : args) {
        if (unquote(expand_env_vars(arg)) == "-v")
            verbose_ = true;
    }

    // show command line
    if (verbose_) {
        cout << "% " << Z80ASM_PROG;
        for (auto& arg : args) {
            cout << " " << arg;
        }
        cout << endl;
    }

    if (g_asm.error_count())
        return;

    bool got_dash_dash = false;
    for (auto& arg : args) {
        string arg1 = unquote(expand_env_vars(arg));
        if (arg1.empty())
            continue;
        else if (arg1 == "--")
            got_dash_dash = true;
        else if (!got_dash_dash && (arg1[0] == '-' || arg1[0] == '+'))
            parse_option(arg1);
        else
            parse_file(arg1);

        if (g_asm.error_count())
            return;
    }

    post_parsing_actions();
}

void Options::parse_option(const string& arg) {
    string opt_arg;

    if (arg == "-vv") {
        debug_z80asm_ = true;
        verbose_ = true;
        return;
    }

#define OPT(opt_name, opt_param, opt_code, opt_help)					\
	if (opt_param == nullptr && string(opt_name) == arg) {				\
		opt_code;														\
		return;															\
	}																	\
	else if (opt_param != nullptr &&									\
			 collect_opt_arg(opt_name, arg, opt_arg)) {					\
		opt_code;														\
		return;															\
	}																	
#include "options.def"

    g_asm.error(ErrIllegalOption, arg);
}

void Options::parse_file(const string& arg_) {
    string arg = str_strip(unquote(arg_));
    if (arg.empty())
        return;

    if (arg[0] == '@')
        expand_list_glob(str_strip(arg.substr(1)));
    else
        expand_source_glob(arg);
}

void Options::exit_copyright() {
    cout << COPYRIGHT_MSG << endl;
    exit(0);
}

void Options::exit_help() {
    cout << COPYRIGHT_MSG << endl
        << endl
        << "Usage:" << endl
        << "  z80asm [options] { @<modulefile> | <filename> }" << endl
        << endl
        << "  [] = optional, {} = may be repeated, | = OR clause." << endl
        << endl
        << "  To assemble 'fred" EXT_ASM "' use 'fred' or 'fred" EXT_ASM "'" << endl
        << endl
        << "  <modulefile> contains list of file names of all modules to be linked," << endl
        << "  one module per line." << endl
        << endl
        << "  File types recognized or created by z80asm:" << endl
        << "    " EXT_ASM "   = source file" << endl
        << "    " EXT_O "     = object file" << endl
        << "    " EXT_LIS "   = list file" << endl
        << "    " EXT_BIN "   = Z80 binary file" << endl
        << "    " EXT_SYM "   = symbols file" << endl
        << "    " EXT_MAP "   = map file" << endl
        << "    " EXT_RELOC " = reloc file" << endl
        << "    " EXT_DEF "   = global address definition file" << endl;

#define OPT_HEADER(opt_header)	cout << endl << opt_header << endl;
#define OPT(opt_name, opt_param, opt_code, opt_help)					\
		{																\
			string opt_text = "  " + string(opt_name);					\
			if (opt_param)												\
				opt_text += string(opt_param);							\
			cout << setw(24) << left << opt_text << opt_help << endl;	\
		}
#include "options.def"

    exit(0);
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

int Options::origin() const {
    return origin_;
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

vector<string>& Options::libraries() {
    return libraries_;
}

string Options::consol_obj_filename() const {
    return file_prepend_output_dir(consol_obj_filename_);
}

unordered_map<string, int>& Options::defines() {
    return defines_;
}

void Options::define_symbol(const string& name, int value) {
    auto it = defines_.find(name);
    if (it != defines_.end()) {     // already exists
        if (value != it->second)
            g_asm.error(ErrDuplicateDefinition, name);
    }
    else {                          // new symbol
        defines_[name] = value;
        if (verbose_)
            cout << "Predefined constant: " << name << " = " << int_to_hex(value, 2) << endl;
    }
}

void Options::undefine_symbol(const string& name) {
    defines_.erase(name);
}

FloatFormat& Options::float_format() {
    return float_format_;
}

vector<string>& Options::input_files() {
    return input_files_;
}

void Options::set_cpu(cpu_t cpu) {
    undefine_symbol("__CPU_Z80__");
    undefine_symbol("__CPU_Z80_STRICT__");
    undefine_symbol("__CPU_Z80N__");
    undefine_symbol("__CPU_Z180__");
    undefine_symbol("__CPU_EZ80__");
    undefine_symbol("__CPU_EZ80_Z80__");
    undefine_symbol("__CPU_ZILOG__");

    undefine_symbol("__CPU_R800__");

    undefine_symbol("__CPU_R2KA__");
    undefine_symbol("__CPU_R3K__");
    undefine_symbol("__CPU_R4K__");
    undefine_symbol("__CPU_R5K__");
    undefine_symbol("__CPU_RABBIT__");

    undefine_symbol("__CPU_8080__");
    undefine_symbol("__CPU_8085__");
    undefine_symbol("__CPU_INTEL__");

    undefine_symbol("__CPU_GBZ80__");

    undefine_symbol("__CPU_KC160__");
    undefine_symbol("__CPU_KC160_Z80__");

    switch (cpu) {
    case CPU_Z80:
        cpu_ = CPU_Z80;
        define_symbol("__CPU_Z80__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z80_STRICT:
        cpu_ = CPU_Z80_STRICT;
        define_symbol("__CPU_Z80_STRICT__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z80N:
        cpu_ = CPU_Z80N;
        define_symbol("__CPU_Z80N__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z180:
        cpu_ = CPU_Z180;
        define_symbol("__CPU_Z180__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80:
        cpu_ = CPU_EZ80;
        define_symbol("__CPU_EZ80__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80_Z80:
        cpu_ = CPU_EZ80_Z80;
        define_symbol("__CPU_EZ80_Z80__");
        define_symbol("__CPU_ZILOG__");
        break;
    case CPU_R800:
        cpu_ = CPU_R800;
        define_symbol("__CPU_R800__");
        break;
    case CPU_R2KA:
        cpu_ = CPU_R2KA;
        define_symbol("__CPU_R2KA__");
        define_symbol("__CPU_RABBIT__");
        break;
    case CPU_R3K:
        cpu_ = CPU_R3K;
        define_symbol("__CPU_R3K__");
        define_symbol("__CPU_RABBIT__");
        break;
    case CPU_R4K:
        cpu_ = CPU_R4K;
        define_symbol("__CPU_R4K__");
        define_symbol("__CPU_RABBIT__");
        break;
    case CPU_R5K:
        cpu_ = CPU_R5K;
        define_symbol("__CPU_R5K__");
        define_symbol("__CPU_RABBIT__");
        break;
    case CPU_8080:
        cpu_ = CPU_8080;
        define_symbol("__CPU_8080__");
        define_symbol("__CPU_INTEL__");
        break;
    case CPU_8085:
        cpu_ = CPU_8085;
        define_symbol("__CPU_8085__");
        define_symbol("__CPU_INTEL__");
        break;
    case CPU_GBZ80:
        cpu_ = CPU_GBZ80;
        define_symbol("__CPU_GBZ80__");
        break;
    case CPU_KC160:
        cpu_ = CPU_KC160;
        define_symbol("__CPU_KC160__");
        break;
    case CPU_KC160_Z80:
        cpu_ = CPU_KC160_Z80;
        define_symbol("__CPU_KC160_Z80__");
        break;
    default:
        xassert(0);
    }
}

void Options::set_cpu(const string& name) {
    got_cpu_option_ = true;

    if (name == "*") {
        set_cpu(CPU_Z80);
        lib_for_all_cpus_ = true;
    }
    else if (name == ARCH_TI83_NAME) {
        set_cpu(CPU_Z80_STRICT);
        ti83_ = true;
        ti83plus_ = false;
    }
    else if (name == ARCH_TI83PLUS_NAME) {
        set_cpu(CPU_Z80_STRICT);
        ti83_ = false;
        ti83plus_ = true;
    }
    else {
        cpu_t id = cpu_id(name.c_str());
        if (id != CPU_UNDEF)
            set_cpu(id);
        else {
            g_asm.error(ErrIllegalCpuOption, name);
            g_asm.error(ErrCpusList, cpu_list());
        }
    }
}

void Options::set_swap_ixiy(swap_ixiy_t swap) {
    got_swap_ixiy_option_ = true;
    swap_ixiy_ = swap;

    undefine_symbol("__SWAP_IX_IY__");

    switch (swap_ixiy_) {
    case IXIY_NO_SWAP:
        break;
    case IXIY_SWAP:
    case IXIY_SOFT_SWAP:
        define_symbol("__SWAP_IX_IY__");
        break;
    default:
        xassert(0);
    }
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

void Options::set_origin(int origin) {
    origin_ = origin;
}

void Options::set_origin(const string& arg) {
    int value = 0;
    if (!parse_opt_int(value, arg) || value < 0)	// value can be >0xffff for banked address
        g_asm.error(ErrInvalidOrgOption, arg);
    else
        set_origin(value);
}

void Options::set_filler(int filler) {
    filler_ = filler;
}

void Options::set_filler(const string& arg) {
    int value = 0;
    if (!parse_opt_int(value, arg) || value < 0 || value > 0xFF)
        g_asm.error(ErrInvalidFillerOption, arg);
    else
        set_filler(value);
}

void Options::set_bin_filename(const string& filename) {
    bin_filename_ = filename;
}

void Options::add_library(const string& name) {
    string filename = file_lib_filename(name);
    filename = file_search_path(filename, library_path_);
    if (file_is_library_file(filename)) {
        libraries_.push_back(filename);
        if (verbose_)
            cout << "Reading library '" << filename << "'" << endl;
    }
}

void Options::set_float_format(float_format_t format) {
    float_format_.set(format);

    vector<string> all_defines = FloatFormat::get_all_defines();
    for (auto& define : all_defines)
        undefine_symbol(define);

    string float_symbol = float_format_.get_define();
    define_symbol(float_symbol);
}

void Options::set_float_format(const string& format) {
    if (!float_format_.set_text(format)) {
        g_asm.error(ErrIllegalFloatOption, format);
        g_asm.error(ErrFloatFormatsList, FloatFormat::get_all_formats());
    }
    else
        got_float_format_option_ = true;
}

// parse environment variable options
void Options::parse_env_vars() {
    const char* options = getenv(Z80ASM_ENVVAR);
    if (options) {
        if (string(options).find("-v") != string::npos) {
            verbose_ = true;
            cout << Z80ASM_ENVVAR << "=" << options << endl;
        }
        parse_args_in_text(options);
    }
}

static string next_arg(const char*& p) {
    string ret;

    // skip blanks
    while (isspace(*p))
        p++;

    // collect delimited string
    while (*p != '\0' && !isspace(*p)) {
        char delim = '\0';
        if (*p == '"' || *p == '\'')	// quoted substring
            delim = *p;
        if (delim) {
            p++;						// skip start quote
            while (*p != '\0' && *p != delim) {
                ret.push_back(*p);		// collect char
                p++;
            }
            if (*p == delim)
                p++;					// skip end quote
        }
        else {
            ret.push_back(*p);			// collect char
            p++;
        }
    }

    return ret;
}

void Options::parse_args_in_text(const string& text) {
    const char* p = text.c_str();

    while (*p != '\0') {
        string arg = next_arg(p);
        if (!arg.empty()) {
            switch (arg[0]) {
            case ';':					// comment
            case '#':
                return;
            case '-':					// option
            case '+':
                parse_option(arg);
                break;
            default:
                parse_file(arg);
                break;
            }
        }
    }
}

bool Options::collect_opt_arg(const string& opt_name, const string& arg, string& opt_arg) {
    opt_arg.clear();

    size_t opt_len = opt_name.length();
    if (arg.length() <= opt_len)
        return false;
    else if (arg.substr(0, opt_len) != opt_name)
        return false;
    else {
        size_t opt_arg_pos = opt_len;
        if (arg[opt_arg_pos] == '=')
            opt_arg_pos++;
        opt_arg = arg.substr(opt_arg_pos);
        if (opt_arg.empty())
            return false;
        else
            return true;
    }
}

void Options::parse_define(const string& opt_arg) {
    // check if we have the "=nnn" optional part
    size_t equal_pos = opt_arg.find('=');

    // get identifier (up to '=' or end)
    string ident;
    if (equal_pos == string::npos)
        ident = opt_arg;
    else
        ident = opt_arg.substr(0, equal_pos);

    if (!is_ident(ident))
        g_asm.error(ErrIllegalIdent, ident);
    else {
        if (equal_pos == string::npos) {
            define_symbol(ident, 1);
        }
        else {
            int value = 0;
            if (parse_opt_int(value, opt_arg.substr(equal_pos + 1)))
                define_symbol(ident, value);
            else
                g_asm.error(ErrInvalidDefineOption, opt_arg);
        }
    }
}

bool Options::parse_opt_int(int& value, const string& opt_arg) {
    value = 0;
    int radix = 10;
    char suffix = '\0';
    const char* p = opt_arg.c_str();

    if (opt_arg[0] == '-') {
        int this_value = 0;
        bool ret = parse_opt_int(this_value, opt_arg.substr(1));
        value = -this_value;
        return ret;
    }
    else if (opt_arg[0] == '+') {
        return parse_opt_int(value, opt_arg.substr(1));
    }

    if (opt_arg.empty()) {
        return false;
    }
    else if (opt_arg[0] == '$') {
        p++;
        radix = 16;
    }
    else if (opt_arg.length() > 2 && opt_arg[0] == '0' && tolower(opt_arg[1]) == 'x') {
        p += 2;
        radix = 16;
    }
    else if (isdigit(opt_arg[0]) && tolower(opt_arg[opt_arg.length() - 1]) == 'h') {
        suffix = opt_arg[opt_arg.length() - 1];
        radix = 16;
    }
    else {
        radix = 10;
    }

    char* end = nullptr;
    long lval = strtol(p, &end, radix);
    if (*end != suffix || errno == ERANGE || lval < 0 || lval > INT_MAX)
        return false;
    else {
        value = static_cast<int>(lval);
        return true;
    }
}

// remove pairs of quotes in argument
string Options::unquote(string text) {
    while (true) {
        size_t q1pos = text.find('"');
        size_t q2pos = text.find('\'');
        size_t q_pos = min(q1pos, q2pos);
        if (q_pos == string::npos)
            break;		// no more quotes
        char q = text[q_pos];
        size_t end = text.substr(q_pos + 1).find(q);	// find matching quote
        if (end == string::npos)
            break;		// no matching quote

        text.erase(q_pos, 1);
        text.erase(q_pos + 1 + end - 1, 1);
    }
    return text;
}

string Options::expand_env_vars(string text) {
    while (true) {
        size_t dollar_pos = text.find("${");
        if (dollar_pos == string::npos)
            break;
        size_t end_pos = text.substr(dollar_pos + 2).find('}');
        if (end_pos == string::npos)
            break;

        string varname = text.substr(dollar_pos + 2, end_pos);
        char* valptr = getenv(varname.c_str());
        string value = valptr == nullptr ? "" : string(valptr);

        text.replace(dollar_pos, end_pos + 2 + 1, value);
    }
    return text;
}

void Options::post_parsing_actions() {
    set_consol_obj_options();

    // check if -d and -m* were given
    if (date_stamp_ && lib_for_all_cpus_) {
        g_asm.error(ErrDateAndMstarIncompatible);
    }

    // check if we have any file to process
    if (input_files_.empty()) {
        g_asm.error(ErrNoSrcFile);
    }

    // make output directory if needed
    if (!output_dir_.empty()) {
        file_create_directories(output_dir_);
    }

    define_assembly_defines();
    include_z80asm_lib();
}

// make consolidated object
void Options::set_consol_obj_options() {
    if (!make_bin_ && !bin_filename_.empty()) {
        consol_obj_filename_ = bin_filename_;
        bin_filename_.clear();
    }
}

void Options::define_assembly_defines() {
    if (!got_cpu_option_)
        set_cpu(CPU_Z80);

    // __SWAP_IXIY__
    if (!got_swap_ixiy_option_)
        set_swap_ixiy(swap_ixiy_);

    if (ti83_) {
        define_symbol("__CPU_TI83__");
        undefine_symbol("__CPU_TI83PLUS__");
    }
    else if (ti83plus_) {
        undefine_symbol("__CPU_TI83__");
        define_symbol("__CPU_TI83PLUS__");
    }

    // __FLOAT__xxx__
    if (!got_float_format_option_)
        set_float_format(float_format_.get());
}

// z80asm standard library
// search in current dir, then in exe path, then in exe path/../lib, then in ZCCCFG/..
// Ignore if not found, probably benign - user will see undefined symbols
// __z80asm__xxx if the library routines are called
void Options::include_z80asm_lib() {
    string library = search_z80asm_lib();
    if (!library.empty())
        add_library(library);
}

string Options::search_z80asm_lib() {
    string lib_filename = z80asm_lib_filename();

    // try to read from current directory
    if (file_is_library_file(lib_filename))
        return lib_filename;

    // try to read from -L path
    string library_pathname = file_search_path(lib_filename, library_path_);
    if (library_pathname != lib_filename) {
        if (file_is_library_file(library_pathname))
            return library_pathname;
    }

    // try to read from ZCCCFG/..
    const char* zcccfg = getenv(ZCC_ENVVAR);
    if (zcccfg) {
        library_pathname = file_norm_path(string(zcccfg) + "/../" + lib_filename);
        if (file_is_library_file(library_pathname))
            return library_pathname;
    }

    // try to read from PREFIX/lib
    library_pathname = file_norm_path(string(PREFIX) + "/lib/" + lib_filename);
    if (file_is_library_file(library_pathname))
        return library_pathname;

    // not found, retrun empty string
    return "";
}

string Options::z80asm_lib_filename() {
    string filename;
    filename = Z80ASM_LIB_BASE;
    filename += EXT_LIB;
    return filename;
}

// Issue #2476: on msys2 a input path "/d/xxx" must be changed to "d:/xxx"
string Options::norm_msys2_arg_filename(const string& filename) {
    string cur_path = file_current_path();
    if (cur_path.size() > 2 && isalpha(cur_path[0]) && cur_path[1] == ':' &&
        filename.size() > 3 && filename[0] == '/' && isalpha(filename[1]) && filename[2] == '/')
        return string(1, filename[1]) + ":" + filename.substr(2);
    else
        return filename;
}

// get list of files from pattern
void Options::expand_source_glob(const string& pattern_) {
    string pattern = norm_msys2_arg_filename(pattern_);           // #2476
    size_t wc_pos = pattern.find_first_of("*?");
    if (wc_pos == string::npos)
        input_files_.push_back(search_source(pattern));
    else {
        vector<string> files;
        file_expand_glob(files, pattern);

        bool found = false;
        for (auto& file : files) {
            if (file_is_regular_file(file)) {
                input_files_.push_back(search_source(file));
                found = true;
            }
        }

        if (!found)
            g_asm.error(ErrGlobNoFiles, pattern);
    }
}

void Options::expand_list_glob(const string& pattern_) {
    string pattern = norm_msys2_arg_filename(pattern_);           // #2476
    vector<string> files;
    size_t wc_pos = pattern.find_first_of("*?");
    if (wc_pos == string::npos) {
        string file = file_search_path(pattern, include_path_);
        if (file_is_regular_file(file))
            files.push_back(file);		// only one file
        else
            g_asm.error(ErrFileNotFound, pattern);
    }
    else {
        file_expand_glob(files, pattern);			// list of files
        if (files.empty())
            g_asm.error(ErrGlobNoFiles, pattern);
    }

    for (auto& file : files) {
        if (file_is_regular_file(file)) {
            // append the directoy of the list file to the include path	and remove it at the end
            include_path_.push_back(file_parent_path(file));
            {
                if (file_reader_.open(file)) {
                    string line;
                    while (file_reader_.getline(line)) {
                        line = str_strip(unquote(expand_env_vars(line)));
                        if (!line.empty()) {
                            switch (line[0]) {
                            case ';':
                            case '#':
                                break;  // comment
                            case '-':
                            case '+':
                                parse_option(line); // option
                                break;
                            default:
                                parse_file(line);
                            }
                        }
                    }
                }
            }
            // finished assembly, remove dirname from include path
            include_path_.pop_back();
        }
    }
}

// search for the first file in path, with the given extension,
// with .asm extension and with .o extension
// if not found, output error and return original file
// run m4 if file is .asm.m4
string Options::search_source(const string& filename) {
    if (str_ends_with(filename, EXT_M4)) {
        string asm_filename = filename.substr(0, filename.size() - strlen(EXT_M4));
        string m4_cmd = "m4 " + m4_options_ + " \"" + filename + "\" > \"" + asm_filename + "\"";
        if (verbose_)
            cout << "% " << m4_cmd << endl;
        if (0 != system(m4_cmd.c_str())) {
            g_asm.error(ErrCmdFailed, m4_cmd);
            perror("m4");
            exit(EXIT_FAILURE);
        }
        return file_norm_path(search_source(asm_filename));
    }
    else {
        string out_filename;

        // check plain filename
        if (check_source(filename, out_filename))
            return file_norm_path(out_filename);

        // check plain file in include path
        string found_file = file_search_path(filename, include_path_);
        if (found_file != filename && check_source(found_file, out_filename))
            return file_norm_path(out_filename);

        // check filename with .asm extension
        string asm_file = filename + EXT_ASM;
        if (check_source(asm_file, out_filename))
            return file_norm_path(out_filename);

        // check filename with .asm extension in include path
        found_file = file_search_path(asm_file, include_path_);
        if (found_file != asm_file && check_source(found_file, out_filename))
            return file_norm_path(out_filename);

        // check filename with .o extension
        string o_file = filename + EXT_O;
        if (check_source(o_file, out_filename))
            return file_norm_path(out_filename);

        // check filename with .o extension in include path
        found_file = file_search_path(o_file, include_path_);
        if (found_file != o_file && check_source(found_file, out_filename))
            return file_norm_path(out_filename);

        // check object file in the output directory
        o_file = file_o_filename(filename);
        if (check_source(o_file, out_filename))
            return file_norm_path(out_filename);

        // check filename with .o extension in include path
        found_file = file_search_path(o_file, include_path_);
        if (found_file != o_file && check_source(found_file, out_filename))
            return file_norm_path(out_filename);

        // not found, avoid cascade of errors
        if (!g_asm.error_count())
            g_asm.error(ErrFileNotFound, filename);

        return file_norm_path(filename);
    }
}

bool Options::check_source(const string& filename, string& out_filename) {
    out_filename.clear();

    // avoid cascade of errors
    if (g_asm.error_count()) {
        out_filename = file_norm_path(filename);
        return true;
    }

    string src_file, obj_file;
    bool got_obj = false;

    if (file_extension(filename) == EXT_O) {
        got_obj = true;
        src_file = file_asm_filename(filename);
        obj_file = filename;
    }
    else if (file_is_regular_file(filename)) {  // any other extension is considered ASM
        got_obj = false;
        src_file = filename;
        obj_file = file_o_filename(filename);
    }
    else {
        return false;
    }

    bool src_ok = file_is_regular_file(src_file);
    bool obj_ok = file_is_regular_file(obj_file);

    // if both .o and .asm exist, return .asm or .o if -d and .o is newer
    // NOTE: -d must come before the file to have effect
    if (src_ok && obj_ok) {
        if (!date_stamp_) {
            // no -d
            if (got_obj) {
                out_filename = obj_file;
                if (!lib_for_all_cpus_)
                    if (!file_is_object_file(obj_file))
                        g_asm.error(ErrNotObjFile, obj_file);
            }
            else
                out_filename = src_file;
            return true;
        }
        else if (file_newer(obj_file, src_file)) {
            // -d and .o is up-to-date
            out_filename = obj_file;
            if (!lib_for_all_cpus_)
                if (!file_is_object_file(obj_file))
                    g_asm.error(ErrNotObjFile, obj_file);
            return true;
        }
        else {
            // -d and .o is old
            out_filename = src_file;
            return true;
        }
    }
    else if (!got_obj && src_ok) {
        out_filename = src_file;
        return true;
    }
    else if (got_obj && obj_ok) {
        out_filename = obj_file;
        if (!lib_for_all_cpus_)
            if (!file_is_object_file(obj_file))
                g_asm.error(ErrNotObjFile, obj_file);
        return true;
    }
    else {
        return false;
    }
}

