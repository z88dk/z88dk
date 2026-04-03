//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "lexer_dump.h"
#include "options.h"
#include "preproc_context.h"
#include "preproc_directives.h"
#include "preproc_driver.h"
#include "preproc_dump.h"
#include "preproc_macro.h"
#include "source_file.h"
#include <cstdlib>
#include <string_view>

/* -------------------------------------------------------------------------
   Preprocessor Flow (preproc_driver.cpp)
   -------------------------------------------------------------------------

   High-level pipeline for:

       std::vector<Token> preprocess(std::string_view filename)

   The preprocessor is eager and layered. Each layer is independently
   testable via -dump-after-* options.

   NEW: Classical macro expansion may emit directive lines. These must be
   fed back into the directive engine before normal macro expansion
   continues. This creates a controlled feedback loop.

   -------------------------------------------------------------------------
   1. Initialization
   -------------------------------------------------------------------------

   - Create PreprocessorContext ctx.
   - Tokenize the initial file.
   - Push initial IncludeFrame onto ctx.include_stack.
   - Create an empty deque<LogicalLine> macro_work_queue.

   -------------------------------------------------------------------------
   2. Unified Input Loop (Files + Macro-Generated Lines)
   -------------------------------------------------------------------------

   while (true):

       if (!macro_work_queue.empty()):
           // Feedback loop: directive lines emitted by macro expansion
           LogicalLine ll = macro_work_queue.pop_front();
           source = "macro-generated";
       else if (!ctx.include_stack.empty()):
           // Normal file input
           read next line from top IncludeFrame
           LogicalLine ll = convert to LogicalLine
           source = "file";
       else:
           break; // No more input

       LineType type =
           process_directive_line(ctx, ll.tokens, processed_ll);

       switch (type):

           case LineType::Skip:
               continue;

           case LineType::ControlOnly:
               // Directive handled; may have modified ctx
               continue;

           case LineType::Normal:
               // Send to macro expansion
               expanded = expand_line(ctx, processed_ll, macro_work_queue);
               // expand_line may push new directive lines into macro_work_queue
               append expanded tokens to final output
               continue;

   -------------------------------------------------------------------------
   3. Termination Checks
   -------------------------------------------------------------------------

   - If ctx.cond_stack not empty -> error: unterminated IF.
   - If inside classical macro definition -> error: unterminated MACRO/ENDM.

   -------------------------------------------------------------------------
   4. Return Final Token Stream
   -------------------------------------------------------------------------

   - Flat vector<Token> with EndOfLine markers preserved.

   -------------------------------------------------------------------------
   End of Preprocessor Flow
   ------------------------------------------------------------------------- */

// -----------------------------------------------------------------------------
// Public API (unchanged)
// -----------------------------------------------------------------------------
std::vector<Token> preprocess(std::string_view filename) {
    ConstSymbols empty;
    return preprocess(filename, empty);
}

// -----------------------------------------------------------------------------
// New API: accepts initial -D symbols
// -----------------------------------------------------------------------------
std::vector<Token> preprocess(std::string_view filename,
                              const ConstSymbols& initial_symbols) {
    PreprocessorContext ctx;
    StringInterner::Id cur_file_id = 0;

    // Inject -DNAME=expr symbols
    ctx.const_symbols = initial_symbols;

    // Final output token stream
    std::vector<Token> final_tokens;

    // -------------------------------------------------------------------------
    // 1. Load and tokenize the top-level file
    // -------------------------------------------------------------------------
    const SourceFile* file = get_source_file(filename, SourceLoc());
    if (!file) {
        // error already emitted by get_source_file()
        return final_tokens;
    }

    // Push initial include frame
    ctx.include_stack.push_back({
        file,
        0,                          // current_line
        file->file_id,              // logical_file_id
        1                           // logical_line
    });
    ctx.dependency_files.push_back(file->file_id);

    // -------------------------------------------------------------------------
    // 2. Unified input loop (files + macro-generated lines)
    // -------------------------------------------------------------------------
    while (true) {
        LogicalLine ll{};
        bool have_line = false;

        // -----------------------------------------------------
        // 2a. Macro feedback queue has priority
        // -----------------------------------------------------
        if (!ctx.macro_work_queue.empty()) {
            ll = ctx.macro_work_queue.front();
            ctx.macro_work_queue.pop_front();
            have_line = true;
        }
        // -----------------------------------------------------
        // 2b. Otherwise read from include stack
        // -----------------------------------------------------
        else if (!ctx.include_stack.empty()) {
            auto& frame = ctx.include_stack.back();

            if (frame.current_line >= frame.file->lines_tokens.size()) {
                // End of this file
                ctx.include_stack.pop_back();
                continue;
            }

            const auto& raw_line =
                frame.file->lines_tokens[frame.current_line++];
            ll.tokens = raw_line;
            ll.loc = raw_line.empty() ? SourceLoc{} :
                     raw_line[0].loc;
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
        LogicalLine processed{};
        LineType type = process_directive_line(ctx, ll.tokens, processed);

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
        expand_line(ctx, processed, expanded);   // may push into ctx.macro_work_queue

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
    if (!ctx.cond_stack.empty()) {
        error(ctx.cond_stack.back().if_loc, "Unterminated IF block");
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
