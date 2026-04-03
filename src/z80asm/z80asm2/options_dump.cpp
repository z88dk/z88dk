//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "options.h"
#include "options_dump.h"
#include "string_interner.h"
#include <algorithm>
#include <iostream>
#include <vector>
#include "string_utils.h"

[[noreturn]]
void dump_after_cmdline_and_exit() {
    std::cout
            << "verbose\t"
            << g_args.options.verbose << "\n"
            << "ucase_labels\t"
            << g_args.options.ucase_labels << "\n"
            << "preprocess_only\t"
            << g_args.options.preprocess_only << "\n"
            << "swap_ix_iy\t"
            << g_args.options.swap_ix_iy << "\n"
            << "date_stamp\t"
            << g_args.options.date_stamp << "\n"
            << "dump_after_cmdline\t"
            << g_args.options.dump_after_cmdline << "\n"
            << "dump_after_tokenization\t"
            << g_args.options.dump_after_tokenization << "\n"
            << "dump_after_directives\t"
            << g_args.options.dump_after_directives << "\n"
            << "dump_after_macro_expansion\t"
            << g_args.options.dump_after_macro_expansion << "\n"
            << "dump_after_preprocessing\t"
            << g_args.options.dump_after_preprocessing << "\n"
            << "m4_options\t"
            << g_args.options.m4_options << "\n"
            << "perl_options\t"
            << g_args.options.perl_options << "\n"
            << "cpp_options\t"
            << g_args.options.cpp_options << "\n"
            << "output_dir\t"
            << g_args.options.output_dir << "\n";

    for (auto& fullpath : g_args.options.include_paths) {
        std::cout << "include_path\t" << fullpath << "\n";
    }

    // collect global_defs and sort by name
    std::vector<const ConstSymbol*> sorted_defs;
    sorted_defs.reserve(g_args.options.global_defs.symbols.size());
    for (auto& kv : g_args.options.global_defs.symbols) {
        sorted_defs.push_back(&kv.second);
    }
    std::sort(sorted_defs.begin(), sorted_defs.end(),
    [](const ConstSymbol * a, const ConstSymbol * b) {
        return g_strings.view(a->name_id) <
               g_strings.view(b->name_id);
    });
    for (auto* sym : sorted_defs) {
        std::cout << "global_def\t" << g_strings.view(sym->name_id)
                  << "\t" << int_to_hex(sym->value) << "\n";
    }

    // collect filenames
    for (auto& filename : g_args.input_files) {
        std::cout << "input_file\t" << filename << "\n";
    }

    for (auto& filename : g_args.obj_files) {
        std::cout << "obj_file\t" << filename << "\n";
    }

    exit(EXIT_SUCCESS);
}
