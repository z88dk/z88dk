/*
 *      Small C+ Compiler
 *
 *      Z80 Code Generator
 *
 *      $Id: codegen.c,v 1.3 2001-04-27 14:45:28 dom Exp $
 *
 *      21/4/99 djm
 *      Added some conditional code for tests of zero with a char, the
 *      expand char to int code will be removed at optimizatin stage
 *
 *      22/4/99 djm
 *      Major rewrite!! All operations have one single routine now
 *      so the compile might actually run quicker, and uses less
 *      of those dodgy pointers to functions
 *
 *      23/4/99 djm
 *      With a bit of luck this file will no contain all assembler
 *      related output, this means that if Gunther gets macros worked
 *      into z80asm, we can change the output of the compiler to be
 *      macros which we can then optimize a lot easier..hazzah!
 */

#define CHARCOMP0

#include "ccdefs.h"
#include <time.h>

extern int WasComp(LVALUE *lval);
extern char Filenorig[];

/*
 * Data for this module
 */

int donelibheader;


/* Begin a comment line for the assembler */

void comment(void)
{
        outbyte(';');
}

/* Put out assembler info before any code is generated */

void header(void)
{
        time_t  tim;
        char    *timestr;
        comment();      outstr(Banner);         nl();
        comment();      outstr(Version);        nl();
        comment();                              nl();
	if (asxx)
		outstr(";\tReconstucted for asz80\n");
	else
	        outstr (";\tReconstructed for the z80 Module Assembler\n");
        outstr (";\tBy Dominic Morris <djm@jb.man.ac.uk>\n");
        donelibheader=0;
        if ( (tim=time(NULL) ) != -1 ) {
                timestr=ctime(&tim);
                comment(); nl();
                comment(); outstr("\tModule compile time: ");
                outstr(timestr);
                nl();
        }
        nl();
}

/*
 * Print the header for a library function, called from the preprocessor!
 */

void DoLibHeader()
{
        char    filen[FILENAME_LEN+1];
	char	*incdir;	
	char	*segment;

        if (donelibheader) return;
/*
 * Copy filename over (obtained by preprocessor), carefully skipping
 * over the quotes!
 */
        strncpy(filen,Filename+1,strlen(Filename)-2);
        filen[strlen(Filename)-1]='\0';
        if (makelib==0) {
/* Compiling a program */
		if (asxx)
			outstr("\n\t.module\t");
		else
                	outstr ("\n\tMODULE\t");
		if (strlen (filen) && strncmp(filen,"<stdin>",7) ) {
                	changesuffix(filen,".c");
                	outstr(filen);
		} else {
/* This handles files produced by a filter cpp */
			strcpy(filen,Filenorig);
                	if ( (segment=strrchr(filen,'/')) ) /* Unix */
                        	++segment;
                	else if ( (segment=strrchr(filen,'\\')) ) /*DOG*/
                        	segment++;
                	else if ( (segment=strrchr(filen,':')) )/*Amiga*/
                        	segment++;
                	else segment=filen;
			changesuffix(filen,".c");
                	outstr("scp_");  /* alpha id incase tmpfile is numeric */
			outstr(segment);
		}
        } else {
/* Library function */
                outstr("\n;\tSmall C+ Library Function\n");
                changesuffix(filen,"");
                if (asxx)
			outstr("\n\t.globl\t");
		else
			outstr("\n\tXLIB\t");
                outstr(filen);
        }
	if (asxx) {
		incdir=getenv("Z80_OZFILES");
		outstr("\n\n\t.include \"");
		if (incdir) outstr(incdir);
		outstr("z88_crt0.hdx\"\n\n");
		ol(".area _CODE\n");
		ol(".radix d\n");
	} else
        	outstr("\n\n\tINCLUDE \"#z88_crt0.hdr\"\n\n\n");
        donelibheader=1;
}


/* Print any assembler stuff needed after all code */
void trailer(void)
{
        nl();
        outstr("; --- End of Compilation ---\n");
}

/* Print out a name such that it won't annoy the assembler
 *      (by matching anything reserved, like opcodes.)
 */
void outname(char *sname,char pref)
{
        int i ;

        if (pref) {
		if (asxx) outstr("_");
		else outstr(Z80ASM_PREFIX);
	}
        if ( strlen(sname) > ASMLEN ) {
                i = ASMLEN;
                while ( i-- )
                        outbyte(raise(*sname++));
        }
        else
                outstr(sname);
}

