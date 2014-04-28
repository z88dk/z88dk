/*
 *	Z80 - Assembler
 *	Copyright (C) 1987-2014 by Udo Munk
 *
 *	History:
 *	17-SEP-1987 Development under Digital Research CP/M 2.2
 *	28-JUN-1988 Switched to Unix System V.3
 *	21-OCT-2006 changed to ANSI C for modern POSIX OS's
 *	03-FEB-2007 more ANSI C conformance and reduced compiler warnings
 *	18-MAR-2007 use default output file extension dependend on format
 *	04-OCT-2008 fixed comment bug, ';' string argument now working
 */

/*
 *	module for output functions to list, object and error files
 */

#include <stdio.h>
#include <string.h>
#include "z80a.h"
#include "z80aglb.h"

void flush_hex(void);
int chksum(void);
void btoh(unsigned char, char **);

extern void fatal(int, char *);

static char *errmsg[] = {		/* error messages for asmerr() */
	"illegal opcode",		/* 0 */
	"illegal operand",		/* 1 */
	"missing operand",		/* 2 */
	"multiply defined symbol",	/* 3 */
	"undefined symbol",		/* 4 */
	"value out of range",		/* 5 */
	"missing )",			/* 6 */
	"missing string separator",	/* 7 */
	"memory override",		/* 8 */
	"missing IF",			/* 9 */
	"IF nesting to deep",		/* 10 */
	"missing ENDIF",		/* 11 */
	"INCLUDE nesting to deep"	/* 12 */
};

#define MAXHEX	32			/* max no bytes/hex record */

static unsigned short hex_adr;		/* current address in hex record */
static int hex_cnt;			/* current no bytes in hex buffer */

static unsigned char hex_buf[MAXHEX];	/* buffer for one hex record */
static char hex_out[MAXHEX*2+11];	/* ASCII buffer for one hex record */

/*
 *	print error message to listfile and increase error counter
 */
void asmerr(int i)
{
	if (pass == 1) {
		fprintf(errfp, "Error in file: %s  Line: %d\n", srcfn, c_line);
		fprintf(errfp, errmsg[i]);
		fprintf(errfp, "\n\n");
	} else
		errnum = i;
	errors++;
}

/*
 *	begin new page in listfile
 */
void lst_header(void)
{
	fprintf(lstfp, "\fZ80-Assembler\t\tRelease %s\t\t\t\tPage %d\n", REL,
		++page);
	fprintf(lstfp, "Source file: %s\n", srcfn);
	fprintf(lstfp, "Title:       %s\n", title);
	p_line = 3;
}

/*
 *	print header for source lines
 */
void lst_attl(void)
{
	fprintf(lstfp, "\nLOC   OBJECT CODE   LINE   STMT SOURCE CODE\n");
	p_line += 2;
}

/*
 *	print one line into listfile, if -l option set
 */
void lst_line(int val, int opanz)
{
	register int i;

	if (!list_flag || sd_flag == 4) {
		sd_flag = 0;
		return;
	}
	if ((p_line >= ppl) || (c_line == 1)) {
		lst_header();
		lst_attl();
	}
	switch (sd_flag) {
	case 0:
		fprintf(lstfp, "%04x  ", val & 0xffff);
		break;
	case 1:
		fprintf(lstfp, "%04x  ", sd_val & 0xffff);
		break;
	case 2:
		fprintf(lstfp, "      ");
		break;
	case 3:
		fprintf(lstfp, "%04x              ", sd_val & 0xffff);
		goto no_data;
	default:
		fatal(F_INTERN, "illegal listflag for function lst_line");
		break;
	}
	if (opanz >= 1) fprintf(lstfp, "%02x ", ops[0] & 0xff);
		else fprintf(lstfp, "   ");
	if (opanz >= 2) fprintf(lstfp, "%02x ", ops[1] & 0xff);
		else fprintf(lstfp, "   ");
	if (opanz >= 3) fprintf(lstfp, "%02x ", ops[2] & 0xff);
		else fprintf(lstfp, "   ");
	if (opanz >= 4) fprintf(lstfp, "%02x ", ops[3] & 0xff);
		else fprintf(lstfp, "   ");
	no_data:
	fprintf(lstfp, "%6d %6d %s", c_line, s_line, line);
	if (errnum) {
		fprintf(errfp, "=> %s", errmsg[errnum]);
		putc('\n', errfp);
		errnum = 0;
		p_line++;
	}
	sd_flag = 0;
	p_line++;
	if (opanz > 4 && sd_flag == 0) {
		opanz -= 4;
		i = 4;
		sd_val = val;
		while (opanz > 0) {
			if (p_line >= ppl) {
				lst_header();
				lst_attl();
			}
			s_line++;
			sd_val += 4;
			fprintf(lstfp, "%04x  ", sd_val & 0xffff);
			if (opanz-- > 0) fprintf(lstfp, "%02x ",
						 ops[i++] & 0xff);
				else fprintf(lstfp, "   ");
			if (opanz-- > 0) fprintf(lstfp, "%02x ",
						 ops[i++] & 0xff);
				else fprintf(lstfp, "   ");
			if (opanz-- > 0) fprintf(lstfp, "%02x ",
						 ops[i++] & 0xff);
				else fprintf(lstfp, "   ");
			if (opanz-- > 0) fprintf(lstfp, "%02x ",
						 ops[i++] & 0xff);
				else fprintf(lstfp, "   ");
			fprintf(lstfp, "%6d %6d\n", c_line, s_line);
			p_line++;
		}
	}
}

