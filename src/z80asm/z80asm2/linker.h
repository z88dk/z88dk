//-----------------------------------------------------------------------------
// z80asm - linker
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "object.h"
#include "symtab.h"
#include <string>
#include <vector>
using namespace std;

class Linker {
public:
    Linker(const string& bin_filename);
    virtual ~Linker();
    Linker(Linker& other) = delete;
    Linker& operator=(Linker& other) = delete;

    void link();
    void write();
    
private:
    struct SectionParams {
        string bin_filename;            // filename of output file
        int origin{ ORG_NOT_DEFINED };  // section origin
        int align{ 1 };                 // section alignment
        int size{ 0 };                  // section size in bytes
        bool split{ false };            // this section splits output
    };

    struct MemoryArea {
        SectionParams params;           // of whole block
        vector<Section*> sections;      // list of all sections concatenated together
    };

    string bin_filename_;
    Symtab global_symbols_;             // globals in the order defined
    vector<Symbol*> unresolved_;        // unresolved symbols in the order found
    vector<MemoryArea*> areas_;         // linked-together sections

    void link_symbols();                // update global_symbols_ and unresolved_
    void link_extern_symbols();         // link all possible extern symbols, return unresolved
    void link_library_modules();        // pull in library modules to resolve symbols
    SectionParams get_section_params(const string& section_name);    // get info from sections
    void concatenate_sections();        // concatenate sections in the order linked


    void allocate_addresses();
    void load_global_symbols();         // load global_symbols_
};
