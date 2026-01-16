
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_at

asm_fzx_at:

   ; change coords but snap to window if out of bounds
   ;
   ; enter : ix = struct fzx_state *
   ;         hl = new x
   ;         bc = new y
   ;
   ; exit  : hl = validated x
   ;         bc = validated y
   ;
   ; uses  : af, bc, de, hl
   
   ; check x against left_margin
   
   ld e,(ix+17)
   ld d,(ix+18)                ; de = left_margin
   
   or a
   
   sbc hl,de
   add hl,de
   
   jr nc, margin_ok
   
   ex de,hl                    ; hl = left_margin

margin_ok:

   ; check x against window.width
   
   ld e,(ix+11)
   ld d,(ix+12)                ; de = window.width
   
   or a
   
   sbc hl,de
   add hl,de
   
   jr c, x_ok
   
   ex de,hl
   dec hl                      ; hl = window.width - 1
   
x_ok:

   ld (ix+5),l
   ld (ix+6),h                 ; set new x
   
   ex de,hl                    ; de = new x
   
   ; check y against window.height
   
   ld l,(ix+15)
   ld h,(ix+16)
   dec hl                      ; hl = window.height - 1
   
   or a
   
   sbc hl,bc
   add hl,bc
   
   jr nc, y_ok
   
   ld c,l
   ld b,h                      ; bc = window.height - 1

y_ok:

   ld (ix+7),c
   ld (ix+8),b
   
   ex de,hl
   ret
