; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_Play

EXTERN asm_PSGlib_Stop
EXTERN _PSGLoopFlag, _PSGMusicStart, _PSGMusicPointer, _PSGMusicLoopPoint
EXTERN _PSGMusicSkipFrames, _PSGMusicSubstringLen, _PSGMusicLastLatch, _PSGMusicStatus

asm_PSGlib_Play:

   ; void PSGPlay (void *song)
   ; receives the address of the PSG to start playing (continuously)
   ;
   ; enter : hl = void *song
   ;
   ; uses  : af
   
   call asm_PSGlib_Stop
   
   ld a,1
   ld (_PSGLoopFlag),a
   
   ld (_PSGMusicStart),hl          ; // store the begin point of music
   ld (_PSGMusicPointer),hl        ; // set music pointer to begin of music
   ld (_PSGMusicLoopPoint),hl      ; // looppointer points to begin too
   
   xor a
   ld (_PSGMusicSkipFrames),a      ; // reset the skip frames
   ld (_PSGMusicSubstringLen),a    ; // reset the substring len (for compression)
   
   ld a,PSGLatch|PSGChannel0|PSGVolumeData|0x0f    ; // latch channel 0, volume=0xF (silent)
   ld (_PSGMusicLastLatch),a
   
   ld a,PSG_PLAYING
   ld (_PSGMusicStatus),a
   
   ret
