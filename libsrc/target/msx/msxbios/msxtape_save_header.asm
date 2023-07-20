; int msxtape_save_header(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC msxtape_save_header
PUBLIC _msxtape_save_header
PUBLIC ___msxtape_save_header

EXTERN asm_msxtape_save_header

.msxtape_save_header
._msxtape_save_header
.___msxtape_save_header

;--------------------
;   in   BC=byte size
;        HL=adr.
;--------------------

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp asm_msxtape_save_header
