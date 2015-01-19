;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "stdio.def"

                PUBLIC    putn    ;Display integer


;Display an integer on screen..

.putn
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
;Now, our kludgy number print..
        ld      b,254
        ld      de,10000
        call    numcal
        ld      de,1000
        call    numcal
        ld      de,100
        call    numcal
        ld      de,10
        call    numcal
        ld      de,1
        ld      b,0
;b=0 print norm, b=255 do space
;b=254 don't print
          
.numcal   ld    a,255  
.numca1   inc   a  
          and   a  
          sbc   hl,de  
          jr    nc,numca1  
          add   hl,de  
          and   a  
          jr    z,numca2  
          ld    b,0  
.numca2   add   a,48  
          ld    c,a  
          ld    a,b  
          and   a  
          jr    z,numca3  
          inc   a  
          ret   nz  
          ld    c,32  
.numca3   ld    a,c  
        call_oz(os_out)
        ret



