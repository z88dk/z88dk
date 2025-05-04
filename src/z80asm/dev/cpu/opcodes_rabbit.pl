#------------------------------------------------------------------------------
# r2ka, r3k, r4k, r5k, r6k
#------------------------------------------------------------------------------

use Modern::Perl;
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
		add_opcodes($cpu, "add sp, %s [r2ka]");
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

# parse from Excel data
sub parse_r6k_opcode {
	my($opcodes, $cpu, $data) = @_;
	$data = clone($data);

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
				($data->{ops}[0] =~ /100x0000/ || $data->{ops}[1] =~ /100x0000/)) {
		# non-existing JR cc, e opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^JRE cc, ee$/ && $data->{ops}[1] =~ /111x0011/) {
		# non-existing JRE cc, ee opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^LLJP cc, lxpc, mn$/ && $data->{ops}[1] =~ /111x0010/) {
		# non-existing LLJP cc, lxpc, mn opcodes, see Rabbit6000_Delta4000Instructions.xlsx
		return;
	}
	elsif ($data->{asm} =~ /^(ALTD|ALTS|ALTSD|IOE|IOI)$/) {
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
		elsif ($data->{ops}[$i] =~ /----d---/) {
			$data->{ops}[$i] = '%d';
			$data->{asm} =~ s/\bd\b/%d/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /----n---/) {
			$data->{ops}[$i] = '%n';
			$data->{asm} =~ s/\bn\b/%n/;
			return parse_r6k_opcode($opcodes, $cpu, $data);
		}
		elsif ($data->{ops}[$i] =~ /--xpc---?/) {
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
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-r-/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br\b/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /-r'/) {
			for my $r ('b', 'c', 'd', 'e', 'h', 'l', 'a') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-r'/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br'/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /rna/) {
			for my $r ('b', 'c', 'd', 'e', 'h', 'l') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/rna/ sprintf("%03b", R($r)) /e;
				$data1->{asm} =~ s/\br\b/$r/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /-f-/) {
			for my $f ('nz', 'z', 'nc', 'c', 'lz', 'lo', 'p', 'm') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/-f-/ sprintf("%03b", F($f)) /e;
				$data1->{asm} =~ s/\bf\b/$f/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /cc/) {
			for my $f ('nz', 'z', 'nc', 'c') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/cc/ sprintf("%02b", F($f)) /e;
				$data1->{asm} =~ s/\bcc\b/$f/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /cx/) {
			for my $xf ('gt', 'gtu', 'lt', 'v') {
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
			for my $rp ('bc', 'de', 'hl', 'sp') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/ss/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bss\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /dd/) {
			for my $rp ('bc', 'de', 'hl', 'sp') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/dd/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bdd\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /rr/) {
			for (['bc'=>0], ['de'=>1], ['ix'=>2], ['iy'=>3]) {
				my($rp, $v) = @$_;
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/rr/ sprintf("%02b", $v) /e;
				$data1->{asm} =~ s/\brr\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /zz/) {
			for my $rp ('bc', 'de', 'hl', 'af') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/zz/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bzz\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /xx/) {
			for my $rp ('bc', 'de', 'ix', 'sp') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/xx/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\bxx\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /yy/) {
			for my $rp ('bc', 'de', 'iy', 'sp') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/yy/ sprintf("%02b", RP($rp)) /e;
				$data1->{asm} =~ s/\byy\b/$rp/;
				parse_r6k_opcode($opcodes, $cpu, $data1);
			}
			return;
		}
		elsif ($data->{ops}[$i] =~ /p[sdp]/) {
			for my $pp ('pw', 'px', 'py', 'pz') {
				my $data1 = clone($data);
				$data1->{ops}[$i] =~ s/p[sdp]/ sprintf("%02b", RABBIT_PP($pp)) /e;
				$data1->{asm} =~ s/\bp[sdp]\b/$pp/;
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

# find and remove duplicates
sub dedup_r6k_opcode {
	my($opcodes, $cpu, $data) = @_;

	my $asm = $data->{asm} = lc($data->{asm});
	if ($asm eq "ld (%m), hl" && @{$data->{ops}} == 3) {
		return;		# 0x22 is shorter
	}
	elsif ($asm eq "ld hl, (%m)" && @{$data->{ops}} == 3) {
		return;		# 0x2A is shorter
	}
	elsif ($asm eq "ldf (%m), hl" && @{$data->{ops}} == 4) {
		return;		# 0x82 is shorter
	}
	elsif ($asm eq "ldf hl, (%m)" && @{$data->{ops}} == 4) {
		return;		# 0x92 is shorter
	}
	elsif ($asm =~ /ld \(%m\), (bcde|jkhl)/ && @{$data->{ops}} == 4) {
		return;		# use the three-byte version
	}
	elsif ($asm =~ /ld (bcde|jkhl), \(%m\)/ && @{$data->{ops}} == 4) {
		return;		# use the three-byte version
	}
	elsif ($asm =~ /ld (bcde|jkhl), %d/ && @{$data->{ops}} == 3) {
		return;		# use the two-byte version
	}
	elsif ($asm =~ /(add|adc|sbc) a,/ && @{$data->{ops}} == 1) {
		return;		# use the 0x7F version with two opcodes
	}
	elsif ($asm =~ /(sub|and|xor|or|cp) / && @{$data->{ops}} == 1) {
		return;		# use the 0x7F version with two opcodes
	}
	elsif ($asm =~ /ld [abcdehl], [abcdehl]/ && @{$data->{ops}} == 1) {
		return;		# use the 0x7F version with two opcodes
	}
	elsif ($asm =~ /ld [abcdehl], [abcdehl]/ && @{$data->{ops}} == 2 && $data->{ops}[0] == 0x6D) {
		return;		# use the 0x7F version instead of the 0x6D version
	}
	elsif ($asm =~ /(rlc|rrc|rl|rr) (bc|de|hl)/ && @{$data->{ops}} == 2) {
		return;		# use the single-byte version
	}
	elsif ($asm =~ /ld (bc|de|hl), (bc|hl|de)/ && @{$data->{ops}} == 2) {
		return;		# use the single-byte version
	}
	elsif ($asm =~ /ld hl, \((pw|px|py|pz)\+%d\)/ && @{$data->{ops}} == 3) {
		return;		# use the two-byte version
	}
	elsif ($asm =~ /ld \((pw|px|py|pz)\+%d\), hl/ && @{$data->{ops}} == 3) {
		return;		# use the two-byte version
	}
	elsif ($asm =~ /ex (bc|jkhl), (hl|bcde)/ && @{$data->{ops}} == 2) {
		return;		# use the single-byte version
	}
	elsif ($asm =~ /add hl, jk/ && @{$data->{ops}} == 2) {
		return;		# use the single-byte version
	}
	elsif ($asm =~ /jr (gt|gtu|lt|v), %j/ && @{$data->{ops}} == 3) {
		return;		# use the two-byte version
	}
	elsif ($asm =~ /jp (gt|gtu|lt|v), %m/ && @{$data->{ops}} == 4) {
		return;		# use the three-byte version
	}
	elsif ($opcodes->{$asm}{$cpu}) {
		# duplicate opcode
		my $prev = $opcodes->{$asm}{$cpu};
		if ($asm =~ /(rlc|rrc) %c, (bcde|jkhl)/) {
			# merge two instructions
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
			say "$prev->{asm}, @{$prev->{ops}}, $prev->{ad}, $prev->{as}, $prev->{io}, @{$prev->{const}}";
		}
		else {
			die "Duplicate opcodes:\n", dump($opcodes->{$asm}{$cpu}), "\n", dump($data), "\n";
		}
	}
	else {
		$opcodes->{$asm}{$cpu} = $data;
		say "$data->{asm}, @{$data->{ops}}, $data->{ad}, $data->{as}, $data->{io}, @{$data->{const}}";
	}
}

1;
