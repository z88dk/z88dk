//-----------------------------------------------------------------------------
// z80asm
// Stack of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "input_files.h"
#include "location.h"
#include "utils.h"
#include <cassert>
using namespace std;

InputFiles* g_input_files{ nullptr };

InputFiles::~InputFiles() {
    while (!m_files.empty())
        pop_file();
}

void InputFiles::push_file(const string& filename) {
    File* file = new File;
    file->filename = filename;
    if (already_included(filename)) {
        g_error->error_recursive_include(filename);
    }
    else {
        file->ifs.open(sanitize_pathname(filename), ios::binary);
        if (!file->ifs.is_open())
            g_error->error_open_file(filename);
        else
            g_location->set_filename(filename);
    }
    m_files.push_back(file);
}

void InputFiles::pop_file() {
    assert(!m_files.empty());
    File* file = m_files.back();
    if (file->ifs.is_open())
        file->ifs.close();
    m_files.pop_back();
    delete file;
    if (m_files.empty()) {
        g_location->clear();
    }
    else {
        file = m_files.back();
        g_location->set_filename(file->filename);
        g_location->set_line_num(file->line_num);
    }
}

bool InputFiles::already_included(const string& filename) {
    for (auto& file : m_files)
        if (file->filename == filename)
            return true;
    return false;
}

bool InputFiles::getline(string& line) {
    line.clear();
    while (!m_files.empty()) {
        File* file = m_files.back();
        if (file->ifs.is_open() && read_custom_line(file->ifs, line)) {
            file->line_num += file->line_inc;
            while (!line.empty() && line[line.size() - 1] == '\\') {	// read continuation line
                line[line.size() - 1] = ' ';
                string cont;
                if (file->ifs.is_open() && read_custom_line(file->ifs, cont)) {
                    file->line_num += file->line_inc;
                    line += cont;
                }
            }
            g_location->set_filename(file->filename);
            g_location->set_line_num(file->line_num);
            g_location->set_text(line);
            return true;
        }
        else {
            pop_file();
        }
    }
    return false;
}

