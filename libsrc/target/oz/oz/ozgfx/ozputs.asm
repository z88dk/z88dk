;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	int ozputs(int x, int y, char *string);
;
; ------
; $Id: ozputs.asm,v 1.4 2016-06-28 14:48:17 dom Exp $
;

        SECTION smc_clib
	PUBLIC	ozputs
	PUBLIC	_ozputs
	PUBLIC	ozputsgetend
	PUBLIC	_ozputsgetend
	
	EXTERN	ozdetectmodel
	EXTERN	restore_a000
	EXTERN	ozfontpointers
	EXTERN	ozmodel

	EXTERN	ozactivepage

	PUBLIC	s_end_s_pointer
	
	EXTERN	LowerFontPage1
	EXTERN	LowerFontPage2
	EXTERN	HigherFontPage1
	EXTERN	HigherFontPage2

	EXTERN	ScrCharSet


;; strlen  equ     7f0ch
;; DisplayStringAt  equ 7f4ch
;; Portable if ScrCharSet is portable ;;

ozputsgetend:
_ozputsgetend:
        ;ld      hl,0  ;; self-mod
        defb	33
s_end_s_pointer:
        defw	0
; $end$pointer equ    $-2   ;;
        ret


DoInit:
        ld      a,1
        ld      (init),a
        ld      a,(ozmodel)
        xor     0ffh
        call    z,ozdetectmodel
        ld      a,(ozmodel)
        and     4
        jr      z,DidInit  ;; not multilingual, so all is OK
        ld      a,1eh
        ld      (LowerFontPage1),a
        ld      (LowerFontPage2),a
        inc     a
        ld      (HigherFontPage1),a
        ld      (HigherFontPage2),a
        jr      DidInit


; int ozputs(int x, int y, char *string);

ozputs:
_ozputs:
        ld      a,(init)
        or      a
        jr      z,DoInit
DidInit: ;;;yyll001122
        push    iy
	ld	iy,2
	add	iy,sp
	push	ix

        exx
        ld      de,(ozactivepage)

        ;ld      l,(iy+6)
        ;ld      h,(iy+7)   ; address of string
        ld      l,(iy+2)
        ld      h,(iy+3)   ; address of string
        exx


	ld	a,(ScrCharSet)
        and     7
        add     a,a
        ld      d,0
        ld      e,a
        ld      hl,ozfontpointers
        add     hl,de
        ld      e,(hl)
        inc     hl
        ld      d,(hl)

        push    de
        pop     ix

        ld      a,(ix+0)
        ld      (font_page+1),a
        ld      a,(ix+1)
        ld      (font_page_hi+1),a

        ld      l,(ix+2)
        ld      h,(ix+3)
        ld      (font_len_offset+1),hl
        ld      l,(ix+4)
        ld      h,(ix+5)
        ld      (font_offset+1),hl
        ld      (font_offset_double+1),hl
        ld      e,(ix+6) ;; height
        ld      a,(ix+7) ;; charset mask
        ld      (charset_mask+1),a

        ;ld      a,(iy+5)
        ld      a,(iy+5)
        or      a
        jp      nz,LengthOnly

        ld      a,80
        ;ld      c,(iy+4)
        ld      c,(iy+4)
        sub     c            ;; number of rows available

        jp      c,LengthOnly
        jp      z,LengthOnly
        cp      e
        jp      nc,HeightOK
        ld      e,a
HeightOK:
        ld      a,e
        ld      (height+1),a
        ld      (height_double+2),a


	;ld	l,(iy+4)
	ld	l,(iy+4)
        ld      h,0
	add	hl,hl
	ld	c,l
	ld	b,h	 ; bc=2*y
	add	hl,hl	 ; hl=4*y
	add	hl,hl	 ; hl=8*y
	add	hl,hl	 ; hl=16*y
	add	hl,hl	 ; hl=32*y
	sbc	hl,bc	 ; hl=30*y
        ld      bc,0a000h
        add     hl,bc
	push	hl
	pop	ix	 ; ix=screen-offset for y
        ;ld      c,(iy+2)   ; x-position
        ;ld      b,(iy+3)
        ld      c,(iy+6)   ; x-position
        ld      b,(iy+7)
        exx
