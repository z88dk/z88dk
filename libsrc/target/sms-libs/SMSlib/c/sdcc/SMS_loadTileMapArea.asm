; void SMS_loadTileMapArea(unsigned char x, unsigned char y,  void *src, unsigned char width, unsigned char height)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTileMapArea

EXTERN asm_SMSlib_loadTileMapArea

_SMS_loadTileMapArea:

   pop af
   pop de
   ld h,e
   ld l,d
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,b
   ld b,c
   ld c,a

   jp asm_SMSlib_loadTileMapArea
