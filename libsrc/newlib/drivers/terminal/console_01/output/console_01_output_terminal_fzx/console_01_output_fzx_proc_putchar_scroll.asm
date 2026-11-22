
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_proc_putchar_scroll

EXTERN OTERM_MSG_PSCROLL, l_jpix, error_znc

console_01_output_fzx_proc_putchar_scroll:

   ; enter : ix = FDSTRUCT.JP *
   ;         hl = scroll amount in pixels
   ;
   ; exit  : de = actual number of pixels scrolled
   ;         else carry set if screen cleared
   ;
   ; uses  : af, bc, de, hl
   
   ld a,OTERM_MSG_PSCROLL
   call l_jpix
   
   jr c, screen_cleared
   
   ; adjust cursor coordinates by scroll amount
   
   ; ix = FDSTRUCT.JP *
   ; hl = actual number of pixels scrolled
   
   ex de,hl                    ; de = pixels scrolled

   ld l,(ix+37)
   ld h,(ix+38)                ; hl = y coord
   
   or a
   sbc hl,de                   ; hl = y - pixels_scrolled
   call c, error_znc           ; if underflow set hl = 0
   
   ld (ix+37),l
   ld (ix+38),h                ; set new y coord
   
   bit 7,(ix+7)
   ret z                       ; if not editing a line
   
   ld l,(ix+27)
   ld h,(ix+28)                ; hl = edit y coord
   
   sbc hl,de                   ; hl = edit_y - pixels_scrolled
   call c, error_znc
   
   ld (ix+27),l
   ld (ix+28),h                ; set new edit y
   
   ret

screen_cleared:

   ; set new y = 0
   
   ld hl,0
   
   ld (ix+37),l
   ld (ix+38),h
   
   bit 7,(ix+7)
   ret z                       ; if not editing a line
   
   ld (ix+27),l
   ld (ix+28),h
   
   ret
