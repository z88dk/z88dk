
; ===============================================================
; Apr 2016
; ===============================================================
; 
; uint16_t ntohs(uint16_t)
;
; Change network byte order to host byte order.
;
; ===============================================================

SECTION code_clib
SECTION code_network

PUBLIC asm_ntohs

EXTERN asm_htons

defc asm_ntohs = asm_htons

   ; enter : hl = network order port
   ;
   ; exit  : hl = host order port
   ;
   ; uses  : a, hl