DoPrintLoop:
        ld      a,(hl)       ;; get character from string
        or      a
        jp      z,done
charset_mask:
        and     0ffh
;charset_mask equ $-1
        exx
        push    bc           ;; x-pos
font_len_offset:
	ld	hl,0000h     ;; self modifying code
;font_len_offset equ $-2
	ld	c,a
	ld	b,0
	add	hl,bc
	add	hl,bc
        add     hl,bc
        push    hl
        pop     iy           ;; iy=font character record position
        ld      a,(font_page+1)
	out	(3),a
        ld      a,(font_page_hi+1)
        out     (4),a
	ld	a,(hl)	; width
        ld      l,a
        ld      h,b     ; h=0 as b=0 still
        pop     bc      ; x-position
	push	bc
        ld      e,c
	add	hl,bc
        ld      (EndXPos+1),hl
        ld      bc,240
	sbc	hl,bc
        jp      nc,DonePop2
        cp      9       ; is width more than 8
        jp      nc,DoubleWidth
        ld      l,a     ; width
	ld	h,b	; h=0 as b=0 still  ;; hl=width
	ld	bc,Masks
	add	hl,bc
        ld      d,(hl)  ; mask for correct width
        ld      a,e     ; low byte of x-position
        ld      e,0
        and     7
        ld      (low_nibble+1),a
        jr      z,EndRotMask
        ld      b,a
RotRightMask:
        rl      d   ;; carry is clear because of "or a" and "dec a"
        rl      e
        djnz    RotRightMask
EndRotMask:


	ld	a,d
        cpl
	ld	(mask1+1),a
	ld	a,e
        cpl
        ld      (mask2+1),a


	ld	l,(iy+1)  ;; font position
	ld	h,(iy+2)
font_offset:
	ld	bc,0000h  ;; self-modifying code
;font_offset equ $-2	  ;;
        add     hl,bc     ;; hl=position of font data for character

	push	hl
        pop     iy        ;; iy=font data $end$pointer

	pop	bc	  ;; x-position of start

        srl     c
        srl     c
        srl     c
	ld	b,0
	push	ix
	pop	hl	  ;; hl=screen position
	add	hl,bc

height:
	ld	c,00  ;; character row counter (self-modifying)
;height equ $-1	      ;;

InnerCharLoop:
low_nibble:
        ld      b,00  ;; self-modifying code
;low_nibble equ $-1    ;;

font_page:
        ld      a,0  ;; self-modifying code
;font_page equ $-1
	out	(3),a
font_page_hi:
        ld      a,0
;font_page_hi equ $-1
	out	(4),a

        ld      e,0
        ld      d,(iy+0)


        exx
        ld      a,e
        out     (3),a
        ld      a,d
        out     (4),a
        exx

	ld	a,b
	or	a
        jr      z,NoCharacterShift
ShiftByte:
        rl      d
        rl      e
	djnz	ShiftByte
NoCharacterShift:
	ld	a,(hl) ;; get from screen
mask1:
        and     00     ;; self-modifying code
;mask1 equ $-1	       ;;
	or	d
	ld	(hl),a
	inc	hl
	ld	a,(hl)
mask2:
        and     00     ;; self-modifying code
;mask2 equ $-1	       ;;
	or	e
	ld	(hl),a
	ld	de,29
	add	hl,de
	inc	iy
	dec	c
	jp	nz,InnerCharLoop

EndOfCharPut:
EndXPos:
	ld	bc,0000     ;; self-modifying code
;EndXPos equ $-2 	    ;;
        exx
        inc     hl
        ld      a,7         ;; restore original page
        out     (3),a
        ld      a,4
        out     (4),a
	jp	DoPrintLoop
done:
        ld      (s_end_s_pointer),hl
        exx

        ld      l,c
        ld      h,b

cleanup_page:
	pop	ix
	pop	iy
        jp      restore_a000

DonePop2:
        pop     hl  ; x position
        exx
        ld      (s_end_s_pointer),hl
        exx
        jr      cleanup_page

