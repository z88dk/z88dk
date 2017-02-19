
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_oterm_msg_putc
PUBLIC console_01_output_char_oterm_msg_putc_raw

EXTERN l_jpix
EXTERN console_01_output_char_proc_putchar_scroll
EXTERN console_01_output_char_proc_linefeed

console_01_output_char_oterm_msg_putc:

   ; enter  : c = char to output
   ; can use: af, bc, de, hl
   
   ; char to print is coming from stdio
   
   bit 5,(ix+6)
   jr z, cooked                ; if cook is disabled

   ; tty emulation is enabled
   
   ld a,OTERM_MSG_TTY
   
   call l_jpix                 ; carry reset if tty absorbed char
   ret nc                      ; if tty absorbed char
   
   ld a,c
   
   cp CHAR_BELL
   jr nz, cooked

putchar_bell:

   ld a,OTERM_MSG_BELL
   jp (ix)

cooked:

   ld b,255                    ; b = parameter (255 = undefined)

   ; b = parameter
   ; c = ascii code
   
   bit 4,(ix+6)
   jr z, crlf_done             ; if not processing crlf

   ld a,c
   
   cp CHAR_CR
   ret z                       ; ignore cr

crlf_done:
console_01_output_char_oterm_msg_putc_raw:

   ; b = parameter
   ; c = ascii code

   ld a,c

   cp CHAR_LF
   jp z, console_01_output_char_proc_linefeed

   ; do not check for control chars here

putchar_ok:
   
   ; check print coordinates
   
   ld e,(ix+14)
   ld d,(ix+15)

   ; b = parameter
   ; c = ascii code
   ; e = x coord
   ; d = y coord
   
   ld a,e
   cp (ix+17)
   
   jr c, x_ok                  ; if x < width
   
   ld e,0                      ; x = 0
   inc d                       ; y++

x_ok:

   ld a,d
   sub (ix+19)                 ; a = y - height
   
   jr c, y_ok                  ; if y < height

   ; scroll upward
   
   push bc                     ; save param, char
   push de                     ; save x
   
   inc a
   call console_01_output_char_proc_putchar_scroll
   
   pop de                      ; e = x
   pop bc                      ; b = param, c = char
   
   ld d,(ix+19)
   dec d                       ; d = y = window.height - 1
   
   jr nc, y_ok                 ; if no cls
   
   ld d,0

y_ok:

   inc e                       ; advance x coord
   
   ld (ix+14),e                ; store next x coord
   ld (ix+15),d                ; store next y coord

   dec e
   
   ld l,(ix+16)                ; l = window.left coord
   ld h,(ix+18)                ; h = window.top  coord
   
   add hl,de                   ; hl = absolute character coords
   
   ; b = parameter
   ; c = ascii code
   ; l = absolute x coord
   ; h = absolute y coord
   
   ld a,OTERM_MSG_PRINTC
   jp (ix)