/* Fetch a static memory cell into the primary register */
/* Can only have directly accessible things here...so should be
 * able to just check for far to see if we need to pick up second
 * bit of long pointer (check for type POINTER as well...
 */
void getmem(sym)
SYMBOL *sym ;
{

        
        if( sym->ident != POINTER && sym->type == CCHAR ) {
                if (!(sym->flags&UNSIGNED)) {
#ifdef PREAPR00
                        ot("ld\ta,("); outname(sym->name,dopref(sym));
                        outstr(")\n");
                        callrts("l_sxt");
#else
                        ot("ld\thl,"); outname(sym->name,dopref(sym));
			nl();
			callrts("l_gchar");
#endif

                } else {
/* Unsigned char - new method - allows more optimizations! */
                        ot("ld\thl,"); outname(sym->name,dopref(sym));
                        nl();
                        ol("ld\tl,(hl)");
                        ol("ld\th,0");
                }
#ifdef OLDLOADCHAR
                ot("ld\ta,("); outname(sym->name,dopref(sym));
                outstr(")\n");
                if (!(sym->flags&UNSIGNED))
                        callrts("l_sxt");
                else {
                        ol("ld\tl,a");
                        ol("ld\th,0");
                }
                
#endif
        }
        else if( sym->ident != POINTER && sym->type == DOUBLE ) {
                address(sym);
                callrts("dload");
        }
        else if (sym->ident !=POINTER && sym->type == LONG ) {
                ot("ld\thl,(");outname(sym->name,dopref(sym)); outstr(")\n");
                ot("ld\tde,(");outname(sym->name,dopref(sym)); outstr("+2)\n");
        }
        else {
/* this is for CINT and get pointer..will need to change! */
                ot("ld\thl,("); outname(sym->name,dopref(sym)); outstr(")\n");
/* For long pointers...load de with name+2, then d,0 */
                if (sym->type==CPTR || (sym->ident==POINTER && sym->flags&FARPTR)) { ot("ld\tde,("); outname(sym->name,dopref(sym)); outstr("+2)\n\tld\td,0\n"); }
        }
}

/* Fetch the address of the specified symbol (from stack)
 */
int getloc(sym, off)
SYMBOL *sym;
int off ;
{
	int	offs;
	offs=sym->offset.i-Zsp+off;
        vconst(offs);
        ol("add\thl,sp");
	return (offs);

}

/* Store the primary register into the specified */
/*      static memory cell */
void putmem(sym)
SYMBOL *sym;
{
        if( sym->ident != POINTER && sym->type == DOUBLE ) {
                address(sym);
                callrts("dstore");
        }
        else {
                if( sym->ident != POINTER && sym->type == CCHAR ) {
                        LoadAccum();
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),a\n");
                }
                else if (sym ->ident != POINTER && sym->type == LONG ) {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("+2),de\n");
                }
                else if (sym->ident == POINTER && sym->flags&FARPTR) {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                        ol("ld\ta,e");
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("+2),a\n");
 
                } else {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                }
        }
}

/*
 *	Store type at TOS - used for initialising auto vars
 */

void StoreTOS(char typeobj)
{
	switch (typeobj) {
		case LONG:
			lpush();
			return;
		case CCHAR:
			ol("dec\tsp");
			LoadAccum();
			mainpop();
			ol("ld\tl,a");
			zpush();
			Zsp--;
			return;
		case DOUBLE:
			dpush();
			return;
/* CPTR..untested */
		case CPTR:
			ol("dec\tsp");
			ol("ld\ta,e");
			zpop();	/* pop de */
			ol("ld\te,a");
			zpushde();
			zpush();
			Zsp--;
			return;
		default:
			zpush();
			return;
			
	}
}	
			
/*
 * Store the object at the frame position marked by offset
 * We already know that it's in range
 */

#ifdef USEFRAME

void PutFrame(char typeobj, int offset)
{
        SYMBOL *ptr;
	char	flags;
	ptr=retrstk(&flags);	/* Not needed but.. */
	switch(typeobj) {
		case CCHAR:
			ot("ld\t");
			OutIndex(offset);
			outstr(",l\n");
			break;
		case CINT:
			ot("ld\t");
			OutIndex(offset);
			outstr(",l\n");
			ot("ld\t");
			OutIndex(offset+1);
			outstr(",h\n");
			break;
		case CPTR:
		case LONG:
			ot("ld\t");
			OutIndex(offset);
			outstr(",l\n");
			ot("ld\t");
			OutIndex(offset+1);
			outstr(",h\n");
			ot("ld\t");
			OutIndex(offset+2);
			outstr(",e\n");
			ot("ld\t");
			if (typeobj == LONG) {
				OutIndex(offset+3);
				outstr(",d\n");
			}
	}
}
#endif




