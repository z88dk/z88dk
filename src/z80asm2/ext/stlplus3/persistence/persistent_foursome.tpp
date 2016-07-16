////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T1, typename T2, typename T3, typename T4, typename D1, typename D2, typename D3, typename D4>
  void dump_foursome(dump_context& context, const foursome<T1,T2,T3,T4>& data, 
                     D1 dump_fn1, D2 dump_fn2, D3 dump_fn3, D4 dump_fn4)
    throw(persistent_dump_failed)
  {
    dump_fn1(context,data.first);
    dump_fn2(context,data.second);
    dump_fn3(context,data.third);
    dump_fn4(context,data.fourth);
  }

  template<typename T1, typename T2, typename T3, typename T4, typename R1, typename R2, typename R3, typename R4>
  void restore_foursome(restore_context& context, foursome<T1,T2,T3,T4>& data,
                        R1 restore_fn1, R2 restore_fn2, R3 restore_fn3, R4 restore_fn4)
    throw(persistent_restore_failed)
  {
    restore_fn1(context,data.first);
    restore_fn2(context,data.second);
    restore_fn3(context,data.third);
    restore_fn4(context,data.fourth);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
