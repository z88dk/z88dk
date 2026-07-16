//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

//-----------------------------------------------------------------------------
// features per version
//-----------------------------------------------------------------------------

struct ObjFeatures {
#define X(name, predicate)	bool name = false;
#include "obj_features.def"
#undef X
};

constexpr ObjFeatures obj_features(int v) {
    return {
#define X(name, predicate)	predicate,
#include "obj_features.def"
#undef X
    };
}
