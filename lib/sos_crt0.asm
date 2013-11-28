;
;       Startup for S-OS (The Sentinel) Japanese OS
;
;       Stefano Bodrato - Winter 2013
;
;       $Id: sos_crt0.asm,v 1.3 2013-11-28 15:33:52 stefano Exp $
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

	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	XREF    _main		;main() is always external to crt0

	XDEF    cleanup		;jp'd to by exit()
	XDEF    l_dcal		;jp(hl)

	XDEF	_vfprintf	;jp to printf core routine

	XDEF    exitsp		;atexit() variables
	XDEF    exitcount

	XDEF    heaplast        ;Near malloc heap variables
	XDEF    heapblocks      ;

	XDEF    __sgoioblk	;std* control block


;-----------------------
; Target specific labels
;-----------------------

	XDEF	snd_tick	; for sound code, if any
	XDEF	bit_irqstatus	; current irq status when DI is necessary

        IF      !myzorg
                defc    myzorg  = $3000
        ENDIF


        org     myzorg

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
	;ld	a,($80)		;byte count of length of args
	;inc	a		;we can use this since args are space separated
	;neg
	;ld	l,a
	;ld	h,-1		;negative number
	;ld      de,-64		;Add on space for atexit() stack
	;add	hl,de
	;add     hl,sp
	;ld      sp,hl
	;ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "amalloc.def"
ENDIF

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
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
	inc hl
	inc hl
	ld	a,(hl)
	cp  ' '
	jr	z,skipblank

	ld	a,(hl)
	and	a
	jr	z,argv_done

	dec hl
find_end:
	inc	hl
	inc c
	ld	a,(hl)
	and	a
	jr	nz,find_end
	dec hl
	; now HL points to the end of command line
	; and C holds the length of args buffer
	
;	ld	b,0
;	and	a
;	jr	z,argv_done
;	ld	c,a
;	add	hl,bc	;now points to the end
; Try to find the end of the arguments
argv_loop_1:
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_2
	ld	(hl),0
	dec	hl
	dec	c
	jr	nz,argv_loop_1
; We've located the end of the last argument, try to find the start
argv_loop_2:
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_3
	;ld	(hl),0
	inc	hl

IF !DEFINED_noredir
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio

		LIB freopen
		xor a
		add b
		jr	nz,no_redir_stdout
		ld	a,(hl)
		cp  '>'
		jr	nz,no_redir_stdout
		push hl
		inc hl
		cp  (hl)
		dec hl
		ld	de,redir_fopen_flag	; "a" or "w"
		jr	nz,noappendb
		ld	a,'a'
		ld	(de),a
		inc hl
noappendb:
		inc hl
		
		push bc
		push hl					; file name ptr
		push de
		ld	de,__sgoioblk+4		; file struct for stdout
		push de
		call freopen
		pop de
		pop de
		pop hl
		pop bc

		pop hl
		
		dec hl
		jr	argv_zloop
no_redir_stdout:

		ld	a,(hl)
		cp  '<'
		jr	nz,no_redir_stdin
		push hl
		inc hl
		ld	de,redir_fopen_flagr
		
		push bc
		push hl					; file name ptr
		push de
		ld	de,__sgoioblk		; file struct for stdin
		push de
		call freopen
		pop de
		pop de
		pop hl
		pop bc

		pop hl
		
		dec hl
		jr	argv_zloop
no_redir_stdin:

ENDIF
ENDIF
ENDIF

	push	hl
	inc	b
	dec	hl

; skip extra blanks
argv_zloop:
	ld	(hl),0
	dec	c
	jr	z,argv_done
	dec	hl
	ld	a,(hl)
	cp	' '
	jr	z,argv_zloop
	inc c
	inc hl

argv_loop_3:
	dec	hl
	dec	c
	jr	nz,argv_loop_2

argv_done:
	ld	hl,end	;name of program (NULL)
	push	hl
	inc	b
	ld	hl,0
	add	hl,sp	;address of argv
	ld	c,b
	ld	b,0
	push	bc	;argc
	push	hl	;argv
        call    _main		;Call user code
	pop	bc	;kill argv
	pop	bc	;kill argc


cleanup:
	push	hl		;Save return value
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall	;Close any opened files
	call	closeall
ENDIF
ENDIF
	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	$1FFA	; HOT boot

l_dcal:	jp	(hl)		;Used for call by function ptr

;------------------------
; The stdio control block
;------------------------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10	;Dummy values
ENDIF


;----------------------------------------
; Work out which vfprintf routine we need
;----------------------------------------
_vfprintf:
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF


;-----------------------
; Some startup variables
;-----------------------

exitsp:		defw	0	;Address of atexit() stack
exitcount:	defb	0	;Number of atexit() routinens
heaplast:	defw	0	;Pointer to last free heap block
heapblocks:	defw	0	;Number of heap blocks available

IF DEFINED_USING_amalloc
XREF ASMTAIL
XDEF _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
	defw ASMTAIL	; Location of the last program byte
	defw 0
ENDIF


IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:       defw    0      ; Seed for integer rand() routines
ENDIF

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;-----------------------------------------------------
; Unneccessary file signature + target specific stuff
;-----------------------------------------------------
end:		defb	0		; null file name


;----------------------------------------------
; Floating point support routines and variables
;----------------------------------------------
IF NEED_floatpack
        INCLUDE         "float.asm"

fp_seed:        defb    $80,$80,0,0,0,0	; FP seed (unused ATM)
extra:          defs    6		; FP spare register
fa:             defs    6		; FP accumulator
fasign:         defb    0		; FP variable

ENDIF

IF !DEFINED_noredir
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
redir_fopen_flag:
				defb 'w'
				defb 0
redir_fopen_flagr:
				defb 'r'
				defb 0
ENDIF
ENDIF
ENDIF

