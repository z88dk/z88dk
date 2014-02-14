
; void *ba_addmem(unsigned char q, size_t num, size_t size, void *addr)

XLIB ba_addmem

LIB asm_ba_addmem

ba_addmem:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   
   push ix
   push bc
   push hl
   push de
   push af
   
   ld a,ixl
   jp asm_ba_addmem
