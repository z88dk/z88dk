
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================

XLIB __fzx_width_sm

LIB __fzx_glyph_width

__fzx_width_sm:

   ; Char width state machine computes next printable
   ; char's width, ignoring newlines and AT sequences
   ; Processes one char on each call.
   ;
   ; enter : ix = struct fzx_font *
   ;          a = char
   ;          b = num chars to ignore + 1
   ;
   ; exit  : no carry if printable char consumed
   ;         a = total glyph width in pixels
   ;           = width + tracking - kern
   ;         b = kern
   ;
   ;         carry set if unprintable char consumed
   ;         b = num chars to ignore + 1
   ;
   ; uses  : af, bc, hl
   
   djnz next_char
   
   cp 13                       ; newline has zero width
   jr nz, chk_at
   
   ld b,1

next_char:

   scf
   ret

chk_at:
   
   cp 22                       ; AT
   jp nz, __fzx_glyph_width    ; a = total width, b = kern
   
   ld b,3                      ; ignore y,x following AT
   scf
   ret
