//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "z80asm_defs.h"
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus

#include "if.h"
#include "utils.h"
#include <string>
#include <vector>
using namespace std;

// command line arguments and files
struct Options {
public:
	void parse_args(const vector<string>& args);

	// options
    bool			verbose{ false };			// -v option
    bool			ucase{ false };			    // -ucase option
    bool            raw_strings{ false };       // -raw-strings option
    bool			opt_speed{ false };		    // -opt-speed option
    bool			debug{ false };			    // -debug option
    string			lib_file;					// -x option
    bool            lib_for_all_cpus{ false };  // build multi-target library
    string			output_dir;				    // -O option
    string			bin_file;					// -o option
    bool			make_bin{ false };		    // -b option
    bool			split_bin{ false };		    // -split-bin option
    bool			date_stamp{ false };		// -d option
    bool			relocatable{ false };		// -R option
    bool			reloc_info{ false };		// -reloc-info option
    int				filler{ 0 };				// -f option
    bool			symtable{ false };		    // -s option
    bool			list_file{ false };		    // -l option
    bool			map_file{ false };			// -m option
    bool			global_def{ false };		// -g option
    int				appmake{ APPMAKE_NONE };	// +zx or +zx81 options
    bool            debug_z80asm{ false };      // -vv
    string          m4_options;                 // options to the m4 subprocess
    vector<string>	include_path;				// -I option
    vector<string>	library_path;				// -L option
    vector<string>	input_files;				// command line files

    // options with side effects
    void set_swap_ixiy(swap_ixiy_t swap_ixiy);
    swap_ixiy_t get_swap_ixiy() const { return m_swap_ixiy; }

    void set_cpu(int cpu);
	cpu_t get_cpu() const { return m_cpu; }
	bool get_ti83() const { return m_ti83; }
	bool get_ti83plus() const { return m_ti83plus; }
    bool get_no_synth() const { return m_no_synth; }
    void set_no_synth(bool no_synth) { m_no_synth = no_synth; }

	bool is_consol_obj_file() const { return !m_consol_obj_file.empty(); }
	string get_consol_obj_file() const;

	// file names
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
    string search_include_path(const string& file) { return search_path(include_path, file); }
    string search_library_path(const string& file) { return search_path(library_path, file); }

private:
	// options with side-effects when changed
    swap_ixiy_t     m_swap_ixiy{ IXIY_NO_SWAP };// -IXIY, -IXIY-soft options
	cpu_t			m_cpu{ CPU_Z80 };	        // -m option
	bool			m_ti83{ false };			// -mti83 option
	bool			m_ti83plus{ false };		// -mti83plus option
    bool            m_no_synth{ false };        // -no-synth option
    bool            m_got_cpu_option{ false };  // got -m option
	string			m_consol_obj_file;			// -o without -b options

	// parsing
	void parse_option(const string& arg);
	void parse_file(const string& arg);
	void parse_args_in_text(const string& text);	// list files or environment
	void expand_source_glob(const string& pattern);
	void expand_list_glob(const string& pattern);
	bool search_source(const string& filename, string& out_filename);
	bool check_source(const string& filename, string& out_filename);
	void post_parsing_actions();
	void parse_env_vars();
	void set_consol_obj_options();
	void include_z80asm_lib();
	string search_z80asm_lib();
	string z80asm_lib_filename();
	bool check_library(const fs::path& file_path);
	void define_assembly_defines();

	void push_path(vector<string>& path, const string& dir);
	void pop_path(vector<string>& path);
	string search_path(vector<string>& path, const string& file);

	void set_cpu(const string& name);
	void set_filler(const string& opt_arg);

	static void exit_help();
	static void exit_copyright();
	static bool collect_opt_arg(const string& opt_name, const string& arg,
								string& opt_arg);

	static bool parse_opt_int(int& value, const string& opt_arg);
	static void parse_define(const string& opt_arg);
	static string unquote(string text);
	static string expand_env_vars(string text);
	static void set_float_format(const string& format);
	static void set_float_option(const string& format);
	static void set_origin(const string& opt_arg);
    static void define_static_symbol(const string& name, int value = 1);
    static void undefine_static_symbol(const string& name);

	// filenames
	string prepend_output_dir(const string& filename);
};

extern Options g_options;

extern "C" {
#endif // __cplusplus

    // C interface
    bool option_verbose();

    swap_ixiy_t option_swap_ixiy();
    void option_set_swap_ixiy(swap_ixiy_t swap_ixiy);
    cpu_t option_cpu();
    bool option_no_synth();
    void option_set_cpu(int cpu);
    bool option_ti83();
    bool option_ti83plus();
    bool option_speed();
    bool option_debug();
    const char* option_lib_file();
    bool option_lib_for_all_cpus();
    const char* option_bin_file();
    bool option_make_bin();
    bool option_split_bin();
    bool option_relocatable();
    bool option_reloc_info();
    int option_filler();
    bool option_symtable();
    bool option_list_file();
    bool option_map_file();
    bool option_global_def();
    bool option_is_consol_obj_file();
    const char* option_consol_obj_file_name();
    int option_appmake();
    bool option_debug_z80asm();
    void push_includes(const char* dir);
    void pop_includes();
    const char* search_includes(const char* filename);
    const char* search_libraries(const char* filename);
    size_t option_files_size();
    const char* option_file(size_t n);

#ifdef __cplusplus
}
#endif
