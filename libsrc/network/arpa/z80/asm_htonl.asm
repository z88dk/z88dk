
; ===============================================================
; Apr 2016
; ===============================================================
; 
; uint32_t htonl(uint32_t)
;
; Change host byte order to network byte order.
;
; ===============================================================

SECTION code_clib
SECTION code_network

PUBLIC asm_htonl

asm_htonl:

   ; enter : dehl = host order address
   ;
   ; exit  : dehl = network order address
   ;
   ; uses  : a, de, hl

   ld a,d
   ld d,l
   ld l,a
   ld a,e
   ld e,h
   ld h,a

   ret
