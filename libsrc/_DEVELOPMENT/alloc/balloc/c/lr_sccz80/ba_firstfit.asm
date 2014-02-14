
; void *ba_firstfit(unsigned int queue, unsigned char num)

XLIB ba_firstfit

LIB asm_ba_firstfit

ba_firstfit:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_ba_firstfit
