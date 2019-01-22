/*
 * cc4.c - fourth part of Small-C/Plus compiler
 *         routines for recursive descent
 *
 * $Id: expr.c,v 1.13 2016-03-29 13:39:44 dom Exp $
 *
 */


#include "ccdefs.h"

static int        heir1a(LVALUE *lval);
static int        heir2a(LVALUE *lval);
static int        heir2b(LVALUE *lval);
static int        heir234(LVALUE *lval, int (*heir)(LVALUE *lval), char opch, void (*oper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int32_t value));
static int        heir2(LVALUE *lval);
static int        heir3(LVALUE *lval);
static int        heir4(LVALUE *lval);
static int        heir5(LVALUE *lval);
static int        heir6(LVALUE *lval);
static int        heir7(LVALUE *lval);
static int        heir8(LVALUE *lval);
static int        heir9(LVALUE *lval);
static int        heirb(LVALUE *lval);
static SYMBOL    *deref(LVALUE *lval, char isaddr);


Kind expression(int  *con, double *val, Type **type)
{
    LVALUE lval={0};

    if (heir1(&lval)) {
        rvalue(&lval);
    }
    *con = lval.is_const;
    *val = lval.const_val;
    *type = lval.ltype;
    return lval.ltype ? lval.ltype->kind : KIND_NONE;
}

int heir1(LVALUE* lval)
{
    char *before, *start;
    LVALUE lval2={0}, lval3={0};
    void (*oper)(LVALUE *) = NULL;
    void  (*doper)(LVALUE *lval) = NULL;
    void (*constoper)(LVALUE *lval, int32_t constvalue) = NULL;
    int k;

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
        if (lval->indirect_kind)
            smartpush(lval, before);
        setstage(&before1, &start1);
        if (heir1(&lval2))
            rvalue(&lval2);
            
        /* If it's a const, then load it with the right type */
        if ( lval2.is_const ) {
            /* This leaves the double with a count of 2 */
            if ( lval2.val_type == KIND_DOUBLE ) {
                decrement_double_ref(&lval2);
                decrement_double_ref(&lval2);
            }
            clearstage(before1, 0);
            lval2.val_type = lval->val_type;
            load_constant(&lval2);
        }

        if ( ispointer(lval->ltype)) {
            Type *rhs = lval2.ltype;

            if ( lval->ltype->ptr->kind == KIND_FUNC && rhs->kind == KIND_FUNC ) {
                rhs = make_pointer(rhs);
            }

            if (  rhs->kind == KIND_ARRAY ) {
                rhs = make_pointer(rhs->ptr);
            }
            
            if ( type_matches(lval->ltype, rhs) == 0 && lval->ltype->ptr->kind != KIND_VOID && 
                    ! (ispointer(rhs) && rhs->ptr->kind == KIND_VOID) )  {
                if ( ispointer(lval->ltype) && lval2.is_const && lval2.const_val == 0 ) {
                } else {
                    UT_string *str;

                    utstring_new(str);
                    utstring_printf(str,"Assigning '%s', type: ", lval->ltype->name);
                    type_describe(lval->ltype,str);
                    utstring_printf(str," from ");
                    type_describe(rhs, str);
                    warningfmt("incompatible-pointer-types","%s", utstring_body(str));
                    utstring_free(str);
                }
            } else if ( lval->ltype->ptr->kind == KIND_FUNC && rhs->ptr->kind == KIND_FUNC ) {
                // Check flag assignment
                if ( (lval->ltype->ptr->flags & CALLEE) && (rhs->ptr->flags & CALLEE) == 0 ) {
                    warningfmt("incompatible-function-types","Assigning CALLEE function pointer with non-CALLEE function");
                }
                if ( (lval->ltype->ptr->flags & SMALLC) && (rhs->ptr->flags & SMALLC) == 0 ) {
                    warningfmt("incompatible-function-types","Assigning SMALLC function pointer with non-SMALLC function");
                }
            }
        } else if ( lval->ltype->kind == KIND_STRUCT ) {
            errorfmt("Cannot assign to aggregate",0);
        } 
        if ( lval2.ltype->kind == KIND_VOID ) {
            warningfmt("void","Assigning from a void expression");
        }
        force(lval->val_type, lval2.val_type, lval->ltype->isunsigned, lval2.ltype->isunsigned, 0); /* 27.6.01 lval2.is_const); */
        smartstore(lval);
        return 0;
    } else if (match("|=")) {
        oper = zor;
        constoper = zor_const;
    } else if (match("^=")) {
        oper = zxor;
        constoper = zxor_const;
    } else if (match("&=")) {
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
    lval3.ltype = lval->ltype;
    lval3.indirect_kind = lval->indirect_kind;
    lval3.flags = lval->flags;
    lval3.val_type = lval->val_type;
    lval3.offset = lval->offset;
    lval3.base_offset = lval->base_offset;
    lval3.const_val = lval->const_val;
    lval3.is_const = lval->is_const;
    /* don't clear address calc we need it on rhs */
    if (lval->indirect_kind)
        smartpush(lval, 0);
    rvalue(lval);
    if (oper == zadd || oper == zsub)
        plnge2b(heir1, lval, &lval2, oper);
    else
        plnge2a(heir1, lval, &lval2, oper, doper, constoper);

    force(lval3.val_type, lval->val_type, lval3.ltype->isunsigned, lval->ltype->isunsigned, lval->is_const);
    smartstore(&lval3);
    return 0;
}

