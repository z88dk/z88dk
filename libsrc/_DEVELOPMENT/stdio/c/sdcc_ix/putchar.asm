
; int putchar(int c)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _putchar

_putchar:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_putchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_putchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _putchar

LIB _putchar_unlocked

_putchar:

   jp _putchar_unlocked
   
   INCLUDE "stdio/z80/asm_putchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
