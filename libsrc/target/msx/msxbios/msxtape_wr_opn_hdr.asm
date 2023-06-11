;
;      Low level cassette control: open for writing (long leading tone)
;
;      Stefano, 2022
;
;      int msxtape_wr_opn_hdr();
;

PUBLIC msxtape_wr_opn_hdr
PUBLIC _msxtape_wr_opn_hdr


EXTERN	msxtape_wr_opn_sub


.msxtape_wr_opn_hdr
._msxtape_wr_opn_hdr

	ld a,-1		;(long leading tone)
	jp msxtape_wr_opn_sub
