//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "dump_context.h"
#include <string>
#include <string_view>

DumpContext::DumpContext(std::ostream& os_, int indent_)
    : os(os_), indent(indent_) {
}

void DumpContext::line(std::string_view text) {
    os << std::string(indent * 4, ' ') << text << std::endl;
}

DumpContext DumpContext::child() const {
    return DumpContext(os, indent + 1);
}
