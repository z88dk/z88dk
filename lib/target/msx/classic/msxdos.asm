        


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	INCLUDE "crt/classic/crt_rules.inc"

	IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE = $100   ; MSXDOS
        ENDIF

	IF !DEFINED_MSXDOS
		defc MSXDOS = 5
	ENDIF
	PUBLIC MSXDOS


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
	call	crt0_init_bss
        ld      (exitsp),sp

	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

	; Handle command line arguments
	;ld	c,25		;Save the default disc
	;call	5
	ld	a,($F306)
	ld	(defltdsk),a

	ld	hl,$80
        ld      a,(hl)
        ld      b,0
        and     a
        jr      z,argv_done
        ld      c,a
	inc	hl
        add     hl,bc   ;now points to the end of the command line
	INCLUDE	"crt/classic/crt_command_line.asm"

        push    hl      ;argv
        push    bc      ;argc
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

    call    crt0_exit


start1:
	ld	sp,0
	jp	0

l_dcal:
        jp      (hl)

end:	defb	0

	INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

        SECTION         bss_crt

        PUBLIC  brksave
        PUBLIC  defltdsk
brksave:        defb    1
defltdsk:       defb    0       ; Default disc
IF !DEFINED_nofileio
        PUBLIC  __fcb
__fcb:          defs    420,0   ;file control block (10 files) (MAXFILE)
ENDIF

        SECTION rodata_clib

IF !DEFINED_noredir
IF CRT_ENABLE_STDIO = 1
redir_fopen_flag:       defb    'w',0
redir_fopen_flagr:      defb    'r',0
ENDIF
ENDIF
