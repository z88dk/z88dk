/*  CAMPUS LIsP, Lemon Version                                         */
/*  Copyright (C) 2000  Hirotsugu Kakugawa (h.kakugawa@computer.org)   */
/*  z88dk variant (SCHEME compatible mode, etc) by Stefano Bodrato     */
/*  This is a free software. See "COPYING" for detail.                 */
/*  z88dk/examples/clisp contains example functions and "COPYING"      */

// zcc +cpm -vn -O3 -clib=new clisp.c -o clisp -create-app
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size clisp.c -o clisp --fsigned-char -create-app

// zcc +zx -vn -O3 -startup=8 -clib=new clisp.c -o clisp -create-app
// zcc +zx -vn -SO3 -startup=8 -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size clisp.c -o clisp --fsigned-char -create-app

// use "-DLARGEMEM=1200" for larger workspace
// use "-DSCHEME" for scheme variant
// use "-DNOINIT" to exclude predefined functions

// more information including examples in z88dk/examples/clisp

#pragma output CLIB_OPT_PRINTF         = 0x00001200   // printf has %(ld)s enabled only

#ifdef __SPECTRUM

#pragma output CRT_ORG_CODE            = 30000        // move ORG to 30000
#pragma output REGISTER_SP             = -1           // indicate crt should not modify stack location
#pragma output CRT_ENABLE_EIDI         = 0x01         // disable interrupts at start

#endif

#pragma output CRT_ENABLE_COMMAND_LINE = 0
#pragma output CRT_ENABLE_CLOSE        = 0
#pragma output CLIB_EXIT_STACK_SIZE    = 0
#pragma output CLIB_MALLOC_HEAP_SIZE   = 0
#pragma output CLIB_STDIO_HEAP_SIZE    = 0

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <input.h>

/* Data Representation ('int' must be at least 32 bits) */

#define D_MASK_DATA     0x0fffffffUL
#define D_MASK_TAG      0x70000000UL
#define D_GC_MARK       0x80000000UL
#define D_TAG_BIT_POS   28UL
#define D_INT_SIGN_BIT  0x08000000UL
/*
#define D_GET_TAG(s)    (s & ~(D_GC_MARK | D_MASK_DATA))
#define D_GET_DATA(s)   (s & D_MASK_DATA)
*/

/* Data Tags */

#define TAG_NIL     (0UL << D_TAG_BIT_POS)
#define TAG_T       (1UL << D_TAG_BIT_POS)
#define TAG_INT     (2UL << D_TAG_BIT_POS)
#define TAG_SYMB    (3UL << D_TAG_BIT_POS)
#define TAG_CONS    (4UL << D_TAG_BIT_POS)
#define TAG_EOF     (5UL << D_TAG_BIT_POS)
#define TAG_UNDEF   (6UL << D_TAG_BIT_POS)
/*
#define TAG_NIL     0x00000000UL
#define TAG_T       0x10000000UL
#define TAG_INT     0x20000000UL
#define TAG_SYMB    0x30000000UL
#define TAG_CONS    0x40000000UL
#define TAG_EOF     0x50000000UL
#define TAG_UNDEF   0x60000000UL
*/

/* Cells */

#ifdef LARGEMEM
#define NCONS   LARGEMEM
#else
#define NCONS   1024
#endif

int t_cons_free;           /* free list */
long t_cons_car[NCONS];     /* "car" part of cell */
long t_cons_cdr[NCONS];     /* "cdr" part of cell */

/* Symbols */

#ifdef LARGEMEM
#define NSYMBS   180
#else
#define NSYMBS   170
#endif

int t_symb_free;           /* free slot */
char *t_symb_pname[NSYMBS];  /* pointer to printable name */
/* #define t_symb_val        ((long *)0x7e00) */        /*long t_symb_val[NSYMBS];*/    /* symbol value */
long t_symb_val[NSYMBS];
/*#define t_symb_fval        ((long *)0x7efc) */        /*long t_symb_fval[NSYMBS];*/   /* symbol function definition */
long t_symb_fval[NSYMBS];
int t_symb_ftype[NSYMBS];  /* function type */ 

/* Printable name */

#ifdef LARGEMEM
#define PNAME_SIZE   LARGEMEM
#else
#define PNAME_SIZE   512
#endif

int t_pnames_free;         /* free pointer */
char  t_pnames[PNAME_SIZE];  /* names */ 

/* Stack */

/* every stack entry has an extra cost on che real CPU stack
   the average cost is about 35 bytes (!) the best overflow protection
   should be to trigger the SP and fire out the error condition when
   a lower limit has been reached */

#ifdef LARGEMEM
#define STACK_SIZE   LARGEMEM/9
#else
#define STACK_SIZE   200
#endif

long t_stack[STACK_SIZE];   /* the stack */
unsigned int t_stack_ptr;           /* stack pointer */
    
/* Function types */

enum Ftype {
  FTYPE_UNDEF,
  FTYPE_SYS, 
  FTYPE_SPECIAL,
  FTYPE_USER
};
#define FTYPE(t, nargs)       ((t)*1024 + (nargs))
#define FTYPE_ANY_ARGS         1023
#define FTYPE_GET_TYPE(p)     ((p) / 1024)
#define FTYPE_GET_NARGS(p)    ((p) % 1024) 

/* Keywords */

