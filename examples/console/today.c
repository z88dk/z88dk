/*
 This program was found in a retro archive related to DEC machines publishing ancient tape dumps.  
 The tape header timestamp says 1982 but probably the program is older.
 
 This is a good example on how to use SCCZ80 to recover old K&R program and port them into newer systems.
 This file is an almost identical copy of the original archive, only a minimal adjustment to the time 
 functions was necessary.   SCCZ80 accept both K&R and recent function definitions, so the program can 
 be progressively changed and checked.
 After that this program will probably hit the Y2K bug, which will require more tuning on the target system OS,
 on the libraries or on the program itself, but the z88dk flexibility makes it less hard.
 
 z88dk is able to build a runnable program for many targets, but only few of them have a full clock hardware.
 E.g. in CP/M we provide support for a restricted range of machines:
 
 CPM 3.x  (aka "CPM+")
 MP/M 2.x and higher
 TurboDOS 1.2x, 1.3x, and, presumably, higher
 Epson PX4/PX8 (direct BIOS access) and all the CP/M 3 - like BIOSes
 
 Not (of course) CPM 1.x and 2.x, which have no real-time functions ,nor QX/M, its clock is not BCD based.

 Please check the clock() function implentation in {z88dk/}libsrc/time for further details.
 
*/

/*
-h- datetx.c	Mon Aug 09 21:08:52 1982	DATETX.C;14
#
 *              Convert Date to Readable Format.
 *
 * Synopsis:
 *
 *      char    *datetxt(buffer, year, month, day);
 *      char    *buffer;        -- Output string goes here
 *      int     year;           -- Year,        1979 = 1979
 *      int     month;          -- Month,       January = 1
 *      int     day;            -- Day,         1 = 1
 *
 * The readable date will be written into the outpub buffer, terminated by
 * a null byte.  datetxt returns a pointer to the null byte.
 *
 * External routines called:
 *
 *      nbrtxt          (Number to ascii conversion)
 *      copyst          (String copy routine)
 */

extern  char    *nbrtxt();
extern  char    *copyst();
extern  char    *datetxt();

static char *daynames[] = {
	"Sunday",                       /* Sunday is day zero           */
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
};

static char *monthnames[] = {
	"?Nomember?",                   /* Illegal month                */
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
};



dayofweek(year, month, day)
int     year;                                   /* Year, 1978 = 1978    */
int     month;                                  /* Month, January = 1   */
int     day;                                    /* Day of month, 1 = 1  */
/*
 * Return the day of the week on which this date falls: Sunday = 0.
 * Note, this routine is valid only for the Gregorian calender.
 */
{
	register int yearfactor;

	yearfactor = year + (month - 14)/12;
	return (( (13 * (month + 10 - (month + 10)/13*12) - 1)/5
		+ day + 77 + 5 * (yearfactor % 100)/4
		+ yearfactor / 400
		- yearfactor / 100 * 2) % 7);
}



char *datetxt(buffer, year, month, day)
char    *buffer;                        /* Output goes here             */
int     year;                           /* Year, 1979 = 1979            */
int     month;                          /* Month of year, Jan = 1       */
int     day;                            /* Day in the month 1 = 1       */
/*
 * Output the date in readable format:
 *      Tuesday, the third of October
 */
{
	register char   *op;                    /* Output pointer       */

	op = buffer;                            /* Setup output pointer */
	op = copyst(op, daynames[dayofweek(year, month, day)]);
	op = copyst(op, ", the ");
	op = nbrtxt(op, day, 1);
	op = copyst(op, " day of ");
	op = copyst(op, monthnames[(month < 0 || month > 12) ? 0 : month]);
	op = copyst(op, ", ");
	if (year < 1000 || year >= 2000)
		return(nbrtxt(op, year, 0));
	else {
		op = nbrtxt(op, year/100, 0);
		op = copyst(op, " ");
		if ((year = year % 100) == 0)
			return(copyst(op, "hundred"));
		else
			return(nbrtxt(op, year, 0));
	}
}




