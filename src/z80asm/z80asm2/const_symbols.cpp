//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_symbols.h"
#include "diag.h"
#include "options.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <algorithm>
#include <iostream>

void ConstSymbols::set(StringInterner::Id name_id, int value, const SourceLoc& loc) {
    const ConstSymbol* existing = get(name_id);
    if (existing != nullptr && existing->value != value) {
        g_diag.error(loc, "Constant already defined: " + g_strings.to_string(name_id));
        g_diag.note(existing->loc, "Previous definition of constant: " + g_strings.to_string(name_id));
        return;
    }

    ConstSymbol sym;
    sym.name_id = name_id;
    sym.value = value;
    sym.loc = loc;
    symbols[sym.name_id] = sym;

    if (g_args.options.verbose) {
        std::cout << "Define constant: " << g_strings.to_string(name_id)
                  << " = " << int_to_hex(value) << std::endl;
    }
}

const ConstSymbol* ConstSymbols::get(StringInterner::Id name_id) const {
    auto it = symbols.find(name_id);
    if (it != symbols.end()) {
        return &it->second;
    }
    return nullptr;
}

void ConstSymbols::erase(StringInterner::Id name_id) {
    symbols.erase(name_id);
}

void ConstSymbols::set(std::string_view name, int value, const SourceLoc& loc) {
    set(g_strings.intern(name), value, loc);
}

const ConstSymbol* ConstSymbols::get(std::string_view name) const {
    return get(g_strings.intern(name));
}

void ConstSymbols::erase(std::string_view name) {
    erase(g_strings.intern(name));
}

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
