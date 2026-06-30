/*
 * sccz80 internal tokeniser — TOKENIZER_PLAN Phase L2.
 *
 * First slice: skeleton + Tokeniser state + lazy peek buffer + lex
 * for whitespace, identifiers, integer literals (decimal/hex/octal),
 * char literals, string literals (without adjacent-concat yet),
 * single-char punctuators. Subsequent slices add multi-char
 * punctuators, keyword classification, suffix-aware numeric parse,
 * adjacent string concat, #line / #pragma / __asm.
 *
 * Parser-side code is untouched in this phase. The `--lex-only`
 * driver in main.c is the sole consumer for now.
 */

#include "ccdefs.h"
#include "tokeniser.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

/* Initial token-buffer capacity. Grows as needed via realloc. */
#define TK_BUF_INITIAL 64

/* Keyword table — flat linear lookup. ~64 entries fits easily in L1d
   and the lex hot path isn't string-heavy, so a perfect/open-addressed
   hash is over-engineering for the current size. Promote when measured
   if it becomes a bottleneck. */
typedef struct { const char *name; int kw_id; } KeywordEntry;

static const KeywordEntry tk_keywords[] = {
    /* A1 */
    {"char",        KW_CHAR},     {"short",       KW_SHORT},
    {"int",         KW_INT},      {"long",        KW_LONG},
    {"signed",      KW_SIGNED},   {"unsigned",    KW_UNSIGNED},
    {"float",       KW_FLOAT},    {"double",      KW_DOUBLE},
    {"void",        KW_VOID},     {"struct",      KW_STRUCT},
    {"union",       KW_UNION},    {"enum",        KW_ENUM},
    {"typedef",     KW_TYPEDEF},  {"extern",      KW_EXTERN},
    {"static",      KW_STATIC},   {"auto",        KW_AUTO},
    {"const",       KW_CONST},    {"register",    KW_REGISTER},
    {"restrict",    KW_RESTRICT}, {"volatile",    KW_VOLATILE},
    {"sizeof",      KW_SIZEOF},
    /* A2 */
    {"if",          KW_IF},       {"else",        KW_ELSE},
    {"while",       KW_WHILE},    {"do",          KW_DO},
    {"for",         KW_FOR},      {"switch",      KW_SWITCH},
    {"case",        KW_CASE},     {"default",     KW_DEFAULT},
    {"break",       KW_BREAK},    {"continue",    KW_CONTINUE},
    {"goto",        KW_GOTO},     {"return",      KW_RETURN},
    /* A3 */
    {"_Static_assert", KW_STATIC_ASSERT},
    {"_Accum",      KW_ACCUM},    {"_Float16",    KW_FLOAT16},
    /* A4 */
    {"__addressmod",     KW_ADDRESSMOD},
    {"__at",             KW_AT},
    {"__banked",         KW_BANKED},
    {"__nonbanked",      KW_NONBANKED},
    {"__critical",       KW_CRITICAL},
    {"__far",            KW_FAR_LONG},
    {"__interrupt",      KW_INTERRUPT},
    {"__naked",          KW_NAKED},
    {"__preserves_regs", KW_PRESERVES_REGS},
    {"__sfr",            KW_SFR},
    {"near",             KW_NEAR},
    {"far",              KW_FAR},
    /* A5 */
    {"__smallc",                 KW_SMALLC},
    {"__stdc",                   KW_STDC},
    {"__z88dk_callee",           KW_Z88DK_CALLEE},
    {"__z88dk_fastcall",         KW_Z88DK_FASTCALL},
    {"__z88dk_hl_call",          KW_Z88DK_HL_CALL},
    {"__z88dk_params_offset",    KW_Z88DK_PARAMS_OFFSET},
    {"__z88dk_saveframe",        KW_Z88DK_SAVEFRAME},
    {"__z88dk_sdccdecl",         KW_Z88DK_SDCCDECL},
    {"__sdcccall",               KW_SDCCCALL},
    {"__z88dk_shortcall",        KW_Z88DK_SHORTCALL},
    {"__z88dk_shortcall_hl",     KW_Z88DK_SHORTCALL_HL},
    {"__CALLEE__",               KW_CALLEE_LEGACY},
    {"__FASTCALL__",             KW_FASTCALL_LEGACY},
    {"__LIB__",                  KW_LIB_LEGACY},
    {"__SAVEFRAME__",            KW_SAVEFRAME_LEGACY},
    /* A6 */
    {"return_c",                 KW_RETURN_C},
    {"return_nc",                KW_RETURN_NC},
    {"iferror",                  KW_IFERROR},
    {NULL, 0}
};

int tk_lookup_keyword(const char *name)
{
    for (const KeywordEntry *e = tk_keywords; e->name; e++) {
        if (strcmp(name, e->name) == 0) return e->kw_id;
    }
    return KW_NONE;
}

const char *tk_keyword_name(int kw_id)
{
    for (const KeywordEntry *e = tk_keywords; e->name; e++) {
        if (e->kw_id == kw_id) return e->name;
    }
    return "?";
}

struct Tokeniser {
    /* One of `input` or `buf` is active. FILE mode reads via fgetc;
       buffer mode reads from a growable byte buffer fed line-by-line
       via tk_feed_line(). Both share the pushback / token-ring
       state. */
    FILE       *input;      /* NULL in buffer mode */
    char       *buf;        /* growable byte buffer (buffer mode) */
    int         buf_len;    /* bytes currently in buf */
    int         buf_cap;    /* allocated capacity of buf */
    int         buf_pos;    /* next byte to read from buf */

    /* Buffer-mode refill callback. Called when buf_pos >= buf_len
       to request more bytes. NULL means the caller is responsible
       for feeding via tk_feed_line() before peeking. */
    tk_refill_fn refill;
    void       *refill_user;
    int         refill_done; /* refill returned 0 — definitely EOF */

    /* Buffer-mode position tracking for the L3 shim layer. Set by
       tk_feed_line — records where the current line begins in the
       accumulated byte buffer. Mapping: legacy `lptr` + this gives
       the absolute buf-position the parser is at, so shims can
       align the tokeniser before peeking. */
    int         current_line_start;

