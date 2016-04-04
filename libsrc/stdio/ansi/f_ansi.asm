;
;       Z80 ANSI Library
;
;---------------------------------------------------
; ANSI specifics handling.
; (Intel 8086 to Z80 port)
;
; Optimized for speed in the case of multi-character write requests.
; Original NANSI terminal driver (C) 1986 Daniel Kegel  - http://www.kegel.com
; Modifications by Tom Almy without restrictions.
;
; - Port to Z80 and some improvement by Stefano Bodrato - 21/4/2000
; - Small fix on the "set cursor position" range checks - 21/11/2002
;
; MISSING or surely buggy Escapes:
;       I - Cursor up and scroll down if on top
;       L - Insert lines: to be completed
;       M - Delete lines: to be completed
;
;
;       $Id: f_ansi.asm,v 1.15 2016-04-04 18:31:22 dom Exp $
;
	SECTION	  code_clib
        PUBLIC    f_ansi
        EXTERN     ansi_putc
        EXTERN     ansi_attr
        EXTERN     ansi_CHAR
        EXTERN     ansi_cls
        EXTERN     ansi_LF
        EXTERN     ansi_DSR6
        EXTERN     ansi_BEL
        EXTERN     ansi_del_line


        EXTERN    text_cols
        EXTERN    text_rows



;---------------------------------------------------
;  Fire out all the buffer (pointed by HL; len DE)
;---------------------------------------------------

.f_ansi
        ld     a,d
        or     e
        ret    z

.show

; **** Link to ANSI engine ****
        ld     bc,(escvector)
        ld     a,b
        or     c
        jp     nz,f_in_escape
        
        ld     a,(hl)
        inc    hl
        dec    de
        
        cp     27
        jp     z,f_escape

; Hide the following two lines to disable CSI.
        cp    155 ;h9b ;CSI?
        jp    z,f_9b

; *****************************

;------------------------
 cp     12  ; Form Feed (CLS) ?
;------------------------
        jr     nz,noFF
        call   docls
        jr     loopn
.noFF

;------------------------
; cp     13  ; CR?
;------------------------
; jr     nz,NoCR
; ld     a,(ansi_COLUMN)
; xor    a
; ld     (ansi_COLUMN),a
; jr     loopn
;.NoCR


;------------------------
; Temporary (?) patch.
; CR becomes CR+LF
;------------------------
        cp 13
        jr     z,isLF
;------------------------

        cp     10  ; LF?
        jr     nz,NoLF

;------------------------
.isLF
;------------------------
;
        push   hl
        push   de
        call   ansi_LF
        pop    de
        pop    hl
        jr     loopn

.NoLF
        cp     9 ; TAB?
        jr     nz,NoTAB
        push   hl
        push   de
        ld     a,(ansi_COLUMN)
        rra
        rra
        inc    a
        rla
        rla
        push   hl
        ld     hl,text_cols
        cp     (hl)
        pop    hl
        jp     p,OutTAB
        ld     (ansi_COLUMN),a
.OutTAB
        pop    de
        pop    hl
        jr     loopn
.NoTAB

;------------------------
 cp     7  ; BEL?
;------------------------
        jr     nz,NoBEL
        push   hl
        push   de
        call   ansi_BEL
        pop    de
        pop    hl
        jr     loopn
.NoBEL

;------------------------
 cp     8   ; BackSpace
;------------------------
        jr     nz,NoBS
        ld     a,(ansi_COLUMN)
        and    a
        jr     z,firstc ; are we in the first column?
        dec    a
        ld     (ansi_COLUMN),a
        jr     loopn
.firstc
        ld     a,(ansi_ROW)
        and    a
        jr     z,loopn
        dec    a
        ld     (ansi_ROW),a
        ld     a,(text_cols)
        dec    a
        ld     (ansi_COLUMN),a
        jr     loopn
.NoBS


; **** Link to ANSI engine ****

.f_not_ANSI   ;
        push   hl
        push   de
        call   ansi_putc
        pop    de
        pop    hl
.loopn
        ld     a,d
        or     e
        jp     nz,show

