////////////////////////////////////////////////////////////////////////////////

// Author:    Andy Rushton
// Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
// License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_contexts.hpp"
#include "persistent.hpp"
#include <map>
#include <string>
#include <stdio.h>

namespace stlplus
{


  ////////////////////////////////////////////////////////////////////////////////
  // File format version

  // This relates to the layout of basic types - if I change the file layout of,
  // say, int or vector, then this will change

  // Early versions of the persistence routines did not have this - they are no longer supported
  // - Change from version 1 to 2: changed the persistent representation of inf

  unsigned char PersistentVersion = 2;

  ////////////////////////////////////////////////////////////////////////////////
  // avoid creating dependencies on other libraries

  static std::string to_string(int number)
  {
    // use sprintf in a very controlled way that cannot overrun
    char* buffer = new char[50];
    sprintf(buffer, "%i", number);
    std::string result = buffer;
    delete[] buffer;
    return result;
  }

  static bool little_endian(void)
  {
    // TODO - find a compile-time way of doing this
    int sample = 1;
    char* sample_bytes = (char*)&sample;
    return sample_bytes[0] != 0;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // dump context classes
  ////////////////////////////////////////////////////////////////////////////////

  class dump_context_body
  {
  public:
    typedef std::map<const void*,unsigned> magic_map;
    typedef std::map<std::string,dump_context::callback_data> callback_map;
    typedef std::map<std::string,unsigned> interface_map;

    unsigned m_max_key;
    unsigned char m_version;
    bool m_little_endian;
    std::ostream* m_device;
    magic_map m_pointers;
    magic_map m_objects;
    callback_map m_callbacks;
    interface_map m_interfaces;

    dump_context_body(std::ostream& device, unsigned char version) throw(persistent_dump_failed) : 
      m_max_key(0), m_version(version), m_little_endian(stlplus::little_endian()), m_device(&device)
      {
        // write the version number as a single byte
        put(version);
        // map a null pointer onto magic number zero
        m_pointers[0] = 0;
        // test whether the version number is supported
        if (m_version != 1 && m_version != 2)
          throw persistent_dump_failed(std::string("wrong version: ") + to_string(m_version));
      }

    void put(unsigned char data) throw(persistent_dump_failed)
      {
        if (!m_device->put(data))
          throw persistent_dump_failed(std::string("output device error"));
      }

    const std::ostream& device(void) const
      {
        return *m_device;
      }

    unsigned char version(void) const
      {
        return m_version;
      }

    bool little_endian(void) const
      {
        return m_little_endian;
      }

    std::pair<bool,unsigned> pointer_map(const void* const pointer)
      {
        magic_map::iterator found = m_pointers.find(pointer);
        if (found == m_pointers.end())
        {
          // add a new mapping
          unsigned magic = static_cast<unsigned>(m_pointers.size());
          m_pointers[pointer] = magic;
          return std::pair<bool,unsigned>(false,magic);
        }
        // return the old mapping
        return std::pair<bool,unsigned>(true,found->second);
      }

    std::pair<bool,unsigned> object_map(const void* const pointer)
      {
        magic_map::iterator found = m_objects.find(pointer);
        if (found == m_objects.end())
        {
          // add a new mapping
          unsigned magic = static_cast<unsigned>(m_objects.size());
          m_objects[pointer] = magic;
          return std::pair<bool,unsigned>(false,magic);
        }
        // return the old mapping
        return std::pair<bool,unsigned>(true,found->second);
      }

    unsigned register_callback(const std::type_info& info, dump_context::dump_callback callback)
      {
        std::string key = info.name();
        unsigned data = ++m_max_key;
        m_callbacks[key] = std::make_pair(data,callback);
        return data;
      }

    bool is_callback(const std::type_info& info) const
      {
        return m_callbacks.find(info.name()) != m_callbacks.end();
      }

    dump_context::callback_data lookup_callback(const std::type_info& info) const throw(persistent_illegal_type)
      {
        std::string key = info.name();
        callback_map::const_iterator found = m_callbacks.find(key);
        if (found == m_callbacks.end())
          throw persistent_illegal_type(key);
        return found->second;
      }

    unsigned register_interface(const std::type_info& info)
      {
        std::string key = info.name();
        unsigned data = ++m_max_key;
        m_interfaces[key] = data;
        return data;
      }

    bool is_interface(const std::type_info& info) const
      {
        return m_interfaces.find(info.name()) != m_interfaces.end();
      }

    unsigned lookup_interface(const std::type_info& info) const throw(persistent_illegal_type)
      {
        std::string key = info.name();
        interface_map::const_iterator found = m_interfaces.find(key);
        if (found == m_interfaces.end())
          throw persistent_illegal_type(key);
        return found->second;
      }
  };

  ////////////////////////////////////////////////////////////////////////////////

  dump_context::dump_context(std::ostream& device, unsigned char version) throw(persistent_dump_failed) : m_body(0)
  {
    m_body = new dump_context_body(device,version);
  }

  dump_context::~dump_context(void)
  {
    delete m_body;
  }

  void dump_context::put(unsigned char data) throw(persistent_dump_failed)
  {
    m_body->put(data);
  }

  const std::ostream& dump_context::device(void) const
  {
    return m_body->device();
  }

  unsigned char dump_context::version(void) const
  {
    return m_body->version();
  }

  bool dump_context::little_endian(void) const
  {
    return m_body->little_endian();
  }

  std::pair<bool,unsigned> dump_context::pointer_map(const void* const pointer)
  {
    return m_body->pointer_map(pointer);
  }

  std::pair<bool,unsigned> dump_context::object_map(const void* const pointer)
  {
    return m_body->object_map(pointer);
  }

  unsigned dump_context::register_callback(const std::type_info& info, dump_context::dump_callback callback)
  {
    return m_body->register_callback(info,callback);
  }

  bool dump_context::is_callback(const std::type_info& info) const
  {
    return m_body->is_callback(info);
  }

  dump_context::callback_data dump_context::lookup_callback(const std::type_info& info) const throw(persistent_illegal_type)
  {
    return m_body->lookup_callback(info);
  }

  unsigned dump_context::register_interface(const std::type_info& info)
  {
    return m_body->register_interface(info);
  }

  bool dump_context::is_interface(const std::type_info& info) const
  {
    return m_body->is_interface(info);
  }

  unsigned dump_context::lookup_interface(const std::type_info& info) const throw(persistent_illegal_type)
  {
    return m_body->lookup_interface(info);
  }

  void dump_context::register_all(dump_context::installer installer)
  {
    if (installer) installer(*this);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // restore context classes
  ////////////////////////////////////////////////////////////////////////////////

  class restore_context_body
  {
  public:
    typedef persistent* persistent_ptr;
    typedef std::map<unsigned,void*> magic_map;
    typedef std::map<unsigned,restore_context::callback_data> callback_map;
    typedef std::map<unsigned,persistent_ptr> interface_map;

    unsigned m_max_key;
    unsigned char m_version;
    bool m_little_endian;
    std::istream* m_device;
    magic_map m_pointers;
    magic_map m_objects;
    callback_map m_callbacks;
    interface_map m_interfaces;

    restore_context_body(std::istream& device) throw(persistent_restore_failed) : 
      m_max_key(0), m_little_endian(stlplus::little_endian()), m_device(&device)
      {
        // map a null pointer onto magic number zero
        m_pointers[0] = 0;
        // get the dump version and see if we support it
        m_version = (unsigned char)get();
        if (m_version != 1 && m_version != 2)
          throw persistent_restore_failed(std::string("wrong version: ") + to_string(m_version));
      }

    ~restore_context_body(void)
      {
        // need to delete all interfaces
        // I used to use smart_ptr_clone for storing them but I want to disconnect as many dependencies as possible
        for (unsigned i = 0; i < m_interfaces.size(); i++)
          delete m_interfaces[i];
      }

    const std::istream& device(void) const
      {
        return *m_device;
      }

    unsigned char version(void) const
      {
        return m_version;
      }

    bool little_endian(void) const
      {
        return m_little_endian;
      }

    int get(void) throw(persistent_restore_failed)
      {
        int result = m_device->get();
        if (!m_device->good())
          throw persistent_restore_failed(std::string("device error or premature end of file"));
        return result;
      }

    std::pair<bool,void*> pointer_map(unsigned magic)
      {
        magic_map::iterator found = m_pointers.find(magic);
        if (found == m_pointers.end())
        {
          // this magic number has never been seen before
          return std::pair<bool,void*>(false,(void*)0);
        }
        return std::pair<bool,void*>(true,found->second);
      }

    void pointer_add(unsigned magic, void* new_pointer)
      {
        m_pointers[magic] = new_pointer;
      }

    std::pair<bool,void*> object_map(unsigned magic)
      {
        magic_map::iterator found = m_objects.find(magic);
        if (found == m_objects.end())
        {
          // this magic number has never been seen before
          return std::pair<bool,void*>(false,(void*)0);
        }
        return std::pair<bool,void*>(true,found->second);
      }

    void object_add(unsigned magic, void* new_pointer)
      {
        m_objects[magic] = new_pointer;
      }

    unsigned register_callback(restore_context::create_callback create, restore_context::restore_callback restore)
      {
        unsigned key = ++m_max_key;
        m_callbacks[key] = std::make_pair(create,restore);
        return key;
      }

    bool is_callback(unsigned key) const
      {
        return m_callbacks.find(key) != m_callbacks.end();
      }

    restore_context::callback_data lookup_callback(unsigned key) const throw(persistent_illegal_type)
      {
        callback_map::const_iterator found = m_callbacks.find(key);
        if (found == m_callbacks.end())
          throw persistent_illegal_type(key);
        return found->second;
      }

    unsigned register_interface(persistent* sample)
      {
        unsigned key = ++m_max_key;
        m_interfaces[key] = sample;
        return key;
      }

    bool is_interface(unsigned key) const
      {
        return m_interfaces.find(key) != m_interfaces.end();
      }

    persistent* lookup_interface(unsigned key) const throw(persistent_illegal_type)
      {
        interface_map::const_iterator found = m_interfaces.find(key);
        if (found == m_interfaces.end())
          throw persistent_illegal_type(key);
        return found->second;
      }
  };

  ////////////////////////////////////////////////////////////////////////////////

  restore_context::restore_context(std::istream& device) throw(persistent_restore_failed) : 
    m_body(0)
  {
    m_body = new restore_context_body(device);
  }

  restore_context::~restore_context(void)
  {
    delete m_body;
  }

  const std::istream& restore_context::device(void) const
  {
    return m_body->device();
  }

  unsigned char restore_context::version(void) const
  {
    return m_body->version();
  }

  bool restore_context::little_endian(void) const
  {
    return m_body->little_endian();
  }

  int restore_context::get(void) throw(persistent_restore_failed)
  {
    return m_body->get();
  }

  std::pair<bool,void*> restore_context::pointer_map(unsigned magic)
  {
    return m_body->pointer_map(magic);
  }

  void restore_context::pointer_add(unsigned magic, void* new_pointer)
  {
    m_body->pointer_add(magic,new_pointer);
  }

  std::pair<bool,void*> restore_context::object_map(unsigned magic)
  {
    return m_body->object_map(magic);
  }

  void restore_context::object_add(unsigned magic, void* new_pointer)
  {
    m_body->object_add(magic,new_pointer);
  }

  unsigned restore_context::register_callback(restore_context::create_callback create, restore_context::restore_callback restore)
  {
    return m_body->register_callback(create,restore);
  }

  bool restore_context::is_callback(unsigned key) const
  {
    return m_body->is_callback(key);
  }

  restore_context::callback_data restore_context::lookup_callback(unsigned key) const throw(persistent_illegal_type)
  {
    return m_body->lookup_callback(key);
  }

  unsigned restore_context::register_interface(persistent* sample)
  {
    return m_body->register_interface(sample);
  }

  bool restore_context::is_interface(unsigned key) const
  {
    return m_body->is_interface(key);
  }

  persistent* restore_context::lookup_interface(unsigned key) const throw(persistent_illegal_type)
  {
    return m_body->lookup_interface(key);
  }

  void restore_context::register_all(restore_context::installer installer)
  {
    if (installer) installer(*this);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

