
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC console_01_output_char_oterm_msg_putc
PUBLIC console_01_output_char_oterm_msg_putc_raw

EXTERN l_jpix
EXTERN console_01_output_char_proc_putchar_scroll
EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_set_coord

EXTERN OTERM_MSG_TTY, OTERM_MSG_PRINTC, OTERM_MSG_BELL

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
   
   ld a,c
   
   bit 4,(ix+6)
   jr z, crlf_done             ; if not processing crlf
   
   cp CHAR_CR
   ret z                       ; ignore cr

crlf_done:
console_01_output_char_oterm_msg_putc_raw:

   ; b = parameter
   ; c = ascii code

   ld a,c

   cp CHAR_LF
   jr z, putchar_lf

   cp 32
   jr nc, putchar_ok           ; if printable

   ld c,'?'

putchar_ok:
   
   ; check print coordinates
   
   call console_01_output_char_proc_get_coord
   
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
      
   push bc                     ; save char info
   
   inc a
   call console_01_output_char_proc_putchar_scroll
   
   pop bc

y_ok:

   inc e                       ; advance x coord
   
   call console_01_output_char_proc_set_coord

   dec e
   
   ld l,(ix+16)                ; l = window.left coord
   ld h,(ix+18)                ; h = window.top  coord
   
   add hl,de                   ; hl = absolute character coords
   
   ; b = parameter
   ; c = ascii code >= 32
   ; l = absolute x coord
   ; h = absolute y coord
   
   ld a,OTERM_MSG_PRINTC
   jp (ix)


putchar_lf:

   ; linefeed
   
   ld e,0                      ; x = 0
   
   ld d,(ix+15)
   inc d                       ; d = y++
   
   ld c,(ix+19)                ; c = height
   
   ld a,d
   sub c
   inc a
   
   call nc, console_01_output_char_proc_putchar_scroll
   jp console_01_output_char_proc_set_coord