/* Store the specified object type in the primary register */
/*      at the address on the top of the stack */
void putstk(char typeobj)
{
        SYMBOL *ptr;
        char flags;
/* Store via long pointer... */
        ptr=retrstk(&flags);
        if ( flags&FARACC ) {
/* exx pop hl, pop de, exx */
                doexx(); mainpop(); zpop(); doexx();
                switch( typeobj ) {
                case DOUBLE:
                        callrts("lp_pdoub");
                        break;
                case CPTR :
                        callrts("lp_pptr");
                        break;
                case LONG :
                        callrts("lp_plong");
                        break;
                case CCHAR :
                        callrts("lp_pchar");
                        break;
                default:
                        callrts("lp_pint");
                }
                return;
        }

        switch ( typeobj ) {
        case DOUBLE :
                mainpop();
                callrts("dstore");
                break ;
        case CPTR :
                zpopbc();
                callrts("l_putptr");
                break;
        case LONG :
                zpopbc();
                callrts("l_plong");
                break ;
        case CCHAR :
                zpop();
                LoadAccum();
                ol("ld\t(de),a");
                break ; 
        default :
                zpop(); 
                if (doinline) {
                	LoadAccum();
                	ol("ld\t(de),a");
                	ol("inc\tde");
                	ol("ld\ta,h");
                	ol("ld\t(de),a");
                } else
                	callrts("l_pint");
        }
}

/* store a two byte object in the primary register at TOS */
void puttos(void)
{
#ifdef USEFRAME
	if (useframe) {
		ot("ld\t");
		OutIndex(0);
		outstr(",l\n");
		ot("ld\t");
		OutIndex(1);
		outstr(",h\n");
		return;
	}
#endif
        ol("pop\tbc");
        ol("push\thl");
}

/* store a two byte object in the primary register at 2nd TOS */
void put2tos(void)
{
#ifdef USEFRAME
	if (useframe) {
		ot("ld\t");
		OutIndex(2);
		outstr(",l\n");
		ot("ld\t");
		OutIndex(3);
		outstr(",h\n");
		return;
	}
#endif
        ol("pop\tde");
        puttos();
        ol("push\tde");
}


/*
 * loadargc - load accumulator with number of words of stack
 *            if n=0 then emit xor a instead of ld a,0 
 *            (this is picked up by the optimizer, but even so)
 */
void loadargc(n)
int n;
{
        n >>= 1;
        if ( n ) {
                ot("ld\ta," ) ;
                outdec(n) ;
                nl();
        } else  ol("xor\ta");
}


/* Fetch the specified object type indirect through the */
/*      primary register into the primary register */
void indirect(LVALUE *lval)
{
        char     sign;
	char	typeobj, flags;

	typeobj=lval->indirect;
	flags=lval->flags;

        sign=flags&UNSIGNED;

	/* Fetch from far pointer */
        if (flags&FARACC) {             /* Access via far method */
                switch(typeobj) {
                case CCHAR :
                        callrts("lp_gchar");
                        if (!sign) callrts("l_sxt");
/*                        else ol("ld\th,0"); */
                        break;
                case CPTR:
                        callrts("lp_gptr");
                        break;
                case LONG:
                        callrts("lp_glong");
                        break;
                case DOUBLE:
                        callrts("lp_gdoub");
                        break;
                default:
                        callrts("lp_gint");
                }
                return;
                
        }


        switch ( typeobj ) {
        case CCHAR :
                if (!sign) {
#ifdef PREAPR00
                        ol("ld\ta,(hl)");
                        callrts("l_sxt");
#else
			callrts("l_gchar");
#endif
                } else {
                        ol("ld\tl,(hl)");
                        ol("ld\th,0");
		}
                break ;
        case CPTR :
                callrts("l_getptr");
                break;
        case LONG :
                callrts("l_glong");
                break;
        case DOUBLE :
                callrts("dload");
                break ;
        default :
                if (doinline){
                	ol("ld\ta,(hl)");
                	ol("inc\thl");
                	ol("ld\th,(hl)");
                	ol("ld\tl,a");
                } else {
			ot("call\tl_gint\t;");
#ifdef USEFRAME
			if (useframe && CheckOffset(lval->offset)) {
				OutIndex(lval->offset);
			}
#endif
			nl();
		}
        }
}

