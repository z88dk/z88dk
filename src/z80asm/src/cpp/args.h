//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "utils.h"
#include <string>
#include <vector>
using namespace std;

// command line arguments and files
struct Args {
public:
	void parse_args(const vector<string>& args);

	// options
	bool verbose() const { return m_verbose; }
	bool swap_ixiy() const { return m_swap_ixiy; }
	bool ucase() const { return m_ucase; }
	int cpu() const { return m_cpu; }
	const string& cpu_name() const { return m_cpu_name; }
	bool ti83() const { return m_ti83; }
	bool ti83plus() const { return m_ti83plus; }
	bool opt_speed() const { return m_opt_speed; }
	bool debug() const { return m_debug; }
	const string& lib_file() const { return m_lib_file; }
	const string& output_dir() const { return m_output_dir; }
	bool split_bin() const { return m_split_bin; }
	bool date_stamp() const { return m_date_stamp; }
	bool relocatable() const { return m_relocatable; }
	bool reloc_info() const { return m_reloc_info; }
	int filler() const { return m_filler; }
	bool symtable() const { return m_symtable; }
	bool list_file() const { return m_list_file; }
	bool map() const { return m_map; }
	bool globaldef() const { return m_globaldef; }
	bool consol_obj_file() const { return !m_consol_obj_file.empty(); }
	string consol_obj_file_name() const { return m_consol_obj_file; }
	bool make_bin() const { return m_make_bin; }
	const string& bin_file() const { return m_bin_file; }
	int appmake() const { return m_appmake; }
	const vector<string>& include_path() { return m_include_path; }
	const vector<string>& files() { return m_files; }

	void push_include_path(const string& dir) { push_path(m_include_path, dir); }
	void pop_include_path() { pop_path(m_include_path); }
	string search_include_path(const string& file) { return search_path(m_include_path, file); }

	void push_library_path(const string& dir) { push_path(m_library_path, dir); }
	void pop_library_path() { pop_path(m_library_path); }
	string search_library_path(const string& file) { return search_path(m_library_path, file); }

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

private:
	// options
	bool			m_verbose{ false };			// -v option
	bool			m_swap_ixiy{ false };		// -IXIY option
	bool			m_ucase{ false };			// -ucase option
	int				m_cpu{ CPU_Z80 };			// -m option
	string			m_cpu_name{ CPU_Z80_NAME };	
	bool			m_ti83{ false };			// -mti83 option
	bool			m_ti83plus{ false };		// -mti83plus option
	bool			m_opt_speed{ false };		// -opt-speed option
	bool			m_debug{ false };			// -debug option
	string			m_lib_file;					// -x option
	string			m_output_dir;				// -O option
	string			m_bin_file;					// -o option
	bool			m_make_bin{ false };		// -b option
	bool			m_split_bin{ false };		// -split-bin option
	bool			m_date_stamp{ false };		// -d option
	bool			m_relocatable{ false };		// -R option
	bool			m_reloc_info{ false };		// -reloc-info option
	int				m_filler{ 0 };				// -f option
	bool			m_symtable{ false };		// -s option
	bool			m_list_file{ false };		// -l option
	bool			m_map{ false };				// -m option
	bool			m_globaldef{ false };		// -g option
	string			m_consol_obj_file;			// -o without -b options
	int				m_appmake{ APPMAKE_NONE };	// +zx or +zx81 options
	vector<string>	m_include_path;				// -I option
	vector<string>	m_library_path;				// -L option
	vector<string>	m_files;					// command line files

	// parsing
	void parse_option(const string& arg);
	void parse_file(const string& arg);
	void parse_args_in_text(const string& text);	// list files or environment
	void expand_source_glob(const string& pattern);
	void expand_list_glob(const string& pattern);
	string search_source(const string& filename);
	bool check_source(const string& filename, string& out_filename);
	void pre_parsing_actions();
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
	static void set_origin(const string& opt_arg);

	// filenames
	string prepend_output_dir(const string& filename);
};

extern Args g_args;
