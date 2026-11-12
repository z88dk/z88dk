;       Startup for NEC PC6001 computers
;
;       Stefano Bodrato - Jan 2013
;
;       If an error occurs eg break we just drop back to BASIC
;
;       The startups are one file each:
;         1, 2, 3  basic.asm        programs loaded by BASIC from tape: 16K
;         ($C437), 32K ($8437) and the mkII's N60m BASIC ($8037)
;         4        rom.asm          a cartridge at $4000
;         5        allrammk2.asm    a PC-6001mkII boot disc: the whole machine,
;         all RAM (-subtype=mk2disc)
;       and rom.asm and allrammk2.asm take the mkII's 320x200 console and
;       graphics (mk2.inc) with -clib=mk2.
;
;       $Id: pc6001_crt0.asm,v 1.11 2016/07/11 21:19:38 dom Exp $
;


    MODULE      pc6001_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc        crt0=1
    INCLUDE     "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN      _main                   ; main() is always external to crt0 code

    PUBLIC      __Exit                  ;jp'd to by exit()
    PUBLIC      l_dcal                  ;jp(hl)

    INCLUDE     "target/pc6001/def/pc6001.def"

  IF    (startup=4)
    INCLUDE     "target/pc6001/classic/rom.asm"
  ELIF  (startup=5)
    INCLUDE     "target/pc6001/classic/allrammk2.asm"
  ELSE
    INCLUDE     "target/pc6001/classic/basic.asm"
  ENDIF

    INCLUDE     "crt/classic/crt_runtime_selection.inc"
    INCLUDE     "crt/classic/crt_section.inc"

    INCLUDE     "crt/classic/mc6847/mc6847_mode_disable.inc"

; (the boot sector is the last thing: it is a section of its own at $F900)
  IF    (startup=5)
    INCLUDE     "target/pc6001/classic/bootstrap_mk2.asm"
  ENDIF
