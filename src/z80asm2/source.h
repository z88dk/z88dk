//-----------------------------------------------------------------------------
// z80asm - input
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <vector>
#include <memory>
#include <string>
#include <fstream>

class SourceFile;

// input source line
struct SourceLine
{
	SourceLine(SourceFile *source_, unsigned line_nr_, std::string text_)
		: source(source_), line_nr(line_nr_), text(text_) {}

	SourceFile	*source;
	unsigned	 line_nr;
	std::string	 text;		// "" if keep_lines = false
};

// input file
class SourceFile 
{
public:
	SourceFile(const std::string& filename, bool keep_lines = false);		// keep previous lines?
	virtual ~SourceFile();

	const std::string& filename() const { return m_filename; }
	unsigned line_nr() const { return m_line_nr; }
	bool good() const { return m_ifs.good(); }

	// read new line, allocate internal SourceLine, return pointer to it; return NULL on end of file
	SourceLine *getline();

private:
	std::string		m_filename;
	unsigned		m_line_nr;
	std::ifstream	m_ifs;
	bool			m_keep_lines;						// if false(default), only last line is preserved
	std::vector<SourceLine *> m_lines;					// owns pointers to SourceLine
};

// stack of input files to read includes
class SourceStack
{
public:
	SourceStack(bool keep_lines = false);				// keep previous lines?
	virtual ~SourceStack();

	bool has_file(const std::string& filename);			// is the given file in the open stack?
	bool open(const std::string& filename);				// open a new file to read at this point

	SourceLine *getline();								// call getline from the top-of-stack, pop it when eof

private:
	bool			m_keep_lines;						// if false(default), only last line is preserved
	std::vector<SourceLine *> m_lines;					// points into SourceFile's SourceLines
	std::vector<SourceFile *> m_files;					// all files opened, owns the pointers
	std::vector<SourceFile *> m_stack;					// current input stack, weak pointers
};
