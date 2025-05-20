//-----------------------------------------------------------------------------
// z80asm
// list files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "preproc.h"
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class LstFile {
public:
	void open(const string& filename);
	void close();
	void source_line(Location location, const string& section, int asmpc, int phased_pc, const string& text);
	void expanded_line(const string& section, int asmpc, int phased_pc, const string& text);
	void append_bytes(const vector<uint8_t>& bytes);
	void patch_bytes(const string& section, int asmpc, const vector<uint8_t>& bytes);
	void end_line();
	void set_list_on(bool f = true) { m_list_on = f; }
	bool list_is_on() const { return m_list_on; }

private:
	ofstream	m_ofs;				// output file handle
	bool		m_line_started;		// output has started
	Location	m_location;			// output file name and line number
    string      m_section;          // current section
	int			m_asmpc;			// address of patch bytes
	int			m_phased_pc;		// address output to list file
	vector<uint8_t> m_bytes;		// bytes collected in this line
	string		m_text;				// line text
	string		m_last_filename;	// last filename output
	bool		m_list_on{ false };

    unordered_map<string, streampos> m_patch_pos;	// file position of a m_asmpc 
    string patch_pos_key(const string& section, int addr);

	void out_filename();
	void out_line();
	void out_bytes(int row);
	int num_rows();
};

extern LstFile g_list_file;
