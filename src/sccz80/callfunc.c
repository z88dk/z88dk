/*
 *      Small C+ Compiler
 *
 *      Perform a function call
 *
 *      $Id: callfunc.c,v 1.20 2016-07-08 06:57:04 dom Exp $
 */

#include "ccdefs.h"

/*
 * Local functions
 */

static int SetWatch(char* sym, int* isscanf);
static int SetMiniFunc(unsigned char* arg, uint32_t* format_option_ptr);
static int ForceArgs(char dest, char src, int expr, char functab);

/*
 *      External variables used
 */

extern int smartprintf;


/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

void callfunction(SYMBOL* ptr)
{
    int isscanf = 0;
    uint32_t format_option;
    int nargs, vconst, val, expr, argnumber;
    int watcharg; /* For watching printf etc */
    int minifunc = 0; /* Call cut down version */
    unsigned char protoarg;
    char preserve = NO; /* Preserve af when cleaningup */
    FILE *tmpfiles[100];  // 100 arguments enough I guess */
    FILE *save_fps;
    int   i;
    int   save_fps_num;
   
    memset(tmpfiles, 0, sizeof(tmpfiles)); 
    nargs = 0;
    argnumber = 0;
    watcharg = minifunc = 0;
    blanks(); /* already saw open paren */

    if (ptr && (strcmp(ptr->name, "asm") == 0)) {
        /* We're calling asm("code") */
        doasmfunc(NO);
        return;
    }

    if (ptr && smartprintf)
        watcharg = SetWatch(ptr->name, &isscanf);

    while (ch() != ')') {
        char *before, *start;
        if (endst()) {
            break;
        }
        argnumber++;
        tmpfiles[argnumber] = tmpfile();
        push_buffer_fp(tmpfiles[argnumber]);

        setstage(&before, &start);
        expr = expression(&vconst, &val);
        clearstage(before, start);  // Wipe out everything we did
        fprintf(tmpfiles[argnumber],";\n");
        pop_buffer_fp();

        if (cmatch(',') == 0)
            break;
    }
    needchar(')'); 

    if ( use_r2l_calling_convention == YES || ( ptr && (ptr->flags & SMALLC) == 0) ) {
        for ( i = 1; argnumber >= i ; argnumber--, i++) {
            FILE *tmp = tmpfiles[i];
            tmpfiles[i] = tmpfiles[argnumber];
            tmpfiles[argnumber] = tmp;
        }
    }
    argnumber = 0;

    /* Don't rewrite expressions whilst we are evaluating */
    save_fps_num = buffer_fps_num;
    save_fps = MALLOC(buffer_fps_num * sizeof(buffer_fps[0]));
    memcpy(save_fps, buffer_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = 0;
    while ( tmpfiles[argnumber+1] ) {
        argnumber++;
        rewind(tmpfiles[argnumber]);
        set_temporary_input(tmpfiles[argnumber]);
        if (ptr) {
            /* ordinary call */
            expr = expression(&vconst, &val);
            if (expr == CARRY) {
                zcarryconv();
                expr = CINT;
            }
            if (ptr->prototyped && (ptr->prototyped >= argnumber)) {
                protoarg = ptr->args[ptr->prototyped - argnumber + 1];
                if ((protoarg != PELLIPSES) && ((protoarg != fnargvalue) || ((protoarg & 7) == STRUCT)))
                    expr = ForceArgs(protoarg, fnargvalue, expr, ptr->tagarg[ptr->prototyped - argnumber + 1]);
            }
            if ((ptr->flags & REGCALL) && ptr->prototyped == 1) {
                /* fastcall of single expression */

            } else {
                if (argnumber == watcharg) {
                    if (ptr)
                        debug(DBG_ARG1, "Caughtarg!! %s", litq + val + 1);
                    minifunc = SetMiniFunc(litq + val + 1, &format_option);
                }
                if (expr == DOUBLE) {
                    dpush();
                    nargs += 6;
                }
                /* Longs and (ahem) long pointers! */
                else if (expr == LONG || expr == CPTR) {
                    if (!(fnflags & FARPTR) && expr != LONG)
                        const2(0);
                    lpush();

                    nargs += 4;
                } else {
                    zpush();
                    nargs += 2;
                }
            }
        } else { /* call to address in HL */
            zpush(); /* Push address */
            expr = expression(&vconst, &val);
            if (expr == CARRY) {
                zcarryconv();
                expr = CINT;
            }
            if (expr == LONG || expr == CPTR) {
                swap(); /* MSW -> hl */
                swapstk(); /* MSW -> stack, addr -> hl */
                zpushde(); /* LSW -> stack, addr = hl */
                nargs += 4;
            } else if (expr == DOUBLE) {
                dpush2();
                nargs += 6;
                mainpop();
            } else {
                /* If we've only got one 2 byte argment, don't swap the stack */
                if ( tmpfiles[argnumber+1] != NULL  || nargs != 0) {
                    swapstk();
                }
                nargs += 2;
            }
        }
        restore_input();
        fclose(tmpfiles[argnumber]);
    }
    memcpy(buffer_fps, save_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = save_fps_num ;
    FREENULL(save_fps);

    if (ptr)
        debug(DBG_ARG2, "arg %d proto %d", argnumber, ptr->args[1]);

    if (ptr && (ptr->prototyped != 0)) {
        if ((ptr->prototyped > argnumber) && (ptr->args[1] != PVOID) && (ptr->args[1] != PELLIPSES)) {
            warning(W_2FAFUNC);
        } else if ((ptr->prototyped < argnumber) && (ptr->args[1] != PELLIPSES)) {
            warning(W_2MAFUNC);
        }
    }

    if (ptr) {
        /* Check to see if we have a variable number of arguments */
        if ((ptr->prototyped) && ptr->args[1] == PELLIPSES) {
            if ( ptr && (ptr->flags & SMALLC) == SMALLC ) {
                loadargc(nargs);
            }
        }
        if ( strcmp(ptr->name,"__builtin_strcmp") == 0) {
            gen_builtin_strcmp();
        } else if (watcharg || (ptr->flags & SHARED) || (ptr->flags & SHAREDC)) {
            if ((ptr->flags & SHARED) || (ptr->flags & SHAREDC))
                preserve = YES;
            if (ptr->flags & SHAREDC)
                zclibcallop();
            else
                zcallop();
            if (isscanf) {
                scanf_format_option |= format_option;
                if (minifunc > scanf_level)
                    scanf_level = minifunc;
            } else {
                printf_format_option |= format_option;
                if (minifunc > printflevel)
                    printflevel = minifunc;
            }
            outname(ptr->name, dopref(ptr));
            if ((ptr->flags & SHARED) && c_useshared)
                outstr("_sl");
            else if (ptr->flags & SHAREDC)
                outstr("_rst");
            nl();
        } else
            zcall(ptr);
    } else {
        callstk(nargs);
    }
    /*
     *	Modify the stack after a function call
     *
     *	We should modify stack if:
     *	- __CALLEE__ isn't set
     *	- Function is __LIB__ even if c_compact_code is set
     *	- c_compact_code isn't set and __CALLEE__ isn't set
     */

    if ((ptr && ptr->flags & CALLEE) || (c_compact_code && ptr == NULL) || (c_compact_code && ((ptr->flags & LIBRARY) == 0))) {
        Zsp += nargs;
    } else {
        /* If we have a frame pointer then ix holds it */
#ifdef USEFRAME
        if (c_useframepointer) {
            if (nargs)
                RestoreSP(preserve);
            Zsp += nargs;
        } else
#endif
            Zsp = modstk(Zsp + nargs, ptr ? (ptr->type != DOUBLE) : YES, preserve); /* clean up arguments - we know what type is MOOK */
    }
}

static int SetWatch(char* sym, int* type)
{
    *type = 0; // printf
    if (strcmp(sym, "printf") == 0)
        return 1;
    if (strcmp(sym, "printk") == 0)
        return 1;
    if (strcmp(sym, "fprintf") == 0)
        return 2;
    if (strcmp(sym, "sprintf") == 0)
        return 2;
    if (strcmp(sym, "vprintf") == 0)
        return 1;
    if (strcmp(sym, "vfprintf") == 0)
        return 2;
    if (strcmp(sym, "vsprintf") == 0)
        return 2;
    if (strcmp(sym, "snprintf") == 0)
        return 3;
    if (strcmp(sym, "vsnprintf") == 0)
        return 3;
    *type = 1; // scanf
    if (strcmp(sym, "scanf") == 0)
        return 1;
    if (strcmp(sym, "vscanf") == 0)
        return 1;
    if (strcmp(sym, "fscanf") == 0)
        return 2;
    if (strcmp(sym, "vfscanf") == 0)
        return 2;
    if (strcmp(sym, "sscanf") == 0)
        return 2;
    if (strcmp(sym, "vsscanf") == 0)
        return 2;
    return 0;
}

/*
 *      djm routine to force arguments to switch type
 */

static int ForceArgs(char dest, char src, int expr, char functab)
{
    char did, dtype, disfar, dissign;
    char sid, stype, sisfar, sissign;
    char buffer[80];

    dtype = dest & 7; /* Lower 3 bits */
    did = (dest & 56) / 8; /* Middle 3 bits */
    disfar = (dest & 128);
    dissign = (dest & 64);

    stype = src & 7; /* Lower 3 bits */
    sid = (src & 56) / 8; /* Middle 3 bits */
    sisfar = (src & 128);
    sissign = (src & 64);


    if (did == VARIABLE) {
        if (sid == VARIABLE) {
            force(dtype, stype, dissign, sissign, 0);
        } else {
            /* Converting pointer to integer/long */
            warning(W_PTRINT);
            /* Pointer is always unsigned */
            force(dtype, ((sisfar) ? CPTR : CINT), dissign, 0, 0);
        }
        if (dtype == CCHAR)
            expr = CINT;
        else
            expr = dtype;

    } else {
        /* Dealing with pointers.. a type mismatch!*/
        if (((dtype != stype) && (dtype != VOID) && (stype != VOID) && (stype != CPTR)) || ((dtype == stype) && (margtag != functab))) {
            debug(DBG_ARG3, "dtype=%d stype=%d margtab=%d functag=%d", dtype, stype, margtag, functab);
            warning(W_PRELIM, currfn->name, lineno - fnstart);
            warning(W_PTRTYP);
            ExpandArgValue(dest, buffer, functab);
            warning(W_PTRTYP1, buffer);
            ExpandArgValue(src, buffer, margtag);
            warning(W_PTRTYP2, buffer);
        } else if (dtype == stype && did != sid) {
            warning(W_INTPTR);
            expr = CINT;
        }

        if (disfar) {
            if (disfar != sisfar) {
                /* Widening a pointer - next line unneeded - done elsewhere*/
                /*                                const2(0); */
                expr = CPTR;
            }
        } else {
            /* destintation is near pointer */
            if (disfar != sisfar) {
                warning(W_PRELIM, currfn->name, lineno - fnstart);
                warning(W_FARNR);
                expr = CINT;
            }
        }
    }
    return (expr);
}

struct printf_format_s {
    char fmt;
    char complex;
    uint32_t val;
    uint32_t lval;
} printf_formats[] = {
    { 'd', 1, 0x01, 0x1000 },
    { 'u', 1, 0x02, 0x2000 },
    { 'x', 2, 0x04, 0x4000 },
    { 'X', 2, 0x08, 0x8000 },
    { 'o', 2, 0x10, 0x10000 },
    { 'n', 2, 0x20, 0x20000 },
    { 'i', 2, 0x40, 0x40000 },
    { 'p', 2, 0x80, 0x80000 },
    { 'B', 2, 0x100, 0x100000 },
    { 's', 1, 0x200, 0x0 },
    { 'c', 1, 0x400, 0x0 },
    { 'a', 0, 0x400000, 0x0 },
    { 'A', 0, 0x800000, 0x0 },
    { 'e', 3, 0x1000000, 0x1000000 },
    { 'E', 3, 0x2000000, 0x2000000 },
    { 'f', 3, 0x4000000, 0x4000000 },
    { 'F', 3, 0x8000000, 0x8000000 },
    { 'g', 3, 0x10000000, 0x10000000 },
    { 'G', 3, 0x20000000, 0x20000000 },
    { 0, 0, 0, 0 }
};

static int SetMiniFunc(unsigned char* arg, uint32_t* format_option_ptr)
{
    char c;
    int complex, islong;
    uint32_t format_option = 0;
    struct printf_format_s* fmt;

    complex = 1; /* mini printf */
    while ((c = *arg++)) {
        if (c != '%')
            continue;

        if (*arg == '-' || *arg == '0' || *arg == '+' || *arg == ' ' || *arg == '*' || *arg == '.') {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (!isalpha(*arg))
                arg++;
        } else if (isdigit(*arg)) {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (isdigit(*arg) || *arg == '.') {
                arg++;
            }
        }

        islong = 0;
        if (*arg == 'l') {
            if (complex < 2)
                complex = 2;
            arg++;
            islong = 1;
        }
        fmt = &printf_formats[0];
        while (fmt->fmt) {
            if (fmt->fmt == *arg) {
                if (complex < fmt->complex)
                    complex = fmt->complex;
                format_option |= islong ? fmt->lval : fmt->val;
                break;
            }
            fmt++;
        }
    }
    *format_option_ptr = format_option;
    return (complex);
}
