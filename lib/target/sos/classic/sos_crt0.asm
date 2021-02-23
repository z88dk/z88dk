;
;       Startup for S-OS (The Sentinel) Japanese OS
;
;       Stefano Bodrato - Winter 2013
;
;       $Id: sos_crt0.asm,v 1.16 2016-07-15 21:38:08 dom Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams - No stdio disc files
;	#pragma output noredir   - do not insert the file redirection option while parsing the
;	                           command line arguments (useless if "nostreams" is set)
;
;	These can cut down the size of the resultant executable

	MODULE  sos_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	EXTERN    _main		;main() is always external to crt0

	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)


        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $3000
        ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -0x1f6a	;;Upper limit of the user area
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE

;        org     $3000-18
;
;
;	defm "_SOS 01 3000 3000"
;	defb $0A
	
;----------------------
; Execution starts here
;----------------------
start:
	ld      (start1+1),sp	;Save entry stack
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	dec	sp	
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


; Push pointers to argv[n] onto the stack now
; We must start from the end 
	ld	hl,0	;NULL pointer at end, just in case
	push	hl
	ld	b,h     ; parameter counter
	ld	c,h     ; character counter

	ld	hl,($1F76)	; #KBFAD

; Program is entered with a 'J' (jump command) at location 3000
; so the command name will be always 3000, we skip eventual balnks,
; so "J3000" and "J  3000" will have the same effect
skipblank:
	inc	hl
	inc	hl
	ld	a,(hl)
	cp	' '
	jr	z,skipblank
	ld	a,(hl)
	and	a
	jr	z,argv_done
	dec	hl
find_end:
	inc	hl
	inc	c
	ld	a,(hl)
	and	a
	jr	nz,find_end
	dec	hl
	; now HL points to the end of command line
	; and C holds the length of args buffer
	ld	b,0
	INCLUDE	"crt/classic/crt_command_line.asm"

        push    hl      ;argv
        push    bc      ;argc
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc


cleanup:
	push	hl		;Save return value
    call    crt0_exit

	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	$1FFA	; HOT boot

l_dcal:	jp	(hl)		;Used for call by function ptr


end:    defb    0               ; null file name

        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"

	SECTION	data_crt
; Default block size for "gendos.lib"
; every single block (up to 36) is written in a separate file
; the bigger RND_BLOCKSIZE, bigger can be the output file size
; but this comes at cost of the malloc'd space for the internal buffer
; Current block size is kept in a control block (just a structure saved
; in a separate file, so changing this value
; at runtime before creating a file is perfectly legal.
	PUBLIC    _RND_BLOCKSIZE;
_RND_BLOCKSIZE:	defw	1000


