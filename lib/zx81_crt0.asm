;       CRT0 for the ZX81
;
;       Stefano Bodrato Apr. 2000
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
;       ZX81 will be thrown in FAST mode by default.
;       The "startup=2" parameter forces the SLOW mode.
;       Values for "startup" from 3 to 6 activate the WRX HRG modes
;       Values between 13 and 17 activate the ARX HRG modes
;		LAMBDA 8300/POWER 3000 modes: startup=101 and startup=102
;
;       OPTIMIZATIONS:
;
;       If in HRG mode it is possible to exclude the SLOW mode text with the
;       '-DDEFINED_noslowfix' parameter it helps to save some memory.
;       "#pragma output noslowfix = 1" in the source program has the same effect.
;
;       If in WRX HRG mode a static position for HRGPAGE cam be defined in 
;       program (i.e. "#pragma output hrgpage=32768"), moving the video frame
;       over the stack instead than lowering it.  The automatic HRG page locator
;       is also disabled too, ripping off about 13 bytes.
;       In any case by POKEing at address 16518/16519 of the compiled program 
;       the HRG page position can be still changed by the user for custom needs.
;
; - - - - - - -
;
;       $Id: zx81_crt0.asm,v 1.59 2016-07-15 21:03:25 dom Exp $
;
; - - - - - - -


        MODULE  zx81_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks

IF (startup>100)
		; LAMBDA specific definitions (if any)
ENDIF


        PUBLIC    save81          ;Save ZX81 critical registers
        PUBLIC    restore81       ;Restore ZX81 critical registers

        ;; PUBLIC    frames         ;Frame counter for time()
        PUBLIC    _FRAMES
        defc    _FRAMES = 16436	; Timer

        IF      !DEFINED_CRT_ORG_CODE
	    IF (startup>100)
		; ORG position for LAMBDA
                defc    CRT_ORG_CODE  = 17307
 	    ELSE
                defc    CRT_ORG_CODE  = 16514
	    ENDIF
        ENDIF


        org     CRT_ORG_CODE


; Hide the mess in the REM line from BASIC program listing

;       jr      start
;       defb    118,255         ; block further listing

; As above, but more elegant

        ld      a,(hl)          ; hide the first 6 bytes of REM line
        jp      start           ; invisible
	defc	DEFINED_basegraphics = 1
_base_graphics:                 ; Address of the Graphics map..
base_graphics:			; it is POKEable at address 16518/16519
IF DEFINED_hrgpage
		defw	hrgpage
ELSE
		defw    0
ENDIF
        defb    'Z'-27          ; Change this with your own signature
        defb    '8'-20
        defb    '8'-20
        defb    'D'-27
        defb    'K'-27
        defb    0
        defb    'C'+101
        defb    149     ; '+'
        defb    118,255         ; block further listing

start:
		ld		ix, 16384	; (IXIY swap) when self-relocating IY is corrupt
        call    save81

IF (!DEFINED_startup | (startup=1))
        ; FAST mode, safest way to use the special registers
        call    $F23    ; FAST mode
        ;call   $2E7    ;setfast
        ;out ($fd),a  ; nmi off        
ENDIF


IF (startup>100)
	IF (startup=101)
		; FAST mode, safest way to use the special registers
		call	$D5E
	ENDIF
	IF (startup=102)
      call    altint_on
	ENDIF
ELSE
IF (startup>=2)
 IF ((startup=3)|(startup=5)|(startup=13)|(startup=15)|(startup=23)|(startup=25))
        ld	a,1
        ld      (hrgbrkflag),a
 ENDIF
 IF (startup=2)
        call    altint_on
	; Trick to get the HRG mode with a #pragma definition
	; perhaps useful with the MemoTech or the G007 HRG boards
	IF DEFINED_ANSIHRG
			call    hrg_on
	ENDIF
 ELSE
        call    hrg_on
 ENDIF
ENDIF
ENDIF

IF (startup>100)
		; LAMBDA specific startup code (if any)
ELSE
IF (startup>=23)	; CHROMA 81
	ld	a,32+16+7	; 32=colour enabled,  16="attribute file" mode, 7=white border
	ld	bc,7FEFh
	out	(c),a

	ld	a,7*16		; white paper, black ink
	ld	hl,HRG_LineStart+2+32768
	ld	de,(16396)
	set	7,d
	inc	de
	ld	c,24
