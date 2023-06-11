; int mztape_save_header(void *addr, size_t len)
; CALLER linkage for function pointers

PUBLIC mztape_save_header
PUBLIC _mztape_save_header

EXTERN asm_mztape_save_header

.mztape_save_header
._mztape_save_header

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
   
   jp asm_mztape_save_header
