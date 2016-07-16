#ifndef STLPLUS_TRIPLE
#define STLPLUS_TRIPLE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton, from an original by Dan Milton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Similar to the STL pair but with three elements

////////////////////////////////////////////////////////////////////////////////
#include "containers_fixes.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // the triple class

  template<typename T1, typename T2, typename T3>
  struct triple
  {
    typedef T1 first_type;
    typedef T2 second_type;
    typedef T3 third_type;

    T1 first;
    T2 second;
    T3 third;

    triple(void);
    triple(const T1& p1, const T2& p2, const T3& p3);
    triple(const triple<T1,T2,T3>& t2);
  };

  ////////////////////////////////////////////////////////////////////////////////
  // creation

  template<typename T1, typename T2, typename T3>
  triple<T1,T2,T3> make_triple(const T1& first, const T2& second, const T3& third);

  ////////////////////////////////////////////////////////////////////////////////
  // comparison

  template<typename T1, typename T2, typename T3>
  bool operator == (const triple<T1,T2,T3>& left, const triple<T1,T2,T3>& right);
  template<typename T1, typename T2, typename T3>
  bool operator < (const triple<T1,T2,T3>& left, const triple<T1,T2,T3>& right);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "triple.tpp"
#endif
