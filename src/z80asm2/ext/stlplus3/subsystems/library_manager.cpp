////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "library_manager.hpp"
#include "file_system.hpp"
#include <algorithm>
#include <fstream>
#include <ctype.h>

////////////////////////////////////////////////////////////////////////////////

static const char* LibraryNameExtension = "lmn";
static const char* HeaderExtension = "lmh";

////////////////////////////////////////////////////////////////////////////////
// local operations
////////////////////////////////////////////////////////////////////////////////

typedef std::map<std::string,stlplus::lm_callback_entry> lm_callback_map;

static std::string lowercase(const std::string& val)
{
  std::string text = val;
  for (unsigned i = 0; i < text.size(); i++)
    text[i] = tolower(text[i]);
  return text;
}

// Context file and library operations
// These must be readable/writeable without a library data structure present
// so that the name of the library is known before creation

static bool read_context(const std::string& path, const std::string& owner, std::string& name, bool& writable)
{
  std::string spec = stlplus::create_filespec(path, owner, LibraryNameExtension);
  name = "";
  writable = false;
  if (!stlplus::file_exists(spec)) return false;
  std::ifstream input(spec.c_str());
  input >> name >> writable;
  return !input.fail();
}

static bool write_context(const std::string& path, const std::string& owner, const std::string& name, bool writable)
{
  std::string spec = stlplus::create_filespec(path, owner, LibraryNameExtension);
  std::ofstream output(spec.c_str());
  output << name << " " << writable << std::endl;
  return !output.fail();
}

static bool create_library(const std::string& path, const std::string& owner, const std::string& name, bool writable)
{
  std::string spec = stlplus::create_filespec(path, owner, LibraryNameExtension);
  if (stlplus::is_present(path) && !stlplus::is_folder(path)) return false;
  if (!stlplus::folder_exists(path) && !stlplus::folder_create(path)) return false;
  return write_context(path, owner, name, writable);
}

static bool erase_library(const std::string& path, const std::string& owner)
{
  // check that it is a library before deleting it!
  std::string spec = stlplus::create_filespec(path, owner, LibraryNameExtension);
  if (!stlplus::file_exists(spec)) return false;
  return stlplus::folder_delete(path, true);
}

// dependency checking

typedef std::map<std::pair<std::string,stlplus::lm_unit_name>,stlplus::lm_dependencies> visited_map;

static stlplus::lm_dependencies& out_of_date_check (visited_map& visited,
                                                    const stlplus::library_manager* manager,
                                                    const std::string& library,
                                                    const stlplus::lm_unit_name& name)
{
  // the visited field contains an entry if a unit has been visited - it also contains the reason for out-of-date-ness
  // this is initially set empty (up to date) since the unit has to be added
  // before it is checked just in case there is a recursive loop
  // the dependencies field is filled in if the unit is subsequently found to be out of date
  std::pair<std::string,stlplus::lm_unit_name> full_name = std::make_pair(library,name);
  // first check whether this unit has already been visited - this should in
  // principle never happen because the same test is performed before trying
  // to recurse, so consider this to be paranoid-mode programming
  visited_map::iterator found = visited.find(full_name);
  if (found != visited.end())
    return found->second;
  // now add this unit to prevent recursion loops later. This entry is added
  // to when out-of-date dependencies are found and is also the return value
  // of the function
  visited[full_name] = stlplus::lm_dependencies();
  // now find the unit
  const stlplus::lm_unit_ptr unit = manager->find(library,name);
  if (!unit)
  {
    // if a unit is missing it fails with a dependency on itself - this is a
    // bit of a work-around, but this again is paranoid-mode programming since
    // the calling function (this function calling itself recursively) should
    // check the unit's existence before recursing
    visited[full_name].unit_add(stlplus::lm_unit_dependency(library,name));
  }
  else
  {
    // we're onto the real checks now - first get the datestamp of this unit:
    // all dependencies must be older than this
    time_t unit_modified = unit->modified();
    // check dependency on source file if there is one
    if (unit->source_file_present())
    {
      std::string source_file = unit->source_file().path_full(unit->library_path());
      time_t source_modified = stlplus::file_modified(source_file);
      if (source_modified == 0 || source_modified > unit_modified)
      {
        visited[full_name].set_source_file(unit->source_file());
      }
    }
    // now check the other file dependencies
    for (unsigned i = 0; i < unit->file_size(); i++)
    {
      // a file dependency is a dependency on a file outside of the library system
      const stlplus::lm_file_dependency& dependency = unit->file_dependency(i);
      std::string file_full = dependency.path_full(unit->library_path());
      time_t source_modified = stlplus::file_modified(file_full);
      if (source_modified == 0 || source_modified > unit_modified)
      {
        visited[full_name].file_add(dependency);
      }
    }
    // now check and recurse on unit dependencies
    for (unsigned j = 0; j < unit->unit_size(); j++)
    {
      const stlplus::lm_unit_dependency& dependency = unit->unit_dependency(j);
      std::pair<std::string,stlplus::lm_unit_name> other_name = std::make_pair(dependency.library(), dependency.unit_name());
      // perform the datestamp checking at this level and only recurse if this does not detect an error
      const stlplus::lm_unit_ptr other_unit = manager->find(other_name.first, other_name.second);
      if (!other_unit)
      {
        visited[full_name].unit_add(dependency);
      }
      else
      {
        time_t other_modified = other_unit->modified();
        if (other_modified == 0 || other_modified > unit_modified)
        {
          visited[full_name].unit_add(dependency);
        }
        else
        {
          // prevent recursion before doing it
          visited_map::iterator other_found = visited.find(other_name);
          if (other_found != visited.end())
          {
            // if the unit was found to be out of date on the previous visit, add it to the failed dependencies
            if (!other_found->second.empty())
            {
              visited[full_name].unit_add(dependency);
            }
          }
          else
          {
            // the unit hasn't been visited before, so recurse on it now
            stlplus::lm_dependencies other_dependencies = 
              out_of_date_check(visited, manager, other_name.first, other_name.second);
            if (!other_dependencies.empty())
            {
              visited[full_name].unit_add(dependency);
            }
          }
        }
      }
    }
  }
  return visited[full_name];
}

////////////////////////////////////////////////////////////////////////////////
// class lm_unit_name

stlplus::lm_unit_name::lm_unit_name(const std::string& name, const std::string& type) :
  m_name(name), m_type(type)
{
}

stlplus::lm_unit_name::~lm_unit_name(void)
{
}

const std::string& stlplus::lm_unit_name::name(void) const
{
  return m_name;
}

void stlplus::lm_unit_name::set_name(const std::string& name)
{
  m_name = name;
}

void stlplus::lm_unit_name::lowercase(void)
{
  m_name = ::lowercase(m_name);
}

const std::string& stlplus::lm_unit_name::type(void) const
{
  return m_type;
}

void stlplus::lm_unit_name::set_type(const std::string& type)
{
  m_type = type;
}

bool stlplus::lm_unit_name::write(std::ostream& context) const
{
  context << m_name << " " << m_type;
  return !context.fail();
}

bool stlplus::lm_unit_name::read(std::istream& context)
{
  context >> m_name >> m_type;
  return !context.fail();
}

std::string stlplus::lm_unit_name::to_string(void) const
{
  return m_name + ":" + m_type;
}

bool stlplus::lm_unit_name::print(std::ostream& str) const
{
  str << to_string();
  return !str.fail();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_unit_name& name)
{
  name.print(str);
  return str;
}

bool stlplus::operator == (const stlplus::lm_unit_name& l, const stlplus::lm_unit_name& r)
{
  return l.name() == r.name() && l.type() == r.type();
}

