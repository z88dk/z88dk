
; ===============================================================
; 2015
; ===============================================================
; 
; unsigned long cpm_get_offset(void *p)
;
; Return the three-byte little endian value at address p.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_get_offset

asm_cpm_get_offset:

   ; enter :   hl = void *p
   ;
   ; exit  : dehl = three-byte little endian value at p
   ;
   ; uses  : de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   ld h,0
   ex de,hl
   
   ret
