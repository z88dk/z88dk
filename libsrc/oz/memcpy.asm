;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	memory copy routine
;	memcpy(dest,src,count)
;
;
; ------
; $Id: memcpy.asm,v 1.1 2003-10-29 13:03:05 stefano Exp $
;

	XLIB	memcpy
	
; 
;blkcpy:
memcpy:
        pop     hl
        ld      (retval+1),hl
;        pop     de
;        pop     hl
;        pop     bc
        pop     bc
        pop     hl
        pop     de
        push    de  ;; save destination

        ld      a,c
        or      b
        jr      z,NothingToDo

        ldir

NothingToDo:
        ex      (sp),hl  ;; get destination pointer
        push    hl
        push    hl       ;; fill up stack
retval:
        jp      0        ;;
;retval  equ     $-2      ;; self-modifying return
