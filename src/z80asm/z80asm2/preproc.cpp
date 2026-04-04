//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "file_mgr.h"
#include "lexer_dump.h"
#include "options.h"
#include "preproc.h"
#include "source_loc.h"
#include "string_interner.h"

void Preproc::set_const_symbols(const ConstSymbols& defs) {
    const_symbols = defs;
}

std::vector<Token> Preproc::preprocess(std::string_view filename) {
    // used for dumping tokens after tokenization, if requested
    StringInterner::Id cur_file_id = 0;

    // Final output token stream
    std::vector<Token> final_tokens;

    // -------------------------------------------------------------------------
    // 1. Load and tokenize the top-level file
    // -------------------------------------------------------------------------
    const SourceFile* file = g_file_mgr.get_source_file(filename, SourceLoc());
    if (!file) {
        // error already emitted by get_source_file()
        return final_tokens;
    }

    // Push initial include frame
    include_stack.push_back({
        file,
        file->file_id,              // logical_file_id
        0,                          // current_line
        false,                      // logical_line_fixed
        0                           // logical_line_offset
    });

    // add to dependency files for generation of .d file
    dependency_files.push_back(file->file_id);

    // -------------------------------------------------------------------------
    // 2. Unified input loop (files + macro-generated lines)
    // -------------------------------------------------------------------------
    while (true) {
        LogicalLine ll;
        bool have_line = false;

        // -----------------------------------------------------
        // 2a. Macro feedback queue has priority
        // -----------------------------------------------------
        if (!macro_work_queue.empty()) {
            ll = macro_work_queue.front();
            macro_work_queue.pop_front();
            have_line = true;
        }
        // -----------------------------------------------------
        // 2b. Otherwise read from include stack
        // -----------------------------------------------------
        else if (!include_stack.empty()) {
            auto& frame = include_stack.back();

            if (frame.current_line >= frame.file->lines_tokens.size()) {
                // End of this file
                include_stack.pop_back();
                continue;
            }

            const auto& raw_line =
                frame.file->lines_tokens[frame.current_line++];
            ll.tokens = raw_line;
            ll.loc = raw_line.empty() ? SourceLoc() : raw_line[0].loc;
            have_line = true;
        }

        // -----------------------------------------------------
        // 2c. No more input
        // -----------------------------------------------------
        if (!have_line) {
            break;
        }

        // ---------------------------------------------------------------------
        // 3. Directive processing
        // ---------------------------------------------------------------------
        LogicalLine processed;
        LineType type = process_directive_line(ll.tokens, processed);

        if (type == LineType::Skip) {
            continue;
        }

        if (type == LineType::ControlOnly) {
            continue;
        }

        if (g_args.options.dump_after_directives) {
            dump_logical_line(processed, cur_file_id);
        }

        // ---------------------------------------------------------------------
        // 4. Macro expansion
        // ---------------------------------------------------------------------
        std::vector<Token> expanded;
        expand_line(processed, expanded);   // may push into macro_work_queue

        if (g_args.options.dump_after_macro_expansion) {
            dump_tokens(expanded, cur_file_id);
        }

        // Append expanded tokens to final output
        final_tokens.insert(final_tokens.end(),
                            expanded.begin(), expanded.end());
    }

    // -------------------------------------------------------------------------
    // 5. Finalization checks
    // -------------------------------------------------------------------------
    if (!cond_stack.empty()) {
        g_diag.error(cond_stack.back().if_loc, "Unterminated IF block");
    }

    // TODO: check for unterminated classical MACRO/ENDM if needed

    if (g_args.options.dump_after_preprocessing) {
        dump_tokens(final_tokens, cur_file_id);
        exit(EXIT_SUCCESS);
    }

    if (g_args.options.dump_after_directives || g_args.options.dump_after_macro_expansion) {
        exit(EXIT_SUCCESS);
    }

    return final_tokens;
}
