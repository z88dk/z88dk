;       CRT0 for the Sharp OZ family
;
;       Stefano Bodrato 13 Aug. 2002
;
;	Mix of the Dominic's work and the Hi-Tech C modifications
;	by the OZDEV team (Alexander R. Pruss, Green, etc..)
;
;	all the "$" prefixes have been changed to "s_";
;	the "$sp$" label is been changed to "s_sp".
; 
;	the "-DOZDK" enables the OZ7xx DK compatibility mode
;	with extra functions and interrupt handling
;	(this causes the DEFINED_ozgetch2 flag to be activated)
;
; - - - - - - -
;
;       $Id: oz_crt0.asm,v 1.21 2016-07-09 21:18:54 stefano Exp $
;
; - - - - - - -


		MODULE  oz_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

		defc    crt0 = 1
		defc	NEED_ansiterminal = 1
		INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

		EXTERN	_main           ;main() is always external to crt0 code

		PUBLIC	cleanup         ;jp'd to by exit()
		PUBLIC	l_dcal          ;jp(hl)

		PUBLIC	_std_seed        ;Integer rand() seed


		PUBLIC	exitsp          ;atexit() variables
		PUBLIC	exitcount

		PUBLIC	__sgoioblk      ;stdio info block

		PUBLIC	heaplast	;Near malloc heap variables
		PUBLIC	heapblocks

		PUBLIC	base_graphics   ;Graphical variables

		PUBLIC	coords          ;Current xy position
		PUBLIC	s_filetypetable

		PUBLIC	saved_hl	;Temporary store used by compiler
		PUBLIC	saved_de	;for hl and de

; --- OZ related stuff---

		PUBLIC	ozactivepage    ;current mem page
		PUBLIC	ozmodel         ;detected model (call "detect" first)
		PUBLIC	ozbacklight     ;display light status
		PUBLIC	ozcontrast      ;display contrast
		PUBLIC	ozbacklight_save
		PUBLIC	s_ozlcdstatus
		PUBLIC	s_init_unblank	;service entry point to go back from "ozfast" or "ozblankscreen"

		PUBLIC	ScrCharSet

IF DEFINED_ozgetch2
		PUBLIC	KeyBufGetPos	;
		PUBLIC	KeyBufPutPos	; don't
		PUBLIC	EnableKeyboard
		PUBLIC	KeyboardBuffer
ENDIF

; --- settings ---
		PUBLIC	ozkeyrepeatspeed
		PUBLIC	ozkeyrepeatdelay
		PUBLIC	ozclick_setting
		PUBLIC	ozautoofftime
		PUBLIC	ozautoblanktime
		PUBLIC	ozautolightofftime
		PUBLIC	ozprogoptions
; --- -------- ---
		defc	contrast  = 0c026h
		defc	lcdstatus = 0c024h

		org	$8000


		DEFB 00h, 64h, 09h, 0FEh, 31h, 26h, 48h, 41h
		DEFB 30h, 31h, 32h,  0Dh, 75h, 31h, 03h, 0FEh, 5Ah, 0Fh

start:
		jr     skipname
ozfilename:
		defm    "BFILNAMEBAS"
		defb    00
ozfileowner:
		defw    65535
; __ozspare1start:
skipname:
		in     a,(1)
		push   af
		in     a,(2)
		push   af        ; save starting 8000 page
		ld     a,2
		out    (1),a
		ld     a,4
		out    (2),a     ; page first code page into 8000h
		jp     continue
continue:

		ld      a,(0c068h)  ; backlight state
		ld      (ozbacklight),a
		ld      (ozbacklight_save),a

		ld      hl,(lcdstatus)
		ld      (s_ozlcdstatus),hl

		ld      a,(contrast)
		ld      (ozcontrast),a

		di

		in     a,(7)
		;ld     (intset),a
		ld     (intset+1),a
		ld     a,0ffh-(16+128+1) ;; ARP: was 4+32 !!
		out    (7),a

		call   s_swapupperpages

;; now our code is paged in as follows:
;;  8000h: first code page, originally in page 406h
;;  a000h: second code page, originally in page 407h
;;  c000h: third code page, originally in page 408h
;;  e000h: fourth code page, originally in page 409h
;;  pages 408h and 409h store the initial contents of c000h-ffffh
;; sp points to 0fe00h

