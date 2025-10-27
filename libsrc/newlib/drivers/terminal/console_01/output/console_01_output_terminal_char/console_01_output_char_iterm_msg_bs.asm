
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_iterm_msg_bs

EXTERN OTERM_MSG_PRINTC
EXTERN console_01_output_char_proc_move_left

console_01_output_char_iterm_msg_bs:

   ; backspace
   ; can use:  af, bc, de, hl, ix
   
   ; move left then print space
   
   ld e,(ix+14)                ; e = x coord
   ld d,(ix+15)                ; d = y coord
   
   ld c,(ix+17)                ; c = window.width
   ld b,(ix+19)                ; b = window.height
   
   call console_01_output_char_proc_move_left

   ld (ix+14),e                ; set x coord
   ld (ix+15),d                ; set y coord
   
   ; print space
   
   ld l,(ix+16)                ; l = window.x
   ld h,(ix+18)                ; h = window.y
   
   add hl,de                   ; hl = absolute character coords
   
   ld bc,$ff20

   ; b = parameter
   ; c = ascii code >= 32
   ; l = absolute x coord
   ; h = absolute y coord

   ld a,OTERM_MSG_PRINTC
   jp (ix)
