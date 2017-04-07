; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_isr

EXTERN l_jphl

EXTERN __SMSlib_VDPFlags, __SMSlib_VDPBlank
EXTERN __SMSlib_PreviousKeysStatus, __SMSlib_KeysStatus
EXTERN __SMSlib_theLineInterruptHandler

asm_SMSlib_isr:
   
   push af
   push hl

   in a,(VDPStatusPort)        ; acknowledge VDP interrupt
   ld (__SMSlib_VDPFlags),a

   rlca
   jr nc, line_interrupt

frame_interrupt:

   ld hl,__SMSlib_VDPBlank
   ld (hl),1
   
   ld hl,(__SMSlib_KeysStatus)
   ld (__SMSlib_PreviousKeysStatus),hl
   
   in a,(IOPortL)
   cpl
   ld (__SMSlib_KeysStatus),a
   
   in a,(IOPortH)
   cpl
   ld (__SMSlib_KeysStatus + 1),a
   
   jr exit

line_interrupt:

   push bc
   push de
   push ix
   push iy
   exx
   ex af,af'
   push af
   push bc
   push de
   push hl
   
   ld hl,(__SMSlib_theLineInterruptHandler)
   call l_jphl
   
   pop hl
   pop de
   pop bc
   pop af
   ex af,af'
   exx
   pop iy
   pop ix
   pop de
   pop bc
   
exit:

   pop hl
   pop af
   
   ei
   reti
