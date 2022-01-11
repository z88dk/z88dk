//-----------------------------------------------------------------------------
// z80asm
// list files
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "lstfile.h"
#include "utils.h"
#include <cassert>
#include <iomanip>
using namespace std;

LstFile g_list_file;

/*-----------------------------------------------------------------------------
List format:
<------><------><------><------>
nnnnnN hhHHHHHH HHhhhhhhhhhhhhhhasm
linenum address bytes           sourceline
//---------------------------------------------------------------------------*/
static const int LineNumWidth = 6;
static const int SeparatorWidth = 1;
static const int AddressWidth = 8;
static const int AddressMinWidth = 6;
static const int BytesWidth = 16;


void LstFile::open(const string& filename) {
	close();
	if (option_list_file()) {			// if -l option
		m_ofs.open(filename);
		if (!m_ofs.is_open())
			error_file_open(filename.c_str());
		else {
			m_patch_pos.clear();
			m_line_started = false;
			m_location.clear();
			m_asmpc = 0;
			m_phased_pc = 0;
			m_bytes.clear();
			m_text.clear();
			m_last_filename.clear();
		}
	}
}

void LstFile::close() {
	if (m_ofs.is_open()) {
		out_line();
		m_ofs.close();
	}
}

void LstFile::source_line(Location location, int asmpc, int phased_pc, const string& text) {
	if (m_ofs.is_open()) {
		out_line();

		m_line_started = true;
		m_location = location;
		m_asmpc = asmpc;
		m_phased_pc = phased_pc;
		m_bytes.clear();
		m_text = text;
	}
}

void LstFile::expanded_line(int asmpc, int phased_pc, const string& text) {
	if (m_ofs.is_open()) {
		out_line();

		m_line_started = true;
		m_location.line_num = 0;
		m_asmpc = asmpc;
		m_phased_pc = phased_pc;
		m_bytes.clear();
		m_text = text;
	}
}

void LstFile::append_bytes(const vector<uint8_t>& bytes) {
	if (m_ofs.is_open()) {
		for (size_t i = 0; i < bytes.size(); i++)
			m_bytes.push_back(bytes[i]);
	}
}

void LstFile::patch_bytes(int asmpc, const vector<uint8_t>& bytes) {
	if (m_ofs.is_open()) {
		out_line();									// output any pending bytes

		for (size_t i = 0; i < bytes.size(); i++) {
			int addr = asmpc + i;
			auto it = m_patch_pos.find(addr);
			assert(it != m_patch_pos.end());		// address must exist

			m_ofs.seekp(it->second);				// seek position and patch in file
			m_ofs << setw(2)
				<< setfill('0')
				<< hex
				<< static_cast<unsigned>(bytes[i])
				<< setfill(' ')
				<< dec;
		}
		m_ofs.seekp(0, ios_base::end);				// go back to end of file
	}
}

void LstFile::end_line() {
	out_line();
}

void LstFile::out_filename() {
	if (m_ofs.is_open()) {
		if (m_location.filename != m_last_filename) {
			m_ofs << m_location.filename << ":" << endl;
			m_last_filename = m_location.filename;
		}
	}
}

void LstFile::out_line() {
	if (m_ofs.is_open() && m_line_started) {
		// output file name
		out_filename();

		// output line number
		if (m_location.line_num > 0)
			m_ofs << setw(LineNumWidth) << m_location.line_num
			<< setw(SeparatorWidth) << "";
		else
			m_ofs << setw(LineNumWidth + SeparatorWidth) << "";

		// output hex address and bytes
		if (m_bytes.empty())
			m_ofs << setw(AddressWidth + SeparatorWidth + BytesWidth) << "";
		else {
			// hex address with up to 8 positions and 6 filled positions
			ostringstream hex_addr_ss;
			hex_addr_ss << setw(AddressMinWidth)
				<< setfill('0')
				<< hex
				<< m_phased_pc
				<< setfill(' ')
				<< dec;

			string hex_addr = hex_addr_ss.str();
			if (hex_addr.length() > AddressWidth)
				hex_addr.erase(0, hex_addr.length() - AddressWidth);

			m_ofs << setw(AddressWidth - hex_addr.length()) << "" << hex_addr
				<< setw(SeparatorWidth) << "";

			// first 8 hex bytes
			out_bytes(0);
		}

		// output asm line
		m_ofs << str_chomp(m_text) << endl;

		// output overflown bytes
		for (int row = 1; row < num_rows(); row++) {
			m_ofs << setw(LineNumWidth + SeparatorWidth + AddressWidth + SeparatorWidth) << "";
			out_bytes(row);
			m_ofs << endl;
		}
	}
	m_line_started = false;
}

void LstFile::out_bytes(int row) {
	int start_addr = m_asmpc + row * BytesWidth / 2;
	int start_idx = row * BytesWidth / 2;
	int end_idx = (row + 1) * BytesWidth / 2;

	for (int i = start_idx; i < end_idx; i++) {
		if (i < static_cast<int>(m_bytes.size())) {
			int addr = start_addr + i - start_idx;
			m_patch_pos[addr] = m_ofs.tellp();
			m_ofs << setw(2)
				<< setfill('0')
				<< hex
				<< static_cast<unsigned>(m_bytes[i])
				<< setfill(' ')
				<< dec;
		}
		else
			m_ofs << "  ";
	}
}

int LstFile::num_rows() {
	return (m_bytes.size() + BytesWidth / 2 - 1) / (BytesWidth / 2);
}

//-----------------------------------------------------------------------------
void list_open(const char* list_file) {
	g_list_file.open(list_file);
}

void list_close() {
	g_list_file.close();
}

void list_source_line(const char* filename, int line_num,
	int asmpc, int phased_pc, const char* text) {
	g_list_file.source_line(Location(filename, line_num), asmpc, phased_pc, text);
}

void list_expanded_line(int asmpc, int phased_pc, const char* text) {
	g_list_file.expanded_line(asmpc, phased_pc, text);
}

void list_append_bytes(int value, int num_bytes) {
	vector<uint8_t> bytes;
	for (int i = 0; i < num_bytes; i++) {
		bytes.push_back(value & 0xff);
		value >>= 8;
	}
	g_list_file.append_bytes(bytes);
}

void list_patch_bytes(int asmpc, int value, int num_bytes) {
	if (asmpc >= 0) {
		vector<uint8_t> bytes;
		for (int i = 0; i < num_bytes; i++) {
			bytes.push_back(value & 0xff);
			value >>= 8;
		}
		g_list_file.patch_bytes(asmpc, bytes);
	}
}

void list_end_line() {
	g_list_file.end_line();
}

// send line to list file
void list_got_source_line(const char* filename, int line_num, const char* text) {
	if (filename && option_cur_list()) {
		list_source_line(filename, line_num,
			get_PC(), get_phased_PC() >= 0 ? get_phased_PC() : get_PC(),
			text);
	}
}

// send line to list file
void list_got_expanded_line(const char* text) {
	if (option_cur_list() && option_verbose()) {
		string line = string("      + ") + text;
		list_expanded_line(
			get_PC(), get_phased_PC() >= 0 ? get_phased_PC() : get_PC(),
			line.c_str());
	}
}
