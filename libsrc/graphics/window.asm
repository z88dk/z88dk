;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
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



                INCLUDE "graphics/grafix.inc"    /* Contains fn defs */

                INCLUDE "#stdio.def"
                INCLUDE "#map.def"
                INCLUDE "#screen.def"


                XLIB    window
                
                XREF    base_graphics
                XREF    gfx_bank

.window
                pop     bc
                pop     ix
                push    ix
                push    bc
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
                ret

.initwind       defb    1,'7','#',0


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
                ret     c               ;error, return TRUE
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
;                ld      a,(map_bk)
;                ld      (oldozbank),a
                ld      a,b
                ld      (gfx_bank),a
;                ld      (map_bk),a
;                out     (map_bk-$400),a

                ld   a,h
                and  63                 ;mask to bank
                or   map_seg            ;mask to segment map_seg
                ld      h,a
                ld      (base_graphics),hl
                ld      hl,0            ;NULL=good
                ret

