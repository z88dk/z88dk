/* 
	HTC Compatibility Library and OZ extras 
	2. KEYBOARD AND INPUT

	$Id: ozinput.h,v 1.6 2016-06-28 17:11:31 dom Exp $
*/

#ifndef _OZINPUT_H
#define _OZINPUT_H

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

#include <sys/compiler.h>

/* functions renamed to have a double mode
   use the -DOZDK parameter to activate this */

#ifdef OZDK
extern int __LIB__ oznkeyhit2(void);
extern int __LIB__ ozkeyhit2(void);
extern unsigned __APPFUNC__ __LIB__ ozgetch2(void);
extern unsigned __LIB__ ozngetch2(void);
extern unsigned __LIB__ ngetch2(void);
extern __LIB__ ozungetch2(unsigned key);
#endif

extern __LIB__ ozrestorekeysettings(void);
extern __LIB__ ozsavekeysettings(void);
#define SETTINGS_LENGTH 14
extern __LIB__ ozcopyfromcursettings(byte *p);
extern __LIB__ ozcopytocursettings(byte *p);

#define OZEDITLINE_ERROR  -2
#define OZEDITLINE_CANCEL -1
//extern int __LIB__ ozeditline(int x0,int y0,char *s,int slen,int xlen);
extern int __LIB__ ozeditline(int x0,int y0,char *s,int slen,int xlen) __smallc;

extern __LIB__ ozkbdon(void);
extern __LIB__ ozkbdoff(void);
extern __LIB__ ozkeyclear(void);
extern byte __LIB__ ozkeyupper(int mask);
extern byte __LIB__ ozkeylower(int mask);
//extern unsigned __LIB__ getch(void);
//extern int __LIB__ kbhit(void);
//extern int __LIB__ nkbhit(void);
extern byte __LIB__ ozgetrepeatspeed(void);
extern byte __LIB__ ozgetrepeatdelay(void);
extern __LIB__ ozsetrepeatspeed(int val);
extern __LIB__ ozsetrepeatdelay(int val);
extern __LIB__ ozclick(int state);
extern byte __LIB__ ozgetclick(void);
extern byte _ozkeyrepeatspeed;
extern byte _ozkeyrepeatdelay;

#ifndef _OZMENU_H
#define _OZMENU_H

struct ozmenuentry
{
    unsigned key;
    char *label;
};

extern int __LIB__ ozmenu(int x,int y,char *title,unsigned start,unsigned num_entries, struct ozmenuentry *menu, int options) __smallc;
#define OZMENU_NUMBERED 1
#define OZMENU_NOEXIT   2
#define OZMENU_NOLIGHT  4

#endif

/* for ozgetch() */
#define KEY_LEFT_SHIFT  0x0800
#define KEY_RIGHT_SHIFT 0x8036
#define KEY_2ND         0x8037
#define KEY_LOWER_ESC   0x8058
#define KEY_UPPER_ESC   0x8067
#define KEY_NEWLINE     0x0D
#define KEY_RETURN      0x0D
#define KEY_MYPROGRAMS  0x7015
#define KEY_MAIN        0x7025
#define KEY_USER1       0x70E9
#define KEY_USER2       0x70EA
#define KEY_USER3       0x70EB
#define KEY_TELEPHONE   KEY_USER1
#define KEY_SCHEDULE    KEY_USER2
#define KEY_CALENDAR    KEY_USER2
#define KEY_MEMO        KEY_USER3
#define KEY_LOWER_MENU  0x8032
#define KEY_NEW         0x8033
#define KEY_BACKSPACE   0x0008
#define KEY_BACKSPACE_16K 0x8057
#define KEY_CATEGORY    0x8035
#define KEY_LOWER_ENTER 0x8038
#define KEY_POWER       0x803A
#define KEY_BACKLIGHT   0x803B
#define KEY_DOWN        0x8041
#define KEY_UP          0x8040
#define KEY_LEFT        0x8042
#define KEY_RIGHT       0x8043
#define KEY_PAGEUP      0x8044
#define KEY_PAGEDOWN    0x8045
#define KEY_DEL         0x8057
#define KEY_UPPER_ENTER 0x8066
#define KEY_UPPER_MENU  0x8068

/* for getch() */
#define NO_KEY       0xFFFF
#define MASKSHIFT    0x0800
#define MASKCATEGORY 0x0400
#define MASKCTRL     0x0200
#define MASK2ND      0x0100

#ifndef NULL
#define NULL ((void*)0)
#endif


extern unsigned __LIB__ ozautoofftime;
extern unsigned __LIB__ ozautoblanktime;
extern unsigned __LIB__ ozautolightofftime;

extern unsigned __LIB__ ozgetchblank(void);

#endif
