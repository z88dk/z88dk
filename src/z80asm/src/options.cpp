//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../config.h"
#include "cpp/scan2.h"
#include "cpp/zfloat.h"
#include "errors.h"
#include "file_reader.h"
#include "if.h"
#include "options.h"
#include "strpool.h"
#include "utils.h"
#include "xassert.h"
#include "z80asm_defs.h"
#include <cassert>
#include <climits>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <map>
using namespace std;

extern "C" {
    extern Symbol1* define_static_def_sym(const char* name, long value);
    extern void undefine_static_def_sym(const char* name);
}

Options g_options;

//-----------------------------------------------------------------------------
// version
//-----------------------------------------------------------------------------
#ifndef Z88DK_VERSION
#define Z88DK_VERSION "build " __DATE__
#endif

#define COPYRIGHT		"InterLogic 1993-2009, Paulo Custodio 2011-2025"

#define COPYRIGHT_MSG	"Z80 Macro Assembler " Z88DK_VERSION "\n(c) " COPYRIGHT

void Options::exit_copyright() {
	cout << COPYRIGHT_MSG << endl;
	exit(0);
}

//-----------------------------------------------------------------------------
// help
//-----------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------
// parsing
//-----------------------------------------------------------------------------
void Options::parse_args(const vector<string>& args) {
	if (args.empty())
		exit_copyright();

    // set verbose, if defined in env var
    parse_env_vars();

    // check for -v to activate verbosity before other options are parsed
    for (auto& arg : args) {
        if (unquote(expand_env_vars(arg)) == "-v")
            verbose = true;
    }

    // show command line
    if (verbose) {
        cout << "% " << Z80ASM_PROG;
        for (auto& arg : args) {
            cout << " " << arg;
        }
        cout << endl;
    }

	if (g_errors.count > 0)
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

		if (g_errors.count > 0)
			return;
	}

	post_parsing_actions();
}

void Options::set_swap_ixiy(swap_ixiy_t swap_ixiy) {
    m_swap_ixiy = swap_ixiy;

    undefine_static_symbol("__SWAP_IX_IY__");

    switch (m_swap_ixiy) {
    case IXIY_NO_SWAP:
        break;
    case IXIY_SWAP:
    case IXIY_SOFT_SWAP:
        define_static_symbol("__SWAP_IX_IY__");
        break;
    default:
        xassert(0);
    }
}

string Options::prepend_output_dir(const string& filename) {
	if (output_dir.empty())
		return filename;
	else if (filename.substr(0, output_dir.size() + 1) == output_dir + "/") {
		// #2260: may be called with an object file already with the path prepended; do not add it twice
		return filename;
	}
	else {
		// NOTE: concatenation (/) of a relative fs::path and an
		// absolute fs::path discards the first one! Do our magic
		// with strings instead.
		// is it a win32 absolute path?
		string file;
		if (filename.size() >= 2 &&
		    isalpha(filename[0]) && filename[1] == ':') {	// C:
			file += output_dir + "/";
			file += string(1, filename[0]) + "/";
			file += string(filename.substr(2));
		}
		else {
			file += output_dir + "/";
			file += filename;
		}
		fs::path path{ file };
		return path.lexically_normal().generic_string();
	}
}

static string replace_ext(const string& filename, const string& ext) {
	fs::path file_path{ filename };
	file_path.replace_extension(ext);
	return file_path.generic_string();
}

string Options::get_consol_obj_file() const {
    if (output_dir.empty())
        return m_consol_obj_file;
    else {
        fs::path file_path{ output_dir };
        file_path /= fs::path{ m_consol_obj_file };
        return file_path.generic_string();
    }
}

string Options::asm_filename(const string& filename) {
	return replace_ext(filename, EXT_ASM);
}

string Options::lis_filename(const string& filename) {
	return prepend_output_dir(replace_ext(filename, EXT_LIS));
}

