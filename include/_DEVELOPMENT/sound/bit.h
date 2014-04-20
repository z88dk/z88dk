
#ifndef _SOUND_BIT_H
#define _SOUND_BIT_H

#include <stdint.h>

//////////////////////
// 1-BIT SOUND LIBRARY
//////////////////////

// void bit_freq(float dur_ms, float freq_hz);
// not yet implemented -- requires float package

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern void                       bit_beep(uint16_t dur_ms, uint16_t freq_hz);
extern void                       bit_beep_raw(uint16_t cycles_num, uint16_t period_T);
extern void                       bit_click(void);
extern void                       bit_fx(void (*bfx)(void));
extern char                      *bit_play(char *melody);
extern void                       bit_synth(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

extern void                       bit_beep_di(uint16_t dur_ms, uint16_t freq_hz);
extern void                       bit_beep_raw_di(uint16_t cycles_num, uint16_t period_T);
extern void                       bit_click_di(void);
extern void                       bit_fx_di(void (*bfx)(void));
extern char                      *bit_play_di(char *melody);
extern void                       bit_synth_di(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

#else

// SCCZ80

extern void __LIB__               bit_beep(uint16_t dur_ms, uint16_t freq_hz);
extern void __LIB__               bit_beep_raw(uint16_t cycles_num, uint16_t period_T);
extern void __LIB__               bit_click(void);
extern void __LIB__ __FASTCALL__  bit_fx(void *bfx);
extern char __LIB__ __FASTCALL__ *bit_play(char *melody);
extern void __LIB__               bit_synth(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

extern void __LIB__               bit_beep_di(uint16_t dur_ms, uint16_t freq_hz);
extern void __LIB__               bit_beep_raw_di(uint16_t cycles_num, uint16_t period_T);
extern void __LIB__               bit_click_di(void);
extern void __LIB__ __FASTCALL__  bit_fx_di(void *bfx);
extern char __LIB__ __FASTCALL__ *bit_play_di(char *melody);
extern void __LIB__               bit_synth_di(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

// SCCZ80 CALLEE LINKAGE

extern void __LIB__ __CALLEE__    bit_beep_callee(uint16_t dur_ms, uint16_t freq_hz);
extern void __LIB__ __CALLEE__    bit_beep_raw_callee(uint16_t cycles_num, uint16_t period_T);
extern void __LIB__ __CALLEE__    bit_synth_callee(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

extern void __LIB__ __CALLEE__    bit_beep_di_callee(uint16_t dur_ms, uint16_t freq_hz);
extern void __LIB__ __CALLEE__    bit_beep_raw_di_callee(uint16_t cycles_num, uint16_t period_T);
extern void __LIB__ __CALLEE__    bit_synth_di_callee(uint8_t dur, uint8_t freq_1, uint8_t freq_2, uint8_t freq_3, uint8_t freq_4);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define bit_beep(a,b)             bit_beep_callee(a,b)
#define bit_beep_raw(a,b)         bit_beep_raw_callee(a,b)
#define bit_synth(a,b,c,d,e)      bit_synth_callee(a,b,c,d,e)

#define bit_beep_di(a,b)          bit_beep_di_callee(a,b)
#define bit_beep_raw_di(a,b)      bit_beep_raw_di_callee(a,b)
#define bit_synth_di(a,b,c,d,e)   bit_synth__di_callee(a,b,c,d,e)

#endif

// SOUND EFFECTS FOR BIT_FX()

#define BFX_UNNAMED_1             bitfx_0
#define BFX_LASER_REPEAT          bitfx_1
#define BFX_SQUEAK                bitfx_2
#define BFX_EATING                bitfx_3
#define BFX_SQUELCH               bitfx_4
#define BFX_KLAXON                bitfx_5
#define BFX_BEEP                  bitfx_6
#define BFX_WARP                  bitfx_7
#define BFX_DEEP_SPACE            bitfx_8
#define BFX_DUAL_NOTE_FUZZY       bitfx_9
#define BFX_DUAL_NOTE_FUZZY_2     bitfx_10
#define BFX_KLAXON_2              bitfx_11
#define BFX_TSPACE                bitfx_12
#define BFX_TSPACE_2              bitfx_13
#define BFX_SQUOINK               bitfx_14
#define BFX_EXPLOSION             bitfx_15
#define BFX_BLIRP                 bitfx_16
#define BFX_BLIRP_2               bitfx_17
#define BFX_STEAM_ENGINE          bitfx_18
#define BFX_BLURP                 bitfx_19
#define BFX_BUZZER_DESCEND        bitfx_20
#define BFX_BUZZER_ASCEND         bitfx_21
#define BFX_BUZZER_DESCEND_2      bitfx_22
#define BFX_UNNAMED_2             bitfx_23
#define BFX_SQUEAK_2              bitfx_24
#define BFX_TAPE_REWIND           bitfx_25
#define BFX_UNNAMED_3             bitfx_26
#define BFX_UNNAMED_4             bitfx_27
#define BFX_SQUEAK_DESCEND        bitfx_28
#define BFX_UNNAMED_5             bitfx_29
#define BFX_UNNAMED_6             bitfx_30
#define BFX_UNNAMED_7             bitfx_31

extern void bitfx_0(void);
extern void bitfx_1(void);
extern void bitfx_2(void);
extern void bitfx_3(void);
extern void bitfx_4(void);
extern void bitfx_5(void);
extern void bitfx_6(void);
extern void bitfx_7(void);
extern void bitfx_8(void);
extern void bitfx_9(void);
extern void bitfx_10(void);
extern void bitfx_11(void);
extern void bitfx_12(void);
extern void bitfx_13(void);
extern void bitfx_14(void);
extern void bitfx_15(void);
extern void bitfx_16(void);
extern void bitfx_17(void);
extern void bitfx_18(void);
extern void bitfx_19(void);
extern void bitfx_20(void);
extern void bitfx_21(void);
extern void bitfx_22(void);
extern void bitfx_23(void);
extern void bitfx_24(void);
extern void bitfx_25(void);
extern void bitfx_26(void);
extern void bitfx_27(void);
extern void bitfx_28(void);
extern void bitfx_29(void);
extern void bitfx_30(void);
extern void bitfx_31(void);

#endif
