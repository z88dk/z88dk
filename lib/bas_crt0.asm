; 
;       Startup code for BBC BASIC programs
;
;       Created 1/4/99 djm


                INCLUDE "#bastoken.def"
                INCLUDE "#ctrlchar.def"
                INCLUDE "#error.def"
                INCLUDE "#stdio.def"


; Dennis' snippet to create a BASIC program straight off!
; No need for a little boot program as well, this needed mods to the
; code as well - one line in cc6.c

        org $2300


.bas_first
        DEFB    bas_last - bas_first    ;Line Length
;       DEFW    0                       ;Row Number 0 can not be listed
        DEFW    1
        DEFM    BAS_IF & BAS_PAGE_G & "<>&2300" & BAS_THEN & BAS_NEW
        DEFM    BAS_ELSE & BAS_LOMEM_P & "=&AFFF" & BAS_CALL & BAS_TO & "P" & CR
.bas_last
        DEFB    0
        DEFW    $FFFF           ;End of BASIC program. Next address is TOP.


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
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
        call_oz(gn_nln)
        call    resterrhan
.start1
        ld      sp,0
        ret

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


; We can't use far stuff with BASIC cos of paging issues so
; We assume all data is in fact near, so this is a dummy fn
; really

._cpfar2near
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret






; Now, define some values for stdin, stdout, stderr
;
; This allows us two models of stdio - the classic z88dk one
; (kludgey) or the newer (slightly less kludgey)

.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



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

; Heap stuff

.heaplast	defw	0
.heapblocks	defw 	0

; Interrupt routine
.packintrout
		defw	0

         defm  "Small C+ z88"&0

;All the float stuff is kept in a different file...for ease of altering!
;It will eventually be integrated into the library
;
;Here we have a minor (minor!) problem, we've no idea if we need the
;float package if this is separated from main (we had this problem before
;but it wasn't critical..so, now we will have to read in a file from
;the directory (this will be produced by zcc) which tells us if we need
;the floatpackage, and if so what it is..kludgey, but it might just work!
;
;Brainwave time! The zcc_opt file could actually be written by the
;compiler as it goes through the modules, appending as necessary - this
;way we only include the package if we *really* need it!

IF NEED_floatpack
        INCLUDE         "#float.asm"

;seed for random number generator - not used yet..
.fp_seed        defb    $80,$80,0,0,0,0
;Floating point registers...
.extra          defs    6
.fa             defs    6
.fasign         defb    0

ENDIF

