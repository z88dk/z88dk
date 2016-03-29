/*
 *				C P P 3 . C
 *
 *		    File open and command line options
 *
 * $Id: cpp3.c,v 1.6 2016-03-29 11:44:18 dom Exp $
 *
 *
 * Edit history
 * 13-Nov-84	MM	Split from cpp1.c
 *
 */

#include	<stdio.h>
#include	<ctype.h>
#include	<time.h>
#include	<stdlib.h>
#include	<string.h>
#include	"cppdef.h"
#include	"cpp.h"
#if DEBUG && (HOST == SYS_VMS || HOST == SYS_UNIX)
#include	<signal.h>
extern void	abort();		/* For debugging		*/
#endif

int
openfile(filename)
char		*filename;
/*
 * Open a file, add it to the linked list of open files.
 * This is called only from openfile() above.
 */
{
	register FILE		*fp;

	if ((fp = fopen(filename, "r")) == NULL) {
#if DEBUG
	    perror(filename);
#endif
	    return (FALSE);
	}
#if DEBUG
	if (debug)
	    fprintf(stderr, "Reading from \"%s\"\n", filename);
#endif
	addfile(fp, filename);
	return (TRUE);
}

void addfile(fp, filename)
FILE		*fp;			/* Open file pointer		*/
char		*filename;		/* Name of the file		*/
/*
 * Initialize tables for this open file.  This is called from openfile()
 * above (for #include files), and from the entry to cpp to open the main
 * input file.  It calls a common routine, getfile() to build the FILEINFO
 * structure which is used to read characters.  (getfile() is also called
 * to setup a macro replacement.)
 */
{
	register FILEINFO	*file;
	extern FILEINFO		*getfile();

	file = getfile(NBUFF, filename);
	file->fp = fp;			/* Better remember FILE *	*/
	file->buffer[0] = EOS;		/* Initialize for first read	*/
	line = 1;			/* Working on line 1 now	*/
	wrongline = TRUE;		/* Force out initial #line	*/
}

void setincdirs()
/*
 * Append system-specific directories to the include directory list.
 * Called only when cpp is started.
 */
{

#ifdef	CPP_INCLUDE
	*incend++ = CPP_INCLUDE;
#define	IS_INCLUDE	1
#else
#define	IS_INCLUDE	0
#endif

/* My own Amiga hack...  Look for includes in progdir:include */
#ifdef AMIGA
	*incend++ = "zcc:include";
#define	MAXINCLUDE	(NINCLUDE - 1 - IS_INCLUDE)
#endif

#if 0
#if HOST == SYS_UNIX
	*incend++ = "/usr/include";
#define	MAXINCLUDE	(NINCLUDE - 1 - IS_INCLUDE)
#endif
#endif

#if HOST == SYS_VMS
	extern char	*getenv();

	if (getenv("C$LIBRARY") != NULL)
	    *incend++ = "C$LIBRARY:";
	*incend++ = "SYS$LIBRARY:";
#define	MAXINCLUDE	(NINCLUDE - 2 - IS_INCLUDE)
#endif

#if HOST == SYS_RSX
	extern int	$$rsts;			/* TRUE on RSTS/E	*/
	extern int	$$pos;			/* TRUE on PRO-350 P/OS	*/
	extern int	$$vms;			/* TRUE on VMS compat.	*/

	if ($$pos) {				/* P/OS?		*/
	    *incend++ = "SY:[ZZDECUSC]";	/* C #includes		*/
	    *incend++ = "LB:[1,5]";		/* RSX library		*/
	}
	else if ($$rsts) {			/* RSTS/E?		*/
	    *incend++ = "SY:@";			/* User-defined account	*/
	    *incend++ = "C:";			/* Decus-C library	*/
	    *incend++ = "LB:[1,1]";		/* RSX library		*/
	}
	else if ($$vms) {			/* VMS compatibility?	*/
	    *incend++ = "C:";
	}
	else {					/* Plain old RSX/IAS	*/
	    *incend++ = "LB:[1,1]";
	}
#define	MAXINCLUDE	(NINCLUDE - 3 - IS_INCLUDE)
#endif

#if HOST == SYS_RT11
	extern int	$$rsts;			/* RSTS/E emulation?	*/

	if ($$rsts)
	    *incend++ = "SY:@";			/* User-defined account	*/
	*incend++ = "C:";			/* Decus-C library disk	*/
	*incend++ = "SY:";			/* System (boot) disk	*/
#define	MAXINCLUDE	(NINCLUDE - 3 - IS_INCLUDE)
#endif
#ifndef MAXINCLUDE
#define	MAXINCLUDE	(NINCLUDE - 0 - IS_INCLUDE)
#endif
}

