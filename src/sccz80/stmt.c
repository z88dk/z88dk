/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part deals with statements
 *
 *      $Id: stmt.c,v 1.22 2016-04-05 20:23:34 dom Exp $
 */

#include "ccdefs.h"

static void     ns(void);
static void     compound(void);
static void     doiferror(void);
static void     doif(void);
static Type    *doexpr(void);
static void     dowhile(void);
static void     dodo(void);
static void     dofor(void);
static void     doswitch(void);
static void     docase(void);
static void     dodefault(void);
static void     doreturn(char);
static void     dobreak(void);
static void     docont(void);
static void     dostaticassert(void);

/*
 *      Some variables for goto and cleaning up after compound 
 *      statements
 */

extern void dogoto(void);
extern int dolabel(void);
static void docritical(void);
static int stkstor[MAX_LEVELS]; /* ZSp for each compound level */
static int lastline = 0;



static int swactive = 0; /* true inside a switch */
static int swdefault = 0; /* default label number, else 0 */
static int swdefault_sp = 0; /* compiler SP at the default label */

static int incritical = 0;  /* Are we in a __critical block */


/*
 *      Statement parser
 *
 * called whenever syntax requires a statement.
 * this routine performs that statement
 * and returns a number telling which one
 */
int statement(void)
{
    int st;
    int locstatic; /* have we had the static keyword */

    blanks();
    if (lineno != lastline) {
        lastline = lineno;
        if (c_cline_directive || c_intermix_ccode) 
            gen_emit_line(lineno);
    }
    if (ch() == 0 && eof) {
        return (lastst = STEXP);
    } else {

        if (amatch("extern")) {
            dodeclare(EXTERNAL);
            return lastst;
        }
        /* Ignore the register and auto keywords! */
        swallow("register");
        swallow("auto");

        /* Check to see if specified as static, and also for far and near */
        locstatic = amatch("static");

        if ( declare_local(locstatic) ) {
            return lastst;
        }        
        /* not a definition */
        if (declared >= 0) {
            Zsp = modstk(Zsp - declared, KIND_NONE, NO, YES);
            declared = 0;
        }
        st = -1;
        switch (ch()) {
        case '{':
            ++scope_block;
            inbyte();
            compound();
            st = lastst;
            break;
        case 'i':
            if (amatch("iferror")) {
                doiferror();
                st = STIF;
            } else if (amatch("if")) {
                doif();
                st = STIF;
            }
            break;
        case 'w':
            if (amatch("while")) {
                dowhile();
                st = STWHILE;
            }
            break;
        case 'd':
            if (amatch("do")) {
                dodo();
                st = STDO;
            } else if (amatch("default")) {
                dodefault();
                st = STDEF;
            }
            break;
        case 'f':
            if (amatch("for")) {
                dofor();
                st = STFOR;
            }
            break;
        case 's':
            if (amatch("switch")) {
                doswitch();
                st = STSWITCH;
            }
            break;
        case 'c':
            if (amatch("case")) {
                docase();
                st = STCASE;
            } else if (amatch("continue")) {
                docont();
                ns();
                st = STCONT;
            }
            break;
        case 'r':
            if (amatch("return")) {
                doreturn(0);
                ns();
                st = STRETURN;
            } else if (amatch("return_c")) {
                doreturn(1);
                ns();
                st = STRETURN;
            } else if (amatch("return_nc")) {
                doreturn(2);
                ns();
                st = STRETURN;
            }
            break;
        case 'b':
            if (amatch("break")) {
                dobreak();
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
                doasmfunc(YES);
                ns();
                st = STASM;
            }
            break;
        case 'g':
            if (amatch("goto")) {
                dogoto();
                ns();
                st = STGOTO;
            }
            break;
        case '#':
            if (match("#asm")) {
                doasm();
                st = STASM;
            }
            break;
        case '_':
            if (match("_Static_assert")) {
                dostaticassert();
                st = STASSERT;
            } else if (match("__critical")) {
                docritical();
                st = STCRITICAL;
            }
        }
        if (st == -1) {
            /* if nothing else, assume it's an expression */
            if (dolabel() == 0) {
                doexpr();
                ns();
            }
            st = STEXP;
        }
    }
    return (lastst = st);
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
void compound(void)
{
    SYMBOL* savloc;
    int     savblock = current_block;

    if (ncmp == MAX_LEVELS)
        errorfmt("Maximum nesting level reached (%d)", 1, ncmp);

    stkstor[ncmp] = Zsp;
    savloc = locptr;
    declared = 0; /* may declare local variables */
    current_block = scope_block; /* numbered by statement() */
    ++ncmp; /* new level open */
    while (cmatch('}') == 0)
        statement(); /* do one */
    --ncmp; /* close current level */
    current_block = savblock;
    if (lastst != STRETURN) {
        modstk(stkstor[ncmp], KIND_NONE, NO, YES); /* delete local variable space */
    }
    Zsp = stkstor[ncmp];
    locptr = savloc; /* delete local symbols */
    declared = 0;
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
void doiferror(void)
{
    int flab1, flab2;
    flab1 = getlabel(); /* Get label for false branch */
    jumpnc(flab1);
    statement();
    if (amatch("else") == 0) {
        /* no else, print false label and exit  */
        postlabel(flab1);
        return;
    }
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        gen_jp_label(flab2,0);
    }
    postlabel(flab1); /* print false label */
    statement(); /* and do 'else' clause */
    postlabel(flab2);
}   

/*
 *              "if" statement
 */
void doif(void)
{
    int flab1, flab2;
    int testtype;
    t_buffer *buf;
    
    flab1 = getlabel(); /* get label for false branch */
    testtype = test(flab1, YES); /* get expression, and branch false */

    buf = startbuffer(100);
    statement();

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
        return;
    }

    clearbuffer(buf);
    if ( testtype == 1 ) {
        // We evaluated the if to true, so we can discard the else
        t_buffer *buf2 = startbuffer(100);
        statement();
        discardbuffer(buf2);
        return;
    } 
    /* an "if...else" statement. */
    flab2 = getlabel();
    if (lastst != STRETURN) {
        /* if last statement of 'if' was 'return' we needn't skip 'else' code */
        gen_jp_label(flab2,1);
    }
    if ( testtype != 0 ) {
        postlabel(flab1); /* print false label */
    }
    statement(); /* and do 'else' clause */
    if ( testtype != 0 ) {
        postlabel(flab2); /* print true label */
    }
}