/*
-h- moontx.c	Mon Aug 09 21:08:52 1982	MOONTX.C;15
#
 *              Phase of the Moon Conversion.
 *
 * Synopsis
 *
 *      char    *moontxt(buffer, year, month, day)
 *      char    *buffer;        -- Output goes here.
 *      int     year;           -- Year         1979 = 1979
 *      int     month;          -- Month        Jan. = 1
 *      int     day;            -- Day          1    = 1
 *
 * The phase of the moon (in readable ascii) is written into the buffer,
 * followed by a null.  The routine returns a pointer to the trailing null.
 *
 * External routines called:
 *
 *      copyst		(String copy routine)
 */

extern char		*copyst();	/* String output routine        */

static char *phasetxt[] = {
	"new",
	"waxing crescent",
	"in its first quarter",
	"waxing gibbous",
	"full",
	"waning gibbous",
	"in its last quarter",
	"waning crescent"
};

static int day_year[] = {		/* Days in year for each month	*/
	-1, -1, 30, 58, 89, 119, 150, 180, 211, 241, 272, 303, 333
};					/* Note: Jan. 1 will equal zero	*/

char *moontxt(buffer, year, month, day)
char    *buffer;                        /* Where to put the text        */
int     year;                           /* Year, 1978 = 1978            */
int     month;                          /* Month, Jan = 1               */
int     day;                            /* Day, 1 = 1                   */
/*
 * Output the phase of the moon for the given year, month, day.
 * The routine calculates the year's epact (the age of the moon on Jan 1.),
 * adds this to the number of days in the year, and calculates the phase
 * of the moon for this date.
 *
 * In the algorithm:
 *
 *	diy	Is the day of the year - 1 (i.e., Jan 1 is day 0).
 *
 *	golden	Is the number of the year in the Mentonic cycle, used to
 *		determine the position of the calender moon.
 *
 *	epact	Is the age of the calender moon (in days) at the beginning
 *		of the year.  To calculate epact, two century-based
 *		corrections are applied:
 *		Gregorian:	(3 * cent)/4 - 12
 *			is the number of years such as 1700, 1800 when
 *			leap year was not held.
 *		Clavian:	(((8 * cent) + 5) / 25) - 5
 *			is a correction to the Mentonic cycle of about
 *			8 days evry 2500 years.  Note that this will
 *			overflow 16 bits in the year 409600.  Beware.
 *
 * The algorithm is accurate for the Gregorian calender only.
 *	
 * The magic numbers used in the phase calculation are as follows:
 *	 29.5		The moon's period in days.
 *	177		29.5 scaled by 6
 *	 22		(29.5 / 8) scaled by 6 (this gets the phase)
 *	 11		((29.5 / 8) / 2) scaled by 6
 *
 * Theoretically, this should yield a number in the range 0 .. 7.  However,
 * two days per year, things don't work out too well.
 *
 * Epact is calculated by the algorithm given in Knuth vol. 1 (calculation
 * of Easter).  See also the article on Calenders in the Encyclopaedia
 * Britannica and Knuth's algorithm in CACM April 1962, page 209.
 */
{
	int		phase;		/* Moon phase			*/
	register int	cent;		/* Century number (1979 = 20)	*/
	register int	epact;		/* Age of the moon on Jan. 1	*/
	register int	diy;		/* Day in the year		*/
	int		golden;		/* Moon's golden number		*/

	if (month < 0 || month > 12) month = 0;	/* Just in case		*/
	diy = day + day_year[month];		/* Day in the year	*/
	if ((month > 2) && ((year % 4 == 0) && 
			((year % 400 == 0) || (year % 100 != 0))))
		diy++;				/* Leapyear fixup	*/
	cent = (year / 100) + 1;		/* Century number	*/
	golden = (year % 19) + 1;		/* Golden number	*/
	epact = ((11 * golden) + 20		/* Golden number	*/
		+ (((8 * cent) + 5) / 25) - 5	/* 400 year cycle	*/
		- (((3 * cent) / 4) - 12)) % 30;/* Leap year correction	*/
	if (epact <= 0)
		epact += 30;			/* Age range is 1 .. 30	*/
	if ((epact == 25 && golden > 11) || epact == 24)
		epact++;
	/*
	 * Calculate the phase, using the magic numbers defined above.
	 * Note that (phase and 7) is equivalent to (phase mod 8) and
	 * is needed on two days per year (when the algorithm yields 8).
	 */
	phase = (((((diy + epact) * 6) + 11) % 177) / 22) & 7;
	return(copyst(buffer, phasetxt[phase]));
}



