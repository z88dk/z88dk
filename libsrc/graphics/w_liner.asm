        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_line_r
        
        EXTERN     line
        ;EXTERN     l_cmp

        EXTERN    __gfx_coords

;
;       $Id: w_liner.asm,v 1.11 2016-10-18 06:52:34 stefano Exp $
;

; ******************************************************************************
;
;       Draw a pixel line from (x0,y0) defined in (COORDS) - the current plot
;       coordinate, to the relative distance points (x0+x,y0+y).
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;       Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
;
;       The (COORDS+0)  pointer contains the current x coordinate, (COORDS+2) the
;       current y coordinate. The main program should set the (COORDS) variables
;       before using line drawing.
;
;       The routine checks the range of specified coordinates which is the
;       boundaries of the graphics area (256x64 pixels).
;       If a boundary error occurs the routine exits automatically.     This may be
;       useful if you are trying to draw a line longer than allowed. Only the
;       visible part will be drawn.
;
;       The hardware graphics memory is organized as (0,0) in the top left corner.
;
;
;
;       "draw line" algorithm
;       ------------------------------------------
;
;       direc_x = SGN x: direc_y = SGN y   (D',E')
;       x = ABS x: y = ABS y
;
;       if x >= y
;               if x+y=0 then return
;               HL = x
;               DE = y
;               ddx = direc_x              (B')
;               ddy = 0                    (C')
;       else
;               HL = y
;               DE = x
;               ddx = 0                    (B')
;               ddy = direc_y              (C')
;       endif
;
;       BC = HL
;       i = INT(BC/2)
;       FOR N=BC TO 1 STEP -1
;               i = i + DE
;               if i < HL
;                       inx = ddx           (B')
;                       iny = ddy           (C')
;               else
;                       i = i - HL
;                       inx = direc_x
;                       iny = direc_y
;               endif
;               x0 = x0 + inx
;               y0 = y0 + iny
;               plot (x0,y0)
;       NEXT    N
;       ------------------------------------------

.w_line_r       ;push    bc
                ;push    de                      ; preserve relative vertical distance
                ;push    hl                      ; preserve relative horizontal distance

                push    de
                push    hl
                
                exx
                pop     hl                      ; get relative horizontal direction
                call    sgn
                ld      d,a                     ; direc_x [D'] = SGN(x) installed
                call    abs                     ; x = ABS(x)
                
                ex      (sp),hl                 ; get vert. direction/save horiz. direction
                call    sgn                     ; direc_y = SGN(y) installed  [DE']
                ld      e,a                     ; direc_y [E'] = SGN(y) installed
                call    abs
                push    hl
                exx
                
                pop     de                      ; DE = absolute y distance
                pop     hl                      ; HL = absolute x distance

                        ;call    l_cmp           ; CMP HL,DE  [carry set if DE < HL]

                        ld	a,d					; CMP DE,HL  [carry set if HL < DE]
                        add	$80
                        ld	b,a
                        ld	a,h
                        add	$80
                        cp	b
                        jr     nz,noteq
                        ld     a,l
                        cp     e
;						jr      z, exit_draw        ; if x+y = 0 then return
.noteq
                        jr      c, x_smaller_y         ; if x > y
								ld a,d
								or e
								or h
								or l
								
								jr      z, exit_draw        ; if x+y = 0 then return	                                
                                                            ;       else
                                exx
                                ld      b,d                     ;       ddx = direc_x
                                ld      c,2                     ;       ddy = zero
                                exx
                                jr      init_drawloop   ; else
.x_smaller_y
                                ex	de,hl			;       invert x,y
                                
                                exx
                                ld      b,2                     ;       ddx = zero
                                ld      c,e                     ;       ddy = direc_y
                                exx

.init_drawloop          ld      b,h
                        ld      c,l             ; BC = HL

                        srl     h               ; i = INT(BC/2)
                        rr      l
                        push    hl
                        pop     iy

                        ld      h,b
                        ld      l,c
;-------------- -------------- -------------- --------------
.drawloop               push    bc              ; FOR N=BC TO 1 STEP -1

                        add     iy,de                   ; i = i + DE
                        
                        ; cmp hl,iy						
						ld	a,iyh
						add	$80
						ld	b,a
						ld	a,h
						add	$80
						cp	b
						jr nz,noteq2
						;ret	nz
						ld	a,l
						cp	iyl

.noteq2
                        jp      c, i_greater           ;       if i < HL

                                exx
                                push    bc                      ;       inx = ddx: iny = ddy
                                exx
                                jp      check_plot      ;       else
.i_greater
								
								ld a,iyl                        ; (IY)  i = i - HL
								sub   l
								ld iyl,a
								ld a,iyh
								sbc	a,h
								ld iyh,a
								
                                exx
                                push    de                      ;       inx = direc_x: iny = direc_y
                                exx                     ;       endif

.check_plot
                        ex      (sp),hl                 ;       preserve distances on stack
                        push    de
;                        ex      de,hl                   ;       D,E = inx, iny

			ld	de,(__gfx_coords+2)           ;       y0 = y0 + iny (range is checked by plot func.)
			dec	l			;       iny
			jp	z,incy
			dec	l
			jp	z,zy
			dec	de
			dec	de
.incy			inc	de
.zy
			ld	a,h
			ld	hl,(__gfx_coords)             ;       x0 = x0 + inx (range is checked by plot func.)
			dec	a			;       inx
			jp	z,incx
			dec	a
			jp	z,zx
			dec	hl
			dec	hl
.incx			inc	hl
.zx

.plot_point             ld      bc, plot_RET
                        push    bc                      ;       hl,de = (x0,y0)...
                        jp      (ix)                    ;       execute PLOT at (x0,y0)
.plot_RET
                        pop     de                      ;       restore distances...
                        pop     hl
                        
                        pop     bc
                        dec     bc
                        ld      a,b
                        or      c
                        jp      nz,drawloop     ; NEXT N
;-------------- -------------- -------------- --------------
.exit_draw
                        ret

;.exit_draw              pop     hl              ; restore relative horizontal distance
;                        pop     de              ; restore relative vertical distance
;                        pop     bc
;                        ret


; ******************************************************************************
;
;       SGN (Sign value) of 16 bit signed integer.
;
;       IN:             HL = integer
;       OUT:            A = result: 2,1,-1 (if zero, positive, negative)
;
;       Registers       changed after return:
;       ..BCDEHL/IXIY   same
;       AF....../....   different
;
.sgn                    ld      a,h
                        or      l
                        ld	a,2
                        ret     z               ; integer is zero, return 0...
                        bit     7,h
                        jr      nz,negative_int
                        dec	a		; 1
                        ret
.negative_int           ld      a,-1
                        ret


; ******************************************************************************
;
;       ABS (Absolute value) of 16 bit signed integer.
;
;       IN:             HL =    integer
;       OUT:            HL =    converted integer
;
;       Registers       changed after return:
;       A.BCDE../IXIY   same
;       .F....HL/....   different
;
.abs                    bit     7,h
                        ret     z               ; integer is positive...
                        push    de
                        ex      de,hl
                        xor     a               ; Fc=0
                        ld      h,a
                        ld      l,a
                        sbc     hl,de           ; convert negative integer
                        pop     de
                        ret
