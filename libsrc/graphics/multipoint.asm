;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Stefano Bodrato 19/7/2007
;
;
;       $Id: multipoint.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: multipoint(int vh, int length, struct *pixel)
;pick a vertical or horizontal bit bar, up to 16 bits long


                PUBLIC    multipoint

                EXTERN     pointxy
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1


.multipoint
                ld      ix,0
                add     ix,sp
                ld      l,(ix+2)
                ld      h,(ix+4)
                ld      b,(ix+6)

                call    swapgfxbk

                ld      de,0
                bit     0,(ix+8)
                jr      z,horizontal                
.vertical
                sla     e
                rl      d
                call    pointxy
                jr      z,jv
                inc     de
.jv
                inc     l
                djnz    vertical
                jr      exit
.horizontal
                sla     e
                rl      d
                call    pointxy
                jr      z,jh
                inc     de
.jh
                inc     h
                djnz    horizontal
.exit
                call    swapgfxbk1

                ld      h,d
                ld      l,e
                ret
