/*
 *      The Goto File
 *
 *      Yes, they are truly hideous things, and no, you shouldn't
 *      have to use them if you write your own code, but those
 *      pesky kids who write grown up C love em..so here I will
 *      (finally!) give them to you!
 *
 *      Started djm 22/4/99
 *
 *      $Id: goto.c,v 1.3 2016-03-29 13:39:44 dom Exp $
 *
 *      The scheme is:
 *
 *      1. If label defined and we hit goto, adjust stack and jump
 *         directly to label
 *      2. If label not defined keep in goto queue
 *      3. If we hit a label and it has been previously goto'd to, we
 *         will scan through the goto table looking for ptrs to our
 *         label, if we find any which have the same sp as us, then dump
 *         that label and invalidate entry (ptr=0)
 *      4. If the stack is uneven, keep in queue and deal with at function
 *         end
 *      5. Literal labels are used for goto labels i.e. getlabel()
 *      6. All gotos are kept in global variable space
 *      7. We endeavour to wipe all trace of goto labels from
 *         global symbol table on exit
 *
 *      All relevent structures and #define are in define.h
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

int dolabel()
{
    int savelptr;
    char sname[NAMESIZE];
    SYMBOL* ptr;
    blanks();
    savelptr = lptr;
    if (symname(sname)) {
        if (gch() == ':') {
            if ((ptr = findgoto(sname)) && ptr->ident == GOTOLABEL) {
                /* Label already goto'd, find some others with
                                 * same stack
                                 */
                ptr->type = GOTOLABEL;
                debug(DBG_GOTO, "Starting chase %s\n", sname);
                ChaseGoto(ptr);
            } else {
                ptr = addgotosym(sname);
                ptr->type = GOTOLABEL;
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

/*
 * dogoto, parse goto, this is where things can go completely wrong!
 */

void dogoto()
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
    if ((ptr = findgoto(sname)) && ptr->ident == GOTOLABEL) {
        /* Label found, but is it actually defined? */
        if (ptr->type == GOTOLABEL) {
            label = ptr->size;
            stkmod = ptr->offset.i;
        } else {
            debug(DBG_GOTO, "Sym found but still on goto\n");
            /* Not defined, add into the goto queue */
            label = AddGoto(ptr);
        }
    } else {
        ptr = addgotosym(sname);
        debug(DBG_GOTO, "Adding symbol to table\n");
        ptr->offset.i = 0;
        label = AddGoto(ptr);
    }
    if (stkmod)
        modstk(stkmod, NO, NO);
    jump(label);
}

SYMBOL* addgotosym(char* sname)
{
    char sname2[NAMESIZE * 3];
    strcpy(sname2, "goto_");
    strcat(sname2, currfn->name);
    strcat(sname2, "_");
    strcat(sname2, sname);
    return (addglb(sname2, GOTOLABEL, 0, 0, 0, 0, 0));
}

SYMBOL* findgoto(char* sname)
{
    char sname2[NAMESIZE * 3];
    strcpy(sname2, "goto_");
    strcat(sname2, currfn->name);
    strcat(sname2, "_");
    strcat(sname2, sname);
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
        error(E_MAXGOTO, NUMGOTO);
    gptr = gotoq + gotocnt; /* Ref for our label */
    gptr->next = gqptr; /* store next in chain */
    ptr->more = gotocnt; /* Make us first */
    gptr->sp = Zsp; /* Store current stack */
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

    gptr = gotoq;
    for (i = 0; i <= gotocnt; i++) {
        debug(DBG_GOTO, "Chasing %s # %d\n", ptr->name, i);
        if (gptr->sym == ptr && gptr->sp == Zsp) {
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

    gptr = gotoq;
    for (i = 0; i <= gotocnt; i++) {
        if (gptr->sym) {
            debug(DBG_GOTO, "Cleaning %s #%d\n", gptr->sym->name, i);
            postlabel(gptr->label);
            if (gptr->sym->type == GOTOLABEL) {
                modstk((gptr->sym->offset.i) - (gptr->sp), NO, NO);
                jump(gptr->sym->size); /* label label(!) */
            } else
                error(E_UNGOTO, gptr->sym->name, gptr->lineno);
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

    gptr = gotoq;
    for (i = 0; i <= gotocnt; i++) {
        if (gptr->sym == ptr && gptr->sp == Zsp)
            return (gptr);
        gptr++;
    }
    return (0);
}