    const char *filename;   /* current source attribution */
    int         lineno;     /* current source line */

    /* Pushback buffer for un-consumed characters — needed for the
       multi-char lookaheads (e.g. distinguishing `<` from `<<` from
       `<<=`). Two-deep is enough for everything we lex. */
    int         pushback[4];
    int         pb_n;

    /* "At start of line" — true at file start and after every
       newline consumed by the whitespace skip; cleared as soon as
       a real (non-directive) token is produced. Drives `#`
       directive detection: only `#` at SOL is a preprocessor
       directive. */
    int         at_sol;

    /* Token ring — peek/consume operate on this growing buffer.
       `head` is the index of the current (peek(0)) token. `tail`
       is one past the last filled token. Grows when peek(n) needs
       more lookahead. */
    Token      *tokens;
    int         tok_cap;
    int         head;
    int         tail;

    int         at_eof;     /* underlying input exhausted */
};

/* ---------- character-stream layer ---------- */

/* Read one byte from the underlying source. Returns -1 at EOF
   (FILE mode) or at buffer exhaustion (buffer mode — caller may
   feed more bytes and call tk_peek again). Handles CR/LF
   normalisation: bare CR → LF, CR LF → LF. */
static int tk_getc(Tokeniser *t)
{
    if (t->pb_n > 0) {
        return t->pushback[--t->pb_n];
    }
    int c;
    if (t->input) {
        c = fgetc(t->input);
        if (c == '\r') {
            c = fgetc(t->input);
            if (c != '\n') {
                if (c != EOF) ungetc(c, t->input);
                return '\n';
            }
        }
        if (c == EOF) { t->at_eof = 1; return -1; }
        return c;
    }
    /* Buffer mode. Pull more bytes via the refill callback if the
       buffer is exhausted and EOF hasn't been signalled. */
    while (t->buf_pos >= t->buf_len) {
        if (t->refill_done || !t->refill) {
            t->at_eof = 1;
            return -1;
        }
        if (t->refill(t, t->refill_user) == 0) {
            t->refill_done = 1;
        }
    }
    c = (unsigned char)t->buf[t->buf_pos++];
    if (c == '\r') {
        if (t->buf_pos < t->buf_len && t->buf[t->buf_pos] == '\n') {
            t->buf_pos++;
        }
        return '\n';
    }
    return c;
}

static void tk_ungetc(Tokeniser *t, int c)
{
    if (c < 0) return;
    if (t->pb_n >= (int)(sizeof t->pushback / sizeof t->pushback[0])) {
        errorfmt("tokeniser: pushback overflow (internal error)", 1);
        return;
    }
    t->pushback[t->pb_n++] = c;
}

static int tk_peekc(Tokeniser *t)
{
    int c = tk_getc(t);
    tk_ungetc(t, c);
    return c;
}

/* ---------- token ring ---------- */

static void tk_grow(Tokeniser *t)
{
    int new_cap = t->tok_cap * 2;
    Token *nt = realloc(t->tokens, sizeof(Token) * new_cap);
    if (!nt) {
        errorfmt("tokeniser: out of memory", 1);
        return;
    }
    t->tokens = nt;
    t->tok_cap = new_cap;
}

static Token *tk_alloc(Tokeniser *t)
{
    if (t->tail >= t->tok_cap) tk_grow(t);
    Token *tok = &t->tokens[t->tail++];
    memset(tok, 0, sizeof *tok);
    tok->file = t->filename;
    return tok;
}

/* ---------- per-token lexers ---------- */

static int is_ident_start(int c) { return isalpha(c) || c == '_'; }
static int is_ident_cont(int c)  { return isalnum(c) || c == '_'; }
static void lex_asm_block(Tokeniser *t, Token *tok, const char *terminator);

static void lex_skip_whitespace_and_comments(Tokeniser *t)
{
    for (;;) {
        int c = tk_getc(t);
        if (c < 0) return;
        if (c == '\n') { t->lineno++; t->at_sol = 1; continue; }
        if (isspace(c)) continue;
        if (c == '/') {
            int n = tk_peekc(t);
            if (n == '/') {
                /* Line comment — should be rare post-ucpp, but
                   handle defensively. */
                while ((c = tk_getc(t)) >= 0 && c != '\n') {}
                if (c == '\n') t->lineno++;
                continue;
            }
            if (n == '*') {
                tk_getc(t);   /* consume '*' */
                int prev = 0;
                while ((c = tk_getc(t)) >= 0) {
                    if (c == '\n') t->lineno++;
                    if (prev == '*' && c == '/') break;
                    prev = c;
                }
                continue;
            }
        }
        tk_ungetc(t, c);
        return;
    }
}

static void lex_ident(Tokeniser *t, Token *tok, int first)
{
    char buf[TK_NAME_MAX + 1];
    int len = 0;
    buf[len++] = (char)first;
    int c;
    while ((c = tk_getc(t)) >= 0 && is_ident_cont(c)) {
        if (len < TK_NAME_MAX) buf[len++] = (char)c;
    }
    if (c >= 0) tk_ungetc(t, c);
    buf[len] = 0;
    /* `__asm` switches to raw-block mode — accumulate everything
       up to the `__endasm` terminator and emit TK_ASM_BLOCK.
       Function-form `asm("…")` / `__asm__("…")` is left alone (the
       parser dispatches those by callee name in callfunc.c). */
    if (strcmp(buf, "__asm") == 0) {
        lex_asm_block(t, tok, "__endasm");
        return;
    }
    int kw = tk_lookup_keyword(buf);
    if (kw != KW_NONE) {
        tok->kind = TK_KEYWORD;
        tok->kw_id = kw;
        tok->text = strdup(buf);  /* keep the spelling for diagnostics */
    } else {
        tok->kind = TK_IDENT;
        tok->text = strdup(buf);
    }
}

