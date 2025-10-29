
; ===============================================================
; Apr 2016
; ===============================================================
; 
; uint32_t ntohl(uint32_t)
;
; Change network byte order to host byte order.
;
; ===============================================================

SECTION code_clib
SECTION code_network

PUBLIC asm_ntohl

EXTERN asm_htonl

defc asm_ntohl = asm_htonl

   ; enter : dehl = network order address
   ;
   ; exit  : dehl = host order address
   ;
   ; uses  : a, de, hl