int
dooptions(argc, argv)
int		argc;
char		*argv[];
/*
 * dooptions is called to process command line arguments (-Detc).
 * It is called only at cpp startup.
 */
{
	register char		*ap;
	register DEFBUF		*dp;
	register int		c;
	int			i, j;
	char			*arg;
	SIZES			*sizp;		/* For -S		*/
	int			size;		/* For -S		*/
	int			isdatum;	/* FALSE for -S*	*/
	int			endtest;	/* For -S		*/

	for (i = j = 1; i < argc; i++) {
	    arg = ap = argv[i];
	    if (*ap++ != '-' || *ap == EOS)
		argv[j++] = argv[i];
	    else {
		c = *ap++;			/* Option byte		*/
		if (islower(c))			/* Normalize case	*/
		    c = toupper(c);
		switch (c) {			/* Command character	*/
		case 'C':			/* Keep comments	*/
		    cflag = TRUE;
		    keepcomments = TRUE;
		    break;

		case 'D':			/* Define symbol	*/
#if HOST != SYS_UNIX
		    zap_uc(ap);			/* Force define to U.C.	*/
#endif
		    /*
		     * If the option is just "-Dfoo", make it -Dfoo=1
		     */
		    while (*ap != EOS && *ap != '=')
			ap++;
		    if (*ap == EOS)
			ap = "1";
		    else
			*ap++ = EOS;
		    /*
		     * Now, save the word and its definition.
		     */
		    dp = defendel(argv[i] + 2, FALSE);
		    dp->repl = savestring(ap);
		    dp->nargs = DEF_NOARGS;
		    break;

		case 'E':			/* Ignore non-fatal	*/
		    eflag = TRUE;		/* errors.		*/
		    break;

		case 'P':			/* No #line 		*/
		    pflag = TRUE;
		    break;
		case 'I':			/* Include directory	*/
		    if (incend >= &incdir[MAXINCLUDE])
			cfatal("Too many include directories", NULLST);
		    *incend++ = ap;
		    break;

		case 'N':			/* No predefineds	*/
		    nflag++;			/* Repeat to undefine	*/
		    break;			/* __LINE__, etc.	*/

		case 'S':
		    sizp = size_table;
		    if ( (isdatum = (*ap != '*')) != 0  )	/* If it's just -S,	*/
			endtest = T_FPTR;	/* Stop here		*/
		    else {			/* But if it's -S*	*/
			ap++;			/* Step over '*'	*/
			endtest = 0;		/* Stop at end marker	*/
		    }
		    while (sizp->bits != endtest && *ap != EOS) {
			if (!isdigit(*ap)) {	/* Skip to next digit	*/
			    ap++;
			    continue;
			}
			size = 0;		/* Compile the value	*/
			while (isdigit(*ap)) {
			    size *= 10;
			    size += (*ap++ - '0');
			}
			if (isdatum)
			    sizp->size = size;	/* Datum size		*/
			else
			    sizp->psize = size;	/* Pointer size		*/
			sizp++;
		    }
		    if (sizp->bits != endtest)
			cwarn("-S, too few values specified in %s", argv[i]);
		    else if (*ap != EOS)
			cwarn("-S, too many values, \"%s\" unused", ap);
		    break;

		case 'U':			/* Undefine symbol	*/
#if HOST != SYS_UNIX
		    zap_uc(ap);
#endif
		    if (defendel(ap, TRUE) == NULL)
			cwarn("\"%s\" wasn't defined", ap);
		    break;

#if DEBUG
		case 'X':			/* Debug		*/
		    debug = (isdigit(*ap)) ? atoi(ap) : 1;
#if (HOST == SYS_VMS || HOST == SYS_UNIX)
		    signal(SIGINT, abort);	/* Trap "interrupt"	*/
#endif
		    fprintf(stderr, "Debug set to %d\n", debug);
		    break;
#endif

		default:			/* What is this one?	*/
		    cwarn("Unknown option \"%s\"", arg);
		    fprintf(stderr, "The following options are valid:\n"
                    "  -C\t\t\tWrite source file comments to output\n"
                    "  -Dsymbol=value\tDefine a symbol with the given (optional) value\n"
                    "  -Idirectory\t\tAdd a directory to the #include search list\n"
                    "  -N\t\t\tDon't predefine target-specific names\n"
                    "  -Stext\t\tSpecify sizes for #if sizeof\n"
                    "  -Usymbol\t\tUndefine symbol\n"
		    "  -P\t\t\tDon't produce # lines\n");
#if DEBUG
		    fprintf(stderr, "  -Xvalue\t\tSet internal debug flag\n");
#endif
		    break;
		}			/* Switch on all options	*/
	    }				/* If it's a -option		*/
	}				/* For all arguments		*/
	if (j > 3) {
	    cerror(
		"Too many file arguments.  Usage: cpp [input [output]]",
		NULLST);
	}
	return (j);			/* Return new argc		*/
}

