;       MSX C stub
;
;       Stefano Bodrato - Apr. 2001
;
;	$Id: msx_crt0.asm,v 1.34 2015-01-21 07:05:00 stefano Exp $
;

; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams      - No stdio disc files
;	#pragma output nofileio       - No fileio at all
;	#pragma output noprotectmsdos - strip the MS-DOS protection header
;
;	These can cut down the size of the resultant executable

                MODULE  msx_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"


;===============================================================================
IF startup != 3
;===============================================================================


;--------
; Some scope definitions
;--------

	EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal

        PUBLIC    _std_seed

        PUBLIC	snd_tick	; Sound variable
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary

        PUBLIC	_vfprintf

        PUBLIC    exitsp
        PUBLIC    exitcount

       	PUBLIC	heaplast	; Near malloc heap variables
        PUBLIC	heapblocks

        PUBLIC    __sgoioblk

; Graphics stuff
        PUBLIC	pixelbyte	; Temp store for non-buffered mode
        PUBLIC    base_graphics   ; Graphical variables
        PUBLIC    coords          ; Current xy position

; MSX platform specific stuff
;
        PUBLIC    msxbios
        PUBLIC    brksave


; Now, getting to the real stuff now!

IF (!DEFINED_startup | (startup=1))
        IF      !myzorg
                defc    myzorg  = 40000
        ENDIF
                org     myzorg
ELSE
	PUBLIC	__fcb		; file control block
        org     $100		; MSXDOS
ENDIF

;----------------------
; Execution starts here
;----------------------
start:

IF (startup=2)
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, it survived up to here !
	defb	$b4,$09		;DOS protection... MOV AH,9 (Err msg for MS-DOS)
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for MSXDOS."
	defb	13,10,'$'

begin:
ENDIF
ENDIF

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

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

; ** IF MSXDOS mode, handle argv, argc... **
IF (startup=2)
	;ld	c,25		;Save the default disc
	;call	5
	ld	a,($F306)
	ld	(defltdsk),a

; Push pointers to argv[n] onto the stack now
; We must start from the end 
	ld	hl,0	;NULL pointer at end, just in case
	push	hl
	ld	hl,$80
	ld	a,(hl)
	ld	b,0
	and	a
	jr	z,argv_done
	ld	c,a
	add	hl,bc	;now points to the end
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

		EXTERN freopen
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

	ld	a,(defltdsk)	;Restore default disc
	ld	($F306),a
	;ld	e,a
	;ld	c,14
	;call	5
ELSE
;** If NOT MSXDOS mode, just get rid of BASIC screen behaviour **
	ld	ix,$CC	; Hide function key strings
	call	msxbios
        call    _main
ENDIF
	ld	ix,$d2	; TOTEXT - force text mode on exit
	call	msxbios
;**
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

start1:
        ld      sp,0
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

; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
	ld	iy,($FCC0)	; slot address of BIOS ROM
	call	001Ch		; CALSLT
	ei			; make sure interrupts are enabled
	ret

; Keeping the BREAK status
brksave:	defb	1


; ---------------
; Misc Variables
; ---------------
defltdsk:       defb    0	; Default disc
base_graphics:  defw    0	; Location of current screen buffer
coords:         defw    0       ; Current graphics xy coordinates
pixelbyte:      defb	0


IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;Seed for integer rand() routines
IF !DEFINED_HAVESEED
		PUBLIC    _std_seed        ;Integer rand() seed
_std_seed:       defw    0       ; Seed for integer rand() routines
ENDIF

IF (startup=2)
  IF !DEFINED_nofileio
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
  ENDIF
ENDIF

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

         defm  "Small C+ MSX"
end:	 defb	0

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

IF (startup=2)
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
ENDIF 



;===============================================================================
ELSE
;===============================================================================

; startup == 3
; msx cartridge rom

; April 2014
; submitted by Timmy

