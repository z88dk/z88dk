//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
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

void Assembler::assemble(const std::string& input_filename) {
    input_filename_ = input_filename;
    preprocessor_.push_file(input_filename_);

}

void assemble_files() {
    for (auto& asm_filename : g_options.input_files) {
        if (g_options.is_o_filename(asm_filename)) {
            if (g_options.verbose) {
                std::cout << "Skipping assembly of object file: "
                          << asm_filename << std::endl;
            }
            g_options.object_files.push_back(asm_filename);
        }
        else {
            if (g_options.verbose) {
                std::cout << "Assembling file: "
                          << asm_filename << std::endl;
            }

            Assembler as;
            as.assemble(asm_filename);
        }
    }
}
