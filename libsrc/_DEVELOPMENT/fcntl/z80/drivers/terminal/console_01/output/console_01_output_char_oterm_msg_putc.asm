
INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC console_01_output_char_oterm_msg_putc
PUBLIC console_01_output_char_oterm_msg_putc_raw

EXTERN l_jpix

EXTERN OTERM_MSG_TTY, OTERM_MSG_PRINTC, OTERM_MSG_BELL
EXTERN OTERM_MSG_SCROLL, OTERM_MSG_SCROLL_PAUSE

console_01_output_char_oterm_msg_putc:

   ; enter  : c = char to output
   ; can use: af, bc, de, hl
   
   ; char to print is coming from stdio
   
   bit 5,(ix+6)
   jr z, fgnd_colour           ; if cook is disabled

   ; tty emulation is enabled
   
   ld a,OTERM_MSG_TTY
   call l_jpix                 ; carry set if tty absorbed char
   
   ccf
   ret nc                      ; if tty absorbed char
   
   ld a,c
   
   cp CHAR_BELL
   jr z, putchar_bell

fgnd_colour:

   ld b,(ix+23)                ; b = foreground colour

console_01_output_char_oterm_msg_putc_raw:

   ; b = foreground colour
   ; c = ascii code
   
   ld a,c
   
   bit 4,(ix+6)
   jr z, crlf_done             ; if not processing crlf
   
   cp CHAR_CR
   ret z                       ; ignore cr

crlf_done:

   cp CHAR_LF
   jr z, putchar_lf
   
   cp 32
   jr nc, putchar_ok           ; if printable

   ld c,'?'

putchar_ok:
   
   ; check print coordinates
   
   ld e,(ix+14)                ; e = x coord
   ld d,(ix+15)                ; d = y coord
   
   ld a,e
   cp (ix+17)
   
   jr c, x_ok                  ; if x < width
   
   ld e,0                      ; x = 0
   inc d                       ; y++

x_ok:

   ld a,(ix+19)                ; a = height
   dec a
   
   cp d
   jr nc, y_ok                 ; if y < height
   
   ; scroll upward
   
   ld d,a                      ; y = last line
   
   push bc                     ; save char info
   push de                     ; save coords
   
   call putchar_scroll
   
   pop de
   pop bc

y_ok:

   inc e                       ; advance x coord
   
   ld (ix+14),e                ; store next x coord
   ld (ix+15),d                ; store next y coord
   
   dec e
   
   ld l,(ix+16)                ; l = window.left coord
   ld h,(ix+18)                ; h = window.top  coord
   
   add hl,de                   ; hl = absolute character coords
   
   ; b = foreground colour
   ; c = ascii code >= 32
   ; l = absolute x coord
   ; h = absolute y coord
   
   ld a,OTERM_MSG_PRINTC
   jp (ix)


putchar_bell:

   ; make audible noise

   bit 6,(ix+6)
   ret z                       ; if bell disabled
   
   ld a,OTERM_MSG_BELL
   jp (ix)


putchar_lf:

   ; linefeed
   
   ld (ix+14),0                ; x coord = 0
   
   ld a,(ix+15)                ; a = y coord
   inc a
   
   ld c,(ix+19)                ; c = height
   
   cp c
   jr nc, lf_scroll            ; if y >= height
   
   ld (ix+15),a                ; store new y coord
   ret
   
lf_scroll:

   dec c
   ld (ix+19),c                ; y = last line

   ; fall through to putchar_scroll

putchar_scroll:

   ld a,(ix+22)                ; a = scroll limit
   
   or a
   jr z, scroll_immediate      ; if continuous scroll
   
   dec a
   ld (ix+22),a                ; write new scroll limit
   
   jr nz, scroll_immediate     ; if scroll limit not reached
   
   ld a,(ix+19)
   ld (ix+22),a                ; scroll limit = window.height

   ld a,OTERM_MSG_SCROLL_PAUSE
   jp (ix)
   
scroll_immediate:

   ld a,OTERM_MSG_SCROLL
   jp (ix)
