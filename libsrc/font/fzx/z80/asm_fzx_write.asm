
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

INCLUDE "config_private.inc"

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_write

EXTERN asm_fzx_putc, __fzx_puts_newline

asm_fzx_write:

   ; write buffer to window, interpret \n as newline
   ;
   ; enter : ix = struct fzx_state *
   ;         de = char *buf
   ;         bc = unsigned int buflen
   ;
   ; exit  : hl = number of chars written
   ;         bc = number remaining chars (0 if success)
   ;
   ;         success
   ;
   ;            de = buf + buflen
   ;            carry reset
   ;
   ;         fail if can't fit window
   ;
   ;            de = & next buffer char to output
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, af'

   ld hl,0                     ; number of chars written

   ld a,b
   or c
   ret z

loop:

   push bc
   push de
   push hl
   
   ld a,(de)
   
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
   pop bc
   
   cpi                         ; hl++, bc--
   inc de
   
   jp pe, loop
   ret

off_screen:

   dec a
   jr nz, newline
   
   pop hl
   pop de
   pop bc
   
   ret

newline:

   call __fzx_puts_newline
   
   pop hl
   pop de
   pop bc
   
   jr loop
