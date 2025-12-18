#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# kc180
#------------------------------------------------------------------------------

for my $cpu1 ('kc160', 'kc160_z80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;

		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
        add_opcodes($cpu, "mvi <r>, N") if !$strict;
		add_opcodes($cpu, "ld <r>, <r>");
        add_opcodes($cpu, "ld <r>, N");
        add_opcodes($cpu, "ld (<x>+DIS), <r>");
        add_opcodes($cpu, "ld (<x>+DIS), N");
		
		add_opcodes($cpu, "lxi <r>, NN") if !$strict;
        add_opcodes($cpu, "lxi <rp>, NN") if !$strict;
        add_opcodes($cpu, "ld <rp>, NN");
        add_opcodes($cpu, "ld <x>, NN");

        add_opcodes($cpu, "lda/sta [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (NN)");
        
        add_opcodes($cpu, "lhld/shld [8080]") if !$strict;
        add_opcodes($cpu, "ld hl, (NN)");
        add_opcodes($cpu, "ld <x>, (NN)");
		add_opcodes($cpu, "ld <rp>, (NN)");

        add_opcodes($cpu, "ldax <r>/stax <r> [8080]") if !$strict;
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (<rp>)");
        
        add_opcodes($cpu, "xchg [8080]") if !$strict;
        add_opcodes($cpu, "ex de, hl");
        add_opcodes($cpu, "ex af, af'");
        add_opcodes($cpu, "exx");

		add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
		add_opcodes($cpu, "<alu> a, <r>");
		add_opcodes($cpu, "<alu-extra> a, <r>") if !$strict;
		
		add_opcodes($cpu, "<alu> (<x>+DIS)");
		add_opcodes($cpu, "<alu-extra> (<x>+DIS)") if !$strict;
		
		add_opcodes($cpu, "<alu> N [8080]") if !$strict;
		add_opcodes($cpu, "<alu> a, N");
		add_opcodes($cpu, "<alu-extra> a, N") if !$strict;
		
		add_opcodes($cpu, "inr/dcr <r> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <r>");
		add_opcodes($cpu, "inc/dec (<x>+DIS)");
		
		add_opcodes($cpu, "inx/dcx <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dcx <rp> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <rp>");
		add_opcodes($cpu, "inc/dec <x>");

		add_opcodes($cpu, "dad <r> [8080]") if !$strict;
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;
		add_opcodes($cpu, "add hl, <rp>");
		add_opcodes($cpu, "add <x>, <rp>");
		add_opcodes($cpu, "sbc/adc hl, <rp>");
		
		add_opcodes($cpu, "daa");
		add_opcodes($cpu, "cma [8080]") if !$strict;
		add_opcodes($cpu, "cpl");
		add_opcodes($cpu, "cpl a") if !$strict;
		add_opcodes($cpu, "cmc [8080]") if !$strict;
		add_opcodes($cpu, "ccf");
		add_opcodes($cpu, "stc [8080]") if !$strict;
		add_opcodes($cpu, "scf");

		add_opcodes($cpu, "<rot-a> [8080]") if !$strict;
		add_opcodes($cpu, "<rot-a>");
		
		add_opcodes($cpu, "<rot> <r>");
		add_opcodes($cpu, "<rot> (<x>+DIS)");
		add_opcodes($cpu, "<bit> <b>, <r>");
		add_opcodes($cpu, "<bit> <b>, (<x>+DIS)");
		
		add_opcodes($cpu, "jr DIS");
		add_opcodes($cpu, "djnz DIS");
		add_opcodes($cpu, "djnz b, DIS") if !$strict;
		add_opcodes($cpu, "jr <f>, DIS");
		
		add_opcodes($cpu, "jmp NN") if !$strict;
		add_opcodes($cpu, "jp NN");
		add_opcodes($cpu, "j<f> NN") if !$strict;
		add_opcodes($cpu, "j_<f> NN") if !$strict;
		add_opcodes($cpu, "jmp <f>, NN") if !$strict;
		add_opcodes($cpu, "jp <f>, NN");
		
        add_opcodes($cpu, "pchl [8080]") if !$strict;
        add_opcodes($cpu, "jp (hl)");
        add_opcodes($cpu, "jp (<x>)");
        add_opcodes($cpu, "jmp (hl)") if !$strict;
        add_opcodes($cpu, "jmp (<x>)") if !$strict;

		add_opcodes($cpu, "call NN");
		add_opcodes($cpu, "c<flag> NN") if !$strict;
		add_opcodes($cpu, "c_<f> NN") if !$strict;
		add_opcodes($cpu, "call <f>, NN");
				
		add_opcodes($cpu, "rst NN");
		
		add_opcodes($cpu, "ret");
		add_opcodes($cpu, "r<f>") if !$strict;
		add_opcodes($cpu, "r_<f>") if !$strict;
		add_opcodes($cpu, "ret <f>");
		
        add_opcodes($cpu, "push/pop <r>") if !$strict;
        add_opcodes($cpu, "push/pop <rp>");
        add_opcodes($cpu, "push/pop <x>");
        
		add_opcodes($cpu, "xthl [8080]") if !$strict;
		add_opcodes($cpu, "ex (sp), hl");
		add_opcodes($cpu, "ex (sp), <x>");

		add_opcodes($cpu, "sphl [8080]") if !$strict;
		add_opcodes($cpu, "ld sp, hl");
		add_opcodes($cpu, "ld sp, <x>");
		
		add_opcodes($cpu, "in N [8080]") if !$strict;
		add_opcodes($cpu, "in a, (N)");
		add_opcodes($cpu, "out N [8080]") if !$strict;
		add_opcodes($cpu, "out (N), a");

		add_opcodes($cpu, "in <r>, (c)");
		add_opcodes($cpu, "in <r>, (bc)") if !$strict;
		add_opcodes($cpu, "out (c), <r>");
		add_opcodes($cpu, "out (bc), <r>") if !$strict;
		
		add_opcodes($cpu, "ei/di");
		add_opcodes($cpu, "hlt [8080]") if !$strict;
		add_opcodes($cpu, "halt");
		add_opcodes($cpu, "nop");
        add_opcodes($cpu, "ld i/r, a");
		add_opcodes($cpu, "reti");
		add_opcodes($cpu, "retn");

		add_opcodes($cpu, "neg");
		add_opcodes($cpu, "neg a") if !$strict;
		add_opcodes($cpu, "rld/rrd");

        add_opcodes($cpu, "ldi/ldir/ldd/lddr");
        add_opcodes($cpu, "cpi/cpir/cpd/cpdr");
        add_opcodes($cpu, "ini/inir/ind/indr");
        add_opcodes($cpu, "outi/otir/outd/otdr");

		if ($cpu =~ /^kc160(_strict)?$/) {
			add_opcodes($cpu, "ld (*hl), <r> [kc160]");
			add_opcodes($cpu, "ld (*hl), N [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), <r> [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), N [kc160]");
			add_opcodes($cpu, "ld (*<rp>), a [kc160]");
			add_opcodes($cpu, "ld (*p:NN), a [kc160]");
			add_opcodes($cpu, "ld *p, a [kc160]");
			add_opcodes($cpu, "ldf (NNN), a [kc160]");
			add_opcodes($cpu, "ld (*p:NN), hl [kc160]");
			add_opcodes($cpu, "ld (*p:NN), <rp> [kc160]");
			add_opcodes($cpu, "ld (*p:NN), <x> [kc160]");
			add_opcodes($cpu, "ld (<x>+DIS), <rp> [kc160]");
			add_opcodes($cpu, "ld (sp+DIS), <rp> [kc160]");
			add_opcodes($cpu, "ldf (NNN), <rp> [kc160]");
			add_opcodes($cpu, "ld (<x>+DIS), <x> [kc160]");
			add_opcodes($cpu, "ld (sp+DIS), <x> [kc160]");
			add_opcodes($cpu, "ldf (NNN), <x> [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), <rp> [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), <x> [kc160]");
			add_opcodes($cpu, "ld <hl/x>, sp [kc160]");
			add_opcodes($cpu, "ld (<x>+DIS), xix [kc160]");
			add_opcodes($cpu, "ld (sp+DIS), xix [kc160]");
			add_opcodes($cpu, "ldf (NNN), xix [kc160]");
			add_opcodes($cpu, "ld (<x>+DIS), yiy [kc160]");
			add_opcodes($cpu, "ld (sp+DIS), yiy [kc160]");
			add_opcodes($cpu, "ldf (NNN), yiy [kc160]");
			add_opcodes($cpu, "ld (<x>+DIS), ahl [kc160]");
			add_opcodes($cpu, "ld (sp+DIS), ahl [kc160]");
			add_opcodes($cpu, "ldf (NNN), ahl [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), xix [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), yiy [kc160]");
			add_opcodes($cpu, "ld (*<x>+DIS), ahl [kc160]");
			add_opcodes($cpu, "ld <ptr>, NNN [kc160]");

			add_opcodes($cpu, "push/pop <ptr> [kc160]");

	        add_opcodes($cpu, "ldi/ldir/ldd/lddr xy [kc160]");
	        add_opcodes($cpu, "cpi/cpir/cpd/cpdr x [kc160]");
	        add_opcodes($cpu, "ini/inir/ind/indr x [kc160]");
    	    add_opcodes($cpu, "outi/otir/outd/otdr x [kc160]");

			add_opcodes($cpu, "<alu> (*hl) [kc160]");
			add_opcodes($cpu, "<alu-extra> (*hl) [kc160]") if !$strict;
			add_opcodes($cpu, "<alu> (*<x>+DIS) [kc160]");
			add_opcodes($cpu, "<alu-extra> (*<x>+DIS) [kc160]") if !$strict;

			add_opcodes($cpu, "inc/dec (*hl) [kc160]");
			add_opcodes($cpu, "inc/dec (*<x>+DIS) [kc160]");

			add_opcodes($cpu, "mul/muls hl [kc160]");
			add_opcodes($cpu, "mul/muls de, hl [kc160]");
			add_opcodes($cpu, "div/divs hl, a [kc160]");
			add_opcodes($cpu, "div/divs dehl, bc [kc160]");

			add_opcodes($cpu, "add *hl, <rp> [kc160]");
			add_opcodes($cpu, "add *<x>, <rp> [kc160]");
			add_opcodes($cpu, "sbc/adc *hl, <rp> [kc160]");

			add_opcodes($cpu, "inc/dec *<rp> [kc160]");
			add_opcodes($cpu, "inc/dec *<x> [kc160]");

			add_opcodes($cpu, "<bit> <b>, (*hl) [kc160]");
			add_opcodes($cpu, "<bit> <b>, (*<x>+DIS) [kc160]");

			add_opcodes($cpu, "<rot> (*hl) [kc160]");
			add_opcodes($cpu, "<rot> (*<x>+DIS) [kc160]");

			add_opcodes($cpu, "rld/rrd (*hl) [kc160]");

			add_opcodes($cpu, "jp (*hl) [kc160]");
			add_opcodes($cpu, "jp (*<x>) [kc160]");
			add_opcodes($cpu, "jmp (*hl) [kc160]") if !$strict;
			add_opcodes($cpu, "jmp (*<x>) [kc160]") if !$strict;

			add_opcodes($cpu, "jp3 NNN [kc160]");
			add_opcodes($cpu, "jp3 <f>, NNN [kc160]");
			add_opcodes($cpu, "call3 NNN [kc160]");
			add_opcodes($cpu, "ret3 [kc160]");
			add_opcodes($cpu, "tra [kc160]");
			add_opcodes($cpu, "retn3 [kc160]");
	        add_opcodes($cpu, "im N [kc160]");
		}
    }
}

1;
