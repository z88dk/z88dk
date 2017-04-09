/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part contains various routines to deal with constants
 *      and also finds variable names in the hash tables
 *
 *      $Id: primary.c,v 1.27 2016-11-25 19:46:20 dom Exp $
 */

#include "ccdefs.h"

int primary(LVALUE* lval)
{
    char sname[NAMESIZE];
    SYMBOL* ptr;
    int k, level;
    char cid, vtype, cflags, clevel;
    TAG_SYMBOL* cotag;

    if (cmatch('(')) {
        lval->level++;
        do
            k = heir1(lval);
        while (cmatch(','));
        needchar(')');
        /* Not sure about doing this here..but here goes nowt!*/
        if (lval->c_vtype) {
            docast(lval, YES);
        }
        lval->level--;
        if (lval->c_vtype) {
            docast(lval, YES);
        }
        return k;
    }
    /* clear lval array - djm second arg was lval.. now cast, clears lval */
    cid = lval->c_id;
    vtype = lval->c_vtype;
    cflags = lval->c_flags;
    cotag = lval->c_tag;
    level = lval->level;
    clevel = lval->castlevel;
    memset(lval, 0, sizeof(LVALUE));
    lval->c_id = cid;
    lval->c_vtype = vtype;
    lval->c_flags = cflags;
    lval->c_tag = cotag;
    lval->level = level;
    lval->castlevel = clevel;

    if (symname(sname)) {
        if (strcmp(sname, "sizeof") == 0) {
            size_of(lval);
            return (0);
        } else if ((ptr = findloc(sname)) && ptr->ident != GOTOLABEL) {
            lval->offset = getloc(ptr, 0);
            lval->symbol = ptr;
            lval->val_type = lval->indirect = ptr->type;
            lval->flags = ptr->flags;
            lval->ident = ptr->ident;
            lval->storage = ptr->storage;
            lval->ptr_type = 0;
            ltype = ptr->type;
            if (ptr->type == STRUCT)
                lval->tagsym = tagtab + ptr->tag_idx;
            if (ptr->ident == POINTER) {
                lval->ptr_type = ptr->type;
                /* djm long pointers */
                lval->indirect = lval->val_type = (ptr->flags & FARPTR ? CPTR : CINT);
                ltype = lval->indirect;
            }
            if (ptr->ident == ARRAY || (ptr->ident == VARIABLE && ptr->type == STRUCT)) {
                /* djm pointer? */
                lval->ptr_type = ptr->type;
                lval->val_type = (ptr->flags & FARPTR ? CPTR : CINT);
                return (0);
            } else
                return (1);
        }
        /* djm search for local statics */
        ptr = findstc(sname);
        if (!ptr)
            ptr = findglb(sname);
        if (ptr) {
            if (ptr->ident != FUNCTION && ptr->ident != FUNCTIONP) {
                if (ptr->ident == ENUM)
                    error(E_UNSYMB, sname);
                if (ptr->type == ENUM) {
                    lval->symbol = NULL;
                    lval->indirect = 0;
                    lval->is_const = 1;
                    lval->const_val = ptr->size;
                    lval->flags = FLAGS_NONE;
                    lval->ident = VARIABLE;
                    return (0);
                }
                lval->symbol = ptr;
                lval->indirect = 0;
                lval->val_type = ptr->type;
                lval->flags = ptr->flags;
                lval->ident = ptr->ident;
                lval->ptr_type = 0;
                lval->storage = ptr->storage;
                ltype = ptr->type;
                if (ptr->type == STRUCT)
                    lval->tagsym = tagtab + ptr->tag_idx;
                if (ptr->ident != ARRAY && (ptr->ident != VARIABLE || ptr->type != STRUCT)) {
                    if (ptr->ident == POINTER) {
                        lval->ptr_type = ptr->type;
                        lval->val_type = (ptr->flags & FARPTR ? CPTR : CINT);
                        ltype = lval->val_type;
                    }
                    return (1);
                }
                /* Handle arrays... */
                address(ptr);
                /* djm sommat here about pointer types? */
                lval->indirect = lval->ptr_type = ptr->type;
                lval->val_type = (ptr->flags & FARPTR ? CPTR : CINT);
                return (0);
            } else {
                lval->ident = FUNCTION;
            }
        } else {
            /* Check to see if we have a right bracket, if we don't assume
             * it's a function then we can break an awful lot of code, do it
             * this way and it's safer... we're not GNU after all!
             */
            if (rcmatch('('))
                warning(W_FUNC_NO_PROTO);
            else {
                error(E_UNSYMB, sname);
            }
            /* assume it's a function we haven't seen yet */
            /* NB value set to 0 */
            ptr = addglb(sname, FUNCTION, CINT, 0, STATIK, 0, 0);
            ptr->size = 0;
            ptr->prototyped = 0; /* No parameters known */
            ptr->args[0] = CalcArgValue(CINT, FUNCTION, 0);
            ptr->flags |= c_use_r2l_calling_convention == YES ? 0 : SMALLC;
        }
        lval->symbol = ptr;
        lval->indirect = 0;
        lval->val_type = ptr->type ; /* Null function, always int */
        lval->flags = ptr->flags;
        lval->ident = FUNCTION;
        return (0);
    }
    if (constant(lval)) {
        lval->symbol = NULL;
        lval->indirect = 0;
        lval->ident = VARIABLE;
        return (0);
    } else {
        error(E_EXPRESSION);
        vconst(0);
        junk();
        return (0);
    }
}