/* Parse an integer suffix following the digits. Letters are case-
   insensitive. Recognises (in any order): U, L, LL — with U+L, U+LL
   combinations. Sets `*kind_out` to KIND_INT / KIND_LONG / KIND_LONGLONG
   and `*unsigned_out` to 0/1. Returns 1 if any suffix letters were
   consumed, 0 if not (suffix-less integer). */
static int lex_int_suffix(Tokeniser *t, int *kind_out, int *unsigned_out)
{
    int got_u = 0, got_l = 0, consumed = 0;
    int c = tk_getc(t);
    /* Walk up to ~4 suffix letters. C standard suffixes are U/L/LL
       and their UL/LU/ULL/LLU combinations. `S` is a sccz80 legacy
       extension meaning "explicit signed" — semantically the
       default, but consumed so source like `42S` still tokenises. */
    for (int i = 0; i < 4 && c >= 0; i++) {
        int up = toupper(c);
        if (up == 'U' && !got_u) {
            got_u = 1; consumed = 1;
            c = tk_getc(t);
            continue;
        }
        if (up == 'L') {
            if (got_l == 0) {
                got_l = 1;
                consumed = 1;
                int n = tk_peekc(t);
                if (toupper(n) == 'L') {
                    tk_getc(t);
                    got_l = 2;
                }
                c = tk_getc(t);
                continue;
            }
        }
        if (c == 'S') { /* sccz80 legacy — explicit signed, default */
            consumed = 1;
            c = tk_getc(t);
            continue;
        }
        break;
    }
    if (c >= 0) tk_ungetc(t, c);
    *unsigned_out = got_u;
    if      (got_l == 2) *kind_out = KIND_LONGLONG;
    else if (got_l == 1) *kind_out = KIND_LONG;
    else                 *kind_out = KIND_INT;
    return consumed;
}

/* Float-literal suffix lex. Recognises (case-insensitive on `f`/`F`,
   case-sensitive on `hk`/`k`/`lk`):
     (none)           → KIND_DOUBLE
     `f` / `F`        → KIND_DOUBLE (sccz80 has no single-precision
                        float distinct from double)
     `f16` / `F16`    → KIND_FLOAT16 (explicit half-precision)
     `hk` / `k`       → KIND_ACCUM16 (Embedded-C short/std _Accum)
     `lk`             → KIND_ACCUM32 (Embedded-C long _Accum)
   Mirrors const.c's existing amatch chain. Unsigned _Accum variants
   are picked up elsewhere when present — deferred. */
static int lex_float_suffix(Tokeniser *t)
{
    int c = tk_getc(t);
    if (c == 'f' || c == 'F') {
        /* Standard `f`/`F` is a no-op for sccz80's double-precision
           default; `f16`/`F16` distinguishes half-precision. */
        int n = tk_peekc(t);
        if (n == '1') {
            tk_getc(t);
            int n2 = tk_peekc(t);
            if (n2 == '6') { tk_getc(t); return KIND_FLOAT16; }
            tk_ungetc(t, '1');
        }
        return KIND_DOUBLE;
    }
    if (c == 'h') {
        if (tk_peekc(t) == 'k') { tk_getc(t); return KIND_ACCUM16; }
        tk_ungetc(t, c);
        return KIND_DOUBLE;
    }
    if (c == 'l') {
        if (tk_peekc(t) == 'k') { tk_getc(t); return KIND_ACCUM32; }
        tk_ungetc(t, c);
        return KIND_DOUBLE;
    }
    if (c == 'k') return KIND_ACCUM16;
    if (c >= 0) tk_ungetc(t, c);
    return KIND_DOUBLE;
}

/* Float-literal lex helper. Reads from the *current* position
   (after the leading digit run and the `.` / `e` / `E`) and parses
   the whole thing via strtold into a zdouble. We pass a string
   buffer that captures everything from the leading digit onwards
   so strtold sees the full literal. Suffix-aware: `f`/`F` →
   KIND_FLOAT16, otherwise KIND_DOUBLE. */
static void lex_float_tail(Tokeniser *t, Token *tok,
                            char *digit_buf, int digit_len)
{
    /* `digit_buf[0..digit_len)` is the integer-portion digits we
       already consumed. Continue reading the fractional / exponent
       part directly into the same buffer, then strtold it. */
    int len = digit_len;
    int c = tk_getc(t);
    /* fractional part (if present) */
    if (c == '.') {
        if (len < TK_NAME_MAX) digit_buf[len++] = '.';
        c = tk_getc(t);
        while (c >= 0 && isdigit(c)) {
            if (len < TK_NAME_MAX) digit_buf[len++] = (char)c;
            c = tk_getc(t);
        }
    }
    /* exponent (if present) */
    if (c == 'e' || c == 'E') {
        if (len < TK_NAME_MAX) digit_buf[len++] = (char)c;
        c = tk_getc(t);
        if (c == '+' || c == '-') {
            if (len < TK_NAME_MAX) digit_buf[len++] = (char)c;
            c = tk_getc(t);
        }
        while (c >= 0 && isdigit(c)) {
            if (len < TK_NAME_MAX) digit_buf[len++] = (char)c;
            c = tk_getc(t);
        }
    }
    /* `c` holds the first non-digit char past the body (or -1 at
       EOF). Push it back so lex_float_suffix sees it as the first
       suffix char. */
    if (c >= 0) tk_ungetc(t, c);
    digit_buf[len] = 0;
    int fkind = lex_float_suffix(t);
    tok->kind = TK_FLOAT;
    tok->fval = (zdouble)strtold(digit_buf, NULL);
    tok->fkind = fkind;
}

/* Integer literal parse. Decimal / 0x hex / 0 octal. Promotes to
   a float literal if a `.` / `e` / `E` follows the integer digits
   (only valid for decimal — hex floats deferred). Integer suffix
   parse: U / L / LL combinations, sets tok->num.{kind,isunsigned}.
   No suffix: KIND_INT, promoted to KIND_LONG if value exceeds
   16-bit signed range. */
