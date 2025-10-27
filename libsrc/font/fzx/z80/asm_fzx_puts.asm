
; int fzx_puts(struct fzx_state *fs, char *s)

INCLUDE "config_private.inc"

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_puts

EXTERN asm_fzx_putc, __fzx_puts_newline

asm_fzx_puts:

   ; write zero terminated string to window
   ; interpret \n as newline
   ;
   ; enter : ix = struct fzx_state *
   ;         de = char *s
   ;
   ; exit  : hl = number of chars written
   ;
   ;         success
   ;
   ;            de = & terminating NUL in s
   ;            carry reset
   ;
   ;         fail if can't fit window vertically
   ;
   ;            de = & next char in s
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, af'
   
   ld hl,0                     ; number of chars written

loop:

   ld a,(de)
   or a
   ret z
   
   push de
   push hl
   
   cp CHAR_LF
   jr nz, putchar

   call __fzx_puts_newline
   jr loop_rejoin

putchar:

   ld c,a
   call asm_fzx_putc

   jr c, off_screen

loop_rejoin:

   pop hl
   pop de
   
   inc hl
   inc de
   
   jr loop

off_screen:

   dec a
   jr nz, newline
   
   pop hl
   pop de
   
   ret

newline:

   call __fzx_puts_newline

   pop hl
   pop de

   jr loop
