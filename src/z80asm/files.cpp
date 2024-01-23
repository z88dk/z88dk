//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "files.h"
#include "z80asm.h"

FileReader g_file_reader;
FileLister g_file_lister;

//-----------------------------------------------------------------------------

bool FileReader::open(const string& filename_) {
    // canonize path
    string filename = fs::path(filename_).generic_string();

    // search file in path
    string found_filename = g_args.search_include_path(filename.c_str());

    // check for recursive includes
    if (check_recursion(found_filename)) {
        g_errors.error(Errors::Code::include_recursion, filename);
        return false;
    }

    // open file
    OpenFile of{ found_filename };

    // show error at current location
    if (!of.ifs.is_open()) {
        g_errors.os_error(Errors::Code::file_open, found_filename);
        return false;
    }

    // push to stack
    m_open_files.push_back(std::move(of));
    g_errors.location = m_open_files.back().location;
    g_errors.clear_lines();

    xassert(is_open());
    return true;
}

bool FileReader::is_open() const {
    if (m_open_files.empty())
        return false;
    else
        return m_open_files.back().ifs.is_open();
}

bool FileReader::getline(string& line) {
    line.clear();

    if (!m_pushed_back_lines.empty()) {
        line = m_pushed_back_lines.back();
        m_pushed_back_lines.pop_back();

        // notify
        Location& location = get_location();
        g_errors.location = location;
        g_errors.expanded_line = str_chomp(line);

        g_file_lister.notify_expanded_line(location, line);

        m_is_pushed_back = true;
        return true;
    }
    else {
        while (!m_open_files.empty()) {
            // get '\\' continuation lines
            string this_line;
            if (!safe_getline(m_open_files.back().ifs, this_line).eof()) {
                // line read ok
                get_location().inc_line_num();
                line = this_line;

                while (!line.empty() && line.back() == '\\') {
                    line.pop_back();
                    line.push_back(' ');

                    if (!safe_getline(m_open_files.back().ifs, this_line).eof())
                        get_location().inc_line_num();
                    else
                        line.pop_back();        // remove space

                    line += this_line;
                }

                // notify
                Location& location = get_location();
                g_errors.location = location;
                g_errors.source_line = str_chomp(line);
                g_errors.expanded_line.clear();

                g_file_lister.notify_source_line(location, line);

                m_is_pushed_back = false;
                return true;
            } 
            else {
                // eof
                m_open_files.pop_back();

                // notify
                Location& location = get_location();
                g_errors.location = location;
                g_errors.clear_lines();

                continue;
            }
        }
        m_is_pushed_back = false;
        return false;
    }
}

void FileReader::push_back(const string& line) {
    m_pushed_back_lines.push_back(line);
}

Location& FileReader::get_location() {
    static Location empty_location;
    if (m_open_files.empty())
        return empty_location;
    else
        return m_open_files.back().location;
}

bool FileReader::check_recursion(const string& filename) const {
    for (auto& open_file : m_open_files)
        if (open_file.location.filename == filename)
            return true;

    return false;
}

//-----------------------------------------------------------------------------

bool FileLister::open(const string& filename) {
    close();
    m_ofs.open(filename);
    return m_ofs.is_open();
}

void FileLister::close() {
    if (m_ofs.is_open())
        m_ofs.close();
}

void FileLister::notify_source_line(const Location& /*location*/, const string& /*line*/) {
    /*
    if (m_ofs.is_open())
        ; // TODO
    */
}

void FileLister::notify_expanded_line(const Location& /*location*/, const string& /*line*/) {
    /*
    if (m_ofs.is_open())
        ; // TODO
    */
}
