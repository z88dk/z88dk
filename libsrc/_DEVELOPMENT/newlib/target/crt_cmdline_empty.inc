
      ; generate an empty command line on the stack

      ld hl,0
      push hl                  ; argv[argc] = NULL
      add hl,sp
      push hl                  ; argv[0] = ""
      dec hl
      dec hl                   ; hl = argv
      ld bc,1                  ; bc = argc = 1

      ; hl = char **argv
      ; bc = int argc
