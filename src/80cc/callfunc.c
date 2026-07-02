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


/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

Node *callfunction(SYMBOL *ptr, Type *fnptr_type)
{
    int isscanf = 0;
    int vconst, argnumber;
    zdouble val;
    int watcharg = 0;       /* For watching printf etc */
    int minifunc = 0;       /* Call cut down version */
    int   function_pointer_call = ptr == NULL ? YES : NO;
    char   *funcname = "(unknown)";
    Type   *functype = ptr ? ptr->ctype: fnptr_type->ptr;
    array  *function_args = array_init(NULL);
    Node   *node;

    if ( functype->kind != KIND_FUNC ) {
        warningfmt("incompatible-pointer-types","Calling via non-function pointer");
        functype = default_function_with_type("(funcpointer)", functype);
    }

    argnumber = 0;
    (void)minifunc; /* set by SetMiniFunc but its return value is unused
                       in AST-codegen mode; the side-effect on
                       printf_format_option / scanf_format_option is
                       what matters. */
    blanks(); /* already saw open paren */

    if (ptr && (strcmp(ptr->name, "asm") == 0 || strcmp(ptr->name,"__asm__") == 0) ) {
        /* We're calling asm("code") */
        return doasmfunc(NO);
    }

    if (ptr ) {
        funcname = ptr->name;
        watcharg = SetWatch(funcname, &isscanf);
    }
    /* Phase L3c-8g: tokeniser kind check — TK_RPAREN is its own
       distinct kind so the loop exits cleanly when the arg list
       is done. */
    while (tk_peek_kind_at_lptr() != TK_RPAREN) {
        Type *type;
        struct nodepair *pair;

        if (endst()) {
            break;
        }
        argnumber++;

        pair = expression(&vconst, &val, &type);
        array_add(function_args, pair->node);

        /* printf/scanf format-string watcher. SetWatch in the prologue
           sets `watcharg` to the format-string arg index for known
           variadic library calls; SetMiniFunc inspects the format
           string at `litq + val + 1` and ORs detected conversion
           specifiers into printf_format_option / scanf_format_option
           which main.c emits as `defc CRT_printf_format` etc. to
           drive the link-time printf/scanf variant selection. */
        if (argnumber == watcharg) {
            uint32_t format_option = 0;
            if (ptr)
                debug(DBG_ARG1, "Caughtarg!! %s", litq + (int)val + 1);
            minifunc = SetMiniFunc(litq + (int)val + 1, &format_option);
            if (isscanf) {
                scanf_format_option |= format_option;
            } else {
                printf_format_option |= format_option;
            }
        }

        if (cmatch(',') == 0)
            break;
    }
    needchar(')');
    reset_namespace();

    /* Arg-count validation (skipped for K&R-style oldstyle decls and
       relaxed for variadic prototypes). */
    if ( functype->funcattrs.oldstyle == 0
         && functype->funcattrs.hasva == 0
         && array_len(functype->parameters) < argnumber ) {
        errorfmt("Too many arguments to call to function '%s'", 1, functype->name);
    }
    if ( functype->funcattrs.oldstyle == 0
         && array_len(functype->parameters) > argnumber ) {
        if ( !(functype->funcattrs.hasva
               && argnumber == array_len(functype->parameters) - 1) )
            errorfmt("Too few arguments to call to function '%s'", 1, functype->name);
    }

    node = ast_function_call(function_pointer_call ? AST_FUNCPTR_CALL : AST_FUNC_CALL, ptr, functype, function_args);

    /* Arg evaluation and the call itself are emitted by the walker
       (cg2_func_call). The legacy tmpfile-replay path below is gone —
       args live on the AST_FUNC_CALL node and the walker reads them
       directly. */
    return node;
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
    { 'S', 3, 0x2000200, 0x00 },
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
