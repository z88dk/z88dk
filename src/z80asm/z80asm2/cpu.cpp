//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include <cassert>

Keyword cpu_invert_flag_condition(Keyword kw) {
    switch (kw) {
    case Keyword::C:
        return Keyword::NC;
    case Keyword::EQ:
        return Keyword::NE;
    case Keyword::GE:
        return Keyword::LT;
    case Keyword::GEU:
        return Keyword::LTU;
    case Keyword::GT:
        return Keyword::LE;
    case Keyword::GTU:
        return Keyword::LEU;
    case Keyword::K:
        return Keyword::NK;
    case Keyword::LE:
        return Keyword::GT;
    case Keyword::LEU:
        return Keyword::GTU;
    case Keyword::LO:
        return Keyword::LZ;
    case Keyword::LT:
        return Keyword::GE;
    case Keyword::LTU:
        return Keyword::GEU;
    case Keyword::LZ:
        return Keyword::LO;
    case Keyword::M:
        return Keyword::P;
    case Keyword::NC:
        return Keyword::C;
    case Keyword::NE:
        return Keyword::EQ;
    case Keyword::NK:
        return Keyword::K;
    case Keyword::NV:
        return Keyword::V;
    case Keyword::NX5:
        return Keyword::X5;
    case Keyword::NZ:
        return Keyword::Z;
    case Keyword::P:
        return Keyword::M;
    case Keyword::PE:
        return Keyword::PO;
    case Keyword::PO:
        return Keyword::PE;
    case Keyword::V:
        return Keyword::NV;
    case Keyword::X5:
        return Keyword::NX5;
    case Keyword::Z:
        return Keyword::NZ;
    default:
        assert(0);
        return Keyword::None;
    }
}

// replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
static void swap_x_y(std::string& inout_text) {
    for (auto& c : inout_text) {
        switch (c) {
        case 'x':
            c = 'y';
            break;
        case 'X':
            c = 'Y';
            break;
        case 'y':
            c = 'x';
            break;
        case 'Y':
            c = 'X';
            break;
        default:
            ;
        }
    }
}

void swap_ix_iy(std::string& inout_text, Keyword& inout_kw) {
    if (keyword_is_x_register(inout_kw)) {
        swap_x_y(inout_text);
        inout_kw = keyword_lookup(inout_text);
    }
}

