; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_isr

EXTERN _SMS_VDPFlags, _VDPBlank
EXTERN _PreviousKeysStatus, _KeysStatus
EXTERN _SMS_theLineInterruptHandler, l_jphl

asm_SMSlib_isr:
   
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
   
   in a,(IOPortL)
   cpl
   ld (_KeysStatus),a
   
   in a,(IOPortH)
   cpl
   ld (_KeysStatus + 1),a
   
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
