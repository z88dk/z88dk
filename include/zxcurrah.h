/*
 *      Currah uSpeech interface for the ZX Spectrum library
 *
 *      Stefano Bodrato - 3/7/2006
 *
 *	$Id: zxcurrah.h,v 1.2 2010-09-19 00:24:08 dom Exp $
 */


#ifndef __ZXCURRAH_H__
#define __ZXCURRAH_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>


/* CURRAH uSpeech interface */

/* TRUE if the interface is present */
extern int __LIB__ currah_detect();

/* Talk using the high level BASIC interface */
extern void __LIB__ currah_speech(char *text);

/* Talk using the allophone codes */
extern void __LIB__ currah_direct(char *allophones);


/* Message terminator */

#define   PH_END    0


/* Pitch (to be ORed with the following codes to increase intonation */

#define   PH_HIGH   64
#define   PH_PITCH  64
#define   PH_UPPER  64


/* Allophone codes */

#define   PH_A    24
#define   PH_B    28
#define   PH_C    8
#define   PH_D    21
#define   PH_E    7
#define   PH_F    40
#define   PH_G    36
#define   PH_H    27
#define   PH_I    12
#define   PH_J    10
#define   PH_K    42
#define   PH_L    45
#define   PH_M    16
#define   PH_N    11
#define   PH_O    23
#define   PH_P    9
#define   PH_R    39
#define   PH_S    55
#define   PH_T    17
#define   PH_U    15
#define   PH_V    35
#define   PH_W    46
#define   PH_Y    49
#define   PH_Z    43

#define   PH_AY   20
#define   PH_AA   20
#define   PH_EE   19
#define   PH_II   6
#define   PH_OO   53
#define   PH_EAU  53
#define   PH_BB   63
#define   PH_DD   33
#define   PH_GG   61
#define   PH_GGG  36
#define   PH_HH   57
#define   PH_LL   62
#define   PH_NN   56
#define   PH_RR   14
#define   PH_TT   13
#define   PH_YY   25
#define   PH_AR   59
#define   PH_AER  47
#define   PH_CH   50
#define   PH_CK   41
#define   PH_EAR  60
#define   PH_EH   26
#define   PH_ER   51
#define   PH_ERR  52
#define   PH_NG   44
#define   PH_OR   58
#define   PH_OU   22
#define   PH_OUU  31
#define   PH_OW   32
#define   PH_OY   5
#define   PH_SH   37
#define   PH_TH   29
#define   PH_DTH  18
#define   PH_UH   30
#define   PH_WH   48
#define   PH_ZH   33

#define   PH_     1
#define   PH__    3
#define   PH___   4

#endif /* __ZXCURRAH_H__ */