static void lex_number(Tokeniser *t, Token *tok, int first)
{
    int64_t value = 0;
    int base = 10;
    char digit_buf[TK_NAME_MAX + 1];
    int digit_len = 0;
    int c = first;
    /* Handle base prefix on a leading `0`. The prefix character(s)
       are captured into digit_buf so a downstream float-tail rebuild
       sees the same text the user wrote. */
    if (first == '0') {
        int n = tk_peekc(t);
        if (n == 'x' || n == 'X') {
            digit_buf[digit_len++] = '0';
            digit_buf[digit_len++] = (char)tk_getc(t);
            base = 16;
            c = tk_getc(t);
        } else if (n == 'b' || n == 'B') {
            /* Binary literal `0b...` — non-standard C but supported
               by sccz80 (and gcc/clang). Pre-parsed here so the
               legacy const.c::number() can be retired. */
            digit_buf[digit_len++] = '0';
            digit_buf[digit_len++] = (char)tk_getc(t);
            base = 2;
            c = tk_getc(t);
        } else if (n >= '0' && n <= '7') {
            digit_buf[digit_len++] = '0';
            base = 8;
            c = tk_getc(t);
        }
        /* else: lone 0 or `0.` — fall through to the general digit
           loop with c == '0' so the digit gets consumed normally. */
    }
    /* Special entry for the `.NNN` form: caller passes `.` as
       `first`, base stays 10. Capture the dot into digit_buf and
       skip the integer-digit loop — go straight to float-tail. */
    if (first == '.') {
        digit_buf[digit_len++] = '.';
        c = tk_getc(t);
        while (c >= 0 && isdigit(c)) {
            if (digit_len < TK_NAME_MAX) digit_buf[digit_len++] = (char)c;
            c = tk_getc(t);
        }
        /* optional exponent */
        if (c == 'e' || c == 'E') {
            if (digit_len < TK_NAME_MAX) digit_buf[digit_len++] = (char)c;
            c = tk_getc(t);
            if (c == '+' || c == '-') {
                if (digit_len < TK_NAME_MAX) digit_buf[digit_len++] = (char)c;
                c = tk_getc(t);
            }
            while (c >= 0 && isdigit(c)) {
                if (digit_len < TK_NAME_MAX) digit_buf[digit_len++] = (char)c;
                c = tk_getc(t);
            }
        }
        if (c >= 0) tk_ungetc(t, c);
        digit_buf[digit_len] = 0;
        int fkind = lex_float_suffix(t);
        tok->kind = TK_FLOAT;
        tok->fval = (zdouble)strtold(digit_buf, NULL);
        tok->fkind = fkind;
        return;
    }
    /* Read the digit body. `c` holds the next char to inspect. */
    while (c >= 0) {
        int d = -1;
        if (base == 16) {
            if (isdigit(c)) d = c - '0';
            else if (c >= 'a' && c <= 'f') d = c - 'a' + 10;
            else if (c >= 'A' && c <= 'F') d = c - 'A' + 10;
        } else if (base == 8) {
            if (c >= '0' && c <= '7') d = c - '0';
        } else if (base == 2) {
            if (c == '0' || c == '1') d = c - '0';
        } else {
            if (isdigit(c)) d = c - '0';
        }
        if (d < 0) break;
        if (digit_len < TK_NAME_MAX) digit_buf[digit_len++] = (char)c;
        /* Accumulate in unsigned: a full-width constant like 0x8000…0000
           overflows int64_t, and signed overflow is UB (host-divergent).
           Unsigned wraps with a defined bit pattern; reinterpret as int64. */
        value = (int64_t)((uint64_t)value * (uint64_t)base + (uint64_t)d);
        c = tk_getc(t);
    }
    /* Float fall-through: decimal `.` / `e` / `E` after digits. */
    if (base == 10 && (c == '.' || c == 'e' || c == 'E')) {
        tk_ungetc(t, c);
        lex_float_tail(t, tok, digit_buf, digit_len);
        return;
    }
    if (c >= 0) tk_ungetc(t, c);
    int s_kind = KIND_INT;
    int s_unsigned = 0;
    lex_int_suffix(t, &s_kind, &s_unsigned);
    /* No-suffix size promotion: int → long when out of 16-bit range.
       A hex/octal/binary (or U-suffixed) constant may take the UNSIGNED
       type of its rank first (C integer-constant rule), so a value that
       still fits in 16 unsigned bits stays KIND_INT — const.c marks it
       unsigned. Only a plain DECIMAL constant is signed-only and leaves
       16-bit range past INT_MAX. (Without this `0xffff` became `long` and
       was pushed as a 4-byte arg, mis-aligning callee stack frames.) */
    if (s_kind == KIND_INT) {
        if (s_unsigned || base != 10) {
            if ((uint64_t)value > 65535) s_kind = KIND_LONG;
        } else {
            if (value > 32767 || value < -32768) s_kind = KIND_LONG;
        }
    }
    tok->kind = TK_NUMBER;
    tok->num.value = value;
    tok->num.kind = s_kind;
    tok->num.isunsigned = s_unsigned;
    tok->num.base = base;
}

/* Char literal — single char, simple escapes. Stores the value as a
   TK_CHAR with num.kind = KIND_CHAR. */
