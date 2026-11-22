
; ===============================================================
; Aug 2003, Apr 2014
; ===============================================================
; 
; void in_mouse_kempston(uint8_t *buttons, uint16_t *x, uint16_t *y)
;
; Returns mouse coordinate and button state.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_kempston

EXTERN __input_kempston_mouse_x, __input_kempston_mouse_y
EXTERN __input_kempston_mouse_rawx, __input_kempston_mouse_rawy

asm_in_mouse_kempston:

   ; exit  :  a = button state = 0000 0MRL active high
   ;         de = x coordinate
   ;         bc = y coordinate
   ;
   ; uses  : af, bc, de, hl
   
   ; buttons

   ld a,$fa
   in a,($df)
   
   and $03
   ld l,a
   rla
   srl l
   or $fc
   or l
   cpl                         ; a = buttons = 0000 00RL active high
   
   push af                     ; save buttons

   ; find x coordinate
   
   ld hl,(__input_kempston_mouse_rawx)
   
   ld a,$fb
   in a,($df)
   
   ld (__input_kempston_mouse_rawx),a
   
   sub l
   ld l,a
   sbc a,a
   ld h,a                      ; hl = signed dx
   
   ld de,(__input_kempston_mouse_x)
   add hl,de                   ; hl = new x coordinate
   
   inc h
   jr z, left_bounded
   
   dec h
   jr z, continue_x

right_bounded:

   ld hl,$00ff
   jr continue_x

left_bounded:

   ld hl,0

continue_x:

   ld (__input_kempston_mouse_x),hl
   ex de,hl                    ; de = new x coordinate

   ; find y coordinate
   
   ld hl,(__input_kempston_mouse_rawy)
   
   ld a,$ff
   in a,($df)
   
   ld (__input_kempston_mouse_rawy),a
   
   sub l
   ld l,a
   sbc a,a
   ld h,a                      ; hl = signed dy

   ld bc,(__input_kempston_mouse_y)
   add hl,bc                   ; hl = new y coordinate
   
   inc h
   jr z, top_bounded
   
   dec h
   jr nz, bottom_bounded
   
   ld a,l
   cp 192
   jr c, continue_y

bottom_bounded:

   ld hl,191
   jr continue_y

top_bounded:

   ld hl,0

continue_y:

   ld (__input_kempston_mouse_y),hl
   ld c,l
   ld b,h                      ; bc = new y coordinate

   pop af                      ; a = buttons
   ret
