
; void *balloc_firstfit(unsigned int queue, unsigned char num)

XLIB balloc_firstfit

LIB asm_balloc_firstfit

balloc_firstfit:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_balloc_firstfit