.f_loopdone
        ret

; *****************************


;------------------------------------------------
;   Clear screen and set text position to HOME
;------------------------------------------------

.docls
        push   hl
        push   de
        push   bc
        call   ansi_cls
        xor    a                ; HOME cursor
        ld     (ansi_ROW),a
        ld     (ansi_COLUMN),a
        pop    bc
        pop    de
        pop    hl
        ret


; A state machine implementation of the mechanics of ANSI terminal control
; string parsing.
;
; Entered with a jump to f_escape when driver finds an escape, or
; to f_in_escape when the last string written to this device ended in the
; middle of an escape sequence.
;
; Exits by jumping to f_ANSI_exit when an escape sequence ends, or
; to f_not_ANSI when a bad escape sequence is found, or (after saving state)
; to f_loopdone when the write ends in the middle of an escape sequence.
;
; Parameters are stored as bytes in param_buffer.  If a parameter is
; omitted, it is stored as zero.  Each character in a keyboard reassignment
; command counts as one parameter.
;
; When a complete escape sequence has been parsed, the address of the
; ANSI routine to call is found in ansi_fn_table.
;
; Register usage during parsing:
;  HL points to the incoming string.
;  DE holds the length remaining in the incoming string.
;  BC is the (incrementing) pointer to param_buffer


.f_ANSI_exit
        ld     bc,0
        ld     (escvector), bc
        jp     loopn

;----- f_in_escape ---------------------------------------------------
; Main loop noticed that escvector was not zero.
; Recall value of BC saved when sleep was jumped to, and jump into parser.
.f_in_escape
        ld      bc, (escvector)
        push    bc
        ld      bc, (cur_parm_ptr)
        ret

;----- syntax_error ---------------------------------------
; A character was rejected by the state machine.  Exit to
; main loop, and print offending character.  Let main loop
; decrement DE (length of input string).
.syntax_error

        ld      bc,0
        ld      (escvector), bc
        jp      f_not_ANSI      ; exit, print offending char

;----- f_escape ------------------------------------------------------
; We found an escape.  Next character should be a left bracket.
.f_escape
        ; next_is f_bracket
        ld      a,d
        or      e
        jr      nz, f_bracket
        ld      bc, f_bracket
        ld      (escvector), bc
        jp      f_loopdone

