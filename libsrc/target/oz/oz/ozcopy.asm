;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	memory block copy routine
;
;
; ------
; $Id: ozcopy.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozcopy
	PUBLIC	_ozcopy
	
defc	load_address = 0ff02h


ozcopy_init:
        push    hl
        push    de
        push    bc
        ld      hl,copy_routine
        ld      de,load_address
        push    de
        ld      bc,end_copy_routine-copy_routine
        ldir
        pop     de
        ld      (ozcopy_jp_address+1),de
        pop     bc
        pop     de
        pop     hl
;;        jp      load_address
;; copy from hl:firstpushed to de:secondpushed, length bc
ozcopy:
_ozcopy:
ozcopy_jp_address:
        jp      ozcopy_init

;; copy from hl:firstpushed to de:secondpushed, length bc
;; relocatable and reentrant
copy_routine:
        in      a,(2)
        push    af
        in      a,(1)
        push    af     ;; save initial 8000 page

        in      a,(4)
        push    af
        in      a,(3)
        push    af     ;; save initial a000 page

        dec     hl
        dec     hl
        dec     hl
        dec     hl     ;; source page-4

        ld      a,l
        out     (1),a
        ld      a,h
        out     (2),a  ;; set source page

        ld      a,e
        out     (3),a
        ld      a,d
        out     (4),a  ;; set destination page

        ld      hl,10
        add     hl,sp

        ;; get destination offset
        ld      e,(hl)
        inc     hl
        ld      a,(hl)
        ;; add 0a000h to offset
        add     a,0a0h
        ld      d,a
        inc     hl


        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a

        ld      a,h    ;; add 08000h to offset
        add     a,080h
        ld      h,a

        ldir

        pop     af
        out     (3),a
        pop     af
        out     (4),a
        pop     af
        out     (1),a
        pop     af
        out     (2),a
        ret
end_copy_routine:

