
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_putchar_scroll

EXTERN l_jpix, console_01_output_char_proc_reset_scroll_limit

EXTERN ITERM_MSG_BELL, OTERM_MSG_PAUSE, OTERM_MSG_SCROLL, OTERM_MSG_CLS

console_01_output_char_proc_putchar_scroll:

   ; enter: a = num rows to scroll
   ;
   ; exit : carry set if screen cleared

   or a
   ret z

   ld c,a                      ; c = num rows to scroll

   bit 7,(ix+7)
   jr nz, scroll_it            ; if input terminal is reading input

   bit 6,(ix+6)
   jr z, scroll_immediate      ; if pause flag is reset
   
   sub (ix+20)   
   jr nc, pause_scroll         ; if scroll_amount >= scroll_limit

   neg
   jr scroll_immediate_0

pause_scroll:

   ld b,a                      ; b = excess scroll amount
   
   push bc

   ld a,ITERM_MSG_BELL
   call l_jpix                 ; send signal bell

   call console_01_output_char_proc_reset_scroll_limit

   ld a,OTERM_MSG_PAUSE
   call l_jpix

   pop bc
   
   ld a,(ix+20)
   sub b

scroll_immediate_0:

   ld (ix+20),a                ; new scroll limit

scroll_immediate:

   bit 7,(ix+6)
   jr nz, page_it              ; if page mode selected
   
scroll_it:

   ; c = num rows to scroll

   ld a,OTERM_MSG_SCROLL
   call l_jpix
   
   or a
   ret

page_it:

   bit 5,(ix+7)
   jr z, no_cls
   
   ld a,OTERM_MSG_CLS
   call l_jpix

no_cls:

   ld (ix+20),0                ; set scroll_limit to zero

   scf
   ret
