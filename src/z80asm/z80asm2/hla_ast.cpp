//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "hla_ast.h"
#include <string>

int HLA_Label::count = 0;

HLA_Label::HLA_Label()
    : id(++count) {
}

HLA_Label::HLA_Label(int id_)
    : id(id_) {
}

std::string HLA_Label::to_string() const {
    return std::string("__HLA_") + std::to_string(id);
}

bool HLA_Label::is_valid() const {
    return id >= 0;
}
