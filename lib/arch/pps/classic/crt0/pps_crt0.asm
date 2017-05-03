;       Kludgey startup for Peters Plus Sprinter
;
;       djm 18/5/99
;
;       $Id: pps_crt0.asm,v 1.20 2016-07-15 21:38:08 dom Exp $
;



                MODULE  pps_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)



        org     $8100 - 512

	defw	$5845		;EXE signature
	defb	$45		;Reserved (EXE type)
	defb	$00		;Version of EXE file
	defq	512		;Offset to code
	defw	0		;Primary loader size or 0 (no primary loader)
	defq	0		;Reserved
	defw	0		;Reserved
	defw	start		;Loading address
	defw	start		;Starting address
	defw	$bfff		;Stack
	defs	490		;Reserved space


start:
        ld      (start1+1),sp	;Save entry stack
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF

	ld	(start_prefix),ix

	ld	de,0
	ld	hl,$2350
	ld	b,7
	ld	a,' '
	ld	c,$56		;CLEAR
	rst	$10
; Work out argc/argv - same as the CPM version 
	ld	hl,0		; NULL pointer at the end
	push	hl
	ld	b,0		;arguments
	ld	hl,(start_prefix)
	ld	a,(hl)		;length of arguments
	and	a
	jr	z,argv_done
	ld	c,a
	add	hl,bc		;now points to end of arguments

	INCLUDE	"crt0_command_line.asm"

        push    hl      ;argv
        push    bc      ;argc
        call    _main           ;Call user code
        pop     bc      ;kill argv
        pop     bc      ;kill argc
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl	;save return code
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF
	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	ld	bc,$41		;exit with - error code
	rst	$10
        ret

l_dcal:	jp	(hl)		;Used for function pointer calls




	defm	"Small C+ PPS"	;Unnecessary file signature
end:	defb	0

        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE "crt0_section.asm"
	
	SECTION  bss_crt

start_prefix:   defw	0	; Entry handle from OS

	SECTION	rodata_clib
IF !DEFINED_noredir
IF !DEFINED_nostreams
redir_fopen_flag:               defb 'w',0
redir_fopen_flagr:              defb 'r',0
ENDIF
ENDIF


