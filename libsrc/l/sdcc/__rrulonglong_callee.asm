
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __rrulonglong_callee

EXTERN l_lsr_dehldehl, l_store_64_dehldehl_mbc

__rrulonglong_callee:

   ; logical shift right 64-bit number
   ;
   ; enter :         +--------------------------
   ;                 | +12  shift amount
   ;         stack = |--------------------------
   ;                 | +11
   ;                 | ...  longlong n (8 bytes)
   ;                 | +4
   ;                 |--------------------------
   ;                 | +3
   ;                 | +2   result *
   ;                 |--------------------------
   ;                 | +1
   ;                 | +0   return address
   ;                 +--------------------------
   ;
   ; exit  : stack cleared
   ;         *result = n << s
   ;
   ; uses  : af, bc, de, hl, af', de', hl'
   
   pop af                      ; af'= return address
   ex af,af'
   
   pop bc                      ; bc = result *
   
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx                         ; dehl'dehl = longlong n
   
   dec sp
   pop af                      ; a = shift amount

   ex af,af'
   push af
   ex af,af'
   
   push bc                     ; save result *
   
   call l_lsr_dehldehl         ; dehl'dehl >>= shift amount
   
   pop bc                      ; bc = result *
   jp l_store_64_dehldehl_mbc  ; store result