enum keywords {
  KW_READ,    KW_EVAL,    KW_GC,      KW_CONS,    KW_CAR,      KW_CDR,
  KW_QUIT,    KW_DEFUN,   KW_QUOTE,   KW_SETQ,    KW_EQ, 
  KW_NULL,    KW_CONSP,   KW_SYMBP,   KW_NUMBERP, KW_PRINC,    KW_TERPRI,   KW_RPLACA,
  KW_RPLACD,  KW_PROGN,   KW_COND,    KW_OR,      KW_NOT,      KW_IF,
  KW_LIST,    KW_ADD,     KW_SUB,     KW_TIMES,   KW_QUOTIENT, 
  KW_GT,      KW_LT,      KW_AND,     KW_DIVIDE,  KW_LAMBDA,  
  KW_WHILE,   KW_GTE,     KW_LTE,     KW_COMMENT,
  KW_ZEROP,   KW_ATOM,    KW_RAND,    KW_REM,
  KW_INCR,    KW_DECR,    KW_EQUAL,   KW_EQMATH
};

struct s_keywords {
  char  *key;
  int  ftype;
  char   i;
};

/* Built-in function table */

#ifndef NOINIT
struct s_keywords funcs[] = {
  { "read",     FTYPE(FTYPE_SYS,     0),               KW_READ     },
  { "eval",     FTYPE(FTYPE_SYS,     1),               KW_EVAL     },
  { "gc",       FTYPE(FTYPE_SYS,     0),               KW_GC       },
  { "cons",     FTYPE(FTYPE_SYS,     2),               KW_CONS     },
  { "car",      FTYPE(FTYPE_SYS,     1),               KW_CAR      },
  { "cdr",      FTYPE(FTYPE_SYS,     1),               KW_CDR      },
  { "quit",     FTYPE(FTYPE_SYS,     0),               KW_QUIT     },
#ifdef SCHEME
  { "define",   FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_DEFUN    },
#else
  { "defun",    FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_DEFUN    },
#endif
  { "quote",    FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_QUOTE    },
#ifdef SCHEME
  { "set!",     FTYPE(FTYPE_SPECIAL, 2),               KW_SETQ     },
  { "eq?",      FTYPE(FTYPE_SYS,     2),               KW_EQ       },
  { "null?",    FTYPE(FTYPE_SYS,     1),               KW_NULL     },
#else
  { "setq",     FTYPE(FTYPE_SPECIAL, 2),               KW_SETQ     },
  { "eq",       FTYPE(FTYPE_SYS,     2),               KW_EQ       },
  { "null",     FTYPE(FTYPE_SYS,     1),               KW_NULL     },
#endif
#ifdef SCHEME
  { "pair?",    FTYPE(FTYPE_SYS,     1),               KW_CONSP    },
  { "symbol?",  FTYPE(FTYPE_SYS,     1),               KW_SYMBP    },
  { "number?",  FTYPE(FTYPE_SYS,     1),               KW_NUMBERP  },
  { "display",  FTYPE(FTYPE_SYS,     1),               KW_PRINC    },
#else
  { "consp",    FTYPE(FTYPE_SYS,     1),               KW_CONSP    },
  { "symbolp",  FTYPE(FTYPE_SYS,     1),               KW_SYMBP    },
  { "numberp",  FTYPE(FTYPE_SYS,     1),               KW_NUMBERP  },
  { "princ",    FTYPE(FTYPE_SYS,     1),               KW_PRINC    },
#endif
  { "terpri",   FTYPE(FTYPE_SYS,     0),               KW_TERPRI   },
  /*    Lisp uses functions rplaca and rplacd to alter list structure
        they change structure the same way as EMACS setcar and setcdr,
        but the Common Lisp functions return the cons cell while
        setcar and setcdr return the new car or cdr. */
  { "rplaca",   FTYPE(FTYPE_SYS,     2),               KW_RPLACA   },
  { "rplacd",   FTYPE(FTYPE_SYS,     2),               KW_RPLACD   },
#ifdef SCHEME
  { "begin",    FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_PROGN    },
#else
  { "progn",    FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_PROGN    },
#endif
  { "cond",     FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_COND     },
  { "or",       FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_OR       },
  { "not",      FTYPE(FTYPE_SYS,     1),               KW_NOT      },
  { "if",       FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_IF       },
  { "list",     FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_LIST     },
  { "+",        FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_ADD      },
  { "-",        FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_SUB      },
  { "*",        FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_TIMES    },
  { "/",        FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_QUOTIENT },
  { ">",        FTYPE(FTYPE_SYS,     2),               KW_GT       },
  { "<",        FTYPE(FTYPE_SYS,     2),               KW_LT       },
  { "and",      FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_AND      },
  { "divide",   FTYPE(FTYPE_SYS,     2),               KW_DIVIDE   },
  { "lambda",   FTYPE(FTYPE_SYS,     FTYPE_ANY_ARGS),  KW_LAMBDA   },
  /* EMACS LISP while syntax */
  { "while",    FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_WHILE    },
  { ">=",       FTYPE(FTYPE_SYS,     2),               KW_GTE      },
  { "<=",       FTYPE(FTYPE_SYS,     2),               KW_LTE      },
  { "comment",  FTYPE(FTYPE_SPECIAL, FTYPE_ANY_ARGS),  KW_COMMENT  },
#ifdef SCHEME
  { "zero?",    FTYPE(FTYPE_SYS,     1),               KW_ZEROP    },
  { "atom",     FTYPE(FTYPE_SYS,     1),               KW_ATOM     },
#else
  { "zerop",    FTYPE(FTYPE_SYS,     1),               KW_ZEROP    },
  { "atom",     FTYPE(FTYPE_SYS,     1),               KW_ATOM     },
#endif
  { "random",   FTYPE(FTYPE_SYS,     1),               KW_RAND     },
  { "rem",      FTYPE(FTYPE_SYS,     2),               KW_REM      },
  { "1+",       FTYPE(FTYPE_SYS,     1),               KW_INCR     },
  { "1-",       FTYPE(FTYPE_SYS,     1),               KW_DECR     },
#ifdef SCHEME
  { "equal?",   FTYPE(FTYPE_SYS,     2),               KW_EQUAL    },
#else
  { "equal",    FTYPE(FTYPE_SYS,     2),               KW_EQUAL    },
#endif
  { "=",        FTYPE(FTYPE_SYS,     2),               KW_EQMATH   },
  { NULL,       -1,                                    -1          }
};
#endif

