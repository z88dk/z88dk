
; ===============================================================
; Apr 2016
; ===============================================================
; 
; uint16_t htons(uint16_t)
;
; Change host byte order to network byte order.
;
; ===============================================================

SECTION code_clib
SECTION code_network

PUBLIC asm_htons

asm_htons:

   ; enter : hl = host order port
   ;
   ; exit  : hl = network order port
   ;
   ; uses  : a, hl

   ld a,l
   ld l,h
   ld h,a

   ret
