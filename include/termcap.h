/*
 *      Small C+ Library
 *
 *  termcap.h
 * 
 *      stefano - 6/6/2012
 *
 *	$Id: termcap.h,v 1.1 2012-10-24 06:44:12 stefano Exp $
 */

#ifndef __TERMCAP_H__
#define __TERMCAP_H__


extern int tgetent (char *buffer, const char *termtype);

extern int tgetnum (const char *name);
extern int tgetflag (const char *name);
extern char *tgetstr (const char *name, char **area);

extern char PC;
extern short ospeed;
extern void tputs (const char *string, int nlines, int (*outfun) (int));

extern char *tparam (const char *ctlstring, char *buffer, int size, ...);

extern char *UP;
extern char *BC;

extern char *tgoto (const char *cstring, int hpos, int vpos);

#endif /* __TERMCAP_H__ */
