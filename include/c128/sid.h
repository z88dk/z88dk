/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: sid.h,v 1.2 2016-06-16 21:13:06 dom Exp $

*/

#ifndef __C128SID_H__
#define __C128SID_H__

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


#define sidVoice1   0xD400 /* voices */
#define sidVoice2   0xD407
#define sidVoice3   0xD40E
#define sidCutoffLo 0xD415 /* cutoff filter */
#define sidCutoffHi 0xD416
#define sidResCtrl  0xD417 /* resonance control */
#define sidVolume   0xD418 /* master volume and filter select */
#define sidPotX     0xD419 /* paddle X */
#define sidPotY     0xD41A /* paddle Y */
#define sidEnvGen3  0xD41C

#define sidWaveGate 0x01 /* waveforms */
#define sidWaveSync 0x02
#define sidWaveRing 0x04
#define sidWaveTest 0x08
#define sidWaveTri  0x10
#define sidWaveSaw  0x20
#define sidWaveSqu  0x40
#define sidWaveNoi  0x80

#define sidLowPass   0x10 /* filter select settings */
#define sidBandPass  0x20
#define sidHighPass  0x40
#define sidVoice3Off 0x80

#define sidFilter1   0x01 /* filter resonance output settings */
#define sidFilter2   0x02
#define sidFilter3   0x04
#define sidFilterExt 0x08

extern void __LIB__ getpotssid(void);
extern void __LIB__ getmousesid(void);

extern void __LIB__ clearsid(void);
extern void __LIB__ volumesid(ushort Amp, ushort Filter) __smallc;
extern void __LIB__ envelopesid(ushort Voice, ushort Attack, ushort Decay, ushort Sustain, ushort Release) __smallc;
extern void __LIB__ freqsid(ushort Voice, ushort Freq) __smallc;
extern void __LIB__ attacksid(ushort Voice, ushort Waveform) __smallc;
extern void __LIB__ releasesid(ushort Voice, ushort Waveform) __smallc;
extern void __LIB__ pulsewavesid(ushort Voice, ushort Width) __smallc;

extern void __LIB__ playzb4sid(uchar *SamStart, ushort SamLen) __smallc;

#endif

