
; int puts_unlocked(const char *s)

SECTION seg_code_stdio

PUBLIC puts_unlocked

puts_unlocked:

   INCLUDE "stdio/z80/asm_puts_unlocked.asm"