/* Error messages */

char *errmsg_sym_undef  = "SYMBOL UNDEFINED: ";
char *errmsg_func_undef = "FUNCTION UNDEFINED: ";
char *errmsg_ill_nargs  = "ILLEGAL NUMBER OF ARGUMENTS: ";
char *errmsg_ill_type   = "ILLEGAL ARGUMENT TYPE: ";
char *errmsg_ill_call   = "ILLEGAL FUNCTION CALL: ";
char *errmsg_ill_syntax = "ILLEGAL SYNTAX: ";
char *errmsg_eof        = "END OF FILE";
char *errmsg_stack_of   = "STACK OVERFLOW";
char *errmsg_zero_div   = "DIVISION BY ZERO: ";
char *errmsg_no_memory  = "\nno memory. abort.\n";

/* Function types */

void  init(void);
void toplevel(void);
long  l_read(void);
long l_eval(long s);
long l_print(long s);
char  skip_space(void);
long  int_make_l(long v);
long  int_get_c(long s);
long  eval_args(long func, long a, long av[2], int n);
long  special(long f, long a);
long  fcall(long f, long av[2]);  /*, int n*/
long  apply(long f, long args, int n);
char  err_msg(char *msg, char f, long s);
long  l_cons(long car, long cdr);
long  l_car(long s);
long  l_cdr(long s);
void  quit(void);
int  list_len(long s);
void  rplacd(long s, long cdr);
void  gcollect(void);
void  gc_mark(long s);
char  gc_protect(long s);
void  gc_unprotect(long s);
long  symb_make(char *p);

long D_GET_TAG(long s) {
        return (s & ~(D_GC_MARK | D_MASK_DATA));
}

long D_GET_DATA(long s) {
        return (s & D_MASK_DATA);
}

int
main(void)
{
  init();
#ifdef SCHEME
  printf("CAMPUS LIsP\nLemon version,\nz88dk SCHEME variant\n");
#else
  printf("CAMPUS LIsP\nLemon version,\nz88dk variant\n");
#endif
  toplevel();
  quit();

  return 0;
}


/* Initialize lisp storage */
void
init(void)
{
  int  i;
/*
  // Randomize 
  printf("Any key to continue...\n\n");
   
  in_wait_nokey();
  for (i=0; !in_test_key(); ++i) ;

  in_wait_nokey();
  srand(i);
*/
  srand(0x1234);
  
  /* stack */
  t_stack_ptr = 0;

#ifndef NOINIT

  /* cells */
  t_cons_free = 0;

  /* make a free cell list */
  for (i = 0; i != NCONS-1; i++)
    t_cons_car[i]  = i+1;
  t_cons_car[NCONS-1] = NCONS-1;    /* self-loop (this is very important) */

  /* symbol table */
  t_symb_free = 0;
  for (i = 0; i != NSYMBS; i++)
    t_symb_pname[i] = NULL;

  /* print name (symbol name) */
  t_pnames_free = 0;

  /* install built-in functions */
  for (i = 0; funcs[i].key != NULL; i++) {
    symb_make(funcs[i].key);
    t_symb_ftype[i] = funcs[i].ftype;

    if (i != funcs[i].i){
      printf("function install error: %s\n", funcs[i].key);
      quit();
    }
  }

#endif
  
}


/* Top level */
void
toplevel(void)
{
  long  s, v;

  for (;;){
    t_stack_ptr = 0;
    printf("\n] ");             /* prompt */
    if ((s = l_read()) < 0)     /* read */
      continue;
    if (s == TAG_EOF)           /* end of file */
      break;
    if (gc_protect(s) < 0)
      break;
    if ((v = l_eval(s)) < 0)    /* eval */
      continue;
    gc_unprotect(s);
        printf("\n");
    (void) l_print(v);          /* print */
  }
}


