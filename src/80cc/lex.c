/*
 /      Small C+ Compiler
 *
 *      Lexical routines - string matching etc
 *
 *      $Id: lex.c,v 1.3 2007-07-19 18:42:37 dom Exp $
 */

#include "ccdefs.h"
#include "tokeniser.h"

/* Char → TokenKind for the single-char punctuator forms cmatch is
   typically called on. Multi-char overlap chars (`+`, `-`, `*`,
   `<`, `>`, `&`, `|`, `=`, `!`, `.`) are included — the audit in
   #167 confirmed every parser-side cmatch on these chars wants the
   single-char form, and the parser routes `++` / `+=` / `==` /
   `...` / etc. via separate paths before reaching cmatch. Chars
   not in the table (digits, letters, quotes, `_`, `\`, `0`) yield
   TK_LAST — the shim falls through to legacy. */
static TokenKind punct_kind_for_char(int c)
{
    switch (c) {
    case '(': return TK_LPAREN;
    case ')': return TK_RPAREN;
    case '{': return TK_LBRACE;
    case '}': return TK_RBRACE;
    case '[': return TK_LBRACK;
    case ']': return TK_RBRACK;
    case ',': return TK_COMMA;
    case ';': return TK_SEMI;
    case ':': return TK_COLON;
    case '?': return TK_QUESTION;
    case '.': return TK_DOT;
    case '!': return TK_BANG;
    case '~': return TK_TILDE;
    case '+': return TK_PLUS;
    case '-': return TK_MINUS;
    case '*': return TK_STAR;
    case '/': return TK_SLASH;
    case '%': return TK_PERCENT;
    case '&': return TK_AMP;
    case '|': return TK_PIPE;
    case '^': return TK_CARET;
    case '=': return TK_ASSIGN;
    case '<': return TK_LT;
    case '>': return TK_GT;
    case '@': return TK_AT;
    case '#': return TK_HASH;
    default:  return TK_LAST;
    }
}

int streq(char str1[], char str2[])
{
    int k;
    k = 0;
    while (*str2) {
        if ((*str1++) != (*str2++))
            return 0;
        ++k;
    }
    return k;
}

/*
 * compare strings
 * match only if we reach end of both strings or if, at end of one of the
 * strings, the other one has reached a non-alphanumeric character
 * (so that, for example, astreq("if", "ifline") is not a match)
 */
int astreq(char* str1, char* str2)
{
    int k;

    k = 0;
    while (*str1 && *str2) {
        if (*str1 != *str2)
            break;
        ++str1;
        ++str2;
        ++k;
    }
    if (an(*str1) || an(*str2))
        return 0;
    return k;
}

int match(char* lit)
{
    int k;

    blanks();
    if ((k = streq(line + lptr, lit))) {
        lptr += k;
        return 1;
    }
    return 0;
}

/* Two-mode primitive:
   • For punctuator chars (table-mapped), route through the
     tokeniser — multi-char overlap (`++` vs `+`, `<=` vs `<`)
     is filtered automatically since they have distinct kinds.
   • For non-punctuator chars (quotes `"` / `'`, escape `\`,
     identifier-prefix `_`, digit `0`, …), char-peek the raw
     line buffer. The tokeniser has no peek-for-quote primitive
     because strings/chars are lexed as whole literals — these
     callers really do want "next character class is X" before
     deciding whether to enter a literal scanner. */
int cmatch(char lit)
{
    blanks();
    if (c_eof)
        errorfmt("Unexpected end of file", 1);

    TokenKind want = punct_kind_for_char((unsigned char)lit);
    if (want != TK_LAST) {
        int pos = tk_current_line_start(current_tokeniser) + lptr;
        tk_align_to_buf_pos(current_tokeniser, pos);
        Token *tok = tk_peek(current_tokeniser, 0);
        if (!tok || tok->kind != want)
            return 0;
        int span = tok->source_end - tok->source_start;
        lptr += span;
        tk_consume(current_tokeniser);
        return 1;
    }

    /* Non-punctuator: raw char-peek-and-consume. */
    if (toupper(line[lptr]) == toupper(lit)) {
        ++lptr;
        return 1;
    }
    return 0;
}

/* Get the next character, don't skip spaces */
int acmatch(char lit)
{
    if (c_eof)
        errorfmt("Unexpected end of file", 1);
    if (line[lptr] == lit) {
        ++lptr;
        return 1;
    }
    return 0;
}


int checkws(void)
{
    return isspace( *(line+lptr));
}


