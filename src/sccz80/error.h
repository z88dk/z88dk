/* error.c */
extern int endst(void);
extern void illname(char *sname);
extern void multidef(void);
extern void needtoken(char *str);
extern void needchar(char c);
extern void needlval(void);
extern void warning(int num,...);
extern void debug(int num,char *str,...);
extern void error(int num,...);

struct warnings {
        char *warn;
        char suppress;
};



extern struct warnings mywarn[];

/*
 *      Warning and error values
 */

enum warnct {
        W_NOWARN=0, W_2FAFUNC,W_2MAFUNC,W_2MADECL,W_DIFFTYPE, 
        W_DIFFTYPE2, W_DIFFTYPE3, W_RETINT,

        W_INTPTR, W_PTRINT, W_EQSG, W_OPSG, W_FARNR, W_PTRTYP,

        W_EXPCOM, W_EXPQT, W_EXPAPO, W_EXPSEMI, W_UNTERM, W_PRAGMA,
        
        W_FAR, W_INIT2LONG, W_BADDECL, W_BADSTC, W_ASSPTR,

        W_SIZEOF, W_EXPARG, W_INTDOUB, W_VOID,

        W_BUG1, W_BUG2, W_BITFIELD,

        W_DIVZERO, W_FUNC_NO_PROTO, W_PTRTYP1, W_PTRTYP2,

        W_PRELIM, W_TYPEDEF, W_LONGDOUB, W_CONST, W_VOLATILE, W_ELLIP,

        W_FLTPRINTF, W_SIGNARG, W_AUTO, W_NULLARRAY, W_UNREACH,

	W_ESCAPE, W_INTERNAL, W_HEXESCAPE_TOO_LONG, W_UNINITIALISED_VARIABLE,

        W_CALLINGCONVENTION_MISMATCH, W_DOUBLE_UNEXPECTED, W_PARAM_CALLINGCONVENTION_MISMATCH, W_LEFTSHIFT_TOO_BIG,

        W_MAXIMUM   };


enum errorct {
        E_NOERR=0,
        E_EOF, E_ZCCOPT, E_NEST, E_INCLUDE, E_TOOLONG, E_OUTERR,

        E_DBOV, E_LITQOV, E_STGOV, E_MACOV, E_GLBOV, E_LOCOV, E_MEMOV,
        E_STROV,

        E_INDIRECTION, E_NEGATIVE, E_SWITCH, E_CASE, E_DEFAULT,
        E_WHILE, E_CONTEXT,
        E_ASSIGN, E_DDECL, E_DECLSW, E_DECLST,

        E_ILLEGAL, E_PAREN, E_ARGNAME, E_BADARG, E_EXPARGS, E_DATA,
        E_DEFINED, E_LVALUE, E_ADDRESS, E_SUBSCRIPT, E_MEMBER,
        E_UNMEMB, E_UNSTR, E_SYMNAME, E_BRACKET, E_TOKEN, E_UNSYMB,
        E_ARGMIS1, E_ARGMIS2, E_NEEDCHAR,

        E_EXPON, E_FLOATING, E_EXPRESSION, E_DEREF, E_INTOPER, E_CONSTANT,
        E_ENUMDEF,

        E_MISSIF, E_MAXLEVELS, E_MAXGOTO, E_UNGOTO, E_AUTOASSIGN,

        E_CHANGING_CONST, E_STATIC_DOUBLE_STRING, E_PORT_DEREF,

        E_MAXIMUM
};
