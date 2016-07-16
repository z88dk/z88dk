#ifndef STLPLUS_STRING_STLPLUS
#define STLPLUS_STRING_STLPLUS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Template string conversions for the STLplus containers

////////////////////////////////////////////////////////////////////////////////

// can be excluded to break the dependency on the containers library
#ifndef NO_STLPLUS_CONTAINERS
#include "string_digraph.hpp"
#include "string_foursome.hpp"
#include "string_hash.hpp"
#include "string_matrix.hpp"
#include "string_ntree.hpp"
#include "string_smart_ptr.hpp"
#include "string_triple.hpp"
#endif

// can be excluded to break the dependency on the portability library
#ifndef NO_STLPLUS_INF
#include "string_inf.hpp"
#endif

#endif
