////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton, from an original by Dan Milton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // the foursome class

  template<typename T1, typename T2, typename T3, typename T4>
  foursome<T1,T2,T3,T4>::foursome(void) :
    first(), second(), third(), fourth()
  {
  }

  template<typename T1, typename T2, typename T3, typename T4>
  foursome<T1,T2,T3,T4>::foursome(const T1& p1, const T2& p2, const T3& p3, const T4& p4) :
    first(p1), second(p2), third(p3), fourth(p4)
  {
  }

  template<typename T1, typename T2, typename T3, typename T4>
  foursome<T1,T2,T3,T4>::foursome(const foursome<T1,T2,T3,T4>& t2) :
    first(t2.first), second(t2.second), third(t2.third), fourth(t2.fourth)
  {
  }

  ////////////////////////////////////////////////////////////////////////////////
  // creation

  template<typename T1, typename T2, typename T3, typename T4>
  foursome<T1,T2,T3,T4> make_foursome(const T1& first, const T2& second, const T3& third, const T4& fourth)
  {
    return foursome<T1,T2,T3,T4>(first,second,third,fourth);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // comparison

  template<typename T1, typename T2, typename T3, typename T4>
  bool operator == (const foursome<T1,T2,T3,T4>& left, const foursome<T1,T2,T3,T4>& right)
  {
    // foursomes are equal if all elements are equal
    return
      left.first == right.first &&
      left.second == right.second &&
      left.third == right.third &&
      left.fourth == right.fourth;
  }

  template<typename T1, typename T2, typename T3, typename T4>
  bool operator < (const foursome<T1,T2,T3,T4>& left, const foursome<T1,T2,T3,T4>& right)
  {
    // use the < operator on each element
  	return left.first < right.first ? true :
  	       right.first < left.first ? false :
  	       left.second < right.second ? true :
  	       right.second < left.second ? false :
  	       left.third < right.third ? true :
  	       right.third < left.third ? false :
  	       left.fourth < right.fourth;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
