
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))
;
; Perform a binary search on a sorted array of items.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_bsearch
PUBLIC asm0_bsearch

EXTERN error_zc, l_mulu_16_16x16, l_compare_de_hl, l_inc_sp

asm_bsearch:

   ; enter : hl = nmemb
   ;         de = size
   ;         bc = base
   ;         af = key
   ;         ix = compare
   ;
   ; exit  : ix = compare
   ;
   ;         success
   ;
   ;           carry reset
   ;           hl = address of item in array = p
   ;
   ;         fail
   ;
   ;           carry set
   ;           hl = 0
   ;           bc = address of an item in array next to where key should be found
   ;           de = size
   ;
   ; uses  : af, bc, de, hl

   push af

asm0_bsearch:
bsearch_loop:

   ld a,h
   or l
   jp z, error_zc - 1

   ; de = size
   ; bc = base
   ; hl = lim
   ; ix = compare
   ; stack = key
  
   pop af
   push hl
   push bc
   push de
   push af
   push bc
   
   srl h
   rr l

   ; hl = lim>>1
   ; de = size
   ; ix = compare
   ; stack = lim, base, size, key, base
   
   call l_mulu_16_16x16        ; hl = hl * de = (lim >> 1) * size
   
   pop de                      ; de = base
   add hl,de                   ; hl = p = base + (lim >> 1) * size
   pop de                      ; de = key

   call l_compare_de_hl        ; (compar)(de = void *key, hl = void *p)

   ; hl = p
   ; de = key
   ; ix = compare
   ; stack = lim, base, size
   
   jp p, key_greater_equal
   
key_less:

   ; de = key
   ; ix = compare
   ; stack = lim, base, size

   ex de,hl
   pop de
   pop bc
   ex (sp),hl
   
   ; de = size
   ; bc = base
   ; hl = lim
   ; ix = compare
   ; stack = key

   srl h
   rr l
   
   jr bsearch_loop

key_greater_equal:

   ; hl = p
   ; de = key
   ; ix = compare
   ; stack = lim, base, size

   or a
   jp z, l_inc_sp - 6          ; if item found
   
key_greater:

   pop bc
   push bc
   
   add hl,bc
   ld c,l
   ld b,h
   
   pop hl
   ex de,hl
   
   pop af
   ex (sp),hl
   
   dec hl
   
   srl h
   rr l
   
   ; de = size
   ; bc = base
   ; hl = lim
   ; ix = compare
   ; stack = key
   
   jr bsearch_loop
   
; ============================================================
;
;void * bsearch(
;   register const void *key,
;   const void *base0,
;   size_t nmemb,
;   register size_t size,
;   register int (*compar)(const void *key, const void *b))
;{
;   for (lim = nmemb; lim != 0; lim >>= 1)
;   {
;      p = base + (lim >> 1) * size;
;      
;      cmp = (*compar)(key, p);
;      
;      if (cmp == 0) return ((void *)p);
;      
;      if (cmp > 0)
;      {	
;         /* key > p: move right */
;         
;         base = (char *)p + size;
;         lim--;
;      }
;      
;      /* else move left */
;      
;   }
;
;   return 0;
;}
