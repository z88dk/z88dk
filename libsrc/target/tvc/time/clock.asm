;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;
;	Enterprise 64/128 clock()
;
;	stefano 5/4/2007
;

        SECTION code_clib
        PUBLIC	clock
        PUBLIC	_clock
        include "target/tvc/def/tvc.def"
.clock
._clock
	ld hl,(INTINC) ; count of 20.096ms from start (can count up to almost 22mins)
    ld de,0
	ret
