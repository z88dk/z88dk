;
;       Startup stub for z88 Shell programs
;
;       Created 12/2/2002 djm
;
;	$Id: z88s_crt0.asm,v 1.2 2002-02-20 21:44:20 dom Exp $



	INCLUDE	"#stdio.def"
	INCLUDE "#error.def"

	
	defc    cmdaddr = $20F5
        defc    cmdlen = $20F3
        defc    cmdptr = $20F7
        defc    next = $F886

        defc	myzorg = $2A71-12

	org	myzorg
.header_start
        defm    "!bin020"&13
.shell_length
        defw    0		; Fill in by make program
        defw    start



;-----------
; Code starts executing from here
;-----------
.start
	push	bc		; Preserve registers that need to be
	push	de	
	push	ix
	push	iy
	ld	(start1+1),sp	;Save starting stack
	ld	hl,(cmdlen)
	ld	de,(cmdaddr)
	add	hl,de
	ld	(hl),0		; terminate command line
	ld	hl,-100		; atexit stack (64) + argv space
	add	hl,sp
        ld      sp,hl
        ld      (exitsp),sp	
        call    doerrhan	;Initialise a laughable error handler

		
;-----------
; Initialise the (ANSI) stdio descriptors so we can be called agin
;-----------
IF DEFINED_ANSIstdio
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
	;; Read in argc/argv
	ld	hl,0		; NULL pointer at end just in case
	push	hl
	;; Try and work out the length available
	ld	hl,(cmdlen)
	ld	de,(cmdaddr)
	add	hl,de		; points to end
	ex	de,hl		; end now in de, hl=cmdaddr
	ld	bc,(cmdptr)
	add	hl,bc		; start in hl
	push	de		; save end
	ex	de,hl		; hl = end, de = start
	and	a
	sbc	hl,de		; hl is length available
	ex	de,hl		; is now in de
	pop	hl		; points to terminator
	ld	c,0		; number of arguments
	ld	a,d
	or	e
	jr	z,argv_none
	dec	hl
	dec	de		; available length
.argv_loop
	ld	a,d
	or	e
	jr	z,argv_exit
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop2
	ld	(hl),0		; terminate previous one
	inc	hl
	inc	c
	push	hl
	dec	hl
.argv_loop2
	dec	hl
	dec	de
	jr	argv_loop
.argv_exit
	push	hl		; first real argument
	inc	c
.argv_none
	ld	hl,end		; program name
	inc	c
	push	hl		
	ld	hl,0
	add	hl,sp		; address of argv
	ld	b,0
	push	bc		; argc
	push	hl		; argv
	ld	hl,(cmdlen)
	ld	(cmdptr),hl
	call_oz(gn_nln)		; Start a new line...
        call    _main		;Run the program

	pop	bc		; kill argv
	pop	bc		; kill argc
	
.cleanup			;Jump back here from exit() if needed
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall	;Close any open files (fopen)
ENDIF
        call    resterrhan	;Restore the original error handler
	
.start1	ld	sp,0		;Restore stack to entry value
	pop	iy		; Get back those registers
	pop	ix
	pop	de
	pop	bc
	jp	next		; out we go

;-----------
; Install the error handler
;-----------
.doerrhan
        xor     a
        ld      (exitcount),a
        ld      b,0
        ld      hl,errhand
        call_oz(os_erh)
        ld      (l_erraddr),hl
        ld      (l_errlevel),a
        ret

;-----------
; Restore BASICs error handler
;-----------
.resterrhan
        ld      hl,(l_erraddr)
        ld      a,(l_errlevel)
        ld      b,0
        call_oz(os_erh)
.processcmd			;processcmd is called after os_tin
        ld      hl,0
        ret


;-----------
; The error handler
;-----------
.errhand
        ret     z   		;Fatal error
        cp      rc_esc
        jr     z,errescpressed
        ld      hl,(l_erraddr)	;Pass everything to BASIC's handler
        scf
.l_dcal	jp	(hl)		;Used for function pointer calls also

.errescpressed
        call_oz(os_esc)		;Acknowledge escape pressed
        jr      cleanup		;Exit the program


;-----------
; Select which vfprintf routine is needed
;-----------
._vfprintf
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


; We can't use far stuff with BASIC cos of paging issues so
; We assume all data is in fact near, so this is a dummy fn
; really

;-----------
; Far stuff can't be used with BASIC because of paging issues, so we assume
; that all data is near - this function is in fact a dummy and just adjusts
; the stack as required
;-----------
._cpfar2near
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret





;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;-----------
; Now some variables
;-----------
.l_erraddr	defw	0	; BASIC error handler address
.l_errlevel	defb	0	; And error level


.coords         defw	0	; Current graphics xy coordinates
.base_graphics  defw	0	; Address of the Graphics map
.gfx_bank       defb    0	; And the bank

.int_seed       defw    0	; Seed for integer rand() routines

.exitsp		defw	0	; Address of where the atexit() stack is
.exitcount	defb	0	; How many routines on the atexit() stack

IF DEFINED_NEED1bitsound
.snd_asave      defb    0	; Sound variable
.snd_tick       defb    0	;  "      "
ENDIF


.heaplast	defw	0	; Address of last block on heap
.heapblocks	defw 	0	; Number of blocks

.packintrout	defw	0	; Address of user interrupt routine


;-----------
; Unnecessary file signature
;-----------
		defm	"Small C+ z88shell"
.end		defb	0

;-----------
; Floating point
;-----------
IF NEED_floatpack
        INCLUDE         "#float.asm"

.fp_seed        defb    $80,$80,0,0,0,0	; FP seed (unused ATM)
.extra          defs    6		; Extra register temp store
.fa             defs    6		; ""
.fasign         defb    0		; ""

ENDIF

