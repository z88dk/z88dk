;
;       Startup for relocatable machine code routines
;
;       A first attempt at it, this is completely untested
;       This should also be able to be used for non relocatable
;       Routines - eg that are loaded at fixed point in BBC BASIC
;       memory
;
;       18/5/99 djm


;
; If we have an org address, use it, if we're relocating it's ignored
; in anycase..default to 16384 (which is as good as any...)


       
        IF      DEFINED_myzorg
                org myzorg
        ELSE
                org 16384
        ENDIF

; Now we have the startup code - extremely similar to that for BBC
; BASIC (I'm lazy and it works so...)


                INCLUDE "#error.def"
                INCLUDE "#stdio.def"


.start
        ld      hl,0
        add     hl,sp
        ld      sp,($1ffe)
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
        call    doerrhan
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
        call    _main
.cleanup
;
;       Deallocate memory which has been allocated here!
;
	push	hl	;preserve return value
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
        call    resterrhan
	pop	hl
	exx
	ld	hl,0
.start1
        ld      sp,0
        ret		;exit with hl=0 hl' = our exit value

;Install an error handler, very simple, but prevents lot so problems

.doerrhan
        xor     a
        ld      (exitcount),a
        ld      b,0
        ld      hl,errhand
        call_oz(os_erh)
        ld      (l_erraddr),hl
        ld      (l_errlevel),a
        ret

;Restore BASICs error handler

.resterrhan
        ld      hl,(l_erraddr)
        ld      a,(l_errlevel)
        ld      b,0
        call_oz(os_erh)
; Tag on the process cmd here it's not relevent at all, but return 0
; just in case
.processcmd
        ld      hl,0
        ret

;The laughable error handler itself!
.errhand
        ret     z       ;fatal
        cp      rc_esc
        jr     z,errescpressed
;Pass everything else to BASICs error handler
        ld      hl,(l_erraddr)
        scf
;Save a byte here, byte there! This has label because it's used for
;calculated calls etc
.l_dcal
        jp      (hl)

;Escape pressed, treat as cntl+c so quit out (bit crude, but there you go!)


.errescpressed
        call_oz(os_esc)
        jr      cleanup


; Now, define some values for stdin, stdout, stderr

.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


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

; Dummy again
._cpfar2near
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret

;Just making me life harder! These will vanish for App startup!

.l_erraddr
        defw    0
.l_errlevel
        defb    0


.coords         defw      0
.base_graphics  defw      0
.gfx_bank       defb    0

;Seed for integer rand() routines

.int_seed       defw    0

;Atexit routine

.exitsp
                defw    0
.exitcount
                defb    0

; malloc gunk

.heaplast
		defw	0
.heapblocks
		defw	0

.packintrout
		defw	0

         defm  "Small C+ z88"&0

; Include the floating point package..if we need it!

IF NEED_floatpack
        INCLUDE         "#float.asm"

;seed for random number generator - not used yet..
.fp_seed        defb    $80,$80,0,0,0,0
;Floating point registers...
.extra          defs    6
.fa             defs    6
.fasign         defb    0

ENDIF

