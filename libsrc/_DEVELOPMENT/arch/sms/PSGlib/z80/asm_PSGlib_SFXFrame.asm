; PSGlib - C programming library for the SEGA PSG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "PSGlib_private.inc"

SECTION code_clib
SECTION code_PSGlib

PUBLIC asm_PSGlib_SFXFrame

EXTERN asm_PSGlib_SFXStop

EXTERN _PSGSFXStatus, _PSGSFXSkipFrames, _PSGSFXPointer
EXTERN _PSGSFXSubstringLen, _PSGSFXSubstringRetAddr, _PSGSFXChan2Volume
EXTERN _PSGSFXChan3Volume, _PSGSFXLoopPoint, _PSGSFXStart, _PSGSFXLoopFlag

asm_PSGlib_SFXFrame:

   ; process an SFX frame
   ;
   ; uses : af, bc, hl

  ld a,(_PSGSFXStatus)           ; check if we have got to play SFX
  or a
  ret z

  ld a,(_PSGSFXSkipFrames)       ; check if we have got to skip frames
  or a
  jp nz,_skipSFXFrame

  ld hl,(_PSGSFXPointer)         ; read current SFX address

_intSFXLoop:
  ld b,(hl)                      ; load a byte in B, temporary
  inc hl                         ; point to next byte
  ld a,(_PSGSFXSubstringLen)     ; read substring len
  or a                           ; check if it is 0 (we are not in a substring)
  jr z,_SFXcontinue
  dec a                          ; decrease len
  ld (_PSGSFXSubstringLen),a     ; save len
  jr nz,_SFXcontinue
  ld hl,(_PSGSFXSubstringRetAddr) ; substring over, retrieve return address

_SFXcontinue:
  ld a,b                         ; restore byte
  cp PSGData
  jp c,_SFXcommand               ; if less than $40 then it is a command
  bit 4,a                        ; check if it is a volume byte
  jr z,_SFXoutbyte               ; if not, output it
  bit 5,a                        ; check if it is volume for channel 2 or channel 3
  jr nz,_SFXvolumechn3
  ld (_PSGSFXChan2Volume),a
  jr _SFXoutbyte

_SFXvolumechn3:
  ld (_PSGSFXChan3Volume),a

_SFXoutbyte:
  out (PSGDataPort),a            ; output the byte
  jp _intSFXLoop
  
_skipSFXFrame:
  dec a
  ld (_PSGSFXSkipFrames),a
  ret

_SFXcommand:
  cp PSGWait
  jr z,_SFXdone                  ; no additional frames
  jr c,_SFXotherCommands         ; other commands?
  and #0x07                      ; take only the last 3 bits for skip frames
  ld (_PSGSFXSkipFrames),a       ; we got additional frames to skip
_SFXdone:
  ld (_PSGSFXPointer),hl         ; save current address
  ret                            ; frame done

_SFXotherCommands:
  cp PSGSubString
  jr nc,_SFXsubstring
  cp PSGEnd
  jr z,_sfxLoop
  cp PSGLoop
  jr z,_SFXsetLoopPoint
  
  ; ***************************************************************************
  ; we should never get here!
  ; if we do, it means the PSG SFX file is probably corrupted, so we just RET
  ; ***************************************************************************

  ret

_SFXsetLoopPoint:
  ld (_PSGSFXLoopPoint),hl
  jp _intSFXLoop
  
_sfxLoop:
  ld a,(_PSGSFXLoopFlag)              ; is it a looping SFX?
  or a
  jp z,asm_PSGlib_SFXStop             ; No:stop it! (tail call optimization)
  ld hl,(_PSGSFXLoopPoint)
  ld (_PSGSFXPointer),hl
  jp _intSFXLoop

_SFXsubstring:
  sub PSGSubString-4                  ; len is value - $08 + 4
  ld (_PSGSFXSubstringLen),a          ; save len
  ld c,(hl)                           ; load substring address (offset)
  inc hl
  ld b,(hl)
  inc hl
  ld (_PSGSFXSubstringRetAddr),hl     ; save return address
  ld hl,(_PSGSFXStart)
  add hl,bc                           ; make substring current
  jp _intSFXLoop
