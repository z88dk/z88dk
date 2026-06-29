/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part deals with statements
 *
 *      $Id: stmt.c,v 1.22 2016-04-05 20:23:34 dom Exp $
 */

#include "ccdefs.h"

static void ns(void);
static Node *compound(void);
static Node *doiferror(void);
static Node *doif(void);
static struct nodepair *doexpr(void);
static Node *dowhile(void);
static Node *dodo(void);
static Node *dofor(void);
static Node *doswitch(void);
static Node *docase(void);
static Node *dodefault(void);
static Node *doreturn(char);
static Node *dobreak(void);
static Node *docont(void);
static Node *dostaticassert(void);

/*
 *      Some variables for goto and cleaning up after compound 
 *      statements
 */

extern Node *dogoto(void);
extern Node *dolabel(void);
static Node *docritical(void);
static int lastline = 0;



static int swactive = 0; /* true inside a switch */
static int swdefault = 0; /* default label number, else 0 */

static int incritical = 0;  /* Are we in a __critical block */


/*
 *      Statement parser
 *
 * called whenever syntax requires a statement.
 * this routine performs that statement
 * and returns a number telling which one
 */
struct nodepair *statement(void)
{
    int st = 0;
    int locstatic; /* have we had the static keyword */
    struct nodepair *pair = calloc(1,sizeof(*pair));
    Node   *node;

    blanks();
    if (lineno != lastline) {
        lastline = lineno;
        /* C_LINE markers are emitted by the walker (cg2_walk) from the
           per-node `filename` / `line` fields so they interleave with
           the body asm instead of clustering at the top. */
    }
    if (tk_peek_kind_at_lptr() == TK_EOF) {
        lastst = st;
        pair->i = st;
        return pair;
    } else {

        if (swallow(KW_EXTERN)) {
            dodeclare(EXTERNAL);
            lastst = st;
            pair->i = st;
            return pair;
        }
        /* Ignore the register and auto keywords! */
        swallow(KW_REGISTER);
        swallow(KW_AUTO);

        /* Check to see if specified as static, and also for far and near */
        locstatic = swallow(KW_STATIC);

        if ( (node = declare_local(locstatic)) != NULL ) {
            lastst = st;
            pair->i = st;
            pair->node = node;
            return pair;
        }        
        /* not a definition */
        if (declared >= 0) {
            declared = 0;
        }
        st = -1;
        /* Phase L3c-12: dispatch on the tokeniser-classified next
           token rather than the legacy first-character switch. C
           keywords are TK_KEYWORD with a kw_id sub-kind, so the
           keyword arms collapse to a `switch (kw_id)`. Punctuators
           (`{`, `;`, `#`) and the `asm` identifier are handled in
           the secondary kind-switch when no keyword matched. */
        int kw = tk_peek_kw_at_lptr();
        switch (kw) {
        case KW_IFERROR:
            swallow(KW_IFERROR);
            pair->node = doiferror();
            st = STIF;
            break;
        case KW_IF:
            swallow(KW_IF);
            pair->node = doif();
            st = STIF;
            break;
        case KW_WHILE:
            swallow(KW_WHILE);
            pair->node = dowhile();
            st = STWHILE;
            break;
        case KW_DO:
            swallow(KW_DO);
            pair->node = dodo();
            st = STDO;
            break;
        case KW_DEFAULT:
            swallow(KW_DEFAULT);
            pair->node = dodefault();
            st = STDEF;
            break;
        case KW_FOR:
            swallow(KW_FOR);
            pair->node = dofor();
            st = STFOR;
            break;
        case KW_SWITCH:
            swallow(KW_SWITCH);
            pair->node = doswitch();
            st = STSWITCH;
            break;
        case KW_CASE:
            swallow(KW_CASE);
            pair->node = docase();
            st = STCASE;
            break;
        case KW_CONTINUE:
            swallow(KW_CONTINUE);
            pair->node = docont();
            ns();
            st = STCONT;
            break;
        case KW_RETURN:
            swallow(KW_RETURN);
            pair->node = doreturn(0);
            ns();
            st = STRETURN;
            break;
        case KW_RETURN_C:
            swallow(KW_RETURN_C);
            pair->node = doreturn(1);
            ns();
            st = STRETURN;
            break;
        case KW_RETURN_NC:
            swallow(KW_RETURN_NC);
            pair->node = doreturn(2);
            ns();
            st = STRETURN;
            break;
        case KW_BREAK:
            swallow(KW_BREAK);
            pair->node = dobreak();
            ns();
            st = STBREAK;
            break;
        case KW_GOTO:
            swallow(KW_GOTO);
            pair->node = dogoto();
            ns();
            st = STGOTO;
            break;
        case KW_STATIC_ASSERT:
            swallow(KW_STATIC_ASSERT);
            pair->node = dostaticassert();
            st = STASSERT;
            break;
        case KW_CRITICAL:
            swallow(KW_CRITICAL);
            pair->node = docritical();
            st = STCRITICAL;
            break;
        default:
            /* Not a keyword we dispatch on — try punctuator /
               non-keyword forms below. */
            break;
        }
        if (st == -1) {
            /* Non-keyword forms: opening brace, semicolon, #asm,
               and the bare `asm` identifier (not a C keyword in
               the sccz80 table). */
            TokenKind kind = tk_peek_kind_at_lptr();
            switch (kind) {
            case TK_LBRACE:
                cmatch('{');
                ++scope_block;
                pair->node = compound();
                st = lastst;
                break;
            case TK_SEMI:
                cmatch(';');
                st = lastst;
                break;
            case TK_HASH:
                if (match("#asm")) {
                    pair->node = doasm();
                    st = STASM;
                }
                break;
            case TK_IDENT:
                if (amatch("asm")) {
                    pair->node = doasmfunc(YES);
                    ns();
                    st = STASM;
                }
                break;
            default:
                break;
            }
        }
        if (st == -1) {
            /* if nothing else, assume it's an expression */
            pair->node = dolabel();

            if ( pair->node == NULL ) {
                pair->node = doexpr()->node;
                ns();
            }
            st = STEXP;
        }
    }
    lastst = st;
    pair->i = st;
    return (pair);
}

