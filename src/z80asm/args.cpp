//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "z80asm.h"
using namespace std;

Args g_args;

//-----------------------------------------------------------------------------
// CPU
//-----------------------------------------------------------------------------

// lookup table of cpus by id
struct cpu_lookup_t {
    CpuId       id;             // cpu id
    const char* name;           // cpu name
    CpuId       parent_id;      // cpu id of compatible parent
    int         level;          // level in dependency tree, 0 not compatible to any
    const char* defines;        // space-separated list of defines for this cpu
};

static cpu_lookup_t cpu_lut[] = {
#define XCPU(id_, name, parent_id, defines)    \
                { CpuId::id_, name, CpuId::parent_id, 0, defines },
#include "args.def"
};

// lookup table of cpus by name
static unordered_map<string, CpuId> cpu_map = {
#define XCPU(id_, name, parent_id, defines)    \
                { name, CpuId::id_ },
#include "args.def"
};

CpuId cpu_lookup(int cpu) {
    size_t idx = static_cast<size_t>(cpu);
    if (idx < NUM_ELEMS(cpu_lut))
        return static_cast<CpuId>(idx);
    else
        return CpuId::undef;
}

CpuId cpu_lookup(const string& name) {
    auto it = cpu_map.find(name);
    if (it != cpu_map.end())
        return it->second;
    else
        return CpuId::undef;
}

string cpu_name(CpuId id) {
    size_t idx = static_cast<size_t>(id);
    if (idx < NUM_ELEMS(cpu_lut))
        return cpu_lut[idx].name;
    else
        return "";
}

vector<string> cpu_all_defines() {
    static string all_defines =
#define XCPU(id_, name, parent_id, defines)    defines " "
#include "args.def"
        ;

    return split(all_defines);
}

vector<string> cpu_defines(CpuId id) {
    size_t idx = static_cast<size_t>(id);
    if (idx < NUM_ELEMS(cpu_lut))
        return split(cpu_lut[idx].defines);
    else
        return vector<string>();
}

const vector<CpuId>& cpu_all_cpus() {
    static vector<CpuId> cpus; // cache result

    if (cpus.empty()) {     // first time
        int max_cpu_compat_level = -1;

        // init dependency level
        for (size_t i = 1; i < NUM_ELEMS(cpu_lut); i++) {
            if (cpu_lut[i].parent_id == CpuId::undef)
                cpu_lut[i].level = 0;            // no comaptibility
            else
                cpu_lut[i].level = -1;           // still to check
        }

        bool done = false;
        do {
            done = true;
            for (size_t i = 1; i < NUM_ELEMS(cpu_lut); i++) {
                if (cpu_lut[i].level < 0) {      // not yet traversed
                    CpuId parent_id = cpu_lut[i].parent_id;
                    cpu_lookup_t* parent_ptr = &cpu_lut[static_cast<size_t>(parent_id)];
                    if (parent_ptr->level >= 0) {
                        cpu_lut[i].level = parent_ptr->level + 1;
                        if (cpu_lut[i].level > max_cpu_compat_level)
                            max_cpu_compat_level = cpu_lut[i].level;
                    }

                    done = false;
                }
            }
        } while (!done);

        // init ordered list of cpu-ids in library link order
        for (int level = max_cpu_compat_level; level >= 0; level--) {
            for (size_t i = 1; i < NUM_ELEMS(cpu_lut); i++) {
                if (cpu_lut[i].level == level)
                    cpus.push_back(cpu_lut[i].id);
            }
        }
    }

    return cpus;
}

bool cpu_compatible(CpuId my_cpu, CpuId lib_cpu) {
    CpuId id = my_cpu;
    while (id != CpuId::undef) {
        if (id == lib_cpu)
            return true;
        else {
            cpu_lookup_t* found = &cpu_lut[static_cast<size_t>(id)];
            id = found->parent_id;
        }
    }
    return false;
}

ostream& operator<<(ostream& os, CpuId id) {
    os << static_cast<int>(id);
    return os;
}

//-----------------------------------------------------------------------------
// Swap IXIY
//-----------------------------------------------------------------------------

// lookup table of swap_ixiy by id
struct swap_ixiy_lookup_t {
    SwapIXIY    id;             // swap_ixiy id
    const char* name;           // swap_ixiy option name
    const char* defines;        // space-separated list of defines for this swap_ixiy
};

static swap_ixiy_lookup_t swap_ixiy_lut[] = {
#define XSWAP_IXIY(id_, option_name, defines)    \
                { SwapIXIY::id_, option_name, defines },
#include "args.def"
};

