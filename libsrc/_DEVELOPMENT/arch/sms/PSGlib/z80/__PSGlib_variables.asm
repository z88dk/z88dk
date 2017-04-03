; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

; fundamental vars

SECTION data_clib
SECTION data_PSGlib

PUBLIC __PSGlib_MusicStatus

__PSGlib_MusicStatus:
   defb PSG_STOPPED            ; are we playing a background music?

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_MusicStart
PUBLIC __PSGlib_MusicPointer
PUBLIC __PSGlib_MusicLoopPoint
PUBLIC __PSGlib_MusicSkipFrames
PUBLIC __PSGlib_LoopFlag
PUBLIC __PSGlib_MusicLastLatch
PUBLIC __PSGlib_MusicVolumeAttenuation

__PSGlib_MusicStart:
   defw 0                      ; the pointer to the beginning of music

__PSGlib_MusicPointer:
   defw 0                      ; the pointer to the current

__PSGlib_MusicLoopPoint:            ; the pointer to the loop begin
   defw 0

__PSGlib_MusicSkipFrames:
   defb 0                      ; the frames we need to skip

__PSGlib_LoopFlag:
   defb 0                      ; the tune should loop or not (flag)

__PSGlib_MusicLastLatch:
   defb 0                      ; the last PSG music latch

__PSGlib_MusicVolumeAttenuation:
   defb 0                      ; the volume attenuation applied to the tune (0-15)

; decompression vars

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_MusicSubstringLen
PUBLIC __PSGlib_MusicSubstringRetAddr

__PSGlib_MusicSubstringLen:
   defb 0                      ; length of the substring we are playing

__PSGlib_MusicSubstringRetAddr:
   defw 0                      ; return to this address when substring is over

; volume/frequency buffering

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_Chan0Volume
PUBLIC __PSGlib_Chan1Volume
PUBLIC __PSGlib_Chan2Volume
PUBLIC __PSGlib_Chan3Volume
PUBLIC __PSGlib_Chan2LowTone
PUBLIC __PSGlib_Chan3LowTone
PUBLIC __PSGlib_Chan2HighTone

__PSGlib_Chan0Volume:
   defb 0                      ; the volume for channel 0

__PSGlib_Chan1Volume:
   defb 0                      ; the volume for channel 1

__PSGlib_Chan2Volume:
   defb 0                      ; the volume for channel 2

__PSGlib_Chan3Volume:
   defb 0                      ; the volume for channel 3

__PSGlib_Chan2LowTone:
   defb 0                      ; the low tone bits for channels 2

__PSGlib_Chan3LowTone:
   defb 0                      ; the low tone bits for channels 3

__PSGlib_Chan2HighTone:
   defb 0                      ; the high tone bits for channel 2

; flags for channels 2-3 access

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_Channel2SFX
PUBLIC __PSGlib_Channel3SFX

__PSGlib_Channel2SFX:
   defb 0                      ; !0 means channel 2 is allocated to SFX

__PSGlib_Channel3SFX:
   defb 0                      ; !0 means channel 3 is allocated to SFX

; volume/frequency buffering for SFX

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_SFXChan2Volume
PUBLIC __PSGlib_SFXChan3Volume

__PSGlib_SFXChan2Volume:
   defb 0                      ; the volume for SFX channel 2

__PSGlib_SFXChan3Volume:
   defb 0                      ; the volume for SFX channel 3

; fundamental vars for SFX

SECTION data_clib
SECTION data_PSGlib

PUBLIC __PSGlib_SFXStatus

__PSGlib_SFXStatus:
   defb PSG_STOPPED            ; are we playing a SFX?

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_SFXStart
PUBLIC __PSGlib_SFXPointer
PUBLIC __PSGlib_SFXLoopPoint
PUBLIC __PSGlib_SFXSkipFrames
PUBLIC __PSGlib_SFXLoopFlag

__PSGlib_SFXStart:
   defw 0                      ; the pointer to the beginning of SFX

__PSGlib_SFXPointer:
   defw 0                      ; the pointer to the current address

__PSGlib_SFXLoopPoint:
   defw 0                      ; the pointer to the loop begin

__PSGlib_SFXSkipFrames:
   defb 0                      ; the frames we need to skip

__PSGlib_SFXLoopFlag:
   defb 0                      ; the SFX should loop or not (flag)

; decompression vars for SDX

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC __PSGlib_SFXSubstringLen
PUBLIC __PSGlib_SFXSubstringRetAddr

__PSGlib_SFXSubstringLen:
   defb 0                      ; length of the substring we are playing

__PSGlib_SFXSubstringRetAddr:
   defw 0                      ; return to this address when substring is over
