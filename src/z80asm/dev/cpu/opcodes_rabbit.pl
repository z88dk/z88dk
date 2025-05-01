#------------------------------------------------------------------------------
# r2ka, r3k, r4k, r5k
#------------------------------------------------------------------------------

for my $cpu1 ('r2ka', 'r3k', 'r4k', 'r5k') {
	for my $strict ('', '_strict') {
		my $cpu = $cpu1.$strict;
        my $ge_r3k = $cpu1 eq 'r3k' || $cpu1 eq 'r4k' || $cpu1 eq 'r5k';
		my $ge_r4k = $cpu1 eq 'r4k' || $cpu1 eq 'r5k';

        if (!$ge_r4k) {
            add_opcodes($cpu, "<alu> a, <r> [r2ka]");
            add_opcodes($cpu, "<alu-extra> a, <r> [r2ka]") if !$strict;
			add_opcodes($cpu, "<alu> <r> [8080]") if !$strict;
        }
        else {
            add_opcodes($cpu, "<alu> a, <r> [r4k]");
            add_opcodes($cpu, "<alu-extra> a, <r> [r4k]") if !$strict;
			add_opcodes($cpu, "<alu> <r> [8080/r4k]") if !$strict;
        }

        if (!$ge_r4k) {
			add_opcodes($cpu, "<alu> a, (hl) [r2ka]");
			add_opcodes($cpu, "<alu-extra> a, (hl) [r2ka]") if !$strict;
        }
        else {
			add_opcodes($cpu, "<alu> a, (hl) [r4k]");
			add_opcodes($cpu, "<alu-extra> a, (hl) [r4k]") if !$strict;
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

        if (!$ge_r4k) {
            add_opcodes($cpu, "jp <xf>, NN [r2ka]");
			add_opcodes($cpu, "j<xf>, NN [r2ka]") if !$strict;
        }
        else {
            add_opcodes($cpu, "jp <xf>, NN [r4k]");
			add_opcodes($cpu, "j<xf>, NN [r4k]") if !$strict;
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

        if (!$ge_r4k) {
    		add_opcodes($cpu, "mov <r>, <r>") if !$strict;
    		add_opcodes($cpu, "ld <r>, <r> [r2ka]");
        }
        else {
    		add_opcodes($cpu, "mov <r>, <r> [r4k]") if !$strict;
    		add_opcodes($cpu, "ld <r>, <r> [r4k]");
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
    }
}

1;
