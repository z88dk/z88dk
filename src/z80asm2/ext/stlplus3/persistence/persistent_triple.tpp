////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T1, typename T2, typename T3, typename D1, typename D2, typename D3>
  void dump_triple(dump_context& context, const triple<T1,T2,T3>& data, 
                   D1 dump_fn1, D2 dump_fn2, D3 dump_fn3)
    throw(persistent_dump_failed)
  {
    dump_fn1(context,data.first);
    dump_fn2(context,data.second);
    dump_fn3(context,data.third);
  }

  template<typename T1, typename T2, typename T3, typename R1, typename R2, typename R3>
  void restore_triple(restore_context& context, triple<T1,T2,T3>& data,
                      R1 restore_fn1, R2 restore_fn2, R3 restore_fn3)
    throw(persistent_restore_failed)
  {
    restore_fn1(context,data.first);
    restore_fn2(context,data.second);
    restore_fn3(context,data.third);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
