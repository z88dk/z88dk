
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_inkey_stdio_msg_flsh

;EXTERN zx_01_input_inkey_proc_getk_address
EXTERN console_01_input_stdio_msg_flsh

defc zx_01_input_inkey_stdio_msg_flsh = console_01_input_stdio_msg_flsh


; zx_01_input_inkey_stdio_msg_flsh:
;
;   call zx_01_input_inkey_proc_getk_address  ; hl = & getk_state
;   
;   xor a
;   
;   ld (hl),a                   ; getk_state = 0
;   inc hl
;   ld (hl),a                   ; getk_lastk = 0
;
;   jp console_01_input_stdio_msg_flsh   ; forward to library
