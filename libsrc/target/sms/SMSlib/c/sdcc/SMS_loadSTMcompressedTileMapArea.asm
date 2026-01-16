; void SMS_loadSTMcompressedTileMapArea(unsigned char x, unsigned char y, unsigned char *src, unsigned char width)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadSTMcompressedTileMapArea

EXTERN asm_SMSlib_loadSTMcompressedTileMapArea

defc _SMS_loadSTMcompressedTileMapArea = asm_SMSlib_loadSTMcompressedTileMapArea
