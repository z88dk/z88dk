
SECTION seg_code_fcntl

PUBLIC zx_01_output_char_32_tty_z88dk_oterm_msg_tty

EXTERN l_offset_ix_de, asm_tty_z88dk
EXTERN console_01_output_proc_tty_return

zx_01_output_char_32_tty_z88dk_oterm_msg_tty:

   ;   implement tty emulation
   ;
   ;   enter  :  c = char to output
   ;   exit   :  c = char to output (possibly modified)
   ;             carry reset if tty emulation absorbs char
   ;   can use:  af, bc, de, hl

   ld hl,26
   call l_offset_ix_de         ; hl = & tty_state
   
   ; hl = & tty_state
   ;  c = ascii char
   
   call asm_tty_z88dk
   
   ; if producing a char for the terminal
   ;
   ;    c = ascii code
   ;    carry set
   ;
   ; if producing nothing for the terminal
   ;
   ;    z flag set
   ;    carry reset
   ;
   ; if executing an action
   ;
   ;    a = action code (> 0)
   ;    nz flag set
   ;    carry reset

   ld hl,action_table
   jp console_01_output_proc_tty_return

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; ACTION TABLE FOR TTY_Z88DK
   ;;
   ;; enter : bc = parameter
   ;;         de = parameter
   ;;
   ;; exit  : if delivering char to terminal
   ;;
   ;;            c = ascii code
   ;;            carry set
   ;;
   ;;         if not delivering char to terminal
   ;;
   ;;            carry reset
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
action_table:

   defw ; action  1 = cls
   defw ; action  2 = home
   defw ; action  3 = cursor left
   defw ; action  4 = cursor right
   defw ; action  5 = cursor up
   defw ; action  6 = cursor down
   defw ; action  7 = tab x (e = x)
   defw ; action  8 = at x,y (e = x, d = y)
   defw ; action  9 = atr dx,dy (e = dx, d = dy)
   defw ; action 10 = scroll
   defw ; action 11 = scroll x (e = x)
   defw ; action 12 = escape
   defw ; action 13 = special_0_0
   defw ; action 14 = special_0_1
   defw ; action 15 = special_0_2
   defw ; action 16 = special_0_3
   defw ; action 17 = special_1_0 x (e = x)
   defw ; action 18 = special_1_1 x (e = x)
   defw ; action 19 = special_1_2 x (e = x)
   defw ; action 20 = special_1_3 x (e = x)
   defw ; action 21 = special_1_4 x (e = x)
   defw ; action 22 = special_1_5 x (e = x)
   defw ; action 23 = special_1_6 x (e = x)
   defw ; action 24 = special_1_7 x (e = x)
   defw ; action 25 = special_2_0 x,y (e = x, d = y)
   defw ; action 26 = special_2_1 x,y (e = x, d = y)
   defw ; action 27 = special_2_2 x,y (e = x, d = y)
   defw ; action 28 = special_2_3 x,y (e = x, d = y)