bool stlplus::operator < (const stlplus::lm_unit_name& l, const stlplus::lm_unit_name& r)
{
  // sort by name then type
  return (l.name() != r.name()) ? l.name() < r.name() : l.type() < r.type();
}

////////////////////////////////////////////////////////////////////////////////
// dependencies

// file dependencies

stlplus::lm_file_dependency::lm_file_dependency(void) : m_line(0), m_column(0)
{
}

stlplus::lm_file_dependency::lm_file_dependency(const std::string& library_path, const std::string& path, unsigned line, unsigned column)
{
  set_path(library_path, path);
  set_line(line);
  set_column(column);
}

stlplus::lm_file_dependency::~lm_file_dependency(void)
{
}

const std::string& stlplus::lm_file_dependency::path(void) const
{
  return m_path;
}

std::string stlplus::lm_file_dependency::path_full(const std::string& library_path) const
{
  return filespec_to_path(library_path, m_path);
}

void stlplus::lm_file_dependency::set_path(const std::string& library_path, const std::string& path)
{
  m_path = filespec_to_relative_path(library_path, path);
}

unsigned stlplus::lm_file_dependency::line(void) const
{
  return m_line;
}

void stlplus::lm_file_dependency::set_line(unsigned line)
{
  m_line = line;
}

unsigned stlplus::lm_file_dependency::column(void) const
{
  return m_column;
}

void stlplus::lm_file_dependency::set_column(unsigned column)
{
  m_column = column;
}

bool stlplus::lm_file_dependency::write(std::ostream& context) const
{
  context << m_path << " " << m_line << " " << m_column;
  return !context.fail();
}

bool stlplus::lm_file_dependency::read(std::istream& context)
{
  context >> m_path >> m_line >> m_column;
  return !context.fail();
}

bool stlplus::lm_file_dependency::print(std::ostream& str) const
{
  str << "file: " << m_path;
  if (m_line != 0)
    str << ":" << m_line << ":" << m_column;
  return !str.fail();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_file_dependency& dependency)
{
  dependency.print(str);
  return str;
}

// unit dependency

stlplus::lm_unit_dependency::lm_unit_dependency(void)
{
}

stlplus::lm_unit_dependency::lm_unit_dependency(const std::string& library, const lm_unit_name& name) : 
  m_library(library), m_name(name)
{
}

stlplus::lm_unit_dependency::~lm_unit_dependency(void)
{
}

const std::string& stlplus::lm_unit_dependency::library(void) const
{
  return m_library;
}

void stlplus::lm_unit_dependency::set_library(const std::string& library)
{
  m_library = library;
}

const stlplus::lm_unit_name& stlplus::lm_unit_dependency::unit_name(void) const
{
  return m_name;
}

void stlplus::lm_unit_dependency::set_unit_name(const lm_unit_name& unit_name)
{
  m_name = unit_name;
}

const std::string& stlplus::lm_unit_dependency::name(void) const
{
  return m_name.name();
}

void stlplus::lm_unit_dependency::set_name(const std::string& name)
{
  m_name.set_name(name);
}

const std::string& stlplus::lm_unit_dependency::type(void) const
{
  return m_name.type();
}

void stlplus::lm_unit_dependency::set_type(const std::string& type)
{
  m_name.set_type(type);
}

bool stlplus::lm_unit_dependency::write(std::ostream& context) const
{
  context << m_library;
  m_name.write(context);
  return !context.fail();
}

bool stlplus::lm_unit_dependency::read(std::istream& context)
{
  context >> m_library;
  m_name.read(context);;
  return !context.fail();
}

bool stlplus::lm_unit_dependency::print(std::ostream& str) const
{
  str << "unit: " << m_library << "." << m_name;
  return !str.fail();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_unit_dependency& dependency)
{
  dependency.print(str);
  return str;
}

// dependencies

stlplus::lm_dependencies::lm_dependencies(void) : m_source(0)
{
}

stlplus::lm_dependencies::lm_dependencies(const lm_dependencies& r) : m_source(0)
{
  *this = r;
}

stlplus::lm_dependencies& stlplus::lm_dependencies::operator=(const stlplus::lm_dependencies& r)
{
  if (m_source)
    delete m_source;
  m_source = 0;
  if (r.m_source)
    m_source = new lm_file_dependency(*r.m_source);
  m_files = r.m_files;
  m_units = r.m_units;
  return *this;
}

stlplus::lm_dependencies::~lm_dependencies(void)
{
  if (m_source)
    delete m_source;
}

void stlplus::lm_dependencies::set_source_file(const lm_file_dependency& source)
{
  if (m_source)
    delete m_source;
  m_source = new lm_file_dependency(source);
}

bool stlplus::lm_dependencies::source_file_present(void) const
{
  return (m_source != 0);
}

const stlplus::lm_file_dependency& stlplus::lm_dependencies::source_file(void) const
{
  return *m_source;
}

unsigned stlplus::lm_dependencies::file_add(const lm_file_dependency& dependency)
{
  m_files.push_back(dependency);
  return file_size()-1;
}

unsigned stlplus::lm_dependencies::file_size(void) const
{
  return static_cast<unsigned>(m_files.size());
}

const stlplus::lm_file_dependency& stlplus::lm_dependencies::file_dependency(unsigned i) const
{
  return m_files[i];
}

void stlplus::lm_dependencies::file_erase(unsigned i)
{
  m_files.erase(m_files.begin()+i);
}

unsigned stlplus::lm_dependencies::unit_add(const lm_unit_dependency& dependency)
{
  m_units.push_back(dependency);
  return unit_size()-1;
}

unsigned stlplus::lm_dependencies::unit_size(void) const
{
  return static_cast<unsigned>(m_units.size());
}

const stlplus::lm_unit_dependency& stlplus::lm_dependencies::unit_dependency(unsigned i) const
{
  return m_units[i];
}

void stlplus::lm_dependencies::unit_erase(unsigned i)
{
  m_units.erase(m_units.begin()+i);
}

void stlplus::lm_dependencies::clear(void)
{
  if (m_source)
    delete m_source;
  m_source = 0;
  m_files.clear();
  m_units.clear();
}

bool stlplus::lm_dependencies::empty(void) const
{
  return (m_source == 0) && m_files.empty() && m_units.empty();
}

bool stlplus::lm_dependencies::write(std::ostream& context) const
{
  context << (m_source ? true : false) << " ";
  if (m_source) m_source->write(context);
  context << std::endl;
  context << m_files.size() << std::endl;
  for (unsigned i = 0; i < m_files.size(); i++)
  {
    m_files[i].write(context);
    context << std::endl;
  }
  context << m_units.size() << std::endl;
  for (unsigned j = 0; j < m_units.size(); j++)
  {
    m_units[j].write(context);
    context << std::endl;
  }
  return !context.fail();
}

bool stlplus::lm_dependencies::read(std::istream& context)
{
  clear();
  bool source_present = false;
  context >> source_present;
  if (source_present)
  {
    m_source = new lm_file_dependency();
    m_source->read(context);
  }
  unsigned files_size = 0;
  context >> files_size;
  for (unsigned i = 0; i < files_size; i++)
  {
    m_files.push_back(lm_file_dependency());
    m_files.back().read(context);
  }
  unsigned units_size = 0;
  context >> units_size;
  for (unsigned j = 0; j < units_size; j++)
  {
    m_units.push_back(lm_unit_dependency());
    m_units.back().read(context);
  }
  return !context.fail();
}

