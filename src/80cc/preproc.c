/*
 *      Small C+ Compiler
 *
 *      The rather simple preprocessor is here
 *
 *      $Id: preproc.c,v 1.4 2016-03-29 13:39:44 dom Exp $
 */

#include "ccdefs.h"
#include "tokeniser.h"

static void       ifline(void);


void junk(void)
{
    if (an(inbyte()))
        while (an(ch()))
            gch();
    else
        while (an(ch()) == 0) {
            if (ch() == 0)
                break;
            gch();
        }
    blanks();
}

char ch(void)
{
    return line[lptr];
}

char nch(void)
{
    if (ch())
        return line[lptr + 1];
    return 0;
}

char gch(void)
{
    if (ch()) {
        return line[lptr++];
    }
    return 0;
}

void clear(void)
{
    lptr = 0;
    line[0] = 0;
}

char inbyte(void)
{
    while (ch() == 0) {
        if (c_eof)
            return 0;
        preprocess();
    }
    return gch();
}

void vinline(void)
{
    int k;

    while (1) {
        if (input == NULL)
            openin();
        if (c_eof)
            return;
        clear();
        while ((k = getc(input)) > 0) {
            if (k == '\r') continue;
            if (k == '\n' || lptr >= LINEMAX)
                break;
            line[lptr++] = k;
        }
        line[lptr] = 0; /* append null */
        ++lineno;

        if (k <= 0) {
            fclose(input);
            input = 0;
            c_eof = 1;
        }
        if (lptr) {
            if (c_intermix_ccode && cmode) {
                /* Cache the source line so the walker / IR lowerer can
                   re-emit it interleaved with each statement's asm at
                   code-emit time (gen_comment here would be too early). */
                cache_source_line(lineno, line);
            }
            /* C_LINE directives are emitted at code-emit time (walker's
               cg2_emit_cline_for / IR lowerer's emit_op_cline), not at
               input-read time — emitting them here clusters them at the
               top of every function before any asm is produced. */
            /* Feed the line into the singleton tokeniser so it stays
               in lockstep with line[]. tk_feed_line appends an
               implicit '\n'; caller passes just the line content. */
            tk_feed_line(current_tokeniser, line);
            lptr = 0;
            return;
        }
    }
}

/*
 * ifline — read the next input line, handle the few preprocessor
 * directives sccz80 still acts on after ucpp has run:
 *   `# N "file"` / `#line N "file"`  — position attribution
 *   `#pragma …`                       — z88dk-specific extensions
 * Everything else (#include, #define, #undef, #ifdef, #ifndef,
 * #else, #endif) is handled by ucpp before we ever see the line.
 * `#asm` is dispatched separately from the parser body. */
void ifline(void)
{
    while (1) {
        vinline();
        if (c_eof)
            return;

        while (ch() == ' ' || ch() == '\t')
            gch();

        if (ch() == '#') {
            if (match("#pragma")) {
                dopragma();
                break;
            }
            if (match("# ") || match("#line")) {
                int num = 0, emitline = 0;
                char string[FILENAME_LEN + 1];
                string[0] = 0;
                sscanf(line + lptr, "%d %s", &num, string);
                if (num)
                    lineno = num - 1;

                if (strlen(string)) {
                    if ( strcmp(Filename, string)) {
                        emitline = 1;
                    }
                    strcpy(Filename, string);
                }
                if ( emitline ) {
                    gen_emit_line(lineno);
                }
                if (lineno == 0)
                    DoLibHeader();
                continue;
            }
        }

        if (ch() == 0)
            continue;

        break;
    }
}

/* Preprocessing is minimal - we need an external preprocessor */
void preprocess(void)
{
    ifline();
    return;
}

/* addmac / delmac / defmac / putmac and the macq[] / macptr buffer
   were sccz80's own macro table — fed by command-line -D/-U,
   #pragma define/undef, and `#define` directives, queried by
   `#ifdef` / `#ifndef` and by a few feature-flag checks in main.c
   (e.g. _FAR_PTR). Now that ucpp owns all macro expansion and
   sccz80 no longer parses any `#`-conditional directives, the
   table has no readers — removed. */

/* Source-line cache for -cc (intermix C source as comments). Each
   physical line of input is strdup'd into a per-file table keyed by
   (filename, lineno). The walker (cg2_emit_cline_for) looks up the
   line that owns each statement so the comments interleave with the
   asm body. Indexed by filename because `#include` resets lineno —
   without per-file keying, line 5 of foo.c and line 5 of foo.h would
   collide. Only populated when -cc / -gcline is active. */
typedef struct source_file_s {
    char  *name;          /* strdup'd; matches `Filename` snapshots */
    char **lines;
    int    cap;
    struct source_file_s *next;
} source_file_t;

static source_file_t *source_files = NULL;

static source_file_t *find_or_create_file(const char *name)
{
    if (!name) return NULL;
    for (source_file_t *f = source_files; f; f = f->next) {
        if (strcmp(f->name, name) == 0) return f;
    }
    source_file_t *f = MALLOC(sizeof(*f));
    f->name = strdup(name);
    f->lines = NULL;
    f->cap = 0;
    f->next = source_files;
    source_files = f;
    return f;
}

void cache_source_line(int n, const char *text)
{
    if (n <= 0) return;
    source_file_t *f = find_or_create_file(Filename);
    if (!f) return;
    if (n >= f->cap) {
        int new_cap = f->cap ? f->cap * 2 : 256;
        while (n >= new_cap) new_cap *= 2;
        f->lines = REALLOC(f->lines, new_cap * sizeof(*f->lines));
        for (int i = f->cap; i < new_cap; i++) f->lines[i] = NULL;
        f->cap = new_cap;
    }
    if (f->lines[n]) free(f->lines[n]);
    f->lines[n] = strdup(text);
}

const char *get_source_line(const char *filename, int n)
{
    if (n <= 0 || !filename) return NULL;
    for (source_file_t *f = source_files; f; f = f->next) {
        if (strcmp(f->name, filename) == 0) {
            if (n >= f->cap) return NULL;
            return f->lines[n];
        }
    }
    return NULL;
}
