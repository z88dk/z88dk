////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include <sstream>
#include <fstream>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, class D>
  void dump_to_device(const T& source, std::ostream& result, D dump_fn, 
                      dump_context::installer installer)
    throw(persistent_dump_failed)
  {
    dump_context context(result);
    context.register_all(installer);
    dump_fn(context, source);
  }

  template<typename T, class R>
  void restore_from_device(std::istream& source, T& result, R restore_fn,
                           restore_context::installer installer)
    throw(persistent_restore_failed)
  {
    restore_context context(source);
    context.register_all(installer);
    restore_fn(context, result);
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, class D>
  void dump_to_string(const T& source, std::string& result, D dump_fn, 
                      dump_context::installer installer)
    throw(persistent_dump_failed)
  {
    std::ostringstream output(std::ios_base::out | std::ios_base::binary);
    dump_to_device<T,D>(source, output, dump_fn, installer);
    result = output.str();
  }

  template<typename T, class R>
  void restore_from_string(const std::string& source, T& result, R restore_fn, 
                           restore_context::installer installer)
    throw(persistent_restore_failed)
  {
    std::istringstream input(source, std::ios_base::in | std::ios_base::binary);
    restore_from_device<T,R>(input, result, restore_fn, installer);
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, class D>
  void dump_to_file(const T& source, const std::string& filename, D dump_fn,
                    dump_context::installer installer)
    throw(persistent_dump_failed)
  {
    std::ofstream output(filename.c_str(), std::ios_base::out | std::ios_base::binary);
    dump_to_device<T,D>(source, output, dump_fn, installer);
  }

  template<typename T, class R>
  void restore_from_file(const std::string& filename, T& result, R restore_fn,
                         restore_context::installer installer)
    throw(persistent_restore_failed)
  {
    std::ifstream input(filename.c_str(), std::ios_base::in | std::ios_base::binary);
    restore_from_device<T,R>(input, result, restore_fn, installer);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
