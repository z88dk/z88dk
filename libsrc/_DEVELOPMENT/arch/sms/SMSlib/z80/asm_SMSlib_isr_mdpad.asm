; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_isr_mdpad

EXTERN l_jphl

EXTERN __SMSlib_VDPFlags, __SMSlib_VDPBlank
EXTERN __SMSlib_theLineInterruptHandler
EXTERN __SMSlib_PreviousKeysStatus, __SMSlib_KeysStatus
EXTERN __SMSlib_PreviousMDKeysStatus, __SMSlib_MDKeysStatus

asm_SMSlib_isr_mdpad:
   
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
   
   ld hl,(__SMSlib_MDKeysStatus)
   ld (__SMSlib_PreviousMDKeysStatus),hl
   
   ld a,TH_HI
   out (IOPortCtrl),a

   in a,(IOPortL)
   cpl
   ld l,a
   
   in a,(IOPortH)
   cpl
   ld h,a
   
   ld (__SMSlib_KeysStatus),hl
   
   ld a,TH_LO
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   
   ld h,0
   ld l,a

   ; hl = MDKeysStatus
   
   and 0x0c
   jr z, read

   ld l,h
   jr set_MDKeysStatus

read:
   
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

   ld (__SMSlib_MDKeysStatus),hl
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