#if HOST != SYS_UNIX
FILE_LOCAL
zap_uc(ap)
register char	*ap;
/*
 * Dec operating systems mangle upper-lower case in command lines.
 * This routine forces the -D and -U arguments to uppercase.
 * It is called only on cpp startup by dooptions().
 */
{
	while (*ap != EOS) {
	    /*
	     * Don't use islower() here so it works with Multinational
	     */
	    if (*ap >= 'a' && *ap <= 'z')
		*ap = toupper(*ap);
	    ap++;
	}
}
#endif

void initdefines()
/*
 * Initialize the built-in #define's.  There are two flavors:
 * 	#define decus	1		(static definitions)
 *	#define	__FILE__ ??		(dynamic, evaluated by magic)
 * Called only on cpp startup.
 *
 * Note: the built-in static definitions are supressed by the -N option.
 * __LINE__, __FILE__, __DATE__ and __TIME__ are always present.
 */
{
	register char		**pp;
	register char		*tp;
	register DEFBUF		*dp;
	int			i;
	time_t			tvec;
	struct tm		*tmp;

	/*
	 * Predefine the built-in symbols.  Allow the
	 * implementor to pre-define a symbol as "" to
	 * eliminate it.
	 */
	if (nflag == 0) {
	    for (pp = preset; *pp != NULL; pp++) {
		if (*pp[0] != EOS) {
		    dp = defendel(*pp, FALSE);
		    dp->repl = savestring("1");
		    dp->nargs = DEF_NOARGS;
		}
	    }
	}
	/*
	 * The magic pre-defines (__FILE__ and __LINE__ are
	 * initialized with negative argument counts.  expand()
	 * notices this and calls the appropriate routine.
	 * DEF_NOARGS is one greater than the first "magic" definition.
	 */
	if (nflag < 2) {
	    for (pp = magic, i = DEF_NOARGS; *pp != NULL; pp++) {
		dp = defendel(*pp, FALSE);
		dp->nargs = --i;
	    }
#if OK_DATE
	    /*
	     * Define __DATE__ as today's date.
	     */
	    dp = defendel("__DATE__", FALSE);
	    dp->repl = tp = getmem(14);
	    dp->nargs = DEF_NOARGS;
            time(&tvec);
	    tmp=localtime(&tvec);
	    strftime(tp, 14,"\"%b %d %Y\"",tmp);
            /*
             * Define __TIME__ as current time.
             */
            dp = defendel("__TIME__", FALSE);
            dp->repl = tp = getmem(10);
            dp->nargs = DEF_NOARGS;
            tp[0] = '"';
            tp[1] = '0'+tmp->tm_hour/10;
            tp[2] = '0'+tmp->tm_hour%10;
            tp[3] = ':';
            tp[4] = '0'+tmp->tm_min/10;
            tp[5] = '0'+tmp->tm_min%10;
            tp[6] = ':';
            tp[7] = '0'+tmp->tm_sec/10;
            tp[8] = '0'+tmp->tm_sec%10;
            tp[9] = '"';
#endif
	}
}

