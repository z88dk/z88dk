; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_InitCharStruct

EXTERN asm_sp1_InitCharStruct

sp1_InitCharStruct:

   push ix
   exx
   pop bc
   exx

   pop ix
   pop bc
   ld a,c
   ex af,af
   pop bc
   pop de
   ld a,e
   pop de
   pop hl
   push hl
   push de
   push de
   push bc
   push bc
   push ix
   
;   jp asm_sp1_InitCharStruct
   exx
   push bc
   exx
   call asm_sp1_InitCharStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_InitCharStruct
defc _sp1_InitCharStruct = sp1_InitCharStruct
ENDIF

