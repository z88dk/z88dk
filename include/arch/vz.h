#ifndef _VZ
#define _VZ

#include <sys/compiler.h>


// VZ Specific Library
// 01.2007 aralbrec


/*****************************************************

	Video Technology library for small C compiler

		Juergen Buchmueller & Jason Oakley

*****************************************************/

// first CALLER and FASTCALL linkage

extern void __LIB__              vz_char_draw(int x, int y, int c, int ch) __smallc;
extern void __LIB__              vz_coursescroll(void *addr, int byte) __smallc;
extern void __LIB__              vz_disableirq(void);
extern void __LIB__              vz_drawsprite(int x, int y, int n) __smallc;
extern void __LIB__              vz_enableirq(void);
extern int  __LIB__              vz_getch(void);
extern int  __LIB__              vz_getrnd(int x);
extern void __LIB__              vz_inch(void);
extern char __LIB__             *vz_midstr(char *str, int pos) __smallc;
extern char __LIB__              vz_peek(void *addr) __smallc;
extern void __LIB__              vz_poke(void *addr, int byte) __smallc;
extern void __LIB__              vz_printat(int x, int y, void *addr) __smallc;
extern void __LIB__				 vz_printnum(int x);
extern void __LIB__              vz_randomize(void);
extern void __LIB__              vz_score(void *addr, int byte) __smallc;
extern void __LIB__				 vz_setpaper(char x) __z88dk_fastcall;
extern void __LIB__              vz_setspritesize(int w, int h) __smallc;
extern void __LIB__              vz_setspritedata(void *addr) __smallc;
extern void __LIB__              vz_shape(int x, int y, int w, int h, int c, char *data) __smallc;
extern void __LIB__              vz_smoothscroll(void *addr, int byte) __smallc;
extern void __LIB__              vz_sound(int freq, int cycles) __smallc;
extern void __LIB__              vz_soundcopy(char *dst, char *src, int size, int sound1, int sound2) __smallc;
extern void __LIB__              vz_waitvb(void);

// CALLEE linkage for functions with at least two parameters

extern void __LIB__    vz_coursescroll_callee(void *addr, int byte) __smallc __z88dk_callee;
extern void __LIB__    vz_drawsprite_callee(int x, int y, int n) __smallc __z88dk_callee;
extern char __LIB__   *vz_midstr_callee(char *str, int pos) __smallc __z88dk_callee;
extern void __LIB__    vz_poke_callee(void *addr, int byte) __smallc __z88dk_callee;
extern void __LIB__    vz_printat_callee(int x, int y, void *addr) __smallc __z88dk_callee;
extern void __LIB__    vz_score_callee(void *addr, int byte) __smallc __z88dk_callee;
extern void __LIB__    vz_setspritesize_callee(int w, int h) __smallc __z88dk_callee;
extern void __LIB__    vz_smoothscroll_callee(void *addr, int byte) __smallc __z88dk_callee;
extern void __LIB__    vz_sound_callee(int freq, int cycles) __smallc __z88dk_callee;
extern void __LIB__    vz_soundcopy_callee(char *dst, char *src, int size, int sound1, int sound2) __smallc __z88dk_callee;

// make the CALLEE linkage default, function pointers will use CALLER linkage

#define vz_coursescroll(a,b)	 vz_coursescroll_callee(a,b)
#define vz_drawsprite(a,b,c)  	 vz_drawsprite_callee(a,b,c)
#define vz_midstr(a,b)           vz_midstr_callee(a,b)
#define vz_poke(a,b)			 vz_poke_callee(a,b)
#define vz_printat(a,b,c)        vz_printat_callee(a,b,c)
#define vz_score(a,b)            vz_score_callee(a,b)
#define vz_setspritesize(a,b)    vz_setspritesize_callee(a,b)
#define vz_smoothscroll(a,b)	 vz_smoothscroll_callee(a,b)
#define vz_sound(a,b)            vz_sound_callee(a,b)
#define vz_soundcopy(a,b,c,d,e)  vz_soundcopy_callee(a,b,c,d,e)

#endif
