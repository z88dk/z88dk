/*
 * cc4.c - fourth part of Small-C/Plus compiler
 *         routines for recursive descent
 *
 * $Id: expr.c,v 1.13 2016-03-29 13:39:44 dom Exp $
 *
 */

/* 9/9/98 djm - Modified plnge2a to use unsigned functions for unsigned
 *              variables, seems to be fine..
 *
 * Have added parameter to addconst, so to not do long add for stack ops
 *
 */

/* 14/9/98 Some conditional long pointer stuff inserted
 *
 * 5/10/98 Some simple prototyping 
 *
 *13/11/98 Radically changed handling of longs - now they are pushed onto
 *         the stack instead of being held in alternate register set
 */

#include "ccdefs.h"

/* Clear the casting markers */
void ClearCast(LVALUE* lval)
{
    lval->c_vtype = lval->c_id = lval->c_flags = 0;
    lval->c_tag = NULL;
    lval->level = 0;
    lval->castlevel = 0;
}

int expression(int  *con, double *val, uint32_t *packedArgumentType)
{
    LVALUE lval={0};
    char type;

    ClearCast(&lval);

    if (heir1(&lval)) {
        rvalue(&lval);
    }
    fnflags = lval.flags;
    if (lval.ptr_type) {
        type = lval.ptr_type;
        lval.ident = POINTER;
    } else {
        type = lval.val_type;
    }
    *packedArgumentType = CalcArgValue(type, lval.ident, lval.flags);
    margtag = 0;
    if (lval.tagsym)
        margtag = (lval.tagsym - tagtab);
    *con = lval.is_const;
    *val = lval.const_val;
    return lval.val_type;
}