/*
 * calculate constant expression (signed values)
 */
int calc(
    int left,
    void (*oper)(LVALUE *),
    int right)
{
    if (oper == zdiv)
        return (left / right);
    else if (oper == zmod)
        return (left % right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr)
        return (left >> right);
    else
        return (CalcStand(left, oper, right));
}

int calcun(
    unsigned int left,
    void (*oper)(LVALUE *),
    unsigned int right)
{
    if (oper == zdiv)
        return (left / right);
    else if (oper == zmod)
        return (left % right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr)
        return (left >> right);
    else
        return (CalcStand(left, oper, right));
}

/*
 * Calculations..standard ones - same for U & S 
 */

int CalcStand(
    int left,
    void (*oper)(LVALUE *),
    int right)
{
    if (oper == zor)
        return (left | right);
    else if (oper == zxor)
        return (left ^ right);
    else if (oper == zand)
        return (left & right);
    else if (oper == mult)
        return (left * right);
    else if (oper == asl)
        return (left << right);
    else if (oper == zeq)
        return (left == right);
    else if (oper == zne)
        return (left != right);
    else
        return (0);
}

/* Complains if an operand isn't int */
int intcheck(LVALUE* lval, LVALUE* lval2)
{
    if (lval->val_type == DOUBLE || lval2->val_type == DOUBLE) {
        error(E_INTOPER);
        return -1;
    }
    return 0;
}

/* Forces result, having type t2, to have type t1 */
/* Must take account of sign in here somewhere, also there is a problem    possibly with longs.. */
void force(int t1, int t2, char sign1, char sign2, int lconst)
{
    if (t2 == CARRY) {
        zcarryconv();
    }

    if (t1 == DOUBLE) {
        if (t2 != DOUBLE) {
            convert_int_to_double(t2, sign2);
        }
    } else {
        if (t2 == DOUBLE) {
            convdoub2int();
            return;
        }
    }
    /* t2 =source, t1=dest */
    /* int to long, if signed, do sign, if not ld de,0 */
    /* Check to see if constant or not... */
    if (t1 == LONG) {
        if (t2 != LONG && (!lconst)) {
            if (sign2 == NO && sign1 == NO && t2 != CARRY)
                convSint2long();
            else
                convUint2long();
        }
        return;
    }

    /* Converting between pointer types..far and near */
    if (t1 == CPTR && t2 == CINT)
        convUint2long();
    else if (t2 == CPTR && t1 == CINT)
        warning(W_FARNR);

    /* Char conversion */
    if (t1 == CCHAR && sign2 == NO && !lconst) {
        if (sign1 == NO)
            convSint2char();
        else
            convUint2char();
    } else if (t1 == CCHAR && sign2 == YES && !lconst) {
        if (sign1 == NO)
            convSint2char();
        else
            convUint2char();
    }
}

