; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_Frame

EXTERN asm_PSGlib_Stop

EXTERN __PSGlib_MusicStatus, __PSGlib_MusicSkipFrames, __PSGlib_MusicPointer
EXTERN __PSGlib_MusicSubstringLen, __PSGlib_MusicSubstringRetAddr, __PSGlib_MusicLastLatch
EXTERN __PSGlib_Chan3LowTone, __PSGlib_Channel3SFX, __PSGlib_SFXStatus
EXTERN __PSGlib_Chan2LowTone, __PSGlib_Channel2SFX, __PSGlib_Chan1Volume
EXTERN __PSGlib_Chan0Volume, __PSGlib_Chan3Volume, __PSGlib_Chan2Volume
EXTERN __PSGlib_MusicVolumeAttenuation, __PSGlib_MusicLoopPoint, __PSGlib_MusicStart
EXTERN __PSGlib_Chan2HighTone, __PSGlib_LoopFlag

asm_PSGlib_Frame:

   ; process a music frame
	;
	; uses : af, bc, hl

  ld a,(__PSGlib_MusicStatus)         ; check if we have got to play a tune
  or a
  ret z

  ld a,(__PSGlib_MusicSkipFrames)     ; check if we have got to skip frames
  or a
  jp nz,_skipFrame

  ld hl,(__PSGlib_MusicPointer)       ; read current address

_intLoop:
  ld b,(hl)                      ; load PSG byte (in B)
  inc hl                         ; point to next byte
  ld a,(__PSGlib_MusicSubstringLen)   ; read substring len
  or a
  jr z,_continue                 ; check if it is 0 (we are not in a substring)
  dec a                          ; decrease len
  ld (__PSGlib_MusicSubstringLen),a   ; save len
  jr nz,_continue
  ld hl,(__PSGlib_MusicSubstringRetAddr)  ; substring is over, retrieve return address

_continue:
  ld a,b                         ; copy PSG byte into A
  cp PSGLatch                    ; is it a latch?
  jr c,_noLatch                  ; if < $80 then it is NOT a latch
  ld (__PSGlib_MusicLastLatch),a      ; it is a latch - save it in "LastLatch"
  
  ; we have got the latch PSG byte both in A and in B
  ; and we have to check if the value should pass to PSG or not
  bit 4,a                        ; test if it is a volume
  jr nz,_latch_Volume            ; jump if volume data
  bit 6,a                        ; test if the latch it is for channels 0-1 or for 2-3
  jp z,_send2PSG_A               ; send data to PSG if it is for channels 0-1

  ; we have got the latch (tone, chn 2 or 3) PSG byte both in A and in B
  ; and we have to check if the value should be passed to PSG or not
  bit 5,a                        ; test if tone it is for channel 2 or 3
  jr z,_ifchn2                   ; jump if channel 2
  ld (__PSGlib_Chan3LowTone),a        ; save tone LOW data
  ld a,(__PSGlib_Channel3SFX)         ; channel 3 free?
  or a
  jp nz,_intLoop
  ld a,(__PSGlib_Chan3LowTone)
  and 3                          ; test if channel 3 is set to use the frequency of channel 2
  cp 3
  jr nz,_send2PSG_B              ; if channel 3 does not use frequency of channel 2 jump
  ld a,(__PSGlib_SFXStatus)           ; test if an SFX is playing
  or a
  jr z,_send2PSG_B               ; if no SFX is playing jump
  ld (__PSGlib_Channel3SFX),a         ; otherwise mark channel 3 as occupied
  ld a,PSGLatch|PSGChannel3|PSGVolumeData|0x0F   ; and silence channel 3
  out (PSGDataPort),a
  jp _intLoop
_ifchn2:
  ld (__PSGlib_Chan2LowTone),a        ; save tone LOW data
  ld a,(__PSGlib_Channel2SFX)         ; channel 2 free?
  or a
  jr z,_send2PSG_B
  jp _intLoop
  
_latch_Volume:
  bit 6,a                        ; test if the latch it is for channels 0-1 or for 2-3
  jr nz,_latch_Volume_23         ; volume is for channel 2 or 3
  bit 5,a                        ; test if volume it is for channel 0 or 1
  jr z,_chn0                     ; jump for channel 0
  ld (__PSGlib_Chan1Volume),a         ; save volume data
  jp _sendVolume2PSG_A
_chn0:
  ld (__PSGlib_Chan0Volume),a         ; save volume data
  jp _sendVolume2PSG_A

