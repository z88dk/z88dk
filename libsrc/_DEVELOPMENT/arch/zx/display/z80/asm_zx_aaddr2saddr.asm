
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_aaddr2saddr(void *attraddr)
;
; Attribute address to screen address. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2saddr

asm_zx_aaddr2saddr:

   ; enter : hl = valid attribute address
   ;
   ; exit  : hl = screen address corresponding to the topmost
   ;              pixel byte in the attribute square
   ;
   ; uses  : af, hl
   
   ld a,h
   
   rlca
   rlca
   rlca
   xor $82
   
   ld h,a
   ret
