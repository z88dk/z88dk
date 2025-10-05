
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_init

EXTERN mtx_recursive, asm_mtx_init

__stdio_file_init:

   ; initialize FILE struct
   ;
   ; enter : hl = FILE *
   ;         de = FDSTRUCT *
   ;          c = mode byte (only RW matter)
   ;          b = FILE type (bit 5 = 0 means stdio handles unget from eatc)
   ;
   ; exit  : hl = FILE *
   ;
   ; uses  : af, bc, de

   push hl                     ; save FILE*
   
   ld (hl),195                 ; JP
   inc hl
   
   ld (hl),e                   ; FDSTRUCT *
   inc hl
   ld (hl),d
   inc hl
   
   ld a,c
   rrca
   rrca
   and $c0
   or b                        ; add FILE type
   ld (hl),a                   ; state_flags_0
   inc hl
   
   ld a,c
   rla
   and $02
   ld (hl),a                   ; state_flags_1
   inc hl
   
   inc hl
   inc hl
   
   ld c,mtx_recursive
   call asm_mtx_init

   pop hl                      ; hl = FILE*
   ret
