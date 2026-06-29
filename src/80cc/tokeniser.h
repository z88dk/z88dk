/*
 * sccz80 internal tokeniser — TOKENIZER_PLAN Phase L2.
 *
 * Lexes the preprocessed source stream into a typed token sequence.
 * Parser-side code is unchanged in L2; consumers of this API in this
 * phase are limited to the `--lex-only` driver (for inspection and
 * golden tests). Phase L3 will add cmatch/amatch shims that read
 * through this stream; Phase L4 migrates parser sites to call this
 * API directly.
 */

#ifndef SCCZ80_TOKENISER_H
#define SCCZ80_TOKENISER_H

#include <stdio.h>
#include <stdint.h>

/* zdouble is the wide-FP type sccz80 uses for parsed numeric
   literals — defined in ccdefs.h as `long double`. The tokeniser
   carries float-literal payloads in zdouble so suffix-driven kind
   resolution (FLOAT16, DOUBLE, ACCUM16/32) keeps full precision
   until the parser decides the binding. */
typedef long double zdouble;

#define TK_NAME_MAX 127     /* matches NAMESIZE-1 */
#define TK_STRING_MAX 4096  /* per-token; longer strings are an error */

/* Keyword sub-kinds carried in Token.kw_id when Token.kind == TK_KEYWORD.
   Covers TOKENIZER_PLAN appendix A1-A6. __asm / __endasm are handled
   via TK_ASM_BLOCK (raw-block lex) and are not keyword sub-kinds.
   __func__ / __builtin_offsetof stay TK_IDENT and are special-cased by
   the parser (per appendix A7 guidance). */
typedef enum {
    KW_NONE = 0,

    /* A1 — types / qualifiers / storage classes. */
    KW_CHAR, KW_SHORT, KW_INT, KW_LONG, KW_SIGNED, KW_UNSIGNED,
    KW_FLOAT, KW_DOUBLE, KW_VOID, KW_STRUCT, KW_UNION, KW_ENUM,
    KW_TYPEDEF, KW_EXTERN, KW_STATIC, KW_AUTO, KW_CONST, KW_REGISTER,
    KW_RESTRICT, KW_VOLATILE, KW_SIZEOF,

    /* A2 — control flow. */
    KW_IF, KW_ELSE, KW_WHILE, KW_DO, KW_FOR, KW_SWITCH, KW_CASE,
    KW_DEFAULT, KW_BREAK, KW_CONTINUE, KW_GOTO, KW_RETURN,

    /* A3 — C11-ish. */
    KW_STATIC_ASSERT,    /* _Static_assert */
    KW_ACCUM,            /* _Accum (Embedded-C fixed-point) */
    KW_FLOAT16,          /* _Float16 */

    /* A4 — sccz80 storage / placement / qualifier extensions. */
    KW_ADDRESSMOD,       /* __addressmod */
    KW_AT,               /* __at */
    KW_BANKED,           /* __banked */
    KW_NONBANKED,        /* __nonbanked */
    KW_CRITICAL,         /* __critical */
    KW_FAR_LONG,         /* __far (24-bit far ptr) */
    KW_INTERRUPT,        /* __interrupt */
    KW_NAKED,            /* __naked */
    KW_PRESERVES_REGS,   /* __preserves_regs */
    KW_SFR,              /* __sfr */
    KW_NEAR,             /* near */
    KW_FAR,              /* far */

    /* A5 — calling-convention. */
    KW_SMALLC,                  /* __smallc */
    KW_STDC,                    /* __stdc */
    KW_Z88DK_CALLEE,            /* __z88dk_callee */
    KW_Z88DK_FASTCALL,          /* __z88dk_fastcall */
    KW_Z88DK_HL_CALL,           /* __z88dk_hl_call */
    KW_Z88DK_PARAMS_OFFSET,     /* __z88dk_params_offset */
    KW_Z88DK_SAVEFRAME,         /* __z88dk_saveframe */
    KW_Z88DK_SDCCDECL,          /* __z88dk_sdccdecl */
    KW_Z88DK_SHORTCALL,         /* __z88dk_shortcall */
    KW_Z88DK_SHORTCALL_HL,      /* __z88dk_shortcall_hl */
    KW_CALLEE_LEGACY,           /* __CALLEE__ */
    KW_FASTCALL_LEGACY,         /* __FASTCALL__ */
    KW_LIB_LEGACY,              /* __LIB__ */
    KW_SAVEFRAME_LEGACY,        /* __SAVEFRAME__ */

    /* A6 — control-flow extensions. */
    KW_RETURN_C,                /* return_c */
    KW_RETURN_NC,               /* return_nc */
    KW_IFERROR,                 /* iferror */

    KW_LAST
} KeywordId;

