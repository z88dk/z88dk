#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# gbz80
#------------------------------------------------------------------------------

for my $cpu1 ('gbz80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;

		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
		add_opcodes($cpu, "ld <r>, <r>");

        add_opcodes($cpu, "mvi <r>, N") if !$strict;
        add_opcodes($cpu, "ld <r>, N");
		
        add_opcodes($cpu, "lda/sta [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (NN)");
        
		add_opcodes($cpu, "ldax <r>/stax <r> [8080]") if !$strict;
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (<rp>)");
        
		add_opcodes($cpu, "ldh a, (c) [gbz80]");
		add_opcodes($cpu, "ld a, (hl+) [gbz80]");
		add_opcodes($cpu, "ldh a, (N) [gbz80]");
		
		add_opcodes($cpu, "lxi <r>, NN") if !$strict;
        add_opcodes($cpu, "lxi <rp>, NN") if !$strict;
        add_opcodes($cpu, "ld <rp>, NN");
        
		add_opcodes($cpu, "sphl [8080]") if !$strict;
		add_opcodes($cpu, "ld sp, hl");

		add_opcodes($cpu, "ldhl sp, N [gbz80]");
		add_opcodes($cpu, "ld (NN), sp [gbz80]");

        add_opcodes($cpu, "push/pop <r>") if !$strict;
        add_opcodes($cpu, "push/pop <rp>");
        
		add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
		add_opcodes($cpu, "<alu> a, <r>");
		add_opcodes($cpu, "<alu-extra> a, <r>") if !$strict;
		
		add_opcodes($cpu, "<alu> N [8080]") if !$strict;
		add_opcodes($cpu, "<alu> a, N");
		add_opcodes($cpu, "<alu-extra> a, N") if !$strict;
		
		add_opcodes($cpu, "inr/dcr <r> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <r>");

		add_opcodes($cpu, "dad <r> [8080]") if !$strict;
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;
		add_opcodes($cpu, "add hl, <rp>");
		
		add_opcodes($cpu, "add sp, N [gbz80]");

		add_opcodes($cpu, "inx/dcx <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dcx <rp> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <rp>");

		add_opcodes($cpu, "daa");

		add_opcodes($cpu, "cma [8080]") if !$strict;
		add_opcodes($cpu, "cpl");
		add_opcodes($cpu, "cpl a") if !$strict;

		add_opcodes($cpu, "cmc [8080]") if !$strict;
		add_opcodes($cpu, "ccf");
		add_opcodes($cpu, "stc [8080]") if !$strict;
		add_opcodes($cpu, "scf");

		add_opcodes($cpu, "nop");

		add_opcodes($cpu, "hlt [8080]") if !$strict;
		add_opcodes($cpu, "halt");
		add_opcodes($cpu, "stop [gbz80]");

		add_opcodes($cpu, "ei/di");

		add_opcodes($cpu, "<rot-a> [8080]") if !$strict;
		add_opcodes($cpu, "<rot-a>");
		
		add_opcodes($cpu, "<rot> <r>");
		add_opcodes($cpu, "swap <r> [gbz80]");
		add_opcodes($cpu, "<bit> <b>, <r>");

		add_opcodes($cpu, "jmp NN") if !$strict;
		add_opcodes($cpu, "jp NN");

		add_opcodes($cpu, "j<f> NN") if !$strict;
		add_opcodes($cpu, "j_<f> NN") if !$strict;
		add_opcodes($cpu, "jmp <f>, NN") if !$strict;
		add_opcodes($cpu, "jp <f>, NN");

        add_opcodes($cpu, "pchl [8080]") if !$strict;
        add_opcodes($cpu, "jp (hl)");
        add_opcodes($cpu, "jmp (hl)") if !$strict;

		add_opcodes($cpu, "jr DIS");
		add_opcodes($cpu, "jr <f>, DIS");

		add_opcodes($cpu, "call NN");
		add_opcodes($cpu, "c<flag> NN") if !$strict;
		add_opcodes($cpu, "c_<f> NN") if !$strict;
		add_opcodes($cpu, "call <f>, NN");

		add_opcodes($cpu, "rst NN");
		
		add_opcodes($cpu, "ret");
		add_opcodes($cpu, "r<f>") if !$strict;
		add_opcodes($cpu, "r_<f>") if !$strict;
		add_opcodes($cpu, "ret <f>");
		add_opcodes($cpu, "reti");
    }
}

1;
