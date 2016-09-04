//-----------------------------------------------------------------------------
// z80asm - data model for intemediate code
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#include "source.h"
#include "util.h"

SourceFile::SourceFile(const std::string& filename, bool keep_lines)
	: m_filename(filename)
	, m_line_nr(0)
	, m_ifs(filename.c_str(), std::ios::in | std::ios::binary)
	, m_keep_lines(keep_lines)
{
}

SourceFile::~SourceFile()
{
	for (std::vector<SourceLine *>::iterator it = m_lines.begin(); it != m_lines.end(); ++it)
		delete *it;
	m_lines.clear();
}

SourceLine *SourceFile::getline()
{
	std::string text;

	if (safeGetline(m_ifs, text).good()) {
		m_line_nr++;

		// delete previous lines, unless m_keep_lines
		if (m_lines.size() > 0 && !m_keep_lines) {
			m_lines.back()->text.clear();
		}

		// allocate a new SourceLine and append to vector
		m_lines.push_back(new SourceLine(this, m_line_nr, text));

		return m_lines.back();
	}
	else {
		return NULL;
	}
}

SourceStack::SourceStack(bool keep_lines)
	: m_keep_lines(keep_lines)
{
}

SourceStack::~SourceStack()
{
	m_lines.clear();		// m_lines has weak pointers
	m_stack.clear();		// m_stack has weak pointers

	for (std::vector<SourceFile *>::iterator it = m_files.begin(); it != m_files.end(); ++it)
		delete *it;
	m_files.clear();
}

bool SourceStack::has_file(const std::string& filename) 
{
	for (std::vector<SourceFile *>::iterator it = m_files.begin(); it != m_files.end(); ++it)
		if ((*it)->filename() == filename)
			return true;
	return false;
}

bool SourceStack::open(const std::string& filename)
{
	SourceFile *file = new SourceFile(filename, m_keep_lines);
	if (file->good()) {
		m_files.push_back(file);
		m_stack.push_back(file);
		return true;
	}
	else {
		delete file;
		return false;
	}
}

SourceLine *SourceStack::getline()
{
	while (m_stack.size() > 0) {
		SourceLine *line = m_stack.back()->getline();
		if (line != NULL) {
			m_lines.push_back(line);
			return line;
		}
		else {							// end of this source
			m_stack.pop_back();			// weak pointer, no delete
		}
	}
	return NULL;
}
