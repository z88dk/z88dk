;       CRT0 stub for the Old School Computer Architecture (FLOS)
;
;       Stefano Bodrato - Jul. 2011
;
;
;       EXTRA OPTIONS:
;
;		At C source level:
;       #pragma output osca_bank=(0..14) set the memory bank for locations > 32768 before loading program
;		#pragma output osca_stack=<value> put the stack in a differen place, i.e. 32767
;
;       At compile time:
;		-zorg=<location> parameter permits to specify the program position
;
;	$Id: osca_crt0.asm,v 1.7 2012-02-17 07:51:48 stefano Exp $
;


                MODULE  osca_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        XREF    _main
        XDEF	snd_tick
;
; Some variables which are needed for both app and basic startup
;

        XDEF    cleanup
        XDEF    l_dcal

; Integer rnd seed

        XDEF    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

        XDEF	_vfprintf

;Exit variables

        XDEF    exitsp
        XDEF    exitcount

;For stdin, stdout, stder

        XDEF    __sgoioblk

       	XDEF	heaplast	;Near malloc heap variables
        XDEF	heapblocks

; Graphics stuff
        XDEF	base_graphics
        XDEF	coords

; Now, getting to the real stuff now!

;--------
; Set an origin for the application (-zorg=) default to $5000
;--------

        IF      !myzorg
                defc    myzorg  = $5000
        ENDIF


	IF ((myzorg = $5000) ~ (!DEFINED_osca_bank))
                org		myzorg
	ELSE
				; optional Program Location File Header
				org		myzorg
				defb	$ed
				defb	$00
				jr	start
				defw	myzorg
		IF DEFINED_osca_bank
				defb	osca_bank
		ELSE
				defb    0
		ENDIF
				defb	$00 ; control byte: 1=truncate basing on next 3 bytes
				;defw	0   ; Load length 15:0 only needed if truncate flag is set
				;defb	0	; Load length ..bits 23:16, only needed if truncate flag is set
	ENDIF
	
start:
		;push	hl
		;pop		bc
		ld	b,h
		ld	c,l

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
IF (!DEFINED_osca_stack)
        ld      sp,-64
ELSE
        ld      sp,osca_stack
ENDIF
        ;ld      sp,$7FFF
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


	; Push pointers to argv[n] onto the stack now
	; We must start from the end 
		ld	hl,0	;NULL pointer at end, just in case
		push	hl

		ld	h,b    ; ptr to argument list
		ld	l,c
		ld	b,0    ; parameter counter
		ld	c,b    ; character counter

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
		ld	(hl),0
		inc	hl
		push	hl
		inc	b
		dec	hl
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
;
;       Deallocate memory which has been allocated here!
;
        push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF
        call	$10c4 ; kjt_flos_display (added in v547)
        pop	hl
start1:
        ld  sp,0
        xor a
        or  h	; ATM we are not mamaging the 'spawn' exception
        jr	nz,cmdok
        ld	l,a
cmdok:
        ld  a,l	; return code (lowest byte only)
        and a	; set Z flag to set the eventual error condition
        ;xor a ; (set A and flags for RESULT=OK)
        ret

l_dcal:
        jp      (hl)

; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


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


;Seed for integer rand() routines
_std_seed:       defw    0

;Atexit routine
exitsp:          defw    0
exitcount:       defb    0

; Heap stuff
heaplast:        defw    0
heapblocks:      defw    0

; mem stuff
base_graphics:   defw    $2000
coords:          defw    0
snd_tick:        defb    0

; Signature
         defm  "Small C+ OSCA"
end:
         defb  0

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
        INCLUDE         "float.asm"

;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0

ENDIF

