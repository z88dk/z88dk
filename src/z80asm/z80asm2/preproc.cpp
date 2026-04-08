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

bool Preproc::next_logical_line(LogicalLine& out) {
    // -----------------------------------------------------
    // Assembler output queue has priority
    // -----------------------------------------------------
    if (!assembler_output_queue.empty()) {
        out = assembler_output_queue.front();
        assembler_output_queue.pop_front();

        out.origin = LineOrigin::ReadyToAssemble;
        return true;
    }

    // -----------------------------------------------------
    // Macro feedback queue comes next
    // -----------------------------------------------------
    if (!macro_work_queue.empty()) {
        out = macro_work_queue.front();
        macro_work_queue.pop_front();
        out.origin = LineOrigin::MacroFeedback;
        return true;
    }

    // -----------------------------------------------------
    // Otherwise read from include stack
    // -----------------------------------------------------
    while (!include_stack.empty()) {
        auto& frame = include_stack.back();

        if (frame.current_line >= frame.file->lines_tokens.size()) {
            // End of this file
            include_stack.pop_back();
            continue;
        }

        const auto& raw_line =
            frame.file->lines_tokens[frame.current_line++];
        out.tokens = raw_line;
        out.loc = raw_line.empty() ? SourceLoc() : raw_line[0].loc;
        out.origin = LineOrigin::RawInput;
        return true;
    }

    // no more input
    return false;
}

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
    LogicalLine ll;
    while (next_logical_line(ll)) {

        // ---------------------------------------------------------------------
        // 3. Directive processing
        // ---------------------------------------------------------------------
        LogicalLine processed;
        LineType type;
        if (ll.origin == LineOrigin::ReadyToAssemble) {
            // Lines from assembler_output_queue are already processed
            // and should not go through directive processing again
            // (e.g. DEFINE X=1 -> DEFC X=1 should not be processed again
            processed = ll;
            type = LineType::Normal;
        }
        else {
            type = process_directive_line(ll.tokens, processed);
        }

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
        if (ll.origin == LineOrigin::ReadyToAssemble) {
            // Lines from assembler_output_queue should not be macro expanded
            // (e.g. DEFINE X=1 -> DEFC X=1 should not have X replaced by 1)
            expanded = processed.tokens;
        }
        else {
            // may push into macro_work_queue
            expand_line(processed, expanded);
        }

        if (g_args.options.dump_after_macro_expansion) {
            dump_tokens(expanded, cur_file_id);
        }

        // Hook: need to parse DEFC, EQU and = so that assembly symbols
        // are known in the preprocessor and can be used in IF expressions.
        // e.g. X EQU 1 // IF X --> show know the value of X
        parse_asm_definitions(expanded);

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

    if (g_args.options.dump_after_macro_expansion) {
        dump_macros();
        exit(EXIT_SUCCESS);
    }

    if (g_args.options.dump_after_directives) {
        exit(EXIT_SUCCESS);
    }

    return final_tokens;
}

