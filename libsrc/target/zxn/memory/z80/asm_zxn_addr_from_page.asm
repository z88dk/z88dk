; ===============================================================
; 2017
; ===============================================================
; 
; uint32_t zxn_addr_from_page(uint8_t page)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_addr_from_page

asm_zxn_addr_from_page:

   ; return linear address from page number
   ;
   ; enter : l = 8k page 0-255
   ;
   ; exit  : success
   ;
   ;            dehl = linear address
   ;            carry reset
   ;
   ;         fail
   ;
   ;            dehl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl

   ld a,l
   rrca
   rrca
   rrca
   ld h,a
   
   and $1f
   ld e,a
   
   ld a,h
   and $e0
   ld h,a   
   
   ld d,0
   ld l,d
   
   ret
