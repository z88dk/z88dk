#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/577
# z80asm: Ti83 and Ti83 apps can't be compiled

for ([call=>0xCD,0xC4], [ret=>0xC9,0xC0], [jp=>0xC3,0xC2], [jmp=>0xC3,0xC2]) {
	my($instr, $uncond_opcode, $cond_opcode) = @$_;

	for ([nz=>0],[z=>1],[nc=>2],[c=>3],[po=>4],[pe=>5],[nv=>4],[v=>5],[p=>6],[m=>7],
	     [ne=>0],[eq=>1],[geu=>2],[ltu=>3]) {
		my($flag, $flag_code) = @$_;
		
		my $var = ($flag =~ /^(c|m)$/) ? $flag."_" : $flag;
		my $cond_instr = ($instr eq "ret") ? "$instr $flag" : "$instr $flag, $var";
		my $uncond_instr = ($instr eq "ret") ? "$instr" : "$instr $var";
		
		z80asm_ok("-l -b", "", "", <<END,
					defc $var = 0x1234
			$instr:
					$cond_instr
					$uncond_instr
					defw $instr, $var
END
			bytes($cond_opcode+8*$flag_code, ($instr eq "ret") ? () : (0x34, 0x12),
				  $uncond_opcode, ($instr eq "ret") ? () : (0x34, 0x12),
				  0, 0, 0x34, 0x12));
	}
}

for ([nz=>0],[z=>1],[nc=>2],[c=>3]) {
	my($flag, $flag_code) = @$_;
	
	my $var = ($flag =~ /^(c|m)$/) ? $flag."_" : $flag;
	
	z80asm_ok("-l -b", "", "", <<END,
				defc $var = 0x12
		jr:
				jr $flag, $var
				jr $var
				defw jr, $var
END
		bytes(0x20+8*$flag_code, 0x12-2,
			  0x18, 0x12-4,
			  0, 0, 0x12, 0));
}

for ([ret=>0xC9,0xC0], [jp=>0xC3,0xC2], [jmp=>0xC3,0xC2]) {
	my($instr, $uncond_opcode, $cond_opcode) = @$_;

	for ([nz=>0],[z=>1],[nc=>2],[c=>3],[lz=>4],[lo=>5],[po=>4],[pe=>5],[p=>6],[m=>7]) {
		my($flag, $flag_code) = @$_;
		
		my $var = ($flag =~ /^(c|m)$/) ? $flag."_" : $flag;
		my $cond_instr = ($instr eq "ret") ? "$instr $flag" : "$instr $flag, $var";
		my $uncond_instr = ($instr eq "ret") ? "$instr" : "$instr $var";
		
		z80asm_ok("-mr2ka -l -b", "", "", <<END,
					defc $var = 0x1234
			$instr:
					$cond_instr
					$uncond_instr
					defw $instr, $var
END
			bytes($cond_opcode+8*$flag_code, ($instr eq "ret") ? () : (0x34, 0x12),
				  $uncond_opcode, ($instr eq "ret") ? () : (0x34, 0x12),
				  0, 0, 0x34, 0x12));
	}
}

for my $instr (qw( jp jmp )) {

	for ([nk=>0xDD],[k=>0xFD],[nx5=>0xDD],[x5=>0xFD]) {
		my($flag, $opcode) = @$_;
		
		my $var = $flag;
		
		z80asm_ok("-m8085 -l -b", "", "", <<END,
					defc $var = 0x1234
			$instr:
					$instr $flag, $var
					defw $instr, $var
END
			bytes($opcode, 0x34, 0x12,
				  0, 0, 0x34, 0x12));
	}
}

unlink_testfiles;
done_testing;