/* Read an S-expression */
long
l_read(void)
{
  long  s, v, t;
  char  token[32];
  char  ch, i;
  
  /* skip spaces */
  if ((ch = skip_space()) < 0){  /* eof */
    return TAG_EOF; 

  } else if (ch == ';'){         /* comment */
    while (getchar() != '\n')
      ;
    return -1;
  }
  else if (ch == '\''){        /* quote macro */
    if ((t = l_read()) < 0)
      return -1;
    if (t == TAG_EOF)
      return err_msg(errmsg_eof, 0, 0);
    t = l_cons(t, TAG_NIL);
    s = l_cons((TAG_SYMB|KW_QUOTE), t);

  } else if (ch != '('){         /* t, nil, symbol, or integer */
    token[0] = ch;
    for (i = 1; ; i++){
      ch = getchar();
      if (isspace(ch) || iscntrl(ch) || (ch < 0) 
          || (ch == ';') || (ch == '(') || (ch == ')')){
        ungetc(ch, stdin);
        token[i] = '\0';
        
        /*  Changed to permint the definition of "1+" and "1-" */
        if ((isdigit((char)token[0]) && (token[1] != '+') && (token[1] != '-'))
/*        if (isdigit((char)token[0]) */
            || ((token[0] == '-') && isdigit((char)token[1]))
            || ((token[0] == '+') && isdigit((char)token[1]))){   /* integer */
          s = int_make_l(atol(token));
#ifdef SCHEME
        } else if (strcmp(token, "#f") == 0){                   /* nil */ 
          s = TAG_NIL;
        } else if (strcmp(token, "#t") == 0){                     /* t */
          s = TAG_T;
#else
        } else if (strcmp(token, "nil") == 0){                   /* nil */ 
          s = TAG_NIL;
        } else if (strcmp(token, "t") == 0){                     /* t */
          s = TAG_T;
#endif
        } else {                                                 /* symbol */
          s = TAG_SYMB | symb_make(token);
        }
        break;
      }
      token[i] = ch;
    }

  } else /* ch == '(' */ {       /* list */
    if ((ch = skip_space()) < 0){
      return err_msg(errmsg_eof, 0, 0);
    } else if (ch == ')'){
      s = TAG_NIL;  /* "()" = nil */
    } else {
      ungetc(ch, stdin);
      if ((t = l_read()) < 0)
        return err_msg(errmsg_eof, 0, 0);
      if (t == TAG_EOF)
        return -1;
      if ((s = v = l_cons(t, TAG_NIL)) < 0)
        return -1;
      if (gc_protect(s) < 0)
        return -1;
      for (;;){
        if ((ch = skip_space()) < 0)  /* look ahead next char */
          return err_msg(errmsg_eof, 0, 0);
        if (ch == ')')
          break;
        ungetc(ch, stdin);
        if ((t = l_read()) < 0)
          return -1;
        if (t == TAG_EOF)
          return err_msg(errmsg_eof, 0, 0);
        if ((t = l_cons(t, TAG_NIL)) < 0) 
          return -1;
        rplacd(v, t);
        v = l_cdr(v);
      }
      gc_unprotect(s);
    }
  }

  return s;
}

char
skip_space(void)
{
  char ch;

  for (;;){
    if ((ch = getchar()) < 0)
      return -1;     /* end-of-file */
    if (!isspace(ch) && !iscntrl(ch))
      break;
  }
  return ch;
}

long
l_equal(long s1, long s2)
{
  int  d1 = s1 & D_MASK_DATA;
  int  d2 = s2 & D_MASK_DATA;
  int  i;

  if (D_GET_TAG(s1) != D_GET_TAG(s2))
    return TAG_NIL;
  switch (D_GET_TAG(s1)){
  case TAG_CONS:
    if (l_equal(l_car(s1), l_car(s1)) == TAG_NIL)
      return TAG_NIL;
    return l_equal(l_car(s2), l_car(s2));
  default:
    return (s1 == s2) ? TAG_T : TAG_NIL;
  }
}

/* Print an S-expression */
long
l_print(long s)
{
  long  v, t;
  int i;

  switch(D_GET_TAG(s)){

#ifdef SCHEME
  case TAG_NIL:
    printf("#f");
    break;

  case TAG_T:
    printf("#t");
    break;
#else
  case TAG_NIL:
    printf("nil");
    break;

  case TAG_T:
    printf("t");
    break;
#endif
  case TAG_INT:
    v = int_get_c(s);
    printf("%ld", v);
    break;

  case TAG_SYMB:
    i = s & D_MASK_DATA;
    printf("%s", t_symb_pname[i]);
    break;

  case TAG_EOF:
    printf("<eof>");
    break;

  case TAG_UNDEF:  /* for debugging */
    printf("<undefined>"); 
    break;

  case TAG_CONS:
    printf("(");
    t = s;
    l_print(l_car(t));
    while (D_GET_TAG(l_cdr(t)) == TAG_CONS) {
      printf(" ");
      t = l_cdr(t);
      l_print(l_car(t));
    }
    if (D_GET_TAG(l_cdr(t)) != TAG_NIL){
      printf(" . ");
      l_print(l_cdr(t)); 
    }
    printf(")");
    break;
  }
  return TAG_T;
}


