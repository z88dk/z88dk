
; ===============================================================
; Apr 2004, Feb 2008
; ===============================================================
;
; void im2_init(void *im2_table)
;
; Point the I register at the im2 table and set im2 mode.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_init

asm_im2_init:

   ; enter : hl = im2_table address (must be on page boundary)
   ;
   ; uses  : af
   
   ld a,h
   ld i,a
   im 2
   ret