/*
 *      Semicolon enforcer
 *
 * called whenever syntax requires a semicolon
 */
void ns(void)
{
    if (cmatch(';') == 0)
        errorfmt("Expected ';'",1);
}

/*
 *      Compound statement
 *
 * allow any number of statements to fall between "{}"
 */
Node *compound(void)
{
    SYMBOL* savloc;
    array  *array = array_init(NULL);

    if (ncmp == MAX_LEVELS)
        errorfmt("Maximum nesting level reached (%d)", 1, ncmp);

    savloc = locptr;
    declared = 0; /* may declare local variables */
    ++ncmp; /* new level open */
    while (cmatch('}') == 0) {
        struct nodepair *pair = statement(); /* do one */
        array_add(array, pair->node);
    }
    --ncmp; /* close current level */
    sym_undecl_frame(array, savloc, lastst != STRETURN);

    locptr = savloc; /* delete local symbols */
    declared = 0;
    return ast_compound(array);
}


/*
 *    "iferror" statement
 *    This is z88dk specific and is used to check for
 *    an error from a package call..highly non standard!
 *
 *    I sense getting into trouble with purists but trying
 *    to combine C and asm compactly and efficiently requires
 *     this sort of extension (much like return_c/_nc
 */
Node *doiferror(void)
{
    /* AST-mode: the iferror legacy construct is no longer emitted —
       leaving it as a stub returning NULL. */
    statement();
    if (swallow(KW_ELSE) == 0) return NULL;
    statement();
    return NULL;
}   

/*
 *              "if" statement
 */
Node *doif(void)
{
    int flab1;
    Node *cond = NULL, *strue = NULL, *sfalse = NULL;
    struct nodepair *pair;

    flab1 = getlabel(); /* parser still allocates labels — useful for diagnostics */
    pair = test(flab1, YES);
    cond = pair->node;
    strue = statement()->node;

    if (swallow(KW_ELSE) == 0) {
        return ast_conditional(cond, strue, NULL);
    }
    pair = statement();
    sfalse = pair->node;
    return ast_conditional(cond, strue, sfalse);
}

/*
 * perform expression (including commas)
 */
struct nodepair *doexpr(void)
{
    zdouble val;
    int    vconst;
    Type   *type_ptr;
    array  *arr = array_init(NULL);
    struct nodepair *pair;

    while (1) {
        pair = expression(&vconst, &val, &type_ptr);
        array_add(arr, pair->node);
        /* Phase L3c-8b: cmatch already routes through the tokeniser
           (L3c-5) — peek-and-consume in one shimmed call. */
        if (!cmatch(',')) {
            pair->type = type_ptr;
            pair->node = ast_compound(arr);
            return pair;
        }
    }
}

/*
 *      "while" statement
 */
Node *dowhile(void)
{
    WHILE_TAB wq;
    struct nodepair *pair;
    Node     *body;
    Node     *cond;
    array *arr = array_init(NULL);

    addwhile(&wq);
    pair = test(wq.exit, YES);
    cond = pair->node;
    pair = statement();
    body = pair->node;
    delwhile();
    array_add(arr, ast_label(wq.loop, NULL));
    array_add(arr, ast_conditional(cond, body, ast_jump(wq.exit, NULL)));
    array_add(arr, ast_jump(wq.loop, NULL));
    array_add(arr, ast_label(wq.exit, NULL));

    return ast_compound(arr);
}

/*
 * "do - while" statement
 */
Node *dodo(void)
{
    WHILE_TAB wq;
    int top;
    struct nodepair *pair;
    Node *body;
    array *arr = array_init(NULL);

    addwhile(&wq);
    top = getlabel();
    pair = statement();
    body = pair->node;
    needtoken("while");
    pair = test(wq.exit, YES);
    delwhile();
    ns();

    array_add(arr,ast_label(top, NULL));
    array_add(arr,body);
    array_add(arr,ast_conditional(pair->node, ast_jump(top, NULL), NULL));
    array_add(arr,ast_label(wq.exit, NULL));

    return ast_compound(arr);
}

/*
 * "for" statement (zrin)
 */
Node *dofor(void)
{
    WHILE_TAB wq;
    int l_condition;
    struct nodepair *pair;
    Node *init = NULL;
    Node *cond = NULL;
    Node *incr = NULL;
    Node *body = NULL;
    array *arr = array_init(NULL);
    SYMBOL *savedloc;

    addwhile(&wq);
    l_condition = getlabel();
    savedloc = locptr;

    needchar('(');
    ++ncmp;
    if (cmatch(';') == 0) {
        if ( (init = declare_local(0)) == NULL ) {
            pair = doexpr();
            init = pair->node;
            ns();
        }
        (wqptr-1)->loop_symptr = locptr;
    }
    if (cmatch(';') == 0) {
        pair = test(wq.exit, NO);
        cond = pair->node;
        ns();
    }
    if (cmatch(')') == 0) {
        pair = doexpr();
        incr = pair->node;
        needchar(')');
    }
    pair = statement();
    body = pair->node;

    if ( init )
        array_add(arr, init);
    array_add(arr,ast_label(l_condition,NULL));
    array_add(arr,ast_conditional(cond, NULL, ast_jump(wq.exit,NULL)));
    if ( body )
        array_add(arr,body);
    array_add(arr,ast_label(wq.loop,NULL));
    if ( incr )
        array_add(arr,incr);
    array_add(arr,ast_jump(l_condition,NULL));
    array_add(arr,ast_label(wq.exit,NULL));

    sym_undecl_frame(arr, savedloc, 1);

    --ncmp;
    locptr = savedloc;
    declared = 0;
    delwhile();

    return ast_compound(arr);
}

/*
 * "switch" statement
 */
Node *doswitch(void)
{
    WHILE_TAB wq;
    int swact, swdef;
    SW_TAB *swnex, *swptr;
    Type   *switch_type;
    struct nodepair *pair, *sw_expr;
    array *arr = array_init(NULL);

    swact = swactive;
    swdef = swdefault;
    swnex = swptr = swnext;
    addwhile(&wq);
    (wqptr - 1)->loop = 0;
    needchar('(');
    sw_expr = doexpr();
    switch_type = sw_expr->type;
    needchar(')');
    swdefault = 0;
    swactive = 1;

    pair = statement();

    /* Collect dispatch cases into a local array — they belong inside
       the AST_SWITCH node so the walker can process the switch
       end-to-end without peeking at siblings. */
    array *cases = array_init(NULL);
    while (swptr < swnext ) {
        array_add(cases, ast_switch_case(switch_type,
                                         ast_literal(switch_type, swptr->value),
                                         swptr->label));
        ++swptr;
    }
    int default_label = swdefault ? swdefault : wq.exit;

    array_add(arr, ast_switch(switch_type, sw_expr->node, pair->node,
                              cases, default_label, wq.exit));

    delwhile();
    swnext = swnex;
    swdefault = swdef;
    swactive = swact;

    return ast_compound(arr);
}

/*
 * "case" statement
 */
Node *docase(void)
{
    double value;
    Kind   valtype;
    if (swactive == 0)
        errorfmt("Not in switch", 0 );
    if (swnext > swend) {
        errorfmt("Too many cases", 0 );
        return NULL;
    }
    swnext->label = getlabel();
    constexpr(&value,&valtype, 1);
    if ( kind_is_decimal(valtype))
        warningfmt("invalid-value","Unexpected floating point encountered, taking int value");
    swnext->value = value;
    needchar(':');
    ++swnext;
    return ast_label((swnext-1)->label, NULL);
}

Node *dodefault(void)
{
    if (swactive) {
        if (swdefault)
            errorfmt("Multiple defaults", 0);
    } else
        errorfmt("Not in switch", 0 );
    needchar(':');
    swdefault = getlabel();
    return ast_label(swdefault, NULL);
}

/*
 *      "return" statement
 */
Node *doreturn(char type)
{
    (void)type;
    array *arr = array_init(NULL);
    /* AST-mode: just build the AST_RETURN node. The walker
       (cg2_return) emits the conversion + gen_leave_function dance. */
    if (endst() == 0) {
        struct nodepair *pair;
        zdouble val;
        int    vconst;
        Type   *type_ptr;

        while (1) {
            pair = expression(&vconst, &val, &type_ptr);
            array_add(arr, pair->node);
            if (!cmatch(',')) break;
        }
    }
    sym_undecl_frame(arr, STARTLOC, 0);
    return ast_return(array_len(arr) == 1 ? array_get_byindex(arr,0) : ast_compound(arr), currfn->ctype->return_type);
}



/*
 *      "break" statement
 */
Node *dobreak(void)
{
    WHILE_TAB* ptr;
    SYMBOL *sptr;
    array *arr = array_init(NULL);

    /* see if any "whiles" are open */
    if ((ptr = readwhile(wqptr)) == 0)
        return NULL; /* no */

    sptr = locptr;
    while ( sptr != ptr->loop_symptr) {
        SYMBOL *ptr = sptr - 1;
        array_add(arr, ast_undecl(ptr));
        --sptr;
    }
    array_add(arr,ast_jump(ptr->exit, NULL));

    return ast_compound(arr);
}

/*
 *      "continue" statement
 */
Node *docont(void)
{
    WHILE_TAB* ptr;
    SYMBOL *sptr;
    array *arr = array_init(NULL);

    /* see if any "whiles" are open */
    ptr = wqptr;
    while (1) {
        if ((ptr = readwhile(ptr)) == 0)
            return NULL;
        /* try again if loop is zero (that's a switch statement) */
        if (ptr->loop)
            break;
    }
    sptr = locptr;
    while ( sptr != ptr->loop_symptr) {
        SYMBOL *ptr = sptr - 1;
        array_add(arr, ast_undecl(ptr));
        --sptr;
    }

    array_add(arr,ast_jump(ptr->loop, NULL));

    return ast_compound(arr);
}

static Node *docritical(void)
{
    struct nodepair *pair;
    if ( incritical ) {
        errorfmt("Cannot nest __critical sections", 1);
    }
    incritical = 1;
    pair = statement();
    incritical = 0;
    return ast_critical(pair->node);
}

/* Tiny grow-on-append byte buffer used by the asm capture below.
   Lives only across one statement; freed once the strdup'd payload
   has been handed to ast_asm(). */
typedef struct asm_buf {
    char *data;
    int   len;
    int   cap;
} asm_buf;

static void asm_buf_init(asm_buf *b) { b->data = NULL; b->len = 0; b->cap = 0; }

static void asm_buf_grow(asm_buf *b, int extra)
{
    int need = b->len + extra + 1;
    if (need <= b->cap) return;
    int newcap = b->cap ? b->cap : 64;
    while (newcap < need) newcap *= 2;
    b->data = realloc(b->data, newcap);
    b->cap = newcap;
}

static void asm_buf_putc(asm_buf *b, char c)
{
    asm_buf_grow(b, 1);
    b->data[b->len++] = c;
    b->data[b->len] = 0;
}

static void asm_buf_puts(asm_buf *b, const char *s)
{
    int n = (int)strlen(s);
    asm_buf_grow(b, n);
    memcpy(b->data + b->len, s, n);
    b->len += n;
    b->data[b->len] = 0;
}

