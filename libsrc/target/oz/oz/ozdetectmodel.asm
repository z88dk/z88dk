;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	Detect the OZ model
;
;;  ozmodel:
;;
;;   bit 0:  0 if 700/730 and 1 if 750/770
;;   bit 1:  0 if <770 and 1 if 770
;;   bit 2:  0 if 7xxPC and 1 if 7xxM
;
; ------
; $Id: ozdetectmodel.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozdetectmodel
	PUBLIC	_ozdetectmodel
	EXTERN	ozmodel
	EXTERN	s_filetypetable
	EXTERN	restore_a000



ozdetectmodel:
_ozdetectmodel:


        push    bc
        push    de
        call    07f94h
        ld      (ozmodel),a
        ld      a,0ch
        ld      hl,0ab4fh
        ld      de,String1
        call    compare4
        jr      nz,is730or750PC
;; we have either a 770 or a 730M/750M at this point
        ld      a,0eh  ;; we'll check where the font tables are
        ld      hl,0a300h
        ld      de,String2
        call    compare4   ;; z if 770;  nz if 730M/750M
        ld      e,2
        jr      z,setmodel
        ld      e,4
setmodel:
        ld      hl,ozmodel
        ld      a,(hl)
        or      e
        ld      (hl),a
        jr      Finish
is730or750PC:
        ld      a,88h
        ld      (s_filetypetable),a
Finish:
        ld      a,(ozmodel)
        ld      l,a
        pop     de
        pop     bc
        jp      restore_a000


compare4:
        out     (3),a
        xor     a
        out     (4),a
        ld      b,4
top:
        ld      a,(de)
        cp      (hl)
        ret     nz
        inc     de
        inc     hl
        djnz    top
        ret

	SECTION rodata_clib
String1:
        defb    89h,0c0h,19h,4dh
String2:
        defm    "PC_P"
