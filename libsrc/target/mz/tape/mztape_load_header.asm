; int mztape_load_header(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC mztape_load_header
PUBLIC _mztape_load_header

EXTERN asm_mztape_load_header

.mztape_load_header
._mztape_load_header

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
   
   jp asm_mztape_load_header
