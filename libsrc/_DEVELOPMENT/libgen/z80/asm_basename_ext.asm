; char *basename_ext(char *path)

SECTION code_string

PUBLIC asm_basename_ext

EXTERN __lg_remove_tail, __str_locate_nul

asm_basename_ext:

   ; point to "." in extension or terminator if no extension found 
   ; may modify path to eliminate trailing slashes
   ;
   ; enter : hl = char *path
   ;
   ; exit  : hl = char *ext
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save path

   call __lg_remove_tail
   ex de,hl
   
   ; de = last char in path
   ; bc = chars remaining in path

   pop hl
   jp nc, __str_locate_nul     ; if path does not contain a basename
   
   ld l,e
   ld h,d
   
   inc de                      ; de = address of terminator

loop:

   ld a,(hl)
   
   cp '.'
   ret z                       ; if extension found
   
   cp '/'
   jr z, no_extension

IF __CPU_GBZ80__ | __CPU_INTEL__
   dec hl
   ld a,b
   or c
   jr z,no_extension
   dec bc
   jr  loop
ELSE

   
   cpd                         ; hl--, bc--
   jp pe, loop
ENDIF

no_extension:

   ex de,hl                    ; return address of terminator
   ret