/*
 * perform expression (including commas)
 */
Type *doexpr(void)
{
    char *before, *start;
    zdouble val;
    int    vconst;
    Type   *type_ptr;

    while (1) {
        int saved_zsp = Zsp;
        int saved_temp = struct_temp_bytes;

        setstage(&before, &start);
        expression(&vconst, &val, &type_ptr);
        if (before) {
            /* The expression was thrown away. Do not free a temp whose
               allocation was thrown away with it. */
            clearstage(before, NULL);
            Zsp = saved_zsp;
            struct_temp_bytes = saved_temp;
        } else {
            clearstage(before, start);
            release_struct_temp();
        }
        if (ch() != ',')
            return type_ptr;
        inbyte();
    }
}

/*
 *      "while" statement
 */
void dowhile(void)
{
    WHILE_TAB wq; /* allocate local queue */
    t_buffer  *buf;
    int       exprconstant;

    addwhile(&wq); /* add entry to queue */
    /* (for "break" statement) */
    buf = startbuffer(100);
    postlabel(wq.loop); /* loop label */
    exprconstant = test(wq.exit, YES); /* see if true */
    if ( exprconstant == 0 ) {
        t_buffer *buf2 = startbuffer(100);
        statement();
        discardbuffer(buf2);
        clearbuffer(buf);
    } else {
        statement(); /* if so, do a statement */
        gen_jp_label(wq.loop, 1); /* loop to label */
        postlabel(wq.exit); /* exit label */
        clearbuffer(buf);
    }
    delwhile(); /* delete queue entry */
}

/*
 * "do - while" statement
 */
void dodo(void)
{
    WHILE_TAB wq;
    int top;
    int testresult;

    addwhile(&wq);
    postlabel(top = getlabel());
    statement();
    needtoken("while");
    postlabel(wq.loop);
    testresult = test(wq.exit, YES);
    if ( testresult == 0 ) { // False
        // Post the exit label in case there were any breaks
        postlabel(wq.exit);
    } else {
        gen_jp_label(top, 1);
        postlabel(wq.exit);
    }
    delwhile();
    ns();
}

/*
 * "for" statement (zrin)
 */