/* Swap the primary and secondary registers */
void swap(void)
{
        ol("ex\tde,hl");
}

/* Print partial instruction to get an immediate value */
/*      into the primary register */
void immed(void)
{
	if (asxx) 
	        ot("ld\thl,#");
	else
		ot("ld\thl,");
}

/* Print partial instruction to get an immediate value */
/*      into the secondary register */
void immed2(void)
{
	if (asxx)
        	ot("ld\tde,#");
	else
		ot("ld\tde,");
}

/* Partial instruction to access literal */
void immedlit(lab)
int lab;
{
        immed();
        queuelabel(lab);
        outbyte('+');
}


/* Push long onto stack */

void lpush(void)
{
        zpushde();
        zpush();
}

void lpush2(void)
{
        callrts("lpush2");
        Zsp-=4;
}

/* Push and pop flags (used for ? operator) */

void zpushflags(void)
{
        ol("push\taf");
        Zsp -=2;
}

void zpopflags(void)
{
        ol("pop\taf");
        Zsp +=2;
}


/* Push secondary register/high work of long onto the stack */


void zpushde(void)
{
        ol("push\tde");
        Zsp -= 2;
}

/* Push the primary register onto the stack */

void zpush(void)
{
        ol("push\thl");
        Zsp -= 2;
}

/* Push the primary floating point register onto the stack */

void dpush(void)
{
        callrts("dpush");
        Zsp -= 6;
}

/* Push the primary floating point register, preserving
        the top value  */

void dpush2(void)
{
        callrts("dpush2");
        Zsp -= 6;
}

/* Pop the top of the stack into the primary register */
void mainpop(void)
{
        ol("pop\thl");
        Zsp += 2;
}

/* Pop the top of the stack into the secondary register */
void zpop(void)
{
        ol("pop\tde");
        Zsp += 2;
}

/* Pop top of stack into bc */

void zpopbc(void)
{
        ol("pop\tbc");
        Zsp += 2;
}

/* Swap af & af' (preserve carry) */

void doexaf(void)
{
	ol("ex\taf,af");
}

/* Swap between the sets of registers */

void doexx(void)
{
        ol("exx");
}


/* Swap the primary register and the top of the stack */
void swapstk(void)
{
        ol("ex\t(sp),hl");
}

/* process switch statement */
void sw(char type)
{
        if (type==LONG || type==CPTR) callrts("l_long_case");
        else callrts("l_case");
}

/* Call a shared library routine FIXME!!!!
 * Dunno which one myself and Garry are gonna hijack yet!
 */

void zclibcallop()
{
	ol("rst\t8");
	defword();
}
	

/* Call the specified subroutine name */
void zcall(sname)
SYMBOL *sname;
{
        zcallop();
        outname(sname->name,dopref(sname));
        nl();
}

/* Output the call op code */

void zcallop(void)
{
        ot("call\t");
}


/* djm (move this!) Decide whether to print a prefix or not 
 * This uses new flags bit LIBRARY
 */

char dopref(sym)
SYMBOL *sym;
{
	if (sym->flags&LIBRARY && (sym->ident == FUNCTION || sym->ident == FUNCTIONP)) return(0);
        return(1);
}

/* Call a run-time library routine */
void callrts(sname)
char *sname;
{
        ot("call\t");
        outstr(sname);
        nl();
}


/* Return from subroutine */
void zret(void)
{
        ol("ret");
        nl();
        nl();
}

/*
 * Perform subroutine call to value on top of stack
 * Put arg count in A in case subroutine needs it
 */
void callstk(n)
int n;
{
        loadargc(n) ;
        callrts( "l_dcal" ) ;
}

void jump0(lval,label)
LVALUE *lval;
int label;
{
	opjump("",label);
}


/* Jump to specified internal label number */
void jump(label)
int label;
{
        opjump("",label);
}

/* Jump relative to specified internal label */
void jumpr(int label)
{
        opjumpr("",label);
}


/*
 * Output the jump code, with conditions as needed
 */

void opjump(char *cc, int label)
{
        ot("jp\t");
        outstr(cc);
        printlabel(label);
        nl();
}

void opjumpr(char *cc, int label)
{
        ot("jr\t");
        outstr(cc);
        printlabel(label);
        nl();
}

void jumpc(int label)
{
        opjump("c,",label);
}

void jumpnc(int label)
{
        opjump("nc,",label);
}

void setcond(int val)
{
        if (val == 1 ) ol("scf");
        else ol("and\ta");
}



