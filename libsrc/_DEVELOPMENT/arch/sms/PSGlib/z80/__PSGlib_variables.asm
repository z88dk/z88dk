; **************************************************
; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

; fundamental vars

SECTION data_clib
SECTION data_PSGlib

PUBLIC _PSGMusicStatus

_PSGMusicStatus:
   defb PSG_STOPPED            ; are we playing a background music?

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGMusicStart
PUBLIC _PSGMusicPointer
PUBLIC _PSGMusicLoopPoint
PUBLIC _PSGMusicSkipFrames
PUBLIC _PSGLoopFlag
PUBLIC _PSGMusicLastLatch
PUBLIC _PSGMusicVolumeAttenuation

_PSGMusicStart:
   defw 0                      ; the pointer to the beginning of music

_PSGMusicPointer:
   defw 0                      ; the pointer to the current

_PSGMusicLoopPoint:            ; the pointer to the loop begin
   defw 0

_PSGMusicSkipFrames:
   defb 0                      ; the frames we need to skip

_PSGLoopFlag:
   defb 0                      ; the tune should loop or not (flag)

_PSGMusicLastLatch:
   defb 0                      ; the last PSG music latch

_PSGMusicVolumeAttenuation:
   defb 0                      ; the volume attenuation applied to the tune (0-15)

; decompression vars

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGMusicSubstringLen
PUBLIC _PSGMusicSubstringRetAddr

_PSGMusicSubstringLen:
   defb 0                      ; length of the substring we are playing

_PSGMusicSubstringRetAddr:
   defw 0                      ; return to this address when substring is over

; volume/frequency buffering

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGChan0Volume
PUBLIC _PSGChan1Volume
PUBLIC _PSGChan2Volume
PUBLIC _PSGChan3Volume
PUBLIC _PSGChan2LowTone
PUBLIC _PSGChan3LowTone
PUBLIC _PSGChan2HighTone

_PSGChan0Volume:
   defb 0                      ; the volume for channel 0

_PSGChan1Volume:
   defb 0                      ; the volume for channel 1

_PSGChan2Volume:
   defb 0                      ; the volume for channel 2

_PSGChan3Volume:
   defb 0                      ; the volume for channel 3

_PSGChan2LowTone:
   defb 0                      ; the low tone bits for channels 2

_PSGChan3LowTone:
   defb 0                      ; the low tone bits for channels 3

_PSGChan2HighTone:
   defb 0                      ; the high tone bits for channel 2

; flags for channels 2-3 access

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGChannel2SFX
PUBLIC _PSGChannel3SFX

_PSGChannel2SFX:
   defb 0                      ; !0 means channel 2 is allocated to SFX

_PSGChannel3SFX:
   defb 0                      ; !0 means channel 3 is allocated to SFX

; volume/frequency buffering for SFX

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGSFXChan2Volume
PUBLIC _PSGSFXChan3Volume

_PSGSFXChan2Volume:
   defb 0                      ; the volume for SFX channel 2

_PSGSFXChan3Volume:
   defb 0                      ; the volume for SFX channel 3

; fundamental vars for SFX

SECTION data_clib
SECTION data_PSGlib

PUBLIC _PSGSFXStatus

_PSGSFXStatus:
   defb PSG_STOPPED            ; are we playing a SFX?

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGSFXStart
PUBLIC _PSGSFXPointer
PUBLIC _PSGSFXLoopPoint
PUBLIC _PSGSFXSkipFrames
PUBLIC _PSGSFXLoopFlag

_PSGSFXStart:
   defw 0                      ; the pointer to the beginning of SFX

_PSGSFXPointer:
   defw 0                      ; the pointer to the current address

_PSGSFXLoopPoint:
   defw 0                      ; the pointer to the loop begin

_PSGSFXSkipFrames:
   defb 0                      ; the frames we need to skip

_PSGSFXLoopFlag:
   defb 0                      ; the SFX should loop or not (flag)

; decompression vars for SDX

SECTION bss_clib
SECTION bss_PSGlib

PUBLIC _PSGSFXSubstringLen
PUBLIC _PSGSFXSubstringRetAddr

_PSGSFXSubstringLen:
   defb 0                      ; length of the substring we are playing

_PSGSFXSubstringRetAddr:
   defw 0                      ; return to this address when substring is over
