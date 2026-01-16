; unsigned char esx_f_ftrunc(unsigned char handle, uint32_t size)

SECTION code_esxdos

PUBLIC esx_f_ftrunc_callee

EXTERN asm_esx_f_ftrunc

esx_f_ftrunc_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld a,l
   jp asm_esx_f_ftrunc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_ftrunc_callee
defc _esx_f_ftrunc_callee = esx_f_ftrunc_callee
ENDIF