/* Evaluate an S-expression */
long
l_eval(long s)
{
  long  v, f, a, av[2];
  int n;

  switch(D_GET_TAG(s)){

  case TAG_NIL:        /* self-evaluating objects */
  case TAG_T:
  case TAG_INT:
    v = s;
    break;

  case TAG_SYMB:       /* symbol ... refer to the symbol table */
    if ((v = t_symb_val[D_GET_DATA(s)]) == TAG_UNDEF)
      return err_msg(errmsg_sym_undef, 1, s);
    break;

  case TAG_CONS:       /* cons ... function call */
    f = l_car(s);   /* function name or lambda exp */
    a = l_cdr(s);   /* actual argument list */

    if ((D_GET_TAG(f) == TAG_CONS) && (D_GET_TAG(l_car(f)) == TAG_SYMB) 
        && ((D_GET_DATA(l_car(f)) == KW_LAMBDA))){   /* lambda exp */
      if (eval_args(f, a, av, FTYPE_ANY_ARGS) < 0)
        return -1;
      v = apply(l_cdr(f), av[0], list_len(l_car(l_cdr(f))));
    } else if (D_GET_TAG(f) == TAG_SYMB){
      n = FTYPE_GET_NARGS(t_symb_ftype[D_GET_DATA(f)]);
      switch (FTYPE_GET_TYPE(t_symb_ftype[D_GET_DATA(f)])){
      case FTYPE_UNDEF:
        return err_msg(errmsg_func_undef, 1, f);
      case FTYPE_SPECIAL:
        v = special(f, a);
        break;
      case FTYPE_SYS:
        if (eval_args(f, a, av, n) < 0)
          return -1;
        v = fcall(f, av/*, n*/);
        break;
      case FTYPE_USER:
        if (eval_args(f, a, av, FTYPE_ANY_ARGS) < 0)
          return -1;
        v = apply(f, av[0], n);
      }
    } else {
      return err_msg(errmsg_ill_call, 1, s);
    }
    break;
  }
  return v;
}


/* Execute special form (defun, setq. etc... arguments are not evaluated) */
long
special(long f, long a)
{
  long  t, v, u;
  int l, i;

  switch (D_GET_DATA(f)){

  case KW_DEFUN:
    if (list_len(a) < 2)
      return err_msg(errmsg_ill_syntax, 1, f);
#ifdef SCHEME
    /* (define (func var1 varn) (func content)) */
    v = l_car(a);            /* function name  */
    v = l_car(v);            /* list of function name, arg and function body */
    if (D_GET_TAG(v) != TAG_SYMB)
      return err_msg(errmsg_ill_syntax, 1, f);
    t = l_cdr(v);   /* list of function args */
    l = list_len(t);  /* #args */
    a = l_cons(  v, l_cons(   l_cdr(l_car(a))  , l_cdr(a)));
#endif
    /* (defun func (var1 varn) (func content)) */
    v = l_car(a);            /* function name  */
    if (D_GET_TAG(v) != TAG_SYMB)
      return err_msg(errmsg_ill_syntax, 1, f);
    t = l_cdr(a);            /* list of function arg and function body */
    l = list_len(l_car(t));  /* #args */

    i = D_GET_DATA(v);
    t_symb_fval[i]  = t;
    t_symb_ftype[i] = FTYPE(FTYPE_USER, l);
    break;

  case KW_SETQ:
    t = l_car(a);  /* symbol name */
    if (D_GET_TAG(t) != TAG_SYMB)
      return err_msg(errmsg_ill_type, 1, f);
    if ((v = l_eval(l_car(l_cdr(a)))) < 0)  /* value */
      return -1;
    t_symb_val[D_GET_DATA(t)] = v;
    break;

  case KW_QUOTE:
    v = l_car(a);
    break;

  case KW_PROGN:
    for (v = TAG_NIL, t = a; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      if ((v = l_eval(l_car(t))) < 0)
        return -1;
    }
    break;

  case KW_WHILE:
    if (D_GET_TAG(a) != TAG_CONS)
      return err_msg(errmsg_ill_syntax, 1, f);
    if ((v = l_eval(l_car(a))) < 0)
      return -1;
    while (D_GET_TAG(v) != TAG_NIL) {
      for (t = l_cdr(a); D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
        if ((v = l_eval(l_car(t))) < 0)
          return -1;
      }
      v = l_eval(l_car(a));
    }
    break;

  case KW_AND:
    for (v = TAG_T, t = a; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      if ((v = l_eval(l_car(t))) < 0)
        return -1;
      if (D_GET_TAG(t) == TAG_NIL)
        break;
    }
    break;

  case KW_OR:
    for (v = TAG_NIL, t = a; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      if ((v = l_eval(l_car(t))) < 0)
        return -1;
      if (D_GET_TAG(v) != TAG_NIL)
        break;
    }
    break; 

  case KW_COND:
    if (D_GET_TAG(a) != TAG_CONS)
      return err_msg(errmsg_ill_syntax, 1, f);
    v = TAG_NIL; 
    for (t = a; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      u = l_car(t);
      if (D_GET_TAG(u) != TAG_CONS)
        return err_msg(errmsg_ill_syntax, 1, f);
      if ((v = l_eval(l_car(u))) < 0)
        return -1;
      if (D_GET_TAG(v) != TAG_NIL){
                for (u = l_cdr(u); D_GET_TAG(u) == TAG_CONS; u = l_cdr(u)){ 
                  if ((v = l_eval(l_car(u))) < 0)
                        return -1;
                }
        break;
      }
    }
    break;

  case KW_COMMENT:
    v = TAG_T;
    break;

  case KW_IF:
    if (D_GET_TAG(a) != TAG_CONS)
      return err_msg(errmsg_ill_syntax, 1, f);
    l = list_len(a);
    if ((l == 2) || (l == 3)){
      if ((v = l_eval(l_car(a))) < 0)
    return -1;
      if (D_GET_TAG(v) != TAG_NIL)
    return l_eval(l_car(l_cdr(a)));
      return  (l == 2) ? TAG_NIL : l_eval(l_car(l_cdr(l_cdr(a))));
    } else {
      return err_msg(errmsg_ill_syntax, 1, f);
    }
    break;
  }
  return v;
}


