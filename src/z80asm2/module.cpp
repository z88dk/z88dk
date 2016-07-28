//-----------------------------------------------------------------------------
// Store one compiled module
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "module.hpp"
#include "messages.hpp"
#include "file_system.hpp"
#include "global.hpp"
#include "util.hpp"
#include "parser.hpp"

Module::Module(const std::string& filename)
	: m_folder(stlplus::folder_part(filename))
	, m_basename(stlplus::basename_part(filename))
	, m_filebase(stlplus::create_filespec(m_folder, m_basename, ""))
	, m_asm_filename(stlplus::create_filespec(m_folder, m_basename, g_args.asm_extension))
	, m_obj_filename(stlplus::create_filespec(m_folder, m_basename, g_args.obj_extension)) {}

bool Module::parse()
{
	if (!stlplus::file_readable(m_asm_filename)) {
		g_errors.error(ERR_READ_FILE, m_asm_filename);
		return false;
	}
	return parse_include(m_asm_filename);
}

bool Module::recursive_include(const std::string& filename)
{
	for (unsigned i = 0; i < m_files_stack.size(); i++) {
		unsigned file_id = m_files_stack[i];
		if (m_files[file_id] == filename)
			return true;
	}
	return false;
}

bool Module::parse_read_file(unsigned file_id)
{
	const std::string& filename(m_files[file_id]);

	if (g_args.is_verbose)
		g_messages.information(MES_PARSING_FILE, filename);

	std::ifstream file(filename.c_str());
	if (!file.good()) {
		g_errors.error(ERR_READ_FILE, filename);
		return false;
	}
	else {
		bool ret = true;
		std::string line;
		unsigned line_nr = 0;
		while (safeGetline(file, line)) {
			line_nr++;
			if (!parse_line(*this, file_id, line_nr, line.c_str()))
				ret = false;
		}

		return ret;
	}
}

bool Module::parse_include(std::string filename)
{
	// check for recursive includes
	filename = file_lookup(filename, g_args.inc_path);
	if (recursive_include(filename)) {
		g_errors.error(ERR_RECURSIVE_INCLUDE, filename);
		return false;
	}

	// update index
	unsigned file_id = m_files.size();
	m_files.push_back(filename);
	m_files_stack.push_back(file_id);

	bool ret = parse_read_file(file_id);

	m_files_stack.pop_back();

	return ret;
}
