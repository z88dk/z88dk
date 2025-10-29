; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateRect

EXTERN asm0_sp1_IterateUpdateRect

sp1_IterateUpdateRect:

   push ix	; save IX to BC'
   exx
   pop bc
   exx

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   
   jp asm0_sp1_IterateUpdateRect

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateRect
defc _sp1_IterateUpdateRect = sp1_IterateUpdateRect
ENDIF