/*
-h- nbrtxt.c	Mon Aug 09 21:08:52 1982	NBRTXT.C;16
#
 *              Integer to Readable ASCII Conversion Routine.
 *
 * Synopsis:
 *
 *      char *nbrtxt(buffer, value, ordinal)
 *      char    *buffer;        -- The output buffer
 *      int     value;          -- The number to output
 *      int     ordinal;        -- Non-zero for ordinal number
 *
 *
 * The value is converted to a readable number and put in the output
 * buffer (null-terminated).  A pointer to the first free location
 * in the buffer (i.e., the null) is returned.  The ordinal
 * flag distinguishes between cardinal and ordinal numbers:
 *
 *      nbrtxt(buffer, 1, 0) = "one"
 *      nbrtxt(buffer, 1, 1) = "first"
 *
 * The longest output string is:
 *
 *      Twenty-seven thousand, three hundred and seventy-seventh.
 *
 *
 *
 *              Copy a String
 *
 * Synopsis
 *
 *      char *copyst(out, in)
 *      char    *out;           -- The output string
 *      char    *in;            -- The input string
 *
 * The input string is copied into the output string.  Copyst returns
 * a pointer to the null trailer.
 *
 */

extern char     *nbrtxt();
extern char     *copyst();

static char *cardinal[] = {
	"zero",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
	"eleven",
	"twelve",
	"thirteen",
	"fourteen",
	"fifteen",
	"sixteen",
	"seventeen",
	"eighteen",
	"nineteen"
};

static char *ordinal[] = {
	"zeroth",
	"first",
	"second",
	"third",
	"fourth",
	"fifth",
	"sixth",
	"seventh",
	"eighth",
	"ninth",
	"tenth",
	"eleventh",
	"twelfth"
};

static char *twenties[] = {
	"twen",
	"thir",
	"for",
	"fif",
	"six",
	"seven",
	"eigh",
	"nine"
};

char *nbrtxt(buffer, datum, ordflag)
char    *buffer;                        /* Output string buffer         */
int     datum;                          /* what to translate            */
int     ordflag;                        /* 0 if cardinal, 1 if ordinal  */
/*
 * Translate a number to a readable text string, punctuation and all.
 * If ordflag is non-zero, ordinal numbers ("first, second") will
 * be generated, rather than cardinal ("one, two").
 * Note: nbrtxt() is recursive.
 */
{

	register int value;
	register char   *op;

	op = buffer;
	value = datum;
	if (value < 0) {
		op = copyst(op, "minus ");
		value = (-value);
		if (value < 0) {                /* Hack -32768          */
			op = copyst(op, twenties[1]);
			value = 2768;
		}
	}
	if (value >= 1000) {
		op = nbrtxt(op, value/1000, 0);
		op = copyst(op, " thousand");
		value = value % 1000;
		if (value == 0) goto exit;
		op = copyst(op, (value >= 100) ? ", " : " and ");
	}
	if (value >= 100) {
		op = copyst(op, cardinal[value/100]);
		op = copyst(op, " hundred");
		value = value % 100;
		if (value == 0) goto exit;
		op = copyst(op, " ");
	}
	if (value >= 20) {
		if (value == 90 && ordflag)
			return(copyst(op, "nintieth"));
		op = copyst(op, twenties[(value-20) / 10]);
		value = value % 10;
		if (value == 0) {
			return(copyst(op, (ordflag) ? "tieth" : "ty"));
		}
		op = copyst(op, "ty-");
	}
	if (value <= 12) {
		return(copyst(op,
			(ordflag) ? ordinal[value] : cardinal[value]));
	}
	op = copyst(op, cardinal[value]);       /* fourteen, fourteenth */
	/*
	 * Here on 100, 14000, etc.
	 */
exit:   if (ordflag) op = copyst(op, "th");
	return(op);
}

