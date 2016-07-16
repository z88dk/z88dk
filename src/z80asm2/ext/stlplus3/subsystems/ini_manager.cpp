////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "ini_manager.hpp"
#include "file_system.hpp"
#include <fstream>
#include <list>
#include <algorithm>
#include <sys/stat.h>
#include <ctype.h>
////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // local utilities

  static std::string trim(const std::string& val)
  {
    std::string result = val;
    while (!result.empty() && isspace(result[0]))
      result.erase(result.begin());
    while (!result.empty() && isspace(result[result.size()-1]))
      result.erase(result.end()-1);
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // internal data structure for storing a single entry (i.e. line) from an ini file
  // lines are categorised as blanks, comments or variables
  // TODO - do I need an error category?
  ////////////////////////////////////////////////////////////////////////////////

  class ini_entry
  {
  public:
    enum kind_t {BLANK, COMMENT, VARIABLE};
    friend std::string to_string(kind_t kind)
      {
        switch(kind)
        {
        case BLANK: return "BLANK";
        case COMMENT: return "COMMENT";
        case VARIABLE: return "VARIABLE";
        }
        return "<*unknown kind*>";
      }

  private:
    unsigned m_line;
    kind_t m_kind;
    std::string m_text;
    std::string m_name;
    std::string m_value;

  public:
    ini_entry(unsigned line) : m_line(line), m_kind(BLANK) {}
    ini_entry(unsigned line, const std::string& comment) : m_line(line), m_kind(COMMENT), m_text("; " + comment) {}
    ini_entry(unsigned line, const std::string& name, const std::string& value) : m_line(line), m_kind(VARIABLE), m_text(name + " = " + value), m_name(name), m_value(value) {}
    ~ini_entry(void) {}

    unsigned line(void) const {return m_line;}
    kind_t kind(void) const {return m_kind;}
    bool blank(void) const {return m_kind == BLANK;}
    bool comment(void) const {return m_kind == COMMENT;}
    bool variable(void) const {return m_kind == VARIABLE;}

    const std::string& text(void) const {return m_text;}
    const std::string& variable_name(void) const {return m_name;}
    const std::string& variable_value(void) const {return m_value;}

    bool print(std::ostream& str) const
      {
        str << "    " << m_line << ":" << to_string(m_kind) << ": " << m_text << std::endl;
        return !str.fail();
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // internal data structure representing an ini file section containing all the
  // entries for that section from a single ini file
  ////////////////////////////////////////////////////////////////////////////////

  class ini_section
  {
  private:
    friend class ini_file;
    std::string m_title;
    std::list<ini_entry> m_entries;

  public:
    ini_section(const std::string& title) : 
      m_title(title)
      {
      }

    ~ini_section(void)
      {
      }

    const std::string& title(void) const
      {
        return m_title;
      }

    bool empty(void) const
      {
        // a section is empty if it contains no variables
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable())
            return false;
        }
        return true;
      }

    void clear(void)
      {
        m_entries.clear();
      }

    bool variable_exists(const std::string variable) const
      {
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable() && i->variable_name() == variable)
            return true;
        }
        return false;
      }

    unsigned variables_size(void) const
      {
        unsigned result = 0;
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
          if (i->variable())
            result++;
        return result;
      }

    std::string variable_name(unsigned offset) const
      {
        unsigned j = 0;
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable())
          {
            if (j == offset)
              return i->variable_name();
            j++;
          }
        }
        return std::string();
      }

    std::vector<std::string> variable_names(void) const
      {
        std::vector<std::string> result;
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
          if (i->variable())
            result.push_back(i->variable_name());
        return result;
      }

    std::string variable_value(unsigned offset) const
      {
        unsigned j = 0;
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable())
          {
            if (j == offset)
              return i->variable_value();
            j++;
          }
        }
        return std::string();
      }

    std::string variable_value(const std::string variable) const
      {
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable() && i->variable_name() == variable)
            return i->variable_value();
        }
        return std::string();
      }

    unsigned variable_line(const std::string variable) const
      {
        for (std::list<ini_entry>::const_iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable() && i->variable_name() == variable)
            return i->line();
        }
        return 0;
      }

    bool add_variable(unsigned line, const std::string& variable, const std::string& value)
      {
        erase_variable(variable);
        m_entries.push_back(ini_entry(line ? line : static_cast<unsigned>(m_entries.size()), variable, value));
        return true;
      }

    bool add_comment(unsigned line, const std::string& comment)
      {
        m_entries.push_back(ini_entry(line ? line : static_cast<unsigned>(m_entries.size()), comment));
        return true;
      }

    bool add_blank(unsigned line)
      {
        m_entries.push_back(ini_entry(line ? line : static_cast<unsigned>(m_entries.size())));
        return true;
      }

    bool erase_variable(const std::string& variable)
      {
        for (std::list<ini_entry>::iterator i = m_entries.begin(); i != m_entries.end(); i++)
        {
          if (i->variable() && i->variable_name() == variable)
          {
            m_entries.erase(i);
            return true;
          }
        }
        return false;
      }

    bool print(std::ostream& str) const
      {
        str << "  [" << m_title << "]" << std::endl;
        for (std::list<ini_entry>::const_iterator entry = m_entries.begin(); entry != m_entries.end(); entry++)
          entry->print(str);
        return !str.fail();
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // internal data structure representing a single ini file
  ////////////////////////////////////////////////////////////////////////////////

  class ini_file
  {
  private:
    friend class ini_section;
    std::string m_filename;
    bool m_changed;
    bool m_writable;
    std::list<ini_section> m_sections;

    std::list<ini_section>::const_iterator find_section(const std::string& section) const
      {
        for (std::list<ini_section>::const_iterator i = m_sections.begin(); i != m_sections.end(); i++)
        {
          if (i->title() == section)
            return i;
        }
        return m_sections.end();
      }

    std::list<ini_section>::iterator find_section(const std::string& section)
      {
        for (std::list<ini_section>::iterator i = m_sections.begin(); i != m_sections.end(); i++)
        {
          if (i->title() == section)
            return i;
        }
        return m_sections.end();
      }

  public:

    ini_file(void) : m_changed(false), m_writable(false)
      {
      }

    ini_file(const std::string& filename) : m_changed(false), m_writable(false)
      {
        read_file(filename);
      }

    ~ini_file(void)
      {
        if (writable())
          save_file();
      }

    bool initialised(void) const
      {
        return !m_filename.empty();
      }

    bool writable(void) const
      {
        return m_writable;
      }

    bool read_file(const std::string& filename)
      {
        m_filename = filename;
        m_changed = false;
        // file may not yet exist - possible to create an Ini file using this class
        // so it is writable if the file exists and is writable or if the folder is writable
        m_writable = file_writable(m_filename);
        if (!file_exists(m_filename))
          return true;
        // create a dummy top section to hold file comments
        std::list<ini_section>::iterator section = m_sections.insert(m_sections.end(), ini_section(""));
        std::ifstream source(m_filename.c_str());
        unsigned line_number = 0;
        std::string line;
        while(std::getline(source,line))
        {
          line_number++;
          unsigned i = 0;
          while(i < line.size() && isspace(line[i]))
            i++;
          if (i < line.size() && line[i] == '[')
          {
            // found a section title
            // skip the [
            i++;
            // get the text up to the end ] or the end of the line
            std::string title;
            while (i < line.size() && line[i] != ']')
              title += line[i++];
            // create a new section and make it the current section
            section = m_sections.insert(m_sections.end(), ini_section(title));
          }
          else if (i < line.size() && line[i] == ';')
          {
            // found a comment
            // skip the ; because that is not part of the comment
            i++;
            // add the rest of the line as a comment to the current section
            section->add_comment(line_number, line.substr(i, line.size()-1));
          }
          else if (i == line.size())
          {
            // found a blank line
            section->add_blank(line_number);
          }
          else
          {
            // found a *possible* variable - now scan forwards for the = operator
            std::string name;
            while (i < line.size() && line[i] != '=')
              name += line[i++];
            // skip the = sign
            // TODO - detect a missing = sign here and convert to an error
            if (i < line.size())
              i++;
            // trim trailing whitespace off the name
            name = trim(name);
            // now get the value, minus any leading whitespace
            std::string value;
            while(i < line.size() && isspace(line[i]))
              i++;
            while (i < line.size())
              value += line[i++];
            // trim trailing whitespace off the value
            value = trim(value);
            // and finally add the name/value pair to the data structure
            section->add_variable(line_number, name, value);
          }
        }
        return true;
      }

    bool save_file(void)
      {
        if (!initialised()) return false;
        if (!m_changed) return true;
        if (!m_writable) return false;
        std::ofstream output(m_filename.c_str());
        for (std::list<ini_section>::iterator section = m_sections.begin(); section != m_sections.end(); section++)
        {
          if (!(section->title().empty()))
            output << "[" << section->title() << "]" << std::endl;
          for (std::list<ini_entry>::iterator entry = section->m_entries.begin(); entry != section->m_entries.end(); entry++)
            output << entry->text() << std::endl;
        }
        m_changed = false;
        return true;
      }

    std::string filename(void) const
      {
        return m_filename;
      }

    bool empty(void) const
      {
        // file is empty if it has either no sections or an empty header section
        if (m_sections.empty()) return true;
        if ((m_sections.begin() == --m_sections.end()) && m_sections.begin()->empty()) return true;
        return false;
      }

    bool section_exists(const std::string& title) const
      {
        return find_section(title) != m_sections.end();
      }

    bool add_section(const std::string& section)
      {
        if (!m_writable) return false;
        m_sections.push_back(ini_section(section));
        m_changed = true;
        return true;
      }

    bool empty_section(const std::string& section)
      {
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) return false;
        return found->empty();
      }

    bool erase_section(const std::string& section)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) return false;
        m_sections.erase(found);
        m_changed = true;
        return true;
      }

    bool clear_section(const std::string& section)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) return false;
        found->clear();
        m_changed = true;
        return true;
      }

    unsigned sections_size(void) const
      {
        return static_cast<unsigned>(m_sections.size());
      }

    const std::string& section_name(unsigned i) const
      {
        std::list<ini_section>::const_iterator result = m_sections.begin();
        for (unsigned j = 1; j <= i; j++)
          result++;
        return result->title();
      }

    std::vector<std::string> section_names(void) const
      {
        std::vector<std::string> result;
        for (unsigned j = 0; j < sections_size(); j++)
          result.push_back(section_name(j));
        return result;
      }

    bool variable_exists(const std::string& section, const std::string variable) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return false;
        return found->variable_exists(variable);
      }

    std::vector<std::string> variable_names(const std::string& section) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return std::vector<std::string>();
        return found->variable_names();
      }

    unsigned variables_size(const std::string& section) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return 0;
        return found->variables_size();
      }

    unsigned variable_line(const std::string& section, const std::string variable) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return 0;
        return found->variable_line(variable);
      }

    std::string variable_name(const std::string& section, unsigned i) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return std::string();
        return found->variable_name(i);
      }

    std::string variable_value(const std::string& section, unsigned i) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return std::string();
        return found->variable_value(i);
      }

    std::string variable_value(const std::string& section, const std::string variable) const
      {
        std::list<ini_section>::const_iterator found = find_section(section);
        if (found == m_sections.end()) return std::string();
        return found->variable_value(variable);
      }

    bool add_variable(const std::string& section, const std::string& variable, const std::string& value)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) found = m_sections.insert(m_sections.end(),ini_section(section));
        if (found->add_variable(0,variable,value))
          m_changed = true;
        return true;
      }

    bool add_comment(const std::string& section, const std::string& comment)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) found = m_sections.insert(m_sections.end(),ini_section(section));
        if (found->add_comment(0,comment))
          m_changed = true;
        return true;
      }

    bool add_blank(const std::string& section)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) found = m_sections.insert(m_sections.end(),ini_section(section));
        if (found->add_blank(0))
          m_changed = true;
        return true;
      }

    bool erase_variable(const std::string& section, const std::string& variable)
      {
        if (!m_writable) return false;
        std::list<ini_section>::iterator found = find_section(section);
        if (found == m_sections.end()) return false;
        if (found->erase_variable(variable))
        {
          m_changed = true;
          return true;
        }
        return false;
      }

    bool print(std::ostream& str) const
      {
        str << "file: " << m_filename << std::endl;
        for (std::list<ini_section>::const_iterator section = m_sections.begin(); section != m_sections.end(); section++)
          section->print(str);
        return !str.fail();
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // body data structure contains all the data and is pointed-to by exported data structure

  class ini_manager_body
  {
  private:
    std::vector<ini_file> m_files;
    unsigned m_count;

    ini_manager_body(const ini_manager_body&);
    ini_manager_body& operator= (const ini_manager_body&);

  public:

    ini_manager_body(void) : m_count(1)
      {
      }

    ~ini_manager_body(void)
      {
        save();
      }

    void increment(void)
      {
        ++m_count;
      }

    bool decrement(void)
      {
        --m_count;
        return m_count == 0;
      }

    //////////////////////////////////////////////////////////////////////////////
    // file management

    // add files starting with the most local file (e.g. the current project) which has depth 0
    // and working back to the most global (e.g. the installation settings) which has a depth of size()-1
    // This does nothing if the file has already been loaded - it is not permitted to manage the same file twice.
    // Returns true if the file loaded okay or was already loaded (it is counted as successful if the file did
    // not exist, only read errors cause a failure)
    bool add_file(const std::string& filename)
      {
        // if this file has been loaded, don't load it again
        // this is not an error
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (filespec_to_path(filename) == filespec_to_path(m_files[i].filename()))
            return true;
        }
        // add a new file to the back of the list and then load it
        // I do it in two steps rather than passing the filename to the constructor in order to return the load status
        m_files.push_back(ini_file());
        return m_files.back().read_file(filename);
      }

    // as above, returns false if *none* of the files were added
    // filenames[0] is the local file, and so on
    bool add_files(const std::vector<std::string>& filenames)
      {
        bool result = true;
        for (unsigned i = 0; i < filenames.size(); i++)
          result &= add_file(filenames[i]);
        return result;
      }

    // saves modified ini files - returns true if all modified files were written successfully
    bool save(void)
      {
        bool result = true;
        for (unsigned i = 0; i < size(); i++)
          result &= m_files[i].save_file();
        return result;
      }

    // get the number of files being managed
    unsigned size(void) const
      {
        return static_cast<unsigned>(m_files.size());
      }

    // get the ini filename associated with a depth
    std::string filename(unsigned depth) const
      {
        return m_files[depth].filename();
      }

    // test whether a file in the ini manager is writable
    bool writable(unsigned depth) const
      {
        return m_files[depth].writable();
      }

    // test whether a file is empty
    // An ini file is considered empty if it has no named sections and the header is empty or missing
    bool empty(unsigned depth) const
      {
        return m_files[depth].empty();
      }

    // erase the ini file from the ini manager and from the disk
    bool erase(unsigned depth)
      {
        std::string file = filename(depth);
        remove(depth);
        return file_delete(file);
      }

    // remove the file from the ini manager but do not erase it from the disk
    bool remove(unsigned depth)
      {
        if (m_files[depth].writable())
          m_files[depth].save_file();
        m_files.erase(m_files.begin() + depth);
        return true;
      }

    //////////////////////////////////////////////////////////////////////////////
    // section management

    // returns the union of all section names in all of the ini files
    std::vector<std::string> section_names(void) const
      {
        std::vector<std::string> result;
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          std::vector<std::string> file_result = section_names(i);
          for (unsigned j = 0; j < file_result.size(); j++)
          {
            if (std::find(result.begin(), result.end(), file_result[j]) == result.end())
              result.push_back(file_result[j]);
          }
        }
        return result;
      }

    // returns the section names in one of the ini files
    std::vector<std::string> section_names(unsigned depth) const
      {
        return m_files[depth].section_names();
      }

    // tests whether a section is found in any of the ini files
    bool section_exists(const std::string& title) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (m_files[i].section_exists(title))
            return true;
        }
        return false;
      }

    // tests whether the section is found in the specific ini file
    bool section_exists(const std::string& title, unsigned depth) const
      {
        return m_files[depth].section_exists(title);
      }

    // adds a section to the specified ini file - does nothing if it is already present
    bool add_section(const std::string& section, unsigned depth)
      {
        return m_files[depth].add_section(section);
      }

    // test whether a section is empty
    bool empty_section(const std::string& section, unsigned depth)
      {
        return m_files[depth].empty_section(section);
      }

    // removes a section from the specified ini file if it exists there but cannot remove it from any other file
    bool erase_section(const std::string& section, unsigned depth)
      {
        return m_files[depth].erase_section(section);
      }

    // removes all the contents of a section from the specified ini file but keeps the empty section
    bool clear_section(const std::string& section, unsigned depth)
      {
        return m_files[depth].clear_section(section);
      }

    //////////////////////////////////////////////////////////////////////////////
    // variable management

    // test whether a variable exists in any of the ini files
    bool variable_exists(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return true;
        }
        return false;
      }

    // test whether a variable exists in specified ini file
    bool variable_exists(const std::string& section, const std::string variable, unsigned depth) const
      {
        return m_files[depth].variable_exists(section, variable);
      }

    // get the union of all variables declared in all ini files
    std::vector<std::string> variable_names(const std::string& section) const
      {
        std::vector<std::string> result;
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          std::vector<std::string> file_result = variable_names(section, i);
          for (unsigned j = 0; j < file_result.size(); j++)
          {
            if (std::find(result.begin(), result.end(), file_result[j]) == result.end())
              result.push_back(file_result[j]);
          }
        }
        return result;
      }

    // get the set of all varaibale names from one file
    std::vector<std::string> variable_names(const std::string& section, unsigned depth) const
      {
        return m_files[depth].variable_names(section);
      }

    // get the depth of the first ini file to define a variable
    // returns 0 if defined in the local ini file, etc. Returns (unsigned)-1 if the variable doesn't exist
    unsigned variable_depth(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return i;
        }
        return (unsigned)-1;
      }

    // get the filename that first defines the variable
    std::string variable_filename(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return filename(i);
        }
        return std::string();
      }

    unsigned variable_linenumber(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return m_files[i].variable_line(section,variable);
        }
        return 0;
      }

    // get the value of a variable as a single unprocessed string
    // if the variable does not exist the string will be empty, but beware that
    // you also get an empty string if a variable exists but has no value
    // you can differentiate between the two cases by using variable_exists_all above
    std::string variable_value(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return variable_value(section, variable, i);
        }
        return std::string();
      }

    // get the value from the specified file
    std::string variable_value(const std::string& section, const std::string variable, unsigned depth) const
      {
        return m_files[depth].variable_value(section, variable);
      }

    // get the value of a variable as a processed string
    // processing splits the value at commas and furthermore supports quoted
    // strings (so that values can contain commas for example)
    // quoted strings are dequoted before they are added to the result
    // the result is a vector of dequoted strings, one per value in the comma-separated list
    std::vector<std::string> variable_values(const std::string& section, const std::string variable) const
      {
        for (unsigned i = 0; i < m_files.size(); i++)
        {
          if (variable_exists(section, variable, i))
            return variable_values(section, variable, i);
        }
        return std::vector<std::string>();
      }

    // get the processed variable from the specified file
    std::vector<std::string> variable_values(const std::string& section, const std::string variable, unsigned depth) const
      {
        // get the unprocessed value and then do the processing into processed separate values
        std::string value = variable_value(section, variable, depth);
        std::vector<std::string> result;
        if (!value.empty())
        {
          result.push_back(std::string());
          unsigned i = 0;
          // loop which is repeated for each element in the comma-separated list
          while(i < value.size())
          {
            // skip leading whitespace
            while (i < value.size() && isspace(value[i])) i++;
            // get the value - this means all text up to the next comma or end of line
            // also allow escaped characters
            while (i < value.size())
            {
              if (value[i] == ',') break;
              if (value[i] == '\\')
              {
                // found an escaped character - de-escape it by only getting the next character
                // beware of an escape character at the end of the line which just gets ignored
                i++;
                if (i < value.size()) result.back() += value[i++];
              }
              else if (value[i] == '"')
              {
                // get a quoted substring
                // first skip the opening quote
                i++;
                // keep getting characters until a close-quote, but allow the quote character to be escaped by itself
                while (i < value.size())
                {
                  if (value[i] == '"')
                  {
                    // found a quote skip it
                    i++;
                    // now establish whether its an escaped quote
                    // if it is, keep it, but de-escape it by only getting the next character
                    // it it isn't, break out and continue processing the value as a non-quoted string
                    if (i < value.size() && value[i] != '"') break;
                    if (i < value.size()) result.back() += value[i++];
                  }
                  else
                  {
                    // non-quote and non-escape so just get the character
                    result.back() += value[i++];
                  }
                }
              }
              else
              {
                // non-escape so just get the character
                result.back() += value[i++];
              }
            }
            // trim trailing whitespace off the value
            while (!result.back().empty() && isspace(result.back()[result.back().size()-1])) result.back().erase(result.back().size()-1,1);
            // now check for whether there is a comma or end of line
            if (i <= value.size() && value[i] == ',')
            {
              // skip the comma and add a new string to the result ready for the next iteration
              i++;
              result.push_back(std::string());
            }
            else
            {
              // end of line found so break out
              break;
            }
          }
        }
        return result;
      }

    // add a variable to the specified file
    bool add_variable(const std::string& section, const std::string& variable, const std::string& value, unsigned depth)
      {
        return m_files[depth].add_variable(section, variable, value);
      }

    // add a variable as a processed string
    // processing means that the values in the string vector are converted into a comma-separated list
    // values containing reserved characters are automatically quoted - so you should not even try to quote them yourself
    bool add_variable(const std::string& section, const std::string& variable, const std::vector<std::string>& values, unsigned depth)
      {
        // convert the values vector into a comma-separated string with each value escaped so that special characters do not confuse the reader
        // the characters escaped are: '\', ',', '"'
        std::string value;
        for (unsigned v = 0; v < values.size(); v++)
        {
          const std::string& element = values[v];
          // add the comma between values === add a comma before all but the first value
          if (v > 0) value += ',';
          for (unsigned i = 0; i < element.size(); i++)
          {
            // add a character at a time, escaping special characters
            if (element[i] == '"' || element[i] == ',' || element[i] == '\\')
            {
              // escape the character
              value += '\\';
            }
            value += element[i];
          }
        }
        return add_variable(section, variable, value, depth);
      }

    // erase a variable from the specified file
    // this does not remove the variable from other ini files, so the variable may still exist
    // to mask a global variable, set the variable to an empty string instead
    bool erase_variable(const std::string& section, const std::string& variable, unsigned depth)
      {
        return m_files[depth].erase_variable(section, variable);
      }

    //////////////////////////////////////////////////////////////////////////////
    // sundry line-entry management

    // add a comment to the specified ini file
    bool add_comment(const std::string& section, const std::string& comment, unsigned depth)
      {
        return m_files[depth].add_comment(section, comment);
      }

    // add a blank line to the specified ini file
    bool add_blank(const std::string& section, unsigned depth)
      {
        return m_files[depth].add_blank(section);
      }

    bool print(std::ostream& str) const
      {
        str << "----------------------------------------" << std::endl;
        for (unsigned depth = 0; depth < m_files.size(); depth++)
        {
          m_files[depth].print(str);
          str << "----------------------------------------" << std::endl;
        }
        return !str.fail();
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // exported data structure representing the set of all ini files and providing
  // the access functions exported by the class
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // constructors/destructors

  ini_manager::ini_manager(void) : m_body(new ini_manager_body)
  {
  }

  ini_manager::ini_manager(const std::vector<std::string>& filenames) : m_body(new ini_manager_body)
  {
    add_files(filenames);
  }

  ini_manager::ini_manager(const ini_manager& manager) : m_body(0)
  {
    m_body = manager.m_body;
    m_body->increment();
  }

  ini_manager& ini_manager::operator= (const ini_manager& manager)
  {
    if (m_body == manager.m_body) return *this;
    if (m_body->decrement())
      delete m_body;
    m_body = manager.m_body;
    m_body->increment();
    return *this;
  }

  ini_manager::~ini_manager(void)
  {
    if (m_body->decrement())
      delete m_body;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // file management

  bool ini_manager::add_file(const std::string& filename)
  {
    return m_body->add_file(filename);
  }

  bool ini_manager::add_files(const std::vector<std::string>& filenames)
  {
    return m_body->add_files(filenames);
  }

  bool ini_manager::save(void)
  {
    return m_body->save();
  }

  unsigned ini_manager::size(void) const
  {
    return m_body->size();
  }

  std::string ini_manager::filename(unsigned depth) const
  {
    return m_body->filename(depth);
  }

  bool ini_manager::writable(unsigned depth) const
  {
    return m_body->writable(depth);
  }

  bool ini_manager::empty(unsigned depth) const
  {
    return m_body->empty(depth);
  }

  bool ini_manager::erase(unsigned depth)
  {
    return m_body->erase(depth);
  }

  bool ini_manager::remove(unsigned depth)
  {
    return m_body->remove(depth);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // section management

  std::vector<std::string> ini_manager::section_names(void) const
  {
    return m_body->section_names();
  }

  std::vector<std::string> ini_manager::section_names(unsigned depth) const
  {
    return m_body->section_names(depth);
  }

  bool ini_manager::section_exists(const std::string& section) const
  {
    return m_body->section_exists(section);
  }

  bool ini_manager::section_exists(const std::string& section, unsigned depth) const
  {
    return m_body->section_exists(section, depth);
  }

  bool ini_manager::add_section(const std::string& section, unsigned depth)
  {
    return m_body->add_section(section, depth);  
  }

  bool ini_manager::empty_section(const std::string& section, unsigned depth)
  {
    return m_body->empty_section(section, depth);  
  }

  bool ini_manager::erase_section(const std::string& section, unsigned depth)
  {
    return m_body->erase_section(section, depth);  
  }

  bool ini_manager::clear_section(const std::string& section, unsigned depth)
  {
    return m_body->clear_section(section, depth);  
  }

  ////////////////////////////////////////////////////////////////////////////////
  // variable management

  bool ini_manager::variable_exists(const std::string& section, const std::string variable) const
  {
    return m_body->variable_exists(section, variable);  
  }

  bool ini_manager::variable_exists(const std::string& section, const std::string variable, unsigned depth) const
  {
    return m_body->variable_exists(section, variable, depth);  
  }

  std::vector<std::string> ini_manager::variable_names(const std::string& section) const
  {
    return m_body->variable_names(section);  
  }

  std::vector<std::string> ini_manager::variable_names(const std::string& section, unsigned depth) const
  {
    return m_body->variable_names(section, depth);  
  }

  unsigned ini_manager::variable_depth(const std::string& section, const std::string variable) const
  {
    return m_body->variable_depth(section, variable);  
  }

  std::string ini_manager::variable_filename(const std::string& section, const std::string variable) const
  {
    return m_body->variable_filename(section, variable);  
  }

  unsigned ini_manager::variable_linenumber(const std::string& section, const std::string variable) const
  {
    return m_body->variable_linenumber(section, variable);  
  }

  std::string ini_manager::variable_value(const std::string& section, const std::string variable) const
  {
    return m_body->variable_value(section, variable);  
  }

  std::string ini_manager::variable_value(const std::string& section, const std::string variable, unsigned depth) const
  {
    return m_body->variable_value(section, variable, depth);  
  }

  std::vector<std::string> ini_manager::variable_values(const std::string& section, const std::string variable) const
  {
    return m_body->variable_values(section, variable);  
  }

  std::vector<std::string> ini_manager::variable_values(const std::string& section, const std::string variable, unsigned depth) const
  {
    return m_body->variable_values(section, variable, depth);  
  }

  bool ini_manager::add_variable(const std::string& section, const std::string& variable, const std::string& value, unsigned depth)
  {
    return m_body->add_variable(section, variable, value, depth);
  }

  bool ini_manager::add_variable(const std::string& section, const std::string& variable, const std::vector<std::string>& values, unsigned depth)
  {
    return m_body->add_variable(section, variable, values, depth);
  }

  bool ini_manager::erase_variable(const std::string& section, const std::string& variable, unsigned depth)
  {
    return m_body->erase_variable(section, variable, depth);
  }


  ////////////////////////////////////////////////////////////////////////////////
  // sundry entries

  bool ini_manager::add_comment(const std::string& section, const std::string& comment, unsigned depth)
  {
    return m_body->add_comment(section, comment, depth);
  }

  bool ini_manager::add_blank(const std::string& section, unsigned depth)
  {
    return m_body->add_blank(section, depth);
  }

  bool ini_manager::print(std::ostream& str) const
  {
    return m_body->print(str);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // diagnostic print

  std::ostream& operator << (std::ostream& str, const ini_manager& manager)
  {
    manager.print(str);
    return str;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
