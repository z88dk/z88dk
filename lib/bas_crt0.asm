;       Startup stub for z88 BBC BASIC programs
;
;       Created 1/4/99 djm
;
;	$Id: bas_crt0.asm,v 1.5 2007-06-27 20:49:27 dom Exp $


;-----------
; The .def files that we need here
;-----------
	INCLUDE "#bastoken.def"
	INCLUDE "#ctrlchar.def"
	INCLUDE "#error.def"
	INCLUDE "#stdio.def"


        org $2300

;-----------
; Dennis Groning's BASIC file header
;-----------
.bas_first
        DEFB    bas_last - bas_first    ;Line Length
;       DEFW    0                       ;Row Number 0 can not be listed
        DEFW    1
        DEFM    BAS_IF & BAS_PAGE_G & "<>&2300" & BAS_THEN & BAS_NEW
        DEFM    BAS_ELSE & BAS_LOMEM_P & "=&AFFF" & BAS_CALL & BAS_TO & "P" & CR
.bas_last
        DEFB    0
        DEFW    $FFFF           ;End of BASIC program. Next address is TOP.


;-----------
; Code starts executing from here
;-----------
.start
	ld	(start1+1),sp	;Save starting stack
        ld      sp,($1ffe)	;Pick up stack from OZ safe place
        ld      hl,-64		;Make room for the atexit() table
        add     hl,sp
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
        call    _main		;Run the program
.cleanup			;Jump back here from exit() if needed
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall	;Close any open files (fopen)
ENDIF
        call_oz(gn_nln)		;Print a new line
        call    resterrhan	;Restore the original error handler
.start1	ld	sp,0		;Restore stack to entry value
        ret			;Out we go

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

._std_seed       defw    0	; Seed for integer rand() routines

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
		defm	"Small C+ z88"
		defb	0

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

