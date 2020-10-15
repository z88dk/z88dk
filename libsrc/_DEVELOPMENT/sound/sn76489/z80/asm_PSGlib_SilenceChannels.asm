; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SilenceChannels

EXTERN asm_sms_psg_silence

defc asm_PSGlib_SilenceChannels = asm_sms_psg_silence

   ; void PSGSilenceChannels (void)
   ; silence all the PSG channels
   ;
   ; uses  : f, bc, hl
