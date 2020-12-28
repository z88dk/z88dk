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
static int stkstor[MAX_LEVELS]; /* ZSp for each compound level */
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
struct nodepair *statement()
{
    int st = 0;
    int locstatic; /* have we had the static keyword */
    struct nodepair *pair = calloc(1,sizeof(*pair));
    Node   *node;

    blanks();
    if (lineno != lastline) {
        lastline = lineno;
        if (c_cline_directive || c_intermix_ccode) 
            gen_emit_line(lineno);
    }
    if (ch() == 0 && eof) {
        lastst = st;
        pair->i = st;
        return pair;
    } else {

        if (amatch("extern")) {
            dodeclare(EXTERNAL);
            lastst = st;
            pair->i = st;
            return pair;
        }
        /* Ignore the register and auto keywords! */
        swallow("register");
        swallow("auto");

        /* Check to see if specified as static, and also for far and near */
        locstatic = amatch("static");

        if ( (node = declare_local(locstatic)) != NULL ) {
            lastst = st;
            pair->i = st;
            pair->node = node;
            return pair;
        }        
        /* not a definition */
        if (declared >= 0) {
            Zsp = modstk(Zsp - declared, KIND_NONE, NO, YES);
            declared = 0;
        }
        st = -1;
        switch (ch()) {
        case '{':
            inbyte();
            pair->node = compound();
            st = lastst;
            break;
        case 'i':
            if (amatch("iferror")) {
                pair->node = doiferror();
                st = STIF;
            } else if (amatch("if")) {
                pair->node = doif();
                st = STIF;
            }
            break;
        case 'w':
            if (amatch("while")) {
                pair->node = dowhile();
                st = STWHILE;
            }
            break;
        case 'd':
            if (amatch("do")) {
                pair->node = dodo();
                st = STDO;
            } else if (amatch("default")) {
                pair->node = dodefault();
                st = STDEF;
            }
            break;
        case 'f':
            if (amatch("for")) {
                pair->node = dofor();
                st = STFOR;
            }
            break;
        case 's':
            if (amatch("switch")) {
                pair->node = doswitch();
                st = STSWITCH;
            }
            break;
        case 'c':
            if (amatch("case")) {
                pair->node = docase();
                st = STCASE;
            } else if (amatch("continue")) {
                pair->node = docont();
                ns();
                st = STCONT;
            }
            break;
        case 'r':
            if (amatch("return")) {
                pair->node = doreturn(0);
                ns();
                st = STRETURN;
            } else if (amatch("return_c")) {
                pair->node = doreturn(1);
                ns();
                st = STRETURN;
            } else if (amatch("return_nc")) {
                pair->node = doreturn(2);
                ns();
                st = STRETURN;
            }
            break;
        case 'b':
            if (amatch("break")) {
                pair->node = dobreak();
                ns();
                st = STBREAK;
            }
            break;
        case ';':
            inbyte();
            st = lastst;
            break;
        case 'a':
            if (amatch("asm")) {
                pair->node = doasmfunc(YES);
                ns();
                st = STASM;
            }
            break;
        case 'g':
            if (amatch("goto")) {
                pair->node = dogoto();
                ns();
                st = STGOTO;
            }
            break;
        case '#':
            if (match("#asm")) {
                pair->node = doasm();
                st = STASM;
            }
            break;
        case '_':
            if (match("_Static_assert")) {
                pair->node = dostaticassert();
                st = STASSERT;
            } else if (match("__critical")) {
                pair->node = docritical();
                st = STCRITICAL;
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
void ns()
{
    if (cmatch(';') == 0)
        errorfmt("Expected ';'",1);
}

/*
 *      Compound statement
 *
 * allow any number of statements to fall between "{}"
 */
Node *compound()
{
    SYMBOL* savloc;
    array  *array = array_init(NULL);

    if (ncmp == MAX_LEVELS)
        errorfmt("Maximum nesting level reached (%d)", 1, ncmp);

    stkstor[ncmp] = Zsp;
    savloc = locptr;
    declared = 0; /* may declare local variables */
    ++ncmp; /* new level open */
    while (cmatch('}') == 0) {
        struct nodepair *pair = statement(); /* do one */
        array_add(array, pair->node);
    }
    --ncmp; /* close current level */
    // NODE: Remove 
    if (lastst != STRETURN) {
        modstk(stkstor[ncmp], KIND_NONE, NO, YES); /* delete local variable space */
    }
    Zsp = stkstor[ncmp];
    // NODE: End remove
    sym_undecl_frame(array, savloc, lastst != STRETURN);

   // locptr = savloc; /* delete local symbols */
    declared = 0;
    return ast_compound(array);
}


Node *doiferror()
{
    int flab1, flab2;
    flab1 = getlabel(); /* Get label for false branch */
    jumpnc(flab1);
    statement();
    if (amatch("else") == 0) {
        /* no else, print false label and exit  */
        postlabel(flab1);
        return NULL;
    }
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        gen_jp_label(flab2);
    }
    postlabel(flab1); /* print false label */
    statement(); /* and do 'else' clause */
    postlabel(flab2);
    return NULL;
}   

/*
 *              "if" statement
 */
Node *doif()
{
    int flab1, flab2;
    int testtype;
    t_buffer *buf;
    Node *cond = NULL, *strue = NULL, *sfalse = NULL;
    struct nodepair *pair;

    flab1 = getlabel(); /* get label for false branch */
    pair = test(flab1, YES); /* get expression, and branch false */
    testtype = pair->i;
    cond = pair->node;

    buf = startbuffer(100);
    strue = statement()->node;

    if ( testtype == 0 ) {
        discardbuffer(buf);
        buf = NULL;
        lastst = STRETURN;
    }

    if (amatch("else") == 0) {
        /* no else, print false label and exit  */
        if ( testtype < 0 ) {
            postlabel(flab1);
            clearbuffer(buf);
        } else if  (testtype ==  1 ) { /* Evaluate to true */
            clearbuffer(buf);
        }
        return ast_conditional(cond, strue, NULL);
    }

    clearbuffer(buf);
    if ( testtype == 1 ) {
        // We evaluated the if to true, so we can discard the else
        t_buffer *buf2 = startbuffer(100);
        pair = statement();
        discardbuffer(buf2);
        return ast_conditional(cond, strue, NULL);
    } 
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        gen_jp_label(flab2);
    }
    if ( testtype != 0 ) {
        postlabel(flab1); /* print false label */
    }
    pair = statement(); /* and do 'else' clause */
    sfalse = pair->node;
    if ( testtype != 0 ) {
        postlabel(flab2); /* print true label */
    }

    return ast_conditional(cond, strue, sfalse);
}

/*
 * perform expression (including commas)
 */
struct nodepair *doexpr()
{
    char *before, *start;
    zdouble val;
    int    vconst;
    Type   *type_ptr;
    array  *arr = array_init(NULL);
    struct nodepair *pair;

    while (1) {
        setstage(&before, &start);
        pair = expression(&vconst, &val, &type_ptr);
        array_add(arr, pair->node);
        clearstage(before, start);
        if (ch() != ',') {
            pair->type = type_ptr;
            pair->node = ast_compound(arr);
            return pair;
        }
        inbyte();
    }
}

/*
 *      "while" statement
 */
Node *dowhile()
{
    WHILE_TAB wq; /* allocate local queue */
    t_buffer  *buf;
    struct nodepair *pair;
    Node     *body;
    int       exprconstant;
    array *arr = array_init(NULL);

    addwhile(&wq); /* add entry to queue */
    /* (for "break" statement) */
    buf = startbuffer(100);
    postlabel(wq.loop); /* loop label */
    pair = test(wq.exit, YES); /* see if true */
    exprconstant = pair->i;
    if ( exprconstant == 0 ) {
        t_buffer *buf2 = startbuffer(100);
        pair = statement();
        body = pair->node;
        discardbuffer(buf2);
        clearbuffer(buf);
    } else {
        pair = statement(); /* if so, do a statement */
        body = pair->node;
        gen_jp_label(wq.loop); /* loop to label */
        postlabel(wq.exit); /* exit label */
        clearbuffer(buf);
    }
    delwhile(); /* delete queue entry */
    array_add(arr, ast_label(wq.loop, NULL));
    array_add(arr, ast_conditional(pair->node,body,ast_jump(wq.exit,NULL)));
    array_add(arr, ast_jump(wq.loop, NULL));
    array_add(arr, ast_label(wq.exit, NULL));

    return ast_compound(arr);
}

/*
 * "do - while" statement
 */
Node *dodo()
{
    WHILE_TAB wq;
    int top;
    int testresult;
    struct nodepair *pair;
    Node *body;
    array *arr = array_init(NULL);

    addwhile(&wq);
    postlabel(top = getlabel());
    pair = statement();
    body = pair->node;
    needtoken("while");
    postlabel(wq.loop);
    pair = test(wq.exit, YES);

    testresult = pair->i;

    if ( testresult == 0 ) { // False
        // We don't need to do anything
    } else {
        gen_jp_label(top);
        postlabel(wq.exit);
    }
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
Node *dofor()
{
    WHILE_TAB wq;
    int l_condition;
    int savedsp;
    struct nodepair *pair;
    Node *init = NULL;
    Node *cond = NULL;
    Node *incr = NULL;
    Node *body = NULL;
    array *arr = array_init(NULL);
    int testresult = 1; // Default is true

    SYMBOL *savedloc;
    t_buffer *buf2, *buf3,*buf4;

    addwhile(&wq);
    l_condition = getlabel();
    savedsp = Zsp;
    savedloc = locptr;

    needchar('(');
    ++ncmp;
    if (cmatch(';') == 0) {
        if ( (init = declare_local(0)) == NULL ) { // TODO
            pair = doexpr(); /*         initialization             */
            init = pair->node;
            ns();
        }
        (wqptr-1)->sp = wq.sp = Zsp;
        (wqptr-1)->loop_symptr = locptr;
    }

    buf2 = startbuffer(1); /* save condition to buf2 */
    if (cmatch(';') == 0) {
        pair = test(wq.exit, NO); /* expr 2 */
        testresult = pair->i;
        cond = pair->node;
        ns();
    }
    suspendbuffer();

    buf3 = startbuffer(1); /* save modification to buf3 */
    if (cmatch(')') == 0) {
        pair = doexpr(); /* expr 3 */
        incr = pair->node;
        needchar(')');
    }
    suspendbuffer();

    if ( testresult != 0 ) {  /* So it's either true or non-constant */      
        postlabel(l_condition); /* .condition                         */
        clearbuffer(buf2); /*         if (!condition) goto exit  */
        pair = statement(); /*         statement                  */
        body = pair->node;
        postlabel(wq.loop); /* .loop                              */
        clearbuffer(buf3); /*         modification               */
        gen_jp_label(l_condition); /*         goto loop                  */
        postlabel(wq.exit) ; /* .exit                              */
    } else {
        clearbuffer(buf2); // Condition 
        buf4 = startbuffer(100);
        pair = statement(); // Evaluate it
        body = pair->node;
        discardbuffer(buf4);
    }

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
    modstk(savedsp, KIND_NONE, NO, YES);
    Zsp = savedsp;
   // locptr = savedloc;
    declared = 0;
    delwhile();



    return ast_compound(arr);
}

/*
 * "switch" statement
 */
Node *doswitch()
{
    WHILE_TAB wq;
    int endlab, swact, swdef;
    SW_TAB *swnex, *swptr;
    Type   *switch_type;
    t_buffer* buf;
    struct nodepair *pair, *sw_expr;
    array *arr = array_init(NULL);

    swact = swactive;
    swdef = swdefault;
    swnex = swptr = swnext;
    addwhile(&wq);
    (wqptr - 1)->loop = 0;
    needchar('(');
    sw_expr = doexpr(); /* evaluate switch expression */
    switch_type = sw_expr->type;
    needchar(')');
    swdefault = 0;
    swactive = 1;


    buf = startbuffer(100);
    pair = statement(); /* cases, etc. */
    /* gen_jp_label(wq.exit) ; */
    suspendbuffer();

    gen_switch_preamble(switch_type->kind);
    array_add(arr,ast_switch(switch_type, sw_expr->node, pair->node));

    // Switch needs:
    // - switch expr
    // - cases
    // - default

    while (swptr < swnext ) {
        gen_switch_case(switch_type->kind, swptr->value, swptr->label);
        array_add(arr, ast_switch_case(switch_type, ast_literal(switch_type, swptr->value), swptr->label));
        ++swptr;
    }
    gen_switch_postamble(switch_type->kind);
    if (swdefault) {
        array_add(arr, ast_jump(swdefault,NULL));
        gen_jp_label(swdefault);
    } else {
        array_add(arr, ast_jump(wq.exit,NULL));
        gen_jp_label(wq.exit);
    }

    clearbuffer(buf);

    array_add(arr, ast_label(wq.exit,NULL));
    postlabel(wq.exit);
    delwhile();
    swnext = swnex;
    swdefault = swdef;
    swactive = swact;

    return ast_compound(arr);
}

/*
 * "case" statement
 */
Node *docase()
{
    double value;
    Kind   valtype;
    if (swactive == 0)
        errorfmt("Not in switch", 0 );
    if (swnext > swend) {
        errorfmt("Too many cases", 0 );
        return NULL;
    }
    postlabel(swnext->label = getlabel());
    constexpr(&value,&valtype, 1);
    if ( kind_is_floating(valtype)) 
        warningfmt("invalid-value","Unexpected floating point encountered, taking int value");
    swnext->value = value;
    needchar(':');
    ++swnext;
    return ast_label((swnext-1)->label, NULL);
}

Node *dodefault()
{
    if (swactive) {
        if (swdefault)
            errorfmt("Multiple defaults", 0);
    } else
        errorfmt("Not in switch", 0 );
    needchar(':');
    postlabel(swdefault = getlabel());
    return ast_label(swdefault, NULL);
}

/*
 *      "return" statement
 */
Node *doreturn(char type)
{
    array *arr = array_init(NULL);
    /* if not end of statement, get an expression */
    if (endst() == 0) {
        struct nodepair *pair;
        char *before, *start;
        zdouble val;
        int    vconst;
        Type   *type_ptr;

        while (1) {
            setstage(&before, &start);
            pair = expression(&vconst, &val, &type_ptr);
            array_add(arr,pair->node);
            // If it's a constant and last, clear the load and load as a constant of the right
            // type
            if ( vconst && ch() != ',') {
                LVALUE lval = {0};
                clearstage(before, NULL);
                lval.val_type = currfn->ctype->return_type->kind;
                lval.const_val = val;
                load_constant(&lval);
                gen_leave_function(currfn->ctype->return_type->kind, type, incritical);
                sym_undecl_frame(arr, STARTLOC, 0);
                return ast_return(array_len(arr) == 1 ? array_get_byindex(arr,0) : ast_compound(arr));
            }
            clearstage(before, start);
            if (ch() != ',')
                break;
            inbyte();
        }
        force(currfn->ctype->return_type->kind, type_ptr->kind, currfn->ctype->return_type->isunsigned, type_ptr->isunsigned, 0);
        gen_leave_function(currfn->ctype->return_type->kind, type, incritical);
    } else {
        gen_leave_function(KIND_INT, type, incritical);
    }
    sym_undecl_frame(arr, STARTLOC, 0);
    return ast_return(array_len(arr) == 1 ? array_get_byindex(arr,0) : ast_compound(arr));
}



/*
 *      "break" statement
 */
Node *dobreak()
{
    WHILE_TAB* ptr;
    SYMBOL *sptr;
    array *arr = array_init(NULL);

    /* see if any "whiles" are open */
    if ((ptr = readwhile(wqptr)) == 0)
        return NULL; /* no */
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */

    gen_jp_label(ptr->exit); /* jump to exit label */

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
Node *docont()
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
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */
    gen_jp_label(ptr->loop); /* jump to loop label */

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
    gen_critical_enter();
    pair = statement();
    gen_critical_leave();
    incritical = 0;
    return ast_critical(pair->node);
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
 */

Node *doasmfunc(char wantbr)
{
    char c;
    int  lastwasLF = 0;
    if (wantbr)
        needchar('(');

    outbyte('\t');
    needchar('"');
    do {
        while (!acmatch('"')) {
            c = litchar();
            if (c == 0)
                break;
            if ( lastwasLF && c != '\t' ) {
                outstr("\t");
            }
            if (c == '\n' || c == '\r') {
                lastwasLF = 1;
                outbyte('\n');
            } else {
                lastwasLF = 0;
                outbyte(c);
            }
        }
    } while (cmatch('"'));
    needchar(')');
    if ( !lastwasLF ) {
        outbyte('\n');
    }
    return NULL;
}

/*
 *      "asm" pseudo-statement (for #asm/#endasm)
 *      enters mode where assembly language statement are
 *      passed intact through parser
 */

Node *doasm()
{
    cmode = 0; /* mark mode as "asm" */

#ifdef INBUILT_OPTIMIZER
    generate(); /* Dump queued stuff to be opt'd */
#endif
    while (1) {
        preprocess(); /* get and print lines */
        if (match("#endasm") || eof) {
            break;
        }
        outfmt("%s\n",line);
    }
    clear(); /* invalidate line */
    if (eof)
        errorfmt("Unterminated assembler code",1);
    cmode = 1; /* then back to parse level */
    return NULL;
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
void dopragma()
{
    blanks();
    if (amatch("proto"))
        addmac();
    else if (amatch("set"))
        addmac();
    else if (amatch("unproto"))
        delmac();
    else if (amatch("unset"))
        delmac();
    else if (amatch("codeseg"))
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

static Node *dostaticassert() 
{
    Kind   valtype;
    double val;
    double global_start;
    char   *before, *start;

    needchar('(');
    setstage(&before, &start);
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
    clearstage(before, NULL);

    return NULL;
}
