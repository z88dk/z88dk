/*
	SPLITLIB/CCC - split a /REL library into manageable parts
	Version 1.0 - 09/08/86
	Original Copyright 1986 Riclin Computer Products. All rights reserved.
	
	Now put into public domain (http://www.tim-mann.org/misosys.html#down):
	   "Misosys is Roy Soltoff's old TRS-80 software company. 
	   Roy has been out of the business for some years, and he has given me permission
	   to put his TRS-80 software and documentation up for free dissemination on the Web.
	   Many thanks to Roy for his generosity."
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <trsdos.h>

//#option MAXFILES 2
//#option FIXBUFS ON
//#option INLIB ON
#define FSPECLEN 14
#define ME "SPLITLIB"
#define DATE "09/08/86"
#define RELEOF 0x9E

char inspec[FSPECLEN+1] = "", outspec[FSPECLEN+1], symbol[9], *drive ="";
int byte, bitno = 7, currlength;
FILE *infp, *outfp = NULL;


abend(format, al, a2)
	char *format, *al, *a2;
{
	fprintf(stderr, "%s: " , ME);
	fprintf(stderr, format, al, a2);
	exit(1);
}

/*
syserrlist(errno)
	int errno;
{
#asm
	pop  de
	pop  hl
	push hl
	push de
	ld a,l
	jp 0x4409
#endasm
}
*/

ioerror(f)
char *f;
{
	extern int errno;
	abend("%s: %s\n", f, syserrlist(errno));
	//abend("%s: error.\n", f, NULL);
}


putbyte(c)
	int c;
{
	if (putc(c, outfp) != c)
	ioerror(outspec);
}


getbyte() /* read next byte from input file, write out */
{
	//if ((byte = getc(infp)) == EOF)
	//	if (ferror(infp))
	//		ioerror(inspec);
	byte = getc(infp);
	
	putbyte(byte);
	++currlength;
}


openout()
{
	static char outext[]="Rnn";
	static int currout = 0;
	
	if (outfp)
	{
		putbyte(RELEOF);
		fclose(outfp);
	}
	outext[1] = ++currout / 10 + '0';
	outext[2] = currout % 10 + '0';
	strcpy(outspec, drive);
	if (! (outfp = fopen(genspec(inspec, outspec, outext), "w")))
		ioerror(outspec);
	printf("\nWriting output file %s\n", outspec);
	currlength = 0;
}


usage()
{
	abend("usage: %s infile[/REL] maxlength [:d]\n", ME, NULL);
}


bitest(bitno, value) /* test bit version 2 */
	int bitno, value;
{
#asm
    DEFC BIT0E = $43    ; BIT 0,E instruction

    ;$GA  BC,DE           ; bit # in C, value in E
	pop hl
	pop de	; value
	pop bc	; bit #
	push bc
	push de
	push hl	; ret addr
	
    LD   A,C
    ADD  A,A             ; shift bit # left 3x
    ADD  A,A
    ADD  A,A
    OR   BIT0E           ; mask bit # into instr
    LD   (BITINST-1),A   ; modify bit test code
    BIT  0,E             ; test bit in E
BITINST:
    LD   HL,0            ; assume not set
    RET  Z               ; rtn FALSE
    INC  HL
#endasm
}


getbit() /* retrieve next bit from file */
{
	static int bit;
	
	bit = bitest(bitno--, byte);
	if (bitno < 0)
	{
		bitno = 7;  /* bitno runs modulo 8 */
		getbyte();      /* next byte */
	}
	return bit;
}


getnum(power) /* get a number <= 2*power_i */
	int power;
{
	static int n;
	for (n = 0; power > 0; power>>= 1)
		n += getbit() * power;
	return n;
}


skipbits(n) /* skip n bits */
	int n;
{
	while (n--)
		getbit();
}


a_field() /* decode A-field */
{
	skipbits(18);
}


b_field() /* decode B-field */
{
	static int len, n;
	
	for (len = getnum(4), n = 0; n < len; ++n) /* get symbol */
		symbol[n] = getnum(128) & 0x7F;
	symbol[n] ='\0';
}


a_and_b() /* decode A- and B-fields */
{
	a_field();
	b_field();
}




main(argc, argv)
	int argc;
	char *argv[];
{
	static int maxlength;
	static char * p;
	
	printf("%s - Split /REL Library - Version 1.0 - %s\nCopyright 1986 Riclin Computer Products. All rights reserved.\n\n", ME, DATE );
	if (argc < 3)
		usage();
	//for (p = argv[2]; isdigit(*p++); )
	//	;
	
		maxlength = atoi(argv[2]);
	
	//if (--p - argv[2] > 5 || *p || maxlength < 10000)
	//if (maxlength < 10000)
	if (maxlength < 4000)
		usage();
	if (argc == 4)
		drive = argv[3];
	if (drive[0] != ':' || drive[1] < '0' || drive[1] > '7')
		usage ;
	if (! (infp = fopen(addext(strncpy(inspec, argv[1], FSPECLEN),"REL") , "r")))
		ioerror(inspec);
	printf("Reading input file %s\n", inspec);
	openout();    /* open first output file */
	getbyte();    /* prime the pump */
	for ( ; ; )   /* loop forever */
	{
		if (! getbit())    /* absolute item */
			skipbits(8);
		else               /* relocatable item */
			switch (getnum(2))
			{
				case 1: /* program relative */
				case 2: /* data relative */
				case 3: /* common relative */
					skipbits(16);
					break;
				case 0: /* special link item */

					switch (getnum(8)) /* compute ctl field */
					{
						case 0: /* entry symbol */
						case 1: /* select common block */
						case 3: /* request lib search */
						case 4: /* reserved */
							b_field();
							break;
						case 2: /* program name */
							b_field();
							printf("Module %s\n", symbol);
							break;
						case 5: /* define common size */
						case 7: /* define entry point */
						case 8: /* reserved */
						case 6: /* chain external */
							a_and_b();
							break;
						case 9: /* external + offset */
						case 10: /* define data area size */
						case 11: /* set counter */
						case 12: /* chain address */
						case 13: /* define program size */
							a_field();
							break;
						case 14: /* end program */
							a_field();
							if (currlength >= maxlength)
								openout(); /* close current, open next */
							if (bitno != 7) /* force to byte boundary */
							{
								bitno = 7;
								getbyte();
							}
							break;
						case 15: /* end file */
							fclose(outfp); /* 0x9E already written */
							exit(0);
					} /* end inner switch */
			} /* end outer switch */
	} /* end for */
}