/* Evaluate arguments */
long
eval_args(long func, long arg, long av[2], int n)
{
  long  x, y;

  if ((n != FTYPE_ANY_ARGS) && (n != list_len(arg)))
    return err_msg(errmsg_ill_nargs, 1, func);

  switch (n){

  case 0:
    av[0] = TAG_NIL;
    break;

  case 1:
    if ((av[0] = l_eval(l_car(arg))) < 0)
      return -1;
    break;

  case 2:
    if ((av[0] = l_eval(l_car(arg))) < 0)
      return -1;
    if (gc_protect(av[0]) < 0)
      return -1;
    if ((av[1] = l_eval(l_car(l_cdr(arg)))) < 0)
      return -1;
    gc_unprotect(av[0]);
    break;

  case FTYPE_ANY_ARGS:   /* return evaluated arguments as a list */
    if (D_GET_TAG(arg) != TAG_CONS){
      av[0] = TAG_NIL;
    } else {
      if ((x = l_eval(l_car(arg))) < 0)
        return -1;
      if ((av[0] = y = l_cons(x, TAG_NIL)) < 0)
        return -1;
      if (gc_protect(av[0]) < 0)
        return -1;
      for (arg = l_cdr(arg); D_GET_TAG(arg) == TAG_CONS; arg = l_cdr(arg)){
        if ((x = l_eval(l_car(arg))) < 0)
          return -1;
        rplacd(y, l_cons(x, TAG_NIL)); 
        y = l_cdr(y);
      }
      gc_unprotect(av[0]);
    }
  }
  return av[0];
}


/* Call a built-in function */
long
fcall(long f, long av[2])  /*, int n*/
{
  long   v, t;
  long  r, d;

  switch (D_GET_DATA(f)){
        case KW_RPLACA:
        case KW_RPLACD:
        case KW_CAR:
        case KW_CDR:
                if (D_GET_TAG(av[0]) != TAG_CONS)
                  return err_msg(errmsg_ill_type, 1, f);
                break;

        case KW_GT:
        case KW_LT:
        case KW_GTE:
        case KW_LTE:
        case KW_REM:
                if ((D_GET_TAG(av[0]) != TAG_INT) || (D_GET_TAG(av[1]) != TAG_INT))
                  return err_msg(errmsg_ill_type, 1, f);
                break;
        case KW_ZEROP:
        case KW_RAND:
        case KW_INCR:
        case KW_DECR:
                if (D_GET_TAG(av[0]) != TAG_INT)
                  return err_msg(errmsg_ill_type, 1, f);
                break;
  }

  switch (D_GET_DATA(f)){

  case KW_LAMBDA:
    return err_msg(errmsg_ill_call, 1, f);
    break;

  case KW_QUIT:
    quit();
    break;
    
  case KW_EQ:
  case KW_EQMATH:
    v = (av[0] == av[1]) ? TAG_T : TAG_NIL;
    break;

  case KW_EQUAL:
    return l_equal(av[0], av[1]);

  case KW_CONS:
    v = l_cons(av[0], av[1]); 
    break;

  case KW_RPLACA:
    v = t_cons_car[D_GET_DATA(av[0])] = av[1];
    break;

  case KW_RPLACD:
    v = t_cons_cdr[D_GET_DATA(av[0])] = av[1];
    break;

  case KW_CAR:
    v = l_car(av[0]);
    break;

  case KW_CDR:
    v = l_cdr(av[0]);
    break;

  case KW_NULL:
    v = (D_GET_TAG(av[0]) == TAG_NIL) ? TAG_T : TAG_NIL;
    break;

  case KW_CONSP:
    return (D_GET_TAG(av[0]) == TAG_CONS) ? TAG_T : TAG_NIL;

  case KW_SYMBP:
    return (D_GET_TAG(av[0]) == TAG_SYMB) ? TAG_T : TAG_NIL;

  case KW_NUMBERP:
    v = (D_GET_TAG(av[0]) == TAG_INT) ? TAG_T : TAG_NIL;
    break;

  case KW_LIST:
    v = av[0];
    break;

  case KW_NOT:
    v = (D_GET_TAG(av[0]) == TAG_NIL) ? TAG_T : TAG_NIL;
    break;

  case KW_READ:
    v = l_read();
    break;

  case KW_EVAL:
    v = l_eval(av[0]);
    break;

  case KW_PRINC:
    v = l_print(av[0]);
    break;

  case KW_TERPRI:
    printf("\n");
    v = TAG_NIL;
    break;

  case KW_GC:
    gcollect();
    v = TAG_T;
    break;

  case KW_ADD:
    for (r = 0, t = av[0]; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      if (D_GET_TAG(l_car(t)) != TAG_INT)
        return err_msg(errmsg_ill_type, 1, f);
      r = r + int_get_c(l_car(t));
    }
    v = int_make_l(r);
    break;

  case KW_TIMES:
    for (r = 1, t = av[0]; D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
      if (D_GET_TAG(l_car(t)) != TAG_INT)
        return err_msg(errmsg_ill_type, 1, f);
      r = r * int_get_c(l_car(t));
    }
    v = int_make_l(r);
    break;

  case KW_SUB:
    if (D_GET_TAG(av[0]) == TAG_NIL){
      r = 0;
    } else if (D_GET_TAG(l_car(av[0])) != TAG_INT){
        return err_msg(errmsg_ill_type, 1, f);
    } else if (D_GET_TAG(l_cdr(av[0])) == TAG_NIL){
      r = 0 - int_get_c(l_car(av[0]));
    } else {
      r = int_get_c(l_car(av[0]));
      for (t = l_cdr(av[0]); D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
        if (D_GET_TAG(l_car(t)) != TAG_INT)
          return err_msg(errmsg_ill_type, 1, f);
        r = r - int_get_c(l_car(t));
      }
    }
    v = int_make_l(r);
    break;

  case KW_QUOTIENT:
    if (D_GET_TAG(av[0]) == TAG_NIL){
      r = 1;
    } else if (D_GET_TAG(l_car(av[0])) != TAG_INT){
        return err_msg(errmsg_ill_type, 1, f);
    } else if ((d = int_get_c(l_car(av[0]))) == 0){
      return err_msg(errmsg_zero_div, 1, f);
    } if (D_GET_TAG(l_cdr(av[0])) == TAG_NIL){
      r = 1 / d;
    } else {
      for (r = d, t = l_cdr(av[0]); D_GET_TAG(t) == TAG_CONS; t = l_cdr(t)){
        if (D_GET_TAG(l_car(t)) != TAG_INT)
          return err_msg(errmsg_ill_type, 1, f);
        if ((d = int_get_c(l_car(t))) == 0)
          return err_msg(errmsg_zero_div, 1, f);
        r = r / d;
      }
    }
    v = int_make_l(r);
    break;

  case KW_GT:
    v = (int_get_c(av[0]) > int_get_c(av[1])) ? TAG_T : TAG_NIL;
    break;

  case KW_DIVIDE:
    r = int_get_c(av[0]);
    if ((d = int_get_c(av[1])) == 0)
      return err_msg(errmsg_zero_div, 1, f);
    v = l_cons(int_make_l(r / d), int_make_l(r % d));
    break;

  case KW_LT:
    v = (int_get_c(av[0]) < int_get_c(av[1])) ? TAG_T : TAG_NIL;
    break;

  case KW_ATOM:
    v = (D_GET_TAG(av[0]) != TAG_CONS) ? TAG_T : TAG_NIL;
    break;

  case KW_GTE:
    v = (int_get_c(av[0]) >= int_get_c(av[1])) ? TAG_T : TAG_NIL;
    break;

  case KW_LTE:
    v = (int_get_c(av[0]) <= int_get_c(av[1])) ? TAG_T : TAG_NIL;
    break;

  case KW_ZEROP:
    v = (int_get_c(av[0]) == 0) ? TAG_T : TAG_NIL;
    break;

  case KW_RAND:
    v = int_make_l(rand() % int_get_c(av[0]));
    break;

  case KW_INCR:
    v = int_make_l(int_get_c(av[0])+1);
    break;

  case KW_DECR:
    v = int_make_l(int_get_c(av[0])-1);
    break;

  case KW_REM:
    r = int_get_c(av[0]);
    if ((d = int_get_c(av[1])) == 0)
      return err_msg(errmsg_zero_div, 1, f);
    v = int_make_l(r % d);
    break;

  }

  return v;
}


