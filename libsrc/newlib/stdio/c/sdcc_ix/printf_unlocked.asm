
; int printf_unlocked(const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _printf_unlocked

EXTERN asm_printf_unlocked

defc _printf_unlocked = asm_printf_unlocked