int heir1(LVALUE* lval)
{
    char *before, *start;
    LVALUE lval2, lval3;
    void (*oper)(LVALUE *lval) = NULL;
    void  (*doper)(LVALUE *lval) = NULL;
    void (*constoper)(LVALUE *lval, int32_t constvalue) = NULL;
    int k;

    ClearCast(&lval2);
    ClearCast(&lval3);
    lval2.level = lval3.level = lval->level;
    setstage(&before, &start);
    k = plnge1(heir1a, lval);
    if (lval->is_const) {
        load_constant(lval);
    }
    doper = NULL;
    if (cmatch('=')) {
        char *start1, *before1;
        if (k == 0) {
            needlval();
            return 0;
        }
        if (lval->indirect)
            smartpush(lval, before);
        setstage(&before1, &start1);
        if (heir1(&lval2))
            rvalue(&lval2);
            
        /* If it's a const, then load it with the right type */
        if ( lval2.is_const ) {
            /* This leaves the double with a count of 2 */
            if ( lval2.val_type == DOUBLE ) {
                decrement_double_ref(&lval2);
                decrement_double_ref(&lval2);
            }
            clearstage(before1, 0);
            lval2.val_type = lval->val_type;
            load_constant(&lval2);
        }


        /* Now our type checking so we can give off lots of warnings about
         * type mismatches etc..
         */
        if (lval2.val_type == VOID && lval2.ptr_type == 0)
            warning(W_VOID);
        /* First operand is a pointer */
        if (lval->ptr_type) {
            if (lval2.ptr_type && lval->ptr_type != lval2.ptr_type && (lval2.ptr_type != VOID && lval->ptr_type != VOID)) {
#if 0
                /*
                * Here we have a pointer mismatch, however we don't take account of
                * ptr2ptr, so anything involvind them will barf badly, I'm leaving
                * this for now, since the code is fine, but commenting out the warning
                * which is a bit of shame, but there you go...
                */
                warning(W_PTRTYP);
#endif
            } else if (!(lval2.ptr_type) && !(lval2.is_const) && lval2.ident != FUNCTION)
                warning(W_INTPTR);
        } else if (lval2.ptr_type && (!(lval->ptr_type) && !(lval->is_const))) {
            warning(W_PTRINT);
        }

        // Check that function pointers are assigned correctly + copy the calling convention from RHS as necessary
        if ( lval->symbol && lval->ident == POINTER && lval2.ident == FUNCTION ) {
            if ( lval->symbol->flags & FLOATINGDECL) {
                /* The function pointer was undecorated, it should take on whatever is on the RHS */
                lval->symbol->flags &= ~(CALLEE|SMALLC);
                lval->symbol->flags |= ( lval2.flags & (CALLEE|SMALLC));
            } else {
                if ( (lval->symbol->flags & CALLEE) != (lval2.flags & CALLEE)) {
                    warning(W_CALLINGCONVENTION_MISMATCH, lval->symbol->name, "_z88dk_callee");
                }
                if ( (lval->symbol->flags & SMALLC) != (lval2.flags & SMALLC)) {
                    warning(W_CALLINGCONVENTION_MISMATCH, lval->symbol->name, "__smallc/__stdc");
                }
            }
        }


#ifdef SILLYWARNING
        if (((lval->flags & UNSIGNED) != (lval2.flags & UNSIGNED)) && (!(lval2.is_const) && !(lval->ptr_type) && !(lval2.ptr_type)))
            warning(W_EGSG);
#endif
        force(lval->val_type, lval2.val_type, lval->flags & UNSIGNED, lval2.flags & UNSIGNED, 0); /* 27.6.01 lval2.is_const); */
        smartstore(lval);
        return 0;
    } else if (match("|=")) {
        oper = zor;
        constoper = zor_const;
    } else if (match("^="))
        oper = zxor;
    else if (match("&=")) {
        oper = zand;
        constoper = zand_const;
    } else if (match("+="))
        oper = doper = zadd;
    else if (match("-="))
        oper = doper = zsub;
    else if (match("*=")) {
        oper = doper = mult;
        constoper = mult_const;
    } else if (match("/=")) {
        oper = doper = zdiv;
        constoper = zdiv_const;
    } else if (match("%=")) {
        oper = zmod;
        constoper = zmod_const;
    } else if (match(">>=")) {
        oper = asr;
        constoper = asr_const;
    } else if (match("<<=")) {
        oper = asl;
        constoper = asl_const;
    } else 
        return k;

    /* if we get here we have an oper= */
    if (k == 0) {
        needlval();
        return 0;
    }
    lval3.symbol = lval->symbol;
    lval3.indirect = lval->indirect;
    lval3.flags = lval->flags;
    lval3.val_type = lval->val_type;
    lval3.offset = lval->offset;
    lval3.storage = lval->storage;
    /* don't clear address calc we need it on rhs */
    if (lval->indirect)
        smartpush(lval, 0);
    rvalue(lval);
    if (oper == zadd || oper == zsub)
        plnge2b(heir1, lval, &lval2, oper);
    else
        plnge2a(heir1, lval, &lval2, oper, doper, constoper);

    force(lval3.val_type, lval->val_type, lval3.flags & UNSIGNED, lval->flags & UNSIGNED, lval->is_const);
    smartstore(&lval3);
    return 0;
}

/*
 * heir1a - conditional operator
 */
