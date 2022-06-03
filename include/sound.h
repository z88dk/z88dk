#ifndef __SOUND_H__
#define __SOUND_H__

#include <sys/compiler.h>
#include <sys/types.h>

/*
 *	Sound support code
 *
 *	$Id: sound.h $
 */



#ifdef __C128__
#include <c128/cia.h>
#include <c128/sid.h>
#endif


/* 1 bit sound library */

extern void  __LIB__ bit_open();
extern void  __LIB__ bit_open_di();
extern void __LIB__ bit_close();
extern void __LIB__ bit_close_ei();
extern void __LIB__ bit_click();

/* Sound effects; every library contains 8 different sounds (effect no. 0..7) */
extern void __LIB__ bit_fx(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx2(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx3(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx4(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx5(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx6(int effect) __smallc __z88dk_fastcall;
extern void __LIB__ bit_fx7(int effect) __smallc __z88dk_fastcall;

/* 1 BIT SYNTH - Polyphony and multitimbric effects */
extern void __LIB__ bit_synth(int duration, int frequency1, int frequency2, int frequency3, int frequency4) __smallc;

/* "period": the higher value, the lower tone ! */
extern void __LIB__ bit_beep(int duration, int period) __smallc;
extern void __LIB__ bit_beep_callee(int duration, int period) __smallc __z88dk_callee;
#define bit_beep(a,b) bit_beep_callee(a,b)

/* "period": the higher value, the lower the simulated white noise frequency cutoff ! */
extern void __LIB__ bit_noise(int duration, int period) __smallc;
extern void __LIB__ bit_noise_callee(int duration, int period) __smallc __z88dk_callee;
#define bit_noise(a,b) bit_noise_callee(a,b)

/* "period": the higher value, the lower tone !  pattern: the "on/off" pattern defining the sound patch, zero terminated */
extern void __LIB__ patch_beep(int duration, int period, void *pattern) __smallc;
extern void __LIB__ patch_beep_callee(int duration, int period, void *pattern) __smallc __z88dk_callee;
#define patch_beep(a,b,c) patch_beep_callee(a,b,c)

/* Real frequency !  Duration is in ms */
extern void __LIB__ bit_frequency(double_t duration, double_t frequency) __smallc;

/* Play a song (example: "2A--A-B-CDEFGAB5C+") */
extern void __LIB__ bit_play(char melody[]) __smallc __z88dk_fastcall;

/* As above, on the PSG */
extern void __LIB__ psg_play(char melody[]) __smallc __z88dk_fastcall;

/* Set up the synth phase parameters (4 hex digits, e.g. 0x1234) */
extern void __LIB__ synth_phase(unsigned int phase) __smallc __z88dk_fastcall;

/* Direct access to the synth phase parameters for manual bending effects */
extern int synth_phase_1;
extern int synth_phase_2;
extern int synth_phase_3;
extern int synth_phase_4;

/* As for bit_play, but using 4 virtual oscillators.  Lacks of precision, but cool sounds. */
extern void __LIB__ synth_play(char melody[]) __smallc __z88dk_fastcall;

/* Yet another way to play a melody.  Good for bass parts. 'soundpatch' is a zero terminated pattern */
extern void __LIB__ buzzer_play(char *soundpatch, char *melody) __smallc;

/* Sound patches for buzzer_play. */
/* Some of them can be long and should be put in a static variable */
#define BUZZ_BASS      "\x01\xF0"
#define BUZZ_BASS2     "\x0F\x80"
#define BUZZ_BASS3     "\x3F\x04"
#define BUZZ_JAMBASS   "\xFF\x80"
#define BUZZ_TREMBASS  "\x0F\x1E\x0F\x80"
#define BUZZ_LOW       "\x5C\x5C"
#define BUZZ_MID       "\xCF"
#define BUZZ_MID2      "\x02"
#define BUZZ_HIGH      "\x22"
#define BUZZ_RESONATE  "\x22\x22"
#define BUZZ_RESONATE2 "\xAA\xBA"

/* Example on how to 'SQUELCH' the sound tail in complex sound patches:
// wah wah buzzer
char wahwah_buzzer[]={0xcF,0xcF,0xcF,0xcF,0xcF,0xcF,0xcF,0xcF,0xcF,0x0F,0x0F,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0};
// buzzer hit
char buzzer_hit[]={0x22,0x22,0x22,0x22,0x22,0x22,0x22,0x22,0x22,0x22,0x22,0x22,2,2,2,2,2,2,2,2,2,0xcF,0xcF,0xcF,0xcF,0x5C,0x5C,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0};
 */


/* 4bit sample player at 8khz, inherited from the C128 functions
 * so far ported to the Bondwell 12/14 */

#ifdef __C128__
#define playzb4(a,b) setintctrlcia(cia2,ciaClearIcr);settimeracia(cia2,timervalcia(8000L),ciaCPUCont);playzb4sid(a,b);
#else
extern void __LIB__ playzb4(unsigned char *SamStart, unsigned int SamLen) __smallc;
#endif


/* Platform specific parameters (mainly timing stuff) 

   The BEEP_TSTATES constant is obtained by dividing the
   CPU clock frequency by eight
*/


#ifdef ACE
  #define BEEP_TSTATES 406250.0 /* 3.25 Mhz */
#endif

#ifdef AQUARIUS
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef AUSSIEBYTE
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef BEE
  #define BEEP_TSTATES 250000.0 /* 2 Mhz */
  /* #define BEEP_TSTATES 421875.0 -> 3.375 Mhz */
#endif

#ifdef C128
  #define BEEP_TSTATES 250000.0  /* 2 Mhz.. VIC-II steals time */
#endif

#ifdef ENTERPRISE
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef GAL
  #define BEEP_TSTATES 384000.0  /* 3.072 MHz*/
#endif

#ifdef MSX
  #define BEEP_TSTATES 447500.0  /* 3.58 Mhz */
#endif

#ifdef MC1000
  #define BEEP_TSTATES 447443.1 /* 3.579545 Mhz */
#endif

#ifdef P2000
  #define BEEP_TSTATES 312500.0 /* 2.5 Mhz */
#endif

#ifdef PC88
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef SPECTRUM
  #define BEEP_TSTATES 437500.0  /* 3.5 Mhz; float value = CPU_CLOCK*125 */
#endif

#ifdef TICALC
// TICALC, TI82, TI83, TI8X, TI85, TI86, SHARP OZ
  #define BEEP_TSTATES 750000.0 /* 6 Mhz */
  /* TI-83 Plus should have 1875000.0 (15 Mhz) if Silver Edition */
  /* #define BEEP_TSTATES 1875000.0 */
#endif

#ifdef TRS80
  //#define BEEP_TSTATES 221750.0 /* 1.774 Mhz , TRS 80 Model I */
  #define BEEP_TSTATES 275000.0 /* 2.03 Mhz , EACA EG2000 */
  //#define BEEP_TSTATES 287500.0 /* 2.2 Mhz , TRS 80 Model III */
  //#define BEEP_TSTATES 500000.0  /* (4 Mhz) Model II, Model IV or modified Model III */
#endif

#ifdef TVC
  #define BEEP_TSTATES 390625.0  /* 3.125 Mhz */
#endif

#ifdef VG5000
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

/* Clock timing is not perfect, here we have a slightly different 
   routine, with the inner loop differing for one cycle,and
   VZ300 has a CPU clock of 3,54 Mhz, VZ200 -> 3,58.. we stay in the middle */
#ifdef VZ
  #define BEEP_TSTATES 442500.0  /* 3.54 Mhz */
#endif

#ifdef Z9001
  #define BEEP_TSTATES 307200.0 /* 2.4576 Mhz */
#endif

/* We always get Z88, so it can't be a condition */
#ifndef BEEP_TSTATES
  #define BEEP_TSTATES 410000.0 /* Z88 -- 3.28 Mhz */
#endif

// SOUND EFFECTS FOR BIT_BEEPFX()

#define BEEPFX_SHOT_1             bfx_0
#define BEEPFX_SHOT_2             bfx_1
#define BEEPFX_JUMP_1             bfx_2
#define BEEPFX_JUMP_2             bfx_3
#define BEEPFX_PICK               bfx_4
#define BEEPFX_DROP_1             bfx_5
#define BEEPFX_DROP_2             bfx_6
#define BEEPFX_GRAB_1             bfx_7
#define BEEPFX_GRAB_2             bfx_8
#define BEEPFX_FAT_BEEP_1         bfx_9
#define BEEPFX_FAT_BEEP_2         bfx_10
#define BEEPFX_FAT_BEEP_3         bfx_11
#define BEEPFX_HARSH_BEEP_1       bfx_12
#define BEEPFX_HARSH_BEEP_2       bfx_13
#define BEEPFX_HARSH_BEEP_3       bfx_14
#define BEEPFX_HIT_1              bfx_15
#define BEEPFX_HIT_2              bfx_16
#define BEEPFX_HIT_3              bfx_17
#define BEEPFX_HIT_4              bfx_18
#define BEEPFX_JET_BURST          bfx_19
#define BEEPFX_BOOM_1             bfx_20
#define BEEPFX_BOOM_2             bfx_21
#define BEEPFX_BOOM_3             bfx_22
#define BEEPFX_BOOM_4             bfx_23
#define BEEPFX_BOOM_5             bfx_24
#define BEEPFX_BOOM_6             bfx_25
#define BEEPFX_BOOM_7             bfx_26
#define BEEPFX_BOOM_8             bfx_27
#define BEEPFX_ITEM_1             bfx_28
#define BEEPFX_ITEM_2             bfx_29
#define BEEPFX_ITEM_3             bfx_30
#define BEEPFX_ITEM_4             bfx_31
#define BEEPFX_ITEM_5             bfx_32
#define BEEPFX_ITEM_6             bfx_33
#define BEEPFX_SWITCH_1           bfx_34
#define BEEPFX_SWITCH_2           bfx_35
#define BEEPFX_POWER_OFF          bfx_36
#define BEEPFX_SCORE              bfx_37
#define BEEPFX_CLANG              bfx_38
#define BEEPFX_WATER_TAP          bfx_39
#define BEEPFX_SELECT_1           bfx_40
#define BEEPFX_SELECT_2           bfx_41
#define BEEPFX_SELECT_3           bfx_42
#define BEEPFX_SELECT_4           bfx_43
#define BEEPFX_SELECT_5           bfx_44
#define BEEPFX_SELECT_6           bfx_45
#define BEEPFX_SELECT_7           bfx_46
#define BEEPFX_ALARM_1            bfx_47
#define BEEPFX_ALARM_2            bfx_48
#define BEEPFX_ALARM_3            bfx_49
#define BEEPFX_EAT                bfx_50
#define BEEPFX_GULP               bfx_51
#define BEEPFX_ROBOBLIP           bfx_52
#define BEEPFX_NOPE               bfx_53
#define BEEPFX_UH_HUH             bfx_54
#define BEEPFX_OLD_COMPUTER       bfx_55
#define BEEPFX_YEAH               bfx_56
#define BEEPFX_AWW                bfx_57

extern void __LIB__ bit_beepfx(void *bfx) __smallc __z88dk_fastcall;

// IMPLEMENTATION DETAILS FOR BIT_BEEPFX()

extern void bfx_0(void);
extern void bfx_1(void);
extern void bfx_2(void);
extern void bfx_3(void);
extern void bfx_4(void);
extern void bfx_5(void);
extern void bfx_6(void);
extern void bfx_7(void);
extern void bfx_8(void);
extern void bfx_9(void);
extern void bfx_10(void);
extern void bfx_11(void);
extern void bfx_12(void);
extern void bfx_13(void);
extern void bfx_14(void);
extern void bfx_15(void);
extern void bfx_16(void);
extern void bfx_17(void);
extern void bfx_18(void);
extern void bfx_19(void);
extern void bfx_20(void);
extern void bfx_21(void);
extern void bfx_22(void);
extern void bfx_23(void);
extern void bfx_24(void);
extern void bfx_25(void);
extern void bfx_26(void);
extern void bfx_27(void);
extern void bfx_28(void);
extern void bfx_29(void);
extern void bfx_30(void);
extern void bfx_31(void);
extern void bfx_32(void);
extern void bfx_33(void);
extern void bfx_34(void);
extern void bfx_35(void);
extern void bfx_36(void);
extern void bfx_37(void);
extern void bfx_38(void);
extern void bfx_39(void);
extern void bfx_40(void);
extern void bfx_41(void);
extern void bfx_42(void);
extern void bfx_43(void);
extern void bfx_44(void);
extern void bfx_45(void);
extern void bfx_46(void);
extern void bfx_47(void);
extern void bfx_48(void);
extern void bfx_49(void);
extern void bfx_50(void);
extern void bfx_51(void);
extern void bfx_52(void);
extern void bfx_53(void);
extern void bfx_54(void);
extern void bfx_55(void);
extern void bfx_56(void);
extern void bfx_57(void);

#endif
