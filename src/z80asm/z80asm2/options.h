//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "files.h"
#include "z80asm_defs.h"
#include "zfloat.h"
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

// appmake
enum appmake_t {
    APPMAKE_NONE, APPMAKE_ZX81, APPMAKE_ZX,
};

#define ZX_ORIGIN		23760		// origin for unexpanded ZX Spectrum
#define ZX_ORIGIN_MIN	ZX_ORIGIN
#define ZX_ORIGIN_MAX	0xFFFF
#define ZX_APP_EXT		".tap"		// ZX Spectrum TAP file

#define ZX81_ORIGIN		16514		// origin for ZX 81
#define ZX81_ORIGIN_MIN	ZX81_ORIGIN
#define ZX81_ORIGIN_MAX	ZX81_ORIGIN
#define ZX81_APP_EXT	".P"		// ZX81 .P file


class Options {
public:
    Options();
    void clear();
    void parse_args(const vector<string>& args);
    void parse_option(const string& arg);
    void parse_file(const string& arg);

    // help
    void exit_copyright();
    void exit_help();

    // options
    cpu_t cpu() const;                  // -mCPU option
    bool ti83() const;                  // -mCPU option
    bool ti83plus() const;              // -mCPU option
    swap_ixiy_t swap_ixiy() const;      // -IXIY option
    bool verbose() const;               // -v option
    bool upper_case() const;		    // -ucase option
    bool raw_strings() const;           // -raw-strings option
    bool opt_speed() const;	            // -opt-speed option
    bool debug() const;			        // -debug option
    bool debug_z80asm() const;          // -vv
    const string& lib_filename() const;	// -x option
    bool lib_for_all_cpus() const;      // build multi-target library
    const string& output_dir() const;	// -O option
    const string& obj_filename() const; // -o option with one source
    const string& bin_filename() const;	// -o option with multiple sources
    bool make_bin() const;		        // -b option
    bool split_bin() const;		        // -split-bin option
    bool date_stamp() const;		    // -d option
    bool relocatable() const;		    // -R option
    bool reloc_info() const;		    // -reloc-info option
    int origin() const;                 // -r option
    int filler() const;				    // -f option
    bool symtable() const;		        // -s option
    bool list_file() const;		        // -l option
    bool map_file() const;			    // -m option
    bool global_def() const;		    // -g option
    appmake_t appmake() const;	        // +zx or +zx81 options
    const string& m4_options() const;   // options to the m4 subprocess
    vector<string>& include_path();		// -I option
    vector<string>& library_path();		// -L option
    vector<string>& libraries();        // -l option
    string consol_obj_filename() const; // -o without -b options
    bool is_consol_obj() const;         // -o without -b options
    unordered_map<string, int>& defines(); // -D option
    void symbol_define(const string& name, int value = 1);
    void symbol_undefine(const string& name);
    bool symbol_exists(const string& name);
    int symbol_value(const string& name);
    FloatFormat& float_format();        // -float option
    vector<string>& input_files();	    // input files to process

    // set options
    void set_cpu(cpu_t cpu = CPU_Z80);
    void set_cpu(const string& name);
    void set_swap_ixiy(swap_ixiy_t swap = IXIY_SWAP);
    void set_upper_case(bool f = true);
    void set_raw_strings(bool f = true);
    void set_output_dir(const string& dir = "");
    void set_origin(int origin);
    void set_origin(const string& arg);
    void set_filler(int filler);
    void set_filler(const string& arg);
    void set_bin_filename(const string& filename = "");
    void add_library(const string& name);
    void set_float_format(float_format_t format = FLOAT_genmath);
    void set_float_format(const string& format);

private:
    // options
    cpu_t   cpu_;                       // -mCPU option
    bool    got_cpu_option_;
    bool    ti83_;                      // -mCPU option
    bool    ti83plus_;                  // -mCPU option
    swap_ixiy_t swap_ixiy_;             // -IXIY option
    bool    got_swap_ixiy_option_;
    bool	verbose_;       			// -v option
    bool	upper_case_;		        // -ucase option
    bool    raw_strings_;               // -raw-strings option
    bool	opt_speed_;	                // -opt-speed option
    bool	debug_;         			// -debug option
    string	lib_filename_;				// -x option
    bool    lib_for_all_cpus_;          // build multi-target library
    string	output_dir_;				// -O option
    string  obj_filename_;              // -o option with one source
    string	bin_filename_;				// -o option with multiple sources
    bool	make_bin_;      		    // -b option
    bool	split_bin_;         		// -split-bin option
    bool	date_stamp_;		        // -d option
    bool	relocatable_;		        // -R option
    bool	reloc_info_;		        // -reloc-info option
    int     origin_;                    // -r option
    int		filler_;				    // -f option
    bool	symtable_;		            // -s option
    bool	list_file_;		            // -l option
    bool	map_file_;			        // -m option
    bool	global_def_;		        // -g option
    appmake_t appmake_;	                // +zx or +zx81 options
    bool    debug_z80asm_;              // -vv
    string  m4_options_;                // options to the m4 subprocess
    vector<string>	include_path_;		// -I option
    vector<string>	library_path_;		// -L option
    vector<string>	libraries_;		    // -l option
    string	consol_obj_filename_;		// -o without -b options
    unordered_map<string, int> defines_;// -D option
    FloatFormat float_format_;          // -float option
    bool    got_float_format_option_;
    vector<string>	input_files_;	    // input files to process
    FileReader  file_reader_;           // reader for @ files

    // parsing
    void parse_env_vars();
    void parse_args_in_text(const string& text);
    bool collect_opt_arg(const string& opt_name, const string& arg, string& opt_arg);
    void parse_define(const string& opt_arg);
    bool parse_opt_int(int& value, const string& opt_arg);
    string unquote(string text);
    string expand_env_vars(string text);

    // option actions
    void post_parsing_actions();
    void define_assembly_defines();

    // z80asm library
    void include_z80asm_lib();
    string search_z80asm_lib();
    string z80asm_lib_filename();

    // parsing files
    string norm_msys2_arg_filename(const string& filename);
    void expand_source_glob(const string& pattern);
    void expand_list_glob(const string& pattern);
    bool search_source(const string& filename, string& out_filename);
    bool check_source(const string& filename, string& out_filename);
};
