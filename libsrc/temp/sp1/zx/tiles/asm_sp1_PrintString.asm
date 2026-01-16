; void sp1_PrintString(struct sp1_pss *ps, uchar *s)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_PrintString

EXTERN SP1PrintString, SP1PSPOP, SP1PSPUSH

asm_sp1_PrintString:
   
   push hl                   ; save & struct sp1_pss
   call SP1PSPOP
   call SP1PrintString
   pop hl
   
   jp SP1PSPUSH
