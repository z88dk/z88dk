#ifndef STLPLUS_LIBRARY_MANAGER
#define STLPLUS_LIBRARY_MANAGER
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generalised library manager.

//   Manages library units in a set of library directories. A unit is both a file
//   on-disk and a data-structure in memory. To use the library manager, you need
//   to:

//     - design a type based on lm_unit with serialising functions read/write 
//     - decide on a file extension for the type
//     - decide on a description of the type
//     - write a create callback for this type
//     - register the file extension, description and callback with the library manager

////////////////////////////////////////////////////////////////////////////////
#include "subsystems_fixes.hpp"
#include "ini_manager.hpp"
#include "smart_ptr.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <time.h>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Internals
  ////////////////////////////////////////////////////////////////////////////////

  class lm_library;
  class library_manager;

  ////////////////////////////////////////////////////////////////////////////////
  // unit names
  ////////////////////////////////////////////////////////////////////////////////

  class lm_unit_name
  {
  public:
    lm_unit_name(const std::string& name = std::string(), const std::string& type = std::string());
    ~lm_unit_name(void);

    const std::string& name(void) const;
    void set_name(const std::string& name);
    void lowercase(void);

    const std::string& type(void) const;
    void set_type(const std::string& type);

    bool write(std::ostream& context) const;
    bool read(std::istream& context);

    std::string to_string(void) const;
    bool print(std::ostream&) const;

  private:
    std::string m_name;
    std::string m_type;
  };

  std::ostream& operator << (std::ostream&, const lm_unit_name&);
  bool operator == (const lm_unit_name& l, const lm_unit_name& r);
  bool operator < (const lm_unit_name& l, const lm_unit_name& r);

  ////////////////////////////////////////////////////////////////////////////////
  // dependencies
  ////////////////////////////////////////////////////////////////////////////////

  // dependencies on external files

  class lm_file_dependency
  {
  public:
    lm_file_dependency(void);
    lm_file_dependency(const std::string& library_path, const std::string& path, unsigned line = 0, unsigned column = 0);
    ~lm_file_dependency(void);

    // a path can be retrieved as either a relative path to the library or as a
    // full path by providing the library path as an argument
    const std::string& path(void) const;
    std::string path_full(const std::string& library_path) const;
    void set_path(const std::string& library_path, const std::string& path);

    unsigned line(void) const;
    void set_line(unsigned line = 0);

    unsigned column(void) const;
    void set_column(unsigned column = 0);

    bool write(std::ostream& context) const;
    bool read(std::istream& context);

    bool print(std::ostream&) const;

  private:
    std::string m_path; // file dependencies are stored as paths relative to the containing library
    unsigned m_line;    // line - starts at 1, 0 means no line/column information
    unsigned m_column;  // column - starts at 0
  };

  std::ostream& operator <<(std::ostream&, const lm_file_dependency&);

  // dependencies on other units

  class lm_unit_dependency
  {
  public:
    lm_unit_dependency(void);
    lm_unit_dependency(const std::string& library, const lm_unit_name& name);
    ~lm_unit_dependency(void);

    const std::string& library(void) const;
    void set_library(const std::string& library);

    const lm_unit_name& unit_name(void) const;
    void set_unit_name(const lm_unit_name& unit_name);

    const std::string& name(void) const;
    void set_name(const std::string& name);

    const std::string& type(void) const;
    void set_type(const std::string& type);

    bool write(std::ostream& context) const;
    bool read(std::istream& context);

    bool print(std::ostream&) const;

  private:
    std::string m_library;
    lm_unit_name m_name;
  };

  std::ostream& operator<<(std::ostream&, const lm_unit_dependency&);

  // the set of all dependencies

  class lm_dependencies
  {
  public:
    lm_dependencies(void);
    lm_dependencies(const lm_dependencies&);
    lm_dependencies& operator=(const lm_dependencies&);
    ~lm_dependencies(void);

    // source file dependency
    void set_source_file(const lm_file_dependency&);
    bool source_file_present(void) const;
    const lm_file_dependency& source_file(void) const;

    // other file dependencies
    unsigned file_add(const lm_file_dependency& dependency);
    unsigned file_size(void) const;
    const lm_file_dependency& file_dependency(unsigned) const;
    void file_erase(unsigned);

    // unit dependencies
    unsigned unit_add(const lm_unit_dependency& dependency);
    unsigned unit_size(void) const;
    const lm_unit_dependency& unit_dependency(unsigned) const;
    void unit_erase(unsigned);

    void clear(void);
    bool empty(void) const;

    bool write(std::ostream& context) const;
    bool read(std::istream& context);

    bool print(std::ostream&) const;

  private:
    lm_file_dependency* m_source;            // source file dependency (optional)
    std::vector<lm_file_dependency> m_files; // other file dependencies
    std::vector<lm_unit_dependency> m_units; // unit dependencies
  };

  std::ostream& operator << (std::ostream&, const lm_dependencies&);

  ////////////////////////////////////////////////////////////////////////////////
  // library unit superclass
  // user's units must be derivatives of lm_unit and overload all the virtuals

  class lm_unit
  {
    friend class lm_library;
  public:
    ////////////////////////////////////////
    // constructor/destructor

    lm_unit(const lm_unit_name& name, lm_library* library);
    virtual ~lm_unit(void);

    ////////////////////////////////////////
    // Header data

    // unit name
    const lm_unit_name& unit_name(void) const;
    const std::string& name(void) const;
    const std::string& type(void) const;

    // dependencies
    // all file dependencies are converted for internal use to a path relative to the library
    // they can be retrieved either in this form or as a full path

    // source file dependency
    void set_source_file(const lm_file_dependency&);
    bool source_file_present(void) const;
    const lm_file_dependency& source_file(void) const;

    // other file dependencies
    unsigned file_add(const lm_file_dependency& dependency);
    unsigned file_size(void) const;
    const lm_file_dependency& file_dependency(unsigned) const;
    void file_erase(unsigned);

    // unit dependencies
    unsigned unit_add(const lm_unit_dependency& dependency);
    unsigned unit_size(void) const;
    const lm_unit_dependency& unit_dependency(unsigned) const;
    void unit_erase(unsigned);

    const lm_dependencies& dependencies(void) const;
    void set_dependencies(const lm_dependencies&);
    void clear_dependencies(void);
    bool empty_dependencies(void) const;

    // dependency checking

    bool out_of_date(void) const;
    bool up_to_date(void) const;
    lm_dependencies out_of_date_reason(void) const;

    // supplementary data

    const std::string& supplementary_data(void) const;
    void set_supplementary_data(const std::string& data);

    ////////////////////////////////////////
    // unit data management

    bool load(void);
    bool save(void);
    bool loaded(void) const;
    void mark(void);

    // file modified time - only changes after a save

    time_t modified(void) const;

    ////////////////////////////////////////
    // containing library manager details

    // get the owning library
    const lm_library* library(void) const;
    lm_library* library(void);

    // owning library name and path
    const std::string& library_name(void) const;
    const std::string& library_path(void) const;

    ////////////////////////////////////////
    // error handling - these apply to the last read/write operation

    bool error(void) const;

    ////////////////////////////////////////
    // functions that customise subclasses of this superclass
    // You MUST provide at least:
    //   - read - either read operation can be overloaded
    //   - write - either write operation can be overloaded
    //   - clone

    // read(filename) is the one actually called to read your data
    // the default read(filename) simply calls read(istream) to actually read the file
    // the default read(istream) does nothing but fail by returning false so you must overload one or other

    // you can just overload read(istream) if you want to use IOstream, or you
    // can overload read(filename) to use any I/O system

    virtual bool read(const std::string& filename, void* type_data);
    virtual bool read(std::istream& file, void* type_data);

    // as above, but for writing the data type

    // write(filename) is the one actually called to write your data
    // the default write(filename) simply calls write(ostream) to actually write the file
    // the default write(ostream) does nothing but fail by returning false so you must overload one or other

    // you can just overload write(ostream) if you want to use IOstream, or you
    // can overload write(filename) to use any I/O system

    virtual bool write(const std::string& filename, void* type_data);
    virtual bool write(std::ostream& file, void* type_data);

    // purge clears any memory associated with the unit - makes the unit unloaded
    // the default does nothing
    virtual bool purge(void);

    // the clone function creates a new-ed copy of the subclass
    virtual lm_unit* clone(void) const;

    // the default print routines print header-only information
    // you can overload these to provide a debug printout of the data structure
    virtual bool print(std::ostream&) const;
    virtual bool print_long(std::ostream&) const;

  protected:
    // header file management
    std::string filename(void) const;
    std::string header_filename(void) const;
    bool write_header(void);
    bool read_header(void);

  private:
    // header fields
    lm_unit_name m_name;            // name
    lm_dependencies m_dependencies; // file and unit dependencies
    std::string m_supplement;       // supplementary data
    bool m_header_modified;         // header modified

    // internal fields
    bool m_loaded;                  // loaded flag
    bool m_marked;                  // mark - determines whether the unit needs saving

    // library manager fields
    lm_library* m_library;          // parent library

    // error handling fields
    bool m_error;                    // error flag if load or save fails - from IOstream
  };

  // Iostream print calls the short print method
  std::ostream& operator << (std::ostream& str, const lm_unit& u);

  ////////////////////////////////////////////////////////////////////////////////
  // other types used in the library manager
  ////////////////////////////////////////////////////////////////////////////////

  // user types

  typedef smart_ptr_nocopy<lm_unit> lm_unit_ptr;
  typedef lm_unit* (*lm_create_callback)(const lm_unit_name& unit_name, lm_library* parent_library, void* type_data);

  // internal types used in the library manager but made global because they are shared

  struct lm_callback_entry
  {
    lm_create_callback m_callback;
    std::string m_description;
    void* m_type_data;

    lm_callback_entry(lm_create_callback callback = 0, const std::string& description = std::string(), void* type_data = 0) :
      m_callback(callback), m_description(description), m_type_data(type_data) {}
  };

  ////////////////////////////////////////////////////////////////////////////////
  // Library
  // Must be contained in a library_manager
  // Manages objects of class lm_unit and its subclasses
  ////////////////////////////////////////////////////////////////////////////////

  class lm_library
  {
  public:
    friend class library_manager;
    friend class lm_unit;

    //////////////////////////////////////////////////////////////////////////////
    // constructors/destructor - lm_library should only ever be constructed by library_manager

    lm_library(library_manager* manager);
    lm_library(const lm_library&);
    lm_library& operator = (const lm_library&);
    ~lm_library(void);

  public:

    const library_manager* manager(void) const;
    library_manager* manager(void);

    //////////////////////////////////////////////////////////////////////////////
    // initialisers

    bool create(const std::string& name, const std::string& path, bool writable);
    bool open(const std::string& path);

    //////////////////////////////////////////////////////////////////////////////
    // management of types

    bool load_type(const std::string& type);
    bool load_types(void);
    bool remove_type(const std::string& type);

    //////////////////////////////////////////////////////////////////////////////
    // whole library operations

    bool load(void);
    bool save(void);
    bool purge(void);
    bool close(void);
    bool erase(void);

    const std::string& name(void) const;
    const std::string& path(void) const;

    //////////////////////////////////////////////////////////////////////////////
    // managing read/write status

    bool set_read_write(bool writable);
    bool set_writable(void);
    bool set_read_only(void);
    bool writable(void) const;
    bool read_only(void) const;
    bool os_writable(void) const;
    bool os_read_only(void) const;
    bool lm_writable(void) const;
    bool lm_read_only(void) const;

    //////////////////////////////////////////////////////////////////////////////
    // unit management

    bool exists(const lm_unit_name& name) const;
    lm_unit_ptr create(const lm_unit_name&);
    bool loaded(const lm_unit_name& name) const;
    bool load(const lm_unit_name& unit);
    bool purge(const lm_unit_name& unit);
    bool save(const lm_unit_name& unit);
    bool erase(const lm_unit_name& name);
    bool mark(const lm_unit_name& name);
    time_t modified(const lm_unit_name& name) const;

    bool erase_by_source(const std::string& source_file);

    const lm_unit_ptr find(const lm_unit_name& name) const;
    lm_unit_ptr find(const lm_unit_name& name);

    std::vector<lm_unit_name> names(void) const;
    std::vector<std::string> names(const std::string& type) const;
    std::vector<lm_unit_ptr> handles(void) const;
    std::vector<lm_unit_ptr> handles(const std::string& type) const;

    //////////////////////////////////////////////////////////////////////////////
    // dependency checking

    bool out_of_date(const lm_unit_name& name) const;
    bool up_to_date(const lm_unit_name& name) const;
    lm_dependencies out_of_date_reason(const lm_unit_name& name) const;

    std::pair<bool,unsigned> tidy(void);

    //////////////////////////////////////////////////////////////////////////////
    // do-everything print function

    bool pretty_print(std::ostream& str,
                      bool print_units = false,                       // print the unit names not just the library names
                      const std::string& type = std::string()) const; // print just this type ("" means all)

    ////////////////////////////////////////////////////////////////////////////////
    // diagnostic print routines

    bool print(std::ostream& str) const;
    bool print_long(std::ostream& str) const;

  private:

    std::map<lm_unit_name,lm_unit_ptr>::iterator local_find(const lm_unit_name& name);
    std::map<lm_unit_name,lm_unit_ptr>::const_iterator local_find(const lm_unit_name& name) const;

    std::string m_name;                         // name
    std::string m_path;                         // path
    bool m_writable;                            // writable
    std::map<lm_unit_name,lm_unit_ptr> m_units; // units
    library_manager* m_manager;                 // parent library manager
  };

  std::ostream& operator << (std::ostream& str, const lm_library& lib);

  ////////////////////////////////////////////////////////////////////////////////
  // Library Manager
  ////////////////////////////////////////////////////////////////////////////////

  class library_manager
  {
  public:
    friend class lm_library;
    friend class lm_unit;

    ////////////////////////////////////////////////////////////////////////////////
    // static functions allow you to test whether a directory is a library before opening it
    // you can also find the library's name without opening it

    static bool is_library(const std::string& path, const std::string& owner);
    static std::string library_name(const std::string& path, const std::string& owner);

    // non-static forms test for libraries with the same owner as the library manager

    bool is_library(const std::string& path);
    std::string library_name(const std::string& path);

    //////////////////////////////////////////////////////////////////////////////
    // tructors

    explicit library_manager(const std::string& owner, bool library_case = false, bool unit_case = false);
    ~library_manager(void);

    //////////////////////////////////////////////////////////////////////////////
    // case sensitivity

    bool library_case(void) const;
    void set_library_case(bool library_case);

    bool unit_case(void) const;
    void set_unit_case(bool library_case);

    //////////////////////////////////////////////////////////////////////////////
    // type handling
    // only units of types added in this way will be recognised

    bool add_type(const std::string& type,
                  const std::string& description,
                  lm_create_callback fn = 0,
                  void* type_data = 0);
    bool remove_type(const std::string& type);
    std::vector<std::string> types(void) const;

    std::string description(const std::string& type) const;
    lm_create_callback callback(const std::string& type) const;
    void* type_data(const std::string& type) const;

    //////////////////////////////////////////////////////////////////////////////
    // Library mappings
    // The library manager implements two different styles of library mappings
    //   - mapping file
    //   - ini file
    // mapping file handling uses a simple text file to store the mappings in an internally-defined format
    // ini file handling stores library mappings using the ini_manager component
    // These modes are switched on by simply specifying a mapping file or an ini file to hold the mappings

    // mapping file methods

    // set but do not load - use this when you want to create a new mapping file
    void set_mapping_file(const std::string& mapping_file);
    // set and load - use this with an existing mapping file
    bool load_mappings (const std::string& mapping_file);
    // return the mapping file string
    std::string mapping_file();

    // ini file methods - the ini manager must be pre-loaded with the list of ini files to manage

    // set and load - this will create the relevant sections in the local ini file if not present already
    bool set_ini_manager(ini_manager* ini_files, const std::string& library_section, const std::string& work_section);
    ini_manager* get_ini_manager(void) const;

    // save to the library mapping handler, whichever kind it is
    bool save_mappings (void);

    //////////////////////////////////////////////////////////////////////////////
    // library management

    // operations on a single library
    // test whether a named library exists
    bool exists(const std::string& name) const;
    // create a new libarry in the specified directory
    lm_library* create(const std::string& name, const std::string& path, bool writable = true);
    // open an existing library
    lm_library* open(const std::string& path);
    // load all units in the library
    bool load(const std::string& name);
    // save all marked units in the library
    bool save(const std::string& name);
    // purge all loaded units in the library
    bool purge(const std::string& name);
    // close the library - remove it from the manager but leave on disk
    bool close(const std::string& name);
    // erase the library - delete the directory and remove the library from the manager
    bool erase(const std::string& name);

    // operations on all libraries - as above but applied to all the libraries in the manager
    bool load(void);
    bool save(void);
    bool purge(void);
    bool close(void);
    bool erase(void);

    // get name and path of a library - name can differ in case if the library manager is case-insensitive
    std::string name(const std::string& library) const;
    std::string path(const std::string& library) const;

    // control and test read/write status
    bool set_writable(const std::string& library);
    bool set_read_only(const std::string& library);
    bool writable(const std::string& library) const;
    bool read_only(const std::string& library) const;
    bool os_writable(const std::string& library) const;
    bool os_read_only(const std::string& library) const;
    bool lm_writable(const std::string& library) const;
    bool lm_read_only(const std::string& library) const;

    // find a library in the manager - returns null if not found
    lm_library* find(const std::string& name);
    const lm_library* find(const std::string& name) const;

    // get the set of all library names
    std::vector<std::string> names(void) const;
    // get the set of all libraries
    std::vector<const lm_library*> handles(void) const;
    std::vector<lm_library*> handles(void);

    //////////////////////////////////////////////////////////////////////////////
    // current library management

    bool setwork(const std::string& library);
    bool unsetwork(void);
    const lm_library* work(void) const;
    lm_library* work(void);
    std::string work_name(void) const;

    //////////////////////////////////////////////////////////////////////////////
    // unit management within a library
    // Note: you can also manipulate the library class through a handle returned by find() or handles()

    bool exists(const std::string& library, const lm_unit_name& name) const;
    lm_unit_ptr create(const std::string& library, const lm_unit_name& name);
    bool loaded(const std::string& library, const lm_unit_name& name) const;
    bool load(const std::string& library, const lm_unit_name& name);
    bool purge(const std::string& library, const lm_unit_name& name);
    bool save(const std::string& library, const lm_unit_name& name);
    bool erase(const std::string& library, const lm_unit_name& name);
    bool mark(const std::string& library, const lm_unit_name& name);
    time_t modified(const std::string& library, const lm_unit_name& name) const;

    bool erase_by_source(const std::string& source_file);

    const lm_unit_ptr find(const std::string& library, const lm_unit_name& name) const;
    lm_unit_ptr find(const std::string& library, const lm_unit_name& name);

    std::vector<lm_unit_name> names(const std::string& library) const;
    std::vector<std::string> names(const std::string& library, const std::string& type) const;
    std::vector<lm_unit_ptr> handles(const std::string& library) const;
    std::vector<lm_unit_ptr> handles(const std::string& library, const std::string& type) const;

    //////////////////////////////////////////////////////////////////////////////
    // dependency checking

    bool out_of_date(const std::string& library, const lm_unit_name& name) const;
    bool up_to_date(const std::string& library, const lm_unit_name& name) const;
    lm_dependencies out_of_date_reason(const std::string& library, const lm_unit_name& name) const;

    // delete out of date units from a library or all libraries
    // return the number of units tidied and a flag to say whether all units were successfully tidied
    std::pair<bool,unsigned> tidy(const std::string& library);
    std::pair<bool,unsigned> tidy(void);

    //////////////////////////////////////////////////////////////////////////////
    // do-everything print routine!

    bool pretty_print(std::ostream& str,
                      bool print_units = false,                       // print the unit names not just the library names
                      const std::string& library = std::string(),     // print just the specified library ("" means all)
                      const std::string& type = std::string()) const; // print just this type ("" means all)

    ////////////////////////////////////////////////////////////////////////////////
    // diagnostic print routines

    bool print(std::ostream& str) const;
    bool print_long(std::ostream& str) const;

    //////////////////////////////////////////////////////////////////////////////
    // internals

  private:
    // NOT a copyable object
    library_manager(const library_manager&);
    library_manager& operator = (const library_manager&);

  protected:
    std::list<lm_library>::iterator local_find(const std::string& name);
    std::list<lm_library>::const_iterator local_find(const std::string& name) const;

    std::string m_owner;                               // owner application name
    std::string m_mapping_file;                        // mapping file method of library management
    ini_manager* m_ini_files;                          // ini manager method of library management
    std::string m_ini_section;                         // ini manager method of library management
    std::string m_ini_work;                            // ini manager method of library management
    std::list<lm_library> m_libraries;                 // libraries
    std::string m_work;                                // work library
    std::map<std::string,lm_callback_entry> m_callbacks; // callbacks
    bool m_library_case;                               // case sensitivity for library names
    bool m_unit_case;                                  // case sensitivity for unit names
  };

  std::ostream& operator << (std::ostream& str, const library_manager& libraries);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
