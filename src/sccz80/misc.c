/*********************************************************************
 *
 *      Some routines just dumped here by djm..can't be bothered to
 *      find proper place for them!
 *
 *********************************************************************
 */

#include "ccdefs.h"

/* Generic change suffix routine */

void changesuffix(char* name, char* suffix)
{
    int j;
    j = strlen(name) - 1;
    while (j && name[j - 1] != '.')
        j--;

    if (j) {
        name[j - 1] = '\0';
    }

    strcat(name, suffix);
}

/* These two used to keep track of what goes on stack, and what comes
 * off of stack, guess 100 is enough to be going on with?
 */

SYMBOL *stkptr[100], *laststk;
int stkcount;
char flgstk[100];

/* Set up the stack references... */

void initstack()
{
    stkcount = 0;
    laststk = 0;
}

/* Retrieve last item on the stack */

SYMBOL* retrstk(char* flags)
{
    SYMBOL* ptr;
    if (!stkcount)
        return (laststk = NULL);
    ptr = laststk = stkptr[--stkcount];
    *flags = flgstk[stkcount];
    return (ptr);
}

/* Insert an item onto the stack */

int addstk(LVALUE* lval)
{
    if ((stkcount + 1) >= 99)
        return (0);

    stkptr[stkcount] = lval->symbol;
    flgstk[stkcount] = lval->flags;
    return (stkcount++);
}

/* Check if last item referenced to is this item, used when loading
 * values - saves a little bit of generated code
 */

int chkstk(SYMBOL* ptr)
{
    if (!stkcount)
        return (0);
    if (laststk == ptr)
        return (1);
    else
        return (0);
}
