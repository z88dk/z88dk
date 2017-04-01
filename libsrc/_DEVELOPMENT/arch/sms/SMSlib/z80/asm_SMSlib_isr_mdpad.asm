; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_isr_mdpad

EXTERN _SMS_VDPFlags, _VDPBlank
EXTERN _SMS_theLineInterruptHandler, l_jphl
EXTERN _PreviousKeysStatus, _KeysStatus, _PreviousMDKeysStatus, _MDKeysStatus

asm_SMSlib_isr_mdpad:
   
   push af
   push hl
   
   in a,(VDPStatusPort)        ; acknowledge VDP interrupt
   ld (_SMS_VDPFlags),a
   
   rlca
   jr nc, line_interrupt
   
frame_interrupt:

   ld hl,_VDPBlank
   ld (hl),1
   
   ld hl,(_KeysStatus)
   ld (_PreviousKeysStatus),hl
   
   ld hl,(_MDKeysStatus)
   ld (_PreviousMDKeysStatus),hl
   
   ld a,TH_HI
   out (IOPortCtrl),a

   in a,(IOPortL)
   cpl
   ld l,a
   
   in a,(IOPortH)
   cpl
   ld h,a
   
   ld (_KeysStatus),hl
   
   ld a,TH_LO
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   
   ld l,a
   ld h,0

   ; hl = MDKeysStatus
   
   and 0x0c
   jr z, read

   ld l,h
   jr set_MDKeysStatus

read:
   
   dec h
   ld a,l
   cpl
   and 0x30
   ld l,a
   
   ld a,TH_HI
   out (IOPortCtrl),a
   
   ld a,TH_LO
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   and 0x0f
   jr nz, set_MDKeysStatus
   
   ld a,TH_HI
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   cpl
   and 0x0f
   or l
   ld l,a
   
   ld a,TH_LO
   out (IOPortCtrl),a

set_MDKeysStatus:

   ld (_MDKeysStatus),hl
   jr exit

line_interrupt:

   push bc
   push de
   push ix
   push iy
   
   ld hl,(_SMS_theLineInterruptHandler)
   call l_jphl
   
   pop iy
   pop ix
   pop de
   pop bc
   
exit:

   pop hl
   pop af
   
   ei
   ret
