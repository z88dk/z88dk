#ifndef STLPLUS_PERSISTENT_CONTEXTS
#define STLPLUS_PERSISTENT_CONTEXTS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Core context classes used to control the persistent dump/restore operations

////////////////////////////////////////////////////////////////////////////////

#include "persistence_fixes.hpp"
#include "persistent.hpp"
#include <iostream>
#include <map>
#include <typeinfo>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Internals

  class dump_context_body;
  class restore_context_body;

  ////////////////////////////////////////////////////////////////////////////////
  // The format version number currently supported
  ////////////////////////////////////////////////////////////////////////////////

  extern unsigned char PersistentVersion;

  ////////////////////////////////////////////////////////////////////////////////
  // dump_context controls the formatting of a persistent dump
  ////////////////////////////////////////////////////////////////////////////////

  class dump_context
  {
    friend class persistent;
  public:
    //////////////////////////////////////////////////////////////////////////////

    // device must be in binary mode
    dump_context(std::ostream& device, unsigned char version = PersistentVersion) throw(persistent_dump_failed);
    ~dump_context(void);

    // low level output used to dump a byte
    void put(unsigned char data) throw(persistent_dump_failed);

    // access the device, for example to check the error status
    const std::ostream& device(void) const;

    // recover the version number of the dumped output
    unsigned char version(void) const;

    // test whether the current platform uses little-endian or big-endian addressing of bytes
    // this is used in dump/restore of integers and is exported so that other routines can use it
    bool little_endian(void) const;

    // Assist functions for Pointers
    // the return pair value is a flag saying whether this is a new pointer and the magic key to dump to file
    std::pair<bool,unsigned> pointer_map(const void* const pointer);
    // the return pair value is a flag saying whether this is a new object and the magic key to dump to file
    std::pair<bool,unsigned> object_map(const void* const pointer);

    // Assist functions for Polymorphous classes (i.e. subclasses) using callback approach
    typedef void (*dump_callback)(dump_context&,const void*);
    unsigned register_callback(const std::type_info& info, dump_callback);
    bool is_callback(const std::type_info& info) const;
    typedef std::pair<unsigned,dump_callback> callback_data;
    callback_data lookup_callback(const std::type_info&) const throw(persistent_illegal_type);

    // Assist functions for Polymorphous classes (i.e. subclasses) using interface approach
    unsigned register_interface(const std::type_info& info);
    bool is_interface(const std::type_info& info) const;
    unsigned lookup_interface(const std::type_info&) const throw(persistent_illegal_type);

    // Register all Polymorphous classes using either approach by calling an installer callback
    typedef void (*installer)(dump_context&);
    void register_all(installer);

  private:
    friend class dump_context_body;
    dump_context_body* m_body;

    // disallow copying by making assignment and copy constructor private
    dump_context(const dump_context&);
    dump_context& operator=(const dump_context&);
  };

  ////////////////////////////////////////////////////////////////////////////////
  // restore_context controls the reading of the persistent data during a restore

  class restore_context
  {
    friend class persistent;
  public:
    //////////////////////////////////////////////////////////////////////////////

    // device must be in binary mode
    restore_context(std::istream& device) throw(persistent_restore_failed);
    ~restore_context(void);

    // low level input used to restore a byte
    int get(void) throw(persistent_restore_failed);

    // access the device, for example to check the error status
    const std::istream& device(void) const;

    // access the version number of the input being restored
    unsigned char version(void) const;

    // test whether the current platform uses little-endian or big-endian addressing of bytes
    // this is used in dump/restore of integers
    bool little_endian(void) const;

    // Assist functions for Pointers
    std::pair<bool,void*> pointer_map(unsigned magic);
    void pointer_add(unsigned magic, void* new_pointer);
    std::pair<bool,void*> object_map(unsigned magic);
    void object_add(unsigned magic, void* new_pointer);

    // Assist functions for Polymorphous classes using the callback approach
    typedef void* (*create_callback)(void);
    typedef void (*restore_callback)(restore_context&,void*);
    unsigned register_callback(create_callback,restore_callback);
    bool is_callback(unsigned) const;
    typedef std::pair<create_callback, restore_callback> callback_data;
    callback_data lookup_callback(unsigned) const throw(persistent_illegal_type);

    // Assist functions for Polymorphous classes using the interface approach
    unsigned register_interface(persistent*);
    bool is_interface(unsigned) const;
    persistent* lookup_interface(unsigned) const throw(persistent_illegal_type);

    // Register all Polymorphous classes using either approach by calling an installer callback
    typedef void (*installer)(restore_context&);
    void register_all(installer);

  private:
    friend class restore_context_body;
    restore_context_body* m_body;

    typedef std::pair<unsigned,persistent*> interface_data;

    // disallow copying by making assignment and copy constructor private
    restore_context(const restore_context&);
    restore_context& operator=(const restore_context&);
  };

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#endif
