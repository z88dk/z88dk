
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_oterm_msg_putc
PUBLIC console_01_output_fzx_oterm_msg_putc_raw

EXTERN l_jpix, l_offset_ix_de, asm_fzx_putc
EXTERN __fzx_puts_newline, __fzx_puts_newline_set_y
EXTERN console_01_output_fzx_proc_linefeed
EXTERN console_01_output_fzx_proc_check_scroll
EXTERN __fzx_puts_single_spacing
EXTERN console_01_output_fzx_proc_putchar_scroll

console_01_output_fzx_oterm_msg_putc:

   ; enter  : c = char to output
   ; can use: af, bc, de, hl
   
   ; char to print is coming from stdio

   bit 5,(ix+6)
   jr z, cooked                ; if cook is disabled
   
   ; tty emulation is enabled
   
   ld a,OTERM_MSG_TTY
   
   call l_jpix
   ret nc                      ; if tty absorbed char
   
   ld a,c
   
   cp CHAR_BELL
   jr nz, cooked

putchar_bell:

   ld a,OTERM_MSG_BELL
   jp (ix)

cooked:

   ; c = ascii code
   
   bit 4,(ix+6)
   jr z, crlf_done             ; if not processing crlf

   ld a,c
   
   cp CHAR_CR
   ret z                       ; ignore cr

crlf_done:
console_01_output_fzx_oterm_msg_putc_raw:

   ; entry for input terminal

   ; c = ascii code

   ld hl,30
   call l_offset_ix_de
   
   push hl
   ex (sp),ix
   
   ; ix = struct fzx_state *
   ;  c = ascii code
   ; stack = FDSTRUCT.JP *

   ld a,c
   
   cp CHAR_LF
   jr z, putchar_lf
   
   cp 32
   jr nc, putchar_loop         ; if printable
   
   ld c,'?'

putchar_loop:

   ; ix = struct fzx_state *
   ;  c = ascii code
   ; stack = FDSTRUCT.JP *

   push bc
   
   call asm_fzx_putc
   
   pop bc                      ; c = ascii code
   jr nc, putchar_done         ; if successful
   
   ; char will not fit window
   
   dec a
   jr z, vertical              ; if char does not fit vertically

horizontal:

   ; char will not fit horizontally
   
   call console_01_output_fzx_proc_linefeed
   jr c, putchar_loop          ; if scroll not necessary

   jr scroll_it

vertical:

   ; char will not fit vertically
   
   call __fzx_puts_single_spacing

   call console_01_output_fzx_proc_check_scroll
   jr c, putchar_loop          ; should not happen

scroll_it:

   ; ix = struct fzx_state *
   ;  c = ascii code
   ; hl = scroll amount in pixels 
   ; stack = FDSTRUCT.JP *

   ex (sp),ix
   push bc
   
   ; ix = FDSTRUCT.JP *
   ; hl = scroll amount in pixels
   ; stack = struct fzx_state *, ascii code

   call console_01_output_fzx_proc_putchar_scroll

   pop bc
   ex (sp),ix
   
   jr putchar_loop

putchar_lf:

   ; ix = struct fzx_state *
   ; stack = FDSTRUCT.JP *

   call console_01_output_fzx_proc_linefeed
   
   pop ix
   ret c                       ; if scroll unnecessary
   
   ; ix = FDSTRUCT.JP *
   ; hl = scroll amount in pixels
   
   jp console_01_output_fzx_proc_putchar_scroll

putchar_done:

   ; ix = struct fzx_state *
   ; stack = FDSTRUCT.JP *

   pop ix
   ret