/* Look up `name` in the keyword table. Returns KW_NONE if not a
   keyword. Used by lex_ident, exposed for the dump driver. */
int tk_lookup_keyword(const char *name);
const char *tk_keyword_name(int kw_id);

typedef enum {
    TK_EOF = 0,
    TK_IDENT,        /* identifier (not a keyword) */
    TK_KEYWORD,      /* sub-kind in .kw_id */
    TK_NUMBER,       /* integer literal, value/kind in .num */
    TK_FLOAT,        /* float literal (placeholder; lex via double) */
    TK_STRING,       /* "..." (after adjacent-literal concat) */
    TK_CHAR,         /* 'x' — value in .num.value, kind KIND_CHAR */
    TK_PRAGMA,       /* #pragma line; body in .text */
    TK_ASM_BLOCK,    /* __asm ... __endasm block; body in .text */

    /* Single-char punctuators. */
    TK_LPAREN,       /* ( */
    TK_RPAREN,       /* ) */
    TK_LBRACE,       /* { */
    TK_RBRACE,       /* } */
    TK_LBRACK,       /* [ */
    TK_RBRACK,       /* ] */
    TK_COMMA,        /* , */
    TK_SEMI,         /* ; */
    TK_COLON,        /* : */
    TK_QUESTION,     /* ? */
    TK_DOT,          /* . */
    TK_BANG,         /* ! */
    TK_TILDE,        /* ~ */
    TK_PLUS,         /* + */
    TK_MINUS,        /* - */
    TK_STAR,         /* * */
    TK_SLASH,        /* / */
    TK_PERCENT,      /* % */
    TK_AMP,          /* & */
    TK_PIPE,         /* | */
    TK_CARET,        /* ^ */
    TK_ASSIGN,       /* = */
    TK_LT,           /* < */
    TK_GT,           /* > */
    TK_AT,           /* @ (sccz80 fixed-address binder) */
    TK_HASH,         /* # (only after pragma capture; raw # outside is errored) */

    /* Multi-char punctuators (filled in by subsequent slice). */
    TK_ARROW,        /* -> */
    TK_INC,          /* ++ */
    TK_DEC,          /* -- */
    TK_SHL,          /* << */
    TK_SHR,          /* >> */
    TK_LE,           /* <= */
    TK_GE,           /* >= */
    TK_EQ,           /* == */
    TK_NE,           /* != */
    TK_LAND,         /* && */
    TK_LOR,          /* || */
    TK_PLUS_ASSIGN,  /* += */
    TK_MINUS_ASSIGN, /* -= */
    TK_STAR_ASSIGN,  /* *= */
    TK_SLASH_ASSIGN, /* /= */
    TK_MOD_ASSIGN,   /* %= */
    TK_AND_ASSIGN,   /* &= */
    TK_OR_ASSIGN,    /* |= */
    TK_XOR_ASSIGN,   /* ^= */
    TK_SHL_ASSIGN,   /* <<= */
    TK_SHR_ASSIGN,   /* >>= */
    TK_ELLIPSIS,     /* ... */

    TK_LAST
} TokenKind;

/* Pre-parsed numeric value carried by TK_NUMBER. Float literals get
   a separate carrier (TK_FLOAT) to avoid mixing the two representations
   in the union — keeps suffix-driven kind resolution per-flavor. */
typedef struct {
    int64_t  value;
    int      kind;        /* KIND_INT / KIND_LONG / KIND_LONGLONG */
    int      isunsigned;
} TokenNumeric;

typedef struct {
    TokenKind  kind;
    int        line;       /* original-source line (post-#line attribution) */
    const char *file;      /* original-source file (interned; not owned) */
    int        kw_id;      /* TK_KEYWORD only — sub-kind */
    TokenNumeric num;      /* TK_NUMBER / TK_CHAR */
    zdouble    fval;       /* TK_FLOAT — wide-precision; suffix-driven binding deferred to parse */
    int        fkind;      /* TK_FLOAT kind (KIND_DOUBLE / KIND_FLOAT16 / KIND_ACCUM*) */
    char       *text;      /* TK_IDENT name / TK_STRING contents / TK_PRAGMA body /
                              TK_ASM_BLOCK body. Owned by the tokeniser. */
    int        text_len;   /* TK_STRING / TK_ASM_BLOCK length (text not NUL-terminated for those) */
    /* Source-byte span this token consumed (buffer-mode only;
       -1 / 0 in FILE-mode). Used by the L3 shim layer to advance
       the legacy `lptr` cursor in lockstep with token consumption.
       source_start is the byte position the token's leading
       whitespace begins at; source_end is the position immediately
       after the token's last source byte. The leading-whitespace
       span is intentionally included so that consuming a token
       also skips past blanks. */
    int        source_start;
    int        source_end;
} Token;

