/*
 *      Small C+ Compiler
 *
 *      Routines for symbol hashing etc
 *
 *      $Id: sym.c,v 1.3 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"

static void initialise_sym(SYMBOL *ptr, char *sname, enum ident_type id, Kind kind, enum storage_type storage);



/* Block-scoped local statics.
 *
 * The STORAGE of a `static` local is a global (LSTATIC, named
 * st_<fn>_<name>), but C scopes its NAME to the block it is declared in — so
 * one function may legally declare several with the same name in sibling or
 * nested blocks, and an inner one shadows an outer one. Deriving the global
 * name from (function, source name) alone cannot express that: the second
 * declaration collided and the compiler rejected valid code with
 * "Symbol st_main_v is already defined".
 *
 * So the mangled name is made unique per DECLARATION (declare_local appends a
 * counter on collision) and the source name is resolved through this alias
 * stack instead. It mirrors the automatic-local stack exactly: entries are
 * pushed in declaration order and searched backwards, so the innermost
 * declaration wins, and each records the COMPOUND LEVEL (`ncmp`) it was declared
 * at so sym_leave_scope can retire it with its block — which is why the two
 * existing scope-exit call sites need no change.
 *
 * The level, not `locptr`, is the scope key: a block that declares no
 * automatics does not advance locptr, so three nested blocks would share one
 * marker and leaving the innermost would retire all three. Both scope-exit
 * sites decrement ncmp BEFORE calling sym_leave_scope, so on entry here ncmp is
 * the ENCLOSING level and anything deeper than it is going out of scope.
 */
typedef struct {
    char    name[NAMESIZE];  /* the name as written in the source */
    SYMBOL *sym;             /* the global (LSTATIC) that holds it */
    int     level;           /* ncmp when declared — the scope key */
    char    out_of_scope;
} StcAlias;

#define MAX_STC_ALIAS 256
static StcAlias stc_alias[MAX_STC_ALIAS];
static int      n_stc_alias;

/* Called when a new function body starts, alongside `locptr = STARTLOC`. */
void stc_reset(void)
{
    n_stc_alias = 0;
}

/* Record that `sname` in the current block refers to the global `sym`. */
void stc_declare(const char *sname, SYMBOL *sym)
{
    if (n_stc_alias >= MAX_STC_ALIAS) return;   /* fall back to the legacy name */
    StcAlias *a = &stc_alias[n_stc_alias++];
    snprintf(a->name, sizeof(a->name), "%s", sname);
    a->sym = sym;
    a->level = ncmp;
    a->out_of_scope = 0;
}

/* Retire every alias declared DEEPER than the level we are returning to.
   Called from sym_leave_scope, by which point ncmp is the enclosing level. */
static void stc_leave_scope(void)
{
    for (int i = 0; i < n_stc_alias; i++)
        if (stc_alias[i].level > ncmp)
            stc_alias[i].out_of_scope = 1;
}

/* Is there an in-scope local static called `sname` declared DEEPER than
   `level`? primary.c asks before accepting an automatic: it tries findloc
   first, which made an automatic in an OUTER block win over a static in an
   inner one — `int v; { static int v; use(v); }` read the automatic. C says
   the innermost declaration wins whatever its storage. */
int stc_shadows(const char *sname, int level)
{
    for (int i = n_stc_alias - 1; i >= 0; i--)
        if (!stc_alias[i].out_of_scope && strcmp(stc_alias[i].name, sname) == 0)
            return stc_alias[i].level > level;
    return 0;
}

SYMBOL *findstc(char* sname)
{
    char sname2[3 * NAMESIZE]; /* Should be enuff! */

    /* Innermost in-scope declaration wins. */
    for (int i = n_stc_alias - 1; i >= 0; i--)
        if (!stc_alias[i].out_of_scope && strcmp(stc_alias[i].name, sname) == 0)
            return stc_alias[i].sym;

    /* Legacy path: anything that reaches a local static without having gone
       through declare_local still resolves by the derived name. */
    snprintf(sname2,sizeof(sname2),"st_%s_%s",currfn ? currfn->name : "", sname);
    return (findglb(sname2));
}


