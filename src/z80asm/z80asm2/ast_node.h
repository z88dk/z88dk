//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include <memory>

class ASTNode {
public:
    virtual ~ASTNode() = default;
protected:
    std::vector<ASTNode*> children_;
};