bool stlplus::lm_dependencies::print(std::ostream& str) const
{
  if (m_source)
    str << "  source file: " << *m_source << std::endl;
  for (unsigned i = 0; i < m_files.size(); i++)
    str << "  " << m_files[i] << std::endl;
  for (unsigned j = 0; j < m_units.size(); j++)
    str << "  " << m_units[j] << std::endl;
  return !str.fail();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_dependencies& dependencies)
{
  dependencies.print(str);
  return str;
}

////////////////////////////////////////////////////////////////////////////////
// lm_unit
////////////////////////////////////////////////////////////////////////////////

stlplus::lm_unit::lm_unit(const lm_unit_name& name, lm_library* library) : 
  m_name(name), m_header_modified(false), m_loaded(false), m_marked(false), m_library(library), m_error(false)
{
  read_header();
}

stlplus::lm_unit::~lm_unit(void)
{
  write_header();
}

////////////////////////////////////////
// Header data

const stlplus::lm_unit_name& stlplus::lm_unit::unit_name(void) const
{
  return m_name;
}

const std::string& stlplus::lm_unit::name(void) const
{
  return m_name.name();
}

const std::string& stlplus::lm_unit::type(void) const
{
  return m_name.type();
}

// dependencies

// source file dependency

void stlplus::lm_unit::set_source_file(const lm_file_dependency& dependency)
{
  m_header_modified = true;
  m_dependencies.set_source_file(dependency);
}

bool stlplus::lm_unit::source_file_present(void) const
{
  return m_dependencies.source_file_present();
}

const stlplus::lm_file_dependency& stlplus::lm_unit::source_file(void) const
{
  return m_dependencies.source_file();
}

// other file dependencies

unsigned stlplus::lm_unit::file_add(const lm_file_dependency& dependency)
{
  m_header_modified = true;
  return m_dependencies.file_add(dependency);
}

unsigned stlplus::lm_unit::file_size(void) const
{
  return m_dependencies.file_size();
}

const stlplus::lm_file_dependency& stlplus::lm_unit::file_dependency(unsigned i) const
{
  return m_dependencies.file_dependency(i);
}

void stlplus::lm_unit::file_erase(unsigned i)
{
  m_header_modified = true;
  m_dependencies.file_erase(i);
}

// unit dependencies

unsigned stlplus::lm_unit::unit_add(const lm_unit_dependency& dependency)
{
  m_header_modified = true;
  return m_dependencies.unit_add(dependency);
}

unsigned stlplus::lm_unit::unit_size(void) const
{
  return m_dependencies.unit_size();
}

const stlplus::lm_unit_dependency& stlplus::lm_unit::unit_dependency(unsigned i) const
{
  return m_dependencies.unit_dependency(i);
}

void stlplus::lm_unit::unit_erase(unsigned i)
{
  m_header_modified = true;
  m_dependencies.unit_erase(i);
}

const stlplus::lm_dependencies& stlplus::lm_unit::dependencies(void) const
{
  return m_dependencies;
}

void stlplus::lm_unit::set_dependencies(const lm_dependencies& dependencies)
{
  m_header_modified = true;
  m_dependencies = dependencies;
}

void stlplus::lm_unit::clear_dependencies(void)
{
  m_header_modified = true;
  m_dependencies.clear();
}

bool stlplus::lm_unit::empty_dependencies(void) const
{
  return m_dependencies.empty();
}

// dependency checking

bool stlplus::lm_unit::out_of_date(void) const
{
  return m_library->out_of_date(m_name);
}

bool stlplus::lm_unit::up_to_date(void) const
{
  return m_library->up_to_date(m_name);
}

stlplus::lm_dependencies stlplus::lm_unit::out_of_date_reason(void) const
{
  return m_library->out_of_date_reason(m_name);
}

// supplementary data

const std::string& stlplus::lm_unit::supplementary_data(void) const
{
  return m_supplement;
}

void stlplus::lm_unit::set_supplementary_data(const std::string& data)
{
  m_supplement = data;
  m_header_modified = true;
}

////////////////////////////////////////
// unit data management

bool stlplus::lm_unit::load(void)
{
  if (out_of_date()) return false;
  if (m_loaded) return true;
  // get the user data for this type
  lm_callback_map::iterator callback = m_library->m_manager->m_callbacks.find(type());
  if (callback == m_library->m_manager->m_callbacks.end()) return false;
  void* data = callback->second.m_type_data;
  bool result = read(filename(), data);
  m_loaded = true;
  return result;
}

bool stlplus::lm_unit::save(void)
{
  if (!m_marked) return true;
  if (!m_loaded) return false;
  // get the user data for this type
  lm_callback_map::iterator callback = m_library->m_manager->m_callbacks.find(type());
  if (callback == m_library->m_manager->m_callbacks.end()) return false;
  void* data = callback->second.m_type_data;
  bool result = write(filename(), data);
  if (result) m_marked = false;
  return result;
}

bool stlplus::lm_unit::loaded(void) const
{
  return m_loaded;
}

void stlplus::lm_unit::mark(void)
{
  m_marked = true;
}

time_t stlplus::lm_unit::modified(void) const
{
  return file_modified(filename());
}

////////////////////////////////////////
// containing library manager details

const stlplus::lm_library* stlplus::lm_unit::library(void) const
{
  return m_library;
}

stlplus::lm_library* stlplus::lm_unit::library(void)
{
  return m_library;
}

const std::string& stlplus::lm_unit::library_name(void) const
{
  return m_library->name();
}

const std::string& stlplus::lm_unit::library_path(void) const
{
  return m_library->path();
}

// error handling - these apply to the last read/write operation

bool stlplus::lm_unit::error(void) const
{
  return m_error;
}

// functions that customise subclasses of this superclass

bool stlplus::lm_unit::read(const std::string& filespec, void* type_data)
{
  std::ifstream input(filespec.c_str());
  bool result = read(input, type_data);
  if (input.fail())
  {
    result = false;
    m_error = true;
  }
  return result;
}

bool stlplus::lm_unit::read(std::istream&, void*)
{
  return false;
}

bool stlplus::lm_unit::write(const std::string& filespec, void* type_data)
{
  std::ofstream output(filespec.c_str());
  bool result = write(output, type_data);
  if (output.fail())
  {
    result = false;
    m_error = true;
  }
  return result;
}

bool stlplus::lm_unit::write(std::ostream&, void*)
{
  return false;
}

bool stlplus::lm_unit::purge(void)
{
  return true;
}

stlplus::lm_unit* stlplus::lm_unit::clone(void) const
{
  return new lm_unit(*this);
}

bool stlplus::lm_unit::print(std::ostream& str) const
{
  str << m_name << " " << (m_loaded ? "loaded" : "") << " " << (m_marked ? "needs saving" : "");
  return !str.fail();
}

bool stlplus::lm_unit::print_long(std::ostream& str) const
{
  str << "header:" << std::endl;
  str << "  name: " << m_name.name() << std::endl;
  str << "  type: " << library()->manager()->description(m_name.type()) << std::endl;
  str << "  dependencies:" << std::endl;
  // Note: I've inlined this rather than call the above-defined print for dependencies
  // This is so that I can use the library manager to look up the descriptions of unit types
  // I can also convert paths so that they are relative to the current directory rather than the library
  // print the source file dependency if present
  if (m_dependencies.source_file_present())
  {
    str << "  source file: ";
    str << filespec_to_relative_path(m_dependencies.source_file().path_full(library()->path()));
    if (m_dependencies.source_file().line() != 0)
      str << ":" << m_dependencies.source_file().line() << ":" << m_dependencies.source_file().column();
    str << std::endl;
  }
  // now print other file dependencies
  // convert these to relative paths too
  for (unsigned f = 0; f < m_dependencies.file_size(); f++)
  {
    str << "  file: ";
    str << filespec_to_relative_path(m_dependencies.file_dependency(f).path_full(library()->path()));
    if (m_dependencies.file_dependency(f).line() != 0)
      str << ":" << m_dependencies.file_dependency(f).line() << ":" << m_dependencies.file_dependency(f).column();
    str << std::endl;
  }
  // now print unit dependencies
  // convert unit types to their descriptive strings
  for (unsigned u = 0; u < m_dependencies.unit_size(); u++)
  {
    str << "  " << library()->manager()->description(m_dependencies.unit_dependency(u).type()) << ": ";
    str << m_dependencies.unit_dependency(u).library() << "." << m_dependencies.unit_dependency(u).name();
    str << std::endl;
  }
  if (!m_supplement.empty())
  {
    str << "  supplementary data: " << m_supplement << std::endl;
  }
  return !str.fail();
}

