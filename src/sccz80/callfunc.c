/*
 *      Small C+ Compiler
 *
 *      Perform a function call
 *
 *      $Id: callfunc.c,v 1.20 2016-07-08 06:57:04 dom Exp $
 */

#include "ccdefs.h"

#ifdef WIN32
#include <process.h>
#endif

/*
 * Local functions
 */

static int SetWatch(char* sym, int* isscanf);
static int SetMiniFunc(unsigned char* arg, uint32_t* format_option_ptr);
static Kind ForceArgs(Type *dest, Type *src, int isconst);


/* msys2 tmpfile() is broken:
   it creates the temporary file in the root directory of C:\ 
   and therefore needs elevated privileges.
   It returns NULL and sets errno to EACCES when run 
   with normal privileges.
   This causes the sccz80 compiler to generate wrong code.
*/
#ifdef _WIN32
#  include <time.h>
#  define my_tmpfile    w32_tmpfile
#else
#  define my_tmpfile    tmpfile
#endif
 
#ifdef _WIN32

static char **tmpfiles = NULL;
static int    tmpfiles_num = 0;


static void cleanup_tmpfiles(void) {
    int  i;

    for ( i = 0; i < tmpfiles_num; i++ ) {
        unlink(tmpfiles[i]);
        free(tmpfiles[i]);
    }
}

static FILE* w32_tmpfile()
{
    static char tmpnambuf[FILENAME_MAX+1];
    static int  inited = 0;
    char        *tmpnam;
    FILE        *fp;
    
    if (!inited) {
        /* Randomize temporary filenames for windows */
        snprintf(tmpnambuf, sizeof(tmpnambuf), 
                 "sccz80%08X%04X",_getpid(), ((unsigned int)time(NULL)) & 0xffff);
        inited = 1;
        atexit(cleanup_tmpfiles);
    }

    if ((tmpnam = _tempnam(".\\", tmpnambuf)) == NULL) {
        fprintf(stderr, "Failed to create temporary filename\n");
        exit(1);
    }

    tmpfiles = REALLOC(tmpfiles, (tmpfiles_num+1) * sizeof(tmpfiles[0]));
    tmpfiles[tmpfiles_num++] = strdup(tmpnam);

    if ((fp = fopen(tmpnam, "w+")) == NULL) {
        perror(tmpnam);
        exit(1);
    }
    
    return fp;
}


#endif
   
/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