string Options::o_filename(const string& filename) {
	return prepend_output_dir(replace_ext(filename, EXT_O));
}

string Options::def_filename(const string& filename) {
	return prepend_output_dir(replace_ext(filename, EXT_DEF));
}

// see https://github.com/z88dk/z88dk/issues/2049
// No fix, to avoid breaking too many things:
// -oFILE generates single binary FILE
// -oFILE.EXT generates single binary file FILE.EXT
// section outputs are always FILE_CODE.bin
string Options::bin_filename(const string& filename, const string& section) {
	fs::path file_path, file_ext;

	if (bin_file.empty()) {
		file_path = filename;
		file_ext = EXT_BIN;
	}
	else {
		// output file may have no extension
		file_path = bin_file;
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

string Options::lib_filename(const string& filename) {
    fs::path file_path{ filename };
    if (file_path.extension() != "")    // # 2606 allow different lib extensions
        return filename;
    else
        return replace_ext(filename, EXT_LIB);
}

string Options::sym_filename(const string& filename) {
	return prepend_output_dir(replace_ext(filename, EXT_SYM));
}

string Options::map_filename(const string& filename) {
	return prepend_output_dir(replace_ext(filename, EXT_MAP));
}

// argument is binary file, already has the output_dir prepended
string Options::reloc_filename(const string& bin_filename) {
	return replace_ext(bin_filename, EXT_RELOC);
}

// Issue #2476: on msys2 a path "/d/xxx" must be changed to "d:/xxx"
string Options::norm_filename(const string& filename) {
    string cur_path = fs::current_path().generic_string();
    if (cur_path.size() > 2 && isalpha(cur_path[0]) && cur_path[1] == ':' &&
        filename.size() > 3 && filename[0] == '/' && isalpha(filename[1]) && filename[2] == '/')
        return string(1, filename[1]) + ":" + filename.substr(2);
    else
        return filename;
}

void Options::parse_option(const string& arg) {
	string opt_arg;

    if (arg == "-vv") {
        debug_z80asm = true;
        verbose = true;
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

	g_errors.error(ErrIllegalOption, arg);
}

// return false if cannot parse integer
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
		g_errors.error(ErrIllegalIdent, ident);
	else {
		if (equal_pos == string::npos) {
            define_static_symbol(ident.c_str(), 1);
		}
		else {
			int value = 0;
			if (parse_opt_int(value, opt_arg.substr(equal_pos + 1))) 
				define_static_symbol(ident.c_str(), value);
			else
				g_errors.error(ErrInvalidDefineOption, opt_arg);
		}
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

void Options::set_float_format(const string& format) {
	if (!g_float_format.set_text(format)) {
        g_errors.error(ErrIllegalFloatFormat, format);
        g_errors.error(ErrFloatFormatsList, FloatFormat::get_all_formats());
	}		
}

void Options::set_float_option(const string& format) {
	if (!g_float_format.set_text(format)) {
        g_errors.error(ErrIllegalFloatOption, format);
        g_errors.error(ErrFloatFormatsList, FloatFormat::get_all_formats());
	}		
}

void Options::set_origin(const string& opt_arg) {
	int value = 0;
	if (!parse_opt_int(value, opt_arg) || value < 0)	// value can be >0xffff for banked address
		g_errors.error(ErrInvalidOrgOption, opt_arg);
	else
		set_origin_option(value);
}

bool Options::collect_opt_arg(const string& opt_name, const string& arg,
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

void Options::parse_file(const string& arg_) {
    string arg = str_strip(unquote(arg_));
    if (arg.empty())
        return;

    if (arg[0] == '@')
		expand_list_glob(str_strip(arg.substr(1)));
	else
		expand_source_glob(arg);
}

// get list of files from pattern
void Options::expand_source_glob(const string& pattern_) {
    string result_filename;
    string pattern = norm_filename(pattern_);           // #2476
    size_t wc_pos = pattern.find_first_of("*?");
    if (wc_pos == string::npos) {
        if (search_source(pattern, result_filename))
            input_files.push_back(norm_filename(result_filename));
    }
	else {
		vector<fs::path> files;
		expand_glob(files, pattern);
		
        bool found = false;
		for (auto& file : files) {
            if (fs::is_regular_file(file)) {
                if (search_source(file.generic_string(), result_filename))
                    input_files.push_back(norm_filename(result_filename));
                found = true;
            }
		}

        if (!found)
            g_errors.error(ErrGlobNoFiles, pattern);
    }
}

// get list of files from pattern
void Options::expand_list_glob(const string& pattern_) {
    string pattern = norm_filename(pattern_);           // #2476
	vector<fs::path> files;
	size_t wc_pos = pattern.find_first_of("*?");
	if (wc_pos == string::npos) {
        pattern = search_include_path(pattern);
        if (fs::is_regular_file(fs::path(pattern)))
			files.push_back(fs::path(pattern));		// only one file
		else
			g_errors.error(ErrFileNotFound, pattern);
	}
	else {
		expand_glob(files, pattern);			// list of files
        if (files.empty())
			g_errors.error(ErrGlobNoFiles, pattern);
	}

	for (auto& file : files) {
		if (fs::is_regular_file(file)) {
			// append the directoy of the list file to the include path	and remove it at the end
			g_options.include_path.push_back(file.parent_path().generic_string());
			{
				if (g_file_reader.open(file.generic_string())) {
					string line;
					while (g_file_reader.getline(line)) {
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
			g_options.include_path.pop_back();
		}
	}
}

// search for the first file in path, with the given extension,
// with .asm extension and with .o extension
// if not found, output error and return false
// run m4 if file is .asm.m4
bool Options::search_source(const string& filename, string& out_filename) {
    if (str_ends_with(filename, EXT_M4)) {                                     		// file.asm.m4
        string m4_full_path = search_include_path(filename);
        string asm_filename = m4_full_path.substr(0, m4_full_path.size() - strlen(EXT_M4));	// file.asm
        string m4_cmd = "m4 " + m4_options + " \"" + m4_full_path + "\" > \"" + asm_filename + "\"";
        if (verbose)
            cout << "% " << m4_cmd << endl;
        if (0 != system(m4_cmd.c_str())) {
			g_errors.error(ErrCmdFailed, m4_cmd);
            perror("m4");
            return false;
        }
        else
            return search_source(asm_filename, out_filename);
    }
    else {
        // check plain filename
        if (check_source(filename, out_filename))
            return true;

        // check plain file in include path
        string found_file = search_include_path(filename);
        if (found_file != filename && check_source(found_file, out_filename))
            return true;

        // check filename with .asm extension
        string asm_file = filename + EXT_ASM;
        if (check_source(asm_file, out_filename))
            return true;

        // check filename with .asm extension in include path
        found_file = search_include_path(asm_file);
        if (found_file != asm_file && check_source(found_file, out_filename))
            return true;

        // check filename with .o extension
        string o_file = filename + EXT_O;
        if (check_source(o_file, out_filename))
            return true;

        // check filename with .o extension in include path
        found_file = search_include_path(o_file);
        if (found_file != o_file && check_source(found_file, out_filename))
            return true;

        // check object file in the output directory
        o_file = o_filename(filename);
        if (check_source(o_file, out_filename))
            return true;

        // check filename with .o extension in include path
        found_file = search_include_path(o_file);
        if (found_file != o_file && check_source(found_file, out_filename))
            return true;

        // not found, avoid cascade of errors
        if (!g_errors.count)
            g_errors.error(ErrFileNotFound, filename);

        return false;
    }
}

bool Options::check_source(const string& filename, string& out_filename) {
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
        if (!date_stamp) {
            // no -d
            if (got_obj) {
                out_filename = obj_file.generic_string();
                if (!lib_for_all_cpus)
                    check_object_file(obj_file.generic_string().c_str());
            }
            else
                out_filename = src_file.generic_string();
            return true;
        }
        else if (fs::last_write_time(obj_file) >= fs::last_write_time(src_file)) {
            // -d and .o is up-to-date
            out_filename = obj_file.generic_string();
            if (!lib_for_all_cpus)
                check_object_file(obj_file.generic_string().c_str());
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
        if (!lib_for_all_cpus)
            check_object_file(obj_file.generic_string().c_str());
        return true;
    }
    else {
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

//-----------------------------------------------------------------------------
// file path manipulation
//-----------------------------------------------------------------------------
void Options::push_path(vector<string>& path, const string& dir) {
	path.push_back(dir);
}

void Options::pop_path(vector<string>& path) {
	path.pop_back();
}

string Options::search_path(vector<string>& path, const string& file) {
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

void Options::set_cpu(int cpu) {
    undefine_static_symbol("__CPU_Z80__");
    undefine_static_symbol("__CPU_Z80_STRICT__");
    undefine_static_symbol("__CPU_Z80N__");
    undefine_static_symbol("__CPU_Z80N_STRICT__");
    undefine_static_symbol("__CPU_Z180__");
    undefine_static_symbol("__CPU_Z180_STRICT__");
    undefine_static_symbol("__CPU_EZ80__");
    undefine_static_symbol("__CPU_EZ80_STRICT__");
    undefine_static_symbol("__CPU_EZ80_Z80__");
    undefine_static_symbol("__CPU_EZ80_Z80_STRICT__");
    undefine_static_symbol("__CPU_ZILOG__");

    undefine_static_symbol("__CPU_R800__");
    undefine_static_symbol("__CPU_R800_STRICT__");

    undefine_static_symbol("__CPU_R2KA__");
    undefine_static_symbol("__CPU_R2KA_STRICT__");
    undefine_static_symbol("__CPU_R3K__");
    undefine_static_symbol("__CPU_R3K_STRICT__");
    undefine_static_symbol("__CPU_R4K__");
    undefine_static_symbol("__CPU_R4K_STRICT__");
    undefine_static_symbol("__CPU_R5K__");
    undefine_static_symbol("__CPU_R5K_STRICT__");
    undefine_static_symbol("__CPU_R6K__");
    undefine_static_symbol("__CPU_R6K_STRICT__");
    undefine_static_symbol("__CPU_RABBIT__");

    undefine_static_symbol("__CPU_8080__");
    undefine_static_symbol("__CPU_8085__");
    undefine_static_symbol("__CPU_8080_STRICT__");
    undefine_static_symbol("__CPU_8085_STRICT__");
    undefine_static_symbol("__CPU_INTEL__");

    undefine_static_symbol("__CPU_GBZ80__");
    undefine_static_symbol("__CPU_GBZ80_STRICT__");

    undefine_static_symbol("__CPU_KC160__");
    undefine_static_symbol("__CPU_KC160_STRICT__");
    undefine_static_symbol("__CPU_KC160_Z80__");
    undefine_static_symbol("__CPU_KC160_Z80_STRICT__");

    switch (cpu) {
    case CPU_Z80:
        m_cpu = CPU_Z80;
        define_static_symbol("__CPU_Z80__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z80_STRICT:
        m_cpu = CPU_Z80_STRICT;
        define_static_symbol("__CPU_Z80_STRICT__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z80N:
        m_cpu = CPU_Z80N;
        define_static_symbol("__CPU_Z80N__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z80N_STRICT:
        m_cpu = CPU_Z80N_STRICT;
        define_static_symbol("__CPU_Z80N_STRICT__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z180:
        m_cpu = CPU_Z180;
        define_static_symbol("__CPU_Z180__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_Z180_STRICT:
        m_cpu = CPU_Z180_STRICT;
        define_static_symbol("__CPU_Z180_STRICT__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80:
        m_cpu = CPU_EZ80;
        define_static_symbol("__CPU_EZ80__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80_STRICT:
        m_cpu = CPU_EZ80_STRICT;
        define_static_symbol("__CPU_EZ80_STRICT__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80_Z80:
        m_cpu = CPU_EZ80_Z80;
        define_static_symbol("__CPU_EZ80_Z80__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_EZ80_Z80_STRICT:
        m_cpu = CPU_EZ80_Z80_STRICT;
        define_static_symbol("__CPU_EZ80_Z80_STRICT__");
        define_static_symbol("__CPU_ZILOG__");
        break;
    case CPU_R800:
        m_cpu = CPU_R800;
        define_static_symbol("__CPU_R800__");
        break;
    case CPU_R800_STRICT:
        m_cpu = CPU_R800_STRICT;
        define_static_symbol("__CPU_R800_STRICT__");
        break;
    case CPU_R2KA:
        m_cpu = CPU_R2KA;
        define_static_symbol("__CPU_R2KA__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R2KA_STRICT:
        m_cpu = CPU_R2KA_STRICT;
        define_static_symbol("__CPU_R2KA_STRICT__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R3K:
        m_cpu = CPU_R3K;
        define_static_symbol("__CPU_R3K__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R3K_STRICT:
        m_cpu = CPU_R3K_STRICT;
        define_static_symbol("__CPU_R3K_STRICT__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R4K:
        m_cpu = CPU_R4K;
        define_static_symbol("__CPU_R4K__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R4K_STRICT:
        m_cpu = CPU_R4K_STRICT;
        define_static_symbol("__CPU_R4K_STRICT__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R5K:
        m_cpu = CPU_R5K;
        define_static_symbol("__CPU_R5K__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R5K_STRICT:
        m_cpu = CPU_R5K_STRICT;
        define_static_symbol("__CPU_R5K_STRICT__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R6K:
        m_cpu = CPU_R6K;
        define_static_symbol("__CPU_R6K__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_R6K_STRICT:
        m_cpu = CPU_R6K_STRICT;
        define_static_symbol("__CPU_R6K_STRICT__");
        define_static_symbol("__CPU_RABBIT__");
        break;
    case CPU_8080:
        m_cpu = CPU_8080;
        define_static_symbol("__CPU_8080__");
        define_static_symbol("__CPU_INTEL__");
        break;
    case CPU_8080_STRICT:
        m_cpu = CPU_8080_STRICT;
        define_static_symbol("__CPU_8080_STRICT__");
        define_static_symbol("__CPU_INTEL__");
        break;
    case CPU_8085:
        m_cpu = CPU_8085;
        define_static_symbol("__CPU_8085__");
        define_static_symbol("__CPU_INTEL__");
        break;
    case CPU_8085_STRICT:
        m_cpu = CPU_8085_STRICT;
        define_static_symbol("__CPU_8085_STRICT__");
        define_static_symbol("__CPU_INTEL__");
        break;
    case CPU_GBZ80:
        m_cpu = CPU_GBZ80;
        define_static_symbol("__CPU_GBZ80__");
        break;
    case CPU_GBZ80_STRICT:
        m_cpu = CPU_GBZ80_STRICT;
        define_static_symbol("__CPU_GBZ80_STRICT__");
        break;
    case CPU_KC160:
        m_cpu = CPU_KC160;
        define_static_symbol("__CPU_KC160__");
        break;
    case CPU_KC160_STRICT:
        m_cpu = CPU_KC160_STRICT;
        define_static_symbol("__CPU_KC160_STRICT__");
        break;
    case CPU_KC160_Z80:
        m_cpu = CPU_KC160_Z80;
        define_static_symbol("__CPU_KC160_Z80__");
        break;
    case CPU_KC160_Z80_STRICT:
        m_cpu = CPU_KC160_Z80_STRICT;
        define_static_symbol("__CPU_KC160_Z80_STRICT__");
        break;
    default:
        xassert(0);
    }
}

void Options::set_cpu(const string& name) {
    m_got_cpu_option = true;

    if (name == "*") {
        set_cpu(CPU_Z80);
        lib_for_all_cpus = true;
    }
    else if (name == ARCH_TI83_NAME) {
        set_cpu(CPU_Z80_STRICT);
        m_ti83 = true;
        m_ti83plus = false;
    }
    else if (name == ARCH_TI83PLUS_NAME) {
        set_cpu(CPU_Z80_STRICT);
        m_ti83 = false;
        m_ti83plus = true;
    }
    else {
        int id = cpu_id(name.c_str());
        if (id != CPU_UNDEF)
            set_cpu(id);
        else {
            g_errors.error(ErrIllegalCpuOption, name);
            g_errors.error(ErrCpusList, cpu_list());
		}
	}
}

void Options::set_filler(const string& opt_arg) {
	int value = 0;
	if (!parse_opt_int(value, opt_arg) || value < 0 || value > 0xFF)
		g_errors.error(ErrInvalidFillerOption, opt_arg);
	else
		filler = value;
}

void Options::post_parsing_actions() {
	set_consol_obj_options();

    // check if -d and -m* were given
    if (date_stamp && lib_for_all_cpus) {
        g_errors.error(ErrDateAndMstarIncompatible);
    }

	// check if we have any file to process
    if (input_files.empty()) {
		g_errors.error(ErrNoSrcFile);
    }

	// make output directory if needed
    if (!output_dir.empty()) {
		fs::create_directories(fs::path(output_dir));
    }

	define_assembly_defines();
	include_z80asm_lib();
}

// parse environment variable options
void Options::parse_env_vars() {
	const char* options = getenv(Z80ASM_ENVVAR);
    if (options) {
        if (string(options).find("-v") != string::npos) {
            verbose = true;
            cout << Z80ASM_ENVVAR << "=" << options << endl;
        }
		parse_args_in_text(options);
    }
}

// make consolidated object
void Options::set_consol_obj_options() {
	if (!make_bin && !bin_file.empty()) {
		m_consol_obj_file = bin_file;
		bin_file.clear();
	}
}

// z80asm standard library
// search in current dir, then in exe path, then in exe path/../lib, then in ZCCCFG/..
// Ignore if not found, probably benign - user will see undefined symbols
// __z80asm__xxx if the library routines are called
void Options::include_z80asm_lib() {
	string library = search_z80asm_lib();
	if (!library.empty())
		library_file_append(library.c_str());
}

string Options::search_z80asm_lib() {
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

	// TODO: this should not rely on g_options
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

// build z80asm_lib filename: z88dk-z80asm.lib
string Options::z80asm_lib_filename() {
	string filename;
	filename = Z80ASM_LIB_BASE;
	filename += EXT_LIB;
	return filename;
}

bool Options::check_library(const fs::path& file_path) {
	if (fs::is_regular_file(file_path))
		return true;
	else {
		if (verbose)
			cout << "Library '" << file_path.generic_string()
			<< "' not found" << endl;
		return false;
	}
}

void Options::define_assembly_defines() {
    if (!m_got_cpu_option)
        set_cpu(CPU_Z80);

    set_swap_ixiy(m_swap_ixiy);

	if (m_ti83) {
		define_static_symbol("__CPU_TI83__");
        undefine_static_symbol("__CPU_TI83PLUS__");
	}
	else if (m_ti83plus) {
        undefine_static_symbol("__CPU_TI83__");
        define_static_symbol("__CPU_TI83PLUS__");
	}

	// __FLOAT__xxx__
	define_static_symbol(get_float_format_define());
}

void Options::define_static_symbol(const string& name, int value) {
    define_static_def_sym(name.c_str(), value);
    define_local_def_sym(name.c_str(), value);
}

void Options::undefine_static_symbol(const string& name) {
    undefine_static_def_sym(name.c_str());
    undefine_local_def_sym(name.c_str());
}

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------
bool option_verbose() {
	return g_options.verbose;
}

swap_ixiy_t option_swap_ixiy() {
	return g_options.get_swap_ixiy();
}

void option_set_swap_ixiy(swap_ixiy_t swap_ixiy) {
    g_options.set_swap_ixiy(swap_ixiy);
}

void push_includes(const char* dir) {
	g_options.include_path.push_back(dir);
}

void pop_includes() {
	g_options.include_path.pop_back();
}

const char* search_includes(const char* filename) {
	string searched_file = g_options.search_include_path(filename);
	return spool_add(searched_file.c_str());
}

cpu_t option_cpu() {
	return g_options.get_cpu();
}

bool option_no_synth() {
    return g_options.get_no_synth();
}

void option_set_cpu(int cpu) {
    g_options.set_cpu(cpu);
}

bool option_ti83() {
	return g_options.get_ti83();
}

bool option_ti83plus() {
	return g_options.get_ti83plus();
}

bool option_speed() {
	return g_options.opt_speed;
}

bool option_debug() {
	return g_options.debug;
}

const char* search_libraries(const char* filename) {
	string searched_file = g_options.search_library_path(filename);
	return spool_add(searched_file.c_str());
}

const char* option_lib_file() {
	string filename = g_options.lib_file;
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

bool option_lib_for_all_cpus() {
    return !g_options.lib_file.empty() && g_options.lib_for_all_cpus;
}

const char* option_bin_file() {
	string filename = g_options.bin_file;
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

bool option_make_bin() {
	return g_options.make_bin;
}

bool option_split_bin() {
	return g_options.split_bin;
}

bool option_relocatable() {
	return g_options.relocatable;
}

bool option_reloc_info() {
	return g_options.reloc_info;
}

int option_filler() {
	return g_options.filler;
}

bool option_symtable() {
	return g_options.symtable;
}

bool option_list_file() {
	return g_options.list_file;
}

bool option_map_file() {
	return g_options.map_file;
}

bool option_global_def() {
	return g_options.global_def;
}

bool option_is_consol_obj_file() {
	return g_options.is_consol_obj_file();
}

const char* option_consol_obj_file_name() {
	string filename = g_options.get_consol_obj_file();
	if (filename.empty())
		return nullptr;
	else
		return spool_add(filename.c_str());
}

int option_appmake() {
	return g_options.appmake;
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
	return spool_add(g_options.asm_filename(filename).c_str());
}

const char* get_lis_filename(const char* filename) {
	return spool_add(g_options.lis_filename(filename).c_str());
}

const char* get_o_filename(const char* filename) {
	return spool_add(g_options.o_filename(filename).c_str());
}

const char* get_def_filename(const char* filename) {
	return spool_add(g_options.def_filename(filename).c_str());
}

const char* get_bin_filename(const char* filename, const char* section) {
	return spool_add(g_options.bin_filename(filename, section).c_str());
}

const char* get_lib_filename(const char* filename) {
	return spool_add(g_options.lib_filename(filename).c_str());
}

const char* get_sym_filename(const char* filename) {
	return spool_add(g_options.sym_filename(filename).c_str());
}

const char* get_map_filename(const char* filename) {
	return spool_add(g_options.map_filename(filename).c_str());
}

const char* get_reloc_filename(const char* bin_filename) {
	return spool_add(g_options.reloc_filename(bin_filename).c_str());
}

size_t option_files_size() {
	return g_options.input_files.size();
}

const char* option_file(size_t n) {
	return spool_add(g_options.input_files.at(n).c_str());
}

bool option_debug_z80asm() {
    return g_options.debug_z80asm;
}
