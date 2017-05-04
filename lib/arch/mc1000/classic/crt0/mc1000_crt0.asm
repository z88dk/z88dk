;
;       Startup for the CCE MC-1000
;
;       Stefano Bodrato - Feb. 2013
;
;       $Id: mc1000_crt0.asm,v 1.22 2016-07-15 21:03:25 dom Exp $
;

; 	There are a couple of #pragma optimization directives 
;	this file:
;
;	#pragma output nostreams      - No stdio disc files
;	#pragma output nogfx          - Saves memory in TEXT only programs




                MODULE  mc1000_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC	pixeladdress
        PUBLIC	clg
        PUBLIC	pix_return
        PUBLIC	pix_rl
        PUBLIC	pix_pre
        PUBLIC	pix_post
        
        PUBLIC	gfxbyte_get
        
        PUBLIC	ansi_cls
        PUBLIC	ansi_del_line
        PUBLIC	ansi_SCROLLUP



        IF      !DEFINED_CRT_ORG_CODE
			IF (startup=2)
				defc    CRT_ORG_CODE  = $100  ; Direct M/C mode, including system variables on top 100h bytes
			ELSE
				defc    CRT_ORG_CODE  = 981	; BASIC startup mode (correct location TBD)
			ENDIF
        ENDIF


; Now, getting to the real stuff now!

		org     CRT_ORG_CODE


IF (startup=2)

  ; native M/C startup mode
  ; "TLOAD" mode

;
    defb  $ff,$ff,$ff
MC_PGM:
MC_PGN:
MC_MUSIC:
    defb  $ff
MC_PLAY:
    defb  $01
MC_PLAYMX:
    defb  $01
MC_HEAD:
    defb  $00
MC_RANDOM:
    defw  $ffff
MC_RCRDPT:
    defw  MC_RECORD
MC_RECORD:
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
    defb  $00,$00
MC_KEY0:
    defb  $ff,$ff,$ff,$ff
;
    defb  $ff
MC_JOB:
    ret
    defb  $ff,$ff
MC_SCOREA:
    defb  $00
MC_SCOREB:
    defb  $00
MC_SHAPE0:
    defb  $ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff
MC_JOBM:
    ret
    defb  $ff,$ff
;
    defb  $ff,$ff
MC_TABLE:
MC_NSA:
    defw  $ffff
MC_NAA:
    defw  $ffff
MC_AVALUE:
    defb  $00
VOICEA:
    defb  $ff
MC_INTRPA:
    defb  $ff
MC_TEMPA:
    defb  $ff
MC_INTA:
    defb  $ff
MC_NSB:
    defw  $ffff
MC_NBB:
    defw  $ffff
MC_BVALUE:
    defb  $00
MC_VOICEB:
    defb  $ff
MC_INTRPB:
    defb  $ff
MC_TEMPB:
    defb  $ff
MC_INTB:
    defb  $ff
MC_NSC:
    defw  $ffff
MC_NCC:
    defw  $ffff
MC_CVALUE:
    defb  $00
MC_VOICEC:
    defb  $ff
MC_INTRPC:
    defb  $ff
MC_TEMPC:
    defb  $ff
MC_INTC:
    defb  $ff
MC_ENABLE:
    defb  $ff
MC_AMPLIT:
    defb  $ff
MC_REGIST:
    defw  $ffff
MC_DEFIN:
    defb  $ff
MC_ONAMP:
    defw  $ffff
MC_LPLAY:
    defb  $ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff
MC_CHECK:
    defb  $00
;
    defb  $ff,$ff,$ff,$ff
MC_DSNAM:
    defw  $8000
MC_DENAM:
    defw  $8200
MC_HISCOR:
    defw  $ffff
MC_TEMP:
    defb  $ff
;
    defb  $ff,$ff
MC_RIGHTJ:
    defb  $ff
MC_CHANA:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEA:
    defb  $ff
MC_CHANB:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEB:
    defb  $ff
MC_CHANC:
    defw  $ffff
;
    defb  $ff,$ff,$ff
MC_TONEC:
    defb  $ff
MC_OBUF:
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff
MC_FILNAM:
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff
;
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    defb  $ff,$ff,$ff,$ff,$ff

;		; At position 200h different 'topics' (entries)
;		; can be defined; user can choose the topic CTRL-H
;		jp		start

		;..on the other side the first topic can be directly
		; the main program entry point, so no need for a jump table  :P


ELSE

  ; BASIC startup mode

    defw  nxt_basic_line
    defw  0       ; BASIC Line number
    defb  $a2     ; Token for CALL.
    defm  "992"   ; this BASIC caller stub is 11 bytes long
    defb  0       ; End of line
nxt_basic_line:
    defw  0


ENDIF


