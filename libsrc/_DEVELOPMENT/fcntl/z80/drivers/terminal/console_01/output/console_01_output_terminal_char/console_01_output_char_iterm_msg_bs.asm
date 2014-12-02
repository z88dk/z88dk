
SECTION seg_code_fcntl

PUBLIC console_01_output_char_iterm_msg_bs

EXTERN console_01_output_char_snap

console_01_output_char_iterm_msg_bs:

   ; backspace
   ; can use:  af, bc, de, hl, ix
   
   ; move left then print space
   
   call console_01_output_char_proc_get_coord
   
   dec e                       ; move left
   
   call console_01_output_char_proc_snap
   call console_01_output_char_proc_set_coord
   
   ld l,(ix+16)                ; l = rect.x
   ld h,(ix+18)                ; h = rect.y
   
   add hl,de                   ; hl = absolute character coords
   
   ld b,255
   ld c,32
   
   ld a,OTERM_MSG_PRINTC
   jp (ix)
   