#if HOST == SYS_VMS
/*
 * getredirection() is intended to aid in porting C programs
 * to VMS (Vax-11 C) which does not support '>' and '<'
 * I/O redirection.  With suitable modification, it may
 * useful for other portability problems as well.
 */

int
getredirection(argc, argv)
int		argc;
char		**argv;
/*
 * Process vms redirection arg's.  Exit if any error is seen.
 * If getredirection() processes an argument, it is erased
 * from the vector.  getredirection() returns a new argc value.
 *
 * Warning: do not try to simplify the code for vms.  The code
 * presupposes that getredirection() is called before any data is
 * read from stdin or written to stdout.
 *
 * Normal usage is as follows:
 *
 *	main(argc, argv)
 *	int		argc;
 *	char		*argv[];
 *	{
 *		argc = getredirection(argc, argv);
 *	}
 */
{
	register char		*ap;	/* Argument pointer	*/
	int			i;	/* argv[] index		*/
	int			j;	/* Output index		*/
	int			file;	/* File_descriptor 	*/
	extern int		errno;	/* Last vms i/o error 	*/

	for (j = i = 1; i < argc; i++) {   /* Do all arguments	*/
	    switch (*(ap = argv[i])) {
	    case '<':			/* <file		*/
		if (freopen(++ap, "r", stdin) == NULL) {
		    perror(ap);		/* Can't find file	*/
		    exit(errno);	/* Is a fatal error	*/
		}
		break;

	    case '>':			/* >file or >>file	*/
		if (*++ap == '>') {	/* >>file		*/
		    /*
		     * If the file exists, and is writable by us,
		     * call freopen to append to the file (using the
		     * file's current attributes).  Otherwise, create
		     * a new file with "vanilla" attributes as if the
		     * argument was given as ">filename".
		     * access(name, 2) returns zero if we can write on
		     * the specified file.
		     */
		    if (access(++ap, 2) == 0) {
			if (freopen(ap, "a", stdout) != NULL)
			    break;	/* Exit case statement	*/
			perror(ap);	/* Error, can't append	*/
			exit(errno);	/* After access test	*/
		    }			/* If file accessable	*/
		}
		/*
		 * On vms, we want to create the file using "standard"
		 * record attributes.  creat(...) creates the file
		 * using the caller's default protection mask and
		 * "variable length, implied carriage return"
		 * attributes. dup2() associates the file with stdout.
		 */
		if ((file = creat(ap, 0, "rat=cr", "rfm=var")) == -1
		 || dup2(file, fileno(stdout)) == -1) {
		    perror(ap);		/* Can't create file	*/
		    exit(errno);	/* is a fatal error	*/
		}			/* If '>' creation	*/
		break;			/* Exit case test	*/

	    default:
		argv[j++] = ap;		/* Not a redirector	*/
		break;			/* Exit case test	*/
	    }
	}				/* For all arguments	*/
	argv[j] = NULL;			/* Terminate argv[]	*/
	return (j);			/* Return new argc	*/
}
#endif



