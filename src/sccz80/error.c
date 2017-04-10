/*
 *      Small C Compiler
 *
 *      Errors and other such misfitting routines
 *
 *      $Id: error.c,v 1.4 2004-03-26 22:06:09 denniz Exp $
 */

#include "ccdefs.h"
#include <stdarg.h>

/*
 * All those lovely error & warnig messages
 */

struct warnings mywarn[] = {

    /*
 * Warnings related to function prototyping 
 */
    { "", 0 },
    { "Too few arguments in function", 0 },
    { "Too many arguments in function call", 0 },
    { "Too many arguments in declaration", 0 },
    { "Function returns different type to prototype", 0 },
    { "Prototype is %s", 0 }, /* 5 */
    { "Function is %s", 0 },
    /* Very annoying warning! */
    { "Return type defaults to int", 1 },
    /*
 * Warnings that can be circumvented by casting
 */
    { "Converting integer to pointer without cast", 0 },
    { "Converting pointer to integer without cast", 0 },
    { "Equating of different signedness", 1 }, /* 10 */
    { "Operation on different signedness!", 1 },
    { "Converting far ptr to near ptr", 0 },
    { "Pointer/pointer type mismatch", 0 },
    /*
 * Well, who can't type then?
 */
    { "Expected ','", 0 },
    { "Expected '\"'", 0 }, /* 15 */
    { "Expected '\''", 0 },
    { "Expected ';'", 0 },
    { "Unterminated assembler code", 0 },
    { "Unknown #pragma directive", 0 },
    /*
 * Warnings that can pop up during declarations
 */
    { "Far only applicable to pointers", 0 }, /* 20 */
    { "Initialisation too long, truncating!", 0 },
    { "Bad variable declaration (void)", 0 },
    { "Static incompatible with register/auto", 0 },
    { "Cannot assign value to pointer", 0 },
    /*
 * Blatantly daft expression things
 */
    { "Illegal sizeof operation (on function)", 0 },  /* 25 */
    { "Expected argument", 0 },
    { "Int constant in double expression", 0 },  /* UNUSED */
    { "Getting value from void function", 1 },
    /*
 * I shall write the compiler better, well one day at least!
 */
    { "Compiler bug - code may not work properly", 1 },
    { "Fix soon hopefully! Next warning may be dubious!", 1 }, /* 30 */
    { "Bitfields not supported by compiler", 0 },
    /*
 * Some more just added on to the end..
 */
    { "Division by zero, result set to be zero", 0 },
    { "Call to function without prototype", 1 },
    { "Func expects: %s", 0 },
    { "Func gets: %s", 0 }, /* 35 */
    { "In function: %s() line %d", 0 },
    { "Typedef doesn't support pointer types (sorry!)", 1 },
    { "Converting long to double in generic math mode", 0 },
    { "Const type not supported by compiler", 0 },
    { "Volatile type not supported by compiler", 1 }, /* 40 */
    { "... must be preceded by named argument", 0 },
    { "Floating point not supported by printf yet!", 1 },
    { "Function arguments have sign mismatch", 0 },
    { "Auto by default in function definition", 0 },
    { "%s%s*[] type uninitialised has no storage", 0 }, /* 45 */
    { "Unreachable code follows", 0 },
    { "Unknown escape sequence \\%c", 0 },
    { "Internal thingummyjob please report!!! Please!", 0 },
    { "Hex escape sequence out of range ", 0 },
    { "Variable '%s' may be used before initialisation ", 0}, /* 50 */
    { "Function pointer '%s'' doesn't have the same %s status as the value it's being given", 0},
    { "Unexpected floating point encountered, taking int value", 0},
    { "Function pointer passed to function '%s' argument %d doesn't have the same %s status as the prototype", 0},
    { "Left shifting by more than the size of the object", 0},
};

