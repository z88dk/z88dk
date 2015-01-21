;       CRT0 stub for the Jupiter ACE
;
;       Stefano Bodrato - Feb 2001
;
;	$Id: ace_crt0.asm,v 1.14 2015-01-21 07:05:00 stefano Exp $
;


                MODULE  ace_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        EXTERN    _main

		PUBLIC	snd_tick
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary
;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal

; Integer rnd seed

        PUBLIC    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

        PUBLIC	_vfprintf

;Exit variables

        PUBLIC    exitsp
        PUBLIC    exitcount

;For stdin, stdout, stder

        PUBLIC    __sgoioblk

       	PUBLIC	heaplast	;Near malloc heap variables
       	PUBLIC	heapblocks

; Graphics stuff
       	PUBLIC	base_graphics
       	PUBLIC	coords

; Now, getting to the real stuff now!

;--------
; Set an origin for the application (-zorg=) default to $4000
;--------

        IF      !myzorg
            IF (startup=2)                 ; ROM ?
                defc    myzorg  = 0
            ELSE
                defc    myzorg  = $4000
            ENDIF
        ENDIF


        org     myzorg

start:
IF (startup=2)
		;  ROM mode BOOT
		di
		ld		hl,$3c00	; RAM starts at $4000
		ld		a,$fc
ace_ramtest:
		inc		h			; step to a higher RAM block
		ld		(hl),a		; probe it
		cp		(hl)
		jr		z,ace_ramtest
		and		h
		ld		h,a			; use $fc to mask to the lower 1k boundary
		ld		sp,hl
ELSE
		;  set stack if in RAM mode
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
ENDIF
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

IF (startup=2)
		ld    hl,$2c00		; character set RAM
		; init the first 256 bytes with gfx blocks
gfx_bloop:
		ld    a,l
		and   $bf
		rrca
		rrca
		rrca
		jr    nc,nobit2
		rrca
		rrca

nobit2: rrca
		ld   b,a
		sbc  a,a		; 0 or $FF
		rr   b
		ld   b,a
		sbc  a,a
		xor  b
		and  $f0
		xor  b
		ld   (hl),a
		inc  l
		jr   nz,gfx_bloop

		; a bit of cleanup (we should load a font, here!)
		xor  a
blankloop:
		ld   (hl),a
		inc  hl
		cp   l
		jr nz,blankloop
		
		ld   h,$24
		ld   (base_graphics),hl

		EXTERN  cleargraphics
		call cleargraphics

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
        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF
	pop	bc
start1:
        ld      sp,0
IF (startup=2)
		di
		halt
ELSE
	jp (iy)		; To the Jupiter ACE FORTH system
ENDIF

l_dcal:
        jp      (hl)


; Now, which of the vfprintf routines do we need?
_vfprintf:
IF DEFINED_floatstdio
	EXTERN	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		EXTERN	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			EXTERN	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF

;---------------------------------------------------------------------------
IF (startup=2) | (startup=3) ; ROM or moved system variables
;---------------------------------------------------------------------------

        PUBLIC    romsvc		; service space for ROM

IF !DEFINED_HAVESEED
      PUBLIC    _std_seed         ; Integer rand() seed
ENDIF


IF !DEFINED_sysdefvarsaddr
      defc sysdefvarsaddr = $2800-80   ; Close to the end of "PAD", the Forth interpreter workspace
ENDIF

IF NEED_floatpack
      INCLUDE   "float.asm"
ENDIF

IF DEFINED_ANSIstdio
      INCLUDE   "stdio_fp.asm"
ENDIF

DEFVARS sysdefvarsaddr
{
__sgoioblk      ds.b    40      ; stdio control block
coords          ds.w    1       ; Graphics xy coordinates
base_graphics   ds.w    1       ; Address of graphics map
IF !DEFINED_HAVESEED
  _std_seed     ds.w    1       ; Integer seed
ENDIF
exitsp          ds.w    1       ; atexit() stack
exitcount       ds.b    1       ; Number of atexit() routines
fp_seed         ds.w    3       ; Floating point seed (not used ATM)
extra           ds.w    3       ; Floating point spare register
fa              ds.w    3       ; Floating point accumulator
fasign          ds.b    1       ; Floating point variable
snd_tick        ds.b    1       ; Sound
bit_irqstatus   ds.w    1       ; used to save the current IRQ status
heaplast        ds.w    1       ; Address of last block on heap
heapblocks      ds.w    1       ; Number of blocks
romsvc          ds.b	1	; Pointer to the end of the sysdefvars
				; used by the ROM version of some library
}


IF !DEFINED_defvarsaddr
        defc defvarsaddr = 24576
ENDIF

DEFVARS defvarsaddr
{
dummydummy        ds.b    1 
}


;---------------------------------------------------------------------------
ELSE
;---------------------------------------------------------------------------



;Seed for integer rand() routines

_std_seed:      defw    0

;Atexit routine

exitsp:
                defw    0
exitcount:
                defb    0

; Heap stuff

heaplast:	defw	0
heapblocks:	defw	0

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

; mem stuff

base_graphics:
		defw	$2400
coords:		defw	0

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF


; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


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

;---------------------------------------------------------------------------
ENDIF
;---------------------------------------------------------------------------

	defm  "Small C+ J.ACE"
	defb  0
