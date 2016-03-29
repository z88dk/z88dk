/*
 * CPP main program.
 *
 * $Id: cpp1.c,v 1.5 2016-03-29 11:44:18 dom Exp $
 *
 *
 * Edit history
 * 21-May-84	MM	"Field test" release
 * 23-May-84	MM	Some minor hacks.
 * 30-May-84	ARF	Didn't get enough memory for __DATE__
 *			Added code to read stdin if no input
 *			files are provided.
 * 29-Jun-84	MM	Added ARF's suggestions, Unixifying cpp.
 * 11-Jul-84	MM	"Official" first release (that's what I thought!)
 * 22-Jul-84	MM/ARF/SCK Fixed line number bugs, added cpp recognition
 *			of #line, fixed problems with #include.
 * 23-Jul-84	MM	More (minor) include hacking, some documentation.
 *			Also, redid cpp's #include files
 * 25-Jul-84	MM	#line filename isn't used for #include searchlist
 *			#line format is <number> <optional name>
 * 25-Jul-84	ARF/MM	Various bugs, mostly serious.  Removed homemade doprint
 * 01-Aug-84	MM	Fixed recursion bug, remove extra newlines and
 *			leading whitespace from cpp output.
 * 02-Aug-84	MM	Hacked (i.e. optimized) out blank lines and unneeded
 *			whitespace in general.  Cleaned up unget()'s.
 * 03-Aug-84	Keie	Several bug fixes from Ed Keizer, Vrije Universitet.
 *			-- corrected arg. count in -D and pre-defined
 *			macros.  Also, allow \n inside macro actual parameter
 *			lists.
 * 06-Aug-84	MM	If debugging, dump the preset vector at startup.
 * 12-Aug-84	MM/SCK	Some small changes from Sam Kendall
 * 15-Aug-84	Keie/MM	cerror, cwarn, etc. take a single string arg.
 *			cierror, etc. take a single int. arg.
 *			changed LINE_PREFIX slightly so it can be
 *			changed in the makefile.
 * 31-Aug-84	MM	USENET net.sources release.
 *  7-Sep-84	SCH/ado Lint complaints
 * 10-Sep-84	Keie	Char's can't be signed in some implementations
 * 11-Sep-84	ado	Added -C flag, pathological line number fix
 * 13-Sep-84	ado	Added -E flag (does nothing) and "-" file for stdin.
 * 14-Sep-84	MM	Allow # 123 as a synonym for #line 123
 * 19-Sep-84	MM	scanid always reads to token, make sure #line is
 *			written to a new line, even if -C switch given.
 *			Also, cpp - - reads stdin, writes stdout.
 * 03-Oct-84	ado/MM	Several changes to line counting and keepcomments
 *			stuff.  Also a rewritten control() hasher -- much
 *			simpler and no less "perfect". Note also changes
 *			in cpp3.c to fix numeric scanning.
 * 04-Oct-84	MM	Added recognition of macro formal parameters if
 *			they are the only thing in a string, per the
 *			draft standard.
 * 08-Oct-84	MM	One more attack on scannumber
 * 15-Oct-84	MM/ado	Added -N to disable predefined symbols.  Fixed
 *			linecount if COMMENT_INVISIBLE enabled.
 * 22-Oct-84	MM	Don't evaluate the #if/#ifdef argument if
 *			compilation is supressed.  This prevents
 *			unnecessary error messages in sequences such as
 *			    #ifdef FOO		-- undefined
 *			    #if FOO == 10	-- shouldn't print warning
 * 25-Oct-84	MM	Fixed bug in false ifdef supression.  On vms,
 *			#include <foo> should open foo.h -- this duplicates
 *			the behavior of Vax-C
 * 31-Oct-84	ado/MM	Parametized $ in indentifiers.  Added a better
 *			token concatenator and took out the trial
 *			concatenation code.  Also improved #ifdef code
 *			and cleaned up the macro recursion tester.
 *  2-Nov-84	MM/ado	Some bug fixes in token concatenation, also
 *			a variety of minor (uninteresting) hacks.
 *  6-Nov-84	MM	Happy Birthday.  Broke into 4 files and added
 *			#if sizeof (basic_types)
 *  9-Nov-84	MM	Added -S* for pointer type sizes
 * 13-Nov-84	MM	Split cpp1.c, added vms defaulting
 * 23-Nov-84	MM/ado	-E supresses error exit, added CPP_INCLUDE,
 *			fixed strncpy bug.
 *  3-Dec-84	ado/MM	Added OLD_PREPROCESSOR
 *  7-Dec-84	MM	Stuff in Nov 12 Draft Standard
 * 17-Dec-84	george	Fixed problems with recursive macros
 * 17-Dec-84	MM	Yet another attack on #if's (f/t)level removed.
 * 07-Jan-85	ado	Init defines before doing command line options
 *			so -Uunix works.
 * 11-Feb-94    MH      Changed token concatenation (hopefully) to ANSI 
 *                      standard and added token quoting.
 * 26-Nov-94    MH      -P problem of outputting a newline after leading
 *                      white space in order to correct counter if fixed 
 *                      now.  Several other fixes for -P, too.
 *
 */