/* Test the primary register and jump if false to label */
void testjump(LVALUE *lval,int label)
{
        ol("ld\ta,h");
        ol("or\tl");
        if (lval->val_type == LONG && WasComp(lval) ) { ol("or\td"); ol("or\te"); }
        if (lval->val_type == CPTR && WasComp(lval) ) { ol("or\te"); }
        opjump("z,",label);
}

/* test primary register against zero and jump if false */
/* Special conditions for testing char here */
void zerojump(oper, label, lval)
void (*oper)(LVALUE *,int);
int label ;
LVALUE *lval ;
{
        clearstage(lval->stage_add, 0) ;                /* purge conventional code */
#ifdef CHARCOMP0
        if      (lval->val_type == CCHAR ) {
                if (oper==testjump ) { /* !=0 or >=0U */
                        LoadAccum();
                        ol("and\ta");
                        opjump("z,",label);
                        return;
                } else if (oper==le0) { /* <=0 */
                        LoadAccum();
                        ol("and\ta");
                        ol("jr\tz,ASMPC+5");
                        opjump("p,",label);
                        return;
                } else if (oper==ge0 ) { /* > 0 */
                        LoadAccum();
                        ol("and\ta");
                        opjump("m,",label);
                        return;
                } else if (oper==gt0 ) {
                        LoadAccum();
                        ol("and\ta");
                        opjump("m,",label);
                        opjump("z,",label);
                        return;
                }

        }
#endif
        (*oper)(lval,label) ;
}


/* Print pseudo-op to define a byte */
void defbyte(void)
{
	if (asxx)
		ot(".db\t");
	else
	        ot("defb\t");
}

/*Print pseudo-op to define storage */
void defstorage(void)
{
	if (asxx)
		ot(".ds\t");
	else
	        ot("defs\t");
}

/* Print pseudo-op to define a word */
void defword(void)
{
	if (asxx)
		ot(".dw\t");
	else
        	ot("defw\t");
}

/* Print pseudo-op to dump a long */
void deflong(void)
{
        ot("defl\t");
}

/* Print pseudo-op to define a string */
void defmesg(void)
{
	if (asxx)
		ot(".ascii\t\"");
	else
        	ot("defm\t\"");
}

/* Point to following object */
void point(void)
{
	if (asxx)
		ol(".dw\t.+2");
	else
        	ol("defw\tASMPC+2");
}

/* Modify the stack pointer to the new value indicated */
int modstk(newsp,save,saveaf)
int newsp;
int save ;              /* if true preserve contents of HL */
int saveaf;		/* Preerve contents of af */
{
        int k,flag=NO;

        k = newsp - Zsp ;
        if ( k == 0 ) return newsp ;
	/* Yes this goto could be an if but this is a dev compiler! */
#ifdef USEFRAME
	if (useframe) goto modstkcht;
#endif
        if ( k > 0 ) {
                if ( k < 7 ) {
                        if ( k & 1 ) {
                                ol("inc\tsp") ;
                                --k ;
                        }
                        while ( k ) {
                                ol("pop\tbc");
                                k -= 2 ;
                        }
                        return newsp;
                }
        }
        if ( k < 0 ) {
                if ( k > -7 ) {
                        if ( k & 1 ) {
				flag=YES;
                                ++k ;
                        }
                        while ( k ) {
                                ol("push\tbc");
                                k += 2 ;
                        }
			if (flag)
                                ol("dec\tsp") ;
                        return newsp;
                }
        }
/*
 * These doexx() where swap() but if we return a long then we've fubarred
 * up!
 */
modstkcht:
	if (saveaf) doexaf();
#ifdef USEFRAME
	if (useframe) {
		ot("ld\t"); FrameP(); outstr(","); outdec(k); nl();
		ot("add\t");
		FrameP();
		outstr(",sp\n");
		RestoreSP(NO);
	} else {
        	if ( save ) doexx() ;
        	vconst(k) ;
        	ol("add\thl,sp");
        	ol("ld\tsp,hl");
        	if ( save ) doexx() ;
	}
#else
        if ( save ) doexx() ;
        vconst(k) ;
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        if ( save ) doexx() ;
#endif
	if (saveaf) doexaf();
        return newsp ;
}

/* Multiply the primary register by the length of some variable */
void scale(type, tag)
int type ;
TAG_SYMBOL *tag ;
{
        switch ( type ) {
        case CINT :
                doublereg() ;
                break ;
        case CPTR :
                threereg() ;
                break ;
        case LONG :
                doublereg();
                doublereg();
                break;
        case DOUBLE :
                sixreg() ;
                break ;
        case STRUCT :
                /* try to avoid multiplying if possible */
                quikmult(tag->size,YES);
        }
}


