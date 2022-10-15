SECTION code_clib
SECTION code_l

PUBLIC l_setix_8080
EXTERN l_jpix_8080

l_setix_8080:
  push af
  ld a,l
  ld (l_jpix_8080+1),a
  ld a,h
  ld (l_jpix_8080+2),a
  pop af
  ret
