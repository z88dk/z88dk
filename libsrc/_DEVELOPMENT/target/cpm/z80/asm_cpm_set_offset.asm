
; ===============================================================
; 2015
; ===============================================================
; 
; void cpm_set_offset(void *p, unsigned long offset)
;
; Store the least significant three bytes of "offset" at address p.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_set_offset

asm_cpm_set_offset:

   ; enter :   bc = void *p
   ;         dehl = offset
   ;
   ; exit  : none
   ;
   ; uses  : a, de, hl

   ld a,e
   ld e,c
   ld d,b
   ex de,hl
   
   ;  hl = void *p
   ; ade = offset
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),a
   
   ret