char *
copyst(buffer, string)
char    *buffer;
char    *string;
/*
 * Copy a string into buffer.  Return the free pointer.
 */
{
	register char   *ip;
	register char   *op;

	ip = string;
	op = buffer;

	while ((*op = *ip++)) op++;
	return (op);
}



/*
-h- timetx.c	Mon Aug 09 21:08:52 1982	TIMETX.C;13
#
 *              Convert Time to a Readable Format.
 *
 * Synopsis:
 *
 *      char    *timetxt(buffer, hour, minute, second, daylight);
 *      char    *buffer;        -- Where output goes
 *      int     hour;           -- Hour,        range is 0 to 24
 *      int     minute;         -- Minute,      range is -1 to 59
 *      int     second;         -- Seconds,     range is -1 to 59
 *      int     daylight;       -- Daylight savings time if non-zero.
 *
 * Note: if minute or second is less than zero, the value is not calculated.
 * This distinguishes between "unknown seconds" and "exactly no seconds."
 * If hour is less than zero, a null string is returned.
 * Timetxt converts the time to a null-trailed string.  It returns a pointer
 * to the first free byte (i.e. the null);
 *
 * The output follows the syntax of Robert J. Lurtsema, and includes:
 *
 *      In twenty-five seconds, the time will be ten minutes before noon.
 *
 *
 * External routines called:
 *
 *      nbrtxt          (Number to ascii conversion)
 *      copyst          (String copy routine)
 */

extern char     *nbrtxt();
extern char     *copyst();

char *timetxt(buffer, hour, minute, second, daylight)
char    *buffer;                        /* Output buffer                */
int     hour;                           /* Hours 00 - 23                */
int     minute;                         /* Minutes                      */
int     second;                         /* Seconds                      */
int     daylight;                       /* Non-zero if savings time     */
/*
 * Output time of day.
 */
{
	char            *op;            /* Output pointer               */
	register int    late;           /* after hour or afternoon      */
	register int	sec;		/* Seconds temp			*/
	char		*stuff();	/* Buffer stuffer		*/

	op = buffer;                    /* Setup buffer pointer         */
	if (hour < 0) {			/* If it's a dummy call,	*/
		*op = 0;		/* Return a null string		*/
		return(op);
	}
	if (daylight == 0101010) {      /* Secret flag                  */
		op = copyst(op, "The big hand is on the ");
		op = nbrtxt(op, (((minute + 2 + second/30)/5 + 11)%12)+1, 0);
		op = copyst(op," and the little hand is on the ");
		op = nbrtxt(op, ((hour + 11) % 12) + 1, 0);
		return(copyst(op, ".  "));
	}
	/*
	 * Check if the time is more than 30 minutes past the hour.
	 * If so, output the time before the next hour.
	 */
	if (minute < 0) second = (-2);  /* No minutes means no seconds  */
	else if ((late = (minute > 30 || (minute == 30 && second > 0)))) {
		if (second > 0) {       /* Before next hour             */
			second = 60 - second;
			minute += 1;    /* Diddle the minute, too       */
		}
		minute = 60 - minute;   /* Minutes before next hour     */
		hour += 1;              /* Frobozz next hour getter     */
	}
	/*
	 * Decisions, decisions:
	 *	Minutes	Seconds =>
	 *	  00	  00	Exactly Noon
	 *	  00	  01	One second after noon
	 *	  01	  00	Exactly one minute after noon
	 *	  30	  00	Exactly half past noon
	 *	  59	  00	Exactly one minute before noon
	 *	  59	  59	In one second, the time will be noon
	 */
	if (late && second > 0) {       /* Respectfully dedicated to    */
					/* Robert J. Lurtsema           */
		op = stuff(op, second, 1, "In ", " second");
		op = copyst(op, ", the time will be ");
		sec = -2;		/* We've done seconds already	*/
	}
	else {
		op = copyst(op, "The time is ");
		sec = second;		/* Seconds still to be done	*/
	}
	if (sec == 0) {
		op = copyst(op, "exactly ");
		if (minute == 30)
			op = copyst(op, "half past ");
		else	op = stuff(op, minute, 1, " ", " minute");
	}
	else {				/* Non exact or missing seconds	*/
		op = stuff(op, minute, 0, " ",     " minute");
	        op = stuff(op, sec, (minute > 0),  " and ", " second");
	}
	op = copyst(op, (minute < 0 || (minute == 0 && late)
			|| (second == 0
				&& ((minute == 0 && late == 0)
					|| minute == 30))) ? " "
		: (late) ? " before " : " after ");
	/*
	 * Hours are not quite so bad
	 */
	if (hour == 0 || hour == 24)
		op = copyst(op, "midnight");
	else if (hour == 12)
		op = copyst(op, "noon");
	else {
		if (late = (hour > 12))
			hour = hour - 12;
		op = nbrtxt(op, hour, 0);
		op = copyst(op, (late) ? " PM" : " AM");
	}
	return(copyst(op, (daylight)
		? ", Daylight Savings Time.  "
		: ", Digital Standard Time.  "));
}

