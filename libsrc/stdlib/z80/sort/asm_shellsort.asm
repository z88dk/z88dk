; ===============================================================
; October 2026
; ===============================================================
;
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
;
; Shellsort with gaps n/2, n/4, ... 1. State lives on the stack and in
; the alternate register set, so a comparator may call shellsort again.
;
; IX stays the comparator. The alternate set during a pass is:
;   bc' = gap in bytes
;   de' = end (one past the last byte)
;   hl' = base
; Those three are pushed around the compare call. The caller's
; alternate set is saved for the whole sort.
;
; AF' is not used. The ZX81 NMI keeps a display line count in AF' and
; does not save the caller's copy. IY is not used.
;
; Classic qsort links asm_quicksort and does not include this file.
; The __CLASSIC comparator path stays so one core still serves both.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_shellsort

EXTERN l_mulu_16_16x16, asm0_memswap
EXTERN error_einval_zc, error_erange_zc

IF __CLASSIC
   EXTERN l_jpix
ELSE
   EXTERN l_compare_de_hl
ENDIF

asm_shellsort:

   ; enter : ix = int (*compar)(de=const void *, hl=const void *)
   ;         bc = void *base
   ;         hl = size_t nmemb
   ;         de = size_t size
   ;
   ; exit  : none
   ;
   ;         einval if size == 0
   ;         erange if nmemb * size overflows 16 bits
   ;         erange if base + nmemb * size wraps
   ;
   ; uses  : af, bc, de, hl, compare function

   ld a,d
   or e
   jp z, error_einval_zc       ; size == 0

   ld a,h
   or l
   ret z                       ; nmemb == 0

   dec hl
   ld a,h
   or l
   ret z                       ; nmemb == 1

   inc hl                      ; hl = nmemb >= 2

   ; caller's alternate set, restored on every exit after this point
   exx
   push bc
   push de
   push hl
   exx

   ; frame above that, low address first:
   ;   sp+0 end
   ;   sp+2 base
   ;   sp+4 gap_elems

   push hl                     ; gap_elems = nmemb
   push bc                     ; base
   ; hl = nmemb, de = width. The 8-bit multiply swaps de when
   ; width < 256 and nmemb >= 256, so keep width across the call.
   push de
   call l_mulu_16_16x16
   pop de                      ; width. pop does not change flags
   jp c, fail_mul              ; stack = base, gap_elems, caller exx

   pop bc                      ; base
   add hl,bc                   ; hl = end
   jp c, fail_end              ; stack = gap_elems, caller exx

   push bc                     ; base
   push hl                     ; end
   ld c,e
   ld b,d                      ; bc = width

   ; gap_elems is under end and base.

gap_loop:

   ld hl,4
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = gap_elems
   srl d
   rr e
   ld (hl),d
   dec hl
   ld (hl),e
   ld a,d
   or e
   jp z, done

   push bc                     ; width
   ld l,e
   ld h,d                      ; hl = gap_elems
   ld e,c
   ld d,b                      ; de = width
   call l_mulu_16_16x16        ; hl = gap bytes
   pop bc                      ; width
   jp c, fail_frame

   ; bc' = gap, de' = end, hl' = base. Width stays in bc.
   push bc                     ; width
   ld c,l
   ld b,h                      ; bc = gap
   ld hl,2
   add hl,sp                   ; pushed width, then end
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = end
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = base
   push hl
   push de
   push bc
   exx
   pop bc                      ; gap
   pop de                      ; end
   pop hl                      ; base
   exx
   pop bc                      ; width

   push bc
   exx
   push hl                     ; base
   push bc                     ; gap
   exx
   pop bc                      ; gap
   pop hl                      ; base
   add hl,bc                   ; hl = i = base + gap
   pop bc                      ; width
   jp c, fail_frame

i_loop:

   ; hl = i, bc = width, ix = compar
   ; bc' = gap, de' = end, hl' = base

   push hl
   exx
   push de                     ; copy end
   exx
   pop de
   pop hl                      ; hl = i, de = end
   ld a,l
   sub e
   ld a,h
   sbc a,d
   jr nc, gap_loop             ; i >= end

   push hl                     ; save i
   ld d,h
   ld e,l                      ; de = right = i
   push bc
   exx
   push bc                     ; copy gap
   exx
   pop bc
   or a
   sbc hl,bc                   ; hl = left = i - gap
   pop bc                      ; width

j_loop:

   ; hl = left, de = right, bc = width
   ; stack = i, end, base, gap_elems, caller exx

   exx
   push bc
   push de
   push hl
   exx

IF __CLASSIC
   call l_jpix
ELSE
   call l_compare_de_hl        ; p set when right >= left
ENDIF

   exx
   pop hl
   pop de
   pop bc
   exx
   jp p, next_i                ; exx and pop do not change flags

   push bc
   call asm0_memswap           ; hl = left on exit
   pop bc                      ; width

   ld d,h
   ld e,l                      ; right = old left
   push bc
   exx
   push bc                     ; copy gap
   exx
   pop bc
   or a
   sbc hl,bc                   ; left -= gap
   pop bc
   jr c, next_i                ; stepped below address 0

   push de                     ; right must survive the test
   push hl
   exx
   push hl                     ; copy base
   exx
   pop de                      ; de = base
   pop hl                      ; hl = left
   ld a,l
   sub e
   ld a,h
   sbc a,d
   pop de                      ; de = right. pop does not change flags
   jr nc, j_loop               ; left >= base

next_i:

   pop hl                      ; i
   add hl,bc                   ; i += width
   jp nc, i_loop
   jp fail_frame

done:

   ; stack = end, base, gap_elems, caller exx
   pop hl
   pop hl
   pop hl

restore_exx:

   exx
   pop hl
   pop de
   pop bc
   exx
   ret

fail_mul:

   ; stack = base, gap_elems, caller exx
   pop hl
   pop hl
   jr fail_errno

fail_end:

   ; stack = gap_elems, caller exx
   pop hl
   jr fail_errno

fail_frame:

   ; stack = end, base, gap_elems, caller exx
   ; i is not on the stack
   pop hl
   pop hl
   pop hl

fail_errno:

   exx
   pop hl
   pop de
   pop bc
   exx
   jp error_erange_zc
