
SECTION code_fcntl

PUBLIC console_01_output_fzx_iterm_msg_readline_end

EXTERN l_offset_ix_de
EXTERN console_01_output_char_iterm_msg_readline_end

console_01_output_fzx_iterm_msg_readline_end:

   ; input terminal has completed editing
   ; can use: af, bc, de, hl, ix
   
   ; restore fzx variables saved during editing
   
   ld hl,23
   call l_offset_ix_de
   
   ex de,hl                    ; de = & FDSTRUCT.temp_fzx_draw_mode
   
   ld hl,8
   add hl,de                   ; hl = & FDSTRUCT.fzx_draw

   ex de,hl
   
   ldi                         ; restore fzx_draw_mode
   ldi

   ld a,(ix+29)
   ld (ix+49),a                ; restore space_expand
   
   jp console_01_output_char_iterm_msg_readline_end
