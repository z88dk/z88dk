//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "code_generator.h"
#include "errors.h"
#include "lexer.h"
#include "parser.h"
#include "symbols.h"
#include <string>
#include <cassert>

bool Assembler::assemble(const std::string& input_file) {
    (void)input_file;
    preprocessor_ = std::make_unique<Preprocessor>();
    compilation_unit_ = std::make_unique<CompilationUnit>();
    return false;
}

Preprocessor& Assembler::preprocessor() {
    assert(preprocessor_);
    return *preprocessor_;
}

CompilationUnit& Assembler::compilation_unit() {
    assert(compilation_unit_);
    return *compilation_unit_;
}
