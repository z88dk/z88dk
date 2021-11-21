//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// // Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "preproc.h"
#include "utils.h"

list<SourceFile>	g_source_files;

bool SourceFile::open(const string& filename, bool search_include_path) {
	// search file in path
	string found_filename;
	if (search_include_path)
		found_filename = search_includes(filename.c_str());
	else
		found_filename = filename;

	// check for recursive includes
	if (recursive_include(found_filename)) {
		error_include_recursion(filename.c_str());
		return false;
	}

	// open file
	m_filename = found_filename;
	m_ifs.open(m_filename, ios::binary);
	if (!m_ifs.is_open()) {
		error_read_file(m_filename.c_str());
		return false;
	}
	else
		return true;
}

void SourceFile::set_line_num(int line_num, int line_inc) {
	m_line_num = line_num;
	m_line_inc = line_inc;
}

const char* SourceFile::getline() {
	while (true) {
		if (!m_out_lines.empty()) {
			m_line = m_out_lines.front();
			m_out_lines.pop_front();
			return m_line.c_str();
		}
		else if (get_input_line())
			parse_line();
		else
			return nullptr;
	}
}

const char* SourceFile::get_input_line() {
	while (true) {
		if (!m_in_lines.empty()) {
			m_line = m_in_lines.front();
			m_in_lines.pop_front();
			return m_line.c_str();
		}
		else {
			if (!m_ifs.is_open() || m_ifs.eof())
				return nullptr;

			safe_getline(m_ifs, m_line);
			m_line += "\n";				// parser expects a newline after line
			m_line_num += m_line_inc;
			got_source_line(m_filename.c_str(), m_line_num, m_line.c_str());
			split_line();				// split on '\\'
		}
	}
}

void SourceFile::split_line() {
	m_in_lines.push_back(m_line);
}

bool SourceFile::recursive_include(const string& filename) {
	for (auto& elem : g_source_files) {
		if (elem.m_filename == filename)
			return true;
	}
	return false;
}

void SourceFile::do_include(const string& filename) {
	g_source_files.emplace_back();
	g_source_files.back().open(filename, true);
}

void sfile_hold_input() {
	g_source_files.emplace_back();
	g_source_files.back().set_hold(true);		// true - getline does not pop()
}

bool sfile_open(const char* filename, bool search_include_path) {
	g_source_files.emplace_back();
	return g_source_files.back().open(filename, search_include_path);
}

const char* sfile_getline() {
	while (!g_source_files.empty()) {
		const char* line = g_source_files.back().getline();
		if (line)
			return line;
		else if (g_source_files.back().hold())
			return nullptr;
		else
			g_source_files.pop_back();
	}
	return nullptr;
}

const char* sfile_filename() {
	if (g_source_files.empty())
		return nullptr;
	for (auto it = g_source_files.rbegin(); it != g_source_files.rend(); it++) {
		if (!it->filename().empty())
			return it->filename().c_str();
	}
	return nullptr;
}

int sfile_line_num() {
	if (g_source_files.empty())
		return 0;
	for (auto it = g_source_files.rbegin(); it != g_source_files.rend(); it++) {
		if (!it->filename().empty())
			return it->line_num();
	}
	return 0;
}

bool sfile_is_c_source() {
	if (g_source_files.empty())
		return false;
	for (auto it = g_source_files.rbegin(); it != g_source_files.rend(); it++) {
		if (!it->filename().empty())
			return it->is_c_source();
	}
	return false;
}

void sfile_set_filename(const char* filename) {
	if (!g_source_files.empty())
		g_source_files.back().set_filename(filename);
}

void sfile_set_line_num(int line_num, int line_inc) {
	if (!g_source_files.empty())
		g_source_files.back().set_line_num(line_num - line_inc, line_inc);
}

void sfile_set_c_source(bool f) {
	if (!g_source_files.empty())
		g_source_files.back().set_c_source(f);
}

void sfile_unhold_input() {
	if (!g_source_files.empty())
		g_source_files.pop_back();
}


#if 0
Location g_location;


void preproc_open(const char* filename) { (void)filename; }
void preproc_close() {}
const char* preproc_getline() { return nullptr; }
#endif