void quikmult(int size,char preserve)
{
                switch (size) {
                case 16 :
                        doublereg() ;
                case 8 :
                        doublereg() ;
                case 4 :
                        doublereg() ;
                case 2 :
                        doublereg() ;
                        break ;
                case 12 :
                        doublereg() ;
                case 6 :
                        sixreg() ;
                        break ;
                case 9 :
                        threereg() ;
                case 3 :
                        threereg() ;
                        break ;
                case 15 :
                        threereg() ;
                case 5 :
                        fivereg() ;
                        break ;
                case 10 :
                        fivereg() ;
                        doublereg() ;
                        break ;
                case 14 :
                        doublereg() ;
                case 7 :
                        sixreg() ;
                        addbc() ;       /* BC contains original value */
                        break ;
                default :
                        if (preserve) ol("push\tde") ;
                        const2(size) ;
                        callrts("l_mult"); /* WATCH OUT!! */
                        if (preserve) ol("pop\tde") ;
                        break ;
                }
}

/* add BC to the primary register */
void addbc(void)
{
        ol("add\thl,bc") ;
}

/* load BC from the primary register */
void ldbc(void)
{
        ol("ld\tb,h") ;
        ol("ld\tc,l") ;
}

/* Double the primary register */
void doublereg(void)
{
        ol("add\thl,hl");
}

/* Multiply the primary register by three */
void threereg(void)
{
        ldbc() ;
        addbc() ;
        addbc() ;
}

/* Multiply the primary register by five */
void fivereg(void)
{
        ldbc() ;
        doublereg() ;
        doublereg() ;
        addbc() ;
}
        
/* Multiply the primary register by six */
void sixreg(void)
{
        threereg() ;
        doublereg() ;
}

/*
 * New routines start here! What we do is have a single routine for
 * each operation type, the routine takes an lval, and it all works
 * out well..honest!
 */


/* Add the primary and secondary registers (result in primary) */
void zadd(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_add");
                        Zsp +=4;
                        break;
                case DOUBLE:
                        callrts("dadd");
                        Zsp += 6;
                        break;
                default:
                        ol("add\thl,de");
        }
}




/* Subtract the primary register from the secondary */
/*      (results in primary) */
void zsub(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_sub");
                        Zsp +=4;
                        break;
                case DOUBLE:
                        callrts("dsub");
                        Zsp += 6;
                        break;
                default:
                        callrts("l_sub");
        }
}

/* Multiply the primary and secondary registers */
/*      (results in primary */
void mult(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_mult");
                        Zsp +=4;
                        break;
                case DOUBLE:
                        callrts("dmul");
                        Zsp += 6;
                        break;
                default:
                        callrts("l_mult");
        }
}

/* Divide the secondary register by the primary */
/*      (quotient in primary, remainder in secondary) */
void zdiv(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_div_u");
                        else callrts("l_long_div");
                        Zsp +=4;
                        break;
                case DOUBLE:
                        callrts("dmul");
                        Zsp += 6;
                        break;
                default:
                        if (utype(lval)) callrts("l_div_u");
                        else callrts("l_div");
        }
}


/* Compute remainder (mod) of secondary register divided
 *      by the primary
 *      (remainder in primary, quotient in secondary)
 */
void zmod(LVALUE *lval)
{
        zdiv(lval);
        if (lval->val_type == LONG || lval->val_type==CPTR) doexx();
        else swap();
}

/* Inclusive 'or' the primary and secondary */
/*      (results in primary) */
void zor(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_or");
                        Zsp +=4;
                        break;
                default:
                        callrts("l_or");
        }
}

/* Exclusive 'or' the primary and secondary */
/*      (results in primary) */
void zxor(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_xor");
                        Zsp +=4;
                        break;
                default:
                        callrts("l_xor");
        }
}


/* 'And' the primary and secondary */
/*      (results in primary) */
void zand(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_and");
                        Zsp +=4;
                        break;
                default:
                        callrts("l_and");
        }
}

/* Arithmetic shift right the secondary register number of */
/*      times in primary (results in primary) */
void asr(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_asr_u");
                        else callrts("l_long_asr");
                        Zsp +=4;
                        break;
                default:
                        if (utype(lval)) callrts("l_asr_u");
                        else callrts("l_asr");
        }
}