#include	<stdio.h>
#include	<ctype.h>
#include	<stdlib.h>
#include	<string.h>
#include	"cppdef.h"
#include	"cpp.h"

#ifdef __MSDOS__
#ifdef __BORLANDC__
extern unsigned _stklen=8192U;	/* Default stack of 4096 is too small */
#endif
#endif



/*
 * Commonly used global variables:
 * line		is the current input line number.
 * wrongline	is set in many places when the actual output
 *		line is out of sync with the numbering, e.g,
 *		when expanding a macro with an embedded newline.
 *
 * token	holds the last identifier scanned (which might
 *		be a candidate for macro expansion).
 * errors	is the running cpp error counter.
 * infile	is the head of a linked list of input files (extended by
 *		#include and macros being expanded).  infile always points
 *		to the current file/macro.  infile->parent to the includer,
 *		etc.  infile->fd is NULL if this input stream is a macro.
 */
int		line;			/* Current line number		*/
int		wrongline;		/* Force #line to compiler	*/
char		token[IDMAX + 1];	/* Current input token		*/
int		errors;			/* cpp error counter		*/
FILEINFO	*infile = NULL;		/* Current input file		*/
#if DEBUG
int		debug;			/* TRUE if debugging now	*/
#endif
/*
 * This counter is incremented when a macro expansion is initiated.
 * If it exceeds a built-in value, the expansion stops -- this tests
 * for a runaway condition:
 *	#define X Y
 *	#define Y X
 *	X
 * This can be disabled by falsifying rec_recover.  (Nothing does this
 * currently: it is a hook for an eventual invocation flag.)
 */
int		recursion;		/* Infinite recursion counter	*/
int		rec_recover = TRUE;	/* Unwind recursive macros	*/

/*
 * instring is set TRUE when a string is scanned.  It modifies the
 * behavior of the "get next character" routine, causing all characters
 * to be passed to the caller (except <DEF_MAGIC>).  Note especially that
 * comments and \<newline> are not removed from the source.  (This
 * prevents cpp output lines from being arbitrarily long).
 *
 * inmacro is set by #define -- it absorbs comments and converts
 * form-feed and vertical-tab to space, but returns \<newline>
 * to the caller.  Strictly speaking, this is a bug as \<newline>
 * shouldn't delimit tokens, but we'll worry about that some other
 * time -- it is more important to prevent infinitly long output lines.
 *
 * instring and inmarcor are parameters to the get() routine which
 * were made global for speed.
 */
int		instring = FALSE;	/* TRUE if scanning string	*/
int		inmacro = FALSE;	/* TRUE if #defining a macro	*/

/*
 * work[] and workp are used to store one piece of text in a temporay
 * buffer.  To initialize storage, set workp = work.  To store one
 * character, call save(c);  (This will fatally exit if there isn't
 * room.)  To terminate the string, call save(EOS).  Note that
 * the work buffer is used by several subroutines -- be sure your
 * data won't be overwritten.  The extra byte in the allocation is
 * needed for string formal replacement.
 */
