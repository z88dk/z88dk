
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_23_atr

EXTERN console_01_output_char_proc_snap
EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_set_coord

zx_01_output_char_32_tty_23_atr:

   ; atr dx,dy
   
   ; de = parameters *
   
   ex de,hl
   
   ld d,(hl)                   ; d = dy
   inc hl
   ld e,(hl)                   ; e = dx
   
   ex de,hl
   
   call console_01_output_char_proc_get_coord
   
   ld a,l
   add a,e
   ld e,a                      ; e = x + dx
   
   ld a,h
   add a,d
   ld d,a                      ; d = y + dy
   
   call console_01_output_char_proc_snap
   jp console_01_output_char_proc_set_coord
   