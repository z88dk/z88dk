; void SMS_loadTileMapArea(unsigned char x, unsigned char y,  void *src, unsigned char width, unsigned char height)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTileMapArea_callee

EXTERN asm_SMSlib_loadTileMapArea

_SMS_loadTileMapArea_callee:

   pop af
   pop de
   ld h,e
   ld l,d
   pop de
   pop bc
   push af
   
   ld a,b
   ld b,c
   ld c,a

   jp asm_SMSlib_loadTileMapArea
