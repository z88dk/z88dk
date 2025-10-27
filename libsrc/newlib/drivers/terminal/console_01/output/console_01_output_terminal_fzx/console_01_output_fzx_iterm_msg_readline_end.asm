
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_readline_end

EXTERN l_offset_ix_de
EXTERN console_01_output_char_iterm_msg_readline_end

EXTERN l_jpix
EXTERN ITERM_MSG_READLINE_SCROLL_LIMIT

;;;; NOTE: the deriving fzx terminal must intercept this message and
;;;; set the number of allowed scrolls to the current pixel y coordinate
;;;; divided by the terminal's scroll height in pixels then add one.
;;;; (see zx_01_output_fzx_iterm_msg_readline_end)

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
   
   ; input terminal readline ends
   
   res 7,(ix+7)                ; indicate readline not in progress

   ; opportunity to adjust scroll limit set by derived driver

   ld c,(ix+20)
   
   ld a,ITERM_MSG_READLINE_SCROLL_LIMIT
   call l_jpix

   ld (ix+20),c   
   ret
