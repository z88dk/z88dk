; void SMS_loadTiles(void *src, unsigned int tilefrom, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTiles

EXTERN asm_SMSlib_loadTiles

_SMS_loadTiles:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_SMSlib_loadTiles
