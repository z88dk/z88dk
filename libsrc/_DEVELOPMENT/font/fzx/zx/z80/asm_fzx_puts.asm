
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; int fzx_puts(char *s)
;
; Render chars from string s to screen using fzx_putc
;
; ===============================================================

SECTION code_font_fzx

PUBLIC asm_fzx_puts

EXTERN asm_fzx_putc

asm_fzx_puts:

   ; enter : hl = char *s
   ; exit  : hl = number of chars written
   ;         de = & terminating 0 in s or next char not written
   ;         carry flag set if not all chars output successfully
   ;         (an off screen error)
   ; uses  : all except bc, iy
   
   ex de,hl
   ld hl,0                     ; number of chars written

loop:

   ld a,(de)
   or a
   ret z

   exx
   call asm_fzx_putc
   exx
   ret c                       ; error
   
   inc de
   inc hl

   jr loop
