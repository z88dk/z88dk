
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_oterm_msg_tty

EXTERN l_offset_ix_de, sms_tty_z88dk_state_table
EXTERN asm_tty_execute_action, l_jphl

sms_01_output_terminal_tty_z88dk_oterm_msg_tty:

   ;   implement tty emulation
   ;
   ;   enter  :  c = char to output
   ;   exit   :  c = char to output (possibly modified)
   ;             carry reset if tty emulation absorbs char
   ;   can use:  af, bc, de, hl

   ld hl,28
   call l_offset_ix_de         ; hl = & tty_state
   
   ; hl = & tty
   ;  c = ascii char
   
   ld de,sms_tty_z88dk_state_table
   
   call l_jphl                 ; execute tty
   ret c                       ; if producing a char for the terminal
   
   ;  a = action code
   ; de = & parameters

   ld hl,action_table
   jp asm_tty_execute_action

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; ACTION TABLE FOR TTY_Z88DK
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   EXTERN error_einval_znc
   EXTERN sms_01_output_terminal_tty_z88dk_01_scroll
   EXTERN sms_01_output_terminal_tty_z88dk_02_pattern_offset
   EXTERN sms_01_output_terminal_tty_z88dk_08_backspace
   EXTERN sms_01_output_terminal_tty_z88dk_09_tab
   EXTERN sms_01_output_terminal_tty_z88dk_11_home
   EXTERN sms_01_output_terminal_tty_z88dk_12_cls
   EXTERN sms_01_output_terminal_tty_z88dk_14_flags_enable
   EXTERN sms_01_output_terminal_tty_z88dk_15_flags_disable
   EXTERN sms_01_output_terminal_tty_z88dk_16_flags_toggle
   EXTERN sms_01_output_terminal_tty_z88dk_22_at
   EXTERN sms_01_output_terminal_tty_z88dk_23_atr
   EXTERN sms_01_output_terminal_tty_z88dk_27_escape
   EXTERN sms_01_output_terminal_tty_z88dk_28_left
   EXTERN sms_01_output_terminal_tty_z88dk_29_right
   EXTERN sms_01_output_terminal_tty_z88dk_30_up
   EXTERN sms_01_output_terminal_tty_z88dk_31_down
   
action_table:

   defw sms_01_output_terminal_tty_z88dk_01_scroll
   defw sms_01_output_terminal_tty_z88dk_02_pattern_offset
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw sms_01_output_terminal_tty_z88dk_08_backspace
   defw sms_01_output_terminal_tty_z88dk_09_tab
   defw error_einval_znc
   defw sms_01_output_terminal_tty_z88dk_11_home
   defw sms_01_output_terminal_tty_z88dk_12_cls
   defw error_einval_znc
   defw sms_01_output_terminal_tty_z88dk_14_flags_enable      ; [ 14 = flags enable ]
   defw sms_01_output_terminal_tty_z88dk_15_flags_disable     ; [ 15 = flags disable ]
   defw sms_01_output_terminal_tty_z88dk_16_flags_toggle      ; [ 16 = flags toggle ]
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw sms_01_output_terminal_tty_z88dk_22_at
   defw sms_01_output_terminal_tty_z88dk_23_atr
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw sms_01_output_terminal_tty_z88dk_27_escape
   defw sms_01_output_terminal_tty_z88dk_28_left
   defw sms_01_output_terminal_tty_z88dk_29_right
   defw sms_01_output_terminal_tty_z88dk_30_up
   defw sms_01_output_terminal_tty_z88dk_31_down
