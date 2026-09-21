//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "optimize.h"
#include "ast.h"
#include "simplify_expr.h"

bool optimize(Prog& prog) {
    simplify_exprs(prog);

    return get_error_count() == 0;
}