;----- f_bracket -----------------------------------------------------
; Last char was an escape.  This one should be a [; if not, print it.
; Next char should begin a parameter string.
.f_bracket

        ld      a, (hl)
        inc     hl
        dec     de
        cp      '['
        jr      nz, syntax_error
.f_9b       ; Entry for CSI.  (Eq. ESC[)
        ; Set up for getting a parameter string.
        ld      bc, param_buffer
        xor     a                       ; zero
        ld      (bc), a                 ; default first char
        dec     bc                      ; point buffer before start
        ld      (eat_key), a            ; no eaten key
        ; next_is f_get_args
        ld      a,d
        or      e
        jr      nz, f_get_args
        ld      (cur_parm_ptr), bc
        ld      bc, f_get_args
        ld      (escvector), bc
        jp      f_loopdone

;----- f_get_args ---------------------------------------------------
; Last char was a [.  If the current char is a '=' or a '?', save
; it for SET/RESET MODE, and then proceed to f_get_param.
.f_get_args

        ld      a,(hl)
        inc     hl
        dec     de
        cp      '='
        jr      z, fga_ignore
        cp      '?'
        jr      nz, get_param_B
.fga_ignore
        ld      (eat_key), a          ; save = or ?
        ; next_is f_get_param
        ld      a,d
        or      e
        jr      nz, f_get_param
        ld      (cur_parm_ptr), bc
        ld      bc, f_get_param
        ld      (escvector), bc
        jp      f_loopdone

;----- f_get_param ---------------------------------------------------
; Last char was one of the four characters "]?=;".
; We are getting the first digit of a parameter, a quoted string,
; a ;, or a command.
.f_get_param
        ld      a,(hl)
        inc     hl
        dec     de
.get_param_B   ; jump to here if no fetch of character

        cp      '0'
        jp      m, fgp_may_quote

        cp      '9'+1
        jp      p, fgp_may_quote
                ; if bc <param_end bc++
                push    hl   
                ld      h,b
                ld      l,c
                push    bc
                ld      bc,param_end
                sbc     hl,bc    
                pop     bc
                pop     hl
                jr      nc,NoBCinc
                inc     bc
              .NoBCinc

                ; It's the first digit.  Initialize parameter with it.
                sub     '0'
                ld      (bc), a
                ; next_is f_in_param
                ld      a,d
                or      e
                jp      nz, f_in_param
                ld      (cur_parm_ptr), bc
                ld      bc, f_in_param
                ld      (escvector), bc
                jp      f_loopdone

.fgp_may_quote
        cp      '"'
        jr      z, fgp_isquote
        cp      '\\'
        jp      nz, fgp_semi_or_cmd    ; jump to code shared with f_in_param
.fgp_isquote
        ld      (string_term), a       ; save it for end of string
        ; and read string into param_buffer ; next_is f_get_string
        ld      a,d
        or      e
        jr      nz, f_get_string
        ld      (cur_parm_ptr), bc
        ld      bc, f_get_string
        ld      (escvector), bc
        jp      f_loopdone

.fgp_semi_or_cmd
        cp      ';'                    ; is it a semi?
        jp      nz, fgp_cmd            ; no, then it's a command

                ; if bc <param_end bc++
                push    hl   
                ld      h,b
                ld      l,c
                push    bc
                ld      bc,param_end
                sbc     hl,bc    
                pop     bc
                pop     hl
                jr      nc,NoBCinc2
                inc     bc
              .NoBCinc2

        xor     a                      ; zero
        ld      (bc), a                ; it is a zero parameter

.f_goto_next
                ;next_is f_get_param
                ld      a,d
                or      e
                jr      nz, f_get_param
                ld      (cur_parm_ptr), bc
                ld      bc, f_get_param
                ld      (escvector), bc
                jp      f_loopdone

;----- f_get_string -------------------------------------
; Last character was a quote or a string element.
; Get characters until ending quote found.
.f_get_string
        ld      a, (hl)
        inc     hl
        dec     de
        push    hl
        ld      hl, string_term
        cp      (hl)
        pop     hl
        jr      z, fgs_init_next_param
                ; if bc <param_end bc++
                push    hl   
                ld      h,b
                ld      l,c
                push    bc
                ld      bc,param_end
                sbc     hl,bc    
                pop     bc
                pop     hl
                jr      nc,NoBCinc3
                inc     bc
              .NoBCinc3

                ld      (bc), a

                ;next_is f_get_string
                ld      a,d
                or      e
                jr      nz, f_get_string
                ld      (cur_parm_ptr), bc
                ld      bc, f_get_string
                ld      (escvector), bc
                jp      f_loopdone

; Ending quote was found.
.fgs_init_next_param
                ;next_is f_eat_semi
                ld      a,d
                or      e
                jr      nz, f_eat_semi
                ld      (cur_parm_ptr), bc
                ld      bc, f_eat_semi
                ld      (escvector), bc
                jp      f_loopdone

;----- f_eat_semi -------------------------------------
; Last character was an ending quote.
; If this char is a semi, eat it
; Then goto f_get_param
.f_eat_semi
        ld      a,(hl)
        inc     hl
        dec     de
        cp      ';'
        jp      nz, get_param_B
        jr      f_goto_next

;------ f_in_param -------------------------------------
; Last character was a digit.
; Looking for more digits, a semicolon, or a command character.
.f_in_param
        ld      a,(hl)
        inc     hl
        dec     de
        cp      '0'
        jp      m, fgp_not_digit
        cp      '9'+1
        jp      p, fgp_not_digit

                ; It's another digit.  Add into current parameter.
                sub     '0'
                push    bc
                push    af
                ld      a, (bc)
                ld      c,a
                ld      b,9
               .Per10
                add     a, c
                djnz    Per10
                ld      c,a
                pop     af
                add     a, c
                pop     bc
                ld      (bc), a

                ;next_is f_in_param
                ld      a,d
                or      e
                jr      nz, f_in_param
                ld      (cur_parm_ptr), bc
                ld      bc, f_in_param
                ld      (escvector), bc
                jp      f_loopdone

.fgp_not_digit
        cp      ';'
        jp      z, f_goto_next
.fgp_cmd
        ; It must be a command letter.


push hl
push de

;Count no. of parameters in reg. B
        ld      h,b
        ld      l,c
        ld      bc,param_buffer
        dec     bc
        scf
        ccf
        sbc     hl,bc
        ld      b,l
; if B=0 -> set to 1 first parameter (B is still = 0)
        inc     b
        dec     b
        jr      nz,no_default
        push    af
        ld      hl,param_buffer
        ld      a,1
        ld      (hl),a
        pop     af
.no_default


; Command interpreter

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Set graphic rendition %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'm'
        jp nz,no_m

        inc     b
        dec     b
        jr      nz,m_nodefault
        ld      hl,param_buffer
        ld      a,0
        ld      (hl),a
        inc     b
.m_nodefault
        ld      hl,param_buffer
.loop_m
        ld      a,(hl)
        call    ansi_attr
        inc     hl
        dec     b
        jp      nz,loop_m
        jp      f_cmd_exit
.no_m

;.temp   jp      f_cmd_exit

;%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% C %%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Cursor forward %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'C' ; CUF - Cursor foreward
        jr nz,no_C

        ld      hl,param_buffer
        ld      a,(ansi_COLUMN)
        add     a,(hl)
        push    bc
        push    af
        ld      a,(text_cols)
        ld      b,a
        pop     af
        inc     b
        cp      b
        pop     bc
        jp      p, no_C_FWD
        ld      (ansi_COLUMN),a
        jp      f_cmd_exit
.no_C_FWD
        ld      a,(text_cols)
        dec     a
        ld      (ansi_COLUMN),a
        jp      f_cmd_exit
.no_C

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% D %%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Cursor backward %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'D' ; CUB - Cursor backward
        jr nz,no_D

        ld      hl,param_buffer
        ld      a,(ansi_COLUMN)
        sub     (hl)
        jp      nc, no_D_TOP
        xor     a
.no_D_TOP
        ld      (ansi_COLUMN),a
        jp      f_cmd_exit
.no_D

;%%%%%%%%%%%%%%%%%%%%%%
;%% A %%%%%%%%%%%%%%%%%
;%%%%%%%% Cursor UP %%%
;%%%%%%%%%%%%%%%%%%%%%%
        cp 'A' ; CUU - Cursor up
        jr nz,no_A

        ld      hl,param_buffer
.f_ansi_cup
        ld      a,(ansi_ROW)
        sub     (hl)
        jp      p, no_A_TOP
        xor     a
.no_A_TOP
        ld      (ansi_ROW),a
        jp      f_cmd_exit
.no_A

;%%%%%%%%%%%%%%%%%%%%%%%%
;%% B %%%%%%%%%%%%%%%%%%%
;%%%%%%%% Cursor DOWN %%%
;%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'B' ; CUD - Cursor down
        jr nz,no_B

        ld      hl,param_buffer
        ld      a,(ansi_ROW)
        add     a,(hl)
        inc     a
        ld      hl,text_rows
        cp      (hl)
        jp      p,B_ok
        ld      a,(text_rows)
.B_ok
        dec     a
        ld      (ansi_ROW),a
        jp      f_cmd_exit
.no_B


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% s - j %%%%%%%%%%%%%%%%%%%%
;%%%%%%%% save cursor pos. %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 's' ; SCP - Save cursor position
        jr z,do_s
        cp 'j'
        jr nz,no_s
.do_s
        ld      a,(ansi_COLUMN)
        ld      (scp_x),a
        ld      a,(ansi_ROW)
        ld      (scp_y),a
        jp      f_cmd_exit
.no_s


;%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% u - k %%%%%%%%%%%%%%%%%%
;%%%%%%%% r. cursor pos. %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'u' ; RCP - Restore cursor position
        jr z,do_u
        cp 'k'
        jr nz,no_u
.do_u
        ld      a,(scp_x)
        ld      (ansi_COLUMN),a
        ld      a,(scp_y)
        ld      (ansi_ROW),a
        jp      f_cmd_exit
.no_u

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% H %%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% SET cursor pos. %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'f'  ; HVP not fully functional
        jr z,IsHVP
        cp 'H'  ; CUP - Cursor position
        jr nz,no_H
.IsHVP
        inc     b
        dec     b
        jr      nz,H_Nodeflt
        ld      hl,param_buffer
        ld      a,1
        ld      (hl),a
        inc     hl
        ld      (hl),a
.H_Nodeflt
        dec     b
        jr      nz,H_nodef1
        ld      hl,param_buffer
        inc     hl
        ld      a,1
        ld      (hl),a

.H_nodef1
        ld      hl,param_buffer ; point to row
        ld      a,(hl)
        and     a
        jr      z,HLineOK
        push    hl
        dec     a
        ld      hl,text_rows
        cp      (hl)
        pop     hl
        jr      c,HLineOK
        ld      a,(text_rows)   ; position next char at max possible row
        dec     a
.HLineOK
        ld      (ansi_ROW),a

        inc     hl              ; point to column
        ld      a,(hl)
        and     a
        jr      z,HColOK
        dec     a               ; char position
        ld      hl,text_cols
        cp      (hl)
        jr      c,HColOK
        ld      a,(text_cols)   ; position next char at max possible column
        dec     a
.HColOK
        ld      (ansi_COLUMN),a
        jp      f_cmd_exit
.no_H

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Erase from start of display %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'b'
        jr z,is_J1_b


;%%%%%%%%%%%%%%%%
;%% J %%%%%%%%%%%
;%%%%%%%% CLS %%%
;%%%%%%%%%%%%%%%%
        cp 'J' ; ED - Erase in display
        jp nz,no_J
        inc     b
        dec     b
        jr      nz,J_nodefault
        ld      hl,param_buffer
        ld      a,0
        ld      (hl),a
;        inc     b  --not useful (1 parameter only)
.J_nodefault
        ld      hl,param_buffer
        ld      a,(hl)
        and     a       ; from cursor to end of screen
        jr      nz,no_J_0
        ; First, from cursor to EOL
        ld      a,(ansi_ROW)
        push    af
        ld      a,(ansi_COLUMN)
        push    af
.j0loop
        push    af
        ld      a,32 ;' '   ; BLANK
        call    ansi_CHAR   ; The low level video routine
        pop     af
        inc     a
        ld      (ansi_COLUMN),a
        ld      hl,text_cols
        cp      (hl)
        jp      m,j0loop
        pop     af
        ld      (ansi_COLUMN),a   ; restore orig. cursor pos.
        pop     af
        ld      (ansi_ROW),a   ; restore orig. cursor pos.
        ; Then, from the cursor line + 1 up to the last line
.j0LineLoop
        inc     a
        inc     a
        ld      hl,text_rows
        cp      (hl)
        jp      z,f_cmd_exit
        ;dec    a
        push    af
        call    ansi_del_line
        pop     af
        jr      j0LineLoop                
.no_J_0
        cp      1       ; from (0;0) to cursor
        jr      nz,no_J_1
.is_J1_b
        ; First, from cursor to 0
        ld      a,(ansi_ROW)
        push    af
        ld      a,(ansi_COLUMN)
        push    af
.j1loop
        push    af
        ld      a,32 ;' '        ; BLANK
        call    ansi_CHAR   ; The low level video routine
        pop     af
        dec     a
        ld      (ansi_COLUMN),a
        cp      0
        jp      p,j1loop
        pop     af
        ld      (ansi_COLUMN),a   ; restore orig. cursor pos.
        pop     af
        ld      (ansi_ROW),a   ; restore orig. cursor pos.
        ; Then, from the cursor line - 1 up to 0
        and     a
        jp      z,f_cmd_exit
.j1LineLoop
        dec     a
        push    af
        call    ansi_del_line
        pop     af
        cp      0
        jp      p,j1LineLoop
        jp      f_cmd_exit
.no_J_1
        cp      2       ; entire screen (+home cursor [non-standard])
        jp      nz,f_cmd_exit ;  Syntax Error!

        ; clear all screen
        call    docls
        jp      f_cmd_exit
.no_J


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Erase from start of line %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'o'
        jr z,is_K1_o


;%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% K %%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Erase in line %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'K' ; EL - Erase in line
        jp nz,no_K
        inc     b
        dec     b
        jr      nz,K_nodefault
        ld      hl,param_buffer
        ld      a,0
        ld      (hl),a
;        inc     b  --not useful (1 parameter only)
.K_nodefault
        ld      hl,param_buffer
        ld      a,(hl)
        and     a       ; From cursor to end of line
        jr      nz,no_K_0
        ld      a,(ansi_COLUMN)
        push    af
.K0loop
        push    af
        ld      a,32 ; ' '        ; BLANK
        call    ansi_CHAR   ; The low level video routine
        pop     af
        inc     a
        ld      (ansi_COLUMN),a
        ld      hl,text_cols
        cp      (hl)
        jp      m,K0loop
        pop     af
        ld      (ansi_COLUMN),a   ; restore orig. cursor pos.
.no_K_0
        cp      1       ; From beginning of line to cursor
        jr      nz,no_K_1
.is_K1_o
        ld      a,(ansi_COLUMN)
        push    af
.K1loop
        push    af
        ld      a,32 ;' '        ; BLANK
        call    ansi_CHAR   ; The low level video routine
        pop     af
        dec     a
        ld      (ansi_COLUMN),a
        cp      0
        jp      p,K1loop
        pop     af
        ld      (ansi_COLUMN),a   ; restore orig. cursor pos.
        jp      f_cmd_exit
.no_K_1
        cp      2       ; entire screen (+home cursor [non-standard])
        jp      nz,f_cmd_exit ;  Syntax Error!
        ld      a,(ansi_ROW)
        call    ansi_del_line
        jp      f_cmd_exit
.no_K


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% l %%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Erase current line %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp      'l'
        jr      nz,noecl
        ld      a,(ansi_ROW)
        call    ansi_del_line
        jp      f_cmd_exit
.noecl


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%% n %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Device Status Report %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'n' ; DSR - Device status report
        jp nz,no_n
        inc     b
        dec     b
        jp      z, f_cmd_exit ; only mode 6 is supported
.n_nodefault
        ld      hl,param_buffer
        ld      a,(hl)
        cp      6
        jp      z, f_cmd_exit ; only mode 6 is supported
        call    ansi_DSR6
        jp      f_cmd_exit
.no_n

;%%%%%%%%%%%%%%%%%%%%%%%%%
;%% L %%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Insert Lines %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'L' ; IL - Insert lines
        jr nz,no_L
        ld      hl,param_buffer
        ld      b,(hl)
        ld      a,(ansi_ROW)
        
        jp      f_cmd_exit        
.no_L

;%%%%%%%%%%%%%%%%%%%%%%%%%
;%% M %%%%%%%%%%%%%%%%%%%%
;%%%%%%%% Delete Lines %%%
;%%%%%%%%%%%%%%%%%%%%%%%%%
        cp 'M' ; DL - Delete lines
        jr nz,no_MM
        ld      hl,param_buffer
        ld      a,(hl)
.no_MM

;%% E X I T %%
.f_cmd_exit
        pop de
        pop hl
        jp      f_ANSI_exit


;-----------------------------------------
; Variables declaration
;-----------------------------------------
	SECTION		bss_clib
        PUBLIC    	ansi_COLUMN
        PUBLIC    	ansi_ROW

.ansi_COLUMN    defb    0
.ansi_ROW       defb    0

.scp_x  defb 0
.scp_y  defb 0
.escvector      defw 0
.cur_parm_ptr   defw 0
.eat_key        defb 0
.string_term    defb 0

.param_buffer   defs 40
.param_end      defw 0
