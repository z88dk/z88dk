;       Startup for VZ200/300
;
;       Stefano Bodrato - Apr. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: vz_crt0.asm,v 1.14 2013-06-18 06:11:23 stefano Exp $
;



                MODULE  vz_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        XREF    _main           ;main() is always external to crt0 code

        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)


        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

       	XDEF	heaplast	;Near malloc heap variables
       	XDEF	heapblocks

        XDEF    __sgoioblk      ;stdio info block

;Graphic function XDEFS..

        XDEF    coords          ;Current xy position
        XDEF    base_graphics   ;GFX memory related variables
        XDEF    gfx_bank

       	XDEF	snd_tick	;Sound variable

        IF      !myzorg
            IF (startup=3)
				defc    myzorg  = 32768  ; clean binary block
            ELSE
				IF (startup=2)
					defc    myzorg  = $7ae9	; BASIC startup mode
				ELSE
					defc    myzorg  = $7b00  ; Direct M/C mode
                ENDIF
            ENDIF
        ENDIF


; Now, getting to the real stuff now!


		org     myzorg-24

IF (startup=3)
;  STARTUP=3 -> plain binary block

ELSE

  defb  $20,$20,0,0
  defm  "z80.mc"
  defb  0,0,0,0,0,0,0,0,0,0,0
  
IF (startup=2)
  ; BASIC startup mode
  defb $f0
ELSE
  ; native M/C startup mode
  defb $f1
ENDIF

  defw myzorg

IF (startup=2)
  defw $7b04
  defw 1
  defb $B1              ;POKE
  defm " 30862,18:"
  defb $B1              ;POKE
  defm " 30863,123"
  defb 0                ; this block is 27 bytes long
  
  defw $7b0f
  defw 2
  defb $b2              ; PRINT
  defb ' '
  defb $c1              ; USR
  defm "(0)"
  defb 0                ; this block is 11 bytes long
  
  defw 0
  defb 4
  
; Header ends here: 65 bytes
ENDIF

ENDIF

start:

	ld	hl,-64		; 32 pointers (ANSI standard)
	add	hl,sp
	ld	sp,hl
	ld	(exitsp),sp

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

        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        LIB     closeall
        call    closeall
ENDIF
ENDIF
        pop     bc
start1:
        ld      sp,0
        jp      1A19h

l_dcal:
        jp      (hl)

;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;---------------------------------
; Select which printf core we want
;---------------------------------

_vfprintf:
IF DEFINED_floatstdio
        LIB     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                LIB     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        LIB     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF


;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map
gfx_bank:       defb    0

IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack

heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

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

IF DEFINED_NEED1bitsound
snd_tick:	defb	0	; Sound variable
ENDIF

         defm  "Small C+ VZ"
         defb   0

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