static char *
stuff(buffer, value, flag, leading, trailing)
char    *buffer;                        /* Output goes here             */
int     value;                          /* The value to print if > 0    */
int     flag;                           /* flag is set to print leading */
char    *leading;                       /* preceeded by ...             */
char    *trailing;                      /* and followed by ...          */
/*
 * If value <= zero, output nothing. Else, output "leading" value "trailing".
 * Note: leading is output only if flag is set.
 * If value is not one, output an "s", too.
 */
{
	register char   *op;            /* Output pointer               */

	op = buffer;                    /* Setup buffer pointer         */
	if (value > 0) {
		if (flag)
			op = copyst(op, leading);
		op = nbrtxt(op, value, 0);
		op = copyst(op, trailing);
		if (value != 1)
			op = copyst(op, "s");
	}
	return(op);
}



/*
-h- today.c	Mon Aug 09 21:08:52 1982	TODAY.C;27
#
 *			T O D A Y
 *
 * time of day
 *
 * Define UNIX for "native" Unix
 */

/*)BUILD	$(PROGRAM)	= today
		$(FILES)	= { today datetx timetx nbrtxt moontx }
		$(TKBOPTIONS)	= {
			TASK	= ...TOD
		}
*/

#ifdef	DOCUMENTATION

title	today	Date and Time in English
index		Date and Time in English

synopsis

	today [-] [x] | [date]

description

	Today prints the date, time, and phase of the moon in English.
	The following options are available:
	.lm +8
	.s.i -8;- or x	Read date strings from the standard input file.
	.s.i -8;date	Print information for the indicated date.
	.s.lm -8
	Date and time information is given in ISO numeric notation.  For
	example, November 6, 1980 would be represented as "801106".  If
	a time is needed, it would be appended to the date, using 24-hour
	notation: "801106110402" would be a time which is exact to the
	second.  To specify the century, the two-digit century number
	may be preceeded by '+' as in "+18801106".
	.s
	Non-numeric separators between the various fields are permitted:
	"+1776.07.04-11:15:21".  Note that the full two digit entry must be
	given.
	.s
	If no parameter is given, today outputs the current date and time.

diagnostics

	.lm +8
	.s.i -8;Bad parameters or date out of range in ...
	.s
	An input date or time is incorrect.
	.lm -8

author

	Martin Minow

bugs

	The algorithm is only valid for the Gregorian calender.

#endif

#define	APRIL_FOOLS

//int	$$narg	=	1;		/* No prompt if no args		*/
#define LINEWIDTH       72              /* Width of line                */

#include <stdio.h>
#include <time.h>
//#define	NULL		0
#define	EOS		0
//#define	FALSE		0
//#define	TRUE		1

int day_month[] = {			/* Needed for dotexttime()      */
	0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};
