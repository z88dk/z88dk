#!perl

# Convert z80asm manual from MultiMarkdown to html
# See also https://rawgit.com/fletcher/human-markdown-reference/master/index.html
# https://metacpan.org/pod/Text::MultiMarkdown

use Modern::Perl;
use Text::MultiMarkdown 'markdown';
use File::Basename;
use File::Slurp;

@ARGV or die "Usage: ",basename($0)," MMD_FILE...\n";

my $version = get_version("../hist.c");

convert_file($_, $version) for @ARGV;
exit 0;

sub convert_file {
	my($input, $version) = @_;
	(my $output = $input) =~ s/\.\w+$/.html/;
	$input eq $output and die "$input is not MMD\n";

	my $text = read_file($input);
	
	# add version
	$text =~ s/vX\.X\.X/v$version/g;
	
	# get title
	my($title) = $text =~ /^\s*(.*?)[ \t]*$/m;
	$title or die "Title not found in $input";
	
	$text = add_chapters($text);
	
	my $html = markdown(
					"title: $title\n".
#					"css: Oxygen.css\n".
					"\n".
					$text, 
				{
					document_format	=> 'Complete',
				});
	
	write_file($output, $html);
	say "$input -> $output";
}

# get version from file
sub get_version {
	my($file) = @_;
	my $text = read_file($file);
	$text =~ /^ \#define \s+ VERSION \s+ \" ([^\"]+) \" /xm
		or die "VERSION not found in $file";
	return $1;
}

# add chapter numbers to '#*' titles, add TOC to the end
sub add_chapters {
	my($text) = @_;
	my $ids = [];
	my $toc = "";
	
	$text =~ s/^(\#+)\s*(.*)/ chapter($1, $2, $ids, \$toc) /xgem;
	$text =~ s/\[TOC\]/$toc/g;
	
warn $text;
	return $text;
}

sub chapter {
	my($prefix, $text, $ids, $rtoc) = @_;
	
	$text =~ s/\#.*//;
	$text =~ s/\s+$//;
	
	if (length($prefix) > scalar(@$ids) + 1) {	# one level jumped
		die "level too deep at @$ids";
	}
	elsif (length($prefix) == scalar(@$ids) + 1) {	# one sub-level
		push @$ids, 1;
	}
	elsif (length($prefix) == scalar(@$ids)) {	# same sub-level
		@$ids or die;
		$ids->[-1]++;
	}
	else {										# drop all extra levels
		while (length($prefix) < scalar(@$ids)) {
			pop @$ids;
		}
		@$ids or die;
		$ids->[-1]++;
	}
	
	my $heading = join(".", @$ids).". $text";
	
	$$rtoc .= "### Index ###\n" unless $$rtoc;
	$$rtoc .= " " x (length($prefix)) ."- [$heading]  \n";
	
	return "$prefix $heading $prefix";
}

		
	
#<link rel="stylesheet" type="text/css" href="style/Oxygen.css" />
