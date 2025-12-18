#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# r2ka, r3k, r4k, r5k, r6k
#------------------------------------------------------------------------------

use Modern::Perl;
use Array::Compare;
use Data::Dump 'dump';

for my $cpu1 ('r2ka', 'r3k', 'r4k', 'r5k', 'r6k') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;
        my $ge_r3k = $cpu1 eq 'r3k' || $cpu1 eq 'r4k' || $cpu1 eq 'r5k' || $cpu1 eq 'r6k';
		my $ge_r4k = $cpu1 eq 'r4k' || $cpu1 eq 'r5k' || $cpu1 eq 'r6k';
		my $ge_r6k = $cpu1 eq 'r6k';

		if ($ge_r4k) {
            add_opcodes($cpu, "<alu> a, <r> [r4k]");
            add_opcodes($cpu, "<alu-extra> a, <r> [r4k]") if !$strict;
			add_opcodes($cpu, "<alu> <r> [8080/r4k]") if !$strict;
		}
		else {
            add_opcodes($cpu, "<alu> a, <r> [r2ka]");
            add_opcodes($cpu, "<alu-extra> a, <r> [r2ka]") if !$strict;
			add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
		}

		if ($ge_r4k) {
			add_opcodes($cpu, "<alu> a, (hl) [r4k]");
			add_opcodes($cpu, "<alu-extra> a, (hl) [r4k]") if !$strict;
		}
		else {
			add_opcodes($cpu, "<alu> a, (hl) [r2ka]");
			add_opcodes($cpu, "<alu-extra> a, (hl) [r2ka]") if !$strict;
		}

		add_opcodes($cpu, "<alu> a, (<x>+DIS) [r2ka]");
		add_opcodes($cpu, "<alu-extra> a, (<x>+DIS) [r2ka]") if !$strict;

        add_opcodes($cpu, "<alu> a, N [r2ka]");
        add_opcodes($cpu, "<alu-extra> a, N [r2ka]") if !$strict;
        add_opcodes($cpu, "<alu> N [8080]") if !$strict;

		add_opcodes($cpu, "inr/dcr <r> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <r> [r2ka]");
		add_opcodes($cpu, "inc/dec (hl) [r2ka]");
		add_opcodes($cpu, "inc/dec (<x>+DIS) [r2ka]");

		add_opcodes($cpu, "inx/dcx <r> [8080]") if !$strict;
		add_opcodes($cpu, "inx/dcx <rp> [8080]") if !$strict;
		add_opcodes($cpu, "inc/dec <rp> [r2ka]");
		add_opcodes($cpu, "inc/dec <x>");

		add_opcodes($cpu, "add hl, <rp> [r2ka]");
		add_opcodes($cpu, "add <x>, <rp> [r2ka]");
		add_opcodes($cpu, "sbc/adc hl, <rp> [r2ka]");
		add_opcodes($cpu, "add sp, %d [r2ka]");
		add_opcodes($cpu, "dad <r> [8080]") if !$strict;
		add_opcodes($cpu, "dad <rp> [8080]") if !$strict;

        if ($ge_r4k) {
			add_opcodes($cpu, "add hl, jk [r4k]");
			add_opcodes($cpu, "add jkhl, bcde [r4k]");
        }

		add_opcodes($cpu, "and hl, de [r2ka]");
		add_opcodes($cpu, "and <x>, de [r2ka]");

        if ($ge_r4k) {
			add_opcodes($cpu, "and jkhl, bcde [r4k]");
        }
        
        add_opcodes($cpu, "xchg [8080]") if !$strict;
        add_opcodes($cpu, "ex de, hl [r2ka]");
        add_opcodes($cpu, "ex af, af'");
        add_opcodes($cpu, "exx");

		add_opcodes($cpu, "xthl [8080]") if !$strict;
		add_opcodes($cpu, "ex (sp), hl [r2ka]");
		add_opcodes($cpu, "ex (sp), <x>");

        if ($ge_r4k) {
            add_opcodes($cpu, "ex bc, hl [r4k]");
            add_opcodes($cpu, "ex jk, hl [r4k]");
            add_opcodes($cpu, "ex jkhl, bcde [r4k]");
            add_opcodes($cpu, "exp [r4k]");
        }

		add_opcodes($cpu, "cma [8080]") if !$strict;
		add_opcodes($cpu, "cpl [r2ka]");

		add_opcodes($cpu, "cmc [8080]") if !$strict;
		add_opcodes($cpu, "ccf");
		add_opcodes($cpu, "ccf' [r2ka]");

		add_opcodes($cpu, "stc [8080]") if !$strict;
		add_opcodes($cpu, "scf");
		add_opcodes($cpu, "scf' [r2ka]");

		add_opcodes($cpu, "<bit> <b>, <r> [r2ka]");
		add_opcodes($cpu, "<bit> <b>, (hl) [r2ka]");
		add_opcodes($cpu, "<bit> <b>, (<x>+DIS) [r2ka]");

		add_opcodes($cpu, "bool hl [r2ka]");
		add_opcodes($cpu, "bool <x> [r2ka]");

        if ($ge_r4k) {
			add_opcodes($cpu, "clr hl [r4k]");

			add_opcodes($cpu, "convc <pp> [r4k]");
			add_opcodes($cpu, "convd <pp> [r4k]");

			add_opcodes($cpu, "copy/copyr [r4k]");

			add_opcodes($cpu, "cp hl, D [r4k]");
			add_opcodes($cpu, "cmp hl, D [r4k]") if !$strict;
			add_opcodes($cpu, "cp hl, de [r4k]");
			add_opcodes($cpu, "cmp hl, de [r4k]") if !$strict;
			add_opcodes($cpu, "cp jkhl, bcde [r4k]");
			add_opcodes($cpu, "cmp jkhl, bcde [r4k]") if !$strict;

			add_opcodes($cpu, "cbm N [r4k]");

            add_opcodes($cpu, "flag <f>, hl [r4k]");
            add_opcodes($cpu, "ibox/sbox a [r4k]");
        }

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

		if ($ge_r4k) {
            add_opcodes($cpu, "jp <xf>, NN [r4k]");
			add_opcodes($cpu, "j<xf>, NN [r4k]") if !$strict;
		}
		else {
            add_opcodes($cpu, "jp <xf>, NN [r2ka]");
			add_opcodes($cpu, "j<xf>, NN [r2ka]") if !$strict;
		}
		
		add_opcodes($cpu, "jr DIS");
		add_opcodes($cpu, "jr <f>, DIS");
        if ($ge_r4k) {
            add_opcodes($cpu, "jr <xf>, DIS [r4k]");
            add_opcodes($cpu, "jre EDIS [r4k]");
            add_opcodes($cpu, "jre <f>, EDIS [r4k]");
        }

        add_opcodes($cpu, "djnz b, DIS [r2ka]");
        if ($ge_r4k) {
            add_opcodes($cpu, "dwjnz bc, DIS [r4k]");
        }

		add_opcodes($cpu, "call NN");
        add_opcodes($cpu, "lcall N, NN [r2ka]");
        if ($ge_r4k) {
			add_opcodes($cpu, "call (hl) [r4k]");
			add_opcodes($cpu, "call (<x>) [r4k]");
			add_opcodes($cpu, "fsyscall [r4k]");
        }

        if ($ge_r3k) {
            add_opcodes($cpu, "idet [r3k]");
        }

        add_opcodes($cpu, "ipres [r4k]");
        add_opcodes($cpu, "ipset N [r4k]");

        add_opcodes($cpu, "ld eir/iir, a [r2ka]");
        if ($ge_r4k) {
            add_opcodes($cpu, "ld htr, a [r4k]");
        }

        add_opcodes($cpu, "ld xpc, a [r2ka]");

        add_opcodes($cpu, "ldax <r>/stax <r> [8080]") if !$strict;
        add_opcodes($cpu, "ldax <rp>/stax <rp> [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (<rp>) [r2ka]");

        add_opcodes($cpu, "lda/sta [8080]") if !$strict;
        add_opcodes($cpu, "ld a, (NN) [r2ka]");

        if ($ge_r4k) {
            add_opcodes($cpu, "ld a, (<x>+A) [r4k]");
            add_opcodes($cpu, "ld a, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld a, (<pp>+HL) [r4k]");

            add_opcodes($cpu, "ld bcde, <pd> [r4k]");
            add_opcodes($cpu, "ld bcde, (hl) [r4k]");
            add_opcodes($cpu, "ld bcde, (<x>+DIS) [r4k]");
            add_opcodes($cpu, "ld bcde, (NN) [r4k]");
            add_opcodes($cpu, "ld bcde, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld bcde, (<pp>+HL) [r4k]");
            add_opcodes($cpu, "ld bcde, D [r4k]");
            add_opcodes($cpu, "ld bcde, (sp+hl) [r4k]");
            add_opcodes($cpu, "ld bcde, (sp+N) [r4k]");
            add_opcodes($cpu, "ld (sp+N), bcde [r4k]");

            add_opcodes($cpu, "ld jkhl, D [r4k]");
            add_opcodes($cpu, "ld jkhl, <pd> [r4k]");
            add_opcodes($cpu, "ld jkhl, (hl) [r4k]");
            add_opcodes($cpu, "ld jkhl, (sp+hl) [r4k]");
            add_opcodes($cpu, "ld jkhl, (<x>+DIS) [r4k]");
            add_opcodes($cpu, "ld jkhl, (NN) [r4k]");
            add_opcodes($cpu, "ld jkhl, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld jkhl, (<pp>+HL) [r4k]");
            add_opcodes($cpu, "ld jkhl, (sp+N) [r4k]");
            add_opcodes($cpu, "ld (sp+N), jkhl [r4k]");

			add_opcodes($cpu, "ld (NN), bcde|jkhl [r4k]");
			add_opcodes($cpu, "ld (NN), jk [r4k]");
            add_opcodes($cpu, "ld bc, hl [r4k]");
            add_opcodes($cpu, "ld de, hl [r4k]");
            add_opcodes($cpu, "ld hl, bc [r4k]");
            add_opcodes($cpu, "ld hl, de [r4k]");

            add_opcodes($cpu, "ld jk, NN [r4k]");
            add_opcodes($cpu, "ld jk, (NN) [r4k]");

            add_opcodes($cpu, "ld <pp>, bcde [r4k]");
            add_opcodes($cpu, "ld <pp>, jkhl [r4k]");
            add_opcodes($cpu, "ld <pp>, NNNN [r4k]");
            add_opcodes($cpu, "ld <pp>, <pd> [r4k]");
            add_opcodes($cpu, "ld <pp>, <pp>+DIS [r4k]");
            add_opcodes($cpu, "ld <pp>, <pp>+de [r4k]");
            add_opcodes($cpu, "ld <pp>, <pp>+hl [r4k]");
            add_opcodes($cpu, "ld <pp>, <pp>+ix [r4k]");
            add_opcodes($cpu, "ld <pp>, <pp>+iy [r4k]");
            add_opcodes($cpu, "ld <pp>, (htr+hl) [r4k]");
            add_opcodes($cpu, "ld <pp>, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld <pp>, (<pp>+hl) [r4k]");
            add_opcodes($cpu, "ld <pp>, (sp+N) [r4k]");
            add_opcodes($cpu, "ld (sp+N), <pp> [r4k]");
            add_opcodes($cpu, "ld <rp>, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld <rp>, (<pp>+hl) [r4k]");
			
			add_opcodes($cpu, "ld (<pp>+bc), hl [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), a [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), bcde [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), hl [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), jkhl [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), <pd> [r4k]");
			add_opcodes($cpu, "ld (<pp>+DIS), <rp> [r4k]");
			add_opcodes($cpu, "ld (<pp>+hl), a [r4k]");
			add_opcodes($cpu, "ld (<pp>+hl), bcde [r4k]");
			add_opcodes($cpu, "ld (<pp>+hl), jkhl [r4k]");
			add_opcodes($cpu, "ld (<pp>+hl), <pd> [r4k]");
			add_opcodes($cpu, "ld (<pp>+hl), <rp> [r4k]");
			
			add_opcodes($cpu, "ld (sp+hl), bcde [r4k]");
			add_opcodes($cpu, "ld (sp+hl), jkhl [r4k]");
        }

        add_opcodes($cpu, "ld <rp>', bc|de [r2ka]");
        add_opcodes($cpu, "ld hl, <x> [r2ka]");
        add_opcodes($cpu, "ld <x>, hl [r2ka]");

		add_opcodes($cpu, "lxi <r>, NN") if !$strict;
        add_opcodes($cpu, "lxi <rp>, NN") if !$strict;
        add_opcodes($cpu, "ld <rp>, NN [r2ka]");
        add_opcodes($cpu, "ld <x>, NN");

        add_opcodes($cpu, "lhld/shld [8080]") if !$strict;
        add_opcodes($cpu, "ld hl, (NN) [r2ka]");
        add_opcodes($cpu, "ld <x>, (NN) [r2ka]");
		add_opcodes($cpu, "ld <rp>, (NN) [r2ka]");

        add_opcodes($cpu, "ld hl, (hl+DIS) [r2ka]");
        add_opcodes($cpu, "ld hl, (iy+DIS) [r2ka]");
        add_opcodes($cpu, "ld hl, (ix+DIS) [r2ka]");

        add_opcodes($cpu, "ld (hl+DIS), hl [r2ka]");
        add_opcodes($cpu, "ld (<x>+DIS), hl [r2ka]");
        add_opcodes($cpu, "ld (<x>+DIS), N [r2ka]");
        add_opcodes($cpu, "ld (<x>+DIS), <r> [r2ka]");

        if ($ge_r4k) {
            add_opcodes($cpu, "ld hl, (<pp>+bc) [r4k]");
            add_opcodes($cpu, "ld hl, (<pp>+DIS) [r4k]");
            add_opcodes($cpu, "ld hl, (sp+hl) [r4k]");
            add_opcodes($cpu, "ld hl, lxpc [r4k]");
        }

        add_opcodes($cpu, "ld hl, (sp+N) [r2ka]");
        add_opcodes($cpu, "ld <x>, (sp+N) [r2ka]");
		add_opcodes($cpu, "ld (sp+N), hl [r2ka]");
        add_opcodes($cpu, "ld (sp+N), <x> [r2ka]");

		if ($ge_r4k) {
    		add_opcodes($cpu, "mov <r>, <r> [r4k]") if !$strict;
    		add_opcodes($cpu, "ld <r>, <r> [r4k]");
		}
        else {
    		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
    		add_opcodes($cpu, "ld <r>, <r> [r2ka]");
        }

        add_opcodes($cpu, "mvi <r>, N") if !$strict;
        add_opcodes($cpu, "ld <r>, N [r2ka]");
        add_opcodes($cpu, "ld <r>, (hl) [r2ka]");
        add_opcodes($cpu, "ld <r>, (<x>+DIS) [r2ka]");
        add_opcodes($cpu, "ld (hl), N [r2ka]");
        add_opcodes($cpu, "ld (hl), <r> [r2ka]");
        
        if ($ge_r4k) {
            add_opcodes($cpu, "ld (hl), bcde [r4k]");
            add_opcodes($cpu, "ld (hl), jkhl [r4k]");
        }

		add_opcodes($cpu, "sphl [8080]") if !$strict;
		add_opcodes($cpu, "ld sp, hl");
		add_opcodes($cpu, "ld sp, <x>");
		
		if ($ge_r4k) {
			add_opcodes($cpu, "ld (<x>+DIS), bcde|jkhl [r4k]");
		}

		add_opcodes($cpu, "ld (NN), <x> [r2ka]");
		
        add_opcodes($cpu, "ldi/ldir/ldd/lddr [r2ka]");
		
		if ($ge_r3k) {
			add_opcodes($cpu, "lddsr/ldisr [r3k]");	
		}
		
		if ($ge_r4k) {
			add_opcodes($cpu, "ldf a, (NNN) [r4k]");
			add_opcodes($cpu, "ldf hl, (NNN) [r4k]");
			add_opcodes($cpu, "ldf bcde, (NNN) [r4k]");
			add_opcodes($cpu, "ldf jkhl, (NNN) [r4k]");
			add_opcodes($cpu, "ldf <pp>, (NNN) [r4k]");
			add_opcodes($cpu, "ldf <rp>, (NNN) [r4k]");
			
			add_opcodes($cpu, "ldf (NNN), a [r4k]");
			add_opcodes($cpu, "ldf (NNN), hl [r4k]");
			add_opcodes($cpu, "ldf (NNN), bcde [r4k]");
			add_opcodes($cpu, "ldf (NNN), jkhl [r4k]");
			add_opcodes($cpu, "ldf (NNN), <pp> [r4k]");
			add_opcodes($cpu, "ldf (NNN), <rp> [r4k]");
			
			add_opcodes($cpu, "ldl <pp>, de [r4k]");
			add_opcodes($cpu, "ldl <pp>, hl [r4k]");
			add_opcodes($cpu, "ldl <pp>, <x> [r4k]");
			add_opcodes($cpu, "ldl <pp>, NN [r4k]");
			add_opcodes($cpu, "ldl <pp>, (sp+N) [r4k]");
		}
		
		add_opcodes($cpu, "ldp hl, (hl) [r2ka]");
		add_opcodes($cpu, "ldp hl, (<x>) [r2ka]");
		add_opcodes($cpu, "ldp hl, (NN) [r2ka]");
		add_opcodes($cpu, "ldp <x>, (NN) [r2ka]");
		add_opcodes($cpu, "ldp (hl), hl [r2ka]");
		add_opcodes($cpu, "ldp (<x>), hl [r2ka]");
		add_opcodes($cpu, "ldp (NN), hl [r2ka]");
		add_opcodes($cpu, "ldp (NN), <x> [r2ka]");
		
		add_opcodes($cpu, "ljp N, NN [r2ka]");
		add_opcodes($cpu, "lret [r2ka]");
		
		if ($ge_r4k) {
			add_opcodes($cpu, "llcall NN, NN [r4k]");
			add_opcodes($cpu, "llcall (jkhl) [r4k]");
			add_opcodes($cpu, "lljp <f>, NN, NN [r4k]");
			add_opcodes($cpu, "lljp NN, NN [r4k]");
			add_opcodes($cpu, "llret [r4k]");
		}		

		if ($ge_r3k) {
			add_opcodes($cpu, "lsddr/lsidr [r3k]");	
			add_opcodes($cpu, "lsdr/lsir [r3k]");	
		}
		
		add_opcodes($cpu, "mul [r2ka]");
		if ($ge_r4k) {
			add_opcodes($cpu, "mulu [r4k]");
		}
		
		add_opcodes($cpu, "neg [r2ka]");
		add_opcodes($cpu, "neg a [r2ka]") if !$strict;
		if ($ge_r4k) {
			add_opcodes($cpu, "neg bcde [r4k]");
			add_opcodes($cpu, "neg jkhl [r4k]");
			add_opcodes($cpu, "neg hl [r4k]");
		}

		add_opcodes($cpu, "nop");
		add_opcodes($cpu, "or hl, de [r2ka]");
		add_opcodes($cpu, "or <x>, de [r2ka]");
		if ($ge_r4k) {
			add_opcodes($cpu, "or jkhl, bcde [r4k]");
		}
		
        add_opcodes($cpu, "push/pop <r>") if !$strict;
        add_opcodes($cpu, "push/pop <rp> [r2ka]");
        add_opcodes($cpu, "push/pop <x>");
        add_opcodes($cpu, "push/pop ip [r2ka]");
		if ($ge_r4k) {
			add_opcodes($cpu, "push/pop bcde/jkhl [r4k]");
			add_opcodes($cpu, "push/pop <pp> [r4k]");
			add_opcodes($cpu, "push NN [r4k]");
		}	
		if ($ge_r3k) {
			add_opcodes($cpu, "push/pop su [r3k]");
			add_opcodes($cpu, "rdmode [r3k]");
		}
		
		add_opcodes($cpu, "ret");
		add_opcodes($cpu, "r<f>") if !$strict;
		add_opcodes($cpu, "r_<f>") if !$strict;
		add_opcodes($cpu, "ret <f>");
		
		add_opcodes($cpu, "reti");
		
		add_opcodes($cpu, "<rot-a> [8080]") if !$strict;
		add_opcodes($cpu, "<rot-a> [r2ka]");

		add_opcodes($cpu, "<rot> <r> [r2ka]");
		add_opcodes($cpu, "<rot> (hl) [r2ka]");
		add_opcodes($cpu, "<rot> (<x>+DIS) [r2ka]");

		add_opcodes($cpu, "rl de [r2ka]");
		if ($ge_r4k) {
			add_opcodes($cpu, "rl bc/hl [r4k]");
			add_opcodes($cpu, "rl B, bcde/jkhl [r4k]");
		}

        if ($ge_r4k) {
            add_opcodes($cpu, "rlb a, bcde/jkhl [r4k]");

			add_opcodes($cpu, "rlc bc/de [r4k]");
			add_opcodes($cpu, "rlc B, bcde/jkhl [r4k]");

			add_opcodes($cpu, "rr bc [r4k]");
			add_opcodes($cpu, "rr B, bcde/jkhl [r4k]");
        }
		
        add_opcodes($cpu, "rr de/hl [r2ka]");
        add_opcodes($cpu, "rr <x> [r2ka]");

        if ($ge_r4k) {
            add_opcodes($cpu, "rrb a, bcde/jkhl [r4k]");

			add_opcodes($cpu, "rrc bc/de [r4k]");
			add_opcodes($cpu, "rrc B, bcde/jkhl [r4k]");
        }

		add_opcodes($cpu, "rst NN");

        if ($ge_r4k) {
            add_opcodes($cpu, "setsysp NN [r4k]");
        }

        if ($ge_r3k) {
            add_opcodes($cpu, "setusr [r3k]");
            add_opcodes($cpu, "sures [r3k]");
            add_opcodes($cpu, "syscall [r3k]");
        }

        if ($ge_r4k) {
            add_opcodes($cpu, "setusrp NN [r4k]");
            add_opcodes($cpu, "sysret [r4k]");
        }

        # SJP smart jump not implemented - requires a third pass in the assembler

        if ($ge_r4k) {
			add_opcodes($cpu, "sla B, bcde/jkhl [r4k]");
			add_opcodes($cpu, "sll B, bcde/jkhl [r4k]");
			add_opcodes($cpu, "sra B, bcde/jkhl [r4k]");
			add_opcodes($cpu, "srl B, bcde/jkhl [r4k]");
        }

        if ($ge_r4k) {
            add_opcodes($cpu, "sub hl, de [r4k]");
            add_opcodes($cpu, "sub hl, jk [r4k]");
            add_opcodes($cpu, "sub jkhl, bcde [r4k]");
            add_opcodes($cpu, "test <> [r4k]");
        }
		
		if ($ge_r3k) {
			add_opcodes($cpu, "uma [r3k]");
			add_opcodes($cpu, "ums [r3k]");
		}
		
		if ($ge_r4k) {
			add_opcodes($cpu, "xor hl, de [r4k]");
			add_opcodes($cpu, "xor jkhl, bcde [r4k]");
		}

		if ($ge_r6k) {
			parse_r6k_opcodes($cpu);
			
			# add opcodes missing in spreadsheet
			for my $op ('add', 'adc', 'sbc') {
				for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a', '%n') {
					my $opcode = get_opcode($cpu, "$op a, $r") or die;
					cond_add_opcode($cpu, "$op $r", [$opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "altsd $op $r", [RABBIT_CONST('altsd'), $opcode->bytes], $opcode->{const});
				}
			}
			
			for my $op ('add', 'adc', 'sbc') {
				for my $idx ('(hl)', '(ix+%d)', '(iy+%d)') {
					my $opcode = get_opcode($cpu, "$op a, $idx") or die;
					cond_add_opcode($cpu, "$op $idx", [$opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "alts $op $idx", [RABBIT_CONST('alts'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "altsd $op $idx", [RABBIT_CONST('altsd'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioe $op $idx", [RABBIT_CONST('ioe'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioi $op $idx", [RABBIT_CONST('ioi'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "alts ioe $op $idx", [RABBIT_CONST('alts'), RABBIT_CONST('ioe'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "alts ioi $op $idx", [RABBIT_CONST('alts'), RABBIT_CONST('ioi'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioe alts $op $idx", [RABBIT_CONST('ioe'), RABBIT_CONST('alts'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioi alts $op $idx", [RABBIT_CONST('ioi'), RABBIT_CONST('alts'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "altsd ioe $op $idx", [RABBIT_CONST('altsd'), RABBIT_CONST('ioe'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "altsd ioi $op $idx", [RABBIT_CONST('altsd'), RABBIT_CONST('ioi'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioe altsd $op $idx", [RABBIT_CONST('ioe'), RABBIT_CONST('altsd'), $opcode->bytes], $opcode->{const});
					cond_add_opcode($cpu, "ioi altsd $op $idx", [RABBIT_CONST('ioi'), RABBIT_CONST('altsd'), $opcode->bytes], $opcode->{const});
				}
			}
			
			for my $r ('eir', 'iir') {
				my $opcode = get_opcode($cpu, "ld $r, a") or die;
				cond_add_opcode($cpu, "alts ld $r, a", [RABBIT_CONST('alts'), $opcode->bytes], $opcode->{const});
			}

			my $opcode = get_opcode($cpu, "ld xpc, hl") or die;
			cond_add_opcode($cpu, "ld lxpc, hl", [$opcode->bytes], $opcode->{const});
			cond_add_opcode($cpu, "alts ld lxpc, hl", [RABBIT_CONST('alts'), $opcode->bytes], $opcode->{const});
			
			for my $op ('rlb', 'rrb') {
				for my $r ('bcde', 'jkhl') {
					my $opcode = get_opcode($cpu, "$op a, $r") or die;
					cond_add_opcode($cpu, "altsd $op a, $r", [RABBIT_CONST('altsd'), $opcode->bytes], $opcode->{const});
				}
			}	
		}
    }
}

#------------------------------------------------------------------------------
# parse Excel opcode list
#------------------------------------------------------------------------------
use Spreadsheet::ParseXLSX;
use constant { 
	ASM => 0, 
	OPCODE => 1, 
	AD => 11,
	AS => 12,
	IO => 13,
};

sub parse_r6k_opcodes {
	my ($cpu) = @_;
	my $file = "Rabbit 6000 Instruction Spreadsheet.xlsx";
	my($sheet, $row) = get_spreadsheet($file);

	# parse opcodes
	my $opcodes = {};
	my $data;
	while (defined($data = get_spreadsheet_row($sheet, $row))) {
		parse_r6k_opcode($opcodes, $cpu, $data);
		$row++;
	}

	# create opcodes and all ALTD/ALTS/ALTSD/IOI/IOE variants
	for my $asm (sort keys %$opcodes) {
		for my $cpu (sort keys %{$opcodes->{$asm}}) {
			add_r6k_opcodes($asm, $cpu, $opcodes->{$asm}{$cpu});
		}
	}
}

sub get_spreadsheet {
	my($file) = @_;

	my $parser = Spreadsheet::ParseXLSX->new;
	my $workbook = $parser->parse($file);
	if (!defined $workbook) {
		die $parser->error(), ".\n";
	}

	my $sheet = $workbook->worksheet(0);
	my $row = 1;
	$sheet->get_cell($row, ASM)->unformatted() eq "Instruction" or die "Invalid file $file";
	for my $col (1..6) {
		$sheet->get_cell($row, OPCODE+$col-1)->unformatted() eq "Opcode  byte $col" or die "Invalid file $file";
	}
	$sheet->get_cell($row, AD)->unformatted() eq "AD" or die "Invalid file $file";
	$sheet->get_cell($row, AS)->unformatted() eq "AS" or die "Invalid file $file";
	$sheet->get_cell($row, IO)->unformatted() eq "IO" or die "Invalid file $file";

	$row++;
	return ($sheet, $row);
}

sub get_spreadsheet_row {
	my($sheet, $row) = @_;
	my %data;

	my $cell = $sheet->get_cell($row, ASM);
	return if !defined $cell;

	my $asm = $sheet->get_cell($row, ASM)->unformatted();
	$asm =~ s/,/, /g;
	return if $asm eq "";
	
	$data{asm} = $asm;
	
	# fix some typos in input
	for ($data{asm}) {
		s/\)\)/)/;
		s/(SBOX|IBOX) pp/$1 ps/;
		s/LD L\.L/LD L, L/;
		s/SBC \(/SBC A, (/;
	}
	
	$data{ops} = [];
	for my $col (1..6) {
		my $opcode = $sheet->get_cell($row, OPCODE+$col-1)->unformatted();
		last if $opcode eq "";
		push @{$data{ops}}, $opcode;
	}
	$data{ad} = $sheet->get_cell($row, AD)->unformatted();
	$data{as} = $sheet->get_cell($row, AS)->unformatted();
	$data{io} = $sheet->get_cell($row, IO)->unformatted();

	$data{const} = [];

	return \%data;
}

#------------------------------------------------------------------------------
# parse from Excel data
sub parse_r6k_opcode {
	my($opcodes, $cpu, $data) = @_;
	$data = clone($data);

	#say $data->{asm} if $data->{asm} =~ /LD r/;
	
	# convert multi-byte sequences
	if ($data->{asm} =~ /^FLAG cc, HL$/ && $data->{ops}[1] =~ /111x0100|10011100/) {
		# non-existing FLAG cc, HL opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^JP cc, mn$/ && 
				($data->{ops}[0] =~ /010x0011|01001011/ || $data->{ops}[1] =~ /010x0011|01001011/)) {
		# non-existing JP cc, mn opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^JR cc, e$/ && 
				($data->{ops}[0] =~ /100x0000|10001000/ || $data->{ops}[1] =~ /100x0000|10001000/)) {
		# non-existing JR cc, e opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^JRE cc, ee$/ && $data->{ops}[1] =~ /111x0011|10011011/) {
		# non-existing JRE cc, ee opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^LLJP cc, lxpc, mn$/ && $data->{ops}[1] =~ /111x0010|10011010/) {
		# non-existing LLJP cc, lxpc, mn opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^(ALTD|ALTS|ALTSD|IOE|IOI|ZDMA|ZINTACK)$/) {
		return;
	}
	elsif ($data->{asm} =~ /SP'/) {
		return;
	}
	elsif ($data->{asm} =~ /\bklmn\b/) {
		$data->{asm} =~ s/\bklmn\b/%m/;
		for (@{$data->{ops}}) {
			s/-+[klmn]-+/%m/;
		}
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}
	elsif ($data->{asm} =~ /\blmn\b/) {
		$data->{asm} =~ s/\blmn\b/%m/;
		for (@{$data->{ops}}) {
			s/-+[lmn]-+/%m/;
		}
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}
	elsif ($data->{asm} =~ /\bmn\b/) {
		$data->{asm} =~ s/\bmn\b/%m/;
		for (@{$data->{ops}}) {
			s/-+[mn]-+/%m/;
		}
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}
	elsif ($data->{asm} =~ /\blxpc\b/) {
		$data->{asm} =~ s/\blxpc\b/%x/;
		for (@{$data->{ops}}) {
			s/-+xp[lh]-+/%x/;
		}
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}
	elsif ($data->{asm} =~ /\bee\b/) {
		$data->{asm} =~ s/\bee\b/%J/;
		for (@{$data->{ops}}) {
			s/-+\(ee-[34]\)[lh]-+/%J/;
		}
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}
	elsif ($data->{asm} =~ /IP [0-3]/) {
		if ($data->{asm} =~ /IP 0/) {
			$data->{asm} =~ s/[0-3]/%c/;
			$data->{ops}[1] = '%c==0?0x46:%c==1?0x56:%c==2?0x4E:0x5E';
			$data->{const} = [0..3];
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		else {
			return;
		}
	}
	elsif ($data->{asm} =~ /^(RLA|RRA|RLC|RRC) 8\b/) {
		$data->{asm} =~ s/8/%c/;
		$data->{const} = [8];
		return parse_r6k_opcode($opcodes, $cpu, $data);
	}

	# convert binary data
	for my $i (0 .. $#{$data->{ops}}) {
		if ($data->{ops}[$i] =~ /^[01]{8}$/) {
			# convert binary to decimal
			$data->{ops}[$i] = oct("0b".$data->{ops}[$i]);
		}
		elsif ($data->{ops}[$i] =~ /^%[dnmjJx]$|^\d{1,3}$|%c/) {
			# already converted
		}
		elsif ($data->{ops}[$i] =~ /-+d-+/) {
			$data->{ops}[$i] = '%d';
			$data->{asm} =~ s/\bd\b/%d/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /-+n-+/) {
			$data->{ops}[$i] = '%n';
			$data->{asm} =~ s/\bn\b/%n/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /-+xpc-+/) {
			$data->{ops}[$i] = '%x';
			$data->{asm} =~ s/\bxpc\b/%x/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /-+\([je]-2\)-+/) {
			$data->{ops}[$i] = '%j';
			$data->{asm} =~ s/\b[je]\b/%j/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /-\(e-3\)-/) {
			$data->{ops}[$i] = '%j';
			$data->{asm} =~ s/\be\b/%j/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /-r-/) {
			for my $r ('B', 'C', 'D', 'E', 'H', 'L', 'A') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-r-/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br\b/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /-r'/) {
			for my $r ('B', 'C', 'D', 'E', 'H', 'L', 'A') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-r'/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br'/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /rna/) {
			for my $r ('B', 'C', 'D', 'E', 'H', 'L') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/rna/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br\b/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /-f-/) {
			for my $f ('NZ', 'Z', 'NC', 'C', 'LZ', 'LO', 'P', 'M') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-f-/ sprintf("%03b", F($f)) /e;
				$data1->{asm} =~ s/\bf\b/$f/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /cc/) {
			for my $f ('NZ', 'Z', 'NC', 'C') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/cc/ sprintf("%02b", F($f)) /e;
				$data1->{asm} =~ s/\bcc\b/$f/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /cx/) {
			for my $xf ('GT', 'GTU', 'LT', 'V') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/cx/ sprintf("%02b", XF($xf)) /e;
				$data1->{asm} =~ s/\bcc\b/$xf/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /-v-/) {
			$data->{ops}[$i] =~ s/-v-/000/;
			$data->{ops}[$i] = oct("0b".$data->{ops}[$i]);
			$data->{ops}[$i] = $data->{ops}[$i]."+(%c<8?%c*8:%c)";
			$data->{asm} =~ s/\bv\b/%c/;
			$data->{const} = [0x10,0x18,0x20,0x28,0x38];
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /[01]{2}-b-[01]{3}/) {
			$data->{ops}[$i] =~ s/-b-/000/;
			$data->{ops}[$i] = oct("0b".$data->{ops}[$i]);
			$data->{ops}[$i] = $data->{ops}[$i]."+8*%c";
			$data->{asm} =~ s/\bb\b/%c/;
			$data->{const} = [0..7];
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /bb$/) {
			$data->{ops}[$i] =~ s/bb$/00/;
			$data->{ops}[$i] = oct("0b".$data->{ops}[$i]);
			$data->{ops}[$i] = $data->{ops}[$i]."+%c-1";
			$data->{asm} =~ s/\bb\b/%c/;
			$data->{const} = [1,2,4];
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /ss/) {
			for my $rp ('BC', 'DE', 'HL', 'SP') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/ss/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bss\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /dd/) {
			for my $rp ('BC', 'DE', 'HL', 'SP') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/dd/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bdd\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /rr/) {
			for my $xrp ('BC', 'DE', 'IX', 'IY') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/rr/ sprintf("%02b", XRP($xrp)) /e;
				$data1->{asm} =~ s/\brr\b/$xrp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /zz/) {
			for my $rp ('BC', 'DE', 'HL', 'AF') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/zz/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bzz\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /xx/) {
			for my $rp ('BC', 'DE', 'IX', 'SP') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/xx/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bxx\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /yy/) {
			for my $rp ('BC', 'DE', 'IY', 'SP') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/yy/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\byy\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /(pp|ps|pd)/) {
			my $got = $1;
			for my $pp ('PW', 'PX', 'PY', 'PZ') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/$got/ sprintf("%02b", RABBIT_PP($pp)) /e;
				$data1->{asm} =~ s/\b$got\b/$pp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] !~ /^[01]+$/) {
			die "Invalid binary data: ", $data->{ops}[$i];
		}
		else {
			die dump $data;
		}
	}

	dedup_r6k_opcode($opcodes, $cpu, $data);
}

#------------------------------------------------------------------------------
# find and remove duplicates
sub dedup_r6k_opcode {
	my($opcodes, $cpu, $data) = @_;
	my $ac = Array::Compare->new;

	# convert letters to lower case except if preceeded by %
	$data->{asm} =~ s/ (?<!%) [A-Z] / lc($&) /gex;
	my $asm = $data->{asm};
	
	my @data_ops = @{$data->{ops}};
	#say $asm;

	state %want = (
		"ld (%m), hl" => [0x22, "%m", "%m"],
		"ld hl, (%m)" => [0x2A, "%m", "%m"],
		"ld b, b" => [0x7F, 0x40],
		"ld c, c" => [0x7F, 0x49],
		"ld d, d" => [0x7F, 0x52],
		"ld e, e" => [0x7F, 0x5B],
		"ld h, h" => [0x7F, 0x64],
		"ld l, l" => [0x7F, 0x6D],
		"ld a, a" => [0x7F, 0x7F],
	);

	if ($asm eq "ld hl', bc" && $ac->compare(\@data_ops, [0xED, 0x69])) {
		return;			# ignore, use [0x76, 0x81]
	}
	elsif ($asm eq "ld hl', de" && $ac->compare(\@data_ops, [0xED, 0x61])) {
		return;			# ignore, use [0x76, 0xA1]
	}

	my $prev = $opcodes->{$asm}{$cpu};
	if ($prev) {							# duplicate opcode
		my @prev_ops = @{$prev->{ops}};

		if ($ac->compare(\@prev_ops, \@data_ops)) {
			return;		# identical opcode
		}
		elsif ($data->{asm} =~ /^(rlc|rrc) %c, (bcde|jkhl)/) {	# merge two instructions
			if (@{$data->{const}} == 1 && $data->{const}[0] == 8) {
				$prev->{const} = [@{$prev->{const}}, @{$data->{const}}];
				$prev->{ops}[1] = "%c==8?".$data->{ops}[1].":".$prev->{ops}[1];
			}
			elsif (@{$prev->{const}} == 1 && $prev->{const}[0] == 8) {
				$prev->{const} = [@{$data->{const}}, @{$prev->{const}}];
				$prev->{ops}[1] = "%c==8?".$prev->{ops}[1].":".$data->{ops}[1];
			}
			else {
				die;
			}
		}
		elsif ($want{$asm}) {
			my @want_ops = @{$want{$asm}};
			if ($ac->compare(\@prev_ops, \@want_ops)) {
				return; 		# already selected correct one
			}
			elsif ($ac->compare(\@data_ops, \@want_ops)) {
				$opcodes->{$asm}{$cpu} = $data;		# select this one
			}
			else {
				return;		# none is correct
			}
		}
		elsif ($prev_ops[0] == 0x7F && $ac->compare(\@prev_ops, [0x7F, @data_ops])) {
			$opcodes->{$asm}{$cpu} = asm_in_7F_page($asm) ? $prev : $data;
		}
		elsif ($data_ops[0] == 0x7F && $ac->compare(\@data_ops, [0x7F, @prev_ops])) {
			$opcodes->{$asm}{$cpu} = asm_in_7F_page($asm) ? $data : $prev;
		}
		else {
			die "Duplicate opcode:\n", hex_dump($prev), "\n", hex_dump($data);
		}
	}
	else {
		$opcodes->{$asm}{$cpu} = $data;
	}
}

#------------------------------------------------------------------------------
# check if asm is the the 0x7F page
sub asm_in_7F_page {
	my($asm) = @_;
	
	for ($asm) {
		if (/^ld [bcdehla], [bcdehla]$/) {
			return 1;
		}
		elsif (/^(add|adc|sbc) a, (\(hl\)|[bcdehla])$/) {
			return 1;
		}
		elsif (/^(sub|and|xor|or|cp) (\(hl\)|[bcdehla])$/) {
			return 1;
		}
		else {
			return 0;
		}
	}
}

#------------------------------------------------------------------------------
# create opcodes and all ALTD/ALTS/ALTSD/IOI/IOE variants
sub add_r6k_opcodes {
	my($asm, $cpu, $data) = @_;
	
	my $ad = $data->{ad};
	my $as = $data->{as};
	my $io = $data->{io};
	my @ops = @{$data->{ops}};
	my @const = @{$data->{const}};
	
	# handle special cases
	if ($ad eq 's') {
		if ($asm eq "ex de, hl") {
			add_r6k_opcode("ex de, hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex de, hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex de, hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex de', hl") {
			add_r6k_opcode("ex de', hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex de', hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex de', hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex bc', hl") {
			add_r6k_opcode("ex bc', hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex bc', hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex bc', hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex bc, hl") {
			add_r6k_opcode("ex bc, hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex bc, hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex bc, hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex jkhl, bcde") {
			add_r6k_opcode("ex jkhl, bcde", $cpu, \@ops, \@const);
			add_r6k_opcode("ex jkhl', bcde", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex jkhl, bcde", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex jkhl, bcde'") {
			add_r6k_opcode("ex jkhl, bcde'", $cpu, \@ops, \@const);
			add_r6k_opcode("ex jkhl', bcde'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex jkhl, bcde'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex jk, hl") {
			add_r6k_opcode("ex jk, hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex jk, hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex jk, hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		elsif ($asm eq "ex jk', hl") {
			add_r6k_opcode("ex jk', hl", $cpu, \@ops, \@const);
			add_r6k_opcode("ex jk', hl'", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
			add_r6k_opcode("altd ex jk', hl", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		}
		else {
			die "Unexpected opcode: $asm, $cpu, ", hex_dump($data);
		}
	}
	elsif ($ad =~ /r/ && $as eq '') {
		my $asm1 = add_tick_altd($asm);
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		add_r6k_opcode($asm1, $cpu, [RABBIT_CONST('altd'), @ops], \@const) if $asm1;
		add_r6k_opcode("altd $asm", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
				add_r6k_opcode("$ioei ".$asm1, $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('altd'), @ops], \@const) if $asm1;
				add_r6k_opcode("$ioei altd $asm", $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('altd'), @ops], \@const);
				add_r6k_opcode("altd $ioei $asm", $cpu, [RABBIT_CONST('altd'), RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	elsif ($ad eq '' && $as =~ /r/) {
		my $asm1 = add_tick_alts($asm);
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		add_r6k_opcode($asm1, $cpu, [RABBIT_CONST('alts'), @ops], \@const) if $asm1;
		add_r6k_opcode("alts $asm", $cpu, [RABBIT_CONST('alts'), @ops], \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
				add_r6k_opcode("$ioei ".$asm1, $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('alts'), @ops], \@const) if $asm1;
				add_r6k_opcode("$ioei alts $asm", $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('alts'), @ops], \@const);
				add_r6k_opcode("alts $ioei $asm", $cpu, [RABBIT_CONST('alts'), RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	elsif ($ad =~ /r/ && $as =~ /r/) {
		my $asm1 = add_tick_alts($asm);
		$asm1 = add_tick_altd($asm1) if $asm1;
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		add_r6k_opcode($asm1, $cpu, [RABBIT_CONST('altsd'), @ops], \@const) if $asm1;
		add_r6k_opcode("altsd $asm", $cpu, [RABBIT_CONST('altsd'), @ops], \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
				add_r6k_opcode("$ioei ".$asm1, $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('altsd'), @ops], \@const) if $asm1;
				add_r6k_opcode("$ioei altsd $asm", $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('altsd'), @ops], \@const);
				add_r6k_opcode("altsd $ioei $asm", $cpu, [RABBIT_CONST('altsd'), RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	elsif ($ad eq 'f') {
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		add_r6k_opcode("altd $asm", $cpu, [RABBIT_CONST('altd'), @ops], \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
				add_r6k_opcode("$ioei altd $asm", $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('altd'), @ops], \@const);
				add_r6k_opcode("altd $ioei $asm", $cpu, [RABBIT_CONST('altd'), RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	elsif ($as eq 'f') {
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		add_r6k_opcode("alts $asm", $cpu, [RABBIT_CONST('alts'), @ops], \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
				add_r6k_opcode("$ioei alts $asm", $cpu, [RABBIT_CONST($ioei), RABBIT_CONST('alts'), @ops], \@const);
				add_r6k_opcode("alts $ioei $asm", $cpu, [RABBIT_CONST('alts'), RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	elsif ($ad eq '' && $as eq '') {
		add_r6k_opcode($asm, $cpu, \@ops, \@const);
		if ($io) {
			for my $ioei ('ioi', 'ioe') {
				add_r6k_opcode("$ioei $asm", $cpu, [RABBIT_CONST($ioei), @ops], \@const);
			}
		}			
	}
	else {
		die "$asm $cpu $ad $as $io"; 
	}
}

sub add_tick_altd {
	my($asm) = @_;
	if ($asm =~ /^ ( \w+ \s+ (?: %c \s* , \s* )? ) (a|f|b|c|d|e|h|l|af|bc|de|jk|hl|jkhl|bcde|pw|px|py|pz) (?!') \b (.*) /xi) {
		return "$1$2'$3";
	}
	else {
		return;
	}
}

sub add_tick_alts {
	my($asm) = @_;
	if ($asm =~ /^ ( \w+ \s+ (?: %c \s* , \s* )? [^,]+ , \s*) (a|f|b|c|d|e|h|l|af|bc|de|jk|hl|jkhl|bcde|pw|px|py|pz) $/xi) {
		return "$1$2'";
	}
	else {
		return;
	}
}

#------------------------------------------------------------------------------
# create one opcode if not already found
sub add_r6k_opcode {
	my($asm, $cpu, $ops, $const) = @_;
	my $ac = Array::Compare->new;

	# filter invalid opcodes
	$asm =~ /altd (io[ie] )?ld sp/ and return;
	$asm =~ /alts (io[ie] )?ld .*, sp/ and return;
	$asm =~ /altd ldf? i[xy]/ and return;
	$asm =~ /alts .*, (ix|iy|sp)$/ and return;
	
	# check if opcode exists already
	my $found = get_opcode($cpu, $asm);
	if ($found && 
		$ac->compare([$found->bytes], $ops) && 
		$ac->compare($found->{const}, $const)) {
		return;		# already defined
	}
	elsif ($found) {
		die "Duplicate opcode:\n", hex_dump($found), "\n", hex_dump({ops=>$ops, const=>$const});
	}
	else {
		add_opcode($cpu, $asm, $ops, $const);
	}	
}

#------------------------------------------------------------------------------
# dump with all numbers in hex
sub hex_dump {
	my($data) = @_;
	my $str = dump($data);
	$str =~ s/\b(\d+)\b/ sprintf("0x%02X", $1) /eg;
	return $str;
}

1;
