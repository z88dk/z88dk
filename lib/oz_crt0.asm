;       CRT0 for the Sharp OZ family
;
;       Stefano Bodrato 13 Aug. 2002
;
;	Mix of the Dominic's work and the Hi-Tech C modifications
;	by the OZDEV team (Alexander R. Pruss, etc..)
;
;	all the "$" prefixes have been changed to "s_";
;	the "$sp$" label is been changed to "s_sp".
; 
;
; - - - - - - -
;
;       $Id: oz_crt0.asm,v 1.1 2002-11-20 14:15:18 stefano Exp $
;
; - - - - - - -


	MODULE  oz_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        XREF    _main           ;main() is always external to crt0 code

        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)

        XDEF    int_seed        ;Integer rand() seed

        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

        XDEF    __sgoioblk      ;stdio info block

       	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks

        XDEF    base_graphics   ;Graphical variables
        XDEF    __ozactivepage
        XDEF    coords          ;Current xy position

	XDEF	saved_hl	;Temporary store used by compiler
	XDEF	saved_de	;for hl and de

; --- OZ related stuff---

	XDEF	ScrCharSet
	XDEF	KeyBufGetPos
	XDEF	KeyBufPutPos
        XDEF    EnableKeyboard


	org	$8000


        DEFB 00h, 64h, 09h, 0FEh, 31h, 26h, 48h, 41h
        DEFB 30h, 31h, 32h,  0Dh, 75h, 31h, 03h, 0FEh, 5Ah, 0Fh

start:
        jr     skipname
__ozfilename:
        defm    "BFILNAMEBAS"
        defb    00
__ozfileowner:
        defw    65535
__ozspare1start:
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
        ld      (__ozbacklight),a

        ;ld      hl,(_$ozlcdstatus)
        ;ld      ($ozlcdstatus),hl

        ;ld      a,(___ozcontrast)
        ;ld      (__ozcontrast),a

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

        ;ld      hl,__ozcustomisr
        ;push    hl
        ;call    _ozsetisr       ;; install our ISR
        ;pop     bc
        ;ld      a,l
        ;or      h
        ;jr      nz,__exit

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
;-------- Z88DK specific code (end) -------

        call    _main    ;call main program
__ozspare1end:

;------- Z88DK specific code (begin) -------
.cleanup
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

.start1	ld	sp,0		;Restore stack to entry value
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
        call    ret_only
;$init_unblank equ $-2
;;;;        call    _ozslow

        di
;intset  equ    $+1
.intset        ld     a,0ffh
        out    (7),a
        im     1

        call    s_swapupperpages

        call    s_clearbacklighttimer

;; restore a bunch of stuff
        ld      a,(__ozbacklight)
        ld      (0c068h),a
        ;ld      hl,($ozlcdstatus)
        ;ld      (_$ozlcdstatus),hl ;; restore right LCD Status
        ;ld      a,(__ozcontrast)
        ;ld      (___ozcontrast),a
        ld      hl,KeyBufGetPos ;; put keyboard buffer in standard buffer
        ld      de,0c031h
        ld      bc,24
        ldir

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

.s_swapupperpages_ret        jp      0
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

.s_saved_sp       ld      hl,0000   ;;
;s_saved_sp equ $-2         ;; self-mod
        ld      sp,hl
        ld      a,7
        out     (3),a
;;        ld      a,4
;;        out     (4),a     ; page in second code page
.s_swappage_ret        jp      0
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
        ;ld      hl,($ozlcdstatus)
        ;ld      (_$ozlcdstatus),hl
        ret

__ozbacklight:
        defb    0
;;__ozbacklight_save:
;;        defb    0
;$ozlcdstatus:
;        defw  0
;__ozcontrast:
;        defb   0

KeyBufGetPos:   defb 0
KeyBufPutPos:   defb 0
KeyboardBuffer: ;     123456789012345678901234
                defm "(c)Pruss,Green,&c v0.093"
;        psect midpage
;        psect text
;        psect data
ScrCharSet:     defb 1
;argv:   defw __ozfilename
;        psect bss
EnableKeyboard: defs 1
;HeapTop EQU 0f980h
;_$ozlcdstatus equ 0c024h
;___ozcontrast equ 0c026h
;Model32k EQU 1


;------------------------------------------
;------------------------------------------
; End of startup part, routines following
;------------------------------------------
;------------------------------------------

.l_dcal
	jp	(hl)


; Now, define some values for stdin, stdout, stderr
IF (!DEFINED_nostreams) ~ (DEFINED_ANSIstdio) ; ~ = AND
.__sgoioblk
	INCLUDE	"#stdio_fp.asm"
ENDIF


;---------------------------------
; Select which printf core we want
;---------------------------------
._vfprintf
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


;-----------
; Now some variables
;-----------
.coords         defw    0       ; Current graphics xy coordinates

base_graphics:	defw A000h	; Address of the Graphics map
__ozactivepage:	defw 0400h	; Page number for the graph map (0400h for A000h)

.int_seed       defw    0       ; Seed for integer rand() routines

.exitsp         defw    0       ; Address of where the atexit() stack is
.exitcount      defb    0       ; How many routines on the atexit() stack


.heaplast       defw    0       ; Address of last block on heap
.heapblocks     defw    0       ; Number of blocks
.saved_hl	defw	0	; Temp store for hl
.saved_de	defw	0	; Temp store for de

         	defm  "Small C+ OZ"&0	;Unnecessary file signature

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "#float.asm"
.fp_seed        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
.extra          defs    6               ;FP register
.fa             defs    6               ;FP Accumulator
.fasign         defb    0               ;FP register
ENDIF

