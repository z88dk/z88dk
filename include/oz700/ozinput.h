/* 
	HTC Compatibility Library and OZ extras 
	2. KEYBOARD AND INPUT

	$Id: ozinput.h,v 1.1 2003-10-14 10:08:35 dom Exp $
*/

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

void ozrestorekeysettings(void);
void ozsavekeysettings(void);
#define SETTINGS_LENGTH 14
void ozcopyfromcursettings(byte *p);
void ozcopytocursettings(byte *p);

#define OZEDITLINE_ERROR  -2
#define OZEDITLINE_CANCEL -1
int ozeditline(byte x0,byte y0,char *s,byte slen,byte xlen);
int oznkeyhit(void);
int ozkeyhit(void);
unsigned ozgetch(void);
unsigned ozngetch(void);
unsigned ngetch(void);
void ozungetch(unsigned key);
void ozkbdon(void);
void ozkbdoff(void);
void ozkeyclear(void);
byte ozkeyupper(byte mask);
byte ozkeylower(byte mask);
unsigned getch(void);
int kbhit(void);
int nkbhit(void);
byte ozgetrepeatspeed(void);
byte ozgetrepeatdelay(void);
void ozsetrepeatspeed(byte val);
void ozsetrepeatdelay(byte val);
void ozclick(byte state);
byte ozgetclick(void);
extern byte _ozkeyrepeatspeed;
extern byte _ozkeyrepeatdelay;

#ifndef _OZMENU_H
#define _OZMENU_H

struct ozmenuentry
{
    unsigned key;
    char *label;
};

int ozmenu(int x,int y,char *title,unsigned start,unsigned num_entries,
    struct ozmenuentry *menu, byte options);
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


extern unsigned ozautoofftime;
extern unsigned ozautoblanktime;
extern unsigned ozautolightofftime;

unsigned ozgetchblank(void);