SwapIXIY swap_ixiy_lookup(int swap_ixiy) {
    size_t idx = static_cast<size_t>(swap_ixiy);
    if (idx < NUM_ELEMS(swap_ixiy_lut))
        return static_cast<SwapIXIY>(idx);
    else
        return SwapIXIY::undef;
}

string swap_ixiy_name(SwapIXIY swap_ixiy) {
    size_t idx = static_cast<size_t>(swap_ixiy);
    if (idx < NUM_ELEMS(swap_ixiy_lut))
        return swap_ixiy_lut[idx].name;
    else
        return "";
}

vector<string> swap_ixiy_all_defines() {
    static string all_defines =
#define XSWAP_IXIY(id_, option_name, defines)   defines " "
#include "args.def"
        ;

    return split(all_defines);
}

vector<string> swap_ixiy_defines(SwapIXIY swap_ixiy) {
    size_t idx = static_cast<size_t>(swap_ixiy);
    if (idx < NUM_ELEMS(swap_ixiy_lut))
        return split(swap_ixiy_lut[idx].defines);
    else
        return vector<string>();
}

bool swap_ixiy_compatible(SwapIXIY my_swap_ixiy, SwapIXIY lib_swap_ixiy) {
    if (my_swap_ixiy == SwapIXIY::no_swap && lib_swap_ixiy == SwapIXIY::soft_swap)
        return true;
    else if (my_swap_ixiy == SwapIXIY::soft_swap && lib_swap_ixiy == SwapIXIY::no_swap)
        return true;
    else if (my_swap_ixiy == lib_swap_ixiy)
        return true;
    else
        return false;
}

ostream& operator<<(ostream& os, SwapIXIY swap_ixiy) {
    os << static_cast<int>(swap_ixiy);
    return os;
}

//-----------------------------------------------------------------------------
// Appmake
//-----------------------------------------------------------------------------

// lookup table
struct appmake_lookup_t {
    Appmake     id;
    int         default_origin;
    int         min_origin;
    int         max_origin;
    const char* file_ext;
};

static appmake_lookup_t appmake_lut[] = {
#define XAPPMAKE(id_, org, org_min, org_max, file_ext)    \
                { Appmake::id_, org, org_min, org_max, file_ext },
#include "args.def"
};

int appmake_default_origin(Appmake appmake) {
    size_t idx = static_cast<size_t>(appmake);
    xassert(idx < NUM_ELEMS(appmake_lut));
    return appmake_lut[idx].default_origin;
}

int appmake_min_origin(Appmake appmake) {
    size_t idx = static_cast<size_t>(appmake);
    xassert(idx < NUM_ELEMS(appmake_lut));
    return appmake_lut[idx].min_origin;
}

int appmake_max_origin(Appmake appmake) {
    size_t idx = static_cast<size_t>(appmake);
    xassert(idx < NUM_ELEMS(appmake_lut));
    return appmake_lut[idx].max_origin;
}

string appmake_file_ext(Appmake appmake) {
    size_t idx = static_cast<size_t>(appmake);
    xassert(idx < NUM_ELEMS(appmake_lut));
    return appmake_lut[idx].file_ext;
}

ostream& operator<<(ostream& os, Appmake appmake) {
    os << static_cast<int>(appmake);
    return os;
}

//-----------------------------------------------------------------------------
// ZFloat
//-----------------------------------------------------------------------------

// lookup table of floats by id
struct zfloat_lookup_t {
    ZFloat      id;
    const char* name;
    const char* defines;
};

static zfloat_lookup_t zfloat_lut[] = {
#define XFLOAT(id_, name, defines)  \
                { ZFloat::id_, name, defines },
#include "args.def"
};

// lookup table of floats by name
static unordered_map<string, ZFloat> zfloat_map = {
#define XFLOAT(id_, name, defines)  \
                { name, ZFloat::id_ },
#include "args.def"
};

ZFloat zfloat_lookup(const string& name) {
    auto it = zfloat_map.find(name);
    if (it != zfloat_map.end()) {
        return it->second;
    }
    else {
        return ZFloat::undef;
    }
}

string zfloat_name(ZFloat zfloat) {
    size_t idx = static_cast<size_t>(zfloat);
    xassert(idx < NUM_ELEMS(zfloat_lut));
    return zfloat_lut[idx].name;
}

vector<string> zfloat_all_defines() {
    static string all_defines =
#define XFLOAT(id_, name, defines)      defines " "
#include "args.def"
        ;

    return split(all_defines);
}