int heir1a(LVALUE* lval)
{
    int falselab, endlab, skiplab;
    LVALUE lval2;
    int k;
    int temptype;
    ClearCast(&lval2);

    lval2.level = lval->level;
    k = heir2a(lval);
    if (cmatch('?')) {
        /* evaluate condition expression */
        if (k)
            rvalue(lval);
        /* test condition, jump to false expression evaluation if necessary */
        if (DoTestJump(lval)) {
            // Always evaluated as an integer, so fake it temporarily
            force(CINT, lval->val_type, c_default_unsigned, lval->flags & UNSIGNED, 0);
            temptype = lval->val_type;
            lval->val_type = CINT; /* Force to integer */
            testjump(lval, falselab = getlabel());
            lval->val_type = temptype;
            /* evaluate 'true' expression */
            if (heir1(&lval2))
                rvalue(&lval2);
            jump(endlab = getlabel());
            postlabel(falselab);
        } else {
/* New handling by djm 13/5/99, push flags, load true, jump on true 
 * The optimizer will with a bit of luck catch inefficient push/pop
 */
#if 1
            jumpnc(falselab = getlabel());
            if (heir1(&lval2))
                rvalue(&lval2);
            jump(endlab = getlabel());
            postlabel(falselab);
#else
            zpushflags();
            /* evaluate 'true' expression */
            if (heir1(&lval2))
                rvalue(&lval2);
            zpopflags();
            jumpc(endlab = getlabel());
#endif
        }
        needchar(':');
        /* evaluate 'false' expression */
        if (heir1(lval))
            rvalue(lval);
        /* check types of expressions and widen if necessary */
        if (lval2.val_type == DOUBLE && lval->val_type != DOUBLE) {
            convert_int_to_double(lval->val_type, lval->flags & UNSIGNED);
            postlabel(endlab);
        } else if (lval2.val_type != DOUBLE && lval->val_type == DOUBLE) {
            jump(skiplab = getlabel());
            postlabel(endlab);
            convert_int_to_double(lval2.val_type, lval2.flags & UNSIGNED);
            postlabel(skiplab);
        }
        /* 12/8/98 Mod by djm to convert long types - it's nice when someone
 * else has had to do it before! */
        else if (lval2.val_type == LONG && lval->val_type != LONG) {
            /* Check for signed, if both signed convert properly, if one/neither signed
 * then we have dodgy equating in anycase, so treat as unsigned
 */
            widenlong(&lval2, lval);
            lval->val_type = LONG;
            postlabel(endlab);
        } else if (lval2.val_type != LONG && lval->val_type == LONG) {
            jump(skiplab = getlabel());
            postlabel(endlab);
            widenlong(lval, &lval2);
            lval->val_type = LONG;
            postlabel(skiplab);
        } else
            postlabel(endlab);
        /* result cannot be a constant, even if second expression is */
        lval->is_const = 0;
        return 0;
    } else
        return k;
}

int heir2a(LVALUE* lval)
{
    return skim("||", eq0, jumpc, 1, 0, heir2b, lval);
}

int heir2b(LVALUE* lval)
{
    return skim("&&", testjump, jumpnc, 0, 1, heir2, lval);
}

int heir234(LVALUE* lval, int (*heir)(LVALUE *lval), char opch, void (*oper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int32_t value))
{
    LVALUE lval2;
    int k;

    ClearCast(&lval2);
    lval2.level = lval->level;
    k = plnge1(heir, lval);
    blanks();
    if ((ch() != opch) || (nch() == '=') || (nch() == opch))
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if ((ch() == opch) && (nch() != '=') && (nch() != opch)) {
            inbyte();
            plnge2a(heir, lval, &lval2, oper, NULL, constoper);
        } else
            return 0;
    }
}

int heir2(LVALUE* lval)
{
    return heir234(lval, heir3, '|', zor, zor_const);
}

int heir3(LVALUE* lval)
{
    return heir234(lval, heir4, '^', zxor, NULL);
}

int heir4(LVALUE* lval)
{
    return heir234(lval, heir5, '&', zand, zand_const);
}

int heir5(LVALUE* lval)
{
    LVALUE lval2;
    int k;

    ClearCast(&lval2);
    lval2.level = lval->level;

    k = plnge1(heir6, lval);
    blanks();
    if ((streq(line + lptr, "==") == 0) && (streq(line + lptr, "!=") == 0))
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (match("==")) {
            plnge2a(heir6, lval, &lval2, zeq, zeq, NULL);
        } else if (match("!=")) {
            plnge2a(heir6, lval, &lval2, zne, zne, NULL);
        } else
            return 0;
    }
}