/* Function application (user defined function) */
long
apply(long func, long aparams, int n) 
{
  long   fdef, fbody, f, sym, a, v;
  int  i;

  if (t_stack_ptr + n > STACK_SIZE)   /* stack overflow */
    return err_msg(errmsg_stack_of, 0, 0);

  if (D_GET_TAG(func) == TAG_SYMB){         /* function symbol */
    fdef = t_symb_fval[D_GET_DATA(func)];
  } else if (D_GET_TAG(func) == TAG_CONS){  /* lambda exp */
    fdef = func;
  }

  /* bind */
  f = l_car(fdef);  /* formal parameters */
  a = aparams;      /* actual parameters */
  t_stack_ptr = t_stack_ptr + n;
  for (i = 0; i < n; i++, f = l_cdr(f), a = l_cdr(a)){
    sym = l_car(f);
    /* push old symbol values onto stack */
    t_stack[t_stack_ptr - i - 1] = t_symb_val[D_GET_DATA(sym)];
    /* bind argument value to symbol */
    t_symb_val[D_GET_DATA(sym)] = l_car(a);
  }

  if (gc_protect(aparams) < 0)
    return -1;

  /* evaluate function body */
  fbody = l_cdr(fdef);  /* function body */
  for (v = TAG_NIL; D_GET_TAG(fbody) == TAG_CONS; fbody = l_cdr(fbody)){
    if ((v = l_eval(l_car(fbody))) < 0)
      break;   /* error ... never return immediately - need unbinding. */
  }

  /* pop gc_protected objects, including 'gc_unprotect(aparams)'. */
  while ((t_stack[t_stack_ptr-1] & D_GC_MARK) != 0)
    --t_stack_ptr;   

  /* unbind: restore old variable values from stack */
  for (i = 0, f = l_car(fdef); i < n; i++, f = l_cdr(f)){
    sym = l_car(f);
    t_symb_val[D_GET_DATA(sym)] = t_stack[t_stack_ptr - i - 1];
  }
  t_stack_ptr = t_stack_ptr - n;

  return v;
}


