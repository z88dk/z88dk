; void __CALLEE__ bpoke_callee(void *addr, uchar byte)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC bpoke_callee
PUBLIC _bpoke_callee
PUBLIC asm_bpoke

.bpoke_callee
._bpoke_callee
IF __CPU_GBZ80__
   pop af	;ret
   pop de	;byte
   pop hl	;addr
   push af
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF
   
.asm_bpoke

   ld (hl),e
   ret