static int lex_escape(Tokeniser *t)
{
    int c = tk_getc(t);
    switch (c) {
    case 'a':  return 7;
    case 'b':  return 8;
    case 't':  return 9;
    case 'n':  return 10;   /* standard LF — sccz80's legacy default
                               (\n=13, \r=10) was retired with the
                               c_standard_escapecodes flag. */
    case 'v':  return 11;
    case 'f':  return 12;
    case 'r':  return 13;
    case 'e':  return 27;   /* ESC (GCC extension, sccz80 inherits) */
    case '\\': return '\\';
    case '\'': return '\'';
    case '"':  return '"';
    case '?':  return '?';  /* literal `?` — disables trigraphs */
    case 'x': {
        int v = 0, digits = 0;
        for (int i = 0; i < 2; i++) {
            int d = tk_peekc(t);
            if (isxdigit(d)) {
                tk_getc(t);
                if (isdigit(d))            v = v*16 + (d - '0');
                else if (d >= 'a' && d <= 'f') v = v*16 + (d - 'a' + 10);
                else                        v = v*16 + (d - 'A' + 10);
                digits++;
            } else break;
        }
        if (digits && isxdigit(tk_peekc(t))) {
            warningfmt("parser", "Hex escape sequence out of range");
            /* eat extra digits to keep parser in sync */
            while (isxdigit(tk_peekc(t))) tk_getc(t);
        }
        return v;
    }
    case '0': case '1': case '2': case '3':
    case '4': case '5': case '6': case '7': {
        /* Octal: 1-3 digits, first already consumed in `c`. */
        int v = c - '0';
        for (int i = 0; i < 2; i++) {
            int d = tk_peekc(t);
            if (d >= '0' && d <= '7') {
                tk_getc(t);
                v = v*8 + (d - '0');
            } else break;
        }
        return v;
    }
    default:
        warningfmt("parser", "Unknown escape sequence \\%c", c);
        return c;
    }
}

static void lex_char(Tokeniser *t, Token *tok)
{
    int c = tk_getc(t);
    int v = (c == '\\') ? lex_escape(t) : c;
    int close = tk_getc(t);
    if (close != '\'') {
        errorfmt("malformed character literal", 1);
        while (close >= 0 && close != '\'' && close != '\n') close = tk_getc(t);
    }
    tok->kind = TK_CHAR;
    tok->num.value = v;
    tok->num.kind = KIND_CHAR;
    tok->num.isunsigned = 0;
}

/* String literal — collects until closing `"`. C99 adjacent-literal
   concat: after the closing `"` of one literal, peek past whitespace
   / comments; if the next non-blank char is another `"`, consume it
   and keep appending into the same buffer. The parser sees a single
   TK_STRING regardless of how many adjacent literals were written. */
static void lex_string(Tokeniser *t, Token *tok)
{
    char buf[TK_STRING_MAX];
    int len = 0;
    for (;;) {
        int c;
        while ((c = tk_getc(t)) >= 0 && c != '"') {
            if (c == '\n') {
                errorfmt("unterminated string literal", 1);
                t->lineno++;
                goto done;
            }
            int v = (c == '\\') ? lex_escape(t) : c;
            if (len < TK_STRING_MAX) buf[len++] = (char)v;
        }
        if (c < 0) goto done;
        /* Closing `"` consumed. Peek past whitespace/comments for
           the next adjacent literal. If none, rewind so the
           trailing whitespace doesn't get absorbed into this
           token's source span — the L3 shim layer uses
           source_end to advance the parser's `lptr` and lex line
           buf only has line content (no implicit '\n'), so
           swallowing trailing whitespace here would over-advance
           lptr into the prior line's stale bytes. */
        int saved_pos = t->buf_pos;
        int saved_lineno = t->lineno;
        int saved_at_sol = t->at_sol;
        lex_skip_whitespace_and_comments(t);
        if (tk_peekc(t) != '"') {
            t->buf_pos = saved_pos;
            t->lineno = saved_lineno;
            t->at_sol = saved_at_sol;
            t->pb_n = 0;
            goto done;
        }
        tk_getc(t);   /* consume opening `"` of the next literal */
    }
done:
    tok->kind = TK_STRING;
    tok->text = malloc(len + 1);
    if (tok->text) {
        memcpy(tok->text, buf, len);
        tok->text[len] = 0;
    }
    tok->text_len = len;
}

/* Consume a preprocessor directive line. Caller has already
   consumed the leading `#`. Returns:
     1  → emitted a token (TK_PRAGMA) into *tok.
     0  → directive consumed silently (e.g. `#line`); caller should
          re-enter lex_one for the next real token.
   Two recognised forms:
     `#line N "file"` or `# N "file"` (gcc passthrough) — update
       t->lineno + t->filename, return 0.
     `#pragma BODY` — emit TK_PRAGMA with `text` = BODY (after the
       `#pragma` keyword and any following whitespace), return 1.
   Any other directive is a hard error — post-ucpp input shouldn't
   contain `#include` / `#if` / `#define` / etc. */
static int lex_pp_directive(Tokeniser *t, Token *tok)
{
    /* Collect rest of line into a fixed buffer; ucpp emits one
       directive per line. LINESIZE matches the parser's `line[]`. */
    char line[1024];
    int len = 0;
    int c;
    while ((c = tk_getc(t)) >= 0 && c != '\n') {
        if (len < (int)sizeof line - 1) line[len++] = (char)c;
    }
    if (c == '\n') { t->lineno++; t->at_sol = 1; }
    line[len] = 0;

    /* Skip leading whitespace after the `#`. */
    char *p = line;
    while (*p == ' ' || *p == '\t') p++;

    /* Optional `line` keyword — gcc emits `# N "file"` without it. */
    if (strncmp(p, "line", 4) == 0 && (p[4] == ' ' || p[4] == '\t')) {
        p += 4;
        while (*p == ' ' || *p == '\t') p++;
    }

    /* `N "file"` position-attribution form. */
    if (isdigit((unsigned char)*p)) {
        int ln = (int)strtol(p, &p, 10);
        while (*p == ' ' || *p == '\t') p++;
        if (*p == '"') {
            char *start = ++p;
            while (*p && *p != '"') p++;
            *p = 0;
            /* Intern the filename — small, intentional leak; the
               tokeniser keeps it alive for the life of the file.
               Better than tracking which Token entries reference
               which file string. */
            t->filename = strdup(start);
        }
        t->lineno = ln;
        return 0;
    }

    if (strncmp(p, "pragma", 6) == 0
        && (p[6] == ' ' || p[6] == '\t' || p[6] == 0)) {
        p += 6;
        while (*p == ' ' || *p == '\t') p++;
        tok->kind = TK_PRAGMA;
        tok->text = strdup(p);
        tok->text_len = (int)strlen(p);
        return 1;
    }

    /* Legacy z88dk `#asm ... #endasm` form (no `__` prefix). The
       directive line is typically `#asm` alone with the body on
       subsequent lines; the terminator is `#endasm`. zpragma
       normally rewrites this to `__asm` / `__endasm` upstream of
       ucpp; supporting it here keeps sccz80 robust against the
       zpragma-less pipeline. */
    if (strncmp(p, "asm", 3) == 0
        && (p[3] == ' ' || p[3] == '\t' || p[3] == 0)) {
        lex_asm_block(t, tok, "#endasm");
        return 1;
    }

    errorfmt("tokeniser: unexpected preprocessor directive '#%.20s' at line %d",
             1, p, t->lineno);
    return 0;   /* silently skip — let the caller move on */
}