int     ccpos;                          /* Current line position        */
char    lastbyte;                       /* Memory for output()          */
char    line[100];                      /* Data line for input function */
char    *valptr;                        /* Needed for number converter  */
char    wordbuffer[LINEWIDTH];          /* Buffer for output function   */
char    *wordptr = wordbuffer;          /* Free byte in wordbuffer      */
char	linebuffer[LINEWIDTH+2];	/* Output text buffer		*/
char	*lineptr = linebuffer;		/* Free byte in linebuffer	*/
int     polish;                         /* Funny mode flag              */

extern  char    *datetxt();             /* Date getter                  */
extern  char    *timetxt();             /* Time of day getter           */
extern  char    *moontxt();             /* Phase of the moon getter     */

main(argc, argv)
int     argc;
char    *argv[];
/*
 * Driver for time routines.  Usage:
 *
 *      today                   Prints current time of day in readable form,
 *                              followed by a cookie.
 *
 *      today {+cc}yymmddhhmmss Prints indicated time of day.
 *                              Note, hh, mm, ss may be omitted.
 *                              For example:
 *                                today 401106     = Nov. 6, 1940
 *                                today +19401106  = Nov. 6, 1940
 *                                today 4011061015 = Nov. 6, 1940 10:15 AM
 *
 *      today -                 Data is read from the standard input and
 *      today x                 output as needed.  The format of each
 *                              line is identical to the command format.
 *				("today x" is needed for vms.)
 */

{
	ccpos = 0;                      /* New line now                 */
	wordptr = wordbuffer;           /* Nothing buffered             */
	lineptr = linebuffer;		/* Nothing in output buffer too	*/
	polish = 0;			/* Normal mode			*/
	if (argc > 1 && tolower(argv[1][0]) == 'p') {
		polish = 1;
		argc--;
		argv++;
	}
	if (argc == 2 && ((argv[1][0] == '-') || (argv[1][0] | 040) == 'x')) {
		while (!getline()) {	/* Read and print times */
			dotexttime(line);
		}
		return;
	}
	else if (argc > 1) {
		if (dotexttime(argv[1]) == 0)
			return;
	}
	/*
	 * Here if no parameters or an error in the parameter field.
	 */
	dotime();			/* Print the time.              */
	output("\n");           	/* Space before cookie          */
#ifdef	UNIX
	execl(COOKIEPROGRAM, "cookie", 0);
#endif
}

dotime()
/*
 * Print the time of day for Unix or VMS native mode.
 */
 #include <time.h>
{
	//int     tvec[2];                /* Buffer for time function     */
	time_t tvec;
	// (prototype is already in <time.h>) -  struct  tm *localtime();	/* Unix time decompile function */
	struct  tm *p;			/* Local pointer to time of day */
	int     year;
	int     month;
 
	time(tvec);                     /* Get the time of day          */
	p = localtime(tvec);            /* Make it more understandable  */
	year = p->tm_year + 1900;
	month = p->tm_mon + 1;
#ifdef	APRIL_FOOLS
	if (month == 4 && p->tm_mday == 1)
		polish = !polish;
#endif
	process(year, month, p->tm_mday, p->tm_hour,
			p->tm_min, p->tm_sec, p->tm_isdst);
}

dotexttime(text)
char    *text;                          /* Time text                    */
/*
 * Create the time values and print them, return 1 on error.
 */

{
	int     epoch;                  /* Which century                */
	int     year;
	int     month;
	int     day;
	int     hour;
	int     minute;
	int     second;
	int     leapyear;

	valptr = text;                          /* Setup for getval()   */
	while (*valptr == ' ') valptr++;        /* Leading blanks skip  */
	if (*valptr != '+')
		epoch = 1900;                   /* Default for now      */
	else {
		valptr++;
		if ((epoch = getval(-1, 00, 99)) < 0) goto bad;
		epoch *= 100;                   /* Make it a real epoch */
	}

	if ((year = getval(-1, 00, 99)) < 0) goto bad;
	year += epoch;
	leapyear = ((year%4) == 0) && (((year%400) == 0) || (year%100 != 0));
	if ((month = getval(-1, 1, 12)) < 0) goto bad;
	if ((day = getval(-1, 1,
		(month == 2 && leapyear) ? 29 : day_month[month])) < 0)
			goto bad;
	if ((hour = getval(-2, 0, 23)) == -1) goto bad;
	if ((minute = getval(-2, 0, 59)) == -1) goto bad;
	if ((second = getval(-2, 0, 59)) == -1) goto bad;
	process(year, month, day, hour, minute, second, 0);
	return(0);				/* Normal exit		*/

bad:    output("Bad parameters or date out of range in \"");
	output(text);
	output("\" after scanning \"");
	*valptr = '\0';
	output(text);
	output("\".\n");
	return(1);				/* Error exit		*/
}

