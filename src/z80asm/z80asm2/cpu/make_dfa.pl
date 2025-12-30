#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# Make C++ DFA to parse assembly from opcodes.dat

use Modern::Perl;
use Data::Dump qw( dump );
use FindBin;
use lib "$FindBin::Bin";   # adjust to find modules
use CsrBuilder;
use Keywords;
use TokenTypes;
use CPUs;
use DFA_Tokens;
use DFA_Leafs;
use Trie;
use DFA;

@ARGV==5 or die "Usage: $0 opcodes.dat keywords.def lexer.h cpu.def opcodes.cpp\n";
my($opcodes_dat_file, $keywords_file, $lexer_file, $cpus_file, $opcodes_cpp_file) = @ARGV;

my $keywords = Keywords->new;
$keywords->read_from_file($keywords_file);

my $token_types = TokenTypes->new;
$token_types->read_from_file($lexer_file);

my $cpus = CPUs->new;
$cpus->read_from_file($cpus_file);

my $dfa_tokens = DFA_Tokens->new;
my $dfa_leafs = DFA_Leafs->new;
my $trie = Trie->new($dfa_tokens, $dfa_leafs);
$trie->read_opcodes($opcodes_dat_file, $keywords);

my $dfa = DFA->new($dfa_tokens, $dfa_leafs);
$dfa->read_from_trie($trie);

# build CSR tables
my $state_count = scalar(@{ $dfa->states });
my $token_count = scalar(@{ $dfa_tokens->list });
my $csr_builder = CsrBuilder->new($state_count, $token_count);
for my $state_idx (0 .. $#{ $dfa->states }) {
    my $state = $dfa->states->[$state_idx];
    if (exists $state->{transitions}) {
        for my $dfa_token (keys %{ $state->{transitions} }) {
            my $token_idx = $dfa->dfa_tokens->by_key->{$dfa_token}{idx};
            my $target_idx = $state->{transitions}{$dfa_token}{state};
            $csr_builder->add_transition($state_idx, $token_idx, $target_idx);
        }
    }
}
$csr_builder->build();

# genetate code files
my $opcodes_def_file = $opcodes_cpp_file =~ s/\.cpp$/.def/r;
make_def_file($opcodes_def_file, $dfa, $keywords, $token_types);

my $opcodes_h_file = $opcodes_cpp_file =~ s/\.cpp$/.h/r;
make_h_file($opcodes_h_file, $dfa, $keywords, $token_types);

make_cpp_file($opcodes_cpp_file, $dfa, $keywords, $token_types);

exit 0;

#------------------------------------------------------------------------------
# make def file - to be included in the private section of OpcodesParser class
#------------------------------------------------------------------------------
sub make_def_file {
	my($def_file, $dfa, $keywords, $token_types) = @_;

    	open(my $fh, ">", $def_file) or die "open $def_file: $!";
	print $fh <<'END';
//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

END
    for my $i (0 .. $#{ $dfa->dfa_leafs->list }) {
        say $fh "void do_action_$i();";
    }

    close($fh);
}

#------------------------------------------------------------------------------
# make h file
#------------------------------------------------------------------------------
sub make_h_file {
	my($h_file, $dfa, $keywords, $token_types) = @_;

    	open(my $fh, ">", $h_file) or die "open $h_file: $!";
	print $fh <<'END';
//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>

enum class DFA_Token : int16_t {
END
    # Order token keys by their numeric idx instead of by name
    my $dfa_tokens = $dfa->dfa_tokens;
    for my $token_key (sort {
        $dfa_tokens->by_key->{$a}{idx} <=> $dfa_tokens->by_key->{$b}{idx}
        } keys %{ $dfa_tokens->by_key }) {
        my $token = $dfa_tokens->by_key->{$token_key};
        printf $fh "    %-24s = %d,\n", $token_key, $token->{idx}; 
    }
	print $fh <<END;
};

END

    close($fh);
}