/*
 * If only one operand is DOUBLE, converts the other one to
 * DOUBLE.  Returns 1 if result will be DOUBLE
 *
 * Maybe should an operand in here for LONG?
 */
int widen(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == DOUBLE) {
        if (lval->val_type != DOUBLE) {
            dpush_under(lval->val_type); /* push 2nd operand UNDER 1st */
            mainpop();
            if (lval->val_type == LONG)
                zpop();
            convert_int_to_double(lval->val_type, lval->flags & UNSIGNED);
            DoubSwap();
            lval->val_type = DOUBLE; /* type of result */
        }
        return (1);
    } else {
        if (lval->val_type == DOUBLE) {
            convert_int_to_double(lval2->val_type, lval2->flags & UNSIGNED);
            lval2->val_type = DOUBLE;
            return (1);
        } else
            return (0);
    }
}

void widenlong(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == CARRY) {
        zcarryconv();
        lval2->val_type = CINT;
    }

    if (lval2->val_type == LONG) {
        /* Second operator is long */
        if (lval->val_type != LONG) {
            doexx(); /* Preserve other operator */
            mainpop();
            force(LONG, lval->val_type, lval->flags & UNSIGNED, lval->flags & UNSIGNED, 0);
            lpush(); /* Put the new expansion on stk*/
            doexx(); /* Get it back again */
            lval->val_type = LONG;
        }
        return;
    }

    if (lval->val_type == LONG) {
        if (lval2->val_type != LONG && lval2->val_type != CPTR) {
           /*
            * FIXED!! 23/4/99 djm, if any of them is unsigned then we extend out
            * to an unsigned long.
            *
            * This is sort of in accordance with A6.5 except for the fact that
            * we don't convert the signed integer to postive if it negative
            *
            * If neither are unsigned, then we extend the sign, let me know if this
            * causes lots of problems!
            */
            if ((lval->flags & UNSIGNED) || (lval2->flags & UNSIGNED))
                convUint2long();
            else
                convSint2long();
            lval->val_type = LONG;
        }
    }
}

/*
 * true if val1 -> int pointer or int array and
 * val2 not ptr or array
 */
int dbltest(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type) {
        if (lval->ptr_type == CCHAR)
            return (0);
        if (lval2->ptr_type)
            return (0);
        return (1);
    } else
        return (0);
}

/*
 * determine type of binary operation
 */
void result(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type && lval2->ptr_type) {
        lval->ptr_type = 0; /* ptr-ptr => int */
        if (lval->val_type == CPTR)
            lval->val_type = LONG;
        else
            lval->val_type = CINT;
        lval->indirect = 0;
        lval->ident = VARIABLE;
    } else if (lval2->ptr_type) { /* ptr +- int => ptr */
        lval->symbol = lval2->symbol;
        lval->indirect = lval2->indirect;
        lval->ptr_type = lval2->ptr_type;
    }
}

/*
 * prestep - preincrement or predecrement lvalue
 */

void prestep(
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval))
{
    if (heira(lval) == 0) {
        needlval();
    } else {
        if (lval->indirect) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        //intcheck(lval, lval);
        switch (lval->ptr_type) {
        case DOUBLE:
            addconst(n * 6, 1, lval->symbol->flags & FARPTR);
            break;
        case STRUCT:
            addconst(n * lval->tagsym->size, 1, lval->symbol->flags & FARPTR);
            break;
        case LONG:
            (*step)(lval);
        case CPTR:
            (*step)(lval);
        case CINT:
            (*step)(lval);
        default:
            (*step)(lval);
            break;
        }
        store(lval);
    }
}

/*
 * poststep - postincrement or postdecrement lvalue
 */
void poststep(
    int k,
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval),
    void (*unstep)(LVALUE *lval))
{
    if (k == 0) {
        needlval();
    } else {
        if (lval->indirect) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        switch (lval->ptr_type) {
        case DOUBLE:
            nstep(lval, n * 6, unstep);
            break;
        case STRUCT:
            nstep(lval, n * lval->tagsym->size, unstep);
            break;
        case LONG:
            nstep(lval, n * 4, unstep);
            break;
        case CPTR:
            nstep(lval, n * 3, unstep);
            break;
        case CINT:
            (*step)(lval);
        default:
            (*step)(lval);
            store(lval);
            if (unstep)
                (*unstep)(lval);
            if (lval->ptr_type == CINT)
                if (unstep)
                    (*unstep)(lval);
            break;
        }
    }
}