/* Arithmetic left shift the secondary register number of */
/*      times in primary (results in primary) */
void asl(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_asl");
                        Zsp +=4;
                        break;
                default:
                        callrts("l_asl");
        }
}

/* Form logical negation of primary register */
void lneg(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_lneg");
                        break;
                default:
                        callrts("l_lneg");
        }
}

/* Form two's complement of primary register */
void neg(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_neg");
                        break;
                case DOUBLE:
                        callrts("minusfa");
                        break;
                default:
                        callrts("l_neg");
        }
}

/* Form one's complement of primary register */
void com(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_com");
                        break;
                default:
                        callrts("l_com");
        }
}

/*
 * Increment value held in main register
 */

void inc(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_inclong");
                        break;
                default:
                        ol("inc\thl");
        }
}

/*
 * Decrement value held in main register
 */

void dec(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_declong");
                        break;
                default:
                        ol("dec\thl");
        }
}


/* Following are the conditional operators */
/* They compare the secondary register against the primary */
/* and put a literal 1 in the primary if the condition is */
/* true, otherwise they clear the primary register */


void dummy(LVALUE *lval, int label)
{
/* Dummy function to allows us to check for c/nc at end of if clause */
}

/* test for equal to zero */
void eq0(LVALUE *lval,int label)
{
        WasComp(lval);
        switch(lval->val_type) {
#ifdef CHARCOMP0
                case CCHAR:
                        ol("ld\ta,l");
                        ol("and\ta");
                        break;
#endif
                case LONG:
                        ol("ld\ta,h");
                        ol("or\tl");
                        ol("or\td");
                        ol("or\te");
                        break;
		case CPTR:
			ol("ld\ta,e");
			ol("or\th");
			ol("or\tl");
			break;
                default:
                        ol("ld\ta,h");
                        ol("or\tl");
        }
        opjump("nz,",label);
}


void lt0(LVALUE *lval, int label)
{
        switch(lval->val_type) {
#ifdef CHARCOMP0
                case CCHAR:
                        ol("ld\ta,l");
                        ol("and\ta");
                        break;
#endif
                case LONG:
                        ol("xor\ta");
                        ol("or\td");
                        break;
                case CPTR:
                        ol("xor\ta");
                        ol("or\te");
                        break;
                default:
                        ol("xor\ta");
                        ol("or\th");
        }
        opjump("p,",label);
}

/* Test for less than or equal to zero */
void le0(LVALUE *lval, int label)
{
        ol("ld\ta,h") ;
        ol("or\tl");
        if (lval->val_type==LONG) { ol("or\td"); ol("or\te"); }
        if (lval->val_type==CPTR) { ol("or\te"); }
        ol("jr\tz,ASMPC+7");
        lt0(lval,label);
}

/* test for greater than zero */
void gt0(LVALUE *lval,int label)
{
        ge0(lval,label) ;
        ol("or\tl");
        opjump("z,",label);
}


/* test for greater than or equal to zero */
void ge0(LVALUE *lval, int label)
{
        ol("xor\ta") ;
	switch(lval->val_type) {
		case LONG:
			ol("or\td");
			break;
		case CPTR:
			ol("or\te");
			break;
		default:
			ol("or\th");
	}
        opjump("m,",label);
}




/* Test for equal */
void zeq(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_eq");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("deq");
                        Zsp+=6;
                        break;
                default:
                        callrts("l_eq");
        }
}


/* Test for not equal */
void zne(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        callrts("l_long_ne");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("dne");
                        Zsp+=6;
                        break;
                default:
                        callrts("l_ne");
        }
}

/* Test for less than*/
void zlt(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_ult");
                        else callrts("l_long_lt");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("dlt");
                        Zsp+=6;
                        break;
                default:
                        if (utype(lval)) callrts("l_ult");
                        else callrts("l_lt");
        }
}


/* Test for less than or equal to (signed/unsigned) */
void zle(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_ule");
                        else callrts("l_long_le");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("dleq");
                        Zsp+=6;
                        break;
                default:
                        if (utype(lval)) callrts("l_ule");
                        else callrts("l_le");
        }
}



/* Test for greater than (signed/unsigned) */
void zgt(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_ugt");
                        else callrts("l_long_gt");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("dgt");
                        Zsp+=6;
                        break;
                default:
                        if (utype(lval)) callrts("l_ugt");
                        else callrts("l_gt");
        }
}

