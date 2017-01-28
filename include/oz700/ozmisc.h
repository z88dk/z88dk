/* 
	HTC Compatibility Library and OZ extras 

	$Id: ozmisc.h,v 1.4 2016-06-28 17:11:31 dom Exp $
*/

#ifndef _OZMISC_H
#define _OZMISC_H

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

#define ozis770() (MODEL770PC==ozdetectmodel())

//void ozsetautorun(byte number);
byte ozgetautorun(void);

byte ozgetmembyte(unsigned page, unsigned offset);

extern __LIB__ ozfarmemcpy(unsigned dest_page,unsigned dest_offset,unsigned src_page,
  unsigned src_offset,unsigned length) __smallc;

extern __LIB__ ozcopytopage(unsigned dest_page,unsigned dest_offset,byte *src,unsigned length) __smallc;

extern __LIB__ ozexitto(unsigned key);
extern __LIB__ ozfast(void);
//void ozslow(void);
#define ozslow ozunblankscreen

extern __LIB__ ozkeyclick(void);

extern __LIB__ ozdelay(unsigned d);
//void exit(int ignored_exit_code);
extern byte __LIB__ ozportin(int port);
extern __LIB__ ozportout(int port, int value) __smallc;

extern __LIB__ ozsound(unsigned value);
extern __LIB__ ozquiet(void);
extern __LIB__ ozinitsound(void);



extern unsigned _oz1hz;
extern unsigned _oz64hz_word;
extern unsigned long _oz64hz_dword;



byte __LIB__ ozdetectmodel(void);

#define MODELMASK_MEMORY 1
#define MODELMASK_770	 2
#define MODELMASK_M 	 4
#define MODEL700PC 0
#define MODEL730PC 0
#define MODEL750PC MODELMASK_MEMORY
#define MODEL770PC (MODELMASK_MEMORY | MODELMASK_770)
#define MODEL700M  MODELMASK_M
#define MODEL750M  (MODELMASK_MEMORY | MODELMASK_M)
#define MODEL770M  (MODELMASK_MEMORY | MODELMASK_770 | MODEMASK_M)
					  /* 770M NOT YET EXISTENT OR DETECTED, BUT IF IT IS */
					  /* MADE, THAT WILL BE ITS MODEL NUMBER */

char __LIB__ *ozgetnextfilename(byte mode);
#define FIND_RESET 1
#define FIND_OWNED 2


byte __LIB__ ozgetpowerkeyhandling(void);
extern __LIB__  ozsetpowerkeyhandling(int state);

extern unsigned __LIB__ ozkeydelay64hz(unsigned len);
extern __LIB__  ozdelay64hz(unsigned length);

extern __LIB__  oz64hztimeron(void);
extern __LIB__  oz64hztimeroff(void);
extern byte __LIB__ ozget64hztimerstate(void);
extern __LIB__  ozinstallmemorywiper(void);

extern byte __LIB__  _ozprogoptions;
extern byte __LIB__  _ozclick_setting;

#define OZ_OPTION_SCROLL_FULL 1
#define OZ_OPTION_NO_SOUND    2
#define OZ_OPTION_KEY_AFTER_BLANK 4

extern byte __LIB__  ozgetstatus(void);
#define OZ_STATUS_CAPSLOCK 2
#define OZ_STATUS_LOCKED 16
#define OZ_STATUS_BACKLIGHT 64
#define OZ_STATUS_BATTERYLOW 128

//#ifndef NULL
//#define NULL ((void*)0)
//#endif

#endif
