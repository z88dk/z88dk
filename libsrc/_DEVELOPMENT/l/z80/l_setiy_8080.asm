SECTION code_clib
SECTION code_l

PUBLIC l_setiy_8080
EXTERN l_jpiy_8080

l_setiy_8080:
  push af
  ld a,l
  ld (l_jpiy_8080+1),a
  ld a,h
  ld (l_jpiy_8080+2),a
  pop af
  ret
