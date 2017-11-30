; ===============================================================
; 2017
; ===============================================================
; 
; uint32_t zxn_addr_from_page(uint8_t page)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_addr_from_page
PUBLIC asm_zxn_addr_from_page_nocheck

EXTERN error_lmc

asm_zxn_addr_from_page:

   ; return linear address from page number
   ;
   ; enter : l = page 0-223
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
IF __ZXNEXT = __ZXNEXT_1MB
   cp 96
ELSE
   cp 224
ENDIF
   jp nc, error_lmc

asm_zxn_addr_from_page_nocheck:

   ; a = page

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
