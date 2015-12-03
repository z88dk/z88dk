
; ===============================================================
; Apr 2004, Feb 2008
; ===============================================================
;
; void *im2_install_isr(uint8_t vector, void *isr)
;
; Install the isr on the vector given.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_im2_install_isr

asm_im2_install_isr:

   ; enter :  l = vector to install on (even by convention)
   ;         de = new isr address
   ;
   ; exit  : hl = old isr address
   ;
   ; uses  : af, de, hl
   
   ld a,i
   ld h,a                      ; hl = address in im2 table corresponding to vector
   
   ld a,(hl)                   ; read current isr address
   ld (hl),e                   ; write new isr address
   ld e,a
   inc hl
   
   ld a,(hl)
   ld (hl),d
   ld d,a
   
   ex de,hl
   ret