; clear BSS segment (lifted from Hi-Tech C init code, but modified)
		;ld      de,__Lbss       ;Start of BSS segment
		;or	a		;clear carry
		;ld	hl,__Hbss
		;sbc	hl,de		;size of uninitialized data area
		;jr      z,EmptyBSS
		;ld	c,l
		;ld	b,h
		;dec	bc	
		;ld	l,e
		;ld	h,d
		;inc	de
		;ld	(hl),0
		;ldir                    ;clear memory
;EmptyBSS:

IF DEFINED_ozgetch2
		ld      hl,KeyBufGetPos
		ld      (hl),0
		ld      de,KeyBufGetPos+1
		ld      bc,26-1
		ldir

;        ld      a,1
;        out     (19h),a
;        ld      a,10
;        out     (17h),a
;        xor     a
;        out     (18h),a
;        ld      a,2
;        out     (16h),a         ;; enable key click

		EXTERN	ozsetisr
		
		ld      hl,ozcustomisr
		push    hl
		call    ozsetisr       ;; install our ISR
		pop     bc
		ld      a,l
		or      h
		jr      nz,__exit
ENDIF

		;ld      hl,1
		;push    hl
		;call    _ozclick
		;pop     hl

		;ld      hl,argv
		;push    hl
		;ld      hl,1
		;push    hl

;------- Z88DK specific code (begin) -------
		ld      (start1+1),sp	;Save entry stack
		ld      hl,-64
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

;-------- Z88DK specific code (end) -------

		call    _main    ;call main program
; __ozspare1end:

;------- Z88DK specific code (begin) -------
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
		EXTERN	closeall
		call	closeall
ENDIF

start1:	ld	sp,0		;Restore stack to entry value
		;ret
;-------- Z88DK specific code (end) -------

		;pop     hl
		;pop     hl	; argv (??)
_ozexitrestoreint:
_exit:
		ld      a,7
		out     (3),a
		ld      a,4
		out     (4),a   ;; page in proper second page
		;call    __ozcallexitfunctions
__exit:
s_init_unblank:			; ozblankscreen or ozfast might have hidden everything;
		call    ret_only	; if so, ret_only is changed into "ozunblankscreen" to make it back visible.

		di
;intset  equ    $+1
intset:        ld     a,0ffh
		out    (7),a
		im     1

		call    s_swapupperpages

		call    s_clearbacklighttimer

;; restore a bunch of stuff
		ld      a,(ozbacklight_save)
		ld      (0c068h),a

		ld      hl,(s_ozlcdstatus)
		ld      (lcdstatus),hl	;; restore right LCD Status

		ld      a,(ozcontrast)
		ld      (contrast),a

IF DEFINED_ozgetch2
		ld      hl,KeyBufGetPos ;; put keyboard buffer in standard buffer
		ld      de,0c031h
		ld      bc,24
		ldir
ENDIF

s_wipe_hook:
		nop
		nop
		nop

;        ld     hl,0406h
;        ld     c,4
;        out    (c),h
;        dec    c
;        out    (c),l
;        dec    c
		ld      a,6
		out     (3),a
		ld      a,4
		out     (4),a

		jp     continue2+2000h
continue2:
;        pop    hl
;        out    (c),h
;        dec    c
;        out    (c),l     ; restore starting page

		pop    af
		out    (2),a
		pop    af
		out    (1),a

		xor    a
		out    (22h),a   ; restore default display page
		ei

_bdos:                ;; dummy routines
		ret
s_sp:
		defw 0fe00h

swapret: defw 0

s_swapupperpages:       ;; must be called with interrupts disabled
		pop     bc
		ld      (s_swapupperpages_ret+1),bc


		ld     a,8
		out    (3),a
		ld     a,4      ; page in page 408 at 0a000h
		out    (4),a

		ld      d,0c0h
		call    s_swappage     ; swap 0a000h page with 0c000h page

		ld      a,9
		out     (3),a
