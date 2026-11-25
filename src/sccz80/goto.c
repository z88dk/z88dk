/*
 *      The scheme is:
 *
 *      1. If label defined and we hit goto, adjust stack and jump
 *         directly to label
 *      2. If label not defined keep in goto queue
 *      3. If we hit a label and it has been previously goto'd to, we
 *         will scan through the goto table looking for ptrs to our
 *         label. The same stack, the same critical depth and the same
 *         critical mark share a label. Anything else stays in the queue.
 *      4. If the stack or the critical depth is uneven, keep in queue
 *         and deal with at function end
 *      5. Literal labels are used for goto labels i.e. getlabel()
 *      6. All gotos are kept in global variable space
 *      7. We endeavour to wipe all trace of goto labels from
 *         global symbol table on exit
 */

#include "ccdefs.h"


static int AddGoto(SYMBOL*);
static void ChaseGoto(SYMBOL* ptr);
static GOTO_TAB* SearchGoto(SYMBOL* ptr);
static SYMBOL* findgoto(char*);
static SYMBOL* addgotosym(char*);

/*
 * Some nice variables for us!
 */

GOTO_TAB* gotoq;
static int gotocnt = 0;

/*
 *      Endeavour to find a label for a goto statement
 *
 *      We chase up the goto stack adjust queue after leaving function
 */

int dolabel(void)
{
    int savelptr;
    char sname[NAMESIZE];
    SYMBOL* ptr;
    blanks();
    savelptr = lptr;
    if (symname(sname)) {
        if (gch() == ':') {
            if ((ptr = findgoto(sname)) && ptr->ident == ID_GOTOLABEL) {
                /* Label already goto'd. Match the stack, the critical
                   depth and the critical mark before sharing the label. */
                ptr->crit_marks = gen_critical_marks();
                ptr->crit_sp = gen_critical_mark_at(ptr->crit_marks);
                debug(DBG_GOTO, "Starting chase %s\n", sname);
                ChaseGoto(ptr);
                ptr->type = KIND_PTR;
            } else {
                ptr = addgotosym(sname);
                ptr->type = KIND_PTR;
                ptr->crit_marks = gen_critical_marks();
                ptr->crit_sp = gen_critical_mark_at(ptr->crit_marks);
            }
            debug(DBG_GOTO, "Adding label not called %s\n", sname);
            ptr->offset.i = Zsp; /* Save stack for label */
            postlabel(ptr->size = getlabel());
            return (1);
        }
    }
    lptr = savelptr;
    return (0);
}

/* A save CPU shares a label when the innermost marks are equal.
   A CPU that pushes no word always shares. */
static int crit_mark_matches(int depth, int here, int there)
{
    if (!CPU_KEEPS_INT_STATE() || depth <= 0)
        return 1;
    return here == there;
}

/*
 * dogoto, parse goto, this is where things can go completely wrong!
 */

void dogoto(void)
{
    SYMBOL* ptr;
    char sname[NAMESIZE];
    int stkmod = 0;
    int label;
    /*
 *      Should find symbol, and if a goto expr obtain the level from
 *      ptr->size, and modify the stack accordingly..
 */
    if (symname(sname) == 0)
        illname(sname);
    debug(DBG_GOTO, "goto is -->%s<--\n", sname);
    if ((ptr = findgoto(sname)) && ptr->ident == ID_GOTOLABEL) {
        /* Label found, but is it actually defined? */
        if (ptr->type == KIND_PTR) {
            int depth = gen_critical_marks();

            label = ptr->size;
            if (ptr->crit_marks > depth) {
                errorfmt("goto into __critical", 0);
                stkmod = ptr->offset.i;
            } else if (ptr->crit_marks < depth ||
                       !crit_mark_matches(ptr->crit_marks, ptr->crit_sp,
                                          gen_critical_mark_at(ptr->crit_marks))) {
                /* Same depth with a different mark still has to move
                   the saved word onto the label's mark. */
                gen_critical_jump(ptr->crit_marks, ptr->offset.i, ptr->crit_sp);
            } else {
                stkmod = ptr->offset.i;
            }
        } else {
            debug(DBG_GOTO, "Sym found but still on goto\n");
            /* Not defined, add into the goto queue */
            label = AddGoto(ptr);
        }
    } else {
        ptr = addgotosym(sname);
        debug(DBG_GOTO, "Adding symbol to table\n");
        ptr->offset.i = 0;
        ptr->crit_marks = 0;
        ptr->crit_sp = 0;
        label = AddGoto(ptr);
    }
    if (stkmod)
        modstk(stkmod, KIND_NONE, NO, YES);
    gen_jp_label(label,1);
}

