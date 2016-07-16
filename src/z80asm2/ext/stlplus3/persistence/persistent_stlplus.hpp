#ifndef STLPLUS_PERSISTENT_STLPLUS
#define STLPLUS_PERSISTENT_STLPLUS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Set of persistence routines for the STLplus classes

////////////////////////////////////////////////////////////////////////////////

// can be excluded to break the dependency on the containers library
#ifndef NO_STLPLUS_CONTAINERS
#include "persistent_digraph.hpp"
#include "persistent_foursome.hpp"
#include "persistent_hash.hpp"
#include "persistent_matrix.hpp"
#include "persistent_ntree.hpp"
#include "persistent_smart_ptr.hpp"
#include "persistent_triple.hpp"
#endif

// can be excluded to break the dependency on the portability library
#ifndef NO_STLPLUS_INF
#include "persistent_inf.hpp"
#endif

////////////////////////////////////////////////////////////////////////////////
#endif