; For cartridge I am not sure what facilities are available from the MSX
; system, if any.  So this CRT only provides the bare minimum.

;
;  Declarations
;

	EXTERN _main		; main() entrance point
	PUBLIC	l_dcal	; jp(hl) instruction
	PUBLIC cleanup

;
;  Main Code Entrance Point
;

    defc  myzorg  = $4000
	org   myzorg

; ROM header

	defb $41,$42,$10,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	jp start

defm  "wai's msx rom"

start:
	di
	ld sp, ($FC4A)
	ei

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

; port fixing; required for ROMs

	in a,($A8)
	and a, $CF
	ld d,a
	in a,($A8)
	and a, $0C
	add a,a
	add a,a
	or d
	out ($A8),a

; init fp seed

	ld hl, $8080
	ld (fp_seed),hl

; init int seed

        ld hl,1
        ld (_std_seed),hl

; init heap

        ld hl,0
        ld (_heap),hl
        ld (_heap+2),hl
        
IF (HEAPSIZE > 4)
        
        ld hl,_heap_area
        ld bc,HEAPSIZE
        ld de,_heap
        
        EXTERN HeapSbrk_callee
        EXTERN ASMDISP_HEAPSBRK_CALLEE
        
        call HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE
ELSE
	defc HEAPSIZE = 4
ENDIF

; call main now

	call _main

; end program

cleanup:
endloop:
	di
	halt
	jr endloop


l_dcal:	jp	(hl)		;Used for call by function pointer


PUBLIC __sgoioblk
PUBLIC coords
PUBLIC base_graphics
PUBLIC pixelbyte
PUBLIC _std_seed
PUBLIC exitsp
PUBLIC exitcount
PUBLIC fp_seed
PUBLIC extra
PUBLIC fa
PUBLIC fasign
PUBLIC heaplast
PUBLIC heapblocks
PUBLIC _heap
PUBLIC _heap_area
PUBLIC brksave
PUBLIC snd_tick
PUBLIC bit_irqstatus
PUBLIC CRT_AVAILABLE_MEMORY

PUBLIC _vfprintf
PUBLIC msxbios

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


; Safe BIOS call
msxbios:
	ld	iy,($FCC0)	; slot address of BIOS ROM
	call	001Ch		; CALSLT
	ei			; make sure interrupts are enabled
	ret

IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

IF !DEFINED_sysdefvarsaddr
      defc sysdefvarsaddr =  $C000   ; Static variables are kept in RAM in high memory
ENDIF

DEFVARS sysdefvarsaddr
{

__sgoioblk      ds.b    40  ; stdio control block

coords          ds.w	1	; Current graphics xy coordinates
base_graphics   ds.w	1	; Location of current screen buffer
pixelbyte       ds.b	1
_std_seed       ds.w    1	; Integer seed
exitsp          ds.w    1	; Address of where the atexit() stack is
exitcount       ds.b    1	; Number of atexit() routines

fp_seed         ds.w	3	; Floating point seed, unused ATM
extra           ds.w	3	; Floating point temp variable
fa              ds.w	3	; Floating point accumulator
fasign          ds.b	1	; Floating point temp store


heaplast        ds.w    1	; Address of last block on heap
heapblocks      ds.w    1	; Number of blocks
_heap           ds.l    1	      ; process heap pointer
_heap_area      ds.b    HEAPSIZE  ; initial heap

brksave         ds.b	1   ; Keeping the BREAK status
;defltdsk        ds.b	1	; Default disc

;IF DEFINED_NEED1bitsound
snd_tick        ds.b	1	; Sound variable
bit_irqstatus 	ds.w	1
;ENDIF


CRT_AVAILABLE_MEMORY
}

IF !DEFINED_defvarsaddr
        defc defvarsaddr = CRT_AVAILABLE_MEMORY+2000
ENDIF

DEFVARS defvarsaddr
{
dummydummy        ds.b    1 
}


;===============================================================================
ENDIF
;===============================================================================