/* Opaque tokeniser state. One per compilation unit. */
typedef struct Tokeniser Tokeniser;

/* Construct a tokeniser reading from `input`. `filename` is the
   initial source filename for position attribution (often the same
   filename ucpp opened, until a `#line` directive remaps it). */
Tokeniser *tk_new(FILE *input, const char *filename);

/* Pull-mode refill callback. Invoked by the tokeniser when its
   internal byte buffer is exhausted. Implementations should
   acquire the next line of input (e.g. by calling preproc.c's
   `vinline()`) and append it to the tokeniser via
   `tk_feed_line(t, buf)`. Return non-zero if at least one byte
   was appended; zero to signal end-of-input (no more lines
   ever). The tokeniser caches a "definitely EOF" state after a
   zero return; subsequent reads short-circuit. */
typedef int (*tk_refill_fn)(struct Tokeniser *t, void *user);

/* Buffer-source variant: no FILE * backing. Bytes are pushed in
   via `tk_feed_line(t, buf)` either eagerly by the caller or
   lazily by the registered refill callback. The callback is
   optional; if NULL the tokeniser only sees what the caller has
   explicitly fed. Used by Phase L3c to drive the tokeniser in
   lockstep with preproc.c's line filling. */
Tokeniser *tk_new_buffer(const char *filename, tk_refill_fn refill, void *user);

/* Append `buf` (NUL-terminated) to the buffer-mode tokeniser's
   internal byte buffer. The tokeniser appends an implicit '\n'
   after the supplied bytes — caller should pass a line without
   its trailing newline. No-op (with diagnostic) if `t` is in
   FILE-mode. */
void       tk_feed_line(Tokeniser *t, const char *buf);

/* L3 shim helpers — buffer-mode only. */

/* Byte position in the tokeniser's buf where the current input
   line begins. Set by tk_feed_line(). Combined with the parser's
   `lptr`, gives the absolute buf-position the legacy lex layer
   is currently at: `current_line_start + lptr`. */
int        tk_current_line_start(Tokeniser *t);

/* Fast-forward (or rewind) the tokeniser's byte cursor to `pos`.
   Discards any cached but un-peeked lookahead tokens (lazy-lex
   means none are typically cached). Used by L3 shims to align
   the tokeniser to the parser's `lptr` before peeking. */
void       tk_align_to_buf_pos(Tokeniser *t, int pos);

/* Peek-and-dispatch helper for parser sites that today use
   ch()/nch() to look at the next char. Skips legacy whitespace,
   aligns the singleton tokeniser to lptr, and returns the kind of
   the next token (TK_EOF when no tokeniser is active). Lives in
   lex.c — declared here so its tokeniser-dependent prototype can
   import the TokenKind type. */
TokenKind  tk_peek_kind_at_lptr(void);

/* Consume the next token if its kind matches `k`, advancing lptr
   in lockstep. Used to replace multi-char `match("...")` calls
   where the literal corresponds to a specific TokenKind. Returns
   1 on match, 0 otherwise. */
int        tk_match_kind_at_lptr(TokenKind k);

/* Peek-and-dispatch on keyword sub-kind. Skips legacy whitespace,
   aligns the singleton tokeniser to lptr, and returns the next
   token's kw_id when its kind is TK_KEYWORD. Returns KW_NONE for
   non-keyword tokens, EOF, or when the singleton is absent. Lets
   the parser switch directly on KW_* values without re-walking
   the peek wiring. */
int        tk_peek_kw_at_lptr(void);

void       tk_free(Tokeniser *t);

/* Peek the token at offset n from the current position. n=0 is the
   current token; n=1 is the next; etc. Returns a stable pointer
   valid until the next tk_consume(). The returned pointer is owned
   by the tokeniser — do not free. */
Token *tk_peek(Tokeniser *t, int n);

/* Consume and return the current token. Returned pointer remains
   valid until the next consume/peek call. */
Token *tk_consume(Tokeniser *t);

/* Convenience: if peek(0).kind == kind, consume and return 1;
   otherwise return 0. */
int    tk_match_kind(Tokeniser *t, TokenKind kind);

/* Consume current token, error-out if not the expected kind. */
void   tk_expect(Tokeniser *t, TokenKind kind);

/* Checkpoint/backtrack — store and restore the current position
   index. Used by parser passes that need to look ahead and
   conditionally consume. */
int    tk_save(Tokeniser *t);
void   tk_restore(Tokeniser *t, int checkpoint);

/* `--lex-only` driver entry: dump every token in the stream to
   stdout (one token per line) and return when TK_EOF reached.
   Format is whatever the implementation chooses — once a golden
   test is in place, that format is frozen. */
void   tk_dump_stream(Tokeniser *t, FILE *out);

#endif /* SCCZ80_TOKENISER_H */
