//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "args.h"
#include "errors.h"
#include "float.h"
#include "lex.h"
#include "preproc.h"
#include "utils.h"
#include "../config.h"
#include <iostream>
#include <iomanip>
#include <cassert>
#include <cstring>
#include <climits>
using namespace std;

Args g_args;

// environment variable
#define Z80ASM_ENVVAR	"Z80ASM"

// library base name
#define Z80ASM_LIB_BASE	"z88dk-z80asm"

//-----------------------------------------------------------------------------
// version
//-----------------------------------------------------------------------------
#ifndef Z88DK_VERSION
#define Z88DK_VERSION "build " __DATE__
#endif

#define COPYRIGHT		"InterLogic 1993-2009, Paulo Custodio 2011-2022"

#define COPYRIGHT_MSG	"Z80 Macro Assembler " Z88DK_VERSION "\n(c) " COPYRIGHT

void Args::exit_copyright() {
	cout << COPYRIGHT_MSG << endl;
	exit(0);
}

//-----------------------------------------------------------------------------
// help
//-----------------------------------------------------------------------------
void Args::exit_help() {
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
#include "args.def"

	exit(0);
}

//-----------------------------------------------------------------------------
// parsing
//-----------------------------------------------------------------------------
void Args::parse_args(const vector<string>& args) {

	if (args.empty())
		exit_copyright();

	pre_parsing_actions();
	if (g_errors.count() > 0)
		return;

	bool got_dash_dash = false;
	for (auto& arg : args) {
		if (arg.empty())
			continue;
		else if (arg == "--")
			got_dash_dash = true;
		else if (!got_dash_dash && (arg[0] == '-' || arg[0] == '+'))
			parse_option(arg);
		else
			parse_file(arg);

		if (g_errors.count() > 0)
			return;
	}

	post_parsing_actions();
}

string Args::prepend_output_dir(const string& filename) {
	if (m_output_dir.empty())
		return filename;
	else if (filename.substr(0, m_output_dir.size() + 1) == m_output_dir + "/") {
		// #2260: may be called with an object file already with the path prepended; do not add it twice
		return filename;
	}
	else {
		// NOTE: concatenation (/) of a relative fs::path and an
		// absolute fs::path discards the first one! Do our magic
		// with strings instead.
		// is it a win32 absolute path?
		string file;
		if (isalpha(filename[0]) && filename[1] == ':') {	// C:
			file += m_output_dir + "/";
			file += string(1, filename[0]) + "/";
			file += string(filename.substr(2));
		}
		else {
			file += m_output_dir + "/";
			file += filename;
		}
		fs::path path{ file };
		return path.generic_string();
	}
}

