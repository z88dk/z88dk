//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla_parser.h"
#include "lexer.h"
#include "location.h"
#include <deque>
#include <string>

namespace hla {

struct Block {
    enum class Kind { If, While, Repeat } kind;  // added Repeat
    Location location;
    std::string else_label; // If only
    std::string end_label;
    std::string top_label; // While / Repeat
    bool saw_else = false;
};

class CodeGen {
public:
    explicit CodeGen(unsigned& label_counter) : counter_(label_counter) {}
    // Emit branch-if-false for expr to label
    void emit_bif(const Expr& e, const std::string& false_label,
                  const Location& loc,
                  std::deque<TokensLine>& out);

    // Emit a dot label definition (".<label>") into output
    void emit_label(const std::string& label, const Location& loc,
                    std::deque<TokensLine>& out);

private:
    unsigned& counter_;
};

} // namespace hla
