/*  $Id: cppdef.h,v 1.6 2016-03-29 11:44:18 dom Exp $  */

#define	TRUE			1
#define	FALSE			0

#define	SYS_UNKNOWN		0
#define	SYS_UNIX		1
#define	SYS_VMS			2
#define	SYS_RSX			3
#define	SYS_RT11		4
#define	SYS_LATTICE		5
#define	SYS_ONYX		6
#define	SYS_68000		7

#define HOST			SYS_UNIX
#define TARGET			SYS_UNIX
#define LINE_PREFIX		""
#define MSG_PREFIX		"cpp: "
#define FILE_LOCAL		static
#define OK_DOLLAR		FALSE
#define OK_CONCAT		TRUE

/*
 * RECURSION_LIMIT may be set to -1 to disable the macro recursion test.
 */
#ifndef	RECURSION_LIMIT
#define	RECURSION_LIMIT	1000
#endif

/*
 * BITS_CHAR may be defined to set the number of bits per character.
 * it is needed only for multi-byte character constants.
 */
#ifndef	BITS_CHAR
#define	BITS_CHAR		8
#endif

/*
 * BIG_ENDIAN is set TRUE on machines (such as the IBM 360 series)
 * where 'ab' stores 'a' in the high-bits and 'b' in the low-bits.
 * It is set FALSE on machines (such as the PDP-11 and Vax-11)
 * where 'ab' stores 'a' in the low-bits and 'b' in the high-bits.
 * (Or is it the other way around?) -- Warning: BIG_ENDIAN code is untested.
 */
#ifndef	BIG_ENDIAN
#define	BIG_ENDIAN 		FALSE
#endif

/*
 * COMMENT_INVISIBLE may be defined to allow "old-style" comment
 * processing, whereby the comment becomes a zero-length token
 * delimiter.  This permitted tokens to be concatenated in macro
 * expansions.  This was removed from the Draft Ansi Standard.
 */
#ifndef	COMMENT_INVISIBLE
#define	COMMENT_INVISIBLE	FALSE
#endif

/*
 * STRING_FORMAL may be defined to allow recognition of macro parameters
 * anywhere in replacement strings.  This was removed from the Draft Ansi
 * Standard and a limited recognition capability added.
 */
#ifndef	STRING_FORMAL
#define	STRING_FORMAL		FALSE
#endif

/*
 * OK_DOLLAR enables use of $ as a valid "letter" in identifiers.
 * This is a permitted extension to the Ansi Standard and is required
 * for e.g., VMS, RSX-11M, etc.   It should be set FALSE if cpp is
 * used to preprocess assembler source on Unix systems.  OLD_PREPROCESSOR
 * sets OK_DOLLAR FALSE for that reason.
 */
#ifndef	OK_DOLLAR
#define	OK_DOLLAR		TRUE
#endif

/*
 * OK_CONCAT enables (one possible implementation of) token concatenation.
 * If cpp is used to preprocess Unix assembler source, this should be
 * set FALSE as the concatenation character, #, is used by the assembler.
 */
#ifndef	OK_CONCAT
#define	OK_CONCAT		TRUE
#endif

/*
 * OK_DATE may be enabled to predefine today's date as a string
 * at the start of each compilation.  This is apparently not permitted
 * by the Draft Ansi Standard.
 */
#ifndef	OK_DATE
#define	OK_DATE		TRUE
#endif

/*
 * Some common definitions.
 */

#ifndef	DEBUG
#define	DEBUG			FALSE
#endif

/*
 * The following definitions are used to allocate memory for
 * work buffers.  In general, they should not be modified
 * by implementors.
 *
 * PAR_MAC	The maximum number of #define parameters (31 per Standard)
 *		Note: we need another one for strings.
 * IDMAX	The longest identifier, 31 per Ansi Standard
 * NBUFF	Input buffer size
 * NWORK	Work buffer size -- the longest macro
 *		must fit here after expansion.
 * NEXP		The nesting depth of #if expressions
 * NINCLUDE	The number of directories that may be specified
 *		on a per-system basis, or by the -I option.
 * BLK_NEST	The number of nested #if's permitted.
 */

#ifndef IDMAX
#define	IDMAX			 255
#endif
#define	PAR_MAC		   (31 + 1)
#define	NBUFF			4096
#define	NWORK			4096
#define	NEXP			128
#define	NINCLUDE		 15
#define	NPARMWORK		(NWORK * 2)
#define	BLK_NEST		32

/*
 * Some special constants.  These may need to be changed if cpp
 * is ported to a wierd machine.
 *
 * NOTE: if cpp is run on a non-ascii machine, ALERT and VT may
 * need to be changed.  They are used to implement the proposed
 * ANSI standard C control characters '\a' and '\v' only.
 * DEL is used to tag macro tokens to prevent #define foo foo
 * from looping.  Note that we don't try to prevent more elaborate
 * #define loops from occurring.
 */

#ifndef	ALERT
#define	ALERT			'\007'		/* '\a' is "Bell"	*/
#endif

#ifndef	VT
#define	VT			'\013'		/* Vertical Tab CTRL/K	*/
#endif
