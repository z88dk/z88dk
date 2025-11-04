;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;       Amstrad NC version by Stefano - 2017
;
;
;	$Id: __gfx_vram_page_in.asm $
;

    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out

    EXTERN  NC_VRAM_SEGMENT


__gfx_vram_page_in:
___gfx_vram_page_in:
  IF    FORzcn
    RET
  ELSE
    LD      A, ($B000 + NC_VRAM_SEGMENT)
    LD      (pgsave), A
    LD      A, 67
    LD      ($B000 + NC_VRAM_SEGMENT), A
    OUT     ($10 + NC_VRAM_SEGMENT), A                    ; $10=0($b000), $11=$4000($b001), $12=$8000 ($b002), $13=$c000 ($b003)
    RET
  ENDIF


__gfx_vram_page_out:
___gfx_vram_page_out:
  IF    FORzcn
    RET
  ELSE
    LD      A, (pgsave)
    ;; We disable interrupts to cope with the case that NC_VRAM_SEGMENT actually contains $B000
    di
    OUT     ($10 + NC_VRAM_SEGMENT), A
    LD      ($B000 + NC_VRAM_SEGMENT), A
    ei
    RET

    SECTION bss_clib
pgsave:
    defb    0

  ENDIF

