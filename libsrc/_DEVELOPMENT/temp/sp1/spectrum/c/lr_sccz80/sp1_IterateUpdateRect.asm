; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)
; CALLER linkage for function pointers

XLIB sp1_IterateUpdateRect

LIB asm0_sp1_IterateUpdateRect

sp1_IterateUpdateRect:

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm0_sp1_IterateUpdateRect