.rowloop
	ld	b,32
.rowattr
	ld	(hl),a
	ld	(de),a
	inc	hl
	inc	de
	djnz rowattr
	inc	hl
	inc	hl
	inc	hl
	inc	de
	dec	c
	jr	nz,rowloop
ENDIF
ENDIF

	; this must be after 'hrg_on', sometimes
	; the stack will be moved to make room
	; for high-resolution graphics.
	
        ld      (start1+1),sp   ;Save entry stack
IF      STACKPTR
        ld      sp,STACKPTR
ENDIF
	ld      hl,-8        ;Create an atexit() stack
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

        call    _main   ;Call user program
        
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl		; keep return code

IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF
		; The BASIC USR call would restore IY on return, but it could not be enough
        call    restore81

IF (startup>100)
    IF (startup=101)
	; LAMBDA specific exit resume code (if any)
	call	 $12A5	; SLOW
    ENDIF
    IF (startup=102)
        call    altint_off
    ENDIF
ELSE
IF (startup>=2)
 IF ((startup=3)|(startup=5)|(startup=13)|(startup=15)|(startup=23)|(startup=25))
        xor	a
        ld      (hrgbrkflag),a
 ELSE
  IF (startup=2)
        call    altint_off
  ELSE
        call    hrg_off		; this is valid for mode 2, too !
  ENDIF
 ENDIF
ELSE
 IF (!DEFINED_startup | (startup=1))
        call    $F2B            ; SLOW mode
        ;call   $207    ;slowfast
 ENDIF
ENDIF
ENDIF

        pop     bc		; return code (for BASIC)
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls


restore81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
        ld      a,(a1save)
        ex      af,af
ENDIF
        exx
        ld	hl,(hl1save)
        ;ld	bc,(bc1save)
        ;ld	de,(de1save)
        exx
        ld      ix,16384	; IT WILL BECOME IY  !!
        ret
        
save81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
        ld      (a1save),a
        ex      af,af
ENDIF
        exx
        ld	(hl1save),hl
        ;ld	(bc1save),bc
        ;ld	(de1save),de
        exx
        ret


;---------------------------------------
; Modified IRQ handler
;---------------------------------------

IF (startup>100)
	; LAMBDA modes
	
     IF (startup=102)
        INCLUDE "lambda_altint.def"
     ENDIF
ELSE

; +++++ non-LAMBDA section begin +++++

    IF (startup=2)
        INCLUDE "zx81_altint.def"
    ENDIF

;-------------------------------------------------
; High Resolution Graphics (Wilf Rigter WRX mode)
; Code my Matthias Swatosch
;-------------------------------------------------

    IF (startup>=3)
	IF ((startup<=7)|(startup>=23))
            INCLUDE "zx81_hrg.def"
        ENDIF
    ENDIF

;-------------------------------------------------
; High Resolution Graphics (Andy Rea ARX816 mode)
;-------------------------------------------------

    IF (startup>=13)
	IF (startup>=23)
	;
	ELSE
	    IF (startup<=17)
		INCLUDE "zx81_hrg_arx.def"
	    ENDIF
	ENDIF
    ENDIF
; +++++ non-LAMBDA section end +++++
ENDIF

;-----------
; Now some variables
;-----------
IF (startup>=3)
	PUBLIC text_rows
	PUBLIC hr_rows
	PUBLIC _hr_rows
text_rows:
hr_rows:
_hr_rows:
 IF ((startup=5)|(startup=6)|(startup=7)|(startup=15)|(startup=16)|(startup=17)|(startup=25)|(startup=26)|(startup=27))
		defw	8	; Current number of text rows in graphics mode
 ELSE
		defw	24	; Current number of text rows in graphics mode
 ENDIF
ENDIF







;                defm  "Small C+ ZX81"   ;Unnecessary file signature
;                defb    0
        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"


	SECTION bss_crt
IF (!DEFINED_startup | (startup=1))
a1save: 	defb    0
ENDIF
hl1save:	defw	0
;bc1save:	defw	0
de1save:	defw	0