;        ld      a,4
;        out     (4),a   ; page in page 409 at 0a000h

		ld      d,0e0h
		call    s_swappage      ; swap 0a000h page with 0e000h page

		ld      hl,0
		add     hl,sp
		ld      de,(s_sp)
		ld      (s_sp),hl
		ex      de,hl
		ld      sp,hl

s_swapupperpages_ret:        jp      0
;s_swapupperpages_ret equ $-2

s_swappage:   ;; must be called with interrupts disabled!
		;; swaps pages at a000 and at d*256

		pop     bc
		ld      (s_swappage_ret+1),bc

		ld      hl,0
		add     hl,sp
		ld      (s_saved_sp+1),hl

		ld      hl,0a000h
		ld      sp,hl
		ld      e,l
		ex      de,hl
		ld      a,h
		add     a,20h      ; end marker
top:
		pop bc   ;10
		ld e,(hl)  ;7
		ld (hl),c  ;7
		inc l       ;4
		ld d,(hl)  ;7
		ld (hl),b  ;7
		inc l        ;4
		push de  ;11
		pop de    ;10    ;SP=SP+2
		pop bc    ;10
		ld e,(hl)
		ld (hl),c
		inc l
		ld d,(hl)
		ld (hl),b
		inc l
		push de
		pop de
		jp nz,top  ;10
		inc h
		cp h
		jp nz,top

s_saved_sp:       ld      hl,0000   ;;
;s_saved_sp equ $-2         ;; self-mod
		ld      sp,hl
		ld      a,7
		out     (3),a
;;        ld      a,4
;;        out     (4),a     ; page in second code page
s_swappage_ret:        jp      0
;$swappage_ret equ $-2

s_32kintoff:
		di
		im      1

ret_only:
		ret

s_32kinton:
		ld      a,0feh
		ld      i,a
		im      2
		ei
		ret

s_clearbacklighttimer:
		ld      hl,0
		ld      (0c00dh),hl
		ld      hl,(s_ozlcdstatus)
		ld      (lcdstatus),hl
		ret

ozbacklight:
		defb    0

ozbacklight_save:
		defb    0

ozcontrast:
		defb   0

s_ozlcdstatus:
		defw  0

; Keyboard and interrupts

INCLUDE "oz_customisr.def"

IF DEFINED_ozgetch2
KeyBufGetPos:   defb 0
KeyBufPutPos:   defb 0
KeyboardBuffer: ;     123456789012345678901234
		        defm "(c)Pruss,Green,&c vZ88DK"
ENDIF

ScrCharSet:     defb 1

;argv:   defw __ozfilename

EnableKeyboard: defs 1

;HeapTop EQU 0f980h
;Model32k EQU 1




;------------------------------------------
;------------------------------------------
; End of startup part, routines following
;------------------------------------------
;------------------------------------------

l_dcal:
		jp	(hl)


		defm  "Small C+ OZ"	;Unnecessary file signature
		defb	0
		
		defc ansipixels = 236
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 59
		ENDIF

		INCLUDE "crt0_runtime_selection.asm"
		INCLUDE "crt0_section.asm"


		SECTION bss_crt

saved_hl:       defw	0	; Temp store for hl
saved_de:       defw	0	; Temp store for de
ozactivepage:	defw 	0 ; Page number for the graph map (0400h for 0A000h)
ozmodel:		defb    0	; Set with "ozdetectmodel" (see libraries)
s_filetypetable: defw    0

		SECTION code_crt_init
			ld	hl,0xa000
			ld	(base_graphics),hl
			ld	hl,0x0400
			ld	(ozactivepage),hl
			ld	hl,0xc089
			ld	(s_filetypetable),hl
			ld	a,1
			ld	(ozmodel),a



; --- settings - leave untouched ---
		SECTION data_crt
ozkeyrepeatspeed:
		defb 5
ozkeyrepeatdelay:
		defb 32
ozclick_setting:
		defb 1
ozautoofftime:
		defw 60*180 ;; 3 hours
ozautoblanktime:
		defw 240    ;; 4 minutes
ozautolightofftime:
		defw 120    ;; 2 minutes
ozprogoptions:
		defb 0
;; padding (for future expansion)
defb 0,0,0,0

