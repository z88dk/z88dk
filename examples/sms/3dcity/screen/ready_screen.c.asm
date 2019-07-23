;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: MSC.190024215 Apr 27 2017
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Thu Apr 27 16:10:51 2017



	MODULE	ready_screen


	INCLUDE "z80_crt0.hdr"


	SECTION	code_compiler


._screen_ready_screen_init
	ld	hl,100 % 256	;const
	ld	a,l
	ld	(_screen_ready_screen_delay),a
	ret



._screen_ready_screen_load
	dec	sp
	call	_engine_score_manager_load
	call	_engine_enemy_manager_load
	call	_engine_gamer_manager_load
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(10 % 256 % 256)
	ld	a,(_hacker_level)
	and	a
	jp	z,i_2
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(7 % 256 % 256)
.i_2
	ld	hl,0	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	call	engine_tile_manager_load
	pop	bc
	call	_engine_tile_manager_draw
	ld	hl,i_1+0
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	push	hl
	call	_engine_font_manager_draw_text
	pop	bc
	pop	bc
	pop	bc
	ld	hl,i_1+31
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	ld	hl,10 % 256	;const
	push	hl
	call	_engine_font_manager_draw_text
	pop	bc
	pop	bc
	pop	bc
	ld	hl,i_1+62
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	push	hl
	call	_engine_font_manager_draw_text
	pop	bc
	pop	bc
	pop	bc
	call	_engine_score_manager_draw_player
	ld	hl,i_1+66
	push	hl
	ld	hl,23 % 256	;const
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	call	_engine_font_manager_draw_text
	pop	bc
	pop	bc
	pop	bc
	call	_engine_score_manager_draw_higher
	call	_engine_gamer_manager_draw_target
	ld	hl,(_hacker_music)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_3
	call	_engine_music_manager_load_module
	call	_engine_music_manager_start_module
.i_3
	inc	sp
	ret



._screen_ready_screen_update
	dec	sp
	pop	hl
	ld	l,+(0 % 256)
	push	hl
	call	_engine_tile_manager_update_middle
	call	_engine_tile_manager_update_bottom
	ld	hl,5	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	call	_engine_gamer_manager_update_target
	pop	bc
	ld	hl,5	;const
	add	hl,sp
	call	l_gint	;
	ld	a,l
	and	16
	and	a
	jp	z,i_5
	ld	hl,3	;const
	add	hl,sp
	call	l_gint	;
	ld	a,l
	and	16
	ld	l,a
	ld	h,0
	call	l_lneg
	jp	c,i_7
.i_5
	jr	i_5_i_6
.i_6
	ld	a,h
	or	l
	jp	nz,i_7
.i_5_i_6
	ld	hl,5	;const
	add	hl,sp
	call	l_gint	;
	ld	a,l
	and	32
	and	a
	jp	z,i_8
	ld	hl,3	;const
	add	hl,sp
	call	l_gint	;
	ld	a,l
	and	32
	ld	l,a
	ld	h,0
	call	l_lneg
	jp	nc,i_8
	ld	hl,1	;const
	jr	i_9
.i_8
	ld	hl,0	;const
.i_9
	ld	a,h
	or	l
	jp	nz,i_7
	jr	i_10
.i_7
	ld	hl,1	;const
.i_10
	ld	a,h
	or	l
	jp	z,i_4
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(1 % 256 % 256)
.i_4
	ld	hl,(_screen_bases_screen_timer)
	inc	hl
	ld	(_screen_bases_screen_timer),hl
	dec	hl
	ld	de,(_screen_bases_screen_timer)
	ld	hl,(_screen_ready_screen_delay)
	ld	h,0
	call	l_uge
	jp	nc,i_11
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(1 % 256 % 256)
.i_11
	ld	hl,0	;const
	add	hl,sp
	ld	a,(hl)
	and	a
	jp	z,i_12
	ld	hl,i_1+69
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	ld	hl,10 % 256	;const
	push	hl
	call	_engine_font_manager_draw_text
	pop	bc
	pop	bc
	pop	bc
	ld	hl,7	;const
	call	l_gintspsp	;
	ld	hl,5	;const
	pop	de
	call	l_pint
.i_12
	inc	sp
	ret


	SECTION	rodata_compiler

.i_1
	defm	"          --3D CITY--         "
	defm	""
	defb	0

	defm	"           GET READY          "
	defm	""
	defb	0

	defm	"1UP"
	defb	0

	defm	"HI"
	defb	0

	defm	"                              "
	defm	""
	defb	0



; --- Start of Static Variables ---

	SECTION	bss_compiler

	SECTION	code_compiler



; --- Start of Scope Defns ---

	PUBLIC	_screen_ready_screen_init
	PUBLIC	_screen_ready_screen_load
	PUBLIC	_screen_ready_screen_update
	EXTERN	_engine_enemy_manager_init
	EXTERN	_engine_enemy_manager_load
	EXTERN	_engine_enemy_manager_update_enemies
	EXTERN	_engine_enemy_manager_trigger_explosion
	EXTERN	_engine_font_manager_load
	EXTERN	_engine_font_manager_draw_text
	EXTERN	_engine_font_manager_draw_data
	EXTERN	_engine_font_manager_draw_score
	EXTERN	_engine_gamer_manager_init
	EXTERN	_engine_gamer_manager_load
	EXTERN	_engine_gamer_manager_update_bullets
	EXTERN	_engine_gamer_manager_update_target
	EXTERN	_engine_gamer_manager_trigger_bullet
	EXTERN	_engine_gamer_manager_draw_target
	EXTERN	_engine_music_manager_load_module
	EXTERN	_engine_music_manager_start_module
	EXTERN	_engine_music_manager_play_module
	EXTERN	_engine_music_manager_pause_module
	EXTERN	_engine_score_manager_init
	EXTERN	_engine_score_manager_load
	EXTERN	_engine_score_manager_update
	EXTERN	_engine_score_manager_draw_player
	EXTERN	_engine_score_manager_draw_higher
	EXTERN	_engine_tile_manager_init
	EXTERN	engine_tile_manager_load
	EXTERN	_engine_tile_manager_update_middle
	EXTERN	_engine_tile_manager_update_bottom
	EXTERN	_engine_tile_manager_draw
	EXTERN	clear_vram
	EXTERN	load_palette
	EXTERN	load_tiles
	EXTERN	set_bkg_map
	EXTERN	scroll_bkg
	EXTERN	get_vcount
	EXTERN	wait_vblank_noint
	EXTERN	set_sprite
	EXTERN	read_joypad1
	EXTERN	read_joypad2
	EXTERN	set_vdp_reg
	EXTERN	gotoxy
	EXTERN	aplib_depack
	EXTERN	add_raster_int
	EXTERN	add_pause_int
	EXTERN	set_sound_freq
	EXTERN	set_sound_volume
	EXTERN	_standard_font
	EXTERN	_pause_flag
	EXTERN	_hacker_level
	EXTERN	_hacker_music
	EXTERN	_screen_bases_screen_count
	EXTERN	_screen_bases_screen_timer
	EXTERN	_screen_ready_screen_delay


; --- End of Scope Defns ---


; --- End of Compilation ---
