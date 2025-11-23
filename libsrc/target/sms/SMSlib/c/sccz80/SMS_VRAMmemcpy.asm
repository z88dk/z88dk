; void SMS_VRAMmemcpy(unsigned int dst,void *src,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemcpy

EXTERN asm_SMSlib_VRAMmemcpy

SMS_VRAMmemcpy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_SMSlib_VRAMmemcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_VRAMmemcpy
defc _SMS_VRAMmemcpy = SMS_VRAMmemcpy
ENDIF

