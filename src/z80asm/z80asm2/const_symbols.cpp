//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_symbols.h"
#include "diag.h"
#include "options.h"
#include "source_loc.h"
#include "strings.h"
#include "string_utils.h"
#include <algorithm>
#include <iostream>

void ConstSymbols::set(StringId name_id, int value,
                       const SourceLoc& loc) {
    const ConstSymbol* existing = get(name_id);
    if (existing != nullptr && existing->value != value) {
        g_diag.error(loc, "Constant already defined: " + std::string(g_strings.view(
                         name_id)));
        g_diag.note(existing->loc,
                    "Previous definition of constant: " + std::string(g_strings.view(name_id)));
        return;
    }

    ConstSymbol sym;
    sym.name_id = name_id;
    sym.value = value;
    sym.loc = loc;
    symbols[sym.name_id] = sym;

    if (g_args.options.verbose) {
        std::cout << "Define constant: " << g_strings.view(name_id)
                  << " = " << int_to_hex(value) << std::endl;
    }
}

const ConstSymbol* ConstSymbols::get(StringId name_id) const {
    auto it = symbols.find(name_id);
    if (it != symbols.end()) {
        return &it->second;
    }
    return nullptr;
}

void ConstSymbols::erase(StringId name_id) {
    if (g_args.options.verbose && get(name_id) != nullptr) {
        std::cout << "Undefine constant: " << g_strings.view(name_id) << std::endl;
    }
    symbols.erase(name_id);
}

#ifdef _DEBUG
void ConstSymbols::dump_symbols() const {
    // collect entries and sort by name
    std::vector<const ConstSymbol*> sorted;
    sorted.reserve(symbols.size());
    for (const auto& pair : symbols) {
        sorted.push_back(&pair.second);
    }
    std::sort(sorted.begin(), sorted.end(),
    [](const ConstSymbol * a, const ConstSymbol * b) {
        return g_strings.view(a->name_id) <
               g_strings.view(b->name_id);
    });

    for (const ConstSymbol* sym : sorted) {
        std::cout << "symbol\t" << g_strings.view(sym->name_id)
                  << "\t" << int_to_hex(sym->value)
                  << "\t(defined at " << sym->loc.to_string() << ")"
                  << std::endl;
    }
}
#endif
