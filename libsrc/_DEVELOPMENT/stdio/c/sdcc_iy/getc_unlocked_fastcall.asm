
; int getc_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _getc_unlocked_fastcall

EXTERN _fgetc_unlocked_fastcall

defc _getc_unlocked_fastcall = _fgetc_unlocked_fastcall

INCLUDE "stdio/z80/asm_getc_unlocked.asm"