int rmatch2(char* lit)
{
    int k;
    blanks();
    if ((k = streq(line + lptr, lit)))
        return 1;
    return 0;
}

/* Peek-only variant of cmatch — no lptr advance. Same two-mode
   split: tokeniser kind check for punctuators, raw char peek for
   non-punctuator chars. */
int rcmatch(char lit)
{
    blanks();
    if (c_eof)
        errorfmt("Unexpected end of file", 1);

    TokenKind want = punct_kind_for_char((unsigned char)lit);
    if (want != TK_LAST) {
        int pos = tk_current_line_start(current_tokeniser) + lptr;
        tk_align_to_buf_pos(current_tokeniser, pos);
        Token *tok = tk_peek(current_tokeniser, 0);
        return (tok && tok->kind == want) ? 1 : 0;
    }

    return (toupper(line[lptr]) == toupper(lit)) ? 1 : 0;
}

/* Peek-and-dispatch on token kind. Skips legacy whitespace, aligns
   the tokeniser to the current lptr position, returns the kind of
   the next token (TK_EOF when stream exhausted). TokenKind already
   distinguishes single-char from multi-char punctuators (TK_PLUS
   vs TK_INC vs TK_PLUS_ASSIGN, etc.) so a kind-equality check
   folds in the legacy `nch() == '='` skip. */
TokenKind tk_peek_kind_at_lptr(void)
{
    blanks();
    int pos = tk_current_line_start(current_tokeniser) + lptr;
    tk_align_to_buf_pos(current_tokeniser, pos);
    Token *tok = tk_peek(current_tokeniser, 0);
    return tok ? tok->kind : TK_EOF;
}

/* Consume the next token if its kind matches `k`, advancing lptr
   by the source span. Returns 1 on match (consumed), 0 otherwise.
   Used for multi-char punctuators like `<=` / `>>=` / `++` / `->`
   where cmatch (char-level) isn't the right granularity. */
int tk_match_kind_at_lptr(TokenKind k)
{
    blanks();
    int pos = tk_current_line_start(current_tokeniser) + lptr;
    tk_align_to_buf_pos(current_tokeniser, pos);
    Token *tok = tk_peek(current_tokeniser, 0);
    if (!tok || tok->kind != k) return 0;
    int span = tok->source_end - tok->source_start;
    lptr += span;
    tk_consume(current_tokeniser);
    return 1;
}

/* Peek-and-dispatch on keyword sub-kind. Returns the kw_id when
   the next token is a TK_KEYWORD, else KW_NONE. */
int tk_peek_kw_at_lptr(void)
{
    blanks();
    int pos = tk_current_line_start(current_tokeniser) + lptr;
    tk_align_to_buf_pos(current_tokeniser, pos);
    Token *tok = tk_peek(current_tokeniser, 0);
    if (!tok || tok->kind != TK_KEYWORD) return KW_NONE;
    return tok->kw_id;
}

/* Match a literal identifier or keyword spelling. If the next
   token is a TK_IDENT or TK_KEYWORD whose text matches `lit`,
   consume it and advance lptr. Used for the few sites that match
   a runtime string (typedef names, namespace names) or a non-
   keyword sub-token (asm, pragma sub-tokens, _Accum-suffix
   letters). Keyword-spelling matches now route through
   swallow(KW_*). */
int amatch_impl(char* lit, int buffer)
{
    (void)buffer;  /* legacy arg-replay buffer machinery is gone */
    blanks();
    int pos = tk_current_line_start(current_tokeniser) + lptr;
    tk_align_to_buf_pos(current_tokeniser, pos);
    Token *tok = tk_peek(current_tokeniser, 0);
    if (tok && (tok->kind == TK_IDENT || tok->kind == TK_KEYWORD)
        && tok->text && strcmp(tok->text, lit) == 0) {
        int span = tok->source_end - tok->source_start;
        lptr += span;
        tk_consume(current_tokeniser);
        return 1;
    }
    return 0;
}

int amatch(char* lit)
{
    return amatch_impl(lit, 1);
}

/* Consume the next keyword token if its kw_id matches. */
int swallow(int kw_id)
{
    blanks();
    int pos = tk_current_line_start(current_tokeniser) + lptr;
    tk_align_to_buf_pos(current_tokeniser, pos);
    Token *tok = tk_peek(current_tokeniser, 0);
    if (tok && tok->kind == TK_KEYWORD && tok->kw_id == kw_id) {
        int span = tok->source_end - tok->source_start;
        lptr += span;
        tk_consume(current_tokeniser);
        return 1;
    }
    return 0;
}

