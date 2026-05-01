#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 8080
#------------------------------------------------------------------------------

for my $cpu1 ('8080') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;

		add_opcodes($cpu, "mov <r>, <r>");
        add_opcodes($cpu, "mvi <r>, N");
		add_opcodes($cpu, "ld <r>, <r>") if !$strict;
        add_opcodes($cpu, "ld <r>, N") if !$strict;
        
		add_opcodes($cpu, "lxi <r>, NN");
        add_opcodes($cpu, "lxi <rp>, NN") if !$strict;
        add_opcodes($cpu, "ld <rp>, NN") if !$strict;

        add_opcodes($cpu, "lda/sta [8080]");
        add_opcodes($cpu, "ld a, (NN)") if !$strict;

        add_opcodes($cpu, "lhld/shld [8080]");
        add_opcodes($cpu, "ld hl, (NN)") if !$strict;

        add_opcodes($cpu, "ldax <r>/stax <r> [8080]");
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (<rp>)") if !$strict;

        add_opcodes($cpu, "xchg [8080]");
        add_opcodes($cpu, "ex de, hl") if !$strict;
        
		add_opcodes($cpu, "<alu> <r> [8080]");
		add_opcodes($cpu, "<alu> a, <r>") if !$strict;
		add_opcodes($cpu, "<alu-extra> a, <r>") if !$strict;
		
		add_opcodes($cpu, "<alu> N [8080]");
		add_opcodes($cpu, "<alu> a, N") if !$strict;
		add_opcodes($cpu, "<alu-extra> a, N") if !$strict;
		
		add_opcodes($cpu, "inr/dcr <r> [8080]");
		add_opcodes($cpu, "inc/dec <r>") if !$strict;
		
		add_opcodes($cpu, "inx/dcx <r> [8080]");
		add_opcodes($cpu, "inx/dcx <rp> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <rp>") if !$strict;
		
		add_opcodes($cpu, "dad <r> [8080]");
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;
		add_opcodes($cpu, "add hl, <rp>") if !$strict;
		
		add_opcodes($cpu, "daa");
		add_opcodes($cpu, "cma [8080]");
		add_opcodes($cpu, "cpl") if !$strict;
		add_opcodes($cpu, "cpl a") if !$strict;
		add_opcodes($cpu, "cmc [8080]");
		add_opcodes($cpu, "ccf") if !$strict;
		add_opcodes($cpu, "stc [8080]");
		add_opcodes($cpu, "scf") if !$strict;
		
		add_opcodes($cpu, "<rot-a> [8080]");
		add_opcodes($cpu, "<rot-a>") if !$strict;
		
		add_opcodes($cpu, "jmp NN");
		add_opcodes($cpu, "jp NN") if !$strict;
		add_opcodes($cpu, "j<f> NN");
		add_opcodes($cpu, "j_<f> NN") if !$strict;
		add_opcodes($cpu, "jp NN [8080]") if $strict;
		add_opcodes($cpu, "jmp <f>, NN") if !$strict;
		add_opcodes($cpu, "jp <f>, NN") if !$strict;
		
        add_opcodes($cpu, "pchl [8080]");
        add_opcodes($cpu, "jp (hl)") if !$strict;
        add_opcodes($cpu, "jmp (hl)") if !$strict;

		add_opcodes($cpu, "call NN");
		add_opcodes($cpu, "c<flag> NN");
		add_opcodes($cpu, "c_<f> NN") if !$strict;
		add_opcodes($cpu, "cp NN [8080]") if $strict;
		add_opcodes($cpu, "call <f>, NN") if !$strict;
		
		add_opcodes($cpu, "rst NN");
		
		add_opcodes($cpu, "ret");
		add_opcodes($cpu, "r<f>");
		add_opcodes($cpu, "r_<f>") if !$strict;
		add_opcodes($cpu, "ret <f>") if !$strict;
		
        add_opcodes($cpu, "push/pop <r>");
        add_opcodes($cpu, "push/pop <rp>") if !$strict;

		add_opcodes($cpu, "xthl [8080]");
		add_opcodes($cpu, "ex (sp), hl") if !$strict;
		
		add_opcodes($cpu, "sphl [8080]");
		add_opcodes($cpu, "ld sp, hl") if !$strict;
		
		add_opcodes($cpu, "in N [8080]");
		add_opcodes($cpu, "in a, (N)") if !$strict;
		add_opcodes($cpu, "out N [8080]");
		add_opcodes($cpu, "out (N), a") if !$strict;
		
		add_opcodes($cpu, "ei/di");
		add_opcodes($cpu, "hlt [8080]");
		add_opcodes($cpu, "halt") if !$strict;
		add_opcodes($cpu, "nop");
    }	
}

1;