/* Accumulate the body of a `__asm ... __endasm` (or legacy z88dk
   `#asm ... #endasm`) block. Caller has already consumed the
   opener. Reads raw text verbatim until `terminator` is encountered
   (case-sensitive, identifier-boundary required so e.g.
   `__endasm_foo` doesn't match — the leading `#` of `#endasm`
   trivially satisfies the boundary check). Strips the terminator
   from the buffer and emits TK_ASM_BLOCK. Newlines inside are
   preserved and `t->lineno` is kept current. */
static void lex_asm_block(Tokeniser *t, Token *tok, const char *terminator)
{
    char buf[16384];
    int len = 0;
    int tlen = (int)strlen(terminator);
    for (;;) {
        int c = tk_getc(t);
        if (c < 0) {
            errorfmt("tokeniser: unterminated asm block at line %d", 1,
                     t->lineno);
            break;
        }
        if (c == '\n') { t->lineno++; t->at_sol = 1; }
        if (len < (int)sizeof buf - 1) buf[len++] = (char)c;
        if (len >= tlen
            && memcmp(&buf[len - tlen], terminator, tlen) == 0
            && (len == tlen || !is_ident_cont((unsigned char)buf[len - tlen - 1]))) {
            len -= tlen;
            break;
        }
    }
    tok->kind = TK_ASM_BLOCK;
    tok->text = malloc(len + 1);
    if (tok->text) {
        memcpy(tok->text, buf, len);
        tok->text[len] = 0;
    }
    tok->text_len = len;
}

/* Effective read position in the byte buffer: `buf_pos` minus any
   pushed-back chars (those have been "uncommitted" so they don't
   count towards consumed bytes). Buffer-mode only — FILE-mode
   doesn't have a contiguous byte position. */
static int tk_eff_pos(Tokeniser *t)
{
    if (t->input) return -1;
    return t->buf_pos - t->pb_n;
}

static void lex_one_inner(Tokeniser *t, Token *tok);

static void lex_one(Tokeniser *t, Token *tok)
{
    lex_one_inner(t, tok);
    tok->source_end = tk_eff_pos(t);
}

static void lex_one_inner(Tokeniser *t, Token *tok)
{
again:
    /* Capture inside the loop so a silently-consumed pp directive
       (#line / # N "file") doesn't pollute the start of the
       *next* emitted token. Includes leading whitespace by design
       — L3 shims advance lptr past blanks + token together. */
    tok->source_start = tk_eff_pos(t);
    lex_skip_whitespace_and_comments(t);
    tok->line = t->lineno;
    tok->file = t->filename;

    int c = tk_getc(t);
    if (c < 0) { tok->kind = TK_EOF; return; }

    /* Preprocessor directive at start of line — `#line` updates
       position attribution silently, `#pragma` emits TK_PRAGMA. */
    if (c == '#' && t->at_sol) {
        t->at_sol = 0;
        if (lex_pp_directive(t, tok)) return;
        goto again;
    }
    t->at_sol = 0;

    if (is_ident_start(c))     { lex_ident(t, tok, c);  return; }
    if (isdigit(c))            { lex_number(t, tok, c); return; }
    /* `.NNN` form: dot followed by a digit is a float literal. */
    if (c == '.' && isdigit(tk_peekc(t))) {
                                  lex_number(t, tok, c); return;
    }
    if (c == '\'')             { lex_char(t, tok);      return; }
    if (c == '"')              { lex_string(t, tok);    return; }

    /* Punctuator dispatch. Each case peeks one (or two) more
       characters to decide between single- and multi-char forms.
       Order within each case: longest match first. */
#define TK_NEXT_IS(ch_) (tk_peekc(t) == (ch_))
#define TK_CONSUME(ch_) (tk_getc(t))
    switch (c) {
    case '(': tok->kind = TK_LPAREN;   return;
    case ')': tok->kind = TK_RPAREN;   return;
    case '{': tok->kind = TK_LBRACE;   return;
    case '}': tok->kind = TK_RBRACE;   return;
    case '[': tok->kind = TK_LBRACK;   return;
    case ']': tok->kind = TK_RBRACK;   return;
    case ',': tok->kind = TK_COMMA;    return;
    case ';': tok->kind = TK_SEMI;     return;
    case ':': tok->kind = TK_COLON;    return;
    case '?': tok->kind = TK_QUESTION; return;
    case '~': tok->kind = TK_TILDE;    return;
    case '@': tok->kind = TK_AT;       return;
    case '#': tok->kind = TK_HASH;     return;
    case '.':
        if (TK_NEXT_IS('.')) {
            TK_CONSUME('.');
            if (TK_NEXT_IS('.')) { TK_CONSUME('.'); tok->kind = TK_ELLIPSIS; return; }
            /* Two dots — not a valid C punctuator. Push the second
               dot back and emit a single TK_DOT; the parser will
               surface a syntax error on the next token. */
            tk_ungetc(t, '.');
        }
        tok->kind = TK_DOT;            return;
    case '!':
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_NE;  return; }
        tok->kind = TK_BANG;           return;
    case '+':
        if (TK_NEXT_IS('+')) { TK_CONSUME('+'); tok->kind = TK_INC;         return; }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_PLUS_ASSIGN; return; }
        tok->kind = TK_PLUS;           return;
    case '-':
        if (TK_NEXT_IS('-')) { TK_CONSUME('-'); tok->kind = TK_DEC;          return; }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_MINUS_ASSIGN; return; }
        if (TK_NEXT_IS('>')) { TK_CONSUME('>'); tok->kind = TK_ARROW;        return; }
        tok->kind = TK_MINUS;          return;
    case '*':
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_STAR_ASSIGN; return; }
        tok->kind = TK_STAR;           return;
    case '/':
        /* Line and block comments were already eaten by the
           whitespace skip above; reaching here means the next char
           isn't a comment opener. Just look for `/=`. */
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_SLASH_ASSIGN; return; }
        tok->kind = TK_SLASH;          return;
    case '%':
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_MOD_ASSIGN; return; }
        tok->kind = TK_PERCENT;        return;
    case '&':
        if (TK_NEXT_IS('&')) { TK_CONSUME('&'); tok->kind = TK_LAND;       return; }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_AND_ASSIGN; return; }
        tok->kind = TK_AMP;            return;
    case '|':
        if (TK_NEXT_IS('|')) { TK_CONSUME('|'); tok->kind = TK_LOR;       return; }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_OR_ASSIGN; return; }
        tok->kind = TK_PIPE;           return;
    case '^':
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_XOR_ASSIGN; return; }
        tok->kind = TK_CARET;          return;
    case '=':
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_EQ; return; }
        tok->kind = TK_ASSIGN;         return;
    case '<':
        if (TK_NEXT_IS('<')) {
            TK_CONSUME('<');
            if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_SHL_ASSIGN; return; }
            tok->kind = TK_SHL;        return;
        }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_LE; return; }
        tok->kind = TK_LT;             return;
    case '>':
        if (TK_NEXT_IS('>')) {
            TK_CONSUME('>');
            if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_SHR_ASSIGN; return; }
            tok->kind = TK_SHR;        return;
        }
        if (TK_NEXT_IS('=')) { TK_CONSUME('='); tok->kind = TK_GE; return; }
        tok->kind = TK_GT;             return;
    }
