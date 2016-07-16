////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_pair.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence

  template <typename I, typename S>
  std::string sequence_to_string(I begin,
                                 I end, 
                                 S to_string,
                                 const std::string& separator)
  {
    std::string result;
    for (I i = begin; i != end; i++)
    {
      if (i != begin) result += separator;
      result += to_string(*i);
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // any sequence where the value is a pair

  template <typename I, typename S1, typename S2>
  std::string pair_sequence_to_string(I begin,
                                      I end,
                                      S1 to_string_fn1,
                                      S2 to_string_fn2,
                                      const std::string& pair_separator,
                                      const std::string& separator)
  {
    std::string result;
    for (I i = begin; i != end; i++)
    {
      if (i != begin) result += separator;
      result += pair_to_string(*i, to_string_fn1, to_string_fn2, pair_separator);
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