/* Print an error message */
char
err_msg(char *msg, char f, long s)
{
  printf("\nERROR. \n%s", msg);
  if (f != 0)
    l_print(s);
  printf("\n");
  return -1;
}

/* Length of a list */
int
list_len(long s)
{
  int i;

  for (i = 0; D_GET_TAG(s) == TAG_CONS; s = l_cdr(s))
    i++;
  return i;
}

/* "Replace cdr" operation ... rewite cdr part of a cons cell */
void
rplacd(long s, long cdr)
{
  t_cons_cdr[D_GET_DATA(s)] = cdr;
}


/* "Cons" operation */
long
l_cons(long car, long cdr)
{
  int s;

  if (t_cons_free < 0){   /*  no cons cells */
    if (gc_protect(car) < 0)
      return -1;
    if (gc_protect(cdr) < 0)
      return -1;
    gcollect();           /* invoke garbage collector */
    gc_unprotect(cdr);
    gc_unprotect(car);
  }

  /* get a free cons cell from a free list */
  s = t_cons_free;
  if (t_cons_car[t_cons_free] != t_cons_free)
    t_cons_free  = t_cons_car[t_cons_free];  /* next free cell */
  else
    t_cons_free = -1;                        /* self-loop: end of free list */

  /* constract a new cell */
  t_cons_car[s] = car;
  t_cons_cdr[s] = cdr;

  return (TAG_CONS | s);
}

/* "Car" operation */
long
l_car(long s)
{
  return t_cons_car[D_GET_DATA(s)];
}

/* "Cdr" operation */
long
l_cdr(long s)
{
  return t_cons_cdr[D_GET_DATA(s)];
}

/* Quit micro lisp */
void
quit(void)
{
  printf("\nBYE\n");
  exit(0);
}


/* Garbage collector */
void
gcollect(void)
{
  int i, n, p;

  /* mark */
  for (i = 0; i < t_symb_free; i++)
    gc_mark(t_symb_val[i]);
  for (i = 0; i < t_symb_free; i++)
    gc_mark(t_symb_fval[i]);
  for (i = 0; i < t_stack_ptr; i++)
    gc_mark(t_stack[i]);

  /* sweep */
  t_cons_free = -1;
  for (i = 0, n = 0; i != NCONS; i++){
    if ((t_cons_car[i] & D_GC_MARK) == 0){  /* collect */
      n++;
      if (t_cons_free == -1){
        t_cons_free = i;
      } else {
        t_cons_car[p] = i; 
      }
      t_cons_car[i] = i; 
      p = i;
    }
    t_cons_car[i] &= ~D_GC_MARK;   /* clear mark */
  }

  if (n == 0){    /* no more cells... */
    printf(errmsg_no_memory);
    quit();
  }
}

/* mark recursively */
void
gc_mark(long s)
{
  for ( ; D_GET_TAG(s) == TAG_CONS; s = l_cdr(s)){
    if ((t_cons_car[D_GET_DATA(s)] & D_GC_MARK) != 0) /* visited before */
      return;
    t_cons_car[D_GET_DATA(s)] |= D_GC_MARK;  /* mark */
    gc_mark(l_car(s));                       /* visit car part */
  }
}

/* protect/unprotect temporary objects from garbage collector */
char
gc_protect(long s)
{
  if (D_GET_TAG(s) == TAG_CONS){  /* save only cons cells */
    if (t_stack_ptr >= STACK_SIZE)     /* stack overflow */
      return err_msg(errmsg_stack_of, 0, 0);
    t_stack[t_stack_ptr++] = (D_GC_MARK | s);  
  }
  return 0;
}

void
gc_unprotect(long s)
{
  if (D_GET_TAG(s) == TAG_CONS)
      --t_stack_ptr;
}


/* Make a Lisp integer from a C integer */
long
int_make_l(long v)
{
  return (TAG_INT | ((unsigned long)v & D_MASK_DATA));
}

/* Make a C integer from a Lisp integer */
long 
int_get_c(long s)
{
  if (((unsigned long)s & D_INT_SIGN_BIT) == 0)
    return ((unsigned long)s & D_MASK_DATA);
  return (long) ((unsigned long)s | ~D_MASK_DATA);
}


/* Make a new symbol */
long
symb_make(char *p)
{
  int  i, s;

  for (i = 0; i != NSYMBS-1; i++){
    if ((t_symb_pname[i] != NULL) && (strcmp(p, t_symb_pname[i]) == 0))
      return i;
  }

  s = t_symb_free;
  t_symb_free++;
  if (t_symb_free == NSYMBS){
    printf(errmsg_no_memory);
    quit();
  }

  t_symb_pname[s] = &t_pnames[t_pnames_free];
  t_symb_val[s]   = TAG_UNDEF;   /* undefined value */
  t_symb_fval[s]  = TAG_UNDEF;   /* undefined value */
  t_symb_ftype[s] = FTYPE_UNDEF; /* undefined type */

  do {
    if (t_pnames_free == PNAME_SIZE){
      printf(errmsg_no_memory);
      quit();
    }
    t_pnames[t_pnames_free] = tolower(*p); t_pnames_free++; p++;
  } while (*p != '\0');
  t_pnames[t_pnames_free] = '\0'; t_pnames_free++;

  return (TAG_SYMB | s);
}

/* END */
