//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "model.h"
#include <string>
#include <vector>
using namespace std;

// origin
#define ORG_NOT_DEFINED     -1
#define ORG_SECTION_SPLIT   -2

#define ZX_ORIGIN		23760		// origin for unexpanded ZX Spectrum
#define ZX81_ORIGIN		16514		// origin for ZX 81

//-----------------------------------------------------------------------------
// CPU
//-----------------------------------------------------------------------------

#define ARCH_TI83_NAME		    "ti83"
#define ARCH_TI83PLUS_NAME	    "ti83plus"

#define ARCH_TI83_DEFINE		"__CPU_TI83__"
#define ARCH_TI83PLUS_DEFINE	"__CPU_TI83PLUS__"

enum class CpuId {
#define XCPU(id_, name, parent_id, defines)     id_,
#include "args.def"
};

CpuId cpu_lookup(int cpu);
CpuId cpu_lookup(const string& name);
string cpu_name(CpuId id);
vector<string> cpu_all_defines();
vector<string> cpu_defines(CpuId id);
const vector<CpuId>& cpu_all_cpus();
bool cpu_compatible(CpuId my_cpu, CpuId lib_cpu);
ostream& operator<<(ostream& os, CpuId id);

//-----------------------------------------------------------------------------
// Swap IXIY
//-----------------------------------------------------------------------------

enum class SwapIXIY {
#define XSWAP_IXIY(id, option_name, defines)   id,
#include "args.def"
};

SwapIXIY swap_ixiy_lookup(int swap_ixiy);
string swap_ixiy_name(SwapIXIY swap_ixiy);
vector<string> swap_ixiy_all_defines();
vector<string> swap_ixiy_defines(SwapIXIY swap_ixiy);
bool swap_ixiy_compatible(SwapIXIY my_swap_ixiy, SwapIXIY lib_swap_ixiy);
ostream& operator<<(ostream& os, SwapIXIY swap_ixiy);

//-----------------------------------------------------------------------------
// Appmake
//-----------------------------------------------------------------------------

enum class Appmake {
#define XAPPMAKE(id, org, org_min, org_max, file_ext)   id, 
#include "args.def"
};

int appmake_default_origin(Appmake appmake);
int appmake_min_origin(Appmake appmake);
int appmake_max_origin(Appmake appmake);
string appmake_file_ext(Appmake appmake);

ostream& operator<<(ostream& os, Appmake appmake);

//-----------------------------------------------------------------------------
// ZFloat
//-----------------------------------------------------------------------------

enum class ZFloat {
#define XFLOAT(id, name, defines)      id,
#include "args.def"
    };

ZFloat zfloat_lookup(const string& name);
string zfloat_name(ZFloat zfloat);
vector<string> zfloat_all_defines();
vector<string> zfloat_defines(ZFloat zfloat);
ostream& operator<<(ostream& os, ZFloat zfloat);

//-----------------------------------------------------------------------------
// command line arguments
//-----------------------------------------------------------------------------

struct Args {
    // help options
    bool            opt_verbose{ false };           // verbose option
    bool            opt_debug_z80asm{ false };      // printf-debug, if needed

    // preprocessor options
    vector<string>	opt_include_path;				// -I option
    bool			opt_ucase{ false };			    // -ucase option
    bool            opt_raw_strings{ false };       // -raw-strings option
    string          opt_m4_options;                 // options to m4 subprocess

    // code generation options
    CpuId           opt_cpu{ CpuId::undef };        // -m option
    void set_cpu(CpuId cpu);                        // sets CPU and defines
    bool set_cpu(int idx);                          // sets CPU and defines
    bool set_cpu(const string& name);               // sets CPU and defines

    SwapIXIY      opt_swap_ixiy{ SwapIXIY::no_swap }; // -IXIY, -IXIY-soft options
    void set_swap_ixiy(SwapIXIY swap_ixiy);         // sets swap IXIY and defines
    bool set_swap_ixiy(int idx);                    // sets CPU and defines

    ZFloat          opt_zfloat{ ZFloat::undef };    // float format
    void set_zfloat(ZFloat zfloat);                 // sets zfloat and defines
    bool set_zfloat(const string& name);            // sets zfloat and defines

    bool			opt_ti83{ false };			    // -mti83 option
    bool			opt_ti83plus{ false };		    // -mti83plus option
    bool			opt_speed{ false };		        // -opt-speed option
    bool			opt_debug{ false };			    // -debug option

    // library options
    vector<string>	opt_library_path;				// -L option
    string			opt_lib_file;					// -x option
    vector<string>  opt_libraries;                  // -llib list of libraries to link
    bool            opt_lib_for_all_cpus{ false };  // build multi-target library

    // binary output options
    string			opt_output_dir;				    // -O option
    string			opt_bin_file;					// -o option
    string			opt_consol_obj_file;			// -o without -b options
    bool			opt_make_bin{ false };		    // -b option
    bool			opt_split_bin{ false };		    // -split-bin option
    bool			opt_date_stamp{ false };		// -d option
    bool			opt_relocatable{ false };		// -R option
    bool			opt_reloc_info{ false };		// -reloc-info option
    int             opt_origin{ ORG_NOT_DEFINED };  // -r=org option
    int				opt_filler{ 0 };				// -f option

    // output file options
    bool			opt_symtable{ false };		    // -s option
    bool			opt_list_file{ false };		    // -l option
    bool			opt_map_file{ false };			// -m option
    bool			opt_globaldef{ false };		    // -g option

    // appmake options
    Appmake		    opt_appmake{ Appmake::none };   // +zx or +zx81 options

    // command line files
    vector<string>	files;					        // command line files

    // operations
    void parse(const string& progname, vector<string> args);

    // filenames
    string asm_filename(const string& filename);
    string lis_filename(const string& filename);
    string o_filename(const string& filename);
    string def_filename(const string& filename);
    string bin_filename(const string& filename, const string& section = "");
    string lib_filename(const string& filename);
    string sym_filename(const string& filename);
    string map_filename(const string& filename);
    string reloc_filename(const string& bin_filename);
    string norm_filename(const string& filename);

    // filename operations
    string search_include_path(const string& file) { return search_path(opt_include_path, file); }
    string search_library_path(const string& file) { return search_path(opt_library_path, file); }
    string search_library(const string& filename);

private:
    void exit_copyright();
    void exit_help();

    void parse_option(const string& arg);
    bool collect_opt_arg(const string& opt_name, const string& arg, string& opt_arg);
    void parse_env_vars();
    void parse_args_in_text(const string& text);	// list files or environment
    void parse_define(const string& opt_arg);       // parses text after -D
    void parse_origin(const string& opt_arg);       // parses integer after -r
    void parse_filler(const string& opt_arg);       // parses integer after -f
    bool parse_opt_int(int& result, const string& opt_arg); // parses integer
    void parse_file(const string& file);            // file glob or list file

    void expand_source_glob(const string& pattern); // expand wildcards in pattern and add files
    void expand_list_glob(const string& pattern);   // expand wildcards in pattern and add list
    void read_list_file(const string& filename);    // read contents of a @listfile

    string search_source(const string& filename);   // choose .o or .asm file
    bool check_source(const string& filename, string& out_filename);

    string search_path(const vector<string>& path, const string& file);
    string search_z80asm_lib();
    bool check_library(const string& filename);

    string replace_ext(const string& filename, const string& ext);
    string prepend_output_dir(const string& filename);
};

extern Args g_args;
