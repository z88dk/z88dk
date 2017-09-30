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
    int k;
    
    if (cmatch('(')) {
        do {
            k = heir1(lval);
        } while (cmatch(','));
        needchar(')');
        return k;
    }

    memset(lval, 0, sizeof(LVALUE));

    if (symname(sname)) {
        if (strcmp(sname, "sizeof") == 0) {
            size_of(lval);
            return (0);
        } else if ( strcmp(sname, "__builtin_offsetof") == 0 ) {
            offset_of(lval);
            return(0);
        } else if ((ptr = findloc(sname))) {
            lval->offset = getloc(ptr, 0);
            lval->symbol = ptr;
            lval->ltype = ptr->ctype;
            lval->val_type = lval->indirect_kind = ptr->type;
            lval->flags = ptr->flags;
            lval->ident = ptr->ident;
            lval->ptr_type = 0;
            if (ptr->ident == POINTER) {
                lval->ptr_type = ptr->type;
                /* djm long pointers */
                lval->indirect_kind = lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
            }
            if (ptr->ident == ID_ARRAY || (ptr->ident == ID_VARIABLE && ptr->type == KIND_STRUCT)) {
                /* djm pointer? */
                lval->ptr_type = ptr->type;
                lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
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
                if (ptr->ident == ID_ENUM)
                    error(E_UNSYMB, sname);
                if (ptr->type == KIND_ENUM) {
                    lval->symbol = NULL;
                    lval->indirect_kind = 0;
                    lval->is_const = 1;
                    lval->const_val = ptr->size;
                    lval->flags = FLAGS_NONE;
                    lval->ident = ID_VARIABLE;
                    return (0);
                }
                lval->symbol = ptr;
                lval->ltype = ptr->ctype;
                lval->indirect_kind = 0;
                lval->val_type = ptr->type;
                lval->flags = ptr->flags;
                lval->ident = ptr->ident;
                lval->ptr_type = 0;
                if (ptr->ident != ID_ARRAY && (ptr->ident != ID_VARIABLE || ptr->type != KIND_STRUCT)) {
                    if (ptr->ident == POINTER) {
                        lval->ptr_type = ptr->type;
                        lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
                    }
                    return (1);
                }
                /* Handle arrays... */
                address(ptr);
                /* djm sommat here about pointer types? */
                lval->indirect_kind = lval->ptr_type = ptr->type;
                lval->val_type = (ptr->flags & FARPTR ? KIND_CPTR : KIND_INT);
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
            warning(W_IMPLICIT_DEFINITION, sname);
            ptr = addglb(sname, FUNCTION, KIND_INT, 0, STATIK, 0, 0);
            ptr->size = 0;
            ptr->prototyped = 0; /* No parameters known */
            ptr->args[0] = CalcArgValue(KIND_INT, FUNCTION, 0);
            ptr->flags |= c_use_r2l_calling_convention == YES ? 0 : SMALLC;
        }
        lval->symbol = ptr;
        lval->indirect_kind = 0;
        lval->val_type = ptr->type ; /* Null function, always int */
        lval->flags = ptr->flags;
        lval->ident = FUNCTION;
        return (0);
    }
    if (constant(lval)) {
        lval->symbol = NULL;
        lval->indirect_kind = 0;
        lval->ident = ID_VARIABLE;
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
double calc(
    double left,
    void (*oper)(LVALUE *),
    double right, int is16bit)
{
    if (oper == zdiv && right != 0.0)
        return (left / right);
    else if (oper == zmod)
        return ((int)left % (int)right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr) {
        if ( is16bit ) return ((int16_t)left >> (int16_t)right);
        else return ((int)left >> (int)right);
    } else
        return (CalcStand(left, oper, right));
}

double calcun(
    double left,
    void (*oper)(LVALUE *),
    double right)
{
    if (oper == zdiv)   {
        return (left / right);
    } else if (oper == zmod)
        return ((unsigned int)left % (unsigned int)right);
    else if (oper == zle)
        return (left <= right);
    else if (oper == zge)
        return (left >= right);
    else if (oper == zlt)
        return (left < right);
    else if (oper == zgt)
        return (left > right);
    else if (oper == asr)
        return ((unsigned int)left >> (unsigned int)right);
    else
        return (CalcStand(left, oper, right));
}

/*
 * Calculations..standard ones - same for U & S 
 */

double CalcStand(
    double left,
    void (*oper)(LVALUE *),
    double right)
{
    if (oper == zor)
        return ((unsigned int)left | (unsigned int)right);
    else if (oper == zxor)
        return ((unsigned int)left ^ (unsigned int)right);
    else if (oper == zand)
        return ((unsigned int)left & (unsigned int)right);
    else if (oper == mult)
        return ((unsigned int)left * (unsigned int)right);
    else if (oper == asl)
        return ((unsigned int)left << (unsigned int)right);
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
    if (lval->val_type == KIND_DOUBLE || lval2->val_type == KIND_DOUBLE) {
        error(E_INTOPER);
        return -1;
    }
    return 0;
}

/* Forces result, having type t2, to have type t1 */
/* Must take account of sign in here somewhere, also there is a problem    possibly with longs.. */
void force(int t1, int t2, char sign1, char sign2, int lconst)
{
    if (t2 == KIND_CARRY) {
        zcarryconv();
    }

    if (t1 == KIND_DOUBLE) {
        if (t2 != KIND_DOUBLE) {
            convert_int_to_double(t2, sign2);
        }
    } else {
        if (t2 == KIND_DOUBLE) {
            convdoub2int();
            return;
        }
    }
    /* t2 =source, t1=dest */
    /* int to long, if signed, do sign, if not ld de,0 */
    /* Check to see if constant or not... */
    if (t1 == KIND_LONG) {
        if (t2 != KIND_LONG && (!lconst)) {
            if (sign2 == NO && sign1 == NO && t2 != KIND_CARRY)
                convSint2long();
            else
                convUint2long();
        }
        return;
    }

    /* Converting between pointer types..far and near */
    if (t1 == KIND_CPTR && t2 == KIND_INT)
        convUint2long();
    else if (t2 == KIND_CPTR && t1 == KIND_INT)
        warning(W_FARNR);

    /* Char conversion */
    if (t1 == KIND_CHAR && sign2 == NO && !lconst) {
        if (sign1 == NO)
            convSint2char();
        else
            convUint2char();
    } else if (t1 == KIND_CHAR && sign2 == YES && !lconst) {
        if (sign1 == NO)
            convSint2char();
        else
            convUint2char();
    }
}

/*
 * If only one operand is KIND_DOUBLE, converts the other one to
 * KIND_DOUBLE.  Returns 1 if result will be KIND_DOUBLE
 *
 * Maybe should an operand in here for KIND_LONG?
 */
int widen(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == KIND_DOUBLE) {
        if (lval->val_type != KIND_DOUBLE) {
            dpush_under(lval->val_type); /* push 2nd operand UNDER 1st */
            mainpop();
            if (lval->val_type == KIND_LONG)
                zpop();
            convert_int_to_double(lval->val_type, lval->flags & UNSIGNED);
            DoubSwap();
            lval->val_type = KIND_DOUBLE; /* type of result */
        }
        return (1);
    } else {
        if (lval->val_type == KIND_DOUBLE) {
            convert_int_to_double(lval2->val_type, lval2->flags & UNSIGNED);
            lval2->val_type = KIND_DOUBLE;
            return (1);
        } else
            return (0);
    }
}

void widenlong(LVALUE* lval, LVALUE* lval2)
{
    if (lval2->val_type == KIND_CARRY) {
        zcarryconv();
        lval2->val_type = KIND_INT;
    }

    if (lval2->val_type == KIND_LONG) {
        /* Second operator is long */
        if (lval->val_type != KIND_LONG) {
            doexx(); /* Preserve other operator */
            mainpop();
            force(KIND_LONG, lval->val_type, lval->flags & UNSIGNED, lval->flags & UNSIGNED, 0);
            lpush(); /* Put the new expansion on stk*/
            doexx(); /* Get it back again */
            lval->val_type = KIND_LONG;
        }
        return;
    }

    if (lval->val_type == KIND_LONG) {
        if (lval2->val_type != KIND_LONG && lval2->val_type != KIND_CPTR) {
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
            lval->val_type = KIND_LONG;
        }
    }
    if ((lval->flags & UNSIGNED) || (lval2->flags & UNSIGNED)) {
         lval->flags |= UNSIGNED;
         lval2->flags |= UNSIGNED;
    }
}

/*
 * true if val1 -> int pointer or int array and
 * val2 not ptr or array
 */
int dbltest(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type) {
        if (lval->ptr_type == KIND_CHAR)
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
        if (lval->val_type == KIND_CPTR)
            lval->val_type = KIND_LONG;
        else
            lval->val_type = KIND_INT;
        lval->indirect_kind = 0;
        lval->ident = ID_VARIABLE;
    } else if (lval2->ptr_type) { /* ptr +- int => ptr */
        lval->symbol = lval2->symbol;
        lval->indirect_kind = lval2->indirect_kind;
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
        if (lval->indirect_kind) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        //intcheck(lval, lval);
        switch (lval->ptr_type) {
        case KIND_DOUBLE:
            zadd_const(lval, (n * 6));
            break;
        case KIND_STRUCT:
            zadd_const(lval, n * lval->ltype->tag->size);
            break;
        case KIND_LONG:
            (*step)(lval);
        case KIND_CPTR:
            (*step)(lval);
        case KIND_INT:
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
        if (lval->indirect_kind) {
            addstk(lval);
            if (lval->flags & FARACC)
                lpush();
            else
                zpush();
        }
        rvalue(lval);
        switch (lval->ptr_type) {
        case KIND_DOUBLE:
            nstep(lval, n * 6, unstep);
            break;
        case KIND_STRUCT:
            nstep(lval, n * lval->ltype->tag->size, unstep);
            break;
        case KIND_LONG:
            nstep(lval, n * 4, unstep);
            break;
        case KIND_CPTR:
            nstep(lval, n * 3, unstep);
            break;
        case KIND_INT:
            (*step)(lval);
        default:
            (*step)(lval);
            store(lval);
            if (unstep)
                (*unstep)(lval);
            if (lval->ptr_type == KIND_INT)
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
    zadd_const(lval, n);
    store(lval);
    if (unstep)
        zadd_const(lval, -n);
}

void store(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isconst ) {
        if ( lval->symbol->isassigned ) 
            error(E_CHANGING_CONST, lval->symbol);
    }
    if ( lval->symbol ) 
        lval->symbol->isassigned = YES;
    if (lval->symbol && (lval->symbol->type == KIND_PORT8 || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_out(lval->symbol);
    } else if (lval->indirect_kind == 0)
        putmem(lval->symbol);
    else
        putstk(lval->indirect_kind);
}

/*
 * push address only if it's not that of a two byte quantity at TOS
 * or second TOS.  In either of those cases, forget address calculation
 * This should be followed by a smartstore()
 */
void smartpush(LVALUE* lval, char* before)
{
    if (lval->indirect_kind != KIND_INT || lval->symbol == NULL || lval->symbol->storage != STKLOC) {
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
    if (lval->indirect_kind != KIND_INT || lval->symbol == NULL || lval->symbol->storage != STKLOC) {
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
        warning(W_UNINITIALISED_ID_VARIABLE, lval->symbol->name);
    }
    if (lval->symbol && strncmp(lval->symbol->name, "0dptr", 5) == 0)
        lval->symbol = lval->symbol->offset.p;

    if (lval->symbol && (lval->symbol->type == KIND_PORT8  || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect_kind == 0) {
       
        getmem(lval->symbol);
    } else {
        indirect(lval);
    }
    if (lval->cast_type ) docast(lval, lval);
}

void rvalue(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isassigned == NO && buffer_fps_num == 0 ) {
        warning(W_UNINITIALISED_ID_VARIABLE, lval->symbol->name);
    }
    if (lval->symbol && (lval->symbol->type == KIND_PORT8  || lval->symbol->type == KIND_PORT16) ) {
        intrinsic_in(lval->symbol);
    } else if (lval->symbol && lval->indirect_kind == 0) { 
        getmem(lval->symbol);
    } else {           
        indirect(lval);
    }
    if (lval->cast_type ) docast(lval, lval);
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
    LVALUE lval={0};
    void (*oper)(LVALUE *lva);

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
        if (lval.binop == dummy || check_lastop_was_testjump(&lval)) {
            if (lval.binop == dummy)
                lval.val_type = KIND_INT; /* logical always int */
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
    if ( valtype == KIND_DOUBLE && con ) {
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
    case KIND_INT:
        *val *= 2;
        break;
    case KIND_CPTR:
        *val *= 3;
        break;
    case KIND_LONG:
        *val *= 4;
        break;
    case KIND_DOUBLE:
        *val *= 6;
        break;
    case KIND_STRUCT:
        *val *= tag->size;
        break;
    }
}


/**
 * \param lval - The lval that holds the cast informatino
 * \param dest_lval - The lvalue that will be changed
 */
int docast(LVALUE* lval, LVALUE *dest_lval)
{
//     SYMBOL* ptr;
//     char temp_type;
//     int itag;
//     char nam[20];


//     if (lval->c_id == ID_VARIABLE) {
//         /* Straight forward variable conversion now.. */
//         if ( dest_lval->is_const == 0 ) {
//             force(lval->c_vtype, dest_lval->val_type, lval->c_flags & UNSIGNED, dest_lval->flags & UNSIGNED, 0);
//         }
//         dest_lval->val_type = lval->c_vtype;
//         dest_lval->ptr_type = 0;
//         dest_lval->ident = ID_VARIABLE;
//         dest_lval->flags = ((dest_lval->flags & FARACC) | (lval->c_flags & UNSIGNED));
//         dest_lval->c_id = 0;
//         dest_lval->c_vtype = 0;
//         dest_lval->c_flags = 0;
//         return (0);
//     }

//     if (lval->c_id == POINTER || lval->c_id == PTR_TO_FN) {
//         switch (lval->c_vtype) {
//         case KIND_STRUCT:
//             /* Casting a structure - has to be a pointer... */
//             dest_lval->tagsym = lval->c_tag; /* Copy tag symbol over */
//             dest_lval->ptr_type = KIND_STRUCT;
//             temp_type = ((lval->c_flags & FARPTR) ? KIND_CPTR : KIND_INT);
//             if ( dest_lval->const_val == 0 ) {
//                 force(temp_type, dest_lval->val_type, 0, 0, 0);
//             }
//             dest_lval->val_type = temp_type;
//             dest_lval->flags = ((lval->flags & FARACC) | lval->c_flags);
//             dest_lval->c_id = 0;
//             dest_lval->c_vtype = 0;
//             dest_lval->c_flags = 0;
//             return (1);

//         /* All other simple pointers.. */
//         default:
//             debug(DBG_CAST2, "Converting %d to %d", dest_lval->ptr_type, lval->c_vtype);
//             dest_lval->indirect_kind = dest_lval->ptr_type = lval->c_vtype;
//             // Set the destination symbol type
//             dest_lval->symbol = dummy_sym[(int)lval->c_vtype];
//             temp_type = ((lval->c_flags & FARPTR) ? KIND_CPTR : KIND_INT);
//             if ( dest_lval->const_val == 0 ) {
//                 force(temp_type, dest_lval->val_type, 0, 0, 0);
//             }
//             dest_lval->val_type = temp_type;
//             dest_lval->flags = ((dest_lval->flags & FARACC) | lval->c_flags);
//             dest_lval->ident = POINTER;
//             dest_lval->c_id = 0;
//             dest_lval->c_vtype = 0;
//             dest_lval->c_flags = 0;
//             return (1);
//         }
//     }
//     /* Now we deal with pointers to pointers and pointers to functions 
//  * returning pointers - to do this, we will define dummy symbols in
//  * the local symbol table so that they do what we want them to do!
//  */
//     sprintf(nam, "0dptr%p", locptr);
//     temp_type = ((lval->c_flags & FARPTR) ? KIND_CPTR : KIND_INT);
//     itag = 0;
//     if (lval->c_tag)
//         itag = lval->c_tag - tagtab;
//     ptr = lval->symbol;
//     dest_lval->symbol = addloc(nam, POINTER, temp_type, dummy_idx(lval->c_vtype, lval->c_tag), itag);
//     dest_lval->symbol->offset.p = ptr;
//     if ( dest_lval->const_val == 0 ) {
//         force(temp_type, dest_lval->val_type, 0, 0, 0);
//     }
//     dest_lval->val_type = temp_type;
//     dest_lval->flags = ((dest_lval->flags & FARACC) | lval->c_flags);
//     dest_lval->c_id = 0;
//     dest_lval->c_vtype = 0;
//     dest_lval->c_flags = 0;
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

int check_lastop_was_testjump(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle || fn == lneg || fn == dummy)
        return (0);
    return (1);
}

/*
 * Check whether previous operation was comparison (used for testjump!)
 * At the same time set the result to be of type KIND_INT
 */

int check_lastop_was_comparison(LVALUE* lval)
{
    void (*fn)(LVALUE *lval);
    fn = lval->binop;

    if (fn == zeq || fn == zne || fn == zge || fn == zle || fn == zgt || fn == zlt || fn == zle) {
        lval->val_type = KIND_INT;
        return (0);
    }
    return (1);
}

/* Generate Code to Turn integer type of signed to double, Generic now does longs */
void convert_int_to_double(char type, char zunsign)
{
    if (type == KIND_INT || type == KIND_CHAR) {
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