int heir6(LVALUE* lval)
{
    LVALUE lval2;
    int k;

    ClearCast(&lval2);
    lval2.level = lval->level;

    k = plnge1(heir7, lval);
    blanks();
    if (ch() != '<' && ch() != '>' && (streq(line + lptr, "<=") == 0) && (streq(line + lptr, ">=") == 0))
        return k;
    if (streq(line + lptr, ">>"))
        return k;
    if (streq(line + lptr, "<<"))
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (match("<=")) {
            plnge2a(heir7, lval, &lval2, zle, zle, NULL);
        } else if (match(">=")) {
            plnge2a(heir7, lval, &lval2, zge, zge, NULL);
        } else if (ch() == '<' && nch() != '<') {
            inbyte();
            plnge2a(heir7, lval, &lval2, zlt, zlt, NULL);
        } else if (ch() == '>' && nch() != '>') {
            inbyte();
            plnge2a(heir7, lval, &lval2, zgt, zgt, NULL);
        } else
            return 0;
    }
}

int heir7(LVALUE* lval)
{
    LVALUE lval2;
    int k;

    ClearCast(&lval2);
    lval2.level = lval->level;

    k = plnge1(heir8, lval);
    blanks();
    if ((streq(line + lptr, ">>") == 0) && (streq(line + lptr, "<<") == 0))
        return k;
    if (streq(line + lptr, ">>="))
        return k;
    if (streq(line + lptr, "<<="))
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if ((streq(line + lptr, ">>") == 2) && (streq(line + lptr, ">>=") == 0)) {
            inbyte();
            inbyte();
            plnge2a(heir8, lval, &lval2, asr, NULL, asr_const);
        } else if ((streq(line + lptr, "<<") == 2) && (streq(line + lptr, "<<=") == 0)) {
            inbyte();
            inbyte();
            plnge2a(heir8, lval, &lval2, asl, NULL, asl_const);
        } else
            return 0;
    }
}

int heir8(LVALUE* lval)
{
    LVALUE lval2;
    int k;

    ClearCast(&lval2);
    lval2.level = lval->level;

    k = plnge1(heir9, lval);
    blanks();
    if (ch() != '+' && ch() != '-')
        return k;
    if (nch() == '=')
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (cmatch('+')) {
            plnge2b(heir9, lval, &lval2, zadd);
        } else if (cmatch('-')) {
            plnge2b(heir9, lval, &lval2, zsub);
        } else
            return 0;
    }
}

int heir9(LVALUE* lval)
{
    LVALUE lval2;
    int k;
    ClearCast(&lval2);
    lval2.level = lval->level;

    k = plnge1(heira, lval);
    blanks();
    if (ch() != '*' && ch() != '/' && ch() != '%')
        return k;
    if (nch() == '=')
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (cmatch('*')) {
            plnge2a(heira, lval, &lval2, mult, mult, mult_const);
        } else if (cmatch('/')) {
            plnge2a(heira, lval, &lval2, zdiv, zdiv, zdiv_const);
        } else if (cmatch('%')) {
            plnge2a(heira, lval, &lval2, zmod, zmod, zmod_const);
        } else
            return 0;
    }
}

/*
 * perform lval manipulation for pointer dereferencing/array subscripting
 */

/* djm, I can't make this routine distinguish between ptr->ptr and ptr
 * so if address loads dummy de,0 to ensure everything works out
 */
SYMBOL *deref(LVALUE* lval, char isaddr)
{
    char flags;
    flags = lval->flags;
    if (isaddr) {
        if (flags & FARACC)
            flags |= FARACC;
    } else {
        if (flags & FARPTR)
            flags |= FARACC;
        else
            flags &= ~FARACC;
    }
    if ( lval->symbol->type == PORT8 || lval->symbol->type == PORT16 ) {
        error(E_PORT_DEREF, lval->symbol->name);
    }
    /* NB it has already been determind that lval->symbol is non-zero */
    if (lval->symbol->more == 0) {
        /* array of/pointer to variable */
        if (flags & FARPTR && lval->val_type == CPTR)
            flags |= FARACC;
        // else flags &= ~FARACC;
        lval->val_type = lval->indirect = lval->symbol->type;
        lval->flags = flags;
        lval->symbol = NULL; /* forget symbol table entry */
        lval->ptr_type = 0; /* flag as not symbol or array */
        lval->ident = VARIABLE; /* We're now a variable! */
    } else {
        /* array of/pointer to pointer */
        lval->symbol = dummy_sym[(int)lval->symbol->more];
        /* djm long pointers */
        lval->ptr_type = lval->symbol->type;
        /* 5/10/98 restored lval->val_type */
        lval->indirect = lval->val_type = (flags & FARPTR ? CPTR : CINT);
        if (flags & FARPTR)
            flags |= FARACC;
        lval->flags = flags;
        if (lval->symbol->type == STRUCT)
            lval->tagsym = tagtab + lval->symbol->tag_idx;
    }
    return lval->symbol;
}