SYMBOL* addgotosym(char* sname)
{
    char sname2[NAMESIZE * 3];
    snprintf(sname2,sizeof(sname2),"00goto_%s_%s",currfn->name,sname);
    return (addglb(sname2, type_void, ID_GOTOLABEL, 0, 0, 0));
}

SYMBOL* findgoto(char* sname)
{
    char sname2[NAMESIZE * 3];
    snprintf(sname2,sizeof(sname2),"00goto_%s_%s",currfn->name,sname);
    return (findglb(sname2));
}

/*
 *      Add an entry into the goto chain
 */

int AddGoto(SYMBOL* ptr)
{
    GOTO_TAB* gptr;
    int gqptr = 0; /* Pointer int goto queue */

    debug(DBG_GOTO, "Adding goto label: %s\n", ptr->name);
    if (ptr->more)
        gqptr = ptr->more;
    if ((gptr = SearchGoto(ptr)))
        return (gptr->label);
    if (++gotocnt > NUMGOTO)
        errorfmt("Maximum number of gotos reached (%d)", 1, NUMGOTO);
    gptr = gotoq + gotocnt; /* Ref for our label */
    gptr->next = gqptr; /* store next in chain */
    ptr->more = gotocnt; /* Make us first */
    gptr->sp = Zsp; /* Store current stack */
    gen_critical_state(&gptr->crit, gptr->mark);
    gptr->sym = ptr; /* What label do we reference */
    gptr->lineno = lineno;
    gptr->label = getlabel();
    return (gptr->label);
}

/*
 *      Chase up the gotoqueue looking for previous gotos that
 *      match our symbol, check to stack to see if same, and if
 *      so dump a label here - saves a jp followed by a jump
 */

void ChaseGoto(SYMBOL* ptr)
{
    GOTO_TAB* gptr;
    int i;

    if (gotocnt == 0)
        return; /* No gotos */

    gptr = gotoq + 1;
    for (i = 0; i < gotocnt; i++) {
        debug(DBG_GOTO, "Chasing %s # %d\n", ptr->name, i);
        if (gptr->sym == ptr && ptr->crit_marks > gptr->crit) {
            int line = lineno;

            lineno = gptr->lineno;
            errorfmt("goto into __critical", 0);
            lineno = line;
        } else if (gptr->sym == ptr && gptr->sp == Zsp && gptr->crit == ptr->crit_marks &&
                   crit_mark_matches(gptr->crit,
                                     gptr->crit > 0 ? gptr->mark[gptr->crit - 1] : 0,
                                     ptr->crit_sp)) {
            debug(DBG_GOTO, "Matched #%d \n", i);
            postlabel(gptr->label);
            gptr->sym = NULL;
        }
        gptr++;
    }
}

/*
 *      Clean up the goto tree, called at the end of a function
 *      Should remedy all stack problems etc(!)
 */

void goto_cleanup(void)
{
    int i;
    GOTO_TAB* gptr;

    if (gotocnt == 0)
        return;

    gptr = gotoq + 1;
    for (i = 0; i < gotocnt; i++) {
        if (gptr->sym) {
            debug(DBG_GOTO, "Cleaning %s #%d jp to i_%d\n", gptr->sym->name, i, gptr->sym->size);
            if (gptr->sym->size == 0 ) {
                errorfmt("Unknown label: %s", 1, gptr->sym->name);
            }
            postlabel(gptr->label);
            if (gptr->sym->crit_marks <= gptr->crit) {
                /* Adjust from the goto's own depth. The compiler SP
                   here is the epilogue, not the goto. */
                gen_critical_jump_from(gptr->crit, gptr->sp, gptr->mark,
                                       gptr->sym->crit_marks, gptr->sym->offset.i,
                                       gptr->sym->crit_sp);
            } else {
                modstk((gptr->sym->offset.i) - (gptr->sp), KIND_NONE, NO, YES);
            }
            gen_jp_label(gptr->sym->size,1); /* label label(!) */
        }
        gptr++;
    }
    /* Wipe out reference to our goto labels in symbol table */
    gotocnt = 0;
}

/*
 *      Search Through Goto table, matching entries which look like
 *      ours, if one does, then return a ptr to the entry - saves 
 *      having duplicate identical jumps to a label
 */

GOTO_TAB* SearchGoto(SYMBOL* ptr)
{
    int i;
    GOTO_TAB* gptr;

    if (gotocnt == 0)
        return (0);

    gptr = gotoq + 1;
    for (i = 0; i <  gotocnt; i++) {
        if (gptr->sym == ptr && gptr->sp == Zsp && gptr->crit == gen_critical_marks() &&
            crit_mark_matches(gptr->crit,
                              gptr->crit > 0 ? gptr->mark[gptr->crit - 1] : 0,
                              gen_critical_mark_at(gptr->crit)))
            return (gptr);
        gptr++;
    }
    return (0);
}
