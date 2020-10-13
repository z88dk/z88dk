
	SECTION	data_clib

	PUBLIC	__lviv_ink
	PUBLIC	__lviv_paper

__lviv_ink:	defb	@10001000
__lviv_paper:	defb	@00000000


        SECTION code_crt_init

        EXTERN          __BSS_END_tail
        EXTERN          __HIMEM_head
        EXTERN          __HIMEM_END_tail

        ld      hl,__BSS_END_tail
        ld      de,__HIMEM_head
        ld      bc,__HIMEM_END_tail - __HIMEM_head
        ldir
