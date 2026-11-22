
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_proc_line_spacing
PUBLIC console_01_output_fzx_proc_line_spacing_p

console_01_output_fzx_proc_line_spacing:

   ; enter : ix = struct fzx_state *
   ;         de = font height
   ;         hl = y coordinate + font_height (single spacing applied)
   ;
   ; exit  : hl = y + (font_height * line_spacing)
   ;
   ; uses  : af, de, hl
   
   ld a,(ix-9)

console_01_output_fzx_proc_line_spacing_p:

   and $03                     ; a = line_spacing
   ret z                       ; if single spacing
   
   dec a
   jr nz, double_spacing

one_and_half_spacing:

   srl d
   rr e

double_spacing:

   add hl,de
   ret