vector<string> zfloat_defines(ZFloat zfloat) {
    size_t idx = static_cast<size_t>(zfloat);
    xassert(idx < NUM_ELEMS(zfloat_lut));
    return split(zfloat_lut[idx].defines);
}

ostream& operator<<(ostream& os, ZFloat zfloat) {
    os << static_cast<int>(zfloat);
    return os;
}

//-----------------------------------------------------------------------------
// command line arguments
//-----------------------------------------------------------------------------

void Args::exit_copyright() {
    cout << COPYRIGHT_MSG << endl;
    exit(EXIT_SUCCESS);
}

void Args::exit_help() {
    cout << COPYRIGHT_MSG << endl;
    cout << endl
        << "Usage:" << endl
        << "  z80asm [options] { @<modulefile> | <filename> }" << endl
        << endl
        << "  [] = optional, {} = may be repeated, | = OR clause." << endl
        << endl
        << "  To assemble 'fred.asm' use 'fred' or 'fred.asm'" << endl
        << endl
        << "  <modulefile> contains list of file names of all modules to be linked," << endl
        << "  one module per line." << endl
        << endl
        << "  File types recognized or created by z80asm:" << endl
        << "    .asm   = source file" << endl
        << "    .o     = object file" << endl
        << "    .lis   = list file" << endl
        << "    .bin   = Z80 binary file" << endl
        << "    .sym   = symbols file" << endl
        << "    .map   = map file" << endl
        << "    .reloc = reloc file" << endl
        << "    .def   = global address definition file" << endl
        << endl
        << "Help Options:" << endl
        << "  -h                    Show help options" << endl
        << "  -v                    Be verbose" << endl
        << endl
        << "Preprocessor Options:" << endl
        << "  -IXIY                 Swap IX and IY registers" << endl
        << "  -IXIY-soft            Swap IX and IY registers but write object as unswapped" << endl
        << "  -I[=]DIR              Add directory to include search path" << endl
        << "  -D[=]SYMBOL[=VALUE]   Define a static symbol in decimal or hex" << endl
        << "  -ucase                Convert identifiers to upper case" << endl
        << "  -float[=]FORMAT       Set default float format, one of:" << endl
        << "                        genmath, math48, ieee16, ieee32, ieee64," << endl
        << "                        z80, zx81, zx, z88, mbfs, mbf40, mbf64, am9511" << endl
        << "  -raw-strings          Double-quoted strings may include any character" << endl
        << "                        except double quotes" << endl
        << "  -m4[=]OPTIONS         Pass options to the m4 subprocess" << endl
        << endl
        << "Code Generation Options:" << endl
        << "  -m[=]CPU              Assemble for the specified CPU, default z80, one of:" << endl
        << "                        *, z80, z80_strict, z180, ez80_z80, ez80, z80n, gbz80," << endl
        << "                        r2ka, r3k, r4k, r5k, 8080, 8085, r800, kc160, kc160_z80," << endl
        << "                        ti83, ti83plus" << endl
        << "  -opt-speed            Optimize for speed" << endl
        << "  -debug                Add debug info to map file" << endl
        << endl
        << "Libraries:" << endl
        << "  -L[=]DIR              Add directory to library search path" << endl
        << "  -x[=]FILE[.lib]       Create a library file.lib" << endl
        << "  -l[=]FILE[.lib]       Use library file.lib" << endl
        << endl
        << "Binary Output:" << endl
        << "  -O[=]DIR              Output directory" << endl
        << "  -o[=]FILE             Output binary file" << endl
        << "  -b                    Assemble and link/relocate to file.bin" << endl
        << "  -split-bin            Create one binary file per section" << endl
        << "  -d                    Assemble only updated files" << endl
        << "  -R                    Create relocatable code" << endl
        << "  -reloc-info           Generate binary file relocation information" << endl
        << "  -r[=]ADDR             Relocate binary file to given address in decimal or hex" << endl
        << "  -f[=]BYTE             Default value to fill in DEFS in decimal or hex" << endl
        << endl
        << "Output File Options:" << endl
        << "  -s                    Create symbol table file.sym" << endl
        << "  -l                    Create listing file.lis" << endl
        << "  -m                    Create address map file.map" << endl
        << "  -g                    Create global definition file.def" << endl
        << endl
        << "Appmake Options:" << endl
        << "  +zx81                 Generate ZX81 .P file, origin at 16514" << endl
        << "  +zx                   Generate ZX Spectrum .tap file, origin defaults to" << endl
        << "                        23760 (in a REM), but can be set with -rORG >= 24000" << endl
        << "                        for above RAMTOP" << endl;
    exit(EXIT_SUCCESS);
}

