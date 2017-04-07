; void SMS_loadTiles(void *src, unsigned int tilefrom, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadTiles_callee

EXTERN asm_SMSlib_loadTiles

SMS_loadTiles_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_SMSlib_loadTiles