// header file management

std::string stlplus::lm_unit::filename(void) const
{
  return stlplus::create_filespec(library_path(), m_name.name(), m_name.type());
}

std::string stlplus::lm_unit::header_filename(void) const
{
  return stlplus::create_filespec(library_path(), m_name.name(), m_name.type() + std::string(HeaderExtension));
}

bool stlplus::lm_unit::read_header(void)
{
  if (file_exists(header_filename()))
  {
    std::ifstream input(header_filename().c_str());
    m_dependencies.read(input);
    input.get();
    std::getline(input, m_supplement);
  }
  m_header_modified = false;
  return true;
}

bool stlplus::lm_unit::write_header(void)
{
  if (!m_header_modified) return true;
  std::ofstream output(header_filename().c_str());
  m_dependencies.write(output);
  output << m_supplement << std::endl;
  m_header_modified = false;
  return true;
}

// print diagnostics

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_unit& u)
{
  u.print(str);
  return str;
}

////////////////////////////////////////////////////////////////////////////////
// lm_library
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// constructors/destructors
// copy operations only legal on unopened libraries

stlplus::lm_library::lm_library(library_manager* manager) : m_writable(false), m_manager(manager)
{
}

stlplus::lm_library::lm_library(const lm_library& library) : m_writable(library.m_writable), m_manager(library.m_manager)
{
}

stlplus::lm_library& stlplus::lm_library::operator = (const stlplus::lm_library& library)
{
  m_writable = library.m_writable;
  m_manager = library.m_manager;
  return *this;
}

stlplus::lm_library::~lm_library(void)
{
  close();
}

const stlplus::library_manager* stlplus::lm_library::manager(void) const
{
  return m_manager;
}

stlplus::library_manager* stlplus::lm_library::manager(void)
{
  return m_manager;
}

//////////////////////////////////////////////////////////////////////////////
// initialisers

bool stlplus::lm_library::create(const std::string& name, const std::string& path, bool writable)
{
  close();
  if (!create_library(path, m_manager->m_owner, name, writable)) return false;
  return open(path);
}

bool stlplus::lm_library::open(const std::string& path)
{
  close();
  if (!read_context(path, m_manager->m_owner, m_name, m_writable)) return false;
  // convert path to full path on load
  m_path = folder_to_path(path);
  return load_types();
}

//////////////////////////////////////////////////////////////////////////////
// management of types

bool stlplus::lm_library::load_type(const std::string& type)
{
  lm_callback_map::iterator callback = m_manager->m_callbacks.find(type);
  if (callback == m_manager->m_callbacks.end()) return false;
  // a null callback means create a dummy unit from the baseclass only
  lm_create_callback fn = callback->second.m_callback;
  void* data = callback->second.m_type_data;
  // for each file in the library folder that matches the type of the create callback, create an unloaded unit
  std::vector<std::string> files = folder_wildcard(m_path, stlplus::create_filename("*", type), false, true);
  for (unsigned i = 0; i < files.size(); i++)
  {
    // key by unit name - lowercase name if case-insensitive
    lm_unit_name uname(basename_part(files[i]),type);
    if (!m_manager->m_unit_case) uname.lowercase();
    lm_unit_ptr unit;
    // if there's a callback, use it to create the subclass, else create the
    // superclass which only contains header information
    if (fn)
      unit.set(fn(uname,this,data));
    else
      unit.set(new lm_unit(uname,this));
    m_units[uname] = unit;
  }
  return true;
}

bool stlplus::lm_library::load_types(void)
{
  bool result = true;
  for (lm_callback_map::const_iterator i = m_manager->m_callbacks.begin(); i != m_manager->m_callbacks.end(); i++)
    result &= load_type(i->first);
  return result;
}

bool stlplus::lm_library::remove_type(const std::string& type)
{
  bool result = true;
  std::vector<std::string> units = names(type);
  for (std::vector<std::string>::iterator i = units.begin(); i != units.end(); i++)
  {
    lm_unit_name name(*i, type);
    std::map<lm_unit_name,lm_unit_ptr>::iterator ni = local_find(name);
    if (ni != m_units.end())
      m_units.erase(ni);
  }
  return result;
}

//////////////////////////////////////////////////////////////////////////////
// whole library operations

bool stlplus::lm_library::load(void)
{
  bool result = true;
  for (std::map<lm_unit_name,lm_unit_ptr>::iterator i = m_units.begin(); i != m_units.end(); i++)
    result &= i->second->load();
  return result;
}

bool stlplus::lm_library::save(void)
{
  bool result = true;
  for (std::map<lm_unit_name,lm_unit_ptr>::iterator i = m_units.begin(); i != m_units.end(); i++)
    result &= i->second->save();
  return result;
}

bool stlplus::lm_library::purge(void)
{
  bool result = true;
  for (std::map<lm_unit_name,lm_unit_ptr>::iterator i = m_units.begin(); i != m_units.end(); i++)
    result &= i->second->purge();
  return result;
}

bool stlplus::lm_library::close(void)
{
  bool result = save();
  m_units.clear();
  m_path = "";
  m_writable = false;
  return result;
}

bool stlplus::lm_library::erase(void)
{
  // preserve the path because close destroys it
  std::string path = m_path;
  return close() && erase_library(path, m_manager->m_owner);
}

const std::string& stlplus::lm_library::name(void) const
{
  return m_name;
}

const std::string& stlplus::lm_library::path(void) const
{
  return m_path;
}

//////////////////////////////////////////////////////////////////////////////
// managing read/write status

bool stlplus::lm_library::set_read_write(bool writable)
{
  if (m_writable == writable) return true;
  if (os_read_only()) return false;
  m_writable = writable;
  if (!write_context(m_path, m_manager->m_owner, m_name, m_writable))
    read_context(m_path, m_manager->m_owner, m_name, m_writable);
  return m_writable == writable;
}

bool stlplus::lm_library::set_writable(void)
{
  return set_read_write(true);
}

bool stlplus::lm_library::set_read_only(void)
{
  return set_read_write(false);
}

bool stlplus::lm_library::writable(void) const
{
  return os_writable() && lm_writable();
}

bool stlplus::lm_library::read_only(void) const
{
  return os_read_only() || lm_read_only();
}

bool stlplus::lm_library::os_writable(void) const
{
  return folder_writable(path());
}

bool stlplus::lm_library::os_read_only(void) const
{
  return !folder_writable(path());
}

bool stlplus::lm_library::lm_writable(void) const
{
  return m_writable;
}

bool stlplus::lm_library::lm_read_only(void) const
{
  return !m_writable;
}

//////////////////////////////////////////////////////////////////////////////
// unit management

std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::iterator stlplus::lm_library::local_find(const lm_unit_name& name)
{
  // implement the case-sensitivity
  lm_unit_name local = name;
  if (!m_manager->m_unit_case) local.lowercase();
  return m_units.find(local);
}

