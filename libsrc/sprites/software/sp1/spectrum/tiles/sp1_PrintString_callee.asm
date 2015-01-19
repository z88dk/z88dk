; void __CALLEE__ sp1_PrintString_callee(struct sp1_pss *ps, uchar *s)
; 02.2008 aralbrec, Sprite Pack v3.0
; zxz81 hi-res version

PUBLIC sp1_PrintString_callee
EXTERN SP1PrintString, SP1PSPOP, SP1PSPUSH

.sp1_PrintString_callee

   pop hl
   pop de
   ex (sp),hl
   
   push hl                   ; save & struct sp1_pss
   call SP1PSPOP
   call SP1PrintString
   pop hl
   
   jp SP1PSPUSH