char		work[NWORK + 1];	/* Work buffer			*/
char		*workp;			/* Work buffer pointer		*/

/*
 * keepcomments is set TRUE by the -C option.  If TRUE, comments
 * are written directly to the output stream.  This is needed if
 * the output from cpp is to be passed to lint (which uses commands
 * embedded in comments).  cflag contains the permanent state of the
 * -C flag.  keepcomments is always falsified when processing #control
 * commands and when compilation is supressed by a false #if
 *
 * If eflag is set, CPP returns "success" even if non-fatal errors
 * were detected.
 *
 * If nflag is non-zero, no symbols are predefined except __LINE__.
 * __FILE__, and __DATE__.  If nflag > 1, absolutely no symbols
 * are predefined.
 */
int		keepcomments = FALSE;	/* Write out comments flag	*/
int		cflag = FALSE;		/* -C option (keep comments)	*/
int		eflag = FALSE;		/* -E option (never fail)	*/
int		nflag = 0;		/* -N option (no predefines)	*/
int		pflag = 0;		/* -P option (no #line)		*/

/*
 * ifstack[] holds information about nested #if's.  It is always
 * accessed via *ifptr.  The information is as follows:
 *	WAS_COMPILING	state of compiling flag at outer level.
 *	ELSE_SEEN	set TRUE when #else seen to prevent 2nd #else.
 *	TRUE_SEEN	set TRUE when #if or #elif succeeds
 * ifstack[0] holds the compiling flag.  It is TRUE if compilation
 * is currently enabled.  Note that this must be initialized TRUE.
 */
char		ifstack[BLK_NEST] = { TRUE };	/* #if information	*/
char		*ifptr = ifstack;		/* -> current ifstack[] */

/*
 * incdir[] stores the -i directories (and the system-specific
 * #include <...> directories.
 */
char	*incdir[NINCLUDE];		/* -i directories		*/
char	**incend = incdir;		/* -> free space in incdir[]	*/

/*
 * This is the table used to predefine target machine and operating
 * system designators.  It may need hacking for specific circumstances.
 * Note: it is not clear that this is part of the Ansi Standard.
 * The -N option supresses preset definitions.
 */
char	*preset[] = {			/* names defined at cpp start	*/
#ifdef	MACHINE
	MACHINE,
#endif
#ifdef	SYSTEM
	SYSTEM,
#endif
#ifdef	COMPILER
	COMPILER,
#endif
#if	DEBUG
	"decus_cpp",			/* Ourselves!			*/
#endif
	NULL				/* Must be last			*/
};

/*
 * The value of these predefined symbols must be recomputed whenever
 * they are evaluated.  The order must not be changed.
 */
char	*magic[] = {			/* Note: order is important	*/
	"__LINE__",
	"__FILE__",
	NULL				/* Must be last			*/
};

FILE_LOCAL void cppmain();
FILE_LOCAL void sharp();

