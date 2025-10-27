; void SMS_loadSTMcompressedTileMapArea(unsigned char x, unsigned char y, unsigned char *src, unsigned char width)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadSTMcompressedTileMapArea

EXTERN asm_SMSlib_loadSTMcompressedTileMapArea

SMS_loadSTMcompressedTileMapArea:

   ; this is rather painful
   ; we must reverse parameter order on the stack and change char params to single byte
   
   pop hl
   pop bc
   pop de
   dec sp
   pop af
   inc sp
   ex (sp),hl

   ld h,a

   ; bc = width
   ; de = src
   ;  h = y
   ;  l = x
   ; stack = ret

   pop af
   push bc                     ; extra item for sccz80 return
   push bc
   push de
   push hl
   push af
   
   jp asm_SMSlib_loadSTMcompressedTileMapArea
