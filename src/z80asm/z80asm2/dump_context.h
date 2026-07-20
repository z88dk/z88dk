//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string_view>

//-----------------------------------------------------------------------------
// helper for dumping AST in a readable format
//-----------------------------------------------------------------------------
struct DumpContext {
    std::ostream& os;
    int indent{0};

    DumpContext(std::ostream& os_, int indent_ = 0);
    void line(std::string_view text);
    DumpContext child() const;
};

//-----------------------------------------------------------------------------
// base class for all tree nodes
//-----------------------------------------------------------------------------
struct TreeNode {
    virtual ~TreeNode() = default;
    virtual void dump(DumpContext ctx) const = 0;
};
