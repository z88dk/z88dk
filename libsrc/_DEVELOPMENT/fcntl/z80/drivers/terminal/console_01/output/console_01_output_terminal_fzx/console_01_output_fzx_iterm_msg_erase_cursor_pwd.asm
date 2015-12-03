
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_erase_cursor_pwd

EXTERN console_01_output_fzx_iterm_msg_bs_pwd_join

console_01_output_fzx_iterm_msg_erase_cursor_pwd:

;   Input terminal is backspacing to erase the cursor.
;
;   enter  :  e = CHAR_PASSWORD
;            bc = int edit_buffer_len >= 0
;   can use: af, bc, de, hl, ix
;
;   Note: The cursor char is not stored in the buffer.

   push ix                     ; save FDSTRUCT.JP *
   
   ld l,(ix+22)
   push hl                     ; save cursor ascii code
   
   jp console_01_output_fzx_iterm_msg_bs_pwd_join
