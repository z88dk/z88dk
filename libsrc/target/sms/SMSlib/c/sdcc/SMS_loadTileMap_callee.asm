; void SMS_loadTileMap(unsigned char x, unsigned char y, void *src, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTileMap_callee

EXTERN asm_SMSlib_loadTileMap

_SMS_loadTileMap_callee:

   pop af
   pop de
   ld h,e
   ld l,d
   pop de
   pop bc
   push af

   jp asm_SMSlib_loadTileMap
