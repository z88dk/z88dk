;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Stefano Bodrato 19/7/2007
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;       $Id: w_multipoint.asm,v 1.3 2016-06-20 21:47:41 dom Exp $
;


;Usage: multipoint(int vh, int length, struct *pixel)
;pick a vertical or horizontal bit bar, up to 16 bits long


		SECTION	  code_clib
                PUBLIC    multipoint
                PUBLIC    _multipoint

                EXTERN     w_pointxy
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1


.multipoint
._multipoint
		push	ix		;save callers
                ld      ix,2
                add     ix,sp
                ld      e,(ix+2)
                ld      d,(ix+3)
                ld      l,(ix+4)
                ld      h,(ix+5)
                ld      a,(ix+6)

                call    swapgfxbk

                ld      bc,0
                bit     0,(ix+8)
                jr      z,horizontal                
.vertical
                sla     c
                rl      b
                push	af
                push	hl
                push	de
                push	bc
                call    w_pointxy
                pop	bc
                pop	de
                pop	hl
                jr      z,jv
                inc     bc
.jv		pop	af
                inc     de
                dec	a
                jr	nz,vertical
                jr      exit
.horizontal
                sla     c
                rl      b
                push	af
                push	hl
                push	de
                push	bc
                call    w_pointxy
                pop	bc
                pop	de
                pop	hl
                jr      z,jh
                inc     bc
.jh		pop	af
                inc     hl
                dec	a
                jr	nz,horizontal
.exit
                call    swapgfxbk1

                ld      h,b
                ld      l,c
		pop	ix		;restore latest
                ret