start:

	ld	hl,($39)
	ld	(irq_hndl+1),hl
	ld	hl,mc_irq
	ld	($39),hl
	
	;CALL $CEBA
	;LD ($0128),A
	;LD ($0357),A
	;LD ($0360),A
	;LD ($0358),A
	;LD ($0352),A
	;LD ($0361),A
	;DEC A
	;LD ($0106),A
	;LD ($0353),A
	;LD ($106),a
		;ld		hl,$106
		;ld		(hl),255	; disable gaming mode (shouldn't this work by putting 255??)
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,$bfff	; 48K ?
        ld      (hl),$55
        ld      a,$AA
        or      (hl)
        inc     a
        jr      z,has48k
        ld      hl,$3fff	; 48K.
has48k:
        ld      sp,hl
        
        ;ei
        ;xor     a
        ;out     ($80),a
        ;call    $c021      ; setup text page (ptr in HL)
        
	call	crt0_init_bss
	ld		(exitsp),sp
		
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF
		

        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF
        pop     bc
start1:
        ld      sp,0

IF (startup=2)
        ;jp      $C000  ; BASIC entry (COLD RESET)
        jp      $C003  ; BASIC entry (WARM RESET)
ELSE
		ld	hl,(irq_hndl+1)
		ld	($39),hl
		ret
ENDIF

l_dcal:
        jp      (hl)


; IRQ stub to get a time counter
mc_irq:
		di
		push hl
		push af
		ld	hl,(FRAMES)
		inc	hl
		ld	(FRAMES),hl
		ld	a,h
		or	l
		jr	nz,irq_hndl
		ld	hl,(FRAMES+2)
		inc	hl
		ld	(FRAMES+2),hl
irq_hndl:
		ld	hl,0
		;jp	$7f
		pop af
		ex	(sp),hl
		ret


IF !DEFINED_nogfx


;-----------  GFX init  -------------
.ansi_cls
.clg
	ld	b,255
	ld	a,$9e
	out	($80),a

	ld	hl,$8000
.clg1
	ld	(hl),b
	inc	hl
	ld	a,h
	cp	$98
	jp	nz,clg1

	ld	a,$9f
	out	($80),a
	ld	($f5),a		; Instruct the BASIC about the current screen mode
					; so the ROM won't mess with the video page when called
	ld	hl,clgret
	ld	($f7),hl	; cursor flashing and positioning routine

.clgret
	ret

;-----------  GFX support for ANSI VT emulation  -------------
.ansi_SCROLLUP
	ld	a,$9e
	out	($80),a

	ld	de,$8000
	ld	hl,$8000+256
	ld	bc,6144-256
	ldir
	
	ld	a,23

.ansi_del_line
	ex	af,af
	ld	a,$9e
	out	($80),a
	ex	af,af

	ld	hl,$8000
	ld	d,a		; de = line*256
	ld	e,l
	add	hl,de	;Line address in HL	
	
	ld	bc,255
	ld	(hl),c
	ld	d,h
	ld	e,l
	inc	de
	ldir

	ld	a,$9f
	out	($80),a
	ret

;-----------  GFX paging  -------------
.pixeladdress

	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,l
	ld	a,h
	ld	b,a

	ld	h,0

	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl

	ld	de,$8000
	add	hl,de

	; add x divided by 8
	
	;or	a
	rra
	srl a
	srl a
	ld	e,a
	ld	d,0
	add	hl,de	
	
;-------
.gfxbyte_get
	ld	a,$9e
	out	($80),a

	ld	a,(hl)
	ld	d,h
	ld	e,l
	ld	hl,pixelbyte
	cpl
	ld	(hl),a

	ld	a,$9f
	out	($80),a

	ld	a,b
	or	0f8h	;set all unused bits 1
	cpl			;they now become 0	
	ret


;-------
.pix_return
	ex	af,af	; dcircle uses the flags in af'.. watch out !
	ld	a,$9e
	out	($80),a

	ex	af,af	; dcircle uses the flags in af'.. watch out !
	cpl
	ld	(de),a	; pixel address

	ld	a,$9f
	out	($80),a
	ret

;------- ANSI VT support (chunk 1)
.pix_pre
	ld	a,$9e
	out	($80),a

	rl (ix+1)
	rl (ix+0)
	inc b
	dec b
	jr z,DTS
.L1
	rl (ix+1)
	rl (ix+0)
	djnz L1
.DTS
	;ex	af,af	;
	ld	a,$9f
	out	($80),a
	;ex	af,af	;
	ret

;------- ANSI VT support (chunk 2)
.pix_rl
	ex	af,af	;
	ld	a,$9e
	out	($80),a
	ex	af,af	;
.L2
	rla
	rl (ix+1)
	rl (ix+0)
	djnz L2
.pix_post
	ld b,6
	inc b
	dec b
	jr z,NEXT
.L3
	rl (ix+1)
	rl (ix+0)
	djnz L3
.NEXT
	ld	a,$9f
	out	($80),a	
	ret

ENDIF

        defm  "Small C+ MC1000"
        defb   0

		
; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
	defc	__crt_org_bss = CRT_ORG_BSS
ENDIF


	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"

	
	SECTION	bss_crt
	
        PUBLIC	pixelbyte	; Temp store for non-buffered mode
        PUBLIC	FRAMES
		
pixelbyte:
		defw    0       

FRAMES:
		defw	0
		defw	0

