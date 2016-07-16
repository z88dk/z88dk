////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename D>
  void dump_complex(dump_context& context, const std::complex<T>& data, D dump_fn)
    throw(persistent_dump_failed)
  {
    dump_fn(context,data.real());
    dump_fn(context,data.imag());
  }

  template<typename T, typename R>
  void restore_complex(restore_context& context, std::complex<T>& data, R restore_fn)
    throw(persistent_restore_failed)
  {
    T re, im;
    restore_fn(context,re);
    restore_fn(context,im);
    data = std::complex<T>(re, im);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