#undef TK_NEXT_IS
#undef TK_CONSUME
    errorfmt("tokeniser: unexpected character 0x%02x at line %d", 1,
             c & 0xff, t->lineno);
    tok->kind = TK_EOF;
}

/* ---------- public API ---------- */

/* Common init shared by tk_new (FILE mode) and tk_new_buffer
   (buffer mode). Allocates token ring and sets position state. */
static Tokeniser *tk_alloc_state(const char *filename)
{
    Tokeniser *t = calloc(1, sizeof *t);
    if (!t) return NULL;
    t->filename = filename;
    t->lineno = 1;
    t->at_sol = 1;
    t->tok_cap = TK_BUF_INITIAL;
    t->tokens = calloc(t->tok_cap, sizeof(Token));
    if (!t->tokens) { free(t); return NULL; }
    return t;
}

Tokeniser *tk_new(FILE *input, const char *filename)
{
    Tokeniser *t = tk_alloc_state(filename);
    if (!t) return NULL;
    t->input = input;
    return t;
}

Tokeniser *tk_new_buffer(const char *filename, tk_refill_fn refill, void *user)
{
    Tokeniser *t = tk_alloc_state(filename);
    if (!t) return NULL;
    /* Modest starting capacity — grows as lines arrive. */
    t->buf_cap = 4096;
    t->buf = malloc(t->buf_cap);
    if (!t->buf) { free(t->tokens); free(t); return NULL; }
    t->refill = refill;
    t->refill_user = user;
    return t;
}

void tk_feed_line(Tokeniser *t, const char *src)
{
    if (!t) return;
    if (t->input) {
        errorfmt("tokeniser: tk_feed_line on a FILE-mode tokeniser (internal error)", 1);
        return;
    }
    int slen = (int)strlen(src);
    /* Record where this line begins — L3 shims use this to map
       legacy `lptr` back to the absolute buf position. */
    t->current_line_start = t->buf_len;
    /* Reserve room for `src` + trailing '\n' + NUL safety. */
    int need = t->buf_len + slen + 2;
    if (need > t->buf_cap) {
        int new_cap = t->buf_cap;
        while (new_cap < need) new_cap *= 2;
        char *nb = realloc(t->buf, new_cap);
        if (!nb) { errorfmt("tokeniser: out of memory growing feed buffer", 1); return; }
        t->buf = nb;
        t->buf_cap = new_cap;
    }
    memcpy(t->buf + t->buf_len, src, slen);
    t->buf_len += slen;
    t->buf[t->buf_len++] = '\n';
    /* Feed un-sets a previously-cached "refill says no more"
       state — if more bytes arrive we treat the earlier EOF as
       provisional. The lexer's stored TK_EOF tokens stay (caller
       hasn't peeked yet in this slice; if it had, we'd need to
       retract them). */
    t->refill_done = 0;
    t->at_eof = 0;
}

void tk_free(Tokeniser *t)
{
    if (!t) return;
    for (int i = 0; i < t->tail; i++) {
        free(t->tokens[i].text);
    }
    free(t->tokens);
    free(t->buf);
    free(t);
}

Token *tk_peek(Tokeniser *t, int n)
{
    while (t->head + n >= t->tail) {
        Token *tok = tk_alloc(t);
        lex_one(t, tok);
        if (tok->kind == TK_EOF) break;
    }
    int idx = t->head + n;
    if (idx >= t->tail) idx = t->tail - 1;   /* last is TK_EOF */
    return &t->tokens[idx];
}

Token *tk_consume(Tokeniser *t)
{
    Token *tok = tk_peek(t, 0);
    if (tok->kind != TK_EOF) t->head++;
    return tok;
}

int tk_match_kind(Tokeniser *t, TokenKind kind)
{
    if (tk_peek(t, 0)->kind == kind) { tk_consume(t); return 1; }
    return 0;
}