/*
 * generate code to postincrement by n
 * no need to change for long pointers since we're going to have
 * memory pools..
 */
void nstep(
    LVALUE* lval,
    int n,
    void (*unstep)(LVALUE *lval))
{
    addconst(n, 1, lval->symbol->flags & FARPTR);
    store(lval);
    if (unstep)
        addconst(-n, 1, lval->symbol->flags & FARPTR);
}

void store(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isconst ) {
        if ( lval->symbol->isassigned ) 
            error(E_CHANGING_CONST, lval->symbol);
    }
    if ( lval->symbol ) 
        lval->symbol->isassigned = YES;
    if (lval->symbol && (lval->symbol->type == PORT8 || lval->symbol->type == PORT16) ) {
        intrinsic_out(lval->symbol);
    } else if (lval->indirect == 0)
        putmem(lval->symbol);
    else
        putstk(lval->indirect);
}

/*
 * push address only if it's not that of a two byte quantity at TOS
 * or second TOS.  In either of those cases, forget address calculation
 * This should be followed by a smartstore()
 */
void smartpush(LVALUE* lval, char* before)
{
    if (lval->indirect != CINT || lval->symbol == 0 || lval->symbol->storage != STKLOC) {
        addstk(lval);
        if ((lval->flags & FARACC) || (lval->symbol && lval->symbol->storage == FAR)) {
            lpush();
        } else {
            zpush();
        }
    } else {
        switch (lval->symbol->offset.i - Zsp) {
        case 0:
        case 2:
            if (before)
                clearstage(before, 0);
            break;
        default:
            addstk(lval);
            if (lval->symbol && lval->symbol->storage == FAR) {
                lpush();
            } else {
                zpush();
            }
        }
    }
}

/*
 * store thing in primary register at address taking account
 * of previous preparation to store at TOS or second TOS
 */
void smartstore(LVALUE* lval)
{
    if (lval->indirect != CINT || lval->symbol == NULL || lval->symbol->storage != STKLOC) {
        store(lval);
    } else {
        switch (lval->symbol->offset.i - Zsp) {
        case 0:
            if ( lval->symbol->isconst && lval->symbol->isassigned ) {
                error(E_CHANGING_CONST, lval->symbol);
            } else {
                lval->symbol->isassigned = YES;
            }
            puttos();
            break;
        case 2:
            if ( lval->symbol->isconst && lval->symbol->isassigned ) {
                error(E_CHANGING_CONST, lval->symbol);
            } else {
                lval->symbol->isassigned = YES;
            }
            put2tos();
            break;
        default:
            store(lval);
        }
    }
}

void rvaluest(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isassigned == NO && buffer_fps_num == 0 ) {
        warning(W_UNINITIALISED_VARIABLE, lval->symbol->name);
    }
    if (lval->symbol && strncmp(lval->symbol->name, "0dptr", 5) == 0)
        lval->symbol = lval->symbol->offset.p;

    if (lval->symbol && (lval->symbol->type == PORT8  || lval->symbol->type == PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect == 0) {
       
        getmem(lval->symbol);
    } else {
        indirect(lval);
    }
}

void rvalue(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isassigned == NO && buffer_fps_num == 0 ) {
        warning(W_UNINITIALISED_VARIABLE, lval->symbol->name);
    }
    if (lval->symbol && (lval->symbol->type == PORT8  || lval->symbol->type == PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect == 0) { 
        getmem(lval->symbol);
    } else {
            
        indirect(lval);
    }
    if (lval->c_vtype) {
        docast(lval, YES);
    }
#if DEBUG_SIGN
    if (lval->flags & UNSIGNED)
        ol("; unsigned");
    else
        ol("; signed");
#endif
}

