/*
 *      Small C+ Compiler
 *
 *      The rather simple preprocessor is here
 *
 *      $Id: preproc.c,v 1.2 2002-02-05 21:02:03 dom Exp $
 */

#include "ccdefs.h"

void junk()
{
        if(an(inbyte()))
                while(an(ch()))gch();
        else while(an(ch())==0) {
                if(ch()==0)break;
                gch();
        }
        blanks();
}



char ch()
{
        return line[lptr] ;
}

char nch()
{
        if ( ch() )
                return line[lptr+1] ;
        return 0;
}

char gch()
{
        if ( ch() )
                return line[lptr++] ;
        return 0;
}

void clear()
{
        lptr = 0 ;
        line[0] = 0 ;
}

char inbyte()
{
        while(ch()==0) {
                if (eof) return 0;
                preprocess();
        }
        return gch();
}


void vinline()
{
        FILE *unit ;
        int k ;

        while(1) {
                if ( input == NULL_FD ) openin() ;
                if ( eof ) return ;
                if( (unit=inpt2) == NULL_FD ) unit = input ;
                clear() ;
                while ( (k=getc(unit)) > 0 ) {
                        if ( k == '\n' || k == '\r' || lptr >= LINEMAX ) break;
                        line[lptr++]=k;
                }
                line[lptr] = 0 ;        /* append null */
                if (k != '\r') 
		    ++lineno ;      /* read one more line */
                if ( k <= 0 ) {
                        fclose(unit);
                        if ( inpt2  != NULL_FD ) endinclude() ;
                                else { input = 0; eof=1; }
                }
                if ( lptr ) {
                        if( ctext && cmode ) {
                                comment();
                                outstr(line);
                                nl();
                        }
                        lptr=0;
                        return;
                }
        }
}

/*
 * ifline - part of preprocessor to handle #ifdef, etc
 */
void ifline()
{
        char sname[NAMESIZE] ;
        endasm=0;

        while ( 1 ) {

                vinline() ;
                if ( eof ) return ;

                if ( ch() == '#' ) {

                        if ( match("#pragma") ) {
                                dopragma();
                                if (endasm) break;
                                continue ;
                        }

                        if ( match("#undef") ) {
                                delmac() ;
                                continue ;
                        }

                        if ( match("#ifdef") ) {
                                ++iflevel ;
                                if ( skiplevel ) continue ;
                                symname(sname) ;
                                if ( findmac(sname) == 0 )
                                        skiplevel = iflevel ;
                                continue ;
                        }

                        if ( match("#ifndef") ) {
                                ++iflevel ;
                                if ( skiplevel ) continue ;
                                symname(sname) ;
                                if ( findmac(sname) )
                                        skiplevel = iflevel ;
                                continue ;
                        }

                        if ( match("#else") ) {
                                if ( iflevel ) {
                                        if ( skiplevel == iflevel )
                                                skiplevel = 0 ;
                                        else if ( skiplevel == 0 )
                                                skiplevel = iflevel ;
                                }
                                else
                                        noiferr() ;
                                continue ;
                        }

                        if ( match("#endif") ) {
                                if ( iflevel ) {
                                        if ( skiplevel == iflevel )
                                                skiplevel = 0 ;
                                        --iflevel ;
                                }
                                else
                                        noiferr() ;
                                continue ;
                        }
                        if ( match("# ") || match("#line") ) {
                                int     num=0;
                                char    string[FILENAME_LEN+1];
                                string[0]=0;
                                sscanf(line+lptr,"%d %s",&num,string);
                                if   (num) lineno=--num;
                                if      (strlen(string)) strcpy(Filename,string);
                                if (lineno==0) DoLibHeader();
                                continue;
                        }

                }

                if ( skiplevel )
                        continue ;

                if ( ch() == 0 )
                        continue ;

                break ;
        }
}

void noiferr()
{
        error(E_MISSIF) ;
}

void keepch(char c)
{
        mline[mptr] = c ;
        if ( mptr < MPMAX ) ++mptr ;
}