/*
 *      asm()   statement
 *
 *      This doesn't do any label expansions - just chucks it out to
 *      the file, it might be useful for setting a value to machine
 *      code thing
 *
 *      If wantbr==YES then we need the opening bracket (called by
 *      itself)
 *
 *      Actually, this caution may be unneccesary because it is also
 *      dealt with as a function, we'll just have to see - i.e. maybe
 *      it doesn't have to be statement as well!
 *
 *      New: 3/3/99 djm
 *
 *      Captures the asm text into a buffer and hands it to ast_asm()
 *      so the walker emits it inline at the AST_ASM node. No direct
 *      outbyte/outstr — those would duplicate the walker's emit.
 */

Node *doasmfunc(char wantbr)
{
    int  lastwasLF = 0;
    asm_buf buf;
    asm_buf_init(&buf);

    if (wantbr)
        needchar('(');

    asm_buf_putc(&buf, '\t');

    /* The asm body is one or more adjacent string literals; the
       tokeniser has already concat'd them and decoded all escapes.
       Walk the resulting payload byte-by-byte, re-indenting each
       new logical line with a leading TAB. */
    if (tk_peek_kind_at_lptr() != TK_STRING) {
        errorfmt("Expected string literal", 1);
    } else {
        Token *tok = tk_peek(current_tokeniser, 0);
        int span = tok->source_end - tok->source_start;
        for (int i = 0; i < tok->text_len; i++) {
            unsigned char c = (unsigned char)tok->text[i];
            if ( lastwasLF && c != '\t' ) {
                asm_buf_putc(&buf, '\t');
            }
            if (c == '\n' || c == '\r') {
                lastwasLF = 1;
                asm_buf_putc(&buf, '\n');
            } else {
                lastwasLF = 0;
                asm_buf_putc(&buf, c);
            }
        }
        lptr += span;
        tk_consume(current_tokeniser);
    }

    needchar(')');
    if ( !lastwasLF ) {
        asm_buf_putc(&buf, '\n');
    }
    Node *n = ast_asm(buf.data ? buf.data : "");
    free(buf.data);
    return n;
}

/*
 *      "asm" pseudo-statement (for #asm/#endasm)
 *      enters mode where assembly language statement are
 *      passed intact through parser
 */

Node *doasm(void)
{
    asm_buf buf;
    asm_buf_init(&buf);
    cmode = 0; /* mark mode as "asm" */

    while (1) {
        preprocess(); /* get and print lines */
        if (match("#endasm") || eof) {
            break;
        }
        asm_buf_puts(&buf, line);
        asm_buf_putc(&buf, '\n');
    }
    clear(); /* invalidate line */
    if (eof)
        errorfmt("Unterminated assembler code",1);
    cmode = 1; /* then back to parse level */
    Node *n = ast_asm(buf.data ? buf.data : "");
    free(buf.data);
    return n;
}

static void set_section(char **dest_section) 
{
    char sname[NAMESIZE];

    if (symname(sname) == 0) {
        illname(sname);
        clear();
        return;
    }

    *dest_section = STRDUP(sname);
}

/* #pragma statement */
void dopragma(void)
{
    blanks();
    if (amatch("codeseg"))
        set_section(&c_code_section);
    else if (amatch("constseg"))
        set_section(&c_rodata_section);
    else if (amatch("dataseg"))
        set_section(&c_data_section);
    else if (amatch("bssseg"))
        set_section(&c_bss_section);
    else if (amatch("initseg"))
        set_section(&c_init_section);
    else if (amatch("bank")) {
        Kind valtype;
        double val;
        char   buf[100];

        if ( constexpr(&val, &valtype, 1) ) {
            snprintf(buf,sizeof(buf),"CODE_%d",(int)val);
            c_code_section = STRDUP(buf);
            snprintf(buf,sizeof(buf),"RODATA_%d",(int)val);
            c_rodata_section = STRDUP(buf);
        }
    }else {
        warningfmt("unknown-pragmas","Unknown #pragma directive");
        clear();
    }
}

static Node *dostaticassert(void)
{
    Kind   valtype;
    double val;
    double global_start;

    needchar('(');
    if (constexpr(&val,&valtype, 1) == 0) {
        val = 0;
    }
    needchar(',');
    qstr(&global_start);
    needchar(')');
    if ( val == 0 ) {
        errorfmt("_Static_assert failed: '%s'",1,&glbq[(int)global_start]);
    }
    // Restore literal queue
    gltptr = global_start;

    return NULL;
}
