;
;	Samsung SPC-1500: select the IPL ROM or RAM at $0000-$7FFF (reads only:
;	stores always go to RAM)
;
;	void spc1500_rom_select(void);	void spc1500_ram_select(void);

	SECTION	code_clib
	PUBLIC	spc1500_rom_select
	PUBLIC	_spc1500_rom_select
	PUBLIC	spc1500_ram_select
	PUBLIC	_spc1500_ram_select
	PUBLIC	asm_spc1500_rom_select
	PUBLIC	asm_spc1500_ram_select

spc1500_rom_select:
_spc1500_rom_select:
asm_spc1500_rom_select:
	push	bc
	ld	bc,$1d00
	out	(c),a
	pop	bc
	ret

spc1500_ram_select:
_spc1500_ram_select:
asm_spc1500_ram_select:
	push	bc
	ld	bc,$1e00
	out	(c),a
	pop	bc
	ret
