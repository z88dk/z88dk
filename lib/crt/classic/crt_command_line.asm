; Command line parsing

; Push pointers to argv[n] onto the stack now
; We must start from the end 
; Entry:  hl = end of arguments
;	   c = length of arguments
;	   b = 0
; Exit:	  bc = argc
;         hl = argv

IF CRT_ENABLE_COMMANDLINE = 1
    jr      argv_begin

redir_fopen_flag:		defb	'w',0
redir_fopen_flagr:		defb	'r'
commandline_argv0:		defb	0

argv_begin:
	push    bc
    ld      d,h
    ld      e,l
    inc     de
    push    de
    lddr
	inc    hl
    ld     (hl),' '
    pop     hl
    pop     bc
	inc     c
	
	
    ld      de,0	;NULL pointer at end of array, just in case
    push    de
; Try to find the end of the arguments
argv_loop_1:
    ld      a,(hl)          ;Strip off trailing spaces
    cp      ' '
    jr      nz,argv_loop_2
    ld      (hl),0
    dec     hl
    dec     c
    jr      nz,argv_loop_1
; We've located the end of the last argument, try to find the start
argv_loop_2:
    ld      a,(hl)
    cp      ' '
    jr      nz,argv_loop_3
    inc     hl              ; We're now on the first character of the argument
    inc     c
IF CRT_COMMANDLINE_REDIRECTION = 1
        EXTERN freopen
        
		; This could be useful on those platforms with args possibly 
		; at the very first buffer byte (no leading spaces, etc..)
		; (shouldn't it be replicated for redir_stdin, then?)
		;xor     a
        ;add     b
        ;jr      nz,no_redir_stdout
        ;-----------------------------------
		
		ld      a,(hl)
        cp      '>'
        jr      nz,no_redir_stdout
        push    hl
        inc     hl
        cp      (hl)
        dec     hl
        ld      de,redir_fopen_flag	; "a" or "w"
        jr      nz,noappendb
        ld      a,'a'
        ld      (de),a
        inc     hl
noappendb:
        inc     hl
        	
        push    bc
        push    hl					; file name ptr
        push    de
        ld      de,__sgoioblk+10		; file struct for stdout
        push    de
        call    freopen
        pop     de
        pop     de
        pop     hl
        pop     bc
        pop     hl
        dec     hl
        jr      argv_zloop
no_redir_stdout:
        ld      a,(hl)
        cp      '<'
        jr      nz,no_redir_stdin
        push    hl
        inc     hl
        ld      de,redir_fopen_flagr
        push    bc
        push    hl					; file name ptr
        push    de
        ld      de,__sgoioblk		; file struct for stdin
        push    de
        call    freopen
        pop     de
        pop     de
        pop     hl
        pop     bc
        pop     hl
        dec	    hl
        jr      argv_zloop
no_redir_stdin:
ENDIF
    push    hl
    inc     b
empty_arg:
    dec     hl
    dec     c
; skip extra blanks
argv_zloop:
    ld      (hl),0      ;Terminate the previous argument
    dec     hl          ;Last character of previous argument
;    inc     a		; 'flag'
    dec     c
    jr      z,argv_done
    ld      a,(hl)
    cp      ' '
    jr      z,argv_zloop ;Skip over multiple spaces
    jr      argv_loop_2  ;And do the next argument
    
argv_loop_3:
    dec     hl
    dec     c
    jr      nz,argv_loop_2

;    inc     a		; 'flag'

argv_done:
;    and     a		; 'flag' to discriminate the "no parameter" case
;    jr      z,argv_done_2

    ; We may still have an argument left (if it was at the start of the buffer)

;argv_push_final_arg:
;    ld      a,(hl)              ;Strip leading spaces
;    cp      ' '
;    jr      nz,argv_push_final_arg2
;    inc     hl
;    jr      argv_push_final_arg
;argv_push_final_arg2:
;    pop     de                  ;Is it the same as the last argument we pushed?
;    push    de
;    ld      a,h
;    sub     d
;    jr      nz,argv_push_final_arg3
;    ld      a,l
;    sub     e
;    jr      z,argv_done_2
;argv_push_final_arg3:
    ;ld      a,(hl)
    ;and     a
    ;jr      z,argv_done_2
    ;push    hl
    ;inc     b
;
;argv_done_2:
    ld      hl,commandline_argv0	;name of program (NULL)
    push    hl
    inc     b
    ld      hl,0
    add     hl,sp	;address of argv
    ld      c,b
    ld      b,0
ELSE
    ld      hl,0    ;argv
    ld      b,h     ;argc
    ld      c,l
ENDIF


