
XLIB bsearch

LIB asm_bsearch

bsearch:

   pop af
   ex af,af'
   pop ix
   pop de
   pop hl
   pop bc
   pop af
   
   push af
   push bc
   push hl
   push de
   push ix
   ex af,af'
   push af
   
   ex af,af'
   jp asm_bsearch