void Args::set_cpu(CpuId cpu) {
    opt_cpu = cpu;

    for (auto& define : cpu_all_defines()) {
        g_static_defines.remove(define);
    }

    for (auto& define : cpu_defines(opt_cpu)) {
        g_static_defines.add(define);
    }
}

bool Args::set_cpu(int idx) {
    CpuId cpu = cpu_lookup(idx);
    if (cpu != CpuId::undef) {
        set_cpu(cpu);
        return true;
    }
    else
        return false;
}

bool Args::set_cpu(const string& name) {
    if (name == "*") {
        set_cpu(CpuId::z80);
        opt_lib_for_all_cpus = true;
        opt_ti83 = false;
        opt_ti83plus = false;
        g_static_defines.remove(ARCH_TI83_DEFINE);
        g_static_defines.remove(ARCH_TI83PLUS_DEFINE);
        return true;
    }
    else if (name == ARCH_TI83_NAME) {
        set_cpu(CpuId::z80_strict);
        opt_lib_for_all_cpus = false;
        opt_ti83 = true;
        opt_ti83plus = false;
        g_static_defines.add(ARCH_TI83_DEFINE);
        g_static_defines.remove(ARCH_TI83PLUS_DEFINE);
        return true;
    }
    else if (name == ARCH_TI83PLUS_NAME) {
        set_cpu(CpuId::z80_strict);
        opt_lib_for_all_cpus = false;
        opt_ti83 = false;
        opt_ti83plus = true;
        g_static_defines.remove(ARCH_TI83_DEFINE);
        g_static_defines.add(ARCH_TI83PLUS_DEFINE);
        return true;
    }
    else {
        CpuId cpu = cpu_lookup(name);
        if (cpu != CpuId::undef) {
            set_cpu(cpu);
            opt_lib_for_all_cpus = false;
            opt_ti83 = false;
            opt_ti83plus = false;
            g_static_defines.remove(ARCH_TI83_DEFINE);
            g_static_defines.remove(ARCH_TI83PLUS_DEFINE);
            return true;
        }
    }
    return false;
}

void Args::set_swap_ixiy(SwapIXIY swap_ixiy) {
    opt_swap_ixiy = swap_ixiy;

    for (auto& define : swap_ixiy_all_defines()) {
        g_static_defines.remove(define);
    }

    for (auto& define : swap_ixiy_defines(swap_ixiy)) {
        g_static_defines.add(define);
    }
}

bool Args::set_swap_ixiy(int idx) {
    SwapIXIY swap_ixiy = swap_ixiy_lookup(idx);
    if (swap_ixiy != SwapIXIY::undef) {
        set_swap_ixiy(swap_ixiy);
        return true;
    }
    else
        return false;
}

void Args::set_zfloat(ZFloat zfloat) {
    opt_zfloat = zfloat;

    for (auto& define : zfloat_all_defines()) {
        g_static_defines.remove(define);
    }

    for (auto& define : zfloat_defines(zfloat)) {
        g_static_defines.add(define);
    }
}

bool Args::set_zfloat(const string& name) {
    ZFloat zfloat = zfloat_lookup(name);
    if (zfloat != ZFloat::undef) {
        set_zfloat(zfloat);
        return true;
    }
    else
        return false;
}

void Args::parse(const string& progname, vector<string> args) {
    if (args.empty())
        exit_copyright();

    // set m_verbose, if defined in env var
    parse_env_vars();

    // check for -v and -vv to activate verbosity before other options are parsed
    for (auto& arg : args) {
        string arg1 = unquote(expand_env_vars(arg));
        if (arg1 == "-v")
            opt_verbose = true;
        else if (arg1 == "-vv")
            opt_verbose = opt_debug_z80asm = true;
    }

    // show command line
    if (opt_verbose) {
        cout << "% " << progname;
        for (auto& arg : args) {
            cout << " " << arg;
        }
        cout << endl;
    }

    // parse arguments
    bool got_dash_dash = false;
    for (auto& arg_ : args) {
        string arg = unquote(expand_env_vars(arg_));
        if (!arg.empty()) {
            if (arg == "--")
                got_dash_dash = true;
            else if (!got_dash_dash && (arg[0] == '-' || arg[0] == '+'))
                parse_option(arg);
            else
                parse_file(arg);
        }

        if (g_errors.count)
            exit(EXIT_FAILURE);
    }

    // consolidated object file
    if (!opt_make_bin && !opt_bin_file.empty()) {
        opt_consol_obj_file = opt_bin_file;
        opt_bin_file.clear();
        opt_make_bin = false;
    }

    // check if -d and -m* were given
    if (opt_date_stamp && opt_lib_for_all_cpus) {
        g_errors.error(Errors::Code::mstar_and_d_options_incompatible);
    }

    // check if we have any file to process
    if (files.empty()) {
        g_errors.error(Errors::Code::source_file_expected);
    }

    // make output directory if needed
    if (!opt_output_dir.empty()) {
        fs::create_directories(fs::path(opt_output_dir));
    }

    // append z80asm library
    string z80asm_lib = search_z80asm_lib();
    if (!z80asm_lib.empty())
        opt_libraries.push_back(z80asm_lib);

    if (g_errors.count)
        exit(EXIT_FAILURE);
}

