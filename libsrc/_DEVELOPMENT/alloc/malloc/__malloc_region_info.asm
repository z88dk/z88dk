
XLIB __malloc_region_info

__malloc_region_info:

   ; Return information about region
   ;
   ; enter : hl = & region
   ;
   ; exit  : carry reset
   ;
   ;         success
   ;
   ;           nz flag set
   ;           hl = current region size
   ;           de = & next region
   ;
   ;         fail
   ;
   ;           z flag set if not a region
   ;
   ; uses  : af, de, hl
   
   ld a,h
   or l
   ret z                       ; not a region
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = & next region
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = size of region in bytes
   
   ret