int heira(LVALUE* lval)
{
    int k, j;
    TAG_SYMBOL* otag;
    struct varid var;
    char ident;
    int klptr;
    int save_fps_num;

    /* Cast check, little kludge here */
    save_fps_num = buffer_fps_num;
    buffer_fps_num = 0;
    if (rcmatch('(')) {
        klptr = lptr;
        lptr++;
        otag = GetVarID(&var, NO);
        var.sflag = ((var.sign & UNSIGNED) | (var.zfar & FARPTR));
        if (var.type != NO) {
            ident = get_ident(var.ident);
            if (ident == PTR_TO_FN || ident == FUNCTIONP)
                needtoken(")()");
            /*
 * Scrunch everything together, replace c_ptype with c_id
 */
            lval->c_vtype = var.type;
            lval->c_id = ident;
            lval->c_tag = otag;
            lval->c_flags = var.sflag;
            lval->castlevel = lval->level;
            needchar(')');
            for ( j = 0; j < save_fps_num; j++ ) {
                 fprintf(buffer_fps[j],"%.*s",lptr-klptr,line+klptr);
            }
            buffer_fps_num = save_fps_num;
            return (heira(lval));
        } else {
            lptr = klptr;
        }
    }
    buffer_fps_num = save_fps_num;

    if (match("++")) {
        prestep(lval, 1, inc);
        return 0;
    } else if (match("--")) {
        prestep(lval, -1, dec);
        return 0;
    } else if (cmatch('~')) {
        if (heira(lval))
            rvalue(lval);
        intcheck(lval, lval);
        com(lval);
        lval->const_val = ~(int32_t)lval->const_val;
        lval->stage_add = NULL;
        return 0;
    } else if (cmatch('!')) {
        if (heira(lval))
            rvalue(lval);
        lneg(lval);
        lval->binop = lneg;
        lval->const_val = !lval->const_val;
        lval->stage_add = NULL;
        return 0;
    } else if (cmatch('-')) {
        if (heira(lval))
            rvalue(lval);
        neg(lval);
        if (lval->val_type != DOUBLE)
            lval->const_val = -lval->const_val;
        lval->stage_add = NULL;
        return 0;
    } else if (cmatch('*')) { /* unary * */
        if (heira(lval))
            rvalue(lval);
        /* Cast the symbol before derefencing.. */
        if (lval->c_id /* != VARIABLE */) {
            j = docast(lval, 1);
            if (j)
                lval->indirect = lval->c_vtype;
        }

        if (lval->symbol == 0) {
            error(E_DEREF);
            junk();
            return 0;
        } else {
            deref(lval, NO);
        }
        lval->is_const = 0; /* flag as not constant */
        lval->const_val = 1; /* omit rvalue() on func call */
        lval->stage_add = 0;
        return 1; /* dereferenced pointer is lvalue */
    } else if (cmatch('&')) {
        if (heira(lval) == 0) {
            // There probably needs to be some checks in here, to be defined later
            if (lval->c_vtype)
                docast(lval, NO);
            return 0;
        }
        // Do the cast in here and convert the type, but don't generate any code.
        if (lval->c_vtype)
            docast(lval, NO);

        if (lval->symbol) {
            lval->ptr_type = lval->symbol->type;
            lval->val_type = (lval->flags & FARACC ? CPTR : CINT);
            lval->symbol->isassigned = YES;
        } else {
            warning(W_BUG1);
            warning(W_BUG2);
            lval->ptr_type = VOID;
            lval->val_type = (lval->flags & (FARACC | FARPTR)) ? CPTR : CINT;
        }
        if (lval->indirect)
            return 0;
        /* global & non-array */
        address(lval->symbol);
        lval->indirect = lval->symbol->type;
        return 0;
    } else {

        k = heirb(lval);

        if (k)
            ltype = lval->val_type; /* djm 28/11/98 */
        if (match("++")) {
            poststep(k, lval, 1, inc, dec);
            return 0;
        } else if (match("--")) {
            poststep(k, lval, -1, dec, inc);

            return 0;
        } else
            return k;
    }
}