#------------------------------------------------------------------------------
# make cpp file
# This version emits CSR arrays:
#  - state_offsets  : uint32_t [num_states+1]
#  - trans_tokens   : uint16_t [num_transitions]
#  - trans_targets  : int32_t  [num_transitions]
#  - accept_index   : int32_t  [num_states] (leaf idx or -1)
#------------------------------------------------------------------------------
sub make_cpp_file {
	my($cpp_file, $dfa, $keywords, $token_types) = @_;

    my $header = <<'END';
//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "macros.h"
#include "opcodes.h"
#include "opcodes_tables.h"
#include <cstdint>

END

    	open(my $fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # DFA size constants emitter
    # ----------------------------
    my $state_count = scalar(@{ $dfa->states });
    my $token_count = scalar(@{ $dfa->dfa_tokens->list });
    my $action_count = scalar(@{ $dfa->dfa_leafs->list });
	print $fh <<END;
// DFA size constants
const std::uint32_t OpcodesParser::StateCount = $state_count;
const std::uint16_t OpcodesParser::TokenCount = $token_count;
const std::uint16_t OpcodesParser::ActionCount = $action_count;

END

    $cpp_file =~ s/\.cpp/_1.cpp/;
    	open($fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # CPU -> DFA_Token map
    # ----------------------------
    my $count = scalar(@{ $cpus->list });
    print $fh <<END;
// map CPU to DFA_Token
const DFA_Token OpcodesParser::map_cpu_to_dfa_tokens[$count] = {
END
    my @cpu_dfa_tokens;
    for my $cpu (@{ $cpus->list }) {
        my $cpu_id = $cpu->{id};
        my $cpu_idx = $cpu->{idx};
        my $dfa_token = $cpu_id =~ s/^CPU::/CPU_/r;
        if (exists $dfa->dfa_tokens->by_key->{$dfa_token}) {
            $cpu_dfa_tokens[$cpu_idx] = ["DFA_Token::$dfa_token", $cpu_id];
        }
        else {
            $cpu_dfa_tokens[$cpu_idx] = ["DFA_Token::None", $cpu_id];
        }
    };

    for (@cpu_dfa_tokens) {
        my($dfa_token, $cpu_id) = @$_;
        printf $fh "    %-32s, // %s\n", $dfa_token, $cpu_id;
    } 
    print $fh <<'END';
};

END

    # ----------------------------
    # keyword -> DFA_Token map
    # ----------------------------
    $count = scalar(@{ $keywords->list });
    print $fh <<END;
// map Keyword to DFA_Token
const DFA_Token OpcodesParser::map_keyword_to_dfa_tokens[$count] = {
END
    my @keyword_dfa_tokens;
    for my $keyword (@{ $keywords->list }) {
        my $keyword_id = $keyword->{id};
        my $keyword_idx = $keyword->{idx};

        my $dfa_token = $keyword_id =~ s/^Keyword::/KW_/r;
        if (exists $dfa->dfa_tokens->by_key->{$dfa_token}) {
            $keyword_dfa_tokens[$keyword_idx] = ["DFA_Token::$dfa_token", $keyword_id];
        }
        else {
            $keyword_dfa_tokens[$keyword_idx] = ["DFA_Token::None", $keyword_id];
        }
    };

    for (@keyword_dfa_tokens) {
        my($dfa_token, $keyword_id) = @$_;
        printf $fh "    %-32s, // %s\n", $dfa_token, $keyword_id;
    } 
    print $fh <<'END';
};

END

    # ----------------------------
    # token type -> DFA_Token map
    # ----------------------------
    $count = scalar(@{ $token_types->list });
    print $fh <<END;
// map TokenType to DFA_Token
const DFA_Token OpcodesParser::map_token_type_to_dfa_tokens[$count] = {
END
    my @token_type_dfa_tokens;
    for my $token_type (@{ $token_types->list }) {
        my $token_type_id = $token_type->{id};
        my $token_type_idx = $token_type->{idx};

        my $dfa_token = $token_type_id =~ s/^TokenType::/TK_/r;
        if (exists $dfa->dfa_tokens->by_key->{$dfa_token}) {
            $token_type_dfa_tokens[$token_type_idx] = ["DFA_Token::$dfa_token", $token_type_id];
        }
        else {
            $token_type_dfa_tokens[$token_type_idx] = ["DFA_Token::None", $token_type_id];
        }
    }

    for (@token_type_dfa_tokens) {
        my($dfa_token, $token_type_id) = @$_;
        printf $fh "    %-24s, // %s\n", $dfa_token, $token_type_id;
    }
    print $fh <<'END';
};

END

    $cpp_file =~ s/_1\.cpp/_2.cpp/;
    	open($fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # CSR emitter: build flattened transition arrays and accept index
    # ----------------------------
    print $fh <<'END';
// CSR transition table (per-state compact lists)
//
// state_offsets: offsets into trans_tokens / trans_targets
//   transitions for state s are in range
//     [ state_offsets[s], state_offsets[s+1] )
END
    $csr_builder->emit_cpp($fh, 'OpcodesParser', '');


    $cpp_file =~ s/_2\.cpp/_3.cpp/;
    	open($fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # accept index per state
    # ----------------------------
    print $fh <<END;
// per-state accept leaf idx (-1 if none)
const std::int32_t OpcodesParser::accept_index[$state_count] = {
END
    for my $i (0 .. scalar(@{ $dfa->states }) - 1) {
        my $state = $dfa->states->[$i];
        my $accept_idx;
        if (exists $state->{end}) {
            # state->{end} is a leaf object; use its numeric idx
            $accept_idx = $state->{end}{idx};
        }
        else {
            $accept_idx = -1;
        }

        printf $fh "%6d, ", $accept_idx;
        print $fh "\n" if $i % 8 == 7;
    }
    print $fh <<'END';
};

END

    $cpp_file =~ s/_3\.cpp/_4.cpp/;
    	open($fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # Emit action dispatcher table
    # ----------------------------
    print $fh <<END;
// Action dispatcher
const OpcodesParser::Action OpcodesParser::accept_actions[$state_count] = {
END
    for my $i (0 .. $#{ $dfa->dfa_leafs->list }) {
        # Add pointer for each action
	    print $fh "    &OpcodesParser::do_action_$i,\n";
    }
    print $fh <<'END';
};

END

    $cpp_file =~ s/_4\.cpp/_5.cpp/;
    	open($fh, ">", $cpp_file) or die "open $cpp_file: $!";
    print $fh $header;

    # ----------------------------
    # emit action functions
    # ----------------------------
    for my $i (0 .. $#{ $dfa->dfa_leafs->list }) {
        my $leaf = $dfa->dfa_leafs->list->[$i];
        my @path = sort keys %{ $leaf->{path} };
        my $path = join("\n// ", @path);
        my $const = $leaf->{const};
        my $action = make_action($leaf);
        say $fh "// $path";
        say $fh "// $const" if $const;
        say $fh "void OpcodesParser::do_action_$i() {";
        print $fh "$action";
        say $fh "}\n";
    }

    close($fh);
}

sub make_action {
    my($leaf) = @_;
    my $code = "";

    # check if we need temp labels
    my $temp_end_label;
    if ($leaf->{ops} =~ /%t/g) {
        warn "test temp_end_label\n";
        $temp_end_label = 1;
        $code .= "    std::string temp_end_label = ".
                 "make_temp_label_name(\"END\");\n";
    }

    my @ops = split(';', $leaf->{ops});
    for my $op (@ops) {
        # hh hh hh hh
        if ($op =~ /^[0-9A-F ]+$/i) {
            $op =~ s/\s+//g;
            $code .= "    emit_bytes(0x$op);\n";
        }
        # hh hh hh %n
        elsif ($op =~ /^([0-9A-F]{2} )+%n$/) {
            $op =~ s/\s+//g;
            $op =~ s/%n/00/g;
            my $offset = length($op)/2 - 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteUnsigned);\n";
        }
        # hh hh %n %n
        elsif ($op =~ /^([0-9A-F]{2} )+%n %n$/) {
            $op =~ s/\s+//g;
            $op =~ s/%n/00/g;
            my $offset1 = length($op)/2 - 2;
            my $offset2 = $offset1 + 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset1, PatchRange::ByteUnsigned,\n".
                    "        $offset2, PatchRange::ByteUnsigned);\n";
        }
        # hh hh %d %n
        elsif ($op =~ /^([0-9A-F]{2} )+%d %n$/) {
            $op =~ s/\s+//g;
            $op =~ s/%[dn]/00/g;
            my $offset1 = length($op)/2 - 2;
            my $offset2 = $offset1 + 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset1, PatchRange::ByteSigned,\n".
                    "        $offset2, PatchRange::ByteUnsigned);\n";
        }
        # hh %n %s
        elsif ($op =~ /^([0-9A-F]{2} )+%n %s$/) {
            $op =~ s/\s+//g;
            $op =~ s/%[ns]/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteToWordUnsigned);\n";
        }
        # hh %n %s %s
        elsif ($op =~ /^([0-9A-F]{2} )+%n %s %s$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%[ns]/00/g;
            my $offset = length($op)/2 - 3;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteToPtr24Unsigned);\n";
        }
        # hh hh hh %d
        elsif ($op =~ /^([0-9A-F]{2} )+%d$/) {
            $op =~ s/\s+//g;
            $op =~ s/%d/00/g;
            my $offset = length($op)/2 - 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteSigned);\n";
        }
        # hh %d %s
        elsif ($op =~ /^([0-9A-F]{2} )+%d %s$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%[ds]/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteToWordSigned);\n";
        }
        # hh %d %s %s
        elsif ($op =~ /^([0-9A-F]{2} )+%d %s %s$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%[ds]/00/g;
            my $offset = length($op)/2 - 3;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteToPtr24Signed);\n";
        }
        # hh hh %d hh
        elsif ($op =~ /^[0-9A-F]{2} [0-9A-F]{2} %d [0-9A-F]{2}$/) {
            $op =~ s/\s+//g;
            $op =~ s/%d/00/g;
            my $offset = 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::ByteSigned);\n";
        }
        # %d
        elsif ($op =~ /^%d$/) {
            warn "test emit_bytes in op: $op\n";
            $code .= "    emit_bytes_expr(0x00,\n".
                    "        0, PatchRange::ByteSigned);\n";
        }
        # hh hh %m %m
        elsif ($op =~ /^([0-9A-F]{2} )+%m %m$/) {
            $op =~ s/\s+//g;
            $op =~ s/%m/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::Word);\n";
        }
        # hh hh %m %m %m
        elsif ($op =~ /^([0-9A-F]{2} )+%m %m %m$/) {
            $op =~ s/\s+//g;
            $op =~ s/%m/00/g;
            my $offset = length($op)/2 - 3;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::Ptr24);\n";
        }
        # hh hh %m %m %m %m
        elsif ($op =~ /^([0-9A-F]{2} )+%m %m %m %m$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%m/00/g;
            my $offset = length($op)/2 - 4;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::Dword);\n";
        }
        # hh hh %m %m %x
        elsif ($op =~ /^([0-9A-F]{2} )+%m %m %x$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%[mx]/00/g;
            my $offset_m = length($op)/2 - 3;
            my $offset_x = $offset_m + 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset_x, PatchRange::ByteUnsigned,\n".
                    "        $offset_m, PatchRange::Word);\n";
        }
        # hh hh %m %m %x %x
        elsif ($op =~ /^([0-9A-F]{2} )+%m %m %x %x$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%[mx]/00/g;
            my $offset_m = length($op)/2 - 4;
            my $offset_x = $offset_m + 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset_x, PatchRange::Word,\n".
                    "        $offset_m, PatchRange::Word);\n";
        }
        # hh hh %m1 %m1
        elsif ($op =~ /^([0-9A-F]{2} )+%m1 %m1$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%m1/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr_plus_one(0x$op,\n".
                    "        $offset, PatchRange::Word);\n";
        }
        # hh hh @func x
        elsif ($op =~ /^(([0-9A-F]{2} )+)\@(\w+) x\s*$/) {
            my($op1, $func) = ($1, $3);
            $op1 =~ s/\s+//g;
            my $offset = length($op1)/2;
            $code .= "    emit_bytes_func(0x${op1}0000,\n".
                    "        $offset, PatchRange::Word, \"$func\");\n";
        }
        # hh hh @func x x
        elsif ($op =~ /^(([0-9A-F]{2} )+)\@(\w+) x x\s*$/) {
            my($op1, $func) = ($1, $3);
            $op1 =~ s/\s+//g;
            my $offset = length($op1)/2;
            $code .= "    emit_bytes_func(0x${op1}000000,\n".
                    "        $offset, PatchRange::Ptr24, \"$func\");\n";
        }
        # hh hh %tN
        elsif ($op =~ /^(([0-9A-F]{2} )+)%t(\d*)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $label_offset) = ($1, $3);
            $op1 =~ s/\s+//g;
            my $offset = length($op1)/2;
            $label_offset = $label_offset eq '' ? 0 : -$label_offset;
            $code .= "    emit_bytes_temp_expr(0x${op1}00,\n".
                    "        $offset, PatchRange::JrOffset,\n".
                    "        temp_end_label, $label_offset);\n";
        }
        # hh hh %tN %tN
        elsif ($op =~ /^(([0-9A-F]{2} )+)%t(\d*) %t\3$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $label_offset) = ($1, $3);
            $op1 =~ s/\s+//g;
            my $offset = length($op1)/2;
            $label_offset = $label_offset eq '' ? 0 : -$label_offset;
            $code .= "    emit_bytes_temp_expr(0x${op1}0000,\n".
                    "        $offset, PatchRange::Word,\n".
                    "        temp_end_label, $label_offset);\n";
        }
        # hh hh %tN %tN %tN
        elsif ($op =~ /^(([0-9A-F]{2} )+)%t(\d*) %t\3 %t\3$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $label_offset) = ($1, $3);
            $op1 =~ s/\s+//g;
            my $offset = length($op1)/2;
            $label_offset = $label_offset eq '' ? 0 : -$label_offset;
            $code .= "    emit_bytes_temp_expr(0x${op1}000000,\n".
                    "        $offset, PatchRange::Ptr24,\n".
                    "        temp_end_label, $label_offset);\n";
        }
        # hh hh %M %M
        elsif ($op =~ /^([0-9A-F]{2} )+%M %M$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%M/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::WordBigEndian);\n";
        }
        # hh hh hh %h
        elsif ($op =~ /^([0-9A-F]{2} )+%h$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%h/00/g;
            my $offset = length($op)/2 - 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::HighOffset);\n";
        }
        # hh hh hh %d1
        elsif ($op =~ /^([0-9A-F]{2} )+%d1$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%d1/00/g;
            my $offset = length($op)/2 - 1;
            $code .= "    emit_bytes_expr_plus_one(0x$op,\n".
                    "        $offset, PatchRange::ByteSigned);\n";
        }
        # hh hh hh %j
        elsif ($op =~ /^([0-9A-F]{2} )+%j$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%j/00/g;
            my $offset = length($op)/2 - 1;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::JrOffset);\n";
        }
        # hh hh hh %J %J
        elsif ($op =~ /^([0-9A-F]{2} )+%J %J$/) {
            warn "test emit_bytes in op: $op\n";
            $op =~ s/\s+//g;
            $op =~ s/%J/00/g;
            my $offset = length($op)/2 - 2;
            $code .= "    emit_bytes_expr(0x$op,\n".
                    "        $offset, PatchRange::JreOffset);\n";
        }
        # hh hh %d dd+8*%c
        elsif ($op =~ /^([0-9A-F]{2} [0-9A-F]{2}) %d (\d+\+8\*%c)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $2);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            my $offset = 2;
            $leaf->{const} eq "0,1,2,3,4,5,6,7" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_8();\n";
            $code .= "    emit_bytes_expr(0x${op1}0000+${op2},\n".
                    "        $offset, PatchRange::ByteSigned);\n";
        }
        # hh hh dd+%c-1
        elsif ($op =~ /^(([0-9A-F]{2} )+)(\d+\+%c-1)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "1,2,4" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_124();\n";
            $code .= "    emit_bytes(0x${op1}00+${op2});\n";
        }
        # hh hh dd+8*%c
        elsif ($op =~ /^(([0-9A-F]{2} )+)(\d+\+8\*%c)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "0,1,2,3,4,5,6,7" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_8();\n";
            $code .= "    emit_bytes(0x${op1}00+${op2});\n";
        }
        # hh hh %c==8?dd:dd+c-1
        elsif ($op =~ /^(([0-9A-F]{2} )+)(%c==8\?\d+:\d+\+%c-1)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "1,2,4,8" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_1248();\n";
            $code .= "    emit_bytes(0x${op1}00+(${op2}));\n";
        }
        # hh hh %c==0?0x46:%c==1?0x56:0x5E
        elsif ($op =~ /^(([0-9A-F]{2} )+)(%c==0\?0x[0-9A-F]+:%c==1\?0x[0-9A-F]+:0x[0-9A-F]+)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "0,1,2" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_012();\n";
            $code .= "    emit_bytes(0x${op1}00+(${op2}));\n";
        }
        # hh hh %c==0?0x46:%c==1?0x56:%c==2?0x5E:0x4E
        elsif ($op =~ /^(([0-9A-F]{2} )+)(%c==0\?0x[0-9A-F]+:%c==1\?0x[0-9A-F]+:%c==2\?0x[0-9A-F]+:0x[0-9A-F]+)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "0,1,2,3" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_0123();\n";
            $code .= "    emit_bytes(0x${op1}00+(${op2}));\n";
        }
        # hh hh dd+%c %n
        elsif ($op =~ /^(([0-9A-F]{2} )+)(\d+\+%c) %n$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            my $offset = length($op1)/2 + 1;
            $leaf->{const} eq "0,1,2,3,4,5,6,7" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_8();\n";
            $code .= "    emit_bytes_expr(0x${op1}0000+((${op2})<<8),\n".
                    "        $offset, PatchRange::ByteUnsigned);\n";
        }
        # hh hh dd+%c
        elsif ($op =~ /^(([0-9A-F]{2} )+)(\d+\+%c)$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            $leaf->{const} eq "0,1,2,3,4,5,6,7" or
                die "unexpected const in leaf: ".$leaf->{const}."\n";
            $code .= "    int c = get_const_8();\n";
            $code .= "    emit_bytes(0x${op1}00+(${op2}));\n";
        }
        # hh dd+(%c<8?%c*8:%c)
        elsif ($op =~ /^(([0-9A-F]{2} )*)(\d+\+\(%c<8\?%c\*8:%c\))$/) {
            warn "test emit_bytes in op: $op\n";
            my($op1, $op2) = ($1, $3);
            $op1 =~ s/\s+//g;
            $op2 =~ s/%c/c/g;
            (my $get_const = "get_const_".$leaf->{const}) =~ s/,/_/g;
            $code .= "    int c = $get_const();\n";
            $code .= "    emit_bytes(0x${op1}00+(${op2}));\n";
        }
        else {
            die "unknown op in leaf: $op\n", dump($leaf);
        }
    }

    # make temp label
    if ($temp_end_label) {
        $code .= "    add_label_symbol(temp_end_label, 0);\n";
        warn "test emit_bytes in temp_end_label\n";
    }

    return $code;
}
