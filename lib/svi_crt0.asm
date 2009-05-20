;       Spectravideo SVI CRT0 stub
;
;       Stefano Bodrato - Apr. 2001
;
;       $Id: svi_crt0.asm,v 1.7 2009-05-20 06:57:25 stefano Exp $
;


                MODULE  svi_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

	XREF    _main

        XDEF    cleanup
        XDEF    l_dcal

        XDEF    _std_seed

	XDEF	snd_tick	; Sound variable

	XDEF	_vfprintf

        XDEF    exitsp
        XDEF    exitcount

       	XDEF	heaplast	; Near malloc heap variables
	XDEF	heapblocks

        XDEF    __sgoioblk

; Graphics stuff
	XDEF	pixelbyte	; Temp store for non-buffered mode
        XDEF    base_graphics   ; Graphical variables
        XDEF    coords          ; Current xy position

; MSX platform specific stuff
;
        XDEF    msxbios
        ;; XDEF    brksave
        


; Now, getting to the real stuff now!


        org     34816

.start
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

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
	call	$53		; Hide function key menu
        call    _main
	
.cleanup
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

.start1
        ld      sp,0
        ret

.l_dcal
        jp      (hl)

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


; ---------------
; Misc Variables
; ---------------
;;.defltdsk       defb    0	; Default disc
.base_graphics  defw    0	; Location of current screen buffer
.coords         defw    0       ; Current graphics xy coordinates
.pixelbyte	defb	0


IF DEFINED_NEED1bitsound
.snd_tick	defb	0	; Sound variable
ENDIF

;Seed for integer rand() routines
IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
._std_seed       defw    0       ; Seed for integer rand() routines
ENDIF


;Atexit routine

.exitsp
                defw    0
.exitcount
                defb    0

; Heap stuff

.heaplast	defw	0
.heapblocks	defw	0

; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
.msxbios
	push	ix
	ret


; Signature in resulting binary

         defm  "Small C+ SVI"
	 defb	0


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

