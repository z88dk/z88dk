
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_64_tty_z88dk_oterm_msg_tty

EXTERN l_offset_ix_de, zx_tty_z88dk_state_table
EXTERN asm_tty_execute_action, l_jphl

zx_01_output_char_64_tty_z88dk_oterm_msg_tty:

   ;   implement tty emulation
   ;
   ;   enter  :  c = char to output
   ;   exit   :  c = char to output (possibly modified)
   ;             carry reset if tty emulation absorbs char
   ;   can use:  af, bc, de, hl

   ld hl,26
   call l_offset_ix_de         ; hl = & tty_state
   
   ; hl = & tty
   ;  c = ascii char
   
   ld de,zx_tty_z88dk_state_table
   
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
   EXTERN zx_01_output_char_32_tty_z88dk_01_scroll
   EXTERN zx_01_output_char_32_tty_z88dk_02_font_address
   EXTERN zx_01_output_char_32_tty_z88dk_08_backspace
   EXTERN zx_01_output_char_32_tty_z88dk_09_tab
   EXTERN zx_01_output_char_32_tty_z88dk_11_home
   EXTERN zx_01_output_char_64_tty_z88dk_12_cls
   EXTERN zx_01_output_char_32_tty_z88dk_14_foreground_mask
   EXTERN zx_01_output_char_32_tty_z88dk_15_background_attr
   EXTERN zx_01_output_char_32_tty_z88dk_16_ink
   EXTERN zx_01_output_char_32_tty_z88dk_17_paper
   EXTERN zx_01_output_char_32_tty_z88dk_18_flash
   EXTERN zx_01_output_char_32_tty_z88dk_19_bright
   EXTERN zx_01_output_char_32_tty_z88dk_20_inverse
   EXTERN zx_01_output_char_32_tty_z88dk_22_at
   EXTERN zx_01_output_char_32_tty_z88dk_23_atr
   EXTERN zx_01_output_char_32_tty_z88dk_27_escape
   EXTERN zx_01_output_char_32_tty_z88dk_28_left
   EXTERN zx_01_output_char_32_tty_z88dk_29_right
   EXTERN zx_01_output_char_32_tty_z88dk_30_up
   EXTERN zx_01_output_char_32_tty_z88dk_31_down
   
action_table:

   defw zx_01_output_char_32_tty_z88dk_01_scroll
   defw zx_01_output_char_32_tty_z88dk_02_font_address
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw zx_01_output_char_32_tty_z88dk_08_backspace
   defw zx_01_output_char_32_tty_z88dk_09_tab
   defw error_einval_znc
   defw zx_01_output_char_32_tty_z88dk_11_home
   defw zx_01_output_char_64_tty_z88dk_12_cls
   defw error_einval_znc
   defw zx_01_output_char_32_tty_z88dk_14_foreground_mask   ; [ 14 = foreground mask ]
   defw zx_01_output_char_32_tty_z88dk_15_background_attr   ; [ 15 = background attr ]
   defw zx_01_output_char_32_tty_z88dk_16_ink               ; [ 16 = ink 0..7 ]
   defw zx_01_output_char_32_tty_z88dk_17_paper             ; [ 17 = paper 0..7 ]
   defw zx_01_output_char_32_tty_z88dk_18_flash             ; [ 18 = flash 0..1 ]
   defw zx_01_output_char_32_tty_z88dk_19_bright            ; [ 19 = bright 0..1 ]
   defw zx_01_output_char_32_tty_z88dk_20_inverse           ; [ 20 = inverse 0..1 ]
   defw error_einval_znc
   defw zx_01_output_char_32_tty_z88dk_22_at
   defw zx_01_output_char_32_tty_z88dk_23_atr
   defw error_einval_znc
   defw error_einval_znc
   defw error_einval_znc
   defw zx_01_output_char_32_tty_z88dk_27_escape
   defw zx_01_output_char_32_tty_z88dk_28_left
   defw zx_01_output_char_32_tty_z88dk_29_right
   defw zx_01_output_char_32_tty_z88dk_30_up
   defw zx_01_output_char_32_tty_z88dk_31_down
