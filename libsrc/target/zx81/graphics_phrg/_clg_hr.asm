;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;
;	$Id: _clg_hr.asm $
;

	MODULE    __pseudohrg_clg_hr

	SECTION   code_graphics
	PUBLIC    _clg_hr
	PUBLIC    __clg_hr

	EXTERN	base_graphics
	
	EXTERN	_gfxhr_pixtab

	EXTERN	hrg_on

	INCLUDE "graphics/grafix.inc"


._clg_hr
.__clg_hr

        ld      hl,(base_graphics)
        ld      a,h
        or      l
        call    z,HRG_Interface_BaseRamtop	; if zero, make space and adjust ramtop for 16K

;--------------------------------------------------------------------
;
; HRG_Tool_Clear
; hl = pointer to display array
;
; to fill hr_rows lines by 32 characters
; here we use the stack (!) to fill hr_rows x 8 x 16 words with push
;
;--------------------------------------------------------------------

	ld	hl,(base_graphics)

	ld	a,maxy
	ld	c,a
	;push af

	ld	a,(_gfxhr_pixtab)
.floop
	ld b,32
.zloop
	ld (hl),a
	inc hl
	djnz zloop
	
	ld (hl),201
	inc hl
	dec c
	jr nz,floop

	jp hrg_on





;------------------------------------------
;
;   ZX81 system variables
;
;------------------------------------------
;DEFC   ERR_NR  = 16384 ;byte   one less than the report code
;DEFC   FLAGS   = 16385 ;byte   flags to control the BASIC system.
;DEFC   MODE    = 16390 ;byte   Specified K, L, F or G cursor.
;DEFC   PPC     = 16391 ;word   Line number of statement currently being executed

DEFC    ERR_SP  = 16386 ;word   Address of first item on machine stack (after GOSUB returns).
DEFC    RAMTOP  = 16388 ;word   Address of first byte above BASIC system area. 




IF DEFINED_MEM8K
    DEFC  TOPOFRAM    = $6000
ELSE
    DEFC  TOPOFRAM    = $8000
ENDIF


DEFC  BASE_VRAM   = TOPOFRAM - (maxy*33)
DEFC  NEW_RAMTOP  = BASE_VRAM - 128
DEFC  WHOLEMEM    = (maxy*33) + 128   ; size of graphics map in 256x192 mode





IF !DEFINED_hrgpage
;--------------------------------------------------------------
;
; HRG_Interface_BaseRamtop
;
; checks if RAMTOP is set to 16k ram pack
; if so it lowers RAMTOP, copies stack and adapts all
; needed variables so that the program can continue with
; no need to issue a NEW command to redirect pointers.
; HRG base is set to the location over RAMTOP
;
;--------------------------------------------------------------
HRG_Interface_BaseRamtop:

        ld      hl,(RAMTOP)
        ld      de,TOPOFRAM     ;is RAMTOP in original 8k/16k position?
        xor     a
        sbc     hl,de
        ld      a,h
        or      l
        jr      z,HRG_Interface_BaseRamtopModify
        ld      hl,(RAMTOP)
        ld      de,NEW_RAMTOP    ;is RAMTOP already lowered?
        xor     a
        sbc     hl,de
        ld      a,h
        or      l               ;no, so this is a problem!
        jr      nz,HRG_Interface_BaseRamError

        ld      hl,BASE_VRAM      ;yes, then set base_graphics
        ld      (base_graphics),hl
        ret


HRG_Interface_BaseRamtopModify: 
        ld      hl,BASE_VRAM
        ld      (base_graphics),hl

        ld      hl,NEW_RAMTOP    ;lower RAMTOP
        ld      (RAMTOP),hl
        
        ld      hl,(ERR_SP)
        ld      de,WHOLEMEM
        xor     a
        sbc     hl,de
        ld      (ERR_SP),hl     ;lower ERR_SP


        ld      hl,$0000
        add     hl,sp           ;load SP into HL
        push    hl		; *** stack pointer
        ld      de,TOPOFRAM     ;prepare to copy the stack
        ex      de,hl
        xor     a
        sbc     hl,de
        ld      de,$0040
        add     hl,de           ;stackdeepth in HL
        push    hl
        pop     bc              ;stackdeepth in BC
        
        ld	hl,TOPOFRAM-1   ;make a copy of the stack
        ld      de,NEW_RAMTOP-1
        lddr

        pop     hl              ; *** stackpointer in HL
        ld      de,WHOLEMEM
        xor     a
        sbc     hl,de           ;lower the stackpointer
        ld      sp,hl           ;WOW!


HRG_Interface_BaseRamError:

        ;rst     $08             ;error
        ;defb    $1a             ;type R

	; Nothig is as expected: let's put graphics just above the actual RAMTOP
	; and cross fingers

        ld      hl,(RAMTOP)
        ld      (base_graphics),hl
        
        ret

ENDIF

