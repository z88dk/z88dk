
; ===============================================================
; 2002
; ===============================================================
; 
; uint16_t in_stick_keyboard(udk_t *u)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_keyboard

asm_in_stick_keyboard:

   ; enter : hl = struct udk_t *
   ;
   ; exit  : hl = F000RLDU active high
   ;
   ; uses  : af, de, hl

   ld de,0
   
fire:

   ld a,(hl)
   inc hl
   
   in a,($fe)
   
   and (hl)
   inc hl
   
   jr nz, right
   set 7,e

right:

   ld a,(hl)
   inc hl
   
   in a,($fe)
   
   and (hl)
   inc hl
   
   jr nz, left
   set 3,e

left:

   ld a,(hl)
   inc hl
   
   in a,($fe)
   
   and (hl)
   inc hl
   
   jr nz, down
   set 2,e

down:

   ld a,(hl)
   inc hl
   
   in a,($fe)
   
   and (hl)
   inc hl
   
   jr nz, up
   set 1,e

up:

   ld a,(hl)
   inc hl
   
   in a,($fe)
   and (hl)
   
   jr nz, exit
   set 0,e

exit:

   ex de,hl
   ret
