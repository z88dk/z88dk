; CALLER linkage for function pointers

PUBLIC ba_AddMem
EXTERN BAAddMem

.ba_AddMem

   ld hl,8
   add hl,sp
   ld c,(hl)
   dec hl
   dec hl
   ld b,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp BAAddMem