std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator stlplus::lm_library::local_find(const lm_unit_name& name) const
{
  // implement the case-sensitivity
  lm_unit_name local = name;
  if (!m_manager->m_unit_case) local.set_name(lowercase(local.name()));
  return m_units.find(local);
}

bool stlplus::lm_library::exists(const lm_unit_name& name) const
{
  return find(name).present();
}

stlplus::lm_unit_ptr stlplus::lm_library::create(const stlplus::lm_unit_name& name)
{
  if (read_only()) return lm_unit_ptr();
  // preserve the unit's name, but use a lowercase key in case-insensitive mode
  lm_unit_name uname = name;
  if (!m_manager->m_unit_case) uname.lowercase();
  // remove any existing unit with the same name
  erase(uname);
  // use the callbacks to create a new unit
  lm_callback_map::iterator callback = m_manager->m_callbacks.find(name.type());
  if (callback == m_manager->m_callbacks.end()) return lm_unit_ptr();
  lm_unit_ptr new_unit;
  new_unit.set(callback->second.m_callback(name,this,callback->second.m_type_data));
  new_unit->m_loaded = true;
  // add it to the library manager
  m_units[uname] = new_unit;
  return m_units[uname];
}

bool stlplus::lm_library::loaded(const lm_unit_name& name) const
{
  lm_unit_ptr unit = find(name);
  return unit && unit->loaded();
}

bool stlplus::lm_library::load(const lm_unit_name& name)
{
  lm_unit_ptr unit = find(name);
  if (!unit) return false;
  return unit->load();
}

bool stlplus::lm_library::purge(const lm_unit_name& name)
{
  lm_unit_ptr unit = find(name);
  if (!unit) return false;
  bool result = save(name);
  result &= unit->purge();
  unit->m_loaded = false;
  return result;
}

bool stlplus::lm_library::save(const lm_unit_name& name)
{
  if (read_only()) return false;
  lm_unit_ptr unit = find(name);
  if (!unit) return false;
  return unit->save();
}

bool stlplus::lm_library::erase(const lm_unit_name& name)
{
  if (read_only()) return false;
  std::map<lm_unit_name,lm_unit_ptr>::iterator i = local_find(name);
  if (i == m_units.end()) return false;
  std::string spec = i->second->filename();
  std::string header_spec = i->second->header_filename();
  m_units.erase(i);
  file_delete(spec);
  file_delete(header_spec);
  return true;
}

bool stlplus::lm_library::mark(const lm_unit_name& name)
{
  if (read_only()) return false;
  lm_unit_ptr unit = find(name);
  if (!unit) return false;
  unit->mark();
  return true;
}

time_t stlplus::lm_library::modified(const lm_unit_name& name) const
{
  lm_unit_ptr unit = find(name);
  return unit ? unit->modified() : 0;
}

bool stlplus::lm_library::erase_by_source(const std::string& source_file)
{
  if (read_only()) return false;
  if (source_file.empty()) return false;
  bool result = false;
  std::string source_file_full = filespec_to_path(source_file);
  // erase by unit name so that I don't have to deal with an iterator to a changing map
  std::vector<lm_unit_name> units = names();
  for (std::vector<lm_unit_name>::iterator i = units.begin(); i != units.end(); i++)
  {
    lm_unit_ptr unit = find(*i);
    if (unit && unit->source_file_present())
    {
      std::string file_full = unit->source_file().path_full(unit->library_path());
      if (file_full == source_file_full)
      {
        erase(*i);
        result = true;
      }
    }
  }
  return result;
}

const stlplus::lm_unit_ptr stlplus::lm_library::find(const stlplus::lm_unit_name& name) const
{
  std::map<lm_unit_name,lm_unit_ptr>::const_iterator i = local_find(name);
  if (i == m_units.end()) return lm_unit_ptr();
  return i->second;
}

stlplus::lm_unit_ptr stlplus::lm_library::find(const stlplus::lm_unit_name& name)
{
  std::map<lm_unit_name,lm_unit_ptr>::iterator i = local_find(name);
  if (i == m_units.end()) return lm_unit_ptr();
  return i->second;
}

std::vector<stlplus::lm_unit_name> stlplus::lm_library::names(void) const
{
  std::vector<stlplus::lm_unit_name> result;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    result.push_back(i->second->unit_name());
  return result;
}

std::vector<std::string> stlplus::lm_library::names(const std::string& type) const
{
  std::vector<std::string> result;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    if (i->first.type() == type)
      result.push_back(i->second->name());
  return result;
}

std::vector<stlplus::lm_unit_ptr> stlplus::lm_library::handles(void) const
{
  std::vector<stlplus::lm_unit_ptr> result;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    result.push_back(i->second);
  return result;
}

