; void SMS_loadTileMapArea(unsigned char x, unsigned char y,  void *src, unsigned char width, unsigned char height)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTileMapArea_callee

EXTERN asm_SMSlib_loadTileMapArea

_SMS_loadTileMapArea_callee:

   pop af
   pop bc
   pop de
   ld b,e
   pop de
   pop hl
   pop ix
   push af
   
   ld a,ixl
   ld h,a
   jp asm_SMSlib_loadTileMapArea
