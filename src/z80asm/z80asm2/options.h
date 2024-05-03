//-----------------------------------------------------------------------------
// z80asm - command line options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "z80asm_defs.h"
#include <string>
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
    void parse_args(const vector<string>& args);

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
    const string& lib_file() const;		// -x option
    bool lib_for_all_cpus() const;      // build multi-target library
    const string& output_dir() const;	// -O option
    const string& bin_filename() const;	// -o option
    bool make_bin() const;		        // -b option
    bool split_bin() const;		        // -split-bin option
    bool date_stamp() const;		    // -d option
    bool relocatable() const;		    // -R option
    bool reloc_info() const;		    // -reloc-info option
    int filler() const;				    // -f option
    bool symtable() const;		        // -s option
    bool list_file() const;		        // -l option
    bool map_file() const;			    // -m option
    bool global_def() const;		    // -g option
    appmake_t appmake() const;	        // +zx or +zx81 options
    bool debug_z80asm() const;          // -vv
    const string& m4_options() const;   // options to the m4 subprocess
    vector<string>& include_path();		// -I option
    vector<string>& library_path();		// -L option
    const string& consol_obj_filename() const;

    // set options
    void set_cpu(cpu_t cpu = CPU_Z80);
    void set_swap_ixiy(swap_ixiy_t swap = IXIY_SWAP);
    void set_upper_case(bool f = true);
    void set_raw_strings(bool f = true);
    void set_output_dir(const string& dir = "");
    void set_bin_filename(const string& filename = "");

private:
    cpu_t   cpu_{ CPU_Z80 };            // -mCPU option
    bool    ti83_{ false };             // -mCPU option
    bool    ti83plus_{ false };         // -mCPU option
    swap_ixiy_t swap_ixiy_{ IXIY_NO_SWAP }; // -IXIY option
    bool	verbose_{ false };			// -v option
    bool	upper_case_{ false };		// -ucase option
    bool    raw_strings_{ false };      // -raw-strings option
    bool	opt_speed_{ false };	    // -opt-speed option
    bool	debug_{ false };			// -debug option
    string	lib_file_;					// -x option
    bool    lib_for_all_cpus_{ false }; // build multi-target library
    string	output_dir_;				// -O option
    string	bin_filename_;				// -o option
    bool	make_bin_{ false };		    // -b option
    bool	split_bin_{ false };		// -split-bin option
    bool	date_stamp_{ false };		// -d option
    bool	relocatable_{ false };		// -R option
    bool	reloc_info_{ false };		// -reloc-info option
    int		filler_{ 0 };				// -f option
    bool	symtable_{ false };		    // -s option
    bool	list_file_{ false };		// -l option
    bool	map_file_{ false };			// -m option
    bool	global_def_{ false };		// -g option
    appmake_t appmake_{ APPMAKE_NONE };	// +zx or +zx81 options
    bool    debug_z80asm_{ false };     // -vv
    string  m4_options_;                // options to the m4 subprocess
    vector<string>	include_path_;		// -I option
    vector<string>	library_path_;		// -L option
    string	consol_obj_filename_;		// -o without -b options

};
