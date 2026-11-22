
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_length_modifier

__stdio_length_modifier:

   ; enter :  de = char *
   ;
   ; exit  :  de = char *, advanced past lm
   ;
   ;          if length modifier not found
   ;
   ;             c = 0
   ;
   ;          if length modifier found
   ;
   ;             c = length modifier id (below)
   ;
   ;             $01 = L
   ;             $02 = h
   ;             $04 = hh
   ;             $08 = j
   ;             $10 = l
   ;             $20 = ll
   ;             $40 = t
   ;             $80 = z
   ;
   ; uses  : af, bc, de, hl

   ld hl,lm_chars
   ld b,6

   ld a,(de)

lm_loop:

   cp (hl)
   inc hl
   
   jr z, lm_found

   inc hl
   djnz lm_loop

   ld c,0
   ret

lm_found:

   ld c,(hl)                   ; c = length modifier id
   inc de                      ; consume length modifier

   cp 'l'   
   jr z, lm_double
   
   cp 'h'
   ret nz

lm_double:

   ld b,a
   ld a,(de)
   
   cp b
   ret nz
   
   inc de                      ; consume second 'l' or 'h'

   ld a,c
   add a,a
   ld c,a
   
   ret

lm_chars:

   defb 'l', $10
   defb 'L', $01
   defb 'h', $02
   defb 'j', $08
   defb 't', $40
   defb 'z', $80
