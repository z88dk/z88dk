;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: window.asm,v 1.3 2016-05-17 21:43:06 dom Exp $
;

;       This function will open a window of any type (graphics/text)
;       on the Z88 screen, graphics flag states gfx or text
;

;Usage: window(struct *windst)
;
;These are offset by 32 as per usual on a z88.
;
;struct window {
;       char windnumber;
;       char x;
;       char y;
;       char width;
;       char depth;
;       char type;
;       char graphics;  0=text, 1=graphics
;} ;



                INCLUDE "graphics/grafix.inc"    ; Contains fn defs

                INCLUDE "stdio.def"
                INCLUDE "map.def"
                INCLUDE "screen.def"

		SECTION	code_clib

                PUBLIC    window
                PUBLIC    _window
                
                EXTERN    base_graphics
                PUBLIC	  gfx_bank
		EXTERN	  z88_map_segment

.window
._window
                pop     bc
                pop     hl
                push    hl
                push    bc
		push	ix	;save ix
		push	hl
		pop	ix
;ix is address of struct..
                ld      a,(ix+graph)
                and     a
                jr      nz,opengfx
                
                ld      hl,initwind
                call_oz(gn_sop)
                push    ix
                pop     hl
                call_oz(gn_sop)
                ld      hl,0            ;All good, return NULL
		pop	ix
                ret



.opengfx
                ld      l,(ix+wind_w)
                ld      h,0
                ld      a,l
                and     a
                ld      a,(ix+windnum)      ;window number
                ld      bc,mp_def       ;define map based on pipedream
                jr      z,opengfx1
                ld      bc,mp_gra       ;user width
.opengfx1
                call_oz(os_map)         ;opened the window
                ld      hl,1
                jr	c,opengfx_exit               ;error, return TRUE
;Now get the address of the map
                ld   b,0
                ld   hl,0               ; dummy address
                ld   a,sc_hr0
                call_oz(os_sci)         ; get base address of map area (hires0)
                push bc
                push hl
                call_oz(os_sci)         ; (and re-write original address)
                pop  hl
                pop  bc
;Page in the map page so it's always there..errkk!
                ld      a,b
                ld      (gfx_bank),a
                ld   a,h
                and  63                 ;mask to bank
                or   z88_map_segment            ;mask to segment map_seg
                ld      h,a
                ld      (base_graphics),hl
                ld      hl,0            ;NULL=good
.opengfx_exit
		pop	ix
                ret

		SECTION	rodata_clib
.initwind       defb    1,'7','#',0

		SECTION bss_clib

.gfx_bank       defb    0       ;Bank that this is in
