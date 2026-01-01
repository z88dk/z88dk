#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# ez80
#------------------------------------------------------------------------------

for my $cpu1 ('ez80', 'ez80_z80') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;
		
		add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
		add_opcodes($cpu, "<alu> N [8080]") if !$strict;
		
		add_opcodes($cpu, "<alu> a, (hl) [ez80]");
		add_opcodes($cpu, "<alu-extra> a, (hl) [ez80]") if !$strict;
		
		add_opcodes($cpu, "<alu> a, <x8> [ez80]");
		add_opcodes($cpu, "<alu-extra> a, <x8>") if !$strict;
		
		add_opcodes($cpu, "<alu> a, (<x>+DIS) [ez80]");
		add_opcodes($cpu, "<alu-extra> a, (<x>+DIS) [ez80]") if !$strict;

		add_opcodes($cpu, "<alu> a, N [ez80]");
		add_opcodes($cpu, "<alu-extra> a, N") if !$strict;

		add_opcodes($cpu, "<alu> a, <r> [ez80]");
		add_opcodes($cpu, "<alu-extra> a, <r>") if !$strict;
		
		add_opcodes($cpu, "sbc/adc hl, <rp> [ez80]");
		
		add_opcodes($cpu, "dad <r> [8080]") if !$strict;
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;
		add_opcodes($cpu, "add hl, <rp> [ez80]");
		add_opcodes($cpu, "add <x>, <rp> [ez80]");

		add_opcodes($cpu, "<bit> <b>, (hl) [ez80]");
		add_opcodes($cpu, "<bit> <b>, (<x>+DIS) [ez80]");
		add_opcodes($cpu, "<bit> <b>, <r>");
		
		add_opcodes($cpu, "c<flag> NN [ez80]") if !$strict;
		add_opcodes($cpu, "c_<f> NN [ez80]") if !$strict;
		add_opcodes($cpu, "call NN [ez80]");
		add_opcodes($cpu, "call <f>, NN [ez80]");

		add_opcodes($cpu, "rst NN");

		add_opcodes($cpu, "ret [ez80]");
		add_opcodes($cpu, "r<f>") if !$strict;
		add_opcodes($cpu, "r_<f>") if !$strict;
		add_opcodes($cpu, "ret <f> [ez80]");

		add_opcodes($cpu, "reti [ez80]");
		add_opcodes($cpu, "retn [ez80]");

		add_opcodes($cpu, "daa");
		
		add_opcodes($cpu, "cmc [8080]") if !$strict;
		add_opcodes($cpu, "ccf");
		
		add_opcodes($cpu, "stc [8080]") if !$strict;
		add_opcodes($cpu, "scf");

		add_opcodes($cpu, "cma [8080]") if !$strict;
		add_opcodes($cpu, "cpl");
		add_opcodes($cpu, "cpl a") if !$strict;
		
        add_opcodes($cpu, "cpi/cpir/cpd/cpdr [ez80]");
		
		add_opcodes($cpu, "inr/dcr <r> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec (hl) [ez80]");
		add_opcodes($cpu, "inc/dec <x8>");
		add_opcodes($cpu, "inc/dec (<x>+DIS) [ez80]");
		add_opcodes($cpu, "inc/dec <r>");
		
		add_opcodes($cpu, "inx/dcx <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dcx <rp> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <x> [ez80]");
		add_opcodes($cpu, "inc/dec <rp> [ez80]");

		add_opcodes($cpu, "ei/di");

        add_opcodes($cpu, "xchg [8080]") if !$strict;
        add_opcodes($cpu, "ex de, hl");
		add_opcodes($cpu, "ex af, af'");
        
		add_opcodes($cpu, "xthl [8080]") if !$strict;
		add_opcodes($cpu, "ex (sp), hl [ez80]");
		add_opcodes($cpu, "ex (sp), <x> [ez80]");

		add_opcodes($cpu, "exx");

		add_opcodes($cpu, "hlt [8080]") if !$strict;
		add_opcodes($cpu, "halt");
        add_opcodes($cpu, "im N");
		add_opcodes($cpu, "slp [z180]");

		add_opcodes($cpu, "in N [8080]") if !$strict;
		add_opcodes($cpu, "in a, (N)");
		add_opcodes($cpu, "out N [8080]") if !$strict;
		add_opcodes($cpu, "out (N), a");
		add_opcodes($cpu, "in <r>, (c)") if !$strict;
		add_opcodes($cpu, "in <r>, (bc)");
		add_opcodes($cpu, "out (c), <r>") if !$strict;
		add_opcodes($cpu, "out (bc), <r>");
		add_opcodes($cpu, "in0 <r>, (N) [z180]");
		add_opcodes($cpu, "out0 (N), <r> [z180]");
		add_opcodes($cpu, "in/out-undoc") if !$strict;

        add_opcodes($cpu, "ini/inir/ind/indr [ez80]");
        add_opcodes($cpu, "ini2/ini2r/ind2/ind2r [ez80]");
        add_opcodes($cpu, "inim/inimr/indm/indmr [ez80]");
        add_opcodes($cpu, "inirx/indrx [ez80]");
        add_opcodes($cpu, "outi/otir/outd/otdr/outi2/outd2 [ez80]");
        add_opcodes($cpu, "oti2r/otirx/otd2r/otdrx [ez80]");
        add_opcodes($cpu, "otim/otimr/otdm/otdmr [ez80]");

		add_opcodes($cpu, "jr DIS");
		add_opcodes($cpu, "jr <f>, DIS");
		add_opcodes($cpu, "djnz DIS");
		add_opcodes($cpu, "djnz b, DIS") if !$strict;

		add_opcodes($cpu, "jp NN [ez80]");
		add_opcodes($cpu, "jmp NN [ez80]") if !$strict;
		add_opcodes($cpu, "j<f> NN [ez80]") if !$strict;
		add_opcodes($cpu, "j_<f> NN [ez80]") if !$strict;
		add_opcodes($cpu, "jmp <f>, NN [ez80]") if !$strict;
		add_opcodes($cpu, "jp <f>, NN [ez80]");

        add_opcodes($cpu, "pchl [8080]") if !$strict;
        add_opcodes($cpu, "jp (hl) [ez80]");
        add_opcodes($cpu, "jmp (hl) [ez80]") if !$strict;
        add_opcodes($cpu, "jp (<x>) [ez80]");
        add_opcodes($cpu, "jmp (<x>) [ez80]") if !$strict;

        add_opcodes($cpu, "ld <x8>, <r>");
        add_opcodes($cpu, "ld <x8>, N");
        add_opcodes($cpu, "ld (<x>+DIS), <r> [ez80]");
        add_opcodes($cpu, "ld (<x>+DIS), <rp> [ez80]");
        add_opcodes($cpu, "ld (<x>+DIS), N [ez80]");

        add_opcodes($cpu, "lda/sta [ez80]") if !$strict;
        add_opcodes($cpu, "ld a, (NN) [ez80]");

        add_opcodes($cpu, "ldax <r>/stax <r> [8080]") if !$strict;
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (<rp>) [ez80]");
        add_opcodes($cpu, "ld (hl), <r> [ez80]");
        add_opcodes($cpu, "ld (hl), <rp> [ez80]");
        add_opcodes($cpu, "ld (hl), <x> [ez80]");
        add_opcodes($cpu, "ld (hl), N [ez80]");
        add_opcodes($cpu, "ld (<x>+DIS), <x> [ez80]");

        add_opcodes($cpu, "ld i/r, a");
        add_opcodes($cpu, "ld i, hl [ez80]");
		add_opcodes($cpu, "ld mb, a [ez80]");
		
		add_opcodes($cpu, "lxi <r>, NN [ez80]") if !$strict;
        add_opcodes($cpu, "lxi <rp>, NN [ez80]") if !$strict;
        add_opcodes($cpu, "ld <rp>, NN [ez80]");
        add_opcodes($cpu, "ld <x>, NN [ez80]");

        add_opcodes($cpu, "lhld/shld [ez80]") if !$strict;
        add_opcodes($cpu, "ld hl, (NN) [ez80]");
        add_opcodes($cpu, "ld <x>, (NN) [ez80]");
		add_opcodes($cpu, "ld <rp>, (NN) [ez80]");

		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
		add_opcodes($cpu, "ld <r>, <r>");
        add_opcodes($cpu, "mvi <r>, N") if !$strict;
        add_opcodes($cpu, "ld <r>, N");

		add_opcodes($cpu, "sphl [8080]") if !$strict;
		add_opcodes($cpu, "ld sp, hl [ez80]");
		add_opcodes($cpu, "ld sp, <x> [ez80]");

        add_opcodes($cpu, "ldi/ldir/ldd/lddr [ez80]");

		add_opcodes($cpu, "lea <rp>, <x>+DIS [ez80]");
		add_opcodes($cpu, "lea <x>, <x>+DIS [ez80]");
		add_opcodes($cpu, "pea <x>+DIS [ez80]");
		
		add_opcodes($cpu, "mlt <rp> [z180]");
		
		add_opcodes($cpu, "neg");
		add_opcodes($cpu, "neg a") if !$strict;

		add_opcodes($cpu, "nop");

        add_opcodes($cpu, "push/pop <r> [ez80]") if !$strict;
        add_opcodes($cpu, "push/pop <rp> [ez80]");
        add_opcodes($cpu, "push/pop <x> [ez80]");

		add_opcodes($cpu, "<rot-a> [8080]") if !$strict;
		add_opcodes($cpu, "<rot-a>");
		add_opcodes($cpu, "<rot> (hl) [ez80]");
		add_opcodes($cpu, "<rot> (<x>+DIS) [ez80]");
		add_opcodes($cpu, "<rot> <r>");
		
		add_opcodes($cpu, "rld/rrd");

		add_opcodes($cpu, "rsmix/stmix [ez80]");

		add_opcodes($cpu, "tst a, (hl) [ez80]");
		add_opcodes($cpu, "tst (hl) [ez80]") if !$strict;
		add_opcodes($cpu, "test a, (hl) [ez80]") if !$strict;
		add_opcodes($cpu, "test (hl) [ez80]") if !$strict;
		
		add_opcodes($cpu, "tst a, <r> [z180]");
		add_opcodes($cpu, "tst <r> [z180]") if !$strict;
		add_opcodes($cpu, "test <r> [z180]") if !$strict;
		add_opcodes($cpu, "test a, <r> [z180]") if !$strict;
		
		add_opcodes($cpu, "tst a, N [z180]");
		add_opcodes($cpu, "tst N [z180]") if !$strict;
		add_opcodes($cpu, "test a, N [z180]") if !$strict;
		add_opcodes($cpu, "test N [z180]") if !$strict;
		
		add_opcodes($cpu, "tstio N [z180]");
		
	}
}

1;