/*
 *	print symbol table into listfile unsorted
 */
void lst_sym(void)
{
	register int i, j;
	register struct sym *np;

	p_line = j = 0;
	strcpy(title,"Symboltable");
	for (i = 0; i < HASHSIZE; i++) {
		if (symtab[i] != NULL) {
			for (np = symtab[i]; np != NULL; np = np->sym_next) {
				if (p_line == 0) {
					lst_header();
					fputs("\n", lstfp);
					p_line += 1;
				}
				fprintf(lstfp, "%-8s %04x\t", np->sym_name,
					np->sym_val & 0xffff);
				if (++j == 4) {
					fprintf(lstfp, "\n");
					if (p_line++ >= ppl)
						p_line = 0;
					j = 0;
				}
			}
		}
	}
}

/*
 *	print sorted symbol table into listfile
 */
void lst_sort_sym(int len)
{
	register int i, j;

	p_line = i = j = 0;
	strcpy(title, "Symboltable");
	while (i < len) {
		if (p_line == 0) {
			lst_header();
			fputs("\n", lstfp);
			p_line += 1;
		}
		fprintf(lstfp, "%-8s %04x\t", symarray[i]->sym_name,
			symarray[i]->sym_val & 0xffff);
		if (++j == 4) {
			fprintf(lstfp, "\n");
			if (p_line++ >= ppl)
				p_line = 0;
			j = 0;
		}
	i++;
	}
}

/*
 *	write header record into object file
 */
void obj_header(void)
{
	switch (out_form) {
	case OUTBIN:
		break;
	case OUTMOS:
		putc(0xff, objfp);
		putc(prg_adr & 0xff, objfp);
		putc(prg_adr >> 8, objfp);
		break;
	case OUTHEX:
		hex_adr = prg_adr;
		break;
	}
}

/*
 *	write end record into object file
 */
void obj_end(void)
{
	switch (out_form) {
	case OUTBIN:
		break;
	case OUTMOS:
		break;
	case OUTHEX:
		flush_hex();
		fprintf(objfp, ":00000001FF\n");
		break;
	}
}

/*
 *	write opcodes in ops[] into object file
 */
void obj_writeb(int opanz)
{
	register int i;

	switch (out_form) {
	case OUTBIN:
		fwrite(ops, 1, opanz, objfp);
		break;
	case OUTMOS:
		fwrite(ops, 1, opanz, objfp);
		break;
	case OUTHEX:
		for (i = 0; opanz; opanz--) {
			if (hex_cnt >= MAXHEX)
				flush_hex();
			hex_buf[hex_cnt++] = ops[i++];
		}
		break;
	}
}

/*
 *	write <count> bytes 0xff into object file
 */
void obj_fill(int count)
{
	switch (out_form) {
	case OUTBIN:
		while (count--)
			putc(0xff, objfp);
		break;
	case OUTMOS:
		while (count--)
			putc(0xff, objfp);
		break;
	case OUTHEX:
		flush_hex();
		hex_adr += count;
		break;
	}
}

/*
 *	create a hex record in ASCII and write into object file
 */
void flush_hex(void)
{
	char *p;
	register int i;

	if (!hex_cnt)
		return;
	p = hex_out;
	*p++ = ':';
	btoh((unsigned char) hex_cnt, &p);
	btoh((unsigned char) (hex_adr >> 8), &p);
	btoh((unsigned char) (hex_adr & 0xff), &p);
	*p++ = '0';
	*p++ = '0';
	for (i = 0; i < hex_cnt; i++)
		btoh(hex_buf[i], &p);
	btoh((unsigned char) chksum(), &p);
	*p++ = '\n';
	*p = '\0';
	fwrite(hex_out, 1, strlen(hex_out), objfp);
	hex_adr += hex_cnt;
	hex_cnt = 0;
}

/*
 *	convert unsigned char into ASCII hex and copy to string at p
 *	increase p by 2
 */
void btoh(unsigned char byte, char **p)
{
	register unsigned char c;

	c = byte >> 4;
	*(*p)++ = (c < 10) ? (c + '0') : (c - 10 + 'A');
	c = byte & 0xf;
	*(*p)++ = (c < 10) ? (c + '0') : (c - 10 + 'A');
}

/*
 *	compute checksum for Intel hex record
 */
int chksum(void)
{
	register int i, j, sum;

	sum = hex_cnt;
	sum += hex_adr >> 8;
	sum += hex_adr & 0xff;
	for (i = 0; i < hex_cnt; i++) {
		j = hex_buf[i];
		sum += j & 0xff;
	}
	return (0x100 - (sum & 0xff));
}
