; void sp1_PrintString(struct sp1_pss *ps, uchar *s)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PrintString

EXTERN asm_sp1_PrintString

sp1_PrintString:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = & string
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = & struct sp1_pss

   jp asm_sp1_PrintString
   