void tk_expect(Tokeniser *t, TokenKind kind)
{
    Token *tok = tk_peek(t, 0);
    if (tok->kind != kind) {
        errorfmt("tokeniser: expected token kind %d, got %d at line %d",
                 1, kind, tok->kind, tok->line);
        return;
    }
    tk_consume(t);
}

int tk_save(Tokeniser *t) { return t->head; }
void tk_restore(Tokeniser *t, int checkpoint) { t->head = checkpoint; }

int tk_current_line_start(Tokeniser *t)
{
    return t ? t->current_line_start : 0;
}

/* Move the byte cursor to `pos` and reset any cached lookahead.
   Lazy lexing means the token ring usually holds at most one
   unconsumed token; we discard the whole ring to simplify. The
   pushback buffer is also drained. Used by L3 shims when they
   know the parser has advanced via the legacy lptr cursor since
   the last tk_peek/tk_consume call. */
void tk_align_to_buf_pos(Tokeniser *t, int pos)
{
    if (!t || t->input) return;       /* FILE-mode tokenisers can't seek */
    if (pos < 0) pos = 0;
    if (pos > t->buf_len) pos = t->buf_len;
    t->buf_pos = pos;
    t->pb_n = 0;
    /* Discard pending tokens — caller is at a new position. */
    for (int i = t->head; i < t->tail; i++) {
        free(t->tokens[i].text);
        t->tokens[i].text = NULL;
    }
    t->head = t->tail = 0;
    t->at_eof = 0;
}

/* ---------- --lex-only dump ---------- */

static const char *kind_name(TokenKind k)
{
    switch (k) {
    case TK_EOF:          return "EOF";
    case TK_IDENT:        return "IDENT";
    case TK_KEYWORD:      return "KEYWORD";
    case TK_NUMBER:       return "NUMBER";
    case TK_FLOAT:        return "FLOAT";
    case TK_STRING:       return "STRING";
    case TK_CHAR:         return "CHAR";
    case TK_PRAGMA:       return "PRAGMA";
    case TK_ASM_BLOCK:    return "ASM_BLOCK";
    case TK_LPAREN:       return "LPAREN";
    case TK_RPAREN:       return "RPAREN";
    case TK_LBRACE:       return "LBRACE";
    case TK_RBRACE:       return "RBRACE";
    case TK_LBRACK:       return "LBRACK";
    case TK_RBRACK:       return "RBRACK";
    case TK_COMMA:        return "COMMA";
    case TK_SEMI:         return "SEMI";
    case TK_COLON:        return "COLON";
    case TK_QUESTION:     return "QUESTION";
    case TK_DOT:          return "DOT";
    case TK_BANG:         return "BANG";
    case TK_TILDE:        return "TILDE";
    case TK_PLUS:         return "PLUS";
    case TK_MINUS:        return "MINUS";
    case TK_STAR:         return "STAR";
    case TK_SLASH:        return "SLASH";
    case TK_PERCENT:      return "PERCENT";
    case TK_AMP:          return "AMP";
    case TK_PIPE:         return "PIPE";
    case TK_CARET:        return "CARET";
    case TK_ASSIGN:       return "ASSIGN";
    case TK_LT:           return "LT";
    case TK_GT:           return "GT";
    case TK_AT:           return "AT";
    case TK_HASH:         return "HASH";
    case TK_ARROW:        return "ARROW";
    case TK_INC:          return "INC";
    case TK_DEC:          return "DEC";
    case TK_SHL:          return "SHL";
    case TK_SHR:          return "SHR";
    case TK_LE:           return "LE";
    case TK_GE:           return "GE";
    case TK_EQ:           return "EQ";
    case TK_NE:           return "NE";
    case TK_LAND:         return "LAND";
    case TK_LOR:          return "LOR";
    case TK_PLUS_ASSIGN:  return "PLUS_ASSIGN";
    case TK_MINUS_ASSIGN: return "MINUS_ASSIGN";
    case TK_STAR_ASSIGN:  return "STAR_ASSIGN";
    case TK_SLASH_ASSIGN: return "SLASH_ASSIGN";
    case TK_MOD_ASSIGN:   return "MOD_ASSIGN";
    case TK_AND_ASSIGN:   return "AND_ASSIGN";
    case TK_OR_ASSIGN:    return "OR_ASSIGN";
    case TK_XOR_ASSIGN:   return "XOR_ASSIGN";
    case TK_SHL_ASSIGN:   return "SHL_ASSIGN";
    case TK_SHR_ASSIGN:   return "SHR_ASSIGN";
    case TK_ELLIPSIS:     return "ELLIPSIS";
    default:              return "???";
    }
}

void tk_dump_stream(Tokeniser *t, FILE *out)
{
    for (;;) {
        Token *tok = tk_peek(t, 0);
        fprintf(out, "%d:%s\t%s", tok->line, tok->file ? tok->file : "?",
                kind_name(tok->kind));
        switch (tok->kind) {
        case TK_IDENT:
            fprintf(out, "\t%s", tok->text ? tok->text : "");
            break;
        case TK_KEYWORD:
            fprintf(out, "\t%s", tk_keyword_name(tok->kw_id));
            break;
        case TK_NUMBER:
            fprintf(out, "\t%lld (kind=%d%s)",
                    (long long)tok->num.value, tok->num.kind,
                    tok->num.isunsigned ? " unsigned" : "");
            break;
        case TK_FLOAT:
            fprintf(out, "\t%.17Lg (fkind=%d)", tok->fval, tok->fkind);
            break;
        case TK_CHAR:
            fprintf(out, "\t%lld", (long long)tok->num.value);
            break;
        case TK_STRING:
            fprintf(out, "\t\"%.*s\"", tok->text_len,
                    tok->text ? tok->text : "");
            break;
        case TK_PRAGMA:
            fprintf(out, "\t%s", tok->text ? tok->text : "");
            break;
        case TK_ASM_BLOCK:
            fprintf(out, "\t<%d bytes>", tok->text_len);
            break;
        default:
            break;
        }
        fputc('\n', out);
        if (tok->kind == TK_EOF) break;
        tk_consume(t);
    }
}
