
SECTION code_clib
SECTION code_l

PUBLIC l_eat_base_prefix

EXTERN asm_tolower

l_eat_base_prefix:

   ; skip past base prefix in number string
   ;
   ; if base == 0 determines the base from the leading prefix
   ; if base == 16 consumes an optional leading 0x
   ;
   ; enter :  a = base (0 means determine base from prefix)
   ;         hl = char *
   ;
   ; exit  :  a = base (possibly modified)
   ;         hl = char * (next char to interpret past prefix)
   ;
   ; uses  : af, hl
   
   or a
   jr z, determine_base
   
   cp 16
   ret nz
   
   ; consume optional leading 0x for hex numbers
   
   ld a,(hl)
   cp '0'
   jr nz, hex_0

   inc hl
   ld a,(hl)
   call asm_tolower
   cp 'x'
   dec hl
   jr nz, hex_0

   inc hl                      ; point at x

hex_2:

   inc hl                      ; point after 0x

hex_0:

   ld a,16
   ret

determine_base:

   ld a,(hl)
   cp '0'                      ; no leading 0 means decimal
   ld a,10
   ret nz
   
   inc hl
   ld a,(hl)
   call asm_tolower
   cp 'x'                      ; 0x means hex
   jr z, hex_2
   
   dec hl
   ld a,8                      ; else leading 0 means octal
   ret