void dofor(void)
{
    WHILE_TAB wq;
    int l_condition;
    int savedsp;
    int testresult = 1; // Default is true
    int savblock = current_block;

    SYMBOL *savedloc;
    t_buffer *buf2, *buf3,*buf4;

    addwhile(&wq);
    l_condition = getlabel();
    savedsp = Zsp;
    savedloc = locptr;

    needchar('(');
    ++scope_block;
    current_block = scope_block; /* the for scope is a block of its own: header and body */
    ++ncmp;
    if (cmatch(';') == 0) {
        if ( declare_local(0) == 0 ) {
            doexpr(); /*         initialization             */
            ns();
        }
        (wqptr-1)->sp = wq.sp = Zsp;
    }

    buf2 = startbuffer(1); /* save condition to buf2 */
    if (cmatch(';') == 0) {
        testresult = test(wq.exit, NO); /* expr 2 */
        ns();
    }
    suspendbuffer();

    buf3 = startbuffer(1); /* save modification to buf3 */
    if (cmatch(')') == 0) {
        doexpr(); /* expr 3 */
        needchar(')');
    }
    suspendbuffer();

    if ( testresult != 0 ) {  /* So it's either true or non-constant */
        gen_jp_label(l_condition,1); /*         goto condition             */
        postlabel(wq.loop); /* .loop                              */
        clearbuffer(buf3); /*         modification               */
        postlabel(l_condition); /* .condition                         */
        clearbuffer(buf2); /*         if (!condition) goto exit  */
        statement(); /*         statement                  */
        gen_jp_label(wq.loop,1); /*         goto loop                  */
        postlabel(wq.exit); /* .exit                              */
    } else {
        clearbuffer(buf2); // Condition
        discardbuffer(buf3); // modification is not emitted
        buf4 = startbuffer(100);
        statement(); // Evaluate it
        discardbuffer(buf4);
    }
    --ncmp;
    current_block = savblock;
    modstk(savedsp, KIND_NONE, NO, YES);
    Zsp = savedsp;
    locptr = savedloc;
    declared = 0;
    delwhile();
}

/* Cases belonging to the switch whose body is being parsed. */
static SW_TAB *swcase;
static Type   *swtype;

/* A case constant has to fit the switch expression. An unsigned long
   long holds every bit pattern we can record. */
static int case_fits(Type *type, int64_t value)
{
    int bits;

    if (type == NULL)
        return 1;
    if (type->kind == KIND_CHAR)
        bits = 8;
    else if (type->kind == KIND_INT || type->kind == KIND_SHORT)
        bits = 16;
    else if (type->kind == KIND_LONG)
        bits = 32;
    else if (type->kind == KIND_LONGLONG)
        bits = 64;
    else
        return 1;

    if (isutype(type)) {
        if (bits >= 64)
            return 1;
        if (value < 0)
            return 0;
        return (uint64_t)value < (UINT64_C(1) << bits);
    }
    if (bits >= 64)
        return 1;
    return value >= -(int64_t)(UINT64_C(1) << (bits - 1))
        && value <= (int64_t)((UINT64_C(1) << (bits - 1)) - 1);
}

/*
 * "switch" statement
 */
void doswitch(void)
{
    WHILE_TAB wq;
    int endlab, swact, swdef, swdef_sp, entry_sp;
    SW_TAB *swnex, *swptr, *p;
    SW_TAB *saved_case = swcase;
    Type   *saved_type = swtype;
    Type   *switch_type;
    t_buffer* buf;

    swact = swactive;
    swdef = swdefault;
    swdef_sp = swdefault_sp;
    swnex = swptr = swcase = swnext;
    swtype = NULL;
    addwhile(&wq);
    (wqptr - 1)->loop = 0;
    needchar('(');
    switch_type = doexpr(); /* evaluate switch expression */
    needchar(')');
    swdefault = 0;
    swdefault_sp = 0;
    swactive = 1;
    swtype = switch_type;
    endlab = getlabel();
    /* gen_jp_label(endlab) ; */

    /* Locals of this block are allocated in the buffered body, before
       the case label. The dispatcher jumps to the label, so a case
       reached that way must be entered at the depth the label was
       compiled for. Fall-through still runs the allocation itself.
       addwhile() sampled Zsp before the expression; break has to
       restore the same depth the body was compiled against. */
    entry_sp = Zsp;
    wq.sp = entry_sp;
    (wqptr - 1)->sp = entry_sp;
    buf = startbuffer(100);
    statement(); /* cases, etc. */
    /* gen_jp_label(wq.exit) ; */
    suspendbuffer();

    {
        int ncase = (int)(swnext - swptr);
        int stub[NUMCASE];
        int def_stub = 0;
        int i;
        int saved_sp;

        for (i = 0, p = swptr; i < ncase; i++, p++) {
            stub[i] = (p->sp != entry_sp) ? getlabel() : 0;
        }
        if (swdefault && swdefault_sp != entry_sp)
            def_stub = getlabel();

        postlabel(endlab);
        gen_switch_preamble(switch_type->kind);
        for (i = 0, p = swptr; i < ncase; i++, p++) {
            gen_switch_case(switch_type->kind, p->value,
                            stub[i] ? stub[i] : p->label);
        }
        gen_switch_postamble(switch_type->kind);
        if (swdefault)
            gen_jp_label(def_stub ? def_stub : swdefault, 1);
        else
            gen_jp_label(wq.exit, 1);

        saved_sp = Zsp;
        for (i = 0, p = swptr; i < ncase; i++, p++) {
            if (!stub[i])
                continue;
            /* Each stub is relative to entry. modstk does not assign Zsp. */
            Zsp = entry_sp;
            postlabel(stub[i]);
            modstk(p->sp, KIND_NONE, NO, YES);
            gen_jp_label(p->label, 1);
        }
        if (def_stub) {
            Zsp = entry_sp;
            postlabel(def_stub);
            modstk(swdefault_sp, KIND_NONE, NO, YES);
            gen_jp_label(swdefault, 1);
        }
        Zsp = saved_sp;
    }

    clearbuffer(buf);

    postlabel(wq.exit);
    delwhile();
    swnext = swnex;
    swdefault = swdef;
    swdefault_sp = swdef_sp;
    swactive = swact;
    swcase = saved_case;
    swtype = saved_type;
}

