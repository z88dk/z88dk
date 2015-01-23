; int __CALLEE__ vfscanf_callee(FILE *stream, const char *format, void *arg_ptr)
; 05.2008 aralbrec

PUBLIC vfscanf_callee
PUBLIC ASMDISP_VFSCANF_CALLEE, LIBDISP_VFSCANF_CALLEE

EXTERN stdio_atou, stdio_error_mc, stdio_error_eacces_mc
EXTERN asm_isspace, asm_isdigit
EXTERN stdio_getchar, stdio_ungetchar
EXTERN jumptbl_scanf, stdio_consumews

.vfscanf_callee

   pop hl
   pop bc
   pop de
   pop ix
   push hl

.asmentry

   ; enter : ix  = FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of conversions done, carry reset
   ;         hl  = -1 and carry if error

   bit 2,(ix+3)                ; open for input?
   jp z, stdio_error_eacces_mc

.libentry

   ; second entry point with ix equal to function address
   ;
   ; enter : ix  = FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of conversions done
   ;         hl  = -1 and carry if error

   push bc

   exx
   ld bc,0
   ld e,c
   ld d,b
   exx
   
   ; bc' = 0 = number of chars read from stream
   ; de' = 0 = number of conversions done
   ; ix  = FILE *
   ; de  = format string
   ; stack = & parameter list

.scanloop

   ; de = pointer in format string
   ; stack = & parameter list

   ld a,(de)                   ; next format char
   or a                        ; end of format string?
   jr z, exit

   inc de
   cp '%'                      ; is it a format specifier?
   jr z, specifier

   ld c,a
   call asm_isspace          ; is it a whitespace char?
   jr z, consumews

.ordinarychar

   call stdio_getchar          ; a = char from stream
   jr c, exit                  ; input stream reached EOF
   
   cp c                        ; format char and stream char match?
   jr z, scanloop
   
   call stdio_ungetchar        ; return unmatched char to stream
   
.exit

   ; ISO C has us exit with # conversions done
   ; or -1 if no chars were read from the input stream
   
   pop hl                      ; trash parameter list
   exx
   ld a,b
   or c                        ; chars read from stream == 0?
   push de                     ; push number of conversions done
   exx
   pop hl                      ; hl = number of conversions done
   ret nz                      ; if at least one char read from stream, return # conversions
   jp stdio_error_mc
   
.consumews

   call stdio_consumews        ; consume whitespace from input stream
   jp scanloop

.specifier

   ; read format specifiers
   ; % {flags} [*] [width] [l] "[diouxXeEfFscpPbn"

   ld c,0

   ; de = pointer in format string (next char)
   ;  c = flags [000a*WL0]
   ; stack = & parameter list

.flagloop

   ld a,(de)
   
   cp 'a'
   jr nz, nextflag0
   set 4,c
   inc de
   jp flagloop

.nextflag0

   cp '*'
   jr nz, width
   set 3,c
   inc de
   jp flagloop

.width

   ; de = pointer in format string (next char)
   ;  c = flags [000a*WL0]
   ; stack = & parameter list

   ld b,0                      ; infinite width is default
   ld a,(de)
   call asm_isdigit
   jr c, formatchar            ; if width field is not present
   
   set 2,c                     ; set width flag
   push bc
   call stdio_atou
   pop bc
   ld b,l
   
.formatchar

   ;  b = width
   ; de = pointer in format string
   ;  c = flags [000a*WL0]
   ; stack = & parameter list

   ld a,(de)                   ; check for long specifier
   cp 'l'
   jr nz, nolongspec
   inc de
   set 1,c
   
.nolongspec

   ld hl,jumptbl_scanf
   ex de,hl

   ;  b = width
   ; hl = pointer in format string
   ;  c = flags [000a*WL0]
   ; de = & vfprintf_jumptbl
   ; stack = & parameter list

.specsrch

   ld a,(de)                   ; table's format char
   or a
   jr z, fmtcharerror
   
   cp (hl)
   jr z, fmtcharfound
   
   inc de                      ; next table entry
   inc de
   inc de
   inc de
   jp specsrch
   
.fmtcharerror

   ; unrecognized format char
   
   ex de,hl
   ld a,(de)
   cp '%'
   jr nz, exit
   ld c,a
   inc de
   jp ordinarychar

.fmtcharfound

   inc hl                      ; consume format char
   ex (sp),hl
   call doformat

   pop de
   push hl
   
   ; de = format string
   ; stack = & parameter list
   
   jp nc, scanloop             ; if no error continue
   jp exit

.doformat

   ;  b = width
   ; hl = & parameter list
   ;  c = flags [000a*WL0]
   ; de = & vfscanf_jumptbl.fmtchar
   ; stack = pointer in format string, ret
   
   inc de
   push de

   ; set-up for formatted input functions
   ;
   ; enter :     ix  = FILE *
   ;               b = width
   ;               c = flags [000a*WL0]
   ;              hl = & parameter list
   ;             bc' = total num chars read from stream thus far
   ;             de' = number of conversions done thus far
   ; on exit :   bc' = total num chars read from stream thus far
   ;             de' = number of conversions done thus far
   ;              hl = & parameter list
   ;             carry set if EOF reached
   ;
   ; MUST NOT ALTER HL' FOR SSCANF FAMILY

   ret

defc ASMDISP_VFSCANF_CALLEE = # asmentry - vfscanf_callee
defc LIBDISP_VFSCANF_CALLEE = # libentry - vfscanf_callee