static	char    outline[500];		/* Output buffer                */

process(year, month, day, hour, minute, second, daylight)
int     year;                           /* Year		1900 = 1900	*/
int     month;                          /* Month	January = 1	*/
int     day;                            /* Day		1 = 1		*/
int	hour;				/* Hour		0 .. 23		*/
int	minute;				/* Minute	0 .. 59		*/
int	second;				/* Second	0 .. 59		*/
int	daylight;			/* Daylight savings time if 1	*/
/*
 * Output the information.  Note that the parameters are within range.
 */
{

	output("Today is ");
	datetxt(outline, year, month, day);
	output(outline);
	output(".  ");
	timetxt(outline, hour, minute, second,
			(polish) ? 0101010 : daylight);
	output(outline);
	output("The moon is ");
	moontxt(outline, year, month, day);
	output(outline);
	output(".  \n");
}


output(text)
char    *text;                                  /* What to print        */
/*
 * Output routine.  Text is output using put() so that lines are
 * not more than LINEWIDTH bytes long.  Current position is in global ccpos.
 * (put is equivalent to putchar() except that it is locally buffered.)
 */
{
	register char	*in;                    /* Current pos. in scan */
	register char	c;                      /* Current character    */
	register char	*wp;			/* Word pointer		*/

	in = text;
	while (c = *in++) {
		switch (c) {
		case '\n':                      /* Force new line       */
		case ' ':                       /* or a space seen      */
			if ((wordptr-wordbuffer) + ccpos >= LINEWIDTH) {
				put('\n');  /* Current word         */
				ccpos = 0;      /* won't fit, dump it.  */
			}
			if (wordptr > wordbuffer) {
				if (ccpos) {	/* Leading space needed */
					put(' ');
					ccpos++;
				}
				for (wp = wordbuffer; wp < wordptr;) {
					put(*wp++);
				}
				ccpos += (wordptr - wordbuffer);
				wordptr = wordbuffer;	/* Empty buffer	*/
			}
			if (c == '\n') {
				put('\n');	/* Print a newline	*/
				ccpos = 0;	/* and reset the cursor	*/
			}
			break;

		default:
			*wordptr++ = c;         /* Save piece of word   */
		}
	}
}

put(c)
register char	c;
/*
 * Actual output routine
 */
{
	if (c == '\n' || (lineptr - linebuffer) >= LINEWIDTH) {
		*lineptr = EOS;
		puts(linebuffer);
		lineptr = linebuffer;
		if (c == '\n')
			return;
	}
	*lineptr++ = c;
} 

getline()
/*
 * Read text to global line[].  Return 1 on end of file, zero on ok.
 */
{
	register char *t;

	return (gets(line) == NULL);
}

getval(flag, low, high)
int     flag;
int     low;
int     high;
/*
 * Global valptr points to a 2-digit positive decimal integer.
 * Skip over leading non-numbers and return the value.
 * Return flag if text[0] == '\0'. Return -1 if the text is bad,
 * or if the value is out of the low:high range.
 */
{
	register int value;
	register int i;
	register int temp;

	if (*valptr == '\0') return(flag);        /* Default?             */
	while (*valptr && (*valptr < '0' || *valptr > '9')) *valptr++;
				/* The above allows for 78.04.22 format */
	for (value = i = 0; i < 2; i++) {
		temp = *valptr++ - '0';
		if (temp < 0 || temp > 9) return(-1);
		value = (value*10) + temp;
	}
	return((value >= low && value <= high) ? value : -1);
}
