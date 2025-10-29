; void SMS_loadTileMap(unsigned char x, unsigned char y, void *src, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadTileMap_callee

EXTERN asm_SMSlib_loadTileMap

SMS_loadTileMap_callee:

   pop hl
   pop bc
   pop de
   dec sp
   pop af
   inc sp
   ex (sp),hl
   
   ld h,l
   ld l,a

   jp asm_SMSlib_loadTileMap
