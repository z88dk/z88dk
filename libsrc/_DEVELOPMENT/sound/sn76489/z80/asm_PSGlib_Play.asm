; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_Play

EXTERN asm_PSGlib_Stop
EXTERN __PSGlib_LoopFlag, __PSGlib_MusicStart, __PSGlib_MusicPointer, __PSGlib_MusicLoopPoint
EXTERN __PSGlib_MusicSkipFrames, __PSGlib_MusicSubstringLen, __PSGlib_MusicLastLatch, __PSGlib_MusicStatus

asm_PSGlib_Play:

   ; void PSGPlay (void *song)
   ; receives the address of the PSG to start playing (continuously)
   ;
   ; enter : hl = void *song
   ;
   ; uses  : af
   
   call asm_PSGlib_Stop
   
   ld a,1
   ld (__PSGlib_LoopFlag),a
   
   ld (__PSGlib_MusicStart),hl          ; // store the begin point of music
   ld (__PSGlib_MusicPointer),hl        ; // set music pointer to begin of music
   ld (__PSGlib_MusicLoopPoint),hl      ; // looppointer points to begin too
   
   xor a
   ld (__PSGlib_MusicSkipFrames),a      ; // reset the skip frames
   ld (__PSGlib_MusicSubstringLen),a    ; // reset the substring len (for compression)
   
   ld a,PSGLatch|PSGChannel0|PSGVolumeData|0x0f    ; // latch channel 0, volume=0xF (silent)
   ld (__PSGlib_MusicLastLatch),a
   
   ld a,PSG_PLAYING
   ld (__PSGlib_MusicStatus),a
   
   ret