struct errors {
    char* error;
    char fatal;
} myerrors[] = {
    /*
 * What happens when file operations screw up? Yup an error..
 */
    { "", 0 },
    { "Unexpected end of file", 1 },
    { "Can't open zcc_opt.def file", 1 },
    { "Can't nest include files", 1 },
    { "Can't open include file", 1 },
    { "Input line too long", 1 }, /* 5*/
    { "Output file error", 1 },

    /*
 * What type of program are you writing, you use too much memory!
 */
    { "Double literal space exhausted", 1 },
    { "Literal Queue Overflow", 1 },
    { "Staging buffer overflow", 1 },
    { "Macro table full", 1 }, /* 10 */
    { "Global symbol table overflow", 1 },
    { "Local symbol table overflow", 1 },
    { "Structure member table overflow", 1 },
    { "Structure symbol table overflow", 1 },
    /*
 * Hey boy, don't make yer program too complex
 */
    { "Indirection too deep", 1 }, /* 15 */
    { "Negative Size Illegal", 0 },
    { "Not in switch", 0 },
    { "Too many cases", 0 },
    { "Multiple defaults", 0 },
    { "Too many active whiles", 1 }, /* 20 */
    { "Out of context", 0 },
    { "Must assign to char pointer or array", 0 },
    { "Dodgy declaration (not pointer)", 0 },
    { "Can't declare within switch", 1 },
    { "Must declare at start of block", 1 },

    /* 
 * Learn to type proper!
 */
    { "Illegal Function or Declaration", 0 },
    { "Missing Open Parenthesis", 1 },
    { "Illegal Argument Name: %s", 0 },
    { "Incorrect number of arguments", 0 },
    { "Expected arguments", 0 },
    { "Out of data for struct initialisation", 1 },
    { "Already defined", 1 },
    { "Must be lvalue", 1 },
    { "Illegal address", 0 },
    { "Can't subscript", 0 },
    { "Can't take member", 1 },
    { "Unknown member: %s", 1 },
    { "Unknown struct", 1 },
    { "Illegal symbol name: %s", 0 },
    { "Missing closing bracket", 0 },
    { "Missing token: %s", 0 },
    { "Unknown symbol: %s", 0 },
    { "Argument mismatch %s() Arg #%d: %s", 0 },
    { "Doesn't match original decl type: %s", 0 },
    { "Missing token, expecting %c got %c", 0 },

    /*
 * Misc problems with yer code..
 */
    { "Invalid Exponent", 0 },
    { "Floating Overflow", 0 },
    { "Invalid expression", 0 },
    { "Can't dereference", 0 },
    { "Operands must be int", 0 },
    { "Expecting constant expression", 0 },
    { "Enum name already used by another symbol", 0 },
    /*
 * Preprocessor errors
 */
    { "No matching #if", 0 },
    { "Maximum nesting level reached (%d)", 1 },
    /*
 * New ones tacked on the end
 */
    { "Maximum number of gotos reached (%d)", 1 },
    { "Unknown goto label: %s at line %d", 1 },
    { "Cannot assign to compound auto variable \'%s\'", 1 },

    { "Attempt to modify const lvalue \'%s\''", 1},
    { "Cannot statically initialise doubles when -doublestr is used", 1},
    { "Cannot dereference the port definition: \'%s\'", 1}
};

/*
 *      Now some code!
 */

int endst(void)
{
    blanks();
    return (ch() == ';' || ch() == 0);
}

void illname(char* sname)
{
    error(E_SYMNAME, sname);
    junk();
}

void multidef(void)
{
    error(E_DEFINED);
}

void needtoken(char* str)
{
    if (match(str) == 0) {
        error(E_TOKEN, str);
    }
}

void needchar(char c)
{
    if (cmatch(c) == 0) {
        error(E_NEEDCHAR, c, (line[lptr] >= 32 && line[lptr] < 127 ? line[lptr] : '?'));
    }
}

void needlval(void)
{
    error(E_LVALUE);
}

void debug(int num, char* str, ...)
{
    va_list ap;

    if (debuglevel != num && debuglevel != DBG_ALL)
        return;
    fprintf(stderr, "sccz80:%s L:%d Debug:#%d: ", Filename, lineno, num);
    va_start(ap, str);
    vfprintf(stderr, str, ap);
    va_end(ap);
    fprintf(stderr, "\n");
}

void warning(int num, ...)
{
    va_list ap;
    if (mywarn[num].suppress == 0) {
        fprintf(stderr, "sccz80:%s L:%d Warning:#%d:", Filename, lineno, num);
        va_start(ap, num);
        vfprintf(stderr, mywarn[num].warn, ap);
        va_end(ap);
        fprintf(stderr, "\n");
    }
}

void error(int num, ...)
{
    va_list ap;

    fprintf(stderr, "sccz80:%s L:%d Error:#%d:", Filename, lineno, num);
    va_start(ap, num);
    vfprintf(stderr, myerrors[num].error, ap);
    va_end(ap);
    fprintf(stderr, "\n");
    if (myerrors[num].fatal != 0)
        ccabort();
    ++errcnt;
    if (c_errstop) {
        fprintf(stderr, "Continue (Y\\N) ?\n");
        if ((toupper(getchar()) == 'N'))
            ccabort();
    }
    if (errcnt >= MAXERRORS) {
        fprintf(stderr, "\nMaximum (%d) number of errors reached, aborting!\n", MAXERRORS);
        ccabort();
    }
}
