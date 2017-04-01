; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_crt_common
PUBLIC asm_GG_isr

EXTERN _SMS_Flags, _SMS_theLineInterruptHandler, l_jphl
EXTERN _PreviousKeysStatus, _KeysStatus

include "../SMSlib_private.inc"

asm_GG_isr:
   
   push af
   push hl
   
   ld hl,_SMS_Flags
   
   ld a,(hl)
   and $01                     ; throw away flag bits except pause
   ld (hl),a
   
   in a,(VDPStatusPort)        ; read acts as int ack
   and $e0
   
   or (hl)
   ld (hl),a                   ; update flags
   
   jp p, line_interrupt

vbi_interrupt:

   ld hl,(_KeysStatus)
   ld (_PreviousKeysStatus),hl
   
   in a,(IOPortL)
   cpl
   ld l,a
   
   in a,(GGIOPort)
   cpl
   ld h,a
   
   ld (_KeysStatus),hl
   jr exit

line_interrupt:

   ld hl,(_SMS_theLineInterruptHandler)
   
   ld a,h
   or l
   
   jr z, exit
   
   push bc
   push de
   push ix
   push iy
   
   call l_jphl

   pop iy
   pop ix
   pop de
   pop bc

exit:

   pop hl
   pop af
   
   ei
   reti
