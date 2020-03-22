SECTION code_string

PUBLIC __lg_remove_tail

EXTERN asm_strlen, asm_isspace
EXTERN __lg_return_dot, __lg_return_slash

__lg_remove_tail:

   ; remove trailing whitespace and slashes
   ;
   ; enter : hl = char *path
   ;
   ; exit  : de = char *path
   ;
   ;         carry set
   ;
   ;             a = last char in path
   ;            hl = ptr to last char in path
   ;            bc = number of chars remaining prior to and including hl
   ;
   ;         carry reset
   ;
   ;            hl = "." or "/"
   ;            (result of basename or dirname)
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h                      ; de = char *path

   ld a,h
   or l
   jp z, __lg_return_dot       ; if path == NULL
   
   call asm_strlen
   jp z, __lg_return_dot       ; if zero length
   
   ld c,l
   ld b,h                      ; bc = strlen(path) > 0
   
   add hl,de
   dec hl                      ; hl = ptr to last char in path
   
   ; remove trailing whitespace
   
   call skip_trailing_ws
   jp nc, __lg_return_dot      ; if all whitespace
   
   ; remove trailing slashes
   
   cp '/'
   jr nz, terminate

   call skip_trailing_slash
   jp nc, __lg_return_slash    ; if only slashes left

terminate:

   ; terminate path

   inc hl
   ld (hl),0
   dec hl

   scf
   ret

skip_trailing_ws:

   ; skip trailing whitespace

   ld a,(hl)
   
   call asm_isspace
   ret c                       ; if char is not whitespace
  
IF __CPU_GBZ80__ | __CPU_INTEL__
   dec hl
   ld a,b
   or c
   ret z
   dec bc
   jr  skip_trailing_ws
ELSE 
   cpd                         ; hl--, bc--
   jp pe, skip_trailing_ws
   
   ret
ENDIF

skip_trailing_slash:

   ; skip trailing slashes
   ; carry reset

IF __CPU_GBZ80__ | __CPU_INTEL__
   dec hl
   ld a,b
   or c
   ret z
   dec bc
ELSE

   cpd                         ; hl--, bc--
   ret po
ENDIF
   
   ld a,(hl)
   
   cp '/'
   jr z, skip_trailing_slash
   
   scf
   ret