std::vector<stlplus::lm_unit_ptr> stlplus::lm_library::handles(const std::string& type) const
{
  std::vector<stlplus::lm_unit_ptr> result;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    if (i->first.type() == type)
      result.push_back(i->second);
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// dependency checking

bool stlplus::lm_library::out_of_date(const stlplus::lm_unit_name& name) const
{
  return m_manager->out_of_date(m_name, name);
}

bool stlplus::lm_library::up_to_date(const stlplus::lm_unit_name& name) const
{
  return m_manager->up_to_date(m_name, name);
}

stlplus::lm_dependencies stlplus::lm_library::out_of_date_reason(const stlplus::lm_unit_name& unit) const
{
  return m_manager->out_of_date_reason(m_name, unit);
}

std::pair<bool,unsigned> stlplus::lm_library::tidy(void)
{
  std::pair<bool,unsigned> result = std::make_pair(true,0);
  // erase every unit that is out of date
  // this will potentially make other units out of date, so keep erasing until
  // everything is up to date or an error occurs
  for (;;)
  {
    std::vector<stlplus::lm_unit_name> units = names();
    unsigned initial_count = result.second;
    for (std::vector<stlplus::lm_unit_name>::iterator i = units.begin(); i != units.end(); i++)
    {
      if (out_of_date(*i))
      {
        if (!erase(*i))
          result.first = false;
        else
          result.second++;
      }
    }
    if (!result.first) break;
    if (result.second == initial_count) break;
  }
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// do-everything print routine!

bool stlplus::lm_library::pretty_print(std::ostream& str,
                                       bool print_units,
                                       const std::string& type) const
{
  // print the library information
  if (this == m_manager->work())
    str << "->> ";
  else
    str << "    ";
  str << name() << " in directory " << folder_to_relative_path(path());
  if (read_only()) str << " (locked)";
  str << std::endl;
  // select the units
  if (print_units)
  {
    // separate into a block per unit kind
    for (lm_callback_map::const_iterator j = m_manager->m_callbacks.begin(); j != m_manager->m_callbacks.end(); j++)
    {
      // select the requested unit kind
      if (type.empty() || type == j->first)
      {
        // get all the units of this kind
        std::vector<std::string> unit_names = names(j->first);
        if (!unit_names.empty())
        {
          str << "    " << j->second.m_description << std::endl;
          for (unsigned k = 0; k < unit_names.size(); k++)
          {
            lm_dependencies reason = out_of_date_reason(stlplus::lm_unit_name(unit_names[k],j->first));
            str << "    - " << unit_names[k];
            if (!reason.empty()) str << " (out of date)";
            str << std::endl;
            if (!reason.empty())
            {
              if (reason.source_file_present())
              {
                const lm_file_dependency& file = reason.source_file();
                str << "    * source file " << filespec_to_relative_path(file.path_full(path())) << " has changed" << std::endl;
              }
              for (unsigned i1 = 0; i1 < reason.file_size(); i1++)
              {
                const lm_file_dependency& file = reason.file_dependency(i1);
                str << "    * file " << filespec_to_relative_path(file.path_full(path())) << " has changed" << std::endl;
              }
              for (unsigned i2 = 0; i2 < reason.unit_size(); i2++)
              {
                const lm_unit_dependency& file = reason.unit_dependency(i2);
                lm_callback_map::const_iterator entry = m_manager->m_callbacks.find(file.type());
                str << "    * " << entry->second.m_description << " " << file.library() << "." << file.name() << " has changed" << std::endl;
              }
            }
          }
        }
      }
    }
  }
  return true;
}

////////////////////////////////////////////////////////////////////////////////
// diagnostic print routines

bool stlplus::lm_library::print(std::ostream& str) const
{
  str << name() << " in " << path() << " " << (writable() ? "writable" : "read-only") << std::endl;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    i->second->print(str);
  return !str.fail();
}

bool stlplus::lm_library::print_long(std::ostream& str) const
{
  str << name() << " in " << path() << " " << (writable() ? "writable" : "read-only") << std::endl;
  for (std::map<stlplus::lm_unit_name,stlplus::lm_unit_ptr>::const_iterator i = m_units.begin(); i != m_units.end(); i++)
    i->second->print_long(str);
  return !str.fail();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::lm_library& lib)
{
  lib.print(str);
  return str;
}

////////////////////////////////////////////////////////////////////////////////
// library manager
////////////////////////////////////////////////////////////////////////////////

// static functions allow you to test whether a directory is a library before opening it
// you can also find the library's name without opening it

bool stlplus::library_manager::is_library(const std::string& path, const std::string& owner)
{
  std::string spec = stlplus::create_filespec(path, owner, LibraryNameExtension);
  return file_exists(spec);
}

std::string stlplus::library_manager::library_name(const std::string& path, const std::string& owner)
{
  std::string name;
  bool writable = false;
  if (!read_context(path, owner, name, writable))
    return std::string();
  return name;
}

bool stlplus::library_manager::is_library(const std::string& path)
{
  return is_library(path, m_owner);
}

std::string stlplus::library_manager::library_name(const std::string& path)
{
  return library_name(path, m_owner);
}

//////////////////////////////////////////////////////////////////////////////
// tructors

stlplus::library_manager::library_manager(const std::string& owner, bool library_case, bool unit_case) :
  m_owner(owner), m_ini_files(0), m_library_case(library_case), m_unit_case(unit_case)
{
}

stlplus::library_manager::~library_manager(void)
{
  close();
}

//////////////////////////////////////////////////////////////////////////////
// case sensitivity

bool stlplus::library_manager::library_case(void) const
{
  return m_library_case;
}

void stlplus::library_manager::set_library_case(bool library_case)
{
  m_library_case = library_case;
}

bool stlplus::library_manager::unit_case(void) const
{
  return m_unit_case;
}

void stlplus::library_manager::set_unit_case(bool unit_case)
{
  m_unit_case = unit_case;
}

////////////////////////////////////////////////////////////////////////////////
// type handling

bool stlplus::library_manager::add_type(const std::string& type,
                                        const std::string& description,
                                        lm_create_callback fn,
                                        void* type_data)
{
  bool result = true;
  m_callbacks[type] = lm_callback_entry(fn, description, type_data);
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result &= i->load_type(type);
  return result;
}

bool stlplus::library_manager::remove_type(const std::string& type)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result &= i->remove_type(type);
  m_callbacks.erase(type);
  return result;
}

std::vector<std::string> stlplus::library_manager::types(void) const
{
  std::vector<std::string> result;
  for (lm_callback_map::const_iterator i = m_callbacks.begin(); i != m_callbacks.end(); i++)
    result.push_back(i->first);
  return result;
}

std::string stlplus::library_manager::description(const std::string& type) const
{
  lm_callback_map::const_iterator found = m_callbacks.find(type);
  if (found == m_callbacks.end()) return std::string();
  return found->second.m_description;
}

stlplus::lm_create_callback stlplus::library_manager::callback(const std::string& type) const
{
  lm_callback_map::const_iterator found = m_callbacks.find(type);
  if (found == m_callbacks.end()) return 0;
  return found->second.m_callback;
}

void* stlplus::library_manager::type_data(const std::string& type) const
{
  lm_callback_map::const_iterator found = m_callbacks.find(type);
  if (found == m_callbacks.end()) return 0;
  return found->second.m_type_data;
}

//////////////////////////////////////////////////////////////////////////////
// mapping file handling

void stlplus::library_manager::set_mapping_file(const std::string& mapping_file)
{
  m_mapping_file = mapping_file;
}

bool stlplus::library_manager::load_mappings(const std::string& mapping_file)
{
  m_mapping_file = mapping_file;
  if (!file_exists(mapping_file))
  {
    return false;
  }
  std::ifstream input(mapping_file.c_str());
  if (input.fail())
    return false;
  // each line of the map file is a path to a library
  // the first line is the work library - may be empty
  // mappings are saved as paths relative to the mapping file and converted to full paths on load
  bool result = true;
  unsigned line = 1;
  for (std::string path = ""; std::getline(input,path); line++)
  {
    if (path.empty()) continue;
    std::string full_path = folder_to_path(folder_part(m_mapping_file), path);
    if (!is_library(full_path))
    {
      result = false;
    }
    else
    {
      lm_library* lib = open(full_path);
      if (!lib)
        result = false;
      else if (line == 1)
        setwork(lib->name());
    }
  }
  return result;
}

std::string stlplus::library_manager::mapping_file()
{
  return m_mapping_file;
}

bool stlplus::library_manager::set_ini_manager(ini_manager* ini_files, const std::string& library_section, const std::string& work_name)
{
  if (!ini_files) return false;
  bool result = true;
  m_ini_files = ini_files;
  m_ini_section = library_section;
  m_ini_work = work_name;
  // now load the existing library mappings if present - in any case create the sections
  // Note: a library mapping is saved as a path relative to the ini file - on load convert it to a path relative to the current directory
  if (m_ini_files->section_exists(m_ini_section))
  {
    std::vector<std::string> library_names = m_ini_files->variable_names(m_ini_section);
    std::string work_name;
    for (unsigned i = 0; i < library_names.size(); i++)
    {
      std::string library_name = library_names[i];
      // if the variable name is the work name, then this is a mapping to an existing library name
      // if it is null, then it is masking a global library definition so ignore it
      // otherwise it is a mapping to a directory containing the library
      if (library_name.empty())
      {
      }
      else if (library_name == m_ini_work)
      {
        work_name = m_ini_files->variable_value(m_ini_section, library_name);
      }
      else
      {
        std::string value = m_ini_files->variable_value(m_ini_section, library_name);
        std::string filename = m_ini_files->variable_filename(m_ini_section, library_name);
        // get the path to the ini file defining this library, strip off the ini filename to get the folder
        // then combine this with the library path from that ini file to the library to get a full path to the library
        // whew!
        std::string full_path = folder_to_path(folder_part(filename),value);
        if (!is_library(full_path))
          result = false;
        else
        {
          lm_library* lib = open(full_path);
          if (!lib)
            result = false;
        }
      }
    }
    // work must be set after all the libraries have been opened because it is
    // illegal to set work to a library that doesn't already exist in the
    // library manager
    if (work_name.empty())
      unsetwork();
    else
      result &= setwork(work_name);
  }
  return result;
}

stlplus::ini_manager* stlplus::library_manager::get_ini_manager(void) const
{
  return m_ini_files;
}

bool stlplus::library_manager::save_mappings (void)
{
  bool result = true;
  // save to mapping file or ini manager or both
  if (!m_mapping_file.empty())
  {
    if (m_libraries.size() == 0)
    {
      // if the file would be empty, delete it
      if (!file_delete(m_mapping_file))
        result = false;
    }
    else
    {
      std::ofstream output(m_mapping_file.c_str());
      if (output.fail())
      {
        result = false;
      }
      else
      {
        // each line of the map file is a path to a library
        // the first line is the work library
        // mappings are saved as relative paths to the mapping file and converted to full paths on load
        if (!work_name().empty())
          output << folder_to_relative_path(folder_part(m_mapping_file), path(work_name()));
        output << std::endl;
        std::vector<std::string> libraries = names();
        for (unsigned i = 0; i < libraries.size(); ++i)
        {
          if (libraries[i] != work_name())
            output << folder_to_relative_path(folder_part(m_mapping_file), path(libraries[i])) << std::endl;
        }
        if (output.fail())
          result = false;
      }
    }
  }
  if (m_ini_files)
  {
    // this is somewhat tricky!
    // first remove all local mappings
    // then need to compare the surviving library mappings with the contents of the library manager
    // if there's a library in the ini files not in the library manager, mask it with an empty local declaration
    // if there's a library in the ini files with the same mapping as the library manager, do nothing
    // if there's a library in the ini files with a different mapping write that library mapping
    // if there's a mapping missing from the ini files, write it
    // finally write the work mapping if there is one
    // clear all local mappings
    // TODO - rework this so that the ini files only change if the mappings change
    m_ini_files->clear_section(m_ini_section);
    m_ini_files->add_comment(m_ini_section, "generated automatically by the library manager");
    // look for globally defined library mappings that need to be overridden in the local ini file
    std::vector<std::string> ini_names = m_ini_files->variable_names(m_ini_section);
    for (unsigned i = 0; i < ini_names.size(); i++)
    {
      std::string ini_name = ini_names[i];
      // check for a global library that needs to be locally masked
      if (!exists(ini_name))
        m_ini_files->add_variable(m_ini_section, ini_name, "");
      else
      {
        // check for a library that is locally remapped
        std::string value = m_ini_files->variable_value(m_ini_section, ini_name);
        std::string filename = m_ini_files->variable_filename(m_ini_section, ini_name);
        std::string full_ini_path = folder_to_path(folder_part(filename), value);
        std::string full_lib_path = folder_to_path(path(ini_name));
        if (full_ini_path != full_lib_path)
        {
          // write the path relative to the ini file
          std::string relative_path = folder_to_relative_path(folder_part(filename), full_lib_path);
          m_ini_files->add_variable(m_ini_section, ini_name, relative_path);
        }
      }
    }
    // now scan the library for mappings that aren't yet in the ini file
    std::vector<std::string> lib_names = names();
    for (unsigned j = 0; j < lib_names.size(); j++)
    {
      std::string lib_name = lib_names[j];
      if (std::find(ini_names.begin(), ini_names.end(), lib_name) == ini_names.end())
      {
        // write the path relative to the ini file
        std::string full_lib_path = folder_to_path(path(lib_name));
        std::string filename = m_ini_files->variable_filename(m_ini_section, lib_name);
        std::string relative_path = folder_to_relative_path(folder_part(filename), full_lib_path);
        m_ini_files->add_variable(m_ini_section, lib_name, relative_path);
      }
    }
    // write the work library - also write a blank value if work is not set but is defined in another library
    if (!work_name().empty())
      m_ini_files->add_variable(m_ini_section, m_ini_work, work_name());
    else if (m_ini_files->variable_exists(m_ini_section, m_ini_work))
      m_ini_files->add_variable(m_ini_section, m_ini_work, "");
    m_ini_files->add_blank(m_ini_section);
    // remove the section from the ini file manager if there's nothing in it
    if (m_ini_files->empty_section(m_ini_section))
      m_ini_files->erase_section(m_ini_section);
    if (!m_ini_files->save())
      result = false;
  }
  return result;
}

//////////////////////////////////////////////////////////////////////////////
// library management

bool stlplus::library_manager::exists(const std::string& name) const
{
  return find(name) != 0;
}

stlplus::lm_library* stlplus::library_manager::create(const std::string& name, const std::string& path, bool writable)
{
  if (!create_library(path, m_owner, name, writable)) return 0;
  return open(path);
}

stlplus::lm_library* stlplus::library_manager::open(const std::string& path)
{
  std::string name;
  bool writable = false;
  if (!read_context(path, m_owner, name, writable)) return 0;
  // remove any pre-existing library with the same name
  close(name);
  // add the library to the manager and open it
  m_libraries.push_back(lm_library(this));
  if (!m_libraries.back().open(folder_to_path(path)))
  {
    // remove the library in the event of an error
    m_libraries.erase(--m_libraries.end());
    return 0;
  }
  return &m_libraries.back();
}

bool stlplus::library_manager::load(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->load();
}

bool stlplus::library_manager::save(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->save();
}

bool stlplus::library_manager::purge(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->purge();
}

bool stlplus::library_manager::close(const std::string& name)
{
  bool result= true;
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  result &= found->close();
  m_libraries.erase(found);
  if (name == m_work) m_work = "";
  return result;
}

bool stlplus::library_manager::erase(const std::string& name)
{
  bool result= true;
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  result &= found->erase();
  m_libraries.erase(found);
  if (name == m_work) m_work = "";
  return result;
}

// operations on all libraries - as above but applied to all the libraries in the manager

bool stlplus::library_manager::load(void)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result &= i->load();
  return result;
}

