;
;    Camputers Lynx 128K: write sectors of the disk
;
;    int lynx_disk_write(uint8_t drive, uint8_t track, uint8_t sector,
;                        uint8_t count, const void *buf) __smallc;
;
;    Writes count sectors of 512 bytes from buf, starting at the sector (1 to
;    10) of the track (the disk is single sided: the track is the cylinder), and
;    carries on to the next track after sector 10.  Returns 0, or 1 if the
;    controller reported an error.  Interrupts are turned off for the call and
;    restored.
;

    MODULE  lynx_disk_write

    SECTION code_clib
    PUBLIC  lynx_disk_write
    PUBLIC  _lynx_disk_write
    PUBLIC  lynx_disk_write_callee
    PUBLIC  _lynx_disk_write_callee

    EXTERN  asm_lynx_disk_call
    EXTERN  asm_lynx_disk_call_callee

lynx_disk_write:
_lynx_disk_write:
    ld      a, 1
    jp      asm_lynx_disk_call

lynx_disk_write_callee:
_lynx_disk_write_callee:
    ld      a, 1
    jp      asm_lynx_disk_call_callee
