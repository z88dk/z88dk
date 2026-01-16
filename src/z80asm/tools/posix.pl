#!/usr/bin/env perl
use strict;
use warnings;
use Time::HiRes qw(time);
use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);

# Optional wildcard expansion for Windows cmd.exe
my $HAVE_AUTOGLOB = 0;
if ($^O eq 'MSWin32') {
    eval {
        require Win32::Autoglob;
        Win32::Autoglob->import();
        $HAVE_AUTOGLOB = 1;
    };
}

@ARGV or die "usage: posix.pl COMMAND [ARGS...]\n";

my $cmd = shift @ARGV;

# -----------------------------
# cp
# -----------------------------
if ($cmd eq 'cp') {
    @ARGV == 2 or die "usage: cp SRC DST\n";
    my ($src, $dst) = @ARGV;
    copy($src, $dst)
        or die "cp: failed to copy '$src' to '$dst': $!\n";
    exit 0;
}

# -----------------------------
# mv
# -----------------------------
if ($cmd eq 'mv') {
    @ARGV == 2 or die "usage: mv SRC DST\n";
    my ($src, $dst) = @ARGV;

    if (!move($src, $dst)) {
        copy($src, $dst)
            or die "mv: failed to copy '$src' to '$dst': $!\n";
        unlink($src)
            or die "mv: failed to remove '$src': $!\n";
    }
    exit 0;
}

# -----------------------------
# rm
# -----------------------------
if ($cmd eq 'rm') {
    my $force = 0;
    my $recursive = 0;

    # Parse flags
    while (@ARGV && $ARGV[0] =~ /^-/) {
        my $flag = shift @ARGV;
        $force = 1 if $flag =~ /f/;
        $recursive = 1 if $flag =~ /r/;
    }

    # Expand wildcards on Windows if available
    @ARGV = map { glob($_) } @ARGV if $HAVE_AUTOGLOB;

    # rm -f with no files is OK
    @ARGV or exit 0 if $force;

    foreach my $path (@ARGV) {
        if (-d $path) {
            if ($recursive) {
                remove_tree($path, { error => \my $err });
                if (@$err && !$force) {
                    die "rm: failed to remove directory '$path'\n";
                }
            } else {
                die "rm: '$path' is a directory (use -r)\n" unless $force;
            }
        } elsif (-e $path) {
            unlink($path) or die "rm: cannot remove '$path': $!\n";
        } else {
            die "rm: '$path' does not exist\n" unless $force;
        }
    }

    exit 0;
}

# -----------------------------
# mkdir
# -----------------------------
if ($cmd eq 'mkdir') {
    my $parents = 0;

    while (@ARGV && $ARGV[0] =~ /^-/) {
        my $flag = shift @ARGV;
        $parents = 1 if $flag =~ /p/;
    }

    @ARGV == 1 or die "usage: mkdir [-p] DIR\n";
    my $dir = shift @ARGV;

    if ($parents) {
        make_path($dir, { error => \my $err });
        die "mkdir: failed to create '$dir'\n" if @$err;
    } else {
        mkdir($dir) or die "mkdir: cannot create '$dir': $!\n";
    }
    exit 0;
}

# -----------------------------
# touch
# -----------------------------
if ($cmd eq 'touch') {
    @ARGV >= 1 or die "usage: touch FILE...\n";

    # Expand wildcards on Windows if Win32::Autoglob is available
    @ARGV = map { glob($_) } @ARGV if $HAVE_AUTOGLOB;

    @ARGV or die "touch: no matching files\n";

	for my $file (@ARGV) {
		if (!-e $file) {
			open my $fh, '>', $file or die "touch: cannot create '$file': $!\n";
			close $fh;
		}

		my $now = time;
		utime $now, $now, $file
			or die "touch: cannot update timestamp on '$file': $!\n";
	}
    exit 0;
}

# -----------------------------
# install
# -----------------------------
if ($cmd eq 'install') {
    my $mode = 0755;
    my $preserve = 0;
    my $makedirs = 0;

    while (@ARGV && $ARGV[0] =~ /^-/) {
        my $flag = shift @ARGV;
        $mode     = oct($1) if $flag =~ /^-m(\d+)/;
        $preserve = 1       if $flag =~ /p/;
        $makedirs = 1       if $flag =~ /d/;
    }

    if ($makedirs) {
        for my $dir (@ARGV) {
            make_path($dir, { error => \my $err });
            die "install: failed to create '$dir'\n" if @$err;
            chmod $mode, $dir or die "install: chmod failed on '$dir': $!\n";
        }
        exit 0;
    }

    @ARGV == 2 or die "usage: install [-mMODE] [-p] SRC DST\n";
    my ($src, $dst) = @ARGV;

    copy($src, $dst)
        or die "install: failed to copy '$src' to '$dst': $!\n";

    chmod $mode, $dst
        or die "install: chmod failed on '$dst': $!\n";

    if ($preserve) {
        my @st = stat($src);
        utime $st[8], $st[9], $dst
            or die "install: utime failed on '$dst': $!\n";
    }
    exit 0;
}

# -----------------------------
# time
# -----------------------------
if ($cmd eq 'time') {
    @ARGV or die "usage: time COMMAND [ARGS...]\n";

    my $start = time;
    system(@ARGV);
    my $raw = $?;  # raw exit status
    my $end = time;

    my $real = $end - $start;

    my $hours   = int($real / 3600);
    my $minutes = int(($real - $hours * 3600) / 60);
    my $seconds = $real - $hours * 3600 - $minutes * 60;

    printf "%dh%02dm%.3fs\n", $hours, $minutes, $seconds;

    my $exit = ($raw >> 8) & 0xFF;
    exit $exit;
}

# -----------------------------
# dos2unix
# -----------------------------
if ($cmd eq 'dos2unix') {
    @ARGV >= 1 or die "usage: dos2unix FILE...\n";

    # Expand wildcards on Windows if Win32::Autoglob is available
    @ARGV = map { glob($_) } @ARGV if $HAVE_AUTOGLOB;

    @ARGV or die "dos2unix: no matching files\n";

    foreach my $file (@ARGV) {
        -f $file or die "dos2unix: '$file' is not a file\n";

        open my $in, '<:raw', $file
            or die "dos2unix: cannot open '$file' for reading: $!\n";
        local $/;
        my $data = <$in>;
        close $in;

        $data =~ s/\r\n/\n/g;

        open my $out, '>:raw', $file
            or die "dos2unix: cannot open '$file' for writing: $!\n";
        print $out $data;
        close $out;
    }

    exit 0;
}

# -----------------------------
# Unknown command
# -----------------------------
die "posix.pl: unknown command '$cmd'\n";