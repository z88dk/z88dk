#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# vm1
#------------------------------------------------------------------------------

for my $cpu1 ('vm1') {
    for my $strict ( '', '_strict' ) {
        my $cpu = $cpu1 . $strict;

        add_opcodes( $cpu, "mov <r>, <r> [vm1]" );
        add_opcodes( $cpu, "mvi <r>, N [vm1]" );
        add_opcodes( $cpu, "ld <r>, <r> [vm1]" ) if !$strict;
        add_opcodes( $cpu, "ld <r>, N [vm1]" )   if !$strict;

        add_opcodes( $cpu, "lxi <r>, NN [vm1]" );
        add_opcodes( $cpu, "lxi <rp>, NN [vm1]" ) if !$strict;
        add_opcodes( $cpu, "ld <rp>, NN [vm1]" )  if !$strict;

        add_opcodes( $cpu, "lda/sta [vm1]" );
        add_opcodes( $cpu, "ld a, (NN) [vm1]" ) if !$strict;

        add_opcodes( $cpu, "lhld/shld [vm1]" );
        add_opcodes( $cpu, "ld hl, (NN) [vm1]" ) if !$strict;

        add_opcodes( $cpu, "ldax <r>/stax <r> [vm1]" );
        add_opcodes( $cpu, "ldax <rp>/stax <rp> [vm1]" ) if !$strict;
        add_opcodes( $cpu, "ld a, (<rp>) [vm1]" ) if !$strict;

        add_opcodes( $cpu, "xchg [8080]" );
        add_opcodes( $cpu, "ex de, hl" ) if !$strict;

        add_opcodes( $cpu, "<alu> <r> [vm1]" );
        add_opcodes( $cpu, "<alu> a, <r> [vm1]" ) if !$strict;
        add_opcodes( $cpu, "<alu-extra> a, <r> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "<alu> N [8080]" );
        add_opcodes( $cpu, "<alu> a, N" )       if !$strict;
        add_opcodes( $cpu, "<alu-extra> a, N" ) if !$strict;

        add_opcodes( $cpu, "inr/dcr <r> [vm1]" );
        add_opcodes( $cpu, "inc/dec <r> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "inx/dcx <r> [vm1]" );
        add_opcodes( $cpu, "inx/dcx <rp> [vm1]" ) if !$strict;
        add_opcodes( $cpu, "inc/dec <rp> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "dad <r> [vm1]" );
        add_opcodes( $cpu, "dad <rp> [vm1]" ) if !$strict;
        add_opcodes( $cpu, "add hl, <rp> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "daa" );
        add_opcodes( $cpu, "cma [8080]" );
        add_opcodes( $cpu, "cpl" )   if !$strict;
        add_opcodes( $cpu, "cpl a" ) if !$strict;
        add_opcodes( $cpu, "cmc [8080]" );
        add_opcodes( $cpu, "ccf" ) if !$strict;
        add_opcodes( $cpu, "stc [8080]" );
        add_opcodes( $cpu, "scf" ) if !$strict;

        add_opcodes( $cpu, "<rot-a> [8080]" );
        add_opcodes( $cpu, "<rot-a>" ) if !$strict;

        add_opcodes( $cpu, "jmp NN" );
        add_opcodes( $cpu, "jp NN" ) if !$strict;
        add_opcodes( $cpu, "j<f> NN" );
        add_opcodes( $cpu, "j_<f> NN" )     if !$strict;
        add_opcodes( $cpu, "jp NN [8080]" ) if $strict;
        add_opcodes( $cpu, "jmp <f>, NN" )  if !$strict;
        add_opcodes( $cpu, "jp <f>, NN" )   if !$strict;

        add_opcodes( $cpu, "pchl [vm1]" );
        add_opcodes( $cpu, "jp (hl) [vm1]" )  if !$strict;
        add_opcodes( $cpu, "jmp (hl) [vm1]" ) if !$strict;

        add_opcodes( $cpu, "call NN [vm1]" );
        add_opcodes( $cpu, "c<flag> NN [vm1]" );
        add_opcodes( $cpu, "c_<f> NN [vm1]" ) if !$strict;
        add_opcodes( $cpu, "cp NN [vm1]" ) if $strict;
        add_opcodes( $cpu, "call <f>, NN [vm1]" ) if !$strict;

        add_opcodes( $cpu, "rst NN [vm1]" );

        add_opcodes( $cpu, "ret [vm1]" );
        add_opcodes( $cpu, "r<f> [vm1]" );
        add_opcodes( $cpu, "r_<f> [vm1]" )   if !$strict;
        add_opcodes( $cpu, "ret <f> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "push/pop <r> [vm1]" );
        add_opcodes( $cpu, "push/pop <rp> [vm1]" ) if !$strict;

        add_opcodes( $cpu, "xthl [vm1]" );
        add_opcodes( $cpu, "ex (sp), hl [vm1]" ) if !$strict;

        add_opcodes( $cpu, "sphl [vm1]" );
        add_opcodes( $cpu, "ld sp, hl [vm1]" ) if !$strict;

        add_opcodes( $cpu, "in N [8080]" );
        add_opcodes( $cpu, "in a, (N)" ) if !$strict;
        add_opcodes( $cpu, "out N [8080]" );
        add_opcodes( $cpu, "out (N), a" ) if !$strict;

        add_opcodes( $cpu, "ei/di" );
        add_opcodes( $cpu, "hlt [8080]" );
        add_opcodes( $cpu, "halt" ) if !$strict;
        add_opcodes( $cpu, "nop" );

        add_opcodes( $cpu, "adc hl, <rp> [vm1]" );
        add_opcodes( $cpu, "dsub [vm1]" );
        add_opcodes( $cpu, "sbc hl, <rp> [vm1]" );
        add_opcodes( $cpu, "dcmp [vm1]" );
        add_opcodes( $cpu, "cpc hl, <rp> [vm1]" );
		
        add_opcodes( $cpu, "ld (hl), <alu> (hl) [vm1]" );
		
        add_opcodes( $cpu, "shlx [vm1]" );
        add_opcodes( $cpu, "lhlx [vm1]" );
		
        add_opcodes( $cpu, "jof [vm1]" );
		add_opcodes( $cpu, "smf0/smf1 [vm1]");
    }
}

sub add_opcode_vm1 {
	my($cpu, $asm, $ops, $const) = @_;
	
	# add original opcode
	if (!get_opcode($cpu, $asm)) {
		add_opcode($cpu, $asm, $ops, $const);
	}
	
	# check for hl', h', l', prefix RS (0x38)
	my $has_38 = grep {$_ == 0x38} @$ops;
	if (!$has_38) {
		my $asm1 = $asm =~ s/\b(pchl|xthl|sphl|hl|h|l)\b(?!')/$1'/gr;
		my $ops1 = [0x38, @$ops];
		if (!get_opcode($cpu, $asm1)) {
			add_opcode_vm1($cpu, $asm1, $ops1, $const);
		}
	}
	
	# check for memory access, prefix MB (0x28)
	my $has_28 = grep {$_ == 0x28} @$ops;
	if (!$has_28 &&								# already has the prefix
		($asm =~ /\(/ && $asm !~ /^j/ ||		# has parens and is not jump
		 $asm =~ /(?<!%)\bm\b/ && $asm !~ /^j/ || # has m, not %m and is not jump
		 $asm =~ /^(?:lda|sta|lhld|shld|ldax|stax|shlx|shlde|lhlx|lhlde)\b/	|| # Intel memory access
		 $asm =~ /^(?:push|pop|call|rst|ret|c(?:z|nz|c|nc|po|pe|m)|c_(?:z|nz|c|nc|po|pe|p|m)|r(?:z|nz|c|nc|po|pe|p|m)|r_(?:z|nz|c|nc|po|pe|p|m))\b/)) {	# stack
		my $asm1 = "mb $asm";
		my $ops1 = [0x28, @$ops];
		if (!get_opcode($cpu, $asm1)) {
			add_opcode_vm1($cpu, $asm1, $ops1, $const);
		}
	}
}
		
1;
