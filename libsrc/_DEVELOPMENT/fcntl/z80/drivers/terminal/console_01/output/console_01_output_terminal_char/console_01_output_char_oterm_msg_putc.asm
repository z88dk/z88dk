
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC console_01_output_char_oterm_msg_putc
PUBLIC console_01_output_char_oterm_msg_putc_raw

EXTERN l_jpix
EXTERN console_0l_output_char_proc_reset_scroll_limit
EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_set_coord

EXTERN OTERM_MSG_TTY, OTERM_MSG_PRINTC, OTERM_MSG_BELL
EXTERN OTERM_MSG_SCROLL, OTERM_MSG_CLS, OTERM_MSG_PAUSE
EXTERN ITERM_MSG_BELL

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

   ld a,(ix+19)                ; a = height
   dec a
   
   cp d
   jr nc, y_ok                 ; if y < height
   
   ; scroll upward
      
   push bc                     ; save char info
   
   call putchar_scroll
   
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
   cp c
   
   call nc, putchar_scroll     ; if y >= height
   jp console_01_output_char_proc_set_coord


putchar_scroll:

   ; exit : e = new x coord
   ;        d = new y coord

   bit 7,(ix+7)
   jr nz, scroll_it            ; if input terminal is reading input

   bit 6,(ix+6)
   jr z, scroll_immediate      ; if pause flag is reset
   
   dec (ix+20)
   jr nz, scroll_immediate     ; if scroll limit not reached

pause_scroll:

   ld a,ITERM_MSG_BELL
   call l_jpix                 ; send signal bell

   call console_0l_output_char_proc_reset_scroll_limit
   
   ld a,OTERM_MSG_PAUSE
   call l_jpix

scroll_immediate:

   bit 7,(ix+6)
   jr nz, page_it              ; if page mode selected
   
scroll_it:

   ld c,1                      ; scroll one row

   ld a,OTERM_MSG_SCROLL
   call l_jpix
   
   ld e,0                      ; new x = 0
   
   ld d,(ix+19)
   dec d                       ; new y = rect.height - 1
   
   ret

page_it:

   bit 5,(ix+7)
   jr z, no_cls
   
   ld a,OTERM_MSG_CLS
   call l_jpix

no_cls:

   ld de,0                     ; new x = y = 0
   ret