SYMBOL* findglb(const char* sname)
{
    SYMBOL *ptr;

    HASH_FIND_STR(symtab, sname, ptr);

    return ptr;
}

SYMBOL* findloc(char* sname)
{
    SYMBOL* ptr;

    ptr = locptr - 1;
    while (ptr >= STARTLOC) {
        if (!ptr->out_of_scope && strcmp(sname, ptr->name) == 0)
            return ptr;
        --ptr;
    }
    return 0;
}

/* Leave a block scope: mark every local declared since `from` out of scope so
   findloc no longer resolves it, but DON'T rewind locptr. The AST built for the
   block holds SYMBOL* into this storage and is lowered only after the whole
   function is parsed, so reusing the slots for a later sibling/nested block
   would alias two distinct locals onto one SYMBOL (the later decl's type would
   retroactively rewrite the earlier one). Keeping the storage live is correct;
   the IR's own liveness-based slot allocator still packs non-overlapping
   locals into shared frame slots, so this costs no frame space. */
void sym_leave_scope(SYMBOL *from)
{
    for (SYMBOL *p = from; p < locptr; p++)
        p->out_of_scope = 1;
    stc_leave_scope();       /* local statics scope with the block too */
}

// Probably not needed since we should clear up at the end of a compound
// statement...
void sym_undecl_frame(array *arr, SYMBOL *target, int need_undecl)
{
    return; // TODO: Something is broken/called at the wrong point in time
    SYMBOL *current = locptr;

    while (current != target) {
        SYMBOL *ptr = current - 1;

        if (need_undecl && ptr->name[0]) {
            array_add(arr, ast_undecl(ptr));
        }
        ptr->name[0] = 0;
        --current;
    }
}


SYMBOL* addglb(
    char* sname, Type *type, enum ident_type id, Kind kind,
    int value, enum storage_type storage)
{
    SYMBOL* ptr;
    if ((ptr = findglb(sname))) {
        /*
         * djm, this is not to be abused!!!!
         *
         * This bit of code allows us to overturn extern declaration of stuff,
         * Useful for those programs which extern everything in header files
         * 
         */
        if ((ptr->storage == EXTERNAL && storage != EXTERNAL) ) {
            ptr->storage = storage;
            ptr->ctype = type;
            return (ptr);
        }
        if ((ptr->storage == EXTERNAL && storage == EXTERNAL) ) {
            ptr->ctype = type;            
            return (ptr);
        }

        if ( type_matches(type, ptr->ctype) ) {
            return ptr;
        }

        multidef(sname);
        return (ptr);
    }
    ptr = CALLOC(1, sizeof(*ptr));
    initialise_sym(ptr, sname, id, kind, storage);
    ptr->offset.i = value;
    ptr->ctype = type;
    ptr->level = ncmp;
    ptr->scope_block = scope_block;
    HASH_ADD_STR(symtab, name, ptr);  
    if ( id == ID_VARIABLE)
        debug_write_symbol(ptr); 
    ++glbcnt;
    return (ptr);
}

SYMBOL* addloc(
    char *sname,
    Type *type,
    enum ident_type id,
    Kind kind,
    int  offset)
{
    SYMBOL* cptr;

    if ((cptr = findloc(sname)) && cptr->level == ncmp ) {
        multidef(sname);
        return cptr;
    }
    if (locptr >= ENDLOC) {
        errorfmt("Local symbol table overflow", 1);
        return 0;
    }
    cptr = locptr++;
	memset(cptr, 0, sizeof(*cptr));
    initialise_sym(cptr, sname, id, kind, STKLOC);
    cptr->ctype = type;
    cptr->level = ncmp;
    cptr->scope_block = scope_block;
    cptr->offset.i = offset;
    debug_write_symbol(cptr);
    return cptr;
}



/*
 * insert values into symbol table
 */

static void initialise_sym(
    SYMBOL* ptr,
    char* sname,
    enum ident_type id,
    Kind kind,
    enum storage_type storage)
{
    strcpy(ptr->name, sname);
    ptr->ident = id;
    ptr->type = kind;
    ptr->storage = storage;
    ptr->flags = FLAGS_NONE;
    snprintf(ptr->declared_location, sizeof(ptr->declared_location),"%s:%d", Filename, lineno);
}