_latch_Volume_23:
  bit 5,a                        ; test if volume it is for channel 2 or 3
  jr z,_chn2                     ; jump for channel 2
  ld (__PSGlib_Chan3Volume),a         ; save volume data
  ld a,(__PSGlib_Channel3SFX)         ; channel 3 free?
  or a
  jr z,_sendVolume2PSG_B
  jp _intLoop
_chn2:
  ld (__PSGlib_Chan2Volume),a         ; save volume data
  ld a,(__PSGlib_Channel2SFX)         ; channel 2 free?
  or a
  jr z,_sendVolume2PSG_B
  jp _intLoop
  
_skipFrame:
  dec a
  ld (__PSGlib_MusicSkipFrames),a
  ret

_noLatch:
  cp PSGData
  jr c,_command                  ; if < $40 then it is a command
  ; it is a data
  ld a,(__PSGlib_MusicLastLatch)      ; retrieve last latch
  jp _output_NoLatch

_command:
  cp PSGWait
  jr z,_done                     ; no additional frames
  jr c,_otherCommands            ; other commands?
  and 0x07                       ; take only the last 3 bits for skip frames
  ld (__PSGlib_MusicSkipFrames),a     ; we got additional frames
_done:
  ld (__PSGlib_MusicPointer),hl       ; save current address
  ret                            ; frame done

_otherCommands:
  cp PSGSubString
  jr nc,_substring
  cp PSGEnd
  jr z,_musicLoop
  cp PSGLoop
  jr z,_setLoopPoint

  ; ***************************************************************************
  ; we should never get here!
  ; if we do, it means the PSG file is probably corrupted, so we just RET
  ; ***************************************************************************

  ret

_send2PSG_B:
  ld a,b
_send2PSG_A:
  out (PSGDataPort),a              ; output the byte
  jp _intLoop

_sendVolume2PSG_B:
  ld a,b
_sendVolume2PSG_A:
  ld c,a                           ; save the PSG command byte
  and 0x0F                         ; keep lower nibble
  ld b,a                           ; save value
  ld a,(__PSGlib_MusicVolumeAttenuation) ; load volume attenuation
  add a,b                          ; add value
  cp 0x0F                          ; check overflow
  jr c,_no_overflow                ; if it is <=15 then ok
  ld a,0x0F                        ; else, reset to 15
_no_overflow:
  ld b,a                           ; save new attenuated volume value
  ld a,c                           ; retrieve PSG command
  and 0xF0                         ; keep upper nibble
  or b                             ; set attenuated volume
  out (PSGDataPort),a              ; output the byte
  jp _intLoop

_output_NoLatch:
  ; we got the last latch in A and the PSG data in B
  ; and we have to check if the value should pass to PSG or not
  ; note that non-latch commands can be only contain frequencies (no volumes)
  ; for channels 0,1,2 only (no noise)
  bit 6,a                        ; test if the latch it is for channels 0-1 or for chn 2
  jr nz,_high_part_Tone          ;  it is tone data for channel 2
  jp _send2PSG_B                 ; otherwise, it is for chn 0 or 1 so we have done!

_setLoopPoint:
  ld (__PSGlib_MusicLoopPoint),hl
  jp _intLoop

_musicLoop:
  ld a,(__PSGlib_LoopFlag)              ; looping requested?
  or a
  jp z,asm_PSGlib_Stop             ; No:stop it! (tail call optimization)
  ld hl,(__PSGlib_MusicLoopPoint)
  jp _intLoop

_substring:
  sub PSGSubString-4                  ; len is value - $08 + 4
  ld (__PSGlib_MusicSubstringLen),a        ; save len
  ld c,(hl)                           ; load substring address (offset)
  inc hl
  ld b,(hl)
  inc hl
  ld (__PSGlib_MusicSubstringRetAddr),hl   ; save return address
  ld hl,(__PSGlib_MusicStart)
  add hl,bc                           ; make substring current
  jp _intLoop

_high_part_Tone:
  ; we got the last latch in A and the PSG data in B
  ; and we have to check if the value should pass to PSG or not
  ; PSG data can only be for channel 2, here
  ld a,b                              ; move PSG data in A
  ld (__PSGlib_Chan2HighTone),a            ; save channel 2 tone HIGH data
  ld a,(__PSGlib_Channel2SFX)              ; channel 2 free?
  or a
  jr z,_send2PSG_B
  jp _intLoop
