/*
 *      Small C+ Compiler
 *
 *      Routines for symbol hashing etc
 *
 *      $Id: sym.c,v 1.1.1.1 2000-07-04 15:33:32 dom Exp $
 */

#include "ccdefs.h"

int hash(sname)
char *sname;
{
        int c, h ;

        h = *sname;
        while( (c = *(++sname)) ) h=(h<<1)+c;
        return (h & MASKGLBS) ;
}

/* djm
 * Find a local static variable - uses findglb after first kludging the
 * name to a hopefully unique identifier!
 */

SYMBOL *findstc(sname)
char *sname;
{
        char    sname2[3*NAMESIZE];     /* Should be enuff! */
        strcpy(sname2,"st_");
	if (currfn)
        	strcat(sname2,currfn->name);
        strcat(sname2,"_");
        strcat(sname2,sname);
        return (findglb(sname2));
}
                

/*
 * find entry in global symbol table,
 * glbptr is set to relevant entry
 * return pointer if match is found,
 * else return zero and glbptr points to empty slot
 */

SYMBOL *findenum(char *sname)
{
        SYMBOL *ptr;
        if ( (ptr=findglb(sname)) ) {
                if (ptr->ident==ENUM) return(ptr);
                else error(E_ENUMDEF);
        }
        return(0);
}

SYMBOL *findglb(sname)
char *sname ;
{
        glbptr = STARTGLB + hash(sname) ;
        while ( strcmp(sname, glbptr->name) ) {
                if ( glbptr->name[0] == 0 ) return 0 ; 
                ++glbptr ;
                if (glbptr == ENDGLB) glbptr = STARTGLB;
        }
        return glbptr ;
}

SYMBOL *findloc(sname)
char *sname ;
{
        SYMBOL *ptr ;

        ptr = STARTLOC ;
        while ( ptr != locptr ) {
                if ( strcmp(sname, ptr->name) == 0 )
                        return ptr;
                ++ptr ;
        }
        return 0;
}

/*
 * find symbol in structure tag symbol table, return 0 if not found
 */

TAG_SYMBOL *findtag(sname)
char *sname ;
{
        TAG_SYMBOL *ptr ;

        ptr = STARTTAG ;
        while ( ptr != tagptr ) {
                if ( strcmp(ptr->name, sname) == 0 )
                        return ptr ;
                ++ptr ;
        }
        return 0 ;
}

/*
 * determine if 'sname' is a member of the struct with tag 'tag'
 * return pointer to member symbol if it is, else 0
 */

SYMBOL *findmemb(tag, sname)
TAG_SYMBOL *tag ;
char *sname ;
{
        SYMBOL *ptr ;

        ptr = tag->ptr ;

        while ( ptr < tag->end ) {
                if ( strcmp(ptr->name, sname) == 0 )
                        return ptr ;
                ++ptr ;
        }
        return 0 ;
}


SYMBOL *addglb(
char *sname,char id,char typ,
int value,int storage,int more, int itag)
{
        SYMBOL *ptr;
        if ( (ptr=findglb(sname)) ) {
/*
 * djm, this is not to be abused!!!!
 *
 * This bit of code allows us to overturn extern declaration of stuff,
 * Useful for those programs which extern everything in header files
 * 
 */
                if ( (ptr->storage==EXTERNAL && storage !=EXTERNAL) && ptr->type==typ && ptr->ident == id && ptr->more==more && itag==ptr->tag_idx ) { ptr->storage=storage; return (ptr); }
                multidef() ;
                return (glbptr) ;
        }
        if ( glbcnt >= NUMGLBS-1 ) {
                error(E_GLBOV);
                return 0;
        }
        addsym(glbptr, sname, id, typ, storage, more, itag) ;
        glbptr->offset.i = value ;
        ++glbcnt ;
        return (glbptr);
}

SYMBOL *addloc(
char *sname, 
char id,
char typ ,
int more,
int itag)
{
        SYMBOL *cptr ;

        if ( (cptr=findloc(sname)) ) {
                multidef() ;
                return cptr;
        }
        if ( locptr >= ENDLOC ) {
                error(E_LOCOV);
                return 0;
        }
        cptr = locptr++ ;
        addsym(cptr, sname, id, typ, STKLOC, more, itag) ;
        return cptr ;
}

/*
 * add new structure member to table
 */
SYMBOL *addmemb(
char *sname,
char id,
char typ ,
int value,
int  storage,
int  more,
int  itag)
{
        if ( membptr >= ENDMEMB ) {
                error(E_MEMOV) ;
                return 0;
        }
        addsym(membptr, sname, id, typ, storage, more, itag) ;
        membptr->offset.i = value ;
        ++membptr ;
        return(membptr);
}

/*
 * insert values into symbol table
 */

void addsym(
SYMBOL *ptr ,
char *sname,
char id,
char  typ ,
int storage,
int  more,
int itag )
{
        strcpy(ptr->name, sname) ;
        ptr->ident = id ;
        ptr->type = typ ;
        ptr->storage = storage ;
        ptr->more = more ;
        ptr->tag_idx = itag ;
        ptr->flags = 0;
}
