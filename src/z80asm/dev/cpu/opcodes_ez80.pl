#------------------------------------------------------------------------------
# ez80
#------------------------------------------------------------------------------

for my $cpu1 ('ez80', 'ez80_z80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;
		
		add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
		add_opcodes($cpu, "<alu> N [8080]") if !$strict;
		
		add_opcodes($cpu, "<alu> (hl) [ez80]");
		add_opcodes($cpu, "<alu-extra> (hl) [ez80]") if !$strict;
		
		add_opcodes($cpu, "<alu> <x8>");
		add_opcodes($cpu, "<alu-extra> <x8>") if !$strict;
				
		add_opcodes($cpu, "inc/dec <rp> [ez80]");



		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
        add_opcodes($cpu, "mvi <r>, N") if !$strict;
		add_opcodes($cpu, "lxi <r>, NN") if !$strict;
        add_opcodes($cpu, "lxi <rp>, NN") if !$strict;
        add_opcodes($cpu, "lda/sta [8080]") if !$strict;
        add_opcodes($cpu, "lhld/shld [8080]") if !$strict;
        add_opcodes($cpu, "ldax <r>/stax <r> [8080]") if !$strict;
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "xchg [8080]") if !$strict;
		add_opcodes($cpu, "inr/dcr <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dcx <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dec <rp> [8080]") if !$strict;
		add_opcodes($cpu, "dad <r> [8080]") if !$strict;
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;
		add_opcodes($cpu, "cma [8080]") if !$strict;
		add_opcodes($cpu, "cmc [8080]") if !$strict;
		add_opcodes($cpu, "stc [8080]") if !$strict;
		add_opcodes($cpu, "<rot-a> [8080]") if !$strict;
		#add_opcodes($cpu, "jmp NN") if !$strict;
		#add_opcodes($cpu, "j<f> NN") if !$strict;
		#add_opcodes($cpu, "j_<f> NN") if !$strict;
		#add_opcodes($cpu, "jmp <f>, NN") if !$strict;
        #add_opcodes($cpu, "pchl [8080]") if !$strict;
        #add_opcodes($cpu, "jmp (hl)") if !$strict;
        #add_opcodes($cpu, "jmp (<x>)") if !$strict;
		#add_opcodes($cpu, "c<flag> NN") if !$strict;
		#add_opcodes($cpu, "c_<f> NN") if !$strict;
		#add_opcodes($cpu, "r<f>") if !$strict;
		#add_opcodes($cpu, "r_<f>") if !$strict;
        add_opcodes($cpu, "push/pop <r>") if !$strict;
		add_opcodes($cpu, "xthl [8080]") if !$strict;
		add_opcodes($cpu, "sphl [8080]") if !$strict;
		add_opcodes($cpu, "in N [8080]") if !$strict;
		add_opcodes($cpu, "out N [8080]") if !$strict;
		add_opcodes($cpu, "hlt [8080]") if !$strict;
		
	}
}

1;