int heirb(LVALUE* lval)
{
    char *before, *start;
    char *before1, *start1;
    char sname[NAMESIZE];
    double dval;
    int val, con, direct, k, valtype;
    char flags;
    SYMBOL* ptr;

    setstage(&before1, &start1);
    k = primary(lval);
    ptr = lval->symbol;
    blanks();
    if (ch() == '[' || ch() == '(' || ch() == '.' || (ch() == '-' && nch() == '>'))
        while (1) {
            if (cmatch('[')) {
                uint32_t packedType;

                if (ptr == 0) {
                    error(E_SUBSCRIPT);
                    junk();
                    needchar(']');
                    return 0;
                } else if (k && ptr->ident == POINTER)
                    rvalue(lval);
                else if (ptr->ident != POINTER && ptr->ident != ARRAY) {
                    error(E_SUBSCRIPT);
                    k = 0;
                }
                setstage(&before, &start);
                if (lval->flags & FARPTR)
                    zpushde();
                lval->ident = VARIABLE;
                zpush();
                valtype = expression(&con, &dval, &packedType);
                // TODO: Check valtype
                val = dval;
                needchar(']');
                if (con) {
                    Zsp += 2; /* undo push */
                    if (lval->flags & FARPTR)
                        Zsp += 2;
                    if (lval->symbol->more)
                        cscale(lval->val_type, tagtab + ptr->tag_idx, &val);
                    else
                        cscale(ptr->type, tagtab + ptr->tag_idx, &val);
                    if (ptr->storage == STKLOC && ptr->ident == ARRAY) {
                        /* constant offset to array on stack */
                        /* do all offsets at compile time */
                        clearstage(before1, 0);
                        lval->offset = getloc(ptr, val);
                    } else {
                        /* add constant offset to address in primary */
                        clearstage(before, 0);
                        //        if (lval->symbol->more)
                        //                cscale(lval->val_type,tagtab+ptr->tag_idx,&val);
                        addconst(val, 1, 0);
                    }
                } else {
                    /* non-constant subscript, calc at run time */
                    if (lval->symbol->more) {
                        scale(lval->val_type, tagtab + ptr->tag_idx);
                    } else {
                        scale(ptr->type, tagtab + ptr->tag_idx);
                    }
                    /* If near, then pop other side back, otherwise
                       load high reg with de and do an add  */
                    if (lval->flags & FARPTR) {
                        const2(0);
                    } else {
                        zpop();
                    }
                    zadd(lval);
                    /* If long pointer restore upper 16 bits */
                    //    if (lval->flags&FARPTR) zpop();
                }
                ptr = deref(lval, YES);
                k = 1;
            } else if (cmatch('(')) {
                if (ptr == NULL) {
                    callfunction(NULL,NULL);
                    /* Bugger knows what ya doing..stop SEGV */
                    ptr = dummy_sym[VOID];
                    warning(W_INTERNAL);
                } else if (ptr->ident != FUNCTION) {
                    if (k && lval->const_val == 0)
                        rvalue(lval);
                    callfunction(NULL,ptr);
                } else
                    callfunction(ptr,NULL);
                lval->flags &= ~(CALLEE|FASTCALL|SMALLC);
                k = lval->is_const = lval->const_val = 0;
                if (ptr && ptr->more == 0) {
                    /* function returning variable */
                    lval->ptr_type = 0;
                    lval->val_type = ptr->type;
                    lval->ident = VARIABLE;
                    ptr = lval->symbol = NULL;
                } else {
                    /* function returning pointer */
                    lval->flags = ptr->flags & ~(CALLEE|SMALLC|FASTCALL); /* djm */
                    ptr = lval->symbol = dummy_sym[(int)ptr->more];
                    lval->ident = POINTER;
                    lval->indirect = lval->ptr_type = ptr->type;
                    /* djm - 24/11/98 */
                    lval->val_type = (lval->flags & FARPTR ? CPTR : CINT);
                    if (ptr->type == STRUCT) {
                        lval->tagsym = tagtab + ptr->tag_idx;
                    }
                }
                /* Perform the cast here */
                if (lval->c_vtype)
                    docast(lval, YES);

            }
            /* Handle structures... come in here with lval holding tehe previous
             * pointer to the struct thing..*/
            else if ((direct = cmatch('.')) || match("->")) {
                /* Check to see if we have a cast in operation, if so then change type
                 * internally, but don't generate any code */
                if (lval->tagsym == 0) {
                    error(E_MEMBER);
                    junk();
                    return 0;
                }
                if (symname(sname) == 0 || (ptr = findmemb(lval->tagsym, sname)) == 0) {
                    error(E_UNMEMB, sname);
                    junk();
                    return 0;
                }
                /*
                 * Here, we're trying to chase our member up, we have to be careful
                 * not to access via far methods near data..
                 */
                if (k && direct == 0)
                    rvaluest(lval);

                if (lval->c_tag)
                    docast(lval, NO);
                debug(DBG_FAR1, "prev=%s name=%s flags %d oflags %d", lval->symbol->name, ptr->name, lval->flags, lval->oflags);
                flags = ptr->flags;
                if (direct == 0) {
                    /* So, we're accessing via a pointer if we get here */
                    flags = ptr->flags;
                    if (lval->oflags & FARACC || (lval->flags & FARPTR))
                        flags |= FARACC;
                    if (flags & FARPTR || (lval->flags & FARPTR))
                        lval->oflags |= FARACC;
                }
                lval->flags = flags;

                addconst(ptr->offset.i, 1, ptr->flags & FARPTR);
                lval->symbol = ptr;
                lval->indirect = lval->val_type = ptr->type;
                lval->ptr_type = lval->is_const = lval->const_val = 0;
                lval->ident = VARIABLE;
                lval->stage_add = NULL;
                lval->tagsym = NULL;
                lval->binop = NULL;
                if (ptr->type == STRUCT)
                    lval->tagsym = tagtab + ptr->tag_idx;
                if (ptr->ident == POINTER) {
                    lval->ptr_type = ptr->type;
                    lval->ident = POINTER;
                    /* djm */
                    if (ptr->flags & FARPTR) {
                        lval->indirect = CPTR;
                        lval->val_type = CPTR;
                    } else {
                        lval->indirect = CINT;
                        lval->val_type = CINT;
                    }
                }
                if (ptr->ident == ARRAY || (ptr->type == STRUCT && ptr->ident == VARIABLE)) {
                    /* array or struct */
                    lval->ptr_type = ptr->type;
                    lval->ident = POINTER;
                    /* djm Long pointers here? */

                    lval->val_type = ((ptr->flags & FARPTR) ? CPTR : CINT);
                    k = 0;
                } else
                    k = 1;
            } else
                return k;
        }
    if (ptr && ptr->ident == FUNCTION) {
        address(ptr);
        lval->symbol = NULL;  // TODO: Can we actually set it correctly here? - Needed for verification of func ptr arguments
        lval->flags = ptr->flags;
        lval->ident = FUNCTION;
        return 0;
    }
    return k;
}
