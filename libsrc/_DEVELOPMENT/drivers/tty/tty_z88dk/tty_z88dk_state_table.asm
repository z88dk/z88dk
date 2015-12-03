
SECTION code_driver
SECTION code_driver_tty

PUBLIC tty_z88dk_state_table

EXTERN asm_tty_state_param_none_absorb
EXTERN asm_tty_output_char
EXTERN asm_tty_param_bb_action
EXTERN asm_tty_state_param_none_action
EXTERN asm_tty_param_b_action

tty_z88dk_state_table:

   ; Specifies the z88dk terminal type
   ;
   ; This is the generic table common across all targets.
   ; Specific targets may copy this table and add additional codes.

   defw asm_tty_state_param_none_absorb          ;  0 = null, absorb
   defw asm_tty_state_param_none_action          ;  1 = scroll
   defw asm_tty_param_bb_action                  ;  2 = font address
   defw asm_tty_output_char                      ;  3 = 
   defw asm_tty_output_char                      ;  4 = 
   defw asm_tty_output_char                      ;  5 = 
   defw asm_tty_output_char                      ;  6 = 
   defw asm_tty_output_char                      ;  7 = bell
   defw asm_tty_state_param_none_action          ;  8 = backspace
   defw asm_tty_state_param_none_action          ;  9 = tab
   defw asm_tty_output_char                      ; 10 = lf
   defw asm_tty_state_param_none_action          ; 11 = home
   defw asm_tty_state_param_none_action          ; 12 = cls
   defw asm_tty_output_char                      ; 13 = cr
   defw asm_tty_output_char                      ; 14 = 
   defw asm_tty_output_char                      ; 15 = 
   defw asm_tty_output_char                      ; 16 = 
   defw asm_tty_output_char                      ; 17 = 
   defw asm_tty_output_char                      ; 18 = 
   defw asm_tty_output_char                      ; 19 = 
   defw asm_tty_output_char                      ; 20 = 
   defw asm_tty_output_char                      ; 21 = 
   defw asm_tty_param_bb_action                  ; 22 = at x,y
   defw asm_tty_param_bb_action                  ; 23 = atr x,y
   defw asm_tty_output_char                      ; 24 = 
   defw asm_tty_output_char                      ; 25 = 
   defw asm_tty_output_char                      ; 26 = 
   defw asm_tty_param_b_action                   ; 27 = esc
   defw asm_tty_state_param_none_action          ; 28 = left
   defw asm_tty_state_param_none_action          ; 29 = right
   defw asm_tty_state_param_none_action          ; 30 = up
   defw asm_tty_state_param_none_action          ; 31 = down