/* Test for greater than or equal to */
void zge(LVALUE *lval)
{
        switch(lval->val_type) {
                case LONG:
		case CPTR:
                        if (utype(lval)) callrts("l_long_uge");
                        else callrts("l_long_ge");
                        Zsp+=4;
                        break;
                case DOUBLE:
                        callrts("dge");
                        Zsp+=6;
                        break;
                default:
                        if (utype(lval)) callrts("l_uge");
                        else callrts("l_ge");
        }
}


/*
 *      Routines for conversion between different types, kept in this
 *      file to aid conversion etc
 */

/* Unsigned int to long */
void convUint2long(void)
{
        const2(0);
}

/* Signed int to long */
void convSint2long(void)
{
        callrts("l_int2long_s");
}

/* signed Int to doub */
void convSint2doub(void)
{
        callrts("float");
}

/* unsigned int to double */

void convUint2doub(void)
{
        callrts("ufloat");
}

/* signed long to double */
void convSlong2doub(void)
{
        convSint2doub();
}

/* unsigned long to double */
void convUlong2doub(void)
{
        convUint2doub();
}

/* double to integerl/long */
void convdoub2int(void)
{
        callrts("ifix");
}

/* Swap double positions on stack */

void DoubSwap(void)
{
        callrts("dswap");
}


/*
 * Load long into hl and de 
 * Takes respect of sign, so if signed and high word=0 then
 * print 65535 else print whats there..could possibly come unstuck!
 * this is so that -1 -> -32768 are correcly represented
 *
 * djm 21/2/99 fixed, so that sign is disregarded! this allows us
 * to have -1 entered correctly
 */

void vlongconst(unsigned long val)
{
        vconst(val%65536);
        const2(val/65536);
}


/*
 * load constant into primary register
 */
void vconst(val)
int val ;
{
        immed();
        outdec(val);
        ot(";const\n");
}

/*
 * load constant into secondary register
 */
void const2(val)
int val ;
{
        immed2();
        outdec(val);
        nl();
}

void addbchl(int val)
{
        ot("ld\tbc,");
        outdec(val);
        outstr("\n\tadd\thl,bc\n");
}

/* Load accumulator with lower half of int */

void LoadAccum(void)
{
        ol("ld\ta,l");
}

/* Compare the accumulator with a value (mod 256) */

void CpCharVal(int val)
{
        ot("cp\t#(");
        outdec(val);
        outstr("% 256)\n");
}


/*
 *      Print prefix for global defintion
 */

void GlobalPrefix(char type)
{
	if (asxx) {
		ot(".globl\t");
		return;
	}
        switch(type) {
                case XDEF:
                        ot("XDEF\t");
                        break;
                case XREF:
                        ot("XREF\t");
                        break;
                case LIB:
                        ot("LIB\t");
                        break;
        }
}

/*
 *	Emit a LINE opcode for assembler
 *	error reporting
 */

void EmitLine(int line)
{
	if (!asxx && ctext ) {
		ot("LINE\t");
		outdec(line);
		nl();
	}
}

#ifdef USEFRAME
/*
 * Check offset is within range for frame pointer
 */
		
int CheckOffset(int val)
{
	if (val>=-126 && val<=127 ) return 1;
	return 0;
}


/*
 *	Output offset to index register
 *
 *	FRAME POINTER STUFF IS BROKEN - DO NOT USE!!!
 */

void OutIndex(int val)
{
	if	(asxx) {
		outdec(val);
		if (indexix)
			outstr("(ix)");
		else
			outstr("(iy)");
	} else {
		outstr("(");
		if (indexix)
			outstr("ix ");
		else
			outstr("iy ");
		if (val >= 0 )
			outstr("+");
		outdec(val);
		outstr(")");
	}
}


void RestoreSP(char saveaf)
{
	if (saveaf) doexaf();
	ot("ld\tsp,");
	FrameP();
	nl();
	if (saveaf) doexaf();
}

void pushframe(void)
{
#ifdef USEFRAME
	if (!useframe) return;
	ot("push\t");
	FrameP();
	nl();
#endif
}

void popframe(void)
{
#ifdef USEFRAME
	if (!useframe) return;
	ot("pop\t");
	FrameP();
	nl();
#endif
}

void setframe(void)
{
#ifdef USEFRAME
	if (!useframe) return;
	ot("ld\t");
	FrameP();
	outstr(",0\n");
	ot("add\t");
	FrameP();
	outstr(",sp\n");
#endif
}


void FrameP(void)
{
	if (indexix)
		outstr("ix");
	else
		outstr("iy");
}

#endif