DoubleWidth:
        sub     8
        ld      l,a     ; width-8
	ld	h,b	; h=0 as b=0 still  ;; hl=width
	ld	bc,Masks
	add	hl,bc
        ld      a,e     ; low byte of x-position
        and     7
        ld      (low_nibble_double+1),a
        ld      d,0ffh
        ld      e,(hl)  ; mask for correct width
        ld      c,0
        jr      z,EndRotMask_double
        ld      b,a
RotRightMask_double:
        rl      d   ;; carry is clear because of "or a" and "dec a"
        rl      e
        rl      c
        djnz    RotRightMask_double
EndRotMask_double:
	ld	a,d
        cpl
        ld      (mask1_double+1),a
	ld	a,e
        cpl
        ld      (mask2_double+1),a
        ld      a,c
        cpl
        ld      (mask3_double+1),a

	ld	l,(iy+1)  ;; font position
	ld	h,(iy+2)
font_offset_double:
	ld	bc,0000h  ;; self-modifying code
;font_offset_double equ $-2       ;;
        add     hl,bc     ;; hl=position of font data for character
	push	hl
        pop     iy        ;; iy=font data $end$pointer

	pop	bc	  ;; x-position of start

        srl     c
        srl     c
        srl     c
	ld	b,0
	push	ix
	pop	hl	  ;; hl=screen position
	add	hl,bc

        push    ix

height_double:
        ;undoc_ix
        ;ld      l,00  ;; ld ixl,00 : character row counter (self-modifying)
        ld ixl,0
;height_double equ $-1        ;;

InnerCharLoop_double:
low_nibble_double:
        ld      b,00  ;; self-modifying code
;low_nibble_double equ $-1    ;;

        ld      a,(font_page+1)
	out	(3),a
        ld      a,(font_page_hi+1)
	out	(4),a

        ld      d,(iy+0)
        inc     iy
        ld      e,(iy+0)
        ld      c,0

        exx
        ld      a,e
        out     (3),a
        ld      a,d
        out     (4),a
        exx

	ld	a,b
	or	a
        jr      z,NoCharacterShift_double
ShiftByte_double:
        rl      d
        rl      e
        rl      c
        djnz    ShiftByte_double
NoCharacterShift_double:
	ld	a,(hl) ;; get from screen
mask1_double:
        and     00     ;; self-modifying code  ;; should be AND
;mask1_double equ $-1          ;;
	or	d
	ld	(hl),a
	inc	hl
	ld	a,(hl)
mask2_double:
        and     00     ;; self-modifying code  ;; should be AND
;mask2_double equ $-1          ;;
	or	e
	ld	(hl),a
        inc     hl
	ld	a,(hl)
mask3_double:
        and     00     ;; self-modifying code  ;; should be AND
;mask3_double equ $-1          ;;
        or      c
        ld      (hl),a
        ld      de,28
	add	hl,de
	inc	iy
        ;undoc_ix
        ;dec     l
        dec	ixl
        jp      nz,InnerCharLoop_double
        pop     ix
        jp      EndOfCharPut

LengthOnly:
        exx
        push    hl
        exx
        pop     de

        ld      c,(iy+2)   ; x-position
        ld      b,(iy+3)
DoCountLoop:
        ld      a,(de)       ;; get character from string
	or	a
        jr      z,doneCounting
        push    bc           ;; x-pos
        ld      hl,(font_len_offset)
	ld	c,a
	ld	b,0
	add	hl,bc
	add	hl,bc
        add     hl,bc
	ld	a,(font_page+1)
	out	(3),a
        ld      a,(font_page_hi+1)
        out     (4),a
	ld	a,(hl)	; width
        ld      l,a
        ld      h,b     ; h=0 as b=0 still
        pop     bc      ; x-position
	add	hl,bc
        ld      c,l
        ld      b,h
	inc	de
        ld      a,7
	out	(3),a
        ld      a,4
	out	(4),a

        jp      DoCountLoop

doneCounting:
        ld      l,c
        ld      h,b
        jp      cleanup_page


Masks:  defb 1,3,7,15,31,63,127,255

init:       defs 1