void Args::parse_option(const string& arg) {
    string opt_arg;

    if (false) {}
#define XOPT(opt_name, opt_has_param, opt_code)        					\
	else if (!opt_has_param && string(opt_name) == arg) {	    		\
		opt_code;														\
		return;															\
	}																	\
	else if (opt_has_param && collect_opt_arg(opt_name, arg, opt_arg)) {\
		opt_code;														\
		return;															\
	}																	
#include "args.def"

    g_errors.error(Errors::Code::illegal_option, arg);
}

bool Args::collect_opt_arg(const string& opt_name, const string& arg, string& opt_arg) {
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

void Args::parse_env_vars() {
    const char* options = getenv(Z80ASM_ENVVAR);
    if (options) {
        if (string(options).find("-v") != string::npos) {
            opt_verbose = true;
            cout << Z80ASM_ENVVAR << "=" << options << endl;
        }
        parse_args_in_text(options);
    }
}

static string next_arg(const char*& p) {
    string ret;

    // skip blanks
    while (is_space(*p))
        p++;

    // collect delimited string
    while (*p != '\0' && !is_space(*p)) {
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

void Args::parse_args_in_text(const string& text) {
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

void Args::parse_define(const string& opt_arg) {
    // check if we have the "=nnn" optional part
    size_t equal_pos = opt_arg.find('=');

    // get identifier (up to '=' or end)
    string ident;
    if (equal_pos == string::npos)
        ident = opt_arg;
    else
        ident = opt_arg.substr(0, equal_pos);

    if (!is_ident(ident))
        g_errors.error(Errors::Code::illegal_identifier, ident);
    else {
        if (equal_pos == string::npos) 
            g_static_defines.add(ident, 1);
        else {
            int value = 0;
            if (!parse_opt_int(value, opt_arg.substr(equal_pos + 1))) 
                g_errors.error(Errors::Code::invalid_define_option, opt_arg);
            else 
                g_static_defines.add(ident, value);
        }
    }
}

void Args::parse_origin(const string& opt_arg) {
    int origin = ORG_NOT_DEFINED;
    if (!parse_opt_int(origin, opt_arg) || origin < 0)
        g_errors.error(Errors::Code::invalid_org_option, opt_arg);
    else
        opt_origin = origin;
}

void Args::parse_filler(const string& opt_arg) {
    int filler = 0;
    if (!parse_opt_int(filler, opt_arg) || filler < 0 || filler > 255)
        g_errors.error(Errors::Code::invalid_filler_option, opt_arg);
    else
        opt_filler = filler;
}

bool Args::parse_opt_int(int& result, const string& opt_arg) {
    result = 0;
    int radix = 10;
    char suffix = '\0';
    const char* p = opt_arg.c_str();

    if (opt_arg.empty())
        return false;

    // recurse for prefix minus or plus
    if (opt_arg[0] == '-') {
        int sub_result = 0;
        if (!parse_opt_int(sub_result, opt_arg.substr(1)))
            return false;
        else {
            result = -sub_result;
            return true;
        }
    }
    else if (opt_arg[0] == '+') {
        int sub_result = 0;
        if (!parse_opt_int(sub_result, opt_arg.substr(1)))
            return false;
        else {
            result = sub_result;
            return true;
        }
    }

    if (opt_arg.empty()) {
        return false;
    }
    else if (opt_arg[0] == '$') {
        p++;
        radix = 16;
    }
    else if (opt_arg.length() > 2 && opt_arg[0] == '0' && to_lower(opt_arg[1]) == 'x') {
        p += 2;
        radix = 16;
    }
    else if (is_digit(opt_arg[0]) && to_lower(opt_arg[opt_arg.length() - 1]) == 'h') {
        suffix = opt_arg[opt_arg.length() - 1];
        radix = 16;
    }
    else {
        radix = 10;
    }

    char* end = nullptr;
    long lval = strtol(p, &end, radix);
    if (*end != suffix || errno == ERANGE || lval < 0 || lval > INT_MAX) {
        return false;
    }
    else {
        result = static_cast<int>(lval);
        return true;
    }
}

void Args::parse_file(const string& file_) {
    // set CPU before trying to check object file compatibility
    if (opt_cpu == CpuId::undef)
        set_cpu(CpuId::z80);

    // set float 
    if (opt_zfloat == ZFloat::undef)
        set_zfloat(ZFloat::genmath);

    string file = str_strip(unquote(file_));
    if (!file.empty()) {
        if (file[0] == '@')
            expand_list_glob(str_strip(file.substr(1)));
        else
            expand_source_glob(file);
    }
}

void Args::expand_source_glob(const string& pattern_) {
    string pattern = norm_filename(pattern_);           // #2476
    size_t wc_pos = pattern.find_first_of("*?");
    if (wc_pos == string::npos)
        files.push_back(search_source(pattern));
    else {
        vector<fs::path> glob_files;
        expand_glob(glob_files, pattern);

        bool found = false;
        for (auto& file : glob_files) {
            if (fs::is_regular_file(file)) {
                files.push_back(search_source(file.generic_string()));
                found = true;
            }
        }

        if (!found)
            g_errors.error(Errors::Code::pattern_returned_no_files, pattern);
    }
}

void Args::expand_list_glob(const string& pattern_) {
    string pattern = norm_filename(pattern_);           // #2476

    // get list of files from pattern
    vector<fs::path> files;
    size_t wc_pos = pattern.find_first_of("*?");
    if (wc_pos == string::npos) {
        if (fs::is_regular_file(fs::path(pattern)))
            files.push_back(fs::path(pattern));		// only one file
        else
            g_errors.error(Errors::Code::file_not_found, pattern);
    }
    else {
        expand_glob(files, pattern);			// list of files
        if (files.empty())
            g_errors.error(Errors::Code::pattern_returned_no_files, pattern);
    }

    for (auto& file : files) {
        if (fs::is_regular_file(file)) {
            // append the directoy of the list file to the include path	and remove it at the end
            g_args.opt_include_path.push_back(file.parent_path().generic_string());
            read_list_file(file.generic_string());
            g_args.opt_include_path.pop_back();
        }
    }
}

void Args::read_list_file(const string& filename) {
    if (g_file_reader.open(filename)) {
        string text;
        while (g_file_reader.getline(text)) {
            text = str_strip(unquote(expand_env_vars(text)));
            g_errors.source_line = text;
            g_errors.expanded_line.clear();

            if (!text.empty()) {
                switch (text[0]) {
                case ';':
                case '#':
                    break;  // comment
                case '-':
                case '+':
                    parse_option(text); // option
                    break;
                default:
                    parse_file(text);   // file
                }
            }

            if (g_errors.count)
                exit(EXIT_FAILURE);
        }
    }
}

// search for the first file in path, with the given extension,
// with .asm extension and with .o extension
// run m4 if file is .asm.m4
// if not found, output error and return original file
string Args::search_source(const string& filename) {
    fs::path file_path{ filename };

    if (file_path.extension().generic_string() == EXT_M4) {
        string asm_filename = filename.substr(0, filename.size() - strlen(EXT_M4));
        string m4_cmd = "m4 " + opt_m4_options + " \"" + filename + "\" > \"" + asm_filename + "\"";
        if (opt_verbose)
            cout << "% " << m4_cmd << endl;
        if (0 != system(m4_cmd.c_str())) {
            perror(m4_cmd.c_str());
            exit(EXIT_FAILURE);
        }
        return search_source(asm_filename);
    }
    else {
        string out_filename;

        // check plain filename
        if (check_source(filename, out_filename))
            return out_filename;

        // check plain file in include path
        string found_file = search_include_path(filename);
        if (found_file != filename && check_source(found_file, out_filename))
            return out_filename;

        // check filename with .asm extension
        string asm_file = filename + EXT_ASM;
        if (check_source(asm_file, out_filename))
            return out_filename;

        // check filename with .asm extension in include path
        found_file = search_include_path(asm_file);
        if (found_file != asm_file && check_source(found_file, out_filename))
            return out_filename;

        // check filename with .o extension
        string o_file = filename + EXT_O;
        if (check_source(o_file, out_filename))
            return out_filename;

        // check filename with .o extension in include path
        found_file = search_include_path(o_file);
        if (found_file != o_file && check_source(found_file, out_filename))
            return out_filename;

        // check object file in the output directory
        o_file = o_filename(filename);
        if (check_source(o_file, out_filename))
            return out_filename;

        // check filename with .o extension in include path
        found_file = search_include_path(o_file);
        if (found_file != o_file && check_source(found_file, out_filename))
            return out_filename;

        // not found, avoid cascade of errors
        if (!g_errors.count)
            g_errors.error(Errors::Code::file_not_found, filename);

        return fs::path(filename).generic_string();
    }
}

bool Args::check_source(const string& filename, string& out_filename) {
    out_filename.clear();

    // avoid cascade of errors
    if (g_errors.count) {
        out_filename = fs::path(filename).generic_string();
        return true;
    }

    fs::path file_path{ filename };
    fs::path src_file, obj_file;
    bool got_obj = false;

    if (file_path.extension().generic_string() == EXT_O) {
        got_obj = true;
        obj_file = file_path;
        src_file = asm_filename(filename);
    }
    else if (file_path.extension().generic_string() == EXT_ASM) {
        got_obj = false;
        src_file = file_path;
        obj_file = o_filename(filename);
    }
    else if (fs::is_regular_file(file_path)) {      // ASM with different extension
        got_obj = false;
        src_file = file_path;
        obj_file = o_filename(filename);
    }
    else {
        return false;
    }

    bool src_ok = fs::is_regular_file(src_file);
    bool obj_ok = fs::is_regular_file(obj_file);

    // if both .o and .asm exist, return .asm or .o if -d and .o is newer
    // NOTE: -d must come before the file to have effect
    if (src_ok && obj_ok) {
        if (!opt_date_stamp) {
            // no -d
            if (got_obj) {
                out_filename = obj_file.generic_string();
                if (!opt_lib_for_all_cpus)
                    if (!ObjFileReader::check_file_header(obj_file.generic_string()))
                        g_errors.error(Errors::Code::invalid_object_file, obj_file.generic_string());
            }
            else
                out_filename = src_file.generic_string();
            return true;
        }
        else if (fs::last_write_time(obj_file) >= fs::last_write_time(src_file)) {
            // -d and .o is up-to-date
            out_filename = obj_file.generic_string();
            if (!opt_lib_for_all_cpus)
                if (!ObjFileReader::check_file_header(obj_file.generic_string()))
                    g_errors.error(Errors::Code::invalid_object_file, obj_file.generic_string());
            return true;
        }
        else {
            // -d and .o is old
            out_filename = src_file.generic_string();
            return true;
        }
    }
    else if (!got_obj && src_ok) {
        out_filename = src_file.generic_string();
        return true;
    }
    else if (got_obj && obj_ok) {
        out_filename = obj_file.generic_string();
        if (!opt_lib_for_all_cpus)
            if (!ObjFileReader::check_file_header(obj_file.generic_string()))
                g_errors.error(Errors::Code::invalid_object_file, obj_file.generic_string());
        return true;
    }
    else {
        return false;
    }
}

string Args::search_path(const vector<string>& path, const string& file) {
    fs::path file_path{ file };

    // if path is empty, return filename as-is
    if (path.empty())
        return file_path.generic_string();

    // if file exists, return filename as-is
    if (fs::is_regular_file(file_path))
        return file_path.generic_string();

    // search in directory list
    for (auto& dir : path) {
        fs::path full_path{ fs::path(dir) / file_path };

        if (fs::is_regular_file(full_path))
            return full_path.generic_string();
    }

    // not found, return original file name
    return file_path.generic_string();
}

string Args::search_z80asm_lib() {
    string lib_name = Z80ASM_LIB;

    // try to read from current directory
    if (check_library(lib_name))
        return lib_name;

    // try to read from -L path
    string found_lib1 = search_library_path(lib_name);
    if (found_lib1 != lib_name && check_library(found_lib1))
        return found_lib1;

    // try to read from ZCCCFG/..
    const char* zcccfg = getenv(ZCCCFG_ENVVAR);
    if (zcccfg != NULL) {
        fs::path lib_path2 = fs::path(zcccfg) / fs::path("..") / fs::path(lib_name);
        string found_lib2 = lib_path2.generic_string();
        if (check_library(found_lib2))
            return found_lib2;
    }

    // try to read from PREFIX/lib
    fs::path lib_path3 = fs::path(PREFIX) / fs::path("lib") / fs::path(lib_name);
    string found_lib3 = lib_path3.generic_string();
    if (check_library(found_lib3))
        return found_lib3;

    // not found, return empty string
    return "";
}

bool Args::check_library(const string& filename) {
    if (LibFileReader::check_file_header(filename))
        return true;
    else {
        if (opt_verbose)
            cout << "Library '" << filename << "' not found" << endl;
        return false;
    }
}

string Args::replace_ext(const string& filename, const string& ext) {
    fs::path file_path{ filename };
    file_path.replace_extension(ext);
    return file_path.generic_string();
}

string Args::prepend_output_dir(const string& filename) {
    if (opt_output_dir.empty())
        return filename;
    else if (filename.substr(0, opt_output_dir.size() + 1) == opt_output_dir + "/") {
        // #2260: may be called with an object file already with the path prepended; do not add it twice
        return filename;
    }
    else {
        // NOTE: concatenation (/) of a relative fs::path and an
        // absolute fs::path discards the first one! Do our magic
        // with strings instead.
        // is it a win32 absolute path?
        string file;
        if (is_alpha(filename[0]) && filename[1] == ':') {	// C:
            file += opt_output_dir + "/";
            file += string(1, filename[0]) + "/";
            file += string(filename.substr(2));
        }
        else {
            file += opt_output_dir + "/";
            file += filename;
        }
        fs::path path{ file };
        return path.generic_string();
    }
}

string Args::asm_filename(const string& filename) {
    return replace_ext(filename, EXT_ASM);
}

string Args::lis_filename(const string& filename) {
    return prepend_output_dir(replace_ext(filename, EXT_LIS));
}

string Args::o_filename(const string& filename) {
    return prepend_output_dir(replace_ext(filename, EXT_O));
}

string Args::def_filename(const string& filename) {
    return prepend_output_dir(replace_ext(filename, EXT_DEF));
}

// see https://github.com/z88dk/z88dk/issues/2049
// No fix, to avoid breaking too many things:
// -oFILE generates single binary FILE
// -oFILE.EXT generates single binary file FILE.EXT
// section outputs are always FILE_CODE.bin
string Args::bin_filename(const string& filename, const string& section) {
    fs::path file_path, file_ext;

    if (opt_bin_file.empty()) {
        file_path = filename;
        file_ext = EXT_BIN;
    }
    else {
        // output file may have no extension
        file_path = opt_bin_file;
        file_ext = file_path.extension();
    }

    string filename1 = prepend_output_dir(file_path.generic_string());
    string filename2 = replace_ext(filename1, file_ext.generic_string());
    file_path = filename2;

    if (!section.empty()) {
        // output file with section has .bin extension
        fs::path new_path;
        new_path = file_path.parent_path();
        new_path /= file_path.stem();
        new_path += "_";
        new_path += section;
        new_path += EXT_BIN;
        file_path = new_path;
    }

    return file_path.generic_string();
}

string Args::lib_filename(const string& filename) {
    return replace_ext(filename, EXT_LIB);
}

string Args::sym_filename(const string& filename) {
    return prepend_output_dir(replace_ext(filename, EXT_SYM));
}

string Args::map_filename(const string& filename) {
    return prepend_output_dir(replace_ext(filename, EXT_MAP));
}

string Args::reloc_filename(const string& filename) {
    return replace_ext(bin_filename(filename), EXT_RELOC);
}

// Issue #2476: on msys2 a path "/d/xxx" must be changed to "d:/xxx"
string Args::norm_filename(const string& filename) {
    string cur_path = fs::current_path().generic_string();
    if (cur_path.size() > 2 && isalpha(cur_path[0]) && cur_path[1] == ':' &&
        filename.size() > 3 && filename[0] == '/' && isalpha(filename[1]) && filename[2] == '/')
        return string(1, filename[1]) + ":" + filename.substr(2);
    else
        return filename;
}

string Args::search_library(const string& filename) {
    // with .lib extension
    string lib_file = replace_ext(filename, EXT_LIB);
    lib_file = search_library_path(lib_file);
    if (fs::is_regular_file(lib_file) && check_library(lib_file))
        return lib_file;

    // without extension
    lib_file = search_library_path(filename);
    if (fs::is_regular_file(lib_file) && check_library(lib_file))
        return lib_file;

    g_errors.error(Errors::Code::library_not_found, filename);

    return filename;
}

