#!/usr/bin/perl

#------------------------------------------------------------------------------
# Beautify asm code
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use File::Copy;
use Config;
if ($Config{osname} eq 'MSWin32') {
    eval q(use Win32::Autoglob); $@ and die $@;
}

my $TAB = 4;
my $OPCODE = 2*$TAB;
my $ARGS = 4*$TAB;
my $COMMENT = 10*$TAB;
my $DEFVARS = 6*$TAB;
my $LEVEL = 1;
my $DEFVARSLEVEL = 0;

@ARGV or die "Usage: ",path($0)->basename," FILES...\n";
for my $asm (@ARGV) {
	open(my $in, "<", $asm) or die "$asm: $!\n";
	open(my $out, ">:raw", $asm.".new") or die "$asm.new: $!\n";
	while (<$in>) {
        my $line = parse_line($_);
        format_line($line, $out);
    }
    close($in);
    close($out);
    if (path($asm)->slurp eq path($asm.".new")->slurp) {
        unlink $asm.".new";
    }
    else {
        move($asm, $asm.".bak");
        move($asm.".new", $asm);        
        say "Formatted $asm";
    }
}

sub parse_line {
    local($_) = @_;
    s/\s+$//;
    my %ret;
    
    # line comment
    if (/^(\s*;.*|\s*)$/) {
        $ret{line_comment} = $1;
    }
    else {
        # label ?
        if (s/^\s*\.\s*(\w+)\s*//)                  { $ret{label} = $1; } 
        elsif (s/^\s*(\w+)\s*:\s*//)                { $ret{label} = $1; } 
        elsif (s/^\s*(\w+)\s+(equ)\b/$2/i)          { $ret{label} = $1; }

        # defvars
        if (s/^\s*(\w+)\s*DS\.\b//i) {
            $ret{defvars} = $1;
            $ret{args} = '';
            while (/\S/) {
                if (s/^\s+//)                       { $ret{args} .= " "; }
                elsif (s/^\s*(;.*)//)               { $ret{comment} = $1; }
                elsif (s/(\w+)//)                   { $ret{args} .= $1; }
                else { die; }
	    }
        }
        # macro 
        elsif (s/^\s*(\w+)\s*MACRO\b//i) {
            $ret{macro_label} = $1;
            $ret{args} = '';
            while (/\S/) {
                if (s/^\s*,\s*//)                   { $ret{args} .= ", "; }
                elsif (s/^\s*(.)//)                 { $ret{args} .= $1; }
                else { die; }
	    }
        }
        # #define
        elsif (s/^\s*(#DEFINE)\b//i) {
            $ret{opcode} = $1;
            $ret{args} = '';
            while (/\S/) {
                if (s/^\s*(\w+)//)                 { $ret{args} .= " " . $1; }
                else { die; }
	    }
        }
        # opcode
        elsif (s/^\s*(#?\w+)\s*//) {
            $ret{opcode} = $1;
            $ret{args} = '';
            while (/\S/) {
                if (s/^\s*,\s*//)                   { $ret{args} .= ", "; }
                elsif (s/^\s*(\'(\\.|[^\'])*\')//)  { $ret{args} .= $1; }
                elsif (s/^\s*(\"(\\.|[^\"])*\")//)  { $ret{args} .= $1; }
                elsif (s/^\s*(;.*)//)               { $ret{comment} = $1; }
                elsif (s/^\s*(.)//)                 { $ret{args} .= $1; }
                elsif (s/^\s+//)                    { $ret{args} .= " "; }
                else { die; }
            }
        }
        elsif (s/^\s*(;.*)//)                       { $ret{comment} = $1; }
	elsif (s/^\s*(\{|\})//)                       { $ret{opcode} = $1; $ret{args} = ''; }
        /\S/ and die "cannot parse: $_";
    }
    return \%ret;
}

sub format_line {
    my($line, $fh) = @_;
    if ($line->{line_comment}) { 
        say $fh $line->{line_comment}; 
    }
    else {
        my $out = '';
        if (($line->{opcode}//'') =~ /^equ$/i) {
            $line->{label} or die;
            $out .= $line->{label};
            $out = tab_to($out, $OPCODE);
            $out .= $line->{opcode};
            $out = tab_to($out, $ARGS);
            $out .= $line->{args};
        }
        elsif (($line->{opcode}//'') =~ /^#define$/i) {
            $out = tab_to($out, $OPCODE);
            $out .= $line->{opcode};
            $out .= "  ";
            $out = tab_to($out, $ARGS);
            $line->{args} =~ s/^\s+|\s+$//g;
            $out .= $line->{args};
        }
        elsif (($line->{opcode}//'') =~ /^(if|ifdef|ifndef|else|elif|elifdef|efifndef|endif)$/i) {
            $line->{label} and die;
            $LEVEL-- if $line->{opcode} =~ /^el|^end/i;
            $out .= "  " x $LEVEL;
            $out .= $line->{opcode};
            # If there are no args, don't add a tab
            if ("$line->{args}" ne "") {
                $out = tab($out);
            }
            $out .= $line->{args};
            $LEVEL++ if $line->{opcode} =~ /^el/i;
            $LEVEL++ if $line->{opcode} =~ /^if/i;
        }
        elsif (($line->{opcode}//'') =~ /^(\{|\})$/i) {
            $DEFVARSLEVEL-- if $line->{opcode} =~ /^\}$/i;

            $out = tab_to_newline($out, $OPCODE, $fh);
            $out .= " " x $TAB x $DEFVARSLEVEL;
            $out .= $line->{opcode};

            $DEFVARSLEVEL++ if $line->{opcode} =~ /^\{$/i;
        }
        else {
            if ($line->{label}) {
                $out .= $line->{label}.":";
            }
            if ($line->{opcode}) {
                $out = tab_to_newline($out, $OPCODE, $fh);
                $out .= " " x $TAB x $DEFVARSLEVEL;
                $out .= $line->{opcode};
                # If there are no args, don't add a tab
                if ("$line->{args}" ne "") {
                    $out = tab_to($out, $ARGS);
                }
                $out .= $line->{args};
            }
            if ($line->{macro_label}) {
                $out = $line->{macro_label};
                $out = tab_to($out, $OPCODE, $fh);
                $out .= "MACRO";
                $out = tab_to($out, $ARGS);
                $out .= $line->{args};
            }
            if ($line->{defvars}) {
                $out = tab_to($out, $OPCODE, $fh);
                $out .= " " x $TAB x $DEFVARSLEVEL;
                $out .= $line->{defvars};
                $out = tab_to($out, $DEFVARS);
                $out .= "ds.";
                $out .= $line->{args};
            }
        }
        
        if ($line->{comment}) {
            $out = tab_to_newline($out, $COMMENT, $fh);
            $out .= $line->{comment};
        }
        say $fh $out;
    }
}

sub tab {
    my($out) = @_;
    do {
        $out .= " ";
    } while ((length($out) % $TAB) != 0);
    return $out;
}

sub tab_to {
    my($out, $min_col) = @_;
    do {
        $out = tab($out);
    } while (length($out) < $min_col);
    return $out;
}

sub tab_to_newline {
    my($out, $min_col, $fh) = @_;
    if (length($out) >= $min_col) {
        say $fh $out; $out = '';
    }
    return tab_to($out, $min_col);
}
