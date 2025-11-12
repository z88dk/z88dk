; void UNSAFE_SMS_VRAMmemcpy64(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy64

EXTERN asm_SMSlib_UNSAFE_VRAMmemcpy64

UNSAFE_SMS_VRAMmemcpy64:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_SMSlib_UNSAFE_VRAMmemcpy64

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _UNSAFE_SMS_VRAMmemcpy64
defc _UNSAFE_SMS_VRAMmemcpy64 = UNSAFE_SMS_VRAMmemcpy64
ENDIF

