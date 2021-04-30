        


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE = $100   ; MSXDOS
    ENDIF

    ; For MSXDOS 1 limit the number of open files to 3 to reduce memory usage
    ; This can be overridden with -pragma-define:CLIB_OPEN_MAX=NN where NN
    ; is your chosen number
    IF CLIB_MSXDOS = 1
        IF !DEFINED_CLIB_OPEN_MAX
            defc    DEFINED_CLIB_OPEN_MAX = 1
            defc    CLIB_OPEN_MAX = 3
        ENDIF
    ENDIF

    IF !DEFINED_MSXDOS
        defc MSXDOS = 5
    ENDIF
    PUBLIC MSXDOS
    
    INCLUDE "crt/classic/crt_rules.inc"


    org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, it survived up to here !
	defb	$b4,$09		;DOS protection... MOV AH,9 (Err msg for MS-DOS)
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for MSXDOS."
	defb	13,10,'$'

begin:
ENDIF

    ld      (start1+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ld      a,($F306)
    ld      (defltdsk),a

IF CRT_ENABLE_COMMANDLINE = 1
    ld      hl,$80
    ld      a,(hl)
    ld      b,0
    and     a
    jr      z,argv_done
    ld      c,a
    inc     hl
    add     hl,bc   ;now points to the end of the command line
    INCLUDE	"crt/classic/crt_command_line.asm"
    push    hl	;argv
    push    bc	;argc
ELSE
    ld      hl,0
    push    hl  ;argv
    push    hl  ;argc
ENDIF
    call    _main		;Call user code
    pop     bc	;kill argv
    pop     bc	;kill argc

cleanup:
    call    crt0_exit
start1:
    ld      sp,0
    jp      0

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"
IF CLIB_MSXDOS = 1
    INCLUDE "crt/classic/crt_cpm_fcntl.asm"
ENDIF

    SECTION bss_crt

    PUBLIC  brksave
brksave:    defb    1