/*
 * "case" statement
 */
void docase(void)
{
    double value;
    uint64_t ival;
    int    ival_valid;
    int    cuns = 0;
    Kind   valtype;
    int64_t cvalue;
    if (swactive == 0)
        errorfmt("Not in switch", 0 );
    if (swnext > swend) {
        errorfmt("Too many cases", 0 );
        return;
    }
    postlabel(swnext->label = getlabel());
    swnext->sp = Zsp;
    constexpr_exact(&value, &ival, &ival_valid, &valtype, 1, &cuns);
    if ( kind_is_decimal(valtype)) 
        warningfmt("invalid-value","Unexpected floating point encountered, taking int value");
    /* A double cannot hold every integer above 2^53. */
    if (ival_valid && !kind_is_decimal(valtype))
        cvalue = (int64_t)ival;
    else
        cvalue = (int64_t)value;
    if (swactive && swcase) {
        SW_TAB *p;

        for (p = swcase; p < swnext; p++) {
            if (p->value == cvalue) {
                errorfmt("Duplicate case value", 0);
                break;
            }
        }
    }
    /* An unsigned constant above 2^63-1 becomes negative in int64_t
       and then looks in range for a signed long long. */
    if (swactive && cuns && ival_valid && !kind_is_decimal(valtype)
        && swtype && !isutype(swtype) && (int64_t)ival < 0)
        warningfmt("limited-range", "Case value is out of range");
    else if (swactive && case_fits(swtype, cvalue) == 0)
        warningfmt("limited-range", "Case value is out of range");
    swnext->value = cvalue;
    needchar(':');
    ++swnext;
}

void dodefault(void)
{
    if (swactive) {
        if (swdefault)
            errorfmt("Multiple defaults", 0);
    } else
        errorfmt("Not in switch", 0 );
    needchar(':');
    postlabel(swdefault = getlabel());
    swdefault_sp = Zsp;
}

/*
 *      "return" statement
 */
void doreturn(char type)
{
    /* if not end of statement, get an expression */
    if (endst() == 0) {
        char *before, *start;

        if (currfn->ctype->return_type->kind == KIND_VOID)
            warningfmt("void", "Returning a value from a void function");
        zdouble val;
        int    vconst;
        Type   *type_ptr;

        while (1) {
            int saved_zsp = Zsp;
            int saved_temp = struct_temp_bytes;

            setstage(&before, &start);
            expression(&vconst, &val, &type_ptr);
            // If it's a constant and last, clear the load and load as a constant of the right
            // type
            if ( vconst && ch() != ',') {
                LVALUE lval = {0};
                clearstage(before, NULL);
                lval.val_type = currfn->ctype->return_type->kind;
                lval.const_val = val;
                load_constant(&lval);
                gen_leave_function(currfn->ctype->return_type->kind, type, incritical);
                return;
            }
            if (ch() != ',')
                break;
            if (before) {
                clearstage(before, NULL);
                Zsp = saved_zsp;
                struct_temp_bytes = saved_temp;
            } else {
                clearstage(before, start);
                release_struct_temp();
            }
            inbyte();
        }
        /* The last expression is still staged. Convert it before the flush
           so a trailing complement is still the last line. */
        if (before == NULL) {
            force(currfn->ctype->return_type->kind, type_ptr->kind, currfn->ctype->return_type->isunsigned, type_ptr->isunsigned, 0);
        }
        clearstage(before, start);
        if (before != NULL) {
            int saved = narrow_byte_unop;

            narrow_byte_unop = 0;
            force(currfn->ctype->return_type->kind, type_ptr->kind, currfn->ctype->return_type->isunsigned, type_ptr->isunsigned, 0);
            narrow_byte_unop = saved;
        }
        gen_leave_function(currfn->ctype->return_type->kind, type, incritical);
    } else {
        gen_leave_function(KIND_INT, type, incritical);
    }
}