void test(int label, int parens)
{
    char *before, *start;
    LVALUE lval;
    void (*oper)(LVALUE *lva);

    ClearCast(&lval);

    if (parens)
        needchar('(');
    while (1) {
        setstage(&before, &start);
        if (heir1(&lval)) {
            rvalue(&lval);
        }
        if (cmatch(','))
            clearstage(before, start);
        else
            break;
    }
    if (parens)
        needchar(')');
    if (lval.is_const) { /* constant expression */
        clearstage(before, 0);
        if (lval.const_val) {
            /* true constant, perform body */
            return;
        }
        /* false constant, jump round body */
        jump(label);
        return;
    }
    if (lval.stage_add) { /* stage address of "..oper 0" code */
        oper = lval.binop; /* operator function pointer */
        lval.binop = 0; /* Reset binop to 0 so not picked up by comparison ops */
        if (oper == zeq || (oper == zle && utype(&lval)))
            zerojump(eq0, label, &lval);
        else if (oper == zne || (oper == zgt && utype(&lval)))
            zerojump(testjump, label, &lval);
        else if (oper == zge && utype(&lval))
            clearstage(lval.stage_add, 0);
        else if (oper == zlt && utype(&lval)) {
            zerojump(jump0, label, &lval);
            warning(W_UNREACH);
        } else if (oper == zgt)
            zerojump(gt0, label, &lval);
        else if (oper == zge)
            zerojump(ge0, label, &lval);
        else if (oper == zlt)
            zerojump(lt0, label, &lval);
        else if (oper == zle)
            zerojump(le0, label, &lval);
        else
            testjump(&lval, label);
    } else {
        if (lval.binop == dummy || DoTestJump(&lval)) {
            if (lval.binop == dummy)
                lval.val_type = CINT; /* logical always int */
            testjump(&lval, label);
        } else {
            jumpnc(label);
        }
    }
    clearstage(before, start);
}

/*
 * evaluate constant expression
 * return TRUE if it is a constant expression
 */
int constexpr(double *val, int *type, int flag)
{
    char *before, *start;
    double valtemp;
    int con;
    int savesp = Zsp;
    int valtype;
    uint32_t packedType;

    setstage(&before, &start);
    valtype = expression(&con, &valtemp, &packedType);
    *val = valtemp;
    clearstage(before, 0); /* scratch generated code */
    if ( valtype == DOUBLE && con ) {
        decrement_double_ref_direct(valtemp);
    }
    *type = valtype;
    Zsp = savesp;
    if (flag && con == 0)
        error(E_CONSTANT);
    return con;
}

/*
 * scale constant value according to type
 */
void cscale(
    int type,
    TAG_SYMBOL* tag,
    int* val)
{
    switch (type) {
    case CINT:
        *val *= 2;
        break;
    case CPTR:
        *val *= 3;
        break;
    case LONG:
        *val *= 4;
        break;
    case DOUBLE:
        *val *= 6;
        break;
    case STRUCT:
        *val *= tag->size;
        break;
    }
}

/*
 * add constant to primary register
 *
 * changed quite a bit...using bc to get offset to add to, was
 * going to take account of far and then push/pop, but maybe this
 * will work just as well?
 */
void addconst(int val, int opr, char zfar)
{
    LVALUE lval;

    if ((ltype == LONG && (!opr)) || (ltype == CPTR && (!opr))) {
        lval.val_type = LONG;
        lpush();
        vlongconst(val);
        zadd(&lval);
    } else {
        lval.val_type = CINT;
        switch (val) {

        case -3:
            dec(&lval);
        case -2:
            dec(&lval);
        case -1:
            dec(&lval);
        case 0:
            break;
        case 3:
            inc(&lval);
        case 2:
            inc(&lval);
        case 1:
            inc(&lval);
            break;

        default:
            addbchl(val);
        }
    }
}

/*
 *      Routine to do casting
 *      djm 24/3/99
 */

