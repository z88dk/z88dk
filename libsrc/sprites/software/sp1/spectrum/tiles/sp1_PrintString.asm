; void sp1_PrintString(struct sp1_pss *ps, uchar *s)
; CALLER linkage for function pointers

PUBLIC sp1_PrintString
EXTERN SP1PrintString, SP1PSPOP, SP1PSPUSH

.sp1_PrintString

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
   
   push hl                   ; push & struct sp1_pss
   call SP1PSPOP
   call SP1PrintString
   pop hl                    ; hl = & struct sp1_pss
   
   jp SP1PSPUSH