bool stlplus::library_manager::save(void)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result &= i->save();
  return result;
}

bool stlplus::library_manager::purge(void)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result &= i->purge();
  return result;
}

bool stlplus::library_manager::close(void)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); )
  {
    std::list<lm_library>::iterator next = i;
    next++;
    result &= i->close();
    m_libraries.erase(i);
    i = next;
  }
  return result;
}

bool stlplus::library_manager::erase(void)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); )
  {
    std::list<lm_library>::iterator next = i;
    next++;
    result &= i->erase();
    m_libraries.erase(i);
    i = next;
  }
  return result;
}

// get name and path of a library - name can differ in case if the library manager is case-insensitive

std::string stlplus::library_manager::name(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::string();
  return found->name();
}

std::string stlplus::library_manager::path(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::string();
  return found->path();
}

// control and test read/write status

bool stlplus::library_manager::set_writable(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->set_writable();
}

bool stlplus::library_manager::set_read_only(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->set_read_only();
}

bool stlplus::library_manager::writable(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->writable();
}

bool stlplus::library_manager::read_only(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->read_only();
}

bool stlplus::library_manager::os_writable(const std::string& library) const
{
  std::list<lm_library>::const_iterator found = local_find(library);
  if (found == m_libraries.end()) return false;
  return found->os_writable();
}

bool stlplus::library_manager::os_read_only(const std::string& library) const
{
  std::list<lm_library>::const_iterator found = local_find(library);
  if (found == m_libraries.end()) return false;
  return found->os_read_only();
}

bool stlplus::library_manager::lm_writable(const std::string& library) const
{
  std::list<lm_library>::const_iterator found = local_find(library);
  if (found == m_libraries.end()) return false;
  return found->lm_writable();
}

bool stlplus::library_manager::lm_read_only(const std::string& library) const
{
  std::list<lm_library>::const_iterator found = local_find(library);
  if (found == m_libraries.end()) return false;
  return found->lm_read_only();
}

// find a library in the manager - returns null if not found

stlplus::lm_library* stlplus::library_manager::find(const std::string& name)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return 0;
  return &(*found);
}

