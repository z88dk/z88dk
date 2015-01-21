;       Startup fo SAM Coupe
;
;       Stefano 26/3/2001
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: sam_crt0.asm,v 1.13 2015-01-21 07:05:00 stefano Exp $
;


        MODULE  sam_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this fileb

        EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal

; Integer rnd seed

        PUBLIC    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

        PUBLIC    _vfprintf

; Exit variables

        PUBLIC    exitsp
        PUBLIC    exitcount

       	PUBLIC	heaplast	;Near malloc heap variables
        PUBLIC	heapblocks

; For stdin, stdout, stder

        PUBLIC    __sgoioblk

; Graphics stuff
        PUBLIC    base_graphics
        PUBLIC    coords

; Sound stuff

        PUBLIC    snd_tick
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary

; Now, getting to the real stuff now!



        org     32768


start:
        ld      (start1+1),sp   ;Save entry stack
        ld      hl,-64		;Create the atexit stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and UDG
IF DEFINED_USING_amalloc
		ld	hl,_heap
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		inc bc
		; compact way to do "mallinit()"
		xor	a
		ld	(hl),a
		dec hl
		ld	(hl),a

		;  Stack is somewhere else, no need to reduce the size for malloc
		ld	hl,65535
		sbc hl,bc	; hl = total free memory

		push bc ; main address for malloc area
		push hl	; area size
		EXTERN sbrk_callee
		call	sbrk_callee
ENDIF


IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF

;       Special SAM stuff goes here

        ; Set screen to mode 0
        ld a,0
        call $15A ; JMODE

        ; set stream to channel 's' (upper screen)
        ld a,2
        call $112 ; JSETSTRM

;       End of SAM stuff




        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        EXTERN     closeall
        call    closeall
ENDIF
ENDIF

        pop     bc

;       Special SAM stuff goes here

;       End of SAM stuff



start1:
        ld      sp,0
        ret

l_dcal:
        jp      (hl)

; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


_vfprintf:
IF DEFINED_floatstdio
        EXTERN     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                EXTERN     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        EXTERN     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF

;Seed for integer rand() routines

_std_seed:       defw    0

;Atexit routine

exitsp:
                defw    0
exitcount:
                defb    0

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

; Heap stuff

heaplast:       defw    0
heapblocks:     defw    0

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
                defw    16384
coords:         defw    0

         defm  "Small C+ SAM Coupe"
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
        INCLUDE         "float.asm"

;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0

ENDIF
