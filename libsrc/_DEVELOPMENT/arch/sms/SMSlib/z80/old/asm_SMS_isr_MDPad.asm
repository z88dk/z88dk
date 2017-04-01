; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_crt_common
PUBLIC asm_SMS_isr_MDPad

EXTERN _SMS_Flags, _SMS_theLineInterruptHandler, l_jphl
EXTERN _PreviousKeysStatus, _KeysStatus, _PreviousMDKeysStatus, _MDKeysStatus

include "../SMSlib_private.inc"

asm_SMS_isr_MDPad:
   
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
   
   ld hl,(_MDKeysStatus)
   ld (_PreviousMDKeysStatus),hl
   
   ld a,TH_HI
   out (IOPortCtrl),a
   
   in a,(IOPortH)
   cpl
   ld h,a
   
   in a,(IOPortL)
   cpl
   ld l,a
   
   ld (_KeysStatus),hl
   
   ld a,TH_LO
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   ld l,a
   
   and 0x0c
   jr nz, mdpad_nonexistent

   ld a,l                      ; /* read MD_A & MD_START */
   cpl
   and 0x30
   ld l,a
   
   ld a,TH_HI
   out (IOPortCtrl),a
   
   ld a,TH_LO
   out (IOPortCtrl),a
   
   in a,(IOPortL)
   
   and 0x0f
   jr nz, write_mdkeys         ; /* if not reading 6 buttons */
   
   ld a,TH_HI
   out (IOPortCtrl),a
   
   in a,(IOPortL)              ; /* read MD_MODE, MD_X, MD_Y, MD_Z */
   cpl
   and 0x0f
   or l
   ld l,a
   
   ld a,TH_LO
   out (IOPortCtrl),a

write_mdkeys:

   ld h,0
   ld (_MDKeyStatus),hl
   
   jr exit

mdpad_nonexistent:

   ld hl,0
   ld (_MDKeyStatus),hl

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