/* The preprocessor here is pants, and messes up all sorts of
   things - best leave it to the external preprocessor to do all
   the dirty work
*/
void preprocess()
{
        char c,sname[NAMESIZE];
        int k;

        ifline() ;
	return;
#if 0
        if ( eof || cmode == 0 ) {
                /* while passing through assembler, only do #if, etc */
                return ;
        }
        mptr = lptr = 0 ;
        while ( ch() ) {
                if ( ch()==' ' || ch()=='\t' ) {
                        keepch(' ');
                        while ( ch()==' ' || ch()=='\t' )
                                gch();
                }
                else if(ch()=='"') {
                        keepch(ch());
                        gch();
			do {
                          while ( ch()!='"' || (line[lptr-1]==92 && line[lptr-2]!=92 ) ) {
                                if(ch()==0) {
                                        warning(W_EXPQT);
                                        break;
                                }
                                keepch(gch());
                          }
			} while (gch() && cmatch('"')  );
                        keepch('"');
                }
                else if(ch()==39) {
                        keepch(39);
                        gch();
                        while ( ch()!=39 || (line[lptr-1]==92 && line[lptr-2]!=92) ) {
                                if(ch()==0) {
                                        warning(W_EXPAPO);
                                        break;
                                }
                                keepch(gch());
                        }
                        gch();
                        keepch(39);
                }
/*
                else if (amatch("typedef"))
                        {
                                        warning(W_TYPEDEF);
                                        junk();
                                        vinline();
                                        if (eof) break;
                        }
 */
                else if (ch()=='/' && nch()=='/' && (cppcom))
                        {
                                        junk();
                                        vinline();
                                        if (eof) break;
                        }
                else if ( ch()=='/' && nch()=='*' ) {
                        lptr += 2;
                        while ( ch()!='*' || nch()!='/' ) {
                                if ( ch() ) {
                                        ++lptr;
                                }
                                else {
                                        vinline() ;
                                        if(eof)break;
                                }
                        }
                        lptr += 2;
                }
/*
 * Some preprocessor directives, if they get this far then we are running
 * the compiler directly, so we need the quotes around filename
 */
                else if ( amatch("__LINE__")){
                        sprintf(sname,"%d",lineno);
                        for (k=0 ; k<strlen(sname) ; k++ )
                                keepch(sname[k]);
                }
                else if ( amatch("__FILE__") ) {
                        keepch('"');
                        for (k=0 ; k<strlen(Filename) ; k++ )
                                keepch(Filename[k]);
                        keepch('"');
                }
                else if ( alpha(ch()) ) {
                        k = 0 ;
                        while ( an(ch()) ) {
                                if ( k < NAMEMAX )
                                        sname[k++] = ch() ;
                                gch();
                        }
                        sname[k]=0;
                        if( (k=findmac(sname)) )
                                while( (c=macq[k++]) )
                                        keepch(c);
                        else {
                                k=0;
                                while( (c=sname[k++]) )
                                        keepch(c);
                        }
                }
                else keepch(gch());
        }
        keepch(0);
        if ( mptr >= MPMAX ) error(E_TOOLONG) ;
        strcpy(line, mline) ;
        lptr = 0 ;
#endif
}


void addmac()
{
        char sname[NAMESIZE];

        if ( symname(sname) == 0 ) {
                illname(sname);
                clear();
                return;
        }
        addglb(sname, MACRO, 0, macptr, STATIK, 0, 0) ;
        while ( ch()==' ' || ch()=='\t' ) gch() ;
        while ( putmac(gch()) ) ;
        if ( macptr >= MACMAX ) error(E_MACOV) ;
}

/*
 * delete macro from symbol table, but leave entry so hashing still works
 */

void delmac()
{
        char sname[NAMESIZE] ;
        SYMBOL *ptr ;

        if ( symname(sname) ) {
                if ( (ptr=findglb(sname)) ) {
                        /* invalidate name */
                        ptr->name[0] = '0' ;
                }
        }
}

char putmac(char c)
{
        macq[macptr] = c ;
        if ( macptr < MACMAX ) ++macptr ;
        return (c) ;
}

int findmac(sname)
char *sname;
{
        if( findglb(sname) != 0 && glbptr->ident == MACRO ) {
                return (glbptr->offset.i) ;
        }
        return (0) ;
}

/*
 * defmac - takes macro definition of form name[=value] and enters
 *          it in table.  If value is not present, set value to 1.
 *          Uses some shady manipulation of the line buffer to set
 *          up conditions for addmac().
 */


void defmac(char *text)
{
        char *p ;

        /* copy macro name into line buffer */
        p = line ;
        while ( *text != '=' && *text ) {
                *p++ = *text++ ;
        }
        *p++ = ' ' ;
        /* copy value or "1" into line buffer */
        strcpy(p, (*text++) ? text : "1") ;
        /* make addition to table */
        lptr = 0 ;
        addmac() ;
}
 
