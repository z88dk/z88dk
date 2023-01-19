;	Stub for the TI 83+ calculator
;
;	Stefano Bodrato - Dec 2000
;			Feb 2000 - Speeded up the cpygraph
;
;	$Id: ti83p_crt0.asm,v 1.33 2016-07-11 05:58:34 stefano Exp $
;
; startup =
;   n - Primary shell, compatible shells
;       (Primary shell merely means it's the smallest implementation
;        for that shell, that uses full capabilities of the shell)
;
;   1  - Ion (default)
;   2  - MirageOS without quit key
;   3  -
;   4  - TSE Kernel
;   10 - asm( executable
;
;-----------------------------------------------------
; Some general PUBLICs and EXTERNs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti83plus_crt0

	EXTERN	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	PUBLIC	cleanup		; used by exit()
	PUBLIC	l_dcal		; used by calculated calls = "call (hl)"


	PUBLIC	cpygraph	; TI calc specific stuff
	PUBLIC	tidi		;
	PUBLIC	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------

	INCLUDE "Ti83p.def"	; ROM / RAM adresses on Ti83+[SE]
        defc    crt0 = 1
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines

	defc	CONSOLE_ROWS = 8
	defc    CONSOLE_COLUMNS = 16
        defc    TAR__clib_exit_stack_size = 3
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 6000000
        INCLUDE "crt/classic/crt_rules.inc"
	
;-----------------------------
;2 - MirageOS without quit key
;-----------------------------
IF (startup=2)
	DEFINE MirageOS			;Used by greyscale interrupt etc.
	DEFINE NOT_DEFAULT_SHELL	;Else we would use Ion
	org	$9D95
	;org	$9D93
	;defb         $BB,$6D
	ret				;So TIOS wont run the program
	defb	1			;Identifier as MirageOS program
	DEFINE NEED_mirage_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_mirage_icon
 IF !DEFINED_NEED_mirage_icon
	defb	@01111000,@00000000	;Picture of a map with "C+" on it
	defb	@10000100,@00000000
	defb	@10000011,@11111100	;15x15 button
	defb	@10000000,@00000010
	defb	@10011111,@00000010
	defb	@10111111,@00000010
	defb	@10110000,@00110010
	defb	@10110000,@01111010
	defb	@10110000,@01111010
	defb	@10110000,@00110010
	defb	@10111111,@00000010
	defb	@10011111,@00000010
	defb	@10000000,@00000010
	defb	@10000000,@00000010
	defb	@01111111,@11111100
 ENDIF
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"		; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0			; Termination zero
	im	1			; Disable MirageOS tasker interrupt...
ENDIF

;--------------
;4 - TSE Kernel
;--------------
IF (startup = 4)
	DEFINE TSE
	DEFINE NOT_DEFAULT_SHELL
	org	$9D94
	ret
	defm	"TSE"
	defb	1
	defm	" "
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
;-----------------------------------------------------------------------------
; External Data Required for virtual stack. I've set this to 400
; (the normal size of the Ti83+ stack). You can use #pragma to set
; a userdefined  value (RECOMMENDED):
; #pragma output StackNeeded = nnn;
;-----------------------------------------------------------------------------
 IF !DEFINED_StackNeeded
	defw	400
 ELSE
	defw	DEFINED_StackNeeded
 ENDIF
ENDIF

;--------------------
;10 - asm( executable
;--------------------
IF (startup=10)
	DEFINE ASM
	DEFINE NOT_DEFAULT_SHELL
	org	$9D95
	;org	$9D93
	;defb         $BB,$6D
ENDIF

;-----------------
;1 - Ion (default)
;-----------------
IF !NOT_DEFAULT_SHELL
	DEFINE Ion
	org	$9D95
	;org	$9D93
	;defb         $BB,$6D
	ret
	jr	nc,start
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
ENDIF


;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
start:
IF DEFINED_GimmeSpeed
	ld	a,1		; switch to 15MHz (extra fast)
	rst	28		; bcall(SetExSpeed)
	defw	SetExSpeed	;
ENDIF				;
	ld	(__restore_sp_onexit+1),sp	;
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
        call    crt0_init_bss
        ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


	EXTERN	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl

IF DEFINED_GRAYlib
 IF DEFINED_GimmeSpeed
	INCLUDE "target/ti83p/classic/gray83pSE.asm"	; 15MHz grayscale interrupt
 ELSE
	INCLUDE	"target/ti83p/classic/gray83p.asm"		;  6MHz grayscale interrupt
 ENDIF
ELSE
	INCLUDE	"target/ti83p/classic/intwrap83p.asm"	; Interrupt Wrapper
ENDIF

	im	2		; enable IM2 interrupt
	call	_main		; call main()
cleanup:			; exit() jumps to this point
	ld	iy,_IY_TABLE	; Restore flag pointer
	im	1		;
IF DEFINED_GimmeSpeed		;
	xor	a		; Switch to 6MHz (normal speed)
	rst	28		; bcall(SetExSpeed)
	defw	SetExSpeed	;
ENDIF				;
__restore_sp_onexit:
    ld	sp,0		; Restore SP
IF TSE				; TSE Kernel
	call	_tseForceYield	; Task-switch back to shell (can return...)
	jp	start		; begin again if needed...
ENDIF				;
tiei:	ei			;
IF DEFINED_GRAYlib		;
cpygraph:
ENDIF				;
tidi:	ret			;

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
l_dcal:
	jp	(hl)		; used as "call (hl)"






IF !DEFINED_GRAYlib
 IF DEFINED_GimmeSpeed
cpygraph:
	call	$50		; bjump(GrBufCpy)
	defw	GrBufCpy	; FastCopy is far too fast at 15MHz...
 ELSE
  IF Ion
	defc	cpygraph = $966E+80+15	; Ion FastCopy call
  ENDIF
  IF MirageOS
	defc	cpygraph = $4092	; MirageOS FastCopy call
  ENDIF
  IF TSE
	defc	cpygraph = $8A3A+18	; TSE FastCopy call
  ENDIF
  IF ASM
cpygraph:
;(ion)FastCopy from Joe Wingbermuehle
	di
	ld	a,$80				; 7
	out	($10),a				; 11
	ld	hl,plotSScreen-12-(-(12*64)+1)		; 10
	ld	a,$20				; 7
	ld	c,a				; 4
	inc	hl				; 6 waste
	dec	hl				; 6 waste
fastCopyAgain:
	ld	b,64				; 7
	inc	c				; 4
	ld	de,-(12*64)+1			; 10
	out	($10),a				; 11
	add	hl,de				; 11
	ld	de,10				; 10
fastCopyLoop:
	add	hl,de				; 11
	inc	hl				; 6 waste
	inc	hl				; 6 waste
	inc	de				; 6
	ld	a,(hl)				; 7
	out	($11),a				; 11
	dec	de				; 6
	djnz	fastCopyLoop			; 13/8
	ld	a,c				; 4
	cp	$2B+1				; 7
	jr	nz,fastCopyAgain		; 10/1
	ret					; 10
  ENDIF
 ENDIF
ENDIF

		defc ansipixels = 96
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 32
		ENDIF
		
        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	code_crt_init
	ld	hl,plotSScreen
	ld	(base_graphics),hl
