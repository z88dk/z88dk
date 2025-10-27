; unsigned char esx_f_open_p3(unsigned char *filename,unsigned char mode,struct esx_p3_hdr *h)

SECTION code_esxdos

PUBLIC esx_f_open_p3_callee

EXTERN asm_esx_f_open_p3

esx_f_open_p3_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld a,c
   jp asm_esx_f_open_p3

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_open_p3_callee
defc _esx_f_open_p3_callee = esx_f_open_p3_callee
ENDIF