static string replace_ext(const string& filename, const string& ext) {
	fs::path file_path{ filename };
	file_path.replace_extension(ext);
	return file_path.generic_string();
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

	if (m_bin_file.empty()) {
		file_path = filename;
		file_ext = EXT_BIN;
	}
	else {
		// output file may have no extension
		file_path = m_bin_file;
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

// argument is binary file, already has the output_dir prepended
string Args::reloc_filename(const string& bin_filename) {
	return replace_ext(bin_filename, EXT_RELOC);
}

void Args::parse_option(const string& arg_) {
	string arg = unquote(expand_env_vars(arg_));
	string opt_arg;

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
#include "args.def"

	g_errors.error(ErrCode::IllegalOption, arg);
}

// return false if cannot parse integer
bool Args::parse_opt_int(int& value, const string& opt_arg) {
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

void Args::parse_define(const string& opt_arg) {
	// check if we have the "=nnn" optional part
	size_t equal_pos = opt_arg.find('=');

	// get identifier (up to '=' or end)
	string ident;
	if (equal_pos == string::npos)
		ident = opt_arg;
	else
		ident = opt_arg.substr(0, equal_pos);

	if (!isident(ident))
		g_errors.error(ErrCode::IllegalIdent, ident);
	else {
		if (equal_pos == string::npos) {
			define_static_def_sym(ident.c_str(), 1);
		}
		else {
			int value = 0;
			if (parse_opt_int(value, opt_arg.substr(equal_pos + 1))) 
				define_static_def_sym(ident.c_str(), value);
			else
				g_errors.error(ErrCode::InvalidDefineOption, opt_arg);
		}
	}
}

// remove pairs of quotes in argument
string Args::unquote(string text) {
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

string Args::expand_env_vars(string text) {
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

void Args::set_float_format(const string& format) {
	if (!g_float_format.set_text(format))
		g_errors.error(ErrCode::InvalidFloatFormat, FloatFormat::get_formats());
}

void Args::set_origin(const string& opt_arg) {
	int value = 0;
	if (!parse_opt_int(value, opt_arg) || value < 0)	// value can be >0xffff for banked address
		g_errors.error(ErrCode::InvalidOrgOption, opt_arg);
	else
		set_origin_option(value);
}

bool Args::collect_opt_arg(const string& opt_name, const string& arg,
	string& opt_arg) {
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

void Args::parse_file(const string& arg_) {
	if (arg_.empty())
		return;

	string arg = unquote(expand_env_vars(arg_));
	if (arg[0] == '@')
		expand_list_glob(arg.substr(1));
	else
		expand_source_glob(arg);
}

void Args::expand_source_glob(const string& pattern) {
	size_t wc_pos = pattern.find_first_of("*?");
	if (wc_pos == string::npos)
		m_files.push_back(search_source(pattern));
	else {
		vector<fs::path> files;
		expand_glob(files, pattern);

		if (files.empty())
			g_errors.error(ErrCode::GlobNoFiles, pattern);

		for (auto& file : files) {
			if (fs::is_regular_file(file))
				m_files.push_back(search_source(file.generic_string()));
		}
	}
}

void Args::expand_list_glob(const string& pattern) {
	// get list of files from pattern
	vector<fs::path> files;
	size_t wc_pos = pattern.find_first_of("*?");
	if (wc_pos == string::npos) {
		if (fs::is_regular_file(fs::path(pattern)))
			files.push_back(fs::path(pattern));		// only one file
		else
			g_errors.error(ErrCode::FileOpen, pattern);
	}
	else {
		expand_glob(files, pattern);			// list of files
		if (files.empty())
			g_errors.error(ErrCode::GlobNoFiles, pattern);
	}

	for (auto& file : files) {
		if (fs::is_regular_file(file)) {
			// append the directoy of the list file to the include path	and remove it at the end
			g_args.push_include_path(file.parent_path().generic_string());
			{
				if (g_preproc.open(file.generic_string(), false)) {
					string line;
					while (g_preproc.get_unpreproc_line(line)) {
						parse_args_in_text(line);
					}
				}
			}
			// finished assembly, remove dirname from include path
			g_args.pop_include_path();
		}
	}
}


// search for the first file in path, with the given extension,
// with .asm extension and with .o extension
// if not found, output error and return original file
string Args::search_source(const string& filename) {
	string out_filename;

	// check plain filename
	if (check_source(filename, out_filename))
		return out_filename;

	// check plain file in include path
	string found_file = search_include_path(filename);
	if (check_source(found_file, out_filename))
		return out_filename;

	// check filename with .asm extension
	string asm_file = asm_filename(filename);
	if (check_source(asm_file, out_filename))
		return out_filename;

	// check filename with .asm extension in include path
	found_file = search_include_path(asm_file);
	if (check_source(found_file, out_filename))
		return out_filename;

	// check filename with .o extension
	string o_file = o_filename(filename);
	if (check_source(o_file, out_filename))
		return out_filename;

	// check filename with .o extension in include path
	found_file = search_include_path(o_file);
	if (check_source(found_file, out_filename))
		return out_filename;

	// not found, avoid cascade of errors
	if (g_errors.count() == 0)
		g_errors.error(ErrCode::FileOpen, filename);

	return fs::path(filename).generic_string();
}

bool Args::check_source(const string& filename, string& out_filename) {
	out_filename.clear();

	// avoid cascade of errors
	if (g_errors.count() > 0) {
		out_filename = fs::path(filename).generic_string();
		return true;
	}

	fs::path file_path{ filename };
	fs::path src_file, obj_file;
	bool got_obj;

	if (!file_path.has_extension()) {
		if (fs::is_regular_file(file_path))
			src_file = filename;
		else
			src_file = asm_filename(filename);
		obj_file = o_filename(filename);
		got_obj = false;
	}
	else if (file_path.extension().generic_string() == EXT_O) {
		src_file = asm_filename(filename);
		obj_file = file_path;
		got_obj = true;
	}
	else {
		src_file = file_path;
		obj_file = o_filename(filename);
		got_obj = false;
	}

	bool src_ok = fs::is_regular_file(src_file);
	bool obj_ok = fs::is_regular_file(obj_file) &&
		check_object_file_no_errors(obj_file.generic_string().c_str());

	// if both .o and .asm exist and .o is valid, return .asm
	// or .o if -d and .o is newer
	// NOTE: -d must come before the file to have effect
	if (src_ok && obj_ok) {
		if (!m_date_stamp) {
			// no -d
			if (got_obj)
				out_filename = obj_file.generic_string();
			else
				out_filename = src_file.generic_string();
			return true;
		}
		else if (fs::last_write_time(obj_file) >= fs::last_write_time(src_file)) {
			// -d and .o is up-to-date
			out_filename = obj_file.generic_string();
			return true;
		}
		else {
			// -d and .o is old
			out_filename = src_file.generic_string();
			return true;
		}
	}
	else if (src_ok) {
		out_filename = src_file.generic_string();
		return true;
	}
	else if (obj_ok) {
		out_filename = obj_file.generic_string();
		return true;
	}
	else {
		// output object file errors, if any
		if (fs::is_regular_file(obj_file))
			check_object_file(obj_file.generic_string().c_str());
		return false;
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

//-----------------------------------------------------------------------------
// file path manipulation
//-----------------------------------------------------------------------------
void Args::push_path(vector<string>& path, const string& dir) {
	path.push_back(dir);
}

void Args::pop_path(vector<string>& path) {
	path.pop_back();
}

string Args::search_path(vector<string>& path, const string& file) {
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

void Args::set_cpu(const string& name) {
	if (name == CPU_Z80_NAME) {
		m_cpu = CPU_Z80;
		m_cpu_name = CPU_Z80_NAME;
	}
	else if (name == CPU_Z80N_NAME) {
		m_cpu = CPU_Z80N;
		m_cpu_name = CPU_Z80N_NAME;
	}
	else if (name == CPU_Z180_NAME) {
		m_cpu = CPU_Z180;
		m_cpu_name = CPU_Z180_NAME;
	}
	else if (name == CPU_R2KA_NAME) {
		m_cpu = CPU_R2KA;
		m_cpu_name = CPU_R2KA_NAME;
	}
	else if (name == CPU_R3K_NAME) {
		m_cpu = CPU_R3K;
		m_cpu_name = CPU_R3K_NAME;
	}
	else if (name == CPU_8080_NAME) {
		m_cpu = CPU_8080;
		m_cpu_name = CPU_8080_NAME;
	}
	else if (name == CPU_8085_NAME) {
		m_cpu = CPU_8085;
		m_cpu_name = CPU_8085_NAME;
	}
	else if (name == CPU_GBZ80_NAME) {
		m_cpu = CPU_GBZ80;
		m_cpu_name = CPU_GBZ80_NAME;
	}
	else if (name == ARCH_TI83_NAME) {
		m_cpu = CPU_Z80;
		m_cpu_name = CPU_Z80_NAME;
		m_ti83 = true;
		m_ti83plus = false;
	}
	else if (name == ARCH_TI83PLUS_NAME) {
		m_cpu = CPU_Z80;
		m_cpu_name = CPU_Z80_NAME;
		m_ti83 = false;
		m_ti83plus = true;
	}
	else {
		string error = name + "; expected: ";
		error += CPU_Z80_NAME		",";
		error += CPU_Z80N_NAME		",";
		error += CPU_Z180_NAME		",";
		error += CPU_R2KA_NAME		",";
		error += CPU_R3K_NAME		",";
		error += CPU_8080_NAME		",";
		error += CPU_8085_NAME		",";
		error += CPU_GBZ80_NAME		",";
		error += ARCH_TI83_NAME		",";
		error += ARCH_TI83PLUS_NAME	",";
		error.pop_back(); // remove last comma
		g_errors.error(ErrCode::InvalidCpu, error);
	}
}

void Args::set_filler(const string& opt_arg) {
	int value = 0;
	if (!parse_opt_int(value, opt_arg) || value < 0 || value > 0xFF)
		g_errors.error(ErrCode::InvalidFillerOption, opt_arg);
	else
		m_filler = value;
}

void Args::pre_parsing_actions() {
	parse_env_vars();
}

void Args::post_parsing_actions() {
	set_consol_obj_options();

	// check if we have any file to process
	if (m_files.empty())
		g_errors.error(ErrCode::NoSrcFile);

	// make output directory if needed
	if (!m_output_dir.empty())
		fs::create_directories(fs::path(m_output_dir));

	include_z80asm_lib();
	define_assembly_defines();
}

// parse environment variable options
void Args::parse_env_vars() {
	const char* options = getenv(Z80ASM_ENVVAR);
	if (options)
		parse_args_in_text(options);
}

// make consolidated object
void Args::set_consol_obj_options() {
	if (!m_make_bin && !m_bin_file.empty()) {
		m_consol_obj_file = m_bin_file;
		m_make_bin = false;
	}
}

// z80asm standard library
// search in current dir, then in exe path, then in exe path/../lib, then in ZCCCFG/..
// Ignore if not found, probably benign - user will see undefined symbols
// __z80asm__xxx if the library routines are called
void Args::include_z80asm_lib() {
	string library = search_z80asm_lib();
	if (!library.empty())
		library_file_append(library.c_str());
}

string Args::search_z80asm_lib() {
	string lib_name = z80asm_lib_filename();

	// try to read from current directory
	if (check_library(fs::path(lib_name)))
		return lib_name;

	// try to read from -L path
	string found_lib1 = search_library_path(lib_name.c_str());
	if (found_lib1 != lib_name) {
		if (check_library(fs::path(found_lib1)))
			return found_lib1;
	}

	// TODO: this should not rely on g_args
	string found_lib2 = search_library_path(get_lib_filename(lib_name.c_str()));
	if (found_lib2 != lib_name && found_lib2 != found_lib1) {
		if (check_library(fs::path(found_lib2)))
			return found_lib2;
	}

	// try to read from ZCCCFG/..
	const char* zcccfg = getenv("ZCCCFG");
	if (zcccfg) {
		fs::path lib_path = fs::path(zcccfg) / fs::path("..") / fs::path(lib_name);
		if (check_library(lib_path))
			return lib_path.generic_string();
	}

	// try to read from PREFIX/lib
	fs::path lib_path{ fs::path(PREFIX) / fs::path("lib") / fs::path(lib_name) };
	if (check_library(lib_path))
		return lib_path.generic_string();

	// not found, retrun empty string
	return "";
}

// build z80asm_lib filename: z88dk-z80asm-<cpu>-<ixiy|''>.lib
string Args::z80asm_lib_filename() {
	string filename;
	filename = Z80ASM_LIB_BASE;
	filename += "-";
	filename += m_cpu_name;
	filename += "-";
	if (m_swap_ixiy)
		filename += "ixiy";
	filename += EXT_LIB;
	return filename;
}

bool Args::check_library(const fs::path& file_path) {
	if (fs::is_regular_file(file_path))
		return true;
	else {
		if (m_verbose)
			cout << "Library '" << file_path.generic_string()
			<< "' not found" << endl;
		return false;
	}
}

void Args::define_assembly_defines() {
	switch (m_cpu) {
	case CPU_Z80:
		define_static_def_sym("__CPU_Z80__", 1);
		define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_Z80N:
		define_static_def_sym("__CPU_Z80N__", 1);
		define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_Z180:
		define_static_def_sym("__CPU_Z180__", 1);
		define_static_def_sym("__CPU_ZILOG__", 1);
		break;
	case CPU_R2KA:
		define_static_def_sym("__CPU_R2KA__", 1);
		define_static_def_sym("__CPU_RABBIT__", 1);
		break;
	case CPU_R3K:
		define_static_def_sym("__CPU_R3K__", 1);
		define_static_def_sym("__CPU_RABBIT__", 1);
		break;
	case CPU_8080:
		define_static_def_sym("__CPU_8080__", 1);
		define_static_def_sym("__CPU_INTEL__", 1);
		break;
	case CPU_8085:
		define_static_def_sym("__CPU_8085__", 1);
		define_static_def_sym("__CPU_INTEL__", 1);
		break;
	case CPU_GBZ80:
		define_static_def_sym("__CPU_GBZ80__", 1);
		break;
	default:
		assert(0);
	}

	if (m_swap_ixiy) {
		define_static_def_sym("__SWAP_IX_IY__", 1);
	}

	if (m_ti83) {
		define_static_def_sym("__CPU_TI83__", 1);
	}
	else if (m_ti83plus) {
		define_static_def_sym("__CPU_TI83PLUS__", 1);
	}

	// __FLOAT__xxx__
	define_static_def_sym(get_float_format_define(), 1);
}

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------
bool option_verbose() {
	return g_args.verbose();
}

bool option_swap_ixiy() {
	return g_args.swap_ixiy();
}

void push_includes(const char* dir) {
	g_args.push_include_path(dir);
}

void pop_includes() {
	g_args.pop_include_path();
}

const char* search_includes(const char* filename) {
	string searched_file = g_args.search_include_path(filename);
	return spool_add(searched_file.c_str());
}

int option_cpu() {
	return g_args.cpu();
}

const char* option_cpu_name() {
	return spool_add(g_args.cpu_name().c_str());
}

bool option_ti83() {
	return g_args.ti83();
}

bool option_ti83plus() {
	return g_args.ti83plus();
}

bool option_speed() {
	return g_args.opt_speed();
}

bool option_debug() {
	return g_args.debug();
}

const char* search_libraries(const char* filename) {
	string searched_file = g_args.search_library_path(filename);
	return spool_add(searched_file.c_str());
}

const char* option_lib_file() {
	string filename = g_args.lib_file();
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

const char* option_bin_file() {
	string filename = g_args.bin_file();
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

bool option_make_bin() {
	return g_args.make_bin();
}

bool option_split_bin() {
	return g_args.split_bin();
}

bool option_date_stamp() {
	return g_args.date_stamp();
}

bool option_relocatable() {
	return g_args.relocatable();
}

bool option_reloc_info() {
	return g_args.reloc_info();
}

int option_filler() {
	return g_args.filler();
}

bool option_symtable() {
	return g_args.symtable();
}

bool option_list_file() {
	return g_args.list_file();
}

bool option_map() {
	return g_args.map();
}

bool option_globaldef() {
	return g_args.globaldef();
}

bool option_consol_obj_file() {
	return g_args.consol_obj_file();
}

const char* option_consol_obj_file_name() {
	string filename = g_args.consol_obj_file_name();
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

int option_appmake() {
	return g_args.appmake();
}

// filesystem
const char* path_parent_dir(const char* filename) {
	fs::path file_path{ filename };
	string parent;

	if (!file_path.has_parent_path())
		parent = ".";
	else
		parent = file_path.parent_path().generic_string();

	return spool_add(parent.c_str());
}

bool path_file_exists(const char* filename) {
	fs::path file_path{ filename };

	if (fs::is_regular_file(file_path))
		return true;
	else
		return false;
}

const char* path_replace_ext(const char* filename, const char* ext) {
	fs::path file_path{ filename };
	file_path.replace_extension(ext);
	string new_file = file_path.generic_string();
	return spool_add(new_file.c_str());
}

const char* get_asm_filename(const char* filename) {
	return spool_add(g_args.asm_filename(filename).c_str());
}

const char* get_lis_filename(const char* filename) {
	return spool_add(g_args.lis_filename(filename).c_str());
}

const char* get_o_filename(const char* filename) {
	return spool_add(g_args.o_filename(filename).c_str());
}

const char* get_def_filename(const char* filename) {
	return spool_add(g_args.def_filename(filename).c_str());
}

const char* get_bin_filename(const char* filename, const char* section) {
	return spool_add(g_args.bin_filename(filename, section).c_str());
}

const char* get_lib_filename(const char* filename) {
	return spool_add(g_args.lib_filename(filename).c_str());
}

const char* get_sym_filename(const char* filename) {
	return spool_add(g_args.sym_filename(filename).c_str());
}

const char* get_map_filename(const char* filename) {
	return spool_add(g_args.map_filename(filename).c_str());
}

const char* get_reloc_filename(const char* bin_filename) {
	return spool_add(g_args.reloc_filename(bin_filename).c_str());
}

size_t option_files_size() {
	return g_args.files().size();
}

const char* option_file(size_t n) {
	return spool_add(g_args.files().at(n).c_str());
}