int docast(LVALUE* lval, char df)
{
    SYMBOL* ptr;
    char temp_type;
    int itag;
    char nam[20];

    debug(DBG_CAST1, "Level=%d Castlevel=%d df=%d %p", lval->level, lval->castlevel, df, lval);
    if (lval->level != lval->castlevel)
        return 0;

    if (lval->c_id == VARIABLE) {
        /* Straight forward variable conversion now.. */
        if (df)
            force(lval->c_vtype, lval->val_type, lval->c_flags & UNSIGNED, lval->flags & UNSIGNED, 0);
        lval->val_type = lval->c_vtype;
        lval->ptr_type = 0;
        lval->ident = VARIABLE;
        lval->flags = ((lval->flags & FARACC) | (lval->c_flags & UNSIGNED));
        lval->c_id = 0;
        lval->c_vtype = 0;
        lval->c_flags = 0;
        lval->is_const = 0;
        return (0);
    }

    if (lval->c_id == POINTER || lval->c_id == PTR_TO_FN) {
        switch (lval->c_vtype) {
        case STRUCT:
            /* Casting a structure - has to be a pointer... */
            lval->tagsym = lval->c_tag; /* Copy tag symbol over */
            lval->ptr_type = STRUCT;
            temp_type = ((lval->c_flags & FARPTR) ? CPTR : CINT);
            if (df)
                force(temp_type, lval->val_type, 0, 0, 0);
            lval->val_type = temp_type;
            lval->flags = ((lval->flags & FARACC) | lval->c_flags);
            if (df) {
                lval->c_id = 0;
                lval->c_vtype = 0;
                lval->c_flags = 0;
            }
            return (1);

        /* All other simple pointers.. */
        default:
            debug(DBG_CAST2, "Converting %d to %d", lval->ptr_type, lval->c_vtype);
            lval->ptr_type = lval->c_vtype;
            // make an exception for "*(double *)var" recasting in vfprintf_fp (c_vtype == 1)
            if ((lval->symbol == NULL) || (lval->c_vtype == 1))
                lval->symbol = dummy_sym[(int)lval->c_vtype];
            temp_type = ((lval->c_flags & FARPTR) ? CPTR : CINT);
            if (df)
                force(temp_type, lval->val_type, 0, 0, 0);
            lval->val_type = temp_type;
            lval->flags = ((lval->flags & FARACC) | lval->c_flags);
            lval->ident = POINTER;
            if (df) {
                lval->c_id = 0;
                lval->c_vtype = 0;
                lval->c_flags = 0;
            }
            return (1);
        }
    }
    /* Now we deal with pointers to pointers and pointers to functions 
 * returning pointers - to do this, we will define dummy symbols in
 * the local symbol table so that they do what we want them to do!
 */
    sprintf(nam, "0dptr%p", locptr);
    temp_type = ((lval->c_flags & FARPTR) ? CPTR : CINT);
    itag = 0;
    if (lval->c_tag)
        itag = lval->c_tag - tagtab;
    ptr = lval->symbol;
    lval->symbol = addloc(nam, POINTER, temp_type, dummy_idx(lval->c_vtype, lval->c_tag), itag);
    lval->symbol->offset.p = ptr;
    if (df)
        force(temp_type, lval->val_type, 0, 0, 0);
    lval->val_type = temp_type;
    lval->flags = ((lval->flags & FARACC) | lval->c_flags);
    if (df) {
        lval->c_id = 0;
        lval->c_vtype = 0;
        lval->c_flags = 0;
    }
    return (1);
}

/*
 * Check whether a type is unsigned..
 */

int utype(LVALUE* lval)
{
    if (lval->flags & UNSIGNED || lval->ptr_type)
        return (1);
    return (0);
}

/*
 * Check to see whether an operation should be testjumped or not
 * i.e. can we trust the carry flag to be an accurate indicator
 * of the actual function
 *
 * Returns 1 if we should testjump i.e. ld a,h or l jp z, or 0 for carry conds
 */

int DoTestJump(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle || fn == lneg || fn == dummy)
        return (0);
    return (1);
}

/*
 * Check whether previous operation was comparison (used for testjump!)
 * At the same time set the result to be of type CINT
 */

int WasComp(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle) {
        lval->val_type = CINT;
        return (0);
    }
    return (1);
}

/* Generate Code to Turn integer type of signed to double, Generic now does longs */
void convert_int_to_double(char type, char zunsign)
{
    if (type == CINT || type == CCHAR) {
        if (zunsign)
            convUint2long();
        else
            convSint2long();
    }
    if (zunsign)
        convUlong2doub();
    else
        convSlong2doub();
}
