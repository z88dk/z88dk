/*********************************************************************
 *
 *      Some routines just dumped here by djm..can't be bothered to
 *      find proper place for them!
 *
 *********************************************************************
 */

#include "ccdefs.h"

/* Copy src into dst. Always terminates. 0 when src does not fit. */
int copy_fit(char *dst, size_t cap, const char *src)
{
    size_t i;

    if (cap == 0)
        return 0;
    if (src == NULL)
        src = "";
    for (i = 0; src[i] != '\0'; i++) {
        if (i + 1 >= cap) {
            dst[cap - 1] = '\0';
            return 0;
        }
        dst[i] = src[i];
    }
    dst[i] = '\0';
    return 1;
}

/* Generic change suffix routine. cap is the size of name. */

void changesuffix(char *name, size_t cap, const char *suffix)
{
    size_t len;
    size_t j;

    len = strlen(name);
    if (len >= cap) {
        fprintf(stderr, "File name is too long\n");
        exit(1);
    }
    j = len;
    while (j && name[j - 1] != '.')
        j--;

    if (j) {
        name[j - 1] = '\0';
        len = j - 1;
    }
    if (suffix == NULL)
        suffix = "";
    if (len + strlen(suffix) >= cap) {
        fprintf(stderr, "File name is too long\n");
        exit(1);
    }
    memcpy(name + len, suffix, strlen(suffix) + 1);
}

/* errorfmt is dropped while an argument is being copied, so these
   paths exit themselves. */
static void nest_limit(int *depth, int limit, const char *message)
{
    if (++(*depth) > limit) {
        fprintf(stderr, "%s\n", message);
        ccabort();
    }
}

void enter_paren_nest(void)
{
    nest_limit(&paren_nest, MAX_PAREN_LEVELS, "Expression is too deeply nested");
}

void leave_paren_nest(void)
{
    if (paren_nest > 0)
        --paren_nest;
}

void enter_call_nest(void)
{
    nest_limit(&call_nest, MAX_CALL_LEVELS, "Calls are nested too deeply");
}

void leave_call_nest(void)
{
    if (call_nest > 0)
        --call_nest;
}

/* These two used to keep track of what goes on stack, and what comes
 * off of stack, guess 100 is enough to be going on with?
 */

Type *stkptr[100], *laststk;
int stkcount;
char flgstk[100];

/* Set up the stack references... */

void initstack(void)
{
    stkcount = 0;
    laststk = 0;
}

/* Retrieve last item on the stack */

Type* retrstk(char* flags)
{
    Type* ptr;
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
    stkptr[stkcount] = lval->ltype;
    flgstk[stkcount] = lval->flags;
    return (stkcount++);
}

const char *get_section_name(const char *namespace, const char *section)
{
    static char   buf[LINEMAX+1];

    if ( namespace == NULL ) 
        return section;

    snprintf(buf,sizeof(buf),"%s_%s",namespace, section);

    return buf;
}
