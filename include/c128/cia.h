/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: cia.h,v 1.2 2016-06-16 21:13:06 dom Exp $

*/

#ifndef __C128CIA_H__
#define __C128CIA_H__

#include <sys/compiler.h>

#ifndef uchar
  #define uchar unsigned char
#endif

#ifndef ushort
  #define ushort unsigned int
#endif

#ifndef ulong
  #define ulong unsigned long
#endif


#define cia1 0xDC00 /* complex interface adapter #1 */
#define cia2 0xDD00 /* complex interface adapter #2 */

#define ciaDataA     0 /* cia registers */
#define ciaDataB     1
#define ciaDataDirA  2
#define ciaDataDirB  3
#define ciaTimerALo  4
#define ciaTimerAHi  5
#define ciaTimerBLo  6
#define ciaTimerBHi  7
#define ciaTODTen    8
#define ciaTODSec    9
#define ciaTODMin   10
#define ciaTODHrs   11
#define ciaSerial   12
#define ciaIntCtrl  13
#define ciaControlA 14
#define ciaControlB 15

#define vicExtKey    0xD02F   /* not part of cia, but used for key scan */

#define ciaTimerFreq 1022730L /* cia timer freq */
#define ciaClearIcr  0x7F     /* clear all cia irq enable bits */
#define ciaCPUCont   0x11     /* load latch, start timer, count cpu cycles continuous */
#define ciaCPUOne    0x19     /* load latch, start timer, count cpu cycles one shot */
#define ciaCountA    0x51     /* load latch, start timer, count timer a */

#define ciaNone      0x1F     /* joy stick direction masks */
#define ciaFire      0x10
#define ciaUp        0x01
#define ciaDown      0x02
#define ciaLeft      0x04
#define ciaRight     0x08
#define ciaUpLeft    0x05
#define ciaUpRight   0x09
#define ciaDownLeft  0x06
#define ciaDownRight 0x0A

#define ciaPotsPort1 0x40     /* 4066 analog switch settings for cia 1 */
#define ciaPotsPort2 0x80

//typedef uchar ciaTODRec[4];   /* types for various cia related functions */
//typedef char  ciaTODStr[12];
//typedef uchar ciaTODRec[4];   /* types for various cia related functions */
//typedef char  ciaTODStr[12];
//typedef uchar ciaKeyRec[11];
//#define ciaTODRec unsigned char *
//#define ciaTODStr char *
#define ciaKeyRec unsigned char *

extern void __LIB__ gettodcia (ushort C, uchar *TOD) __smallc;
extern void __LIB__ settodcia (ushort C, uchar *TOD) __smallc;
extern void __LIB__ todcharcia (uchar Bcd, char *TODStr) __smallc;
extern void __LIB__ todstrcia (uchar *TOD, char *TODStr) __smallc;

extern void __LIB__ setintctrlcia (ushort C, ushort Icr) __smallc;

extern void __LIB__ settimeracia (ushort C, ushort Latch, ushort CtrlReg) __smallc;
extern ushort __LIB__ gettimeracia (ushort C);
extern void __LIB__ settimerbcia (ushort C, ushort Latch, ushort CtrlReg) __smallc;
extern ushort __LIB__ gettimerbcia (ushort C);
extern ushort __LIB__ timervalcia (ulong Hz);

extern void __LIB__ getjoyscia(void);
extern char __LIB__ *getkeyscia(void);


#endif