/*
 * heir1a - conditional operator
 */
int heir1a(LVALUE* lval)
{
    int falselab, endlab, skiplab;
    LVALUE lval2={0};
    int k;
    Kind temptype;
    Type *templtype;

    k = heir2a(lval);
    if (cmatch('?')) {
        /* evaluate condition expression */
        if (k)
            rvalue(lval);

        if ( lval->is_const ) {
            vconst(lval->const_val);
        }
        /* test condition, jump to false expression evaluation if necessary */
        if (check_lastop_was_testjump(lval)) {
            // Always evaluated as an integer, so fake it temporarily
            force(KIND_INT, lval->val_type, c_default_unsigned, lval->ltype->isunsigned, 0);
            temptype = lval->val_type;
            templtype = lval->ltype;
            lval->val_type = KIND_INT; /* Force to integer */
            lval->ltype = type_int;
            testjump(lval, falselab = getlabel());
            lval->val_type = temptype;
            lval->ltype = templtype;
            /* evaluate 'true' expression */
            if (heir1(&lval2))
                rvalue(&lval2);
            jump(endlab = getlabel());
            postlabel(falselab);
        } else {
            jumpnc(falselab = getlabel());
            if (heir1(&lval2))
                rvalue(&lval2);
            jump(endlab = getlabel());
            postlabel(falselab);
        }
        needchar(':');
        /* evaluate 'false' expression */
        if (heir1(lval))
            rvalue(lval);
        /* check types of expressions and widen if necessary */
        if (lval2.val_type == KIND_DOUBLE && lval->val_type != KIND_DOUBLE) {
            convert_int_to_double(lval->val_type, lval->ltype->isunsigned);
            postlabel(endlab);
        } else if (lval2.val_type != KIND_DOUBLE && lval->val_type == KIND_DOUBLE) {
            jump(skiplab = getlabel());
            postlabel(endlab);
            convert_int_to_double(lval2.val_type, lval2.ltype->isunsigned);
            postlabel(skiplab);
        } else if (lval2.val_type == KIND_LONG && lval->val_type != KIND_LONG) {
            widenlong(&lval2, lval);
            lval->val_type = KIND_LONG;
            lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            postlabel(endlab);
        } else if (lval2.val_type != KIND_LONG && lval->val_type == KIND_LONG) {
            jump(skiplab = getlabel());
            postlabel(endlab);
            widenlong(lval, &lval2);
            lval->val_type = KIND_LONG;
            lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;            
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
    LVALUE lval2={0};
    int k;

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
    return heir234(lval, heir4, '^', zxor, zxor_const);
}

int heir4(LVALUE* lval)
{
    return heir234(lval, heir5, '&', zand, zand_const);
}

int heir5(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heir6, lval);
    blanks();
    if ((streq(line + lptr, "==") == 0) && (streq(line + lptr, "!=") == 0))
        return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (match("==")) {
            plnge2a(heir6, lval, &lval2, zeq, zeq, zeq_const);
        } else if (match("!=")) {
            plnge2a(heir6, lval, &lval2, zne, zne, zne_const);
        } else
            return 0;
    }
}