int main(argc, argv)
int		argc;
char		*argv[];
{
	register int	i;

#if HOST == SYS_VMS
	argc = getredirection(argc, argv);	/* vms >file and <file	*/
#endif
	initdefines();				/* O.S. specific def's	*/
	i = dooptions(argc, argv);		/* Command line -flags	*/
	switch (i) {
	case 3:
	    /*
	     * Get output file, "-" means use stdout.
	     */
	    if (!streq(argv[2], "-")) {
#if HOST == SYS_VMS
		/*
		 * On vms, reopen stdout with "vanilla rms" attributes.
		 */
		if ((i = creat(argv[2], 0, "rat=cr", "rfm=var")) == -1
		 || dup2(i, fileno(stdout)) == -1) {
#else
		if (freopen(argv[2], "w", stdout) == NULL) {
#endif
		    perror(argv[2]);
		    cerror("Can't open output file `%s'", argv[2]);
		    exit(IO_ERROR);
		}
	    }				/* Continue by opening input	*/
	case 2:				/* One file -> stdin		*/
	    /*
	     * Open input file, "-" means use stdin.
	     */
	    if (!streq(argv[1], "-")) {
		if (freopen(argv[1], "r", stdin) == NULL) {
		    perror(argv[1]);
		    cerror("Can't open input file `%s'", argv[1]);
		    exit(IO_ERROR);
		}
		strcpy(work, argv[1]);	/* Remember input filename	*/
		break;
	    }				/* Else, just get stdin		*/
	case 0:				/* No args?			*/
	case 1:				/* No files, stdin -> stdout	*/
#if HOST == SYS_UNIX
	    work[0] = EOS;		/* Unix can't find stdin name	*/
#else
	    fgetname(stdin, work);	/* Vax-11C, Decus C know name	*/
#endif
	    break;

	default:
	    exit(IO_ERROR);		/* Can't happen			*/
	}
	setincdirs();			/* Setup -I include directories	*/
	addfile(stdin, work);		/* "open" main input file	*/
#if DEBUG
	if (debug > 0)
	    dumpdef("preset #define symbols");
#endif
	cppmain();			/* Process main file		*/
	if ((i = (ifptr - &ifstack[0])) != 0) {
#if OLD_PREPROCESSOR
	    ciwarn("Inside #ifdef block at end of input, depth = %d", i);
#else
	    cierror("Inside #ifdef block at end of input, depth = %d", i);
#endif
	}
	fclose(stdout);
	if (errors > 0) {
	    fprintf(stderr, (errors == 1)
		? "%d error in preprocessor\n"
		: "%d errors in preprocessor\n", errors);
	    if (!eflag)
		exit(IO_ERROR);
	}
	exit(IO_NORMAL);		/* No errors or -E option set	*/
}

FILE_LOCAL
void cppmain()
/*
 * Main process for cpp -- copies tokens from the current input
 * stream (main file, include file, or a macro) to the output
 * file.
 */
{
	register int		c;		/* Current character	*/
	register int		counter;	/* newlines and spaces	*/

	/*
	 * Explicitly output a #line at the start of cpp output so
	 * that lint (etc.) knows the name of the original source
	 * file.  If we don't do this explicitly, we may get
	 * the name of the first #include file instead.
	 * We also seem to need a blank line following that first #line.
	 */
	sharp();
	output('\n');
	/*
	 * This loop is started "from the top" at the beginning of each line
	 * wrongline is set TRUE in many places if it is necessary to write
	 * a #line record.  (But we don't write them when expanding macros.)
	 *
	 * The counter variable has two different uses:  at
	 * the start of a line, it counts the number of blank lines that
	 * have been skipped over.  These are then either output via
	 * #line records or by outputting explicit blank lines.
 	 * When expanding tokens within a line, the counter remembers
	 * whether a blank/tab has been output.  These are dropped
	 * at the end of the line, and replaced by a single blank
	 * within lines.
	 */
	for (;;) {
	    counter = 0;			/* Count empty lines	*/
	    for (;;) {				/* For each line, ...	*/
		while (type[(c = get())] == SPA)/* Skip leading blanks	*/
		    if (pflag && compiling)	/* in this line.	*/
			output(c);
		if (c == '\n')			/* If line's all blank,	*/
		    if (pflag)			/* Do nothing now	*/
			output('\n');
		    else ++counter;
		else if (c == '#') {		/* Is 1st non-space '#'	*/
		    keepcomments = FALSE;	/* Don't pass comments	*/
		    counter = control(counter);	/* Yes, do a #command	*/
		    if (pflag)			/* Output missing \n    */
			while (counter>0) { output('\n'); --counter; }
		    keepcomments = (cflag && compiling);
		}
		else if (c == EOF_CHAR)		/* At end of file?	*/
		    break;
		else if (!compiling) {		/* #ifdef false?	*/
		    skipnl();			/* Skip to newline	*/
		    if (pflag) 
			output('\n');		/* Output blank line    */
		    else counter++;		/* Count it, too.	*/
		}
		else {
		    break;			/* Actual token		*/
		}
	    }
	    if (c == EOF_CHAR)			/* Exit process at	*/
		break;				/* End of file		*/
	    /*
	     * If the loop didn't terminate because of end of file, we
	     * know there is a token to compile.  First, clean up after
	     * absorbing newlines.  counter has the number we skipped.
	     */
	    if ((wrongline && infile->fp != NULL) || counter > 4)
		sharp();			/* Output # line number	*/
	    else {				/* If just a few, stuff	*/
		while (--counter >= 0)		/* them out ourselves	*/
		    output('\n');
	    }
	    /*
	     * Process each token on this line.
	     */
	    unget();				/* Reread the char.	*/
	    for (;;) {				/* For the whole line,	*/
		do {				/* Token concat. loop	*/
		    for (counter = 0; type[(c = get())] == SPA;) {
			if (pflag) output(c);
			else {
#if COMMENT_INVISIBLE
			    if (c != COM_SEP)
			        counter++;
#else
			    counter++;		/* Skip over blanks	*/
#endif
			}
		    }
		    if (c == EOF_CHAR || c == '\n')
			goto end_line;		/* Exit line loop	*/
		    else if (counter > 0)	/* If we got any spaces	*/
			output(' ');		/* Output one space	*/
		    c = macroid(c);		/* Grab the token	*/
		} while (type[c] == LET && catenate());
		if (c == EOF_CHAR || c == '\n')	/* From macro exp error	*/
		    goto end_line;		/* Exit line loop	*/
		switch (type[c]) {
		case LET:
		    output(*token); fputs(token+1, stdout);	/* Quite ordinary token	*/
		    break;


		case DIG:			/* Output a number	*/
		case DOT:			/* Dot may begin floats	*/
		    scannumber(c, output);
		    break;

		case QUO:			/* char or string const	*/
		    scanstring(c, output);	/* Copy it to output	*/
		    break;

		default:			/* Some other character	*/
		    output(c);			/* Just output it	*/
		    break;
		}				/* Switch ends		*/
	    }					/* Line for loop	*/
end_line:   if (c == '\n') {			/* Compiling at EOL?	*/
		output('\n');			/* Output newline, if	*/
		if (infile->fp == NULL)		/* Expanding a macro,	*/
		    wrongline = TRUE;		/* Output # line later	*/
	    }
	}					/* Continue until EOF	*/
}

int join=0;

void output(c)
int		c;
/*
 * Output one character to stdout -- output() is passed as an
 * argument to scanstring()
 */
{
 	static int quote_quote=0;
 	
	if (c == DBL_QUOTE)
	    { if (join) { putchar('\\'); join=0; } putchar('"'); quote_quote=!quote_quote; }
	else if (c == '"')
	    { if (join) { putchar('\\'); join=0; } if (quote_quote) putchar('\\'); putchar('"'); }
	else if (c == '\\')
	    { if (join) { putchar('\\'); putchar('\\'); join=0; } else join=1; }
	else if (c=='\n')
	    { if (join==0) putchar('\n'); else wrongline=1; join=0; }
        else
#if COMMENT_INVISIBLE
	if (c != TOK_SEP && c != COM_SEP)
#else
	if (c != TOK_SEP)
#endif
	    { if (join) putchar('\\'); join=0; putchar(c); }
}

static char	*sharpfilename = NULL;

FILE_LOCAL
void sharp()
/*
 * Output a line number line.
 */
{
	register char		*name;

	if (keepcomments)			/* Make sure # comes on	*/
	    putchar('\n');			/* a fresh, new line.	*/
	if (pflag == 0) {
	    printf("#%s %d", LINE_PREFIX, line);
	    if (infile->fp != NULL) {
	        name = (infile->progname != NULL)
		    ? infile->progname : infile->filename;
	        if (sharpfilename == NULL
	        || (sharpfilename != NULL && !streq(name, sharpfilename))) {
		    if (sharpfilename != NULL)
		        free(sharpfilename);
		    sharpfilename = savestring(name);
		    output(' '); output('"'); fputs(name,stdout); output('"');
	        }
	    }
	    output('\n');
	}
	wrongline = FALSE;
}
