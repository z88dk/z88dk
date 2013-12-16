
XLIB __malloc_region_locate
LIB __malloc_region_info

LIB error_zc

__malloc_region_locate:

   ; Find region in the heap that could contain memory address p.
   ; Regions are linked in order of increasing address.
   ;
   ; enter : bc = void *p
   ;         hl = & region
   ;
   ; exit  : bc = void *p
   ;
   ;         success
   ;
   ;           carry reset
   ;           de = & region containing p
   ;
   ;         fail
   ;
   ;           carry set
   ;
   ; uses   : af, de, hl

region_loop:

   push hl                     ; save region

   call __malloc_region_info
   jp z, error_zc - 1          ; p does not belong to any region
   
   ex de,hl
   ex (sp),hl
   push hl
   
   ; bc = void *p
   ; de = region size
   ; hl = & region
   ; stack = & next region, & region
   
   add hl,de                   ; hl = & one byte past region
   
   scf
   sbc hl,bc                   ; if p < end of region, p must be in region
   
   pop hl                      ; hl = region
   pop de                      ; de = & next region
   
   ex de,hl
   jp c, region_loop

possible_region:

   ; de = & region
   ; bc = void *p
   
   ; p must be greater than region start
   
   ld l,c
   ld h,b
   
   sbc hl,de                   ; carry set if p not in region
   ret
