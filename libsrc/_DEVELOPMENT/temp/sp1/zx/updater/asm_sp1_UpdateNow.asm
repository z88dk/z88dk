
; sp1_UpdateNow
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_UpdateNow

EXTERN SP1DrawUpdateStruct

; Iterates through the invalidated tiles list, drawing all invalidated tiles on screen.
; Validates them and removes them from the list along the way.
;
; enter : none
; uses  : af, bc, de, hl, ix, b' for MaskLB and MaskRB sprites

asm_sp1_UpdateNow:

   ld hl,(SP1V_UPDATELISTH+6) ; get the first struct update char to draw
   ld a,l
   ld l,h
   ld h,a                    ; correct endianness
   or a
   jp nz, updatelp
   ret                       ; if empty update list

.skipthischar

   ld bc,6
   add hl,bc                 ; hl = & struct update.next_update
   ld a,(hl)
   or a
   jr z, doneupdate          ; return if no next struct update
   inc hl
   ld l,(hl)
   ld h,a                    ; hl = next struct update
   
.updatelp

   bit 6,(hl)                ; if this update char has been removed from the display skip it
   jr nz, skipthischar

   ld a,$80
   xor (hl)                  ; (hl) = # load sprites, bit 7 set for marked to update
   jp m, skipthischar        ; if bit 7 was reset (now set), this char was validated so skip it
   ld (hl),a                 ; mark char as not needing update (bit 7 is reset)

   ld b,a                    ; b = # of occluding sprites in this char + 1

   ;  b = # occluding sprites in char + 1
   ; hl = & struct sp1_update

   call SP1DrawUpdateStruct

   ; bc = & next sp1_update in update list

   ld l,c
   ld h,b
   
   inc b                     ; go to next char to update (more if b!=0)
   djnz updatelp

.doneupdate

   xor a
   ld (SP1V_UPDATELISTH+6),a ; mark update list empty
   ld hl,SP1V_UPDATELISTH
   ld (SP1V_UPDATELISTT),hl
   ret