void callfunction(SYMBOL *ptr, Type *fnptr_type)
{
    int isscanf = 0;
    uint32_t format_option = 0;
    int nargs, vconst, expr, argnumber;
    zdouble val;
    int watcharg; /* For watching printf etc */
    int minifunc = 0; /* Call cut down version */
    char preserve = NO; /* Preserve af when cleaningup */
    int   isconstarg[5];
    zdouble constargval[5];
    FILE *tmpfiles[100];  // 100 arguments enough I guess */
    int   tmplinenos[100];
    FILE *save_fps;
    int   i;
    int   save_fps_num;
    int   function_pointer_call = ptr == NULL ? YES : NO;
    int   savesp;
    int   last_argument_size = 0;
    int   saveline;
    enum symbol_flags builtin_flags = 0;
    char   *funcname = "(unknown)";
    Type   *functype = ptr ? ptr->ctype: fnptr_type->ptr;
    
    if ( functype->kind != KIND_FUNC ) {
        warningfmt("incompatible-pointer-types","Calling via non-function pointer");
        functype = default_function_with_type("(funcpointer)", functype);
    }   

    memset(tmpfiles, 0, sizeof(tmpfiles)); 
    nargs = 0;
    argnumber = 0;
    watcharg = minifunc = 0;
    blanks(); /* already saw open paren */

    if (ptr && (strcmp(ptr->name, "asm") == 0 || strcmp(ptr->name,"__asm__") == 0) ) {
        /* We're calling asm("code") */
        doasmfunc(NO);
        return;
    }

    if (ptr ) {
        funcname = ptr->name;
        watcharg = SetWatch(funcname, &isscanf);
    }
    savesp = Zsp;
    while (ch() != ')') {
        char *before, *start;
        Type *type;
        if (endst()) {
            break;
        }
        argnumber++;
        tmpfiles[argnumber] = my_tmpfile();
        tmplinenos[argnumber] = lineno;
        push_buffer_fp(tmpfiles[argnumber]);

        setstage(&before, &start);
        expr = expression(&vconst, &val, &type);
        if ( argnumber < 5 ) {
            isconstarg[argnumber] = vconst;
            constargval[argnumber] = val;
        }
        clearstage(before, start);  // Wipe out everything we did
        fprintf(tmpfiles[argnumber],";\n");
        pop_buffer_fp();

        if (cmatch(',') == 0)
            break;
    }
    needchar(')'); 
    Zsp = savesp;
    saveline = lineno;
    reset_namespace();

    //  if ( ptr == NULL ) ptr = fnptr;
    if ( functype->funcattrs.oldstyle == 0 && functype->funcattrs.hasva == 0 && array_len(functype->parameters) < argnumber  ) {
        errorfmt("Too many arguments to call to function '%s'", 1, functype->name);
    }

    if ( functype->funcattrs.oldstyle == 0 && array_len(functype->parameters) > argnumber ) {
        if ( !(functype->funcattrs.hasva && argnumber == array_len(functype->parameters) -1) ) 
            errorfmt("Too few arguments to call to function '%s'", 1, functype->name);
    }

    if ( ptr != NULL ) {
        /* Check for some builtins */
        if ( strcmp(funcname, "__builtin_memset") == 0 ) {
            if ( argnumber == 3 && isconstarg[3] && constargval[3] > 0 && c_disable_builtins == 0  ) {
                /* We want at least the size to be constant */
                fclose(tmpfiles[3]);
                tmpfiles[3] = NULL;
                builtin_flags = SMALLC|FASTCALL;
                if ( isconstarg[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "memset";
            }
        } else if ( strcmp(funcname, "__builtin_memcpy") == 0 ) {
            if ( argnumber == 3 && isconstarg[3] && constargval[3] > 0  && c_disable_builtins == 0) {
                /* We want at least the size to be constant */
                fclose(tmpfiles[3]);
                tmpfiles[3] = NULL;
                builtin_flags = SMALLC|FASTCALL;    
                if ( isconstarg[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "memcpy";
            }  
        } else if ( strcmp(funcname, "__builtin_strcpy") == 0) {
            if ( argnumber == 2  && c_disable_builtins == 0 ) {
                builtin_flags = FASTCALL|SMALLC;
            } else {
                funcname = "strcpy";
            }
        } else if ( strcmp(funcname, "__builtin_strchr") == 0) {
            if ( argnumber == 2  && c_disable_builtins == 0) {
                builtin_flags = SMALLC|FASTCALL;
                if ( isconstarg[2] && constargval[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "strchr";
            }

        }
    }

    if ( ( (ptr == NULL && c_use_r2l_calling_convention == YES ) || (ptr && (functype->flags & SMALLC) == 0) ) && (builtin_flags & SMALLC) == 0)  {
        for ( i = 1; argnumber >= i ; argnumber--, i++) {
            FILE *tmp = tmpfiles[i];
            int   tmpi;
            tmpfiles[i] = tmpfiles[argnumber];
            tmpfiles[argnumber] = tmp;
            tmpi = tmplinenos[i];
            tmplinenos[i] = tmplinenos[argnumber];
            tmplinenos[argnumber] = tmpi;
        }
    }
    argnumber = 0;

    /* Don't rewrite expressions whilst we are evaluating */
    save_fps_num = buffer_fps_num;
    save_fps = MALLOC(buffer_fps_num * sizeof(buffer_fps[0]));
    memcpy(save_fps, buffer_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = 0;
    while ( tmpfiles[argnumber+1] ) {
        Type *type;        
        char *before, *start;

        argnumber++;
        rewind(tmpfiles[argnumber]);
        set_temporary_input(tmpfiles[argnumber]);
        lineno = tmplinenos[argnumber];
        if ( function_pointer_call ) {
            if ( fnptr_type->kind == KIND_CPTR ) {
                if ( argnumber == 1 )  {
                    lpush();
                }
            } else {
                zpush(); // Save function address
            }
        }
        /* ordinary call */
        setstage(&before, &start);
        expr = expression(&vconst, &val, &type);
        if (expr == KIND_CARRY) {
            gen_conv_carry2int();
            expr = KIND_INT;
            type = type_int;
        }
        if ( functype->funcattrs.oldstyle == 0 && argnumber <= array_len(functype->parameters)) {       
            int proto_argnumber;
            Type *prototype;
            if ( (functype->flags & SMALLC) == SMALLC)  {
                proto_argnumber = argnumber - 1;                
            } else {
                proto_argnumber = (int)array_len(functype->parameters) - argnumber;
            }
            prototype = array_get_byindex(functype->parameters, proto_argnumber);

            if ( prototype->kind != KIND_ELLIPSES && type->kind != prototype->kind ) {
                if ( vconst && (kind_is_decimal(prototype->kind) || kind_is_integer(prototype->kind))) {                 
                     LVALUE lval = {0};
                     clearstage(before,start);
                     start = NULL;
                     lval.val_type = prototype->kind;
                     lval.const_val = val;
                     load_constant(&lval);
                     expr = prototype->kind;
                } else {
                    expr = ForceArgs(prototype, type, vconst);
                }
            } else if ( prototype->kind != KIND_ELLIPSES && ispointer(prototype)) {
                if ( type_matches_pointer(prototype, type) == 0 ) {
                    UT_string *str;
                    
                    utstring_new(str);
                    utstring_printf(str,"Converting type: ");
                    type_describe(type,str);
                    utstring_printf(str," to ");
                    type_describe(prototype, str);
                    warningfmt("incompatible-pointer-types","%s", utstring_body(str));
                    utstring_free(str);
                }
            }
            // if ( (protoarg & ( SMALLC << 16)) !=  (packedArgumentType & (SMALLC << 16)) ) {
            //     warning(W_PARAM_CALLINGCONVENTION_MISMATCH, funcname, argnumber, "__smallc/__stdc");
            // }
            // if ( (protoarg & ( CALLEE << 16)) !=  (packedArgumentType & (CALLEE << 16)) ) {
            //     warning(W_PARAM_CALLINGCONVENTION_MISMATCH, funcname, argnumber, "__z88dk_callee");
            // }
        }
        //clearstage(before,start);
        if ( function_pointer_call == 0 && tmpfiles[argnumber+1] == NULL &&
            ( (functype->flags & FASTCALL) == FASTCALL || (builtin_flags & FASTCALL) == FASTCALL ) ) {
            /* fastcall of single expression OR the last argument of a builtin */
        } else {
            if (argnumber == watcharg) {
                if (ptr)
                    debug(DBG_ARG1, "Caughtarg!! %s", litq + (int)val + 1);
                minifunc = SetMiniFunc(litq + (int)val + 1, &format_option);
                if (isscanf) {
                    scanf_format_option |= format_option;
                } else {
                    printf_format_option |= format_option;
                }
            }
            if ( function_pointer_call == 0 ||  fnptr_type->kind == KIND_CPTR ) {
                nargs += gen_push_function_argument(expr, type,  functype->flags & SDCCDECL && argnumber <= array_len(functype->parameters));
            } else {
                last_argument_size = push_function_argument_fnptr(expr, type, functype, functype->flags & SDCCDECL && argnumber <= array_len(functype->parameters), tmpfiles[argnumber+1] == NULL);
                nargs += last_argument_size;
            }
        }
        restore_input();
        fclose(tmpfiles[argnumber]);
    }
    memcpy(buffer_fps, save_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = save_fps_num ;
    FREENULL(save_fps);
    lineno = saveline;


    if (function_pointer_call == NO ) {
        int va_arg_count = -1;
        /* Check to see if we have a variable number of arguments */
        if ( functype->funcattrs.hasva ) {
            if ( (functype->flags & SMALLC) == SMALLC ) {
                va_arg_count = nargs;
            }
        }
        if ( strcmp(funcname,"__builtin_strcpy") == 0 && !IS_808x() ) {
            gen_builtin_strcpy();
            nargs = 0;
            Zsp += 2;
        } else if ( strcmp(funcname,"__builtin_strchr") == 0 && !IS_808x() ) {
            gen_builtin_strchr(isconstarg[2] ? constargval[2] : -1);
            nargs = 0;
        } else if ( strcmp(funcname, "__builtin_memset") == 0 && !IS_808x() ) {
            gen_builtin_memset(isconstarg[2] ? constargval[2] : -1,  constargval[3]);
            nargs = 0;
        } else if ( strcmp(funcname, "__builtin_memcpy") == 0 && !IS_808x() ) {
            gen_builtin_memcpy(isconstarg[2] ? constargval[2] : -1,  constargval[3]);
            nargs = 0;
        } else if ( functype->flags & SHORTCALL ) {
            gen_shortcall(functype, functype->funcattrs.shortcall_rst, functype->funcattrs.shortcall_value);
        } else if ( functype->flags & HL_CALL ) {
            gen_hl_call(functype, functype->funcattrs.hlcall_module, functype->funcattrs.hlcall_addr);
        } else if ( functype->flags & BANKED ) {
            gen_bankedcall(ptr, functype);
        } else {
            gen_call(va_arg_count, funcname, ptr);
        }
    } else {
        nargs += callstk(functype, nargs, fnptr_type->kind == KIND_CPTR, last_argument_size);
    }
    if ( functype->return_type->kind == KIND_LONGLONG) {
        nargs += 2;
    }
    if (functype->flags & CALLEE ) {
        Zsp += nargs;
        // IF we called a far pointer and we had arguments, pop the address off the stack
        if ( function_pointer_call && fnptr_type->kind == KIND_CPTR && nargs ) {
            Zsp = modstk(Zsp + 4, functype->return_type->kind != KIND_DOUBLE || c_fp_size == 4, preserve,YES); 
        }
    } else {
        /* If we have a frame pointer then ix holds it */
        if ( function_pointer_call && fnptr_type->kind == KIND_CPTR && nargs ) {
            nargs += 4;
        }
        Zsp = gen_restore_frame_after_call(nargs,functype->return_type->kind != KIND_DOUBLE || c_fp_size < 6, preserve, YES);  /* clean up arguments - we know what type is MOOK */
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

static Kind ForceArgs(Type *dest, Type *src, int isconst)
{
    // TODO: ARRAYS
    if ( !ispointer(dest) ) {
        if ( !ispointer(src) ) {
            // Variable to variable cast
            if ( src->kind == KIND_LONG && dest->kind != KIND_LONG && dest->kind != KIND_DOUBLE) {
                UT_string *str;
                
                utstring_new(str);
                utstring_printf(str,"Loss of precision, converting ");
                type_describe(src,str);
                utstring_printf(str," to ");
                type_describe(dest, str);
                warningfmt("conversion","%s", utstring_body(str));
                utstring_free(str);
            }
            force( dest->kind, src->kind, dest->isunsigned, src->isunsigned, isconst);
        } else {
            /* Converting pointer to integer */
            warningfmt("int-conversion","Converting pointer to integer without cast");
            force( dest->kind, src->kind == KIND_PTR ? KIND_INT : KIND_LONG, dest->isunsigned, 1, isconst);
        }
    } else  if ( !ispointer(src) ) {
        // Converting int/long to pointer
        //warningfmt("unknown","Converting int/long to pointer");
        if ( dest->kind == KIND_CPTR && src->kind != KIND_LONG) {
            const2(0);            
        }
    } else {
        // Pointer to pointer
        if ( src->kind == KIND_PTR && dest->kind == KIND_CPTR ) {
            
            const2(0);
        } else {
            // Pointer to pointer
            if ( dest->kind == KIND_PTR && src->kind == KIND_CPTR ) {
                warningfmt("incompatible-pointer-types","Narrowing pointer from far to near");
            } else if ( type_matches_pointer(dest, src) == 0 ) {
                UT_string *str;
                
                utstring_new(str);
                utstring_printf(str,"Converting type: ");
                type_describe(src,str);
                utstring_printf(str," to ");
                type_describe(dest, str);
                warningfmt("incompatible-pointer-types","%s", utstring_body(str));
                utstring_free(str);
            }
        }
    }         
    return dest->kind;
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
    { '[', 0, 0x200000, 0x0 },
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
        } else if ( *arg == 'h' ) {
            arg++;
            if ( *arg == 'h' ) arg++;
        } else if ( *arg == 'z' ) {
            arg++; 
        }
        fmt = &printf_formats[0];
        while (fmt->fmt) {
            if (fmt->fmt == *arg) {
                if (complex < fmt->complex)
                    complex = fmt->complex;
                format_option |= islong ? fmt->lval : fmt->val;
                if ( *arg == '[') {
                    while (*arg && *arg != ']') arg++;
                }
                break;
            }
            fmt++;
        }
    }
    *format_option_ptr = format_option;
    return (complex);
}
