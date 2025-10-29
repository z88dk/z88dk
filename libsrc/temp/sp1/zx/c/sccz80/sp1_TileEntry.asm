; void *sp1_TileEntry(uchar c, void *def)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_TileEntry

EXTERN asm_sp1_TileEntry

sp1_TileEntry:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   
;   jp asm_sp1_TileEntry
   push ix
   call asm_sp1_TileEntry
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_TileEntry
defc _sp1_TileEntry = sp1_TileEntry
ENDIF