/*
 *      "break" statement
 */
void dobreak(void)
{
    WHILE_TAB* ptr;

    /* see if any "whiles" are open */
    if ((ptr = readwhile(wqptr)) == 0)
        return; /* no */
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */
    gen_jp_label(ptr->exit,1); /* jump to exit label */
}

/*
 *      "continue" statement
 */
void docont(void)
{
    WHILE_TAB* ptr;

    /* see if any "whiles" are open */
    ptr = wqptr;
    while (1) {
        if ((ptr = readwhile(ptr)) == 0)
            return;
        /* try again if loop is zero (that's a switch statement) */
        if (ptr->loop)
            break;
    }
    modstk(ptr->sp, KIND_NONE, NO, YES); /* else clean up stk ptr */
    gen_jp_label(ptr->loop,1); /* jump to loop label */
}

static void docritical(void)
{
    if ( incritical ) {
        errorfmt("Cannot nest __critical sections", 1);
    }
    incritical = 1;
    gen_critical_enter();
    statement();
    gen_critical_leave();
    incritical = 0;
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

void doasmfunc(char wantbr)
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
}

/*
 *      "asm" pseudo-statement (for #asm/#endasm)
 *      enters mode where assembly language statement are
 *      passed intact through parser
 */

void doasm(void)
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
}

/* One slot for each section name. The defaults are literals, and
   --codeseg stores an argv pointer, so only a name allocated here
   is freed. */
static char *heap_section[5];

static void replace_section(char **dest, const char *name)
{
    char *copy = STRDUP(name);
    int   i;

    for (i = 0; i < 5; i++) {
        if (heap_section[i] == *dest) {
            free(*dest);
            heap_section[i] = copy;
            *dest = copy;
            return;
        }
    }
    for (i = 0; i < 5; i++) {
        if (heap_section[i] == NULL) {
            heap_section[i] = copy;
            *dest = copy;
            return;
        }
    }
    *dest = copy;
}

void free_section_names(void)
{
    char **dest[5];
    int    i, j;

    dest[0] = &c_code_section;
    dest[1] = &c_rodata_section;
    dest[2] = &c_data_section;
    dest[3] = &c_bss_section;
    dest[4] = &c_init_section;
    for (i = 0; i < 5; i++) {
        if (heap_section[i] == NULL)
            continue;
        for (j = 0; j < 5; j++) {
            if (*dest[j] == heap_section[i])
                *dest[j] = NULL;
        }
        free(heap_section[i]);
        heap_section[i] = NULL;
    }
}

static void set_section(char **dest_section) 
{
    char sname[NAMESIZE];

    if (symname(sname) == 0) {
        illname(sname);
        clear();
        return;
    }

    replace_section(dest_section, sname);
}

/* #pragma statement */
void dopragma(void)
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
        int    have_bank = 0;

        blanks();
        if ( isdigit((unsigned char)ch()) ) {
            /* A plain number is read here. The expression parser looks at the
               next line for an operator, and eats the first word of the
               declaration that follows the pragma. */
            char *end;

            val = strtol(&line[lptr], &end, 0);
            lptr += end - &line[lptr];
            have_bank = 1;
        } else {
            have_bank = constexpr(&val, &valtype, 1);
        }

        if ( have_bank ) {
            snprintf(buf,sizeof(buf),"CODE_%d",(int)val);
            replace_section(&c_code_section, buf);
            snprintf(buf,sizeof(buf),"RODATA_%d",(int)val);
            replace_section(&c_rodata_section, buf);
        }
    }else {
        warningfmt("unknown-pragmas","Unknown #pragma directive");
        clear();
    }
}

static void dostaticassert(void) 
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

}