int heir6(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

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
            plnge2a(heir7, lval, &lval2, zle, zle, zle_const);
        } else if (match(">=")) {
            plnge2a(heir7, lval, &lval2, zge, zge, zge_const);
        } else if (ch() == '<' && nch() != '<') {
            inbyte();
            plnge2a(heir7, lval, &lval2, zlt, zlt, zlt_const);
        } else if (ch() == '>' && nch() != '>') {
            inbyte();
            plnge2a(heir7, lval, &lval2, zgt, zgt, zgt_const);
        } else
            return 0;
    }
}

int heir7(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

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
    LVALUE lval2={0};
    int k;


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
    LVALUE lval2={0};
    int k;

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

SYMBOL *deref(LVALUE* lval, char isaddr)
{
    Type *old_type = lval->ltype;



    lval->symbol = NULL;
    if ( ispointer(lval->ltype) && lval->ltype->ptr->kind == KIND_FUNC ) {
        return lval->symbol;
    }

    lval->ltype = lval->ltype->ptr;
    if ( lval->ltype->kind != KIND_PTR && lval->ltype->kind != KIND_CPTR ) 
        lval->ptr_type = KIND_NONE;
    else
        lval->ptr_type = lval->ltype->ptr->kind;
    lval->val_type = lval->indirect_kind = lval->ltype->kind;

    if ( old_type->kind == KIND_CPTR ) {
        lval->flags |= FARACC;
    } else {
        lval->flags &= ~FARACC;
    }

    return lval->symbol;
}

int heira(LVALUE *lval)
{
    int k, j;
    LVALUE  cast_lval={0};
    int klptr;
    int save_fps_num;

    /* Cast check, little kludge here */
    save_fps_num = buffer_fps_num;
    buffer_fps_num = 0;
    if (rcmatch('(')) {
        Type  *ctype;
        klptr = lptr;
        lptr++;
        if ( (ctype = parse_expr_type()) != NULL ) {
            needchar(')');
            cast_lval.cast_type = ctype;
            for ( j = 0; j < save_fps_num; j++ ) {
                 fprintf(buffer_fps[j],"%.*s",lptr-klptr,line+klptr);
            }
            buffer_fps_num = save_fps_num;
            k = heira(lval);
            if ( k == 1 ) { // If we need to fetch then we should cast what we get 
                lval->cast_type = cast_lval.cast_type;
            } else {
                if (cast_lval.cast_type ) docast(&cast_lval, lval);
            }
            return k;
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
        lval->const_val = ~(uint32_t)lval->const_val;
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
        if ( lval->val_type == KIND_DOUBLE ) decrement_double_ref(lval);
        lval->const_val = -lval->const_val;
        if ( lval->val_type == KIND_DOUBLE ) increment_double_ref(lval);
        lval->stage_add = NULL;
        return 0;
    } else if (cmatch('*')) { /* unary * */
        if (heira(lval))
            rvalue(lval);
        if (lval->ltype->ptr == NULL ) {
            errorfmt("Can't dereference", 0);
            junk();
            return 0;
        } else {
            deref(lval, NO);
        }
        lval->is_const = 0; /* flag as not constant */
        lval->const_val = 1; /* omit rvalue() on func call */
        lval->stage_add = NULL;
        lval->stage_add_ltype = NULL;
        return 1; /* dereferenced pointer is lvalue */
    } else if (cmatch('&')) {
        if (heira(lval) == 0) {
            lval->ltype = make_pointer(lval->ltype);
            lval->ptr_type = lval->ltype->ptr->kind;
            lval->val_type = lval->flags & FARACC ? KIND_CPTR : KIND_PTR;
            return 0;
        }
        lval->ltype = make_pointer(lval->ltype);
        lval->ptr_type = lval->ltype->ptr->kind;
        lval->val_type = lval->flags & FARACC ? KIND_CPTR : KIND_PTR;

        if (lval->symbol) {
            lval->symbol->isassigned = YES;
        } 
        if (lval->indirect_kind)
            return 0;
        /* global & non-array */
        address(lval->symbol);
        lval->indirect_kind = lval->symbol->ctype->kind;
        return 0;
    }

    k = heirb(lval);

    if (match("++")) {
        poststep(k, lval, 1, inc, dec);
        return 0;
    } else if (match("--")) {
        poststep(k, lval, -1, dec, inc);
        return 0;
    } 
    return k;
}

int heirb(LVALUE* lval)
{
    char *before, *start;
    char *before1, *start1;
    char sname[NAMESIZE];
    double dval;
    int val, con, direct, k, valtype;
    char flags;
    SYMBOL* ptr = NULL;

    setstage(&before1, &start1);

    
    k = primary(lval);
    ptr = lval->symbol;
    blanks();
    if (ch() == '[' || ch() == '(' || ch() == '.' || (ch() == '-' && nch() == '>'))
        while (1) {
            if (cmatch('[')) {
                Type *type;
                
                if (k && ispointer(lval->ltype)) {
                    rvalue(lval);
                } else if ( !ispointer(lval->ltype) && lval->ltype->kind != KIND_ARRAY) {
                    errorfmt("Can't subscript", 0);
                    junk();
                    needchar(']');
                    return 0;
                }
                setstage(&before, &start);
                if (lval->ltype->kind == KIND_CPTR)
                    zpushde();
                zpush();
                valtype = expression(&con, &dval, &type);
                // TODO: Check valtype
                val = dval;
                needchar(']');
                if (con) {
                    Zsp += 2; /* undo push */
                    if (lval->ltype->kind == KIND_CPTR)
                        Zsp += 2;
                    if ( val > lval->ltype->len && lval->ltype->len != -1 && lval->ltype->kind == KIND_ARRAY) {
                        warningfmt("unknown","Access of array at index %d is greater than size %d", val, lval->ltype->len);
                    }
                    cscale(lval->ltype, &val);
                    val += lval->offset;
                    

                    if (ptr && ptr->storage == STKLOC && lval->ltype->kind == KIND_ARRAY && ptr->ctype->kind != KIND_PTR) {
                        /* constant offset to array on stack */
                        /* do all offsets at compile time */
                        clearstage(before1, 0);
                        lval->base_offset = getloc(ptr, val);
                        lval->offset = val;
                    } else {
                        /* add constant offset to address in primary */
                        clearstage(before, 0);
                        //        if (lval->symbol->more)
                        //                cscale(lval->val_type,tagtab+ptr->tag_idx,&val);
                        zadd_const(lval, val  - lval->offset);
                        lval->offset = 0;
                    }
                } else {
                    /* non-constant subscript, calc at run time */
                    if (ispointer(lval->ltype) ) {
                        scale(lval->ltype->ptr->kind, lval->ltype->ptr->tag);
                    } else if ( lval->ltype->kind == KIND_ARRAY ) {
                        LVALUE tmp = {0};
                        int    size;
                        tmp.val_type = KIND_INT;
                        if ( lval->ltype->size != -1 ) {
                            size = lval->ltype->size / lval->ltype->len;
                        } else {
                            size = lval->ltype->ptr->size;
                        }
                        mult_const(&tmp,size);
                    } else {
                        scale(ptr->type, lval->ltype->tag);
                    }
                    /* If near, then pop other side back, otherwise
                       load high reg with de and do an add  */
                    if (lval->ltype->kind == KIND_CPTR) {
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
                Type *return_type = type_void;
                int   flags = 0;
                if ( ispointer(lval->ltype) ) {
                     if (k && lval->const_val == 0)
                        rvalue(lval);
                    // Functino pointer call
                    callfunction(NULL,lval->ltype);
                    return_type = lval->ltype->ptr->return_type;
                    if ( return_type == NULL ) {
                        return_type = lval->ltype->ptr;
                    }
                    flags = lval->ltype->ptr->flags;
                } else if ( lval->ltype->kind == KIND_FUNC ) {
                    // Normal function call
                    callfunction(ptr,NULL);
                    return_type = lval->ltype->return_type;      
                    flags = lval->ltype->flags;                    
                } else {
                    // No idea what you are doing, calling a non pointer
                    errorfmt("Calling a non-pointer function?",1);
                }
                if ( return_type->kind == KIND_CHAR && flags & SDCCDECL) {
                    // We just called an SDCC function, we need to extend out to 16 bits, these names are wrong, but
                    // they do the right thing
                    if ( return_type->isunsigned ) {
                        convUint2char();
                    } else {
                        convSint2char();
                    }
                }
                lval->flags &= ~(CALLEE|FASTCALL|SMALLC);
                k = lval->is_const = lval->const_val = 0;
                lval->ltype = return_type;
                lval->ptr_type = KIND_NONE;
                lval->val_type = lval->ltype->kind;
                lval->symbol = NULL;
                // Function returing pointer
                if ( lval->ltype->kind == KIND_PTR || lval->ltype->kind == KIND_CPTR ) {
                    lval->val_type = lval->ltype->kind;
                    lval->indirect_kind = lval->ltype->kind;
                }
            }
            /* Handle structures... come in here with lval holding tehe previous
             * pointer to the struct thing..*/
            else if ((direct = cmatch('.')) || match("->")) {
                Type *str = lval->ltype;
                Type *member_type;

                // If there's a cast active, then use the cast type
                if ( lval->cast_type ) {
                    str = lval->cast_type;
                }

                if ( str->kind == KIND_PTR || str->kind == KIND_CPTR) {
                    str = str->ptr->tag;
                } else {
                    str = str->tag;
                }
            

                if (str == NULL ) {
                    errorfmt("Non struct type can't take member", 1);
                    junk();
                    return 0;
                }
                if (symname(sname) == 0 || (member_type = find_tag_field(str, sname)) == NULL) {
                    errorfmt("Unknown member: '%s' of struct '%s'", 1, sname, str->name);
                    junk();
                    return 0;
                }
                /*
                 * Here, we're trying to chase our member up, we have to be careful
                 * not to access via far methods near data..
                 */
                if (k && direct == 0)
                    rvaluest(lval);

                debug(DBG_FAR1, "prev=%s name=%s flags %d oflags %d", lval->symbol->name, ptr->name, lval->flags, lval->oflags);
                flags = member_type->flags;
                if (direct == 0) {
                    if ( lval->ltype->kind == KIND_CPTR ) {
                        flags |= FARACC;
                    }
                }
                lval->flags = flags;

                zadd_const(lval, member_type->offset);
//                lval->symbol = ptr; // 201710108: Remove this
                lval->symbol = NULL;
                lval->ltype = member_type;
                lval->indirect_kind = lval->val_type = member_type->kind;
                lval->ptr_type = lval->is_const = lval->const_val = 0;
                lval->stage_add = NULL;
                lval->binop = NULL;
                if (ispointer(lval->ltype) || lval->ltype->kind == KIND_ARRAY) {
                    lval->ptr_type = lval->ltype->ptr->kind;
                    /* djm */
                    // TODO
                  //  if (ptr->flags & FARPTR) {
                       // lval->indirect_kind = KIND_INT;
                       // lval->val_type = KIND_INT;
                    // } else {
                    //     lval->indirect_kind = KIND_INT;
                    //     lval->val_type = KIND_INT;
                    // }
                }
                if (lval->ltype->kind == KIND_ARRAY || lval->ltype->kind == KIND_STRUCT ) {
                   // lval->indirect_kind = lval->ltype->ptr->kind;
                    /* array or struct */
                    // TODO
                 //   lval->ptr_type = ptr->type;
                    /* djm Long pointers here? */
                 //   lval->ptr_type = lval->ltype->kind;
                 //   lval->val_type = KIND_PTR;
                    //lval->val_type = ((ptr->flags & FARPTR) ? KIND_CPTR : KIND_INT);
                    k = 0;
                } else
                    k = 1;
            } else
                return k;
        }
    if (ptr && ptr->ctype->kind == KIND_FUNC) {
        address(ptr);
        lval->symbol = NULL;  // TODO: Can we actually set it correctly here? - Needed for verification of func ptr arguments
        lval->ltype = ptr->ctype;
        lval->flags = ptr->flags;
        return 0;
    }
    return k;
}
