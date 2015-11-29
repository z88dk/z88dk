
SECTION code_clib
SECTION code_l

PUBLIC l_command_line_parse_in_place

EXTERN asm_isspace

l_command_line_parse_in_place:
   
   ; * parse command line into words in place
   ; * return argc and argv
   ; * return pointer to redirector string if '>' or '<' found
   ; * command line length capped at 255 chars
   ;
   ; enter : hl = & command line
   ;         bc = number of chars in command line
   ;
   ; note  : *(hl+bc) will be set to 0
   ;
   ; exit  : bc    = int argc
   ;         hl    = char *argv[]
   ;         hl'   = & redirector in command line (0 if none)
   ;         bc'   = num chars remaining in redirector (0 if none)
   ;         de'   = address of empty string
   ;
   ; note  : on exit if there is a redirector, must 0 the
   ;         redirector byte after examining it.
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

   pop ix                      ; ix = return address

   ; initialize redirector pointers
   
   xor a
   
   exx

   ld c,a
   ld b,a                      ; bc'= chars remaining in redirector
   
   push bc                     ; argv[argc] = NULL
   
   ld hl,0
   add hl,sp
   
   ex de,hl                    ; de'= & ""

   ld l,a
   ld h,a                      ; hl'= & redirector in command line

   exx

   ; find end of command line
   
   ; hl = & command line
   ; bc = num chars remaining in command line
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address

   ld e,a
   ld d,a
   
   ld a,b
   or c
   jr z, argv_finished         ; if there is no command line

find_end:

   ld a,(hl)
   
   cp '>'
   jr z, redirector
   
   cp '<'
   jr nz, find_cont

redirector:

   push bc
   push hl
   
   exx
   
   pop hl                      ; hl'= & redirector
   pop bc                      ; bc'= num chars remaining in redirector
   
   exx
   
   jr found_end

find_cont:

   inc de
   
   cpi                         ; hl++, bc--
   jp pe, find_end

   ld (hl),0

found_end:

   ld c,e
   ld b,d
   
   ; hl = & last char in command line + 1
   ; bc = number of chars in command line
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address

   ; work command line backwords

   ld de,0                     ; de = word_count
   inc bc
   
word_loop:

   cpd                         ; hl--, bc--
   jp po, argv_finished        ; if reached beginning of command line

   ld a,(hl)
   call asm_isspace

   jr c, word_found            ; not space, end of word found

word_terminate:

   ld (hl),0
   jr word_loop

word_found:

   inc de                      ; word_count++
   
word_begin_loop:

   cpd                         ; hl--, bc--
   jp po, generate_last_argv   ; if reached beginning of command line

   ld a,(hl)
   call asm_isspace
   
   jr nc, word_begin_loop      ; if next char is not space, word continues

   inc hl
   push hl                     ; save start of word to argv[]
   dec hl
   
   jr word_terminate

generate_last_argv:

   inc hl
   push hl                     ; save argv[]

argv_finished:

   ld c,e
   ld b,d

   ; bc = argc = word count
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address
   ; stack = argv[]

   ld hl,0
   add hl,sp                   ; hl = &argv[0]

   jp (ix)
