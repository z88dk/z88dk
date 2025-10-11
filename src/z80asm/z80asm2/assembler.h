//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>
#include <cstdint>

class Lexer;
class Parser;
class CodeGenerator;
class SymbolTable;
class ErrorReporter;

class Assembler {
public:
    Assembler();
    void assemble(const std::string& input);
    std::vector<uint8_t> getOutput() const;
private:
    // Components
    //Lexer* lexer_{ nullptr };
    //Parser* parser_{ nullptr };
    //CodeGenerator* codegen_{ nullptr };
    //SymbolTable* symbols_{ nullptr };
    //ErrorReporter* errors_{ nullptr };
};