const stlplus::lm_library* stlplus::library_manager::find(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return 0;
  return &(*found);
}

// get the set of all library names

std::vector<std::string> stlplus::library_manager::names(void) const
{
  std::vector<std::string> result;
  for (std::list<lm_library>::const_iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result.push_back(i->name());
  return result;
}

// get the set of all libraries

std::vector<const stlplus::lm_library*> stlplus::library_manager::handles(void) const
{
  std::vector<const lm_library*> result;
  for (std::list<lm_library>::const_iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result.push_back(&(*i));
  return result;
}

std::vector<stlplus::lm_library*> stlplus::library_manager::handles(void)
{
  std::vector<stlplus::lm_library*> result;
  for (std::list<stlplus::lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    result.push_back(&(*i));
  return result;
}

//////////////////////////////////////////////////////////////////////////////
// current library management

bool stlplus::library_manager::setwork(const std::string& name)
{
  unsetwork();
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  m_work = found->name();
  return true;
}

bool stlplus::library_manager::unsetwork(void)
{
  m_work = "";
  return true;
}

const stlplus::lm_library* stlplus::library_manager::work(void) const
{
  if (m_work.empty()) return 0;
  return find(m_work);
}

stlplus::lm_library* stlplus::library_manager::work(void)
{
  if (m_work.empty()) return 0;
  return find(m_work);
}

std::string stlplus::library_manager::work_name(void) const
{
  return m_work;
}

//////////////////////////////////////////////////////////////////////////////
// unit management within a library

bool stlplus::library_manager::exists(const std::string& name, const stlplus::lm_unit_name& unit) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->exists(unit);
}

stlplus::lm_unit_ptr stlplus::library_manager::create(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return stlplus::lm_unit_ptr();
  return found->create(unit);
}

bool stlplus::library_manager::loaded(const std::string& name, const stlplus::lm_unit_name& unit) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return stlplus::lm_unit_ptr();
  return found->loaded(unit);
}

bool stlplus::library_manager::load(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return stlplus::lm_unit_ptr();
  return found->load(unit);
}

bool stlplus::library_manager::purge(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->purge(unit);
}

bool stlplus::library_manager::save(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->save(unit);
}

bool stlplus::library_manager::erase(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->erase(unit);
}

bool stlplus::library_manager::mark(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return false;
  return found->mark(unit);
}

time_t stlplus::library_manager::modified(const std::string& name, const stlplus::lm_unit_name& unit) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return 0;
  return found->modified(unit);
}

bool stlplus::library_manager::erase_by_source(const std::string& source_file)
{
  bool result = true;
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
    if (i->writable())
      result &= i->erase_by_source(source_file);
  return result;
}

const stlplus::lm_unit_ptr stlplus::library_manager::find(const std::string& name, const stlplus::lm_unit_name& unit) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end())
    return stlplus::lm_unit_ptr();
  return found->find(unit);
}

stlplus::lm_unit_ptr stlplus::library_manager::find(const std::string& name, const stlplus::lm_unit_name& unit)
{
  std::list<lm_library>::iterator found = local_find(name);
  if (found == m_libraries.end()) return stlplus::lm_unit_ptr();
  return found->find(unit);
}

std::vector<stlplus::lm_unit_name> stlplus::library_manager::names(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::vector<stlplus::lm_unit_name>();
  return found->names();
}

std::vector<std::string> stlplus::library_manager::names(const std::string& name, const std::string& type) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::vector<std::string>();
  return found->names(type);
}

std::vector<stlplus::lm_unit_ptr> stlplus::library_manager::handles(const std::string& name) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::vector<stlplus::lm_unit_ptr>();
  return found->handles();
}

std::vector<stlplus::lm_unit_ptr> stlplus::library_manager::handles(const std::string& name, const std::string& type) const
{
  std::list<lm_library>::const_iterator found = local_find(name);
  if (found == m_libraries.end()) return std::vector<stlplus::lm_unit_ptr>();
  return found->handles(type);
}

//////////////////////////////////////////////////////////////////////////////
// dependency checking
// done at the top level because a global view of the libraries is required

bool stlplus::library_manager::out_of_date(const std::string& library, const stlplus::lm_unit_name& name) const
{
  return !up_to_date(library, name);
}

bool stlplus::library_manager::up_to_date(const std::string& library, const stlplus::lm_unit_name& name) const
{
  lm_dependencies reason = out_of_date_reason(library, name);
  return reason.empty();
}

stlplus::lm_dependencies stlplus::library_manager::out_of_date_reason(const std::string& library, const stlplus::lm_unit_name& name) const
{
  std::map<std::pair<std::string,stlplus::lm_unit_name>,lm_dependencies> visited;
  return out_of_date_check(visited, this, library, name);
}

std::pair<bool,unsigned> stlplus::library_manager::tidy(const std::string& library)
{
  std::list<lm_library>::iterator found = local_find(library);
  if (found == m_libraries.end()) return std::make_pair(false,0);
  return found->tidy();
}

std::pair<bool,unsigned> stlplus::library_manager::tidy(void)
{
  std::pair<bool,unsigned> result = std::make_pair(true,0);
  for (std::list<lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
  {
    if (i->writable())
    {
      std::pair<bool,unsigned> library_result = i->tidy();
      result.second += library_result.second;
      result.first &= library_result.first;
    }
  }
  return result;
}

//////////////////////////////////////////////////////////////////////////////
// do-everything print routine!

bool stlplus::library_manager::pretty_print(std::ostream& str,
                                            bool print_units,
                                            const std::string& lib,
                                            const std::string& type) const
{
  bool library_found = false;
  for (std::list<lm_library>::const_iterator l = m_libraries.begin(); l != m_libraries.end(); l++)
  {
    // select the library
    if (lib.empty() || lib == l->name())
    {
      l->pretty_print(str, print_units, type);
      library_found = true;
    }
  }
  if (!library_found)
  {
    if (lib.empty())
      str << "there are no libraries in the library list" << std::endl;
    else
      str << "there is no library called " << lib << " in the library list" << std::endl;
    return false;
  }
  return true;
}

////////////////////////////////////////////////////////////////////////////////
// diagnostic print routines

bool stlplus::library_manager::print(std::ostream& str) const
{
  for (std::list<lm_library>::const_iterator l = m_libraries.begin(); l != m_libraries.end(); l++)
    l->print(str);
  return !str.good();
}

bool stlplus::library_manager::print_long(std::ostream& str) const
{
  for (std::list<lm_library>::const_iterator l = m_libraries.begin(); l != m_libraries.end(); l++)
    l->print_long(str);
  return !str.good();
}

// find a library by name

std::list<stlplus::lm_library>::iterator stlplus::library_manager::local_find(const std::string& name)
{
  for (std::list<stlplus::lm_library>::iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
  {
    if (m_library_case)
    {
      if (i->name() == name) return i;
    }
    else
    {
      if (lowercase(i->name()) == lowercase(name)) return i;
    }
  }
  return m_libraries.end();
}

std::list<stlplus::lm_library>::const_iterator stlplus::library_manager::local_find(const std::string& name) const
{
  for (std::list<stlplus::lm_library>::const_iterator i = m_libraries.begin(); i != m_libraries.end(); i++)
  {
    if (m_library_case)
    {
      if (i->name() == name) return i;
    }
    else
    {
      if (lowercase(i->name()) == lowercase(name)) return i;
    }
  }
  return m_libraries.end();
}

std::ostream& stlplus::operator << (std::ostream& str, const stlplus::library_manager& manager)
{
  manager.print(str);
  return str;
}

////////////////////////////////////////////////////////////////////////////////
