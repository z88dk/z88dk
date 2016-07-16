////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton, from an original by Dan Milton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // the triple class

  template<typename T1, typename T2, typename T3>
  triple<T1,T2,T3>::triple(void) :
    first(), second(), third()
  {
  }

  template<typename T1, typename T2, typename T3>
  triple<T1,T2,T3>::triple(const T1& p1, const T2& p2, const T3& p3) :
    first(p1), second(p2), third(p3)
  {
  }

  template<typename T1, typename T2, typename T3>
  triple<T1,T2,T3>::triple(const triple<T1,T2,T3>& t2) :
    first(t2.first), second(t2.second), third(t2.third)
  {
  }

  ////////////////////////////////////////////////////////////////////////////////
  // creation

  template<typename T1, typename T2, typename T3>
  triple<T1,T2,T3> make_triple(const T1& first, const T2& second, const T3& third)
  {
    return triple<T1,T2,T3>(first,second,third);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // comparison

  template<typename T1, typename T2, typename T3>
  bool operator == (const triple<T1,T2,T3>& left, const triple<T1,T2,T3>& right)
  {
    // triples are equal if all elements are equal
    return left.first == right.first && left.second == right.second && left.third == right.third;
  }

  template<typename T1, typename T2, typename T3>
  bool operator < (const triple<T1,T2,T3>& left, const triple<T1,T2,T3>& right)
  {
    // use the < operator on each element
  	return left.first < right.first ? true :
  	       right.first < left.first ? false :
  	       left.second < right.second ? true :
  	       right.second < left.second ? false :
  	       left.third < right.third;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

