; void SMS_loadTileMap(unsigned char x, unsigned char y, void *src, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadTileMap

EXTERN asm_SMSlib_loadTileMap

SMS_loadTileMap:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   
   push hl
   push hl
   push de
   push bc
   push af
   
   ld a,ixl
   ld h,a

   jp asm_SMSlib_loadTileMap
