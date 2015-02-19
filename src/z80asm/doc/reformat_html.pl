#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2015
#
# Convert z80asm manual from the format exported by Google Docs HTML
# format to CVS-friendly HTML (Google exports one single text line for 
# the whole document) and to .txt format
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/doc/reformat_html.pl,v 1.2 2015-02-19 22:05:12 pauloscustodio Exp $

use Modern::Perl;
use HTML::Tree;
use File::Basename;
use File::Copy;
use File::Slurp;
use Encode qw(encode);
use Data::Dump 'dump';

@ARGV==1 or die "Usage: ", basename($0), " HTML_FILE\n";

my $html_file = shift;
-f $html_file or die "File $html_file: not found\n";

my $html_ori = read_file($html_file);
my $tree = HTML::Tree->new_from_content($html_ori);

my %left_margin = get_left_margin($tree);
insert_indent($tree, %left_margin);
add_chapter_numbers($tree);

# beautify HTML
my $html = $tree->as_HTML(undef, "  ", {});

if ($html ne $html_ori) {
	say "Write $html_file";
	copy($html_file, "$html_file.bak");
	write_file($html_file, $html);
}

# generate TXT
my $text_file = $html_file; 
$text_file =~ s/\.html?$/.txt/ or die "$html_file not HTML\n";
my $text_ori = read_file($text_file);

my $formatter = MyFormatter->new(leftmargin => 0, rightmargin => 80);
my $text = $formatter->format($tree);
$text = encode("iso-8859-1", $text);

if ($text ne $text_ori) {
	say "Write $text_file";
	copy($text_file, "$text_file.bak");
	write_file($text_file, $text);
}

# Get list of styles with corresponding margin sizes
sub get_left_margin {
	my($tree) = @_;
	my %left_margin;
	my %margins;
	
	# search <style>
	my $style = $tree->find_by_tag_name('style');
	$style or return ();
	
	# check for c3{margin-left:36pt}
	for ($style->content_list) {
		for (split(/\}/, $_)) {
			my $name;
			my $margin;
			/(\w+)\{/ and $name = $1;
			/margin-left:(\d+)pt/ and $margin = 0+$1;
			if (defined($name) && defined($margin)) {
				$margins{$margin} ||= [];
				push @{$margins{$margin}}, $name;
			}
		}
	}
	
	# convert first size to 1, second size to 2, and so on
	my $tab = 1;
	for my $margin (sort {$a <=> $b} keys %margins) {
		for my $name (@{$margins{$margin}}) {
			$left_margin{$name} = $tab;
		}
		$tab++;
	}	

	return %left_margin;
}

# insert <OL> </OL> around every <p> with an indented style
# second run on the same file keeps content
sub insert_indent {
	my($tree, %left_margin) = @_;
	
	while (my($style, $tabs) = each %left_margin) {
		my @indented = $tree->look_down( 
				_tag => 'p', 
				sub { ($_[0]->attr('class') || "") =~ /\b$style\b/ }
			);
		for my $indented (@indented) {
			# make a copy
			my $indented_clone = $indented->clone;
			
			# move up the tree of <ol>
			for (1 .. $tabs) {
				my $parent = $indented->parent;
				my $parent_tag = $parent->attr('_tag');
				if ($parent_tag eq 'ol') {
					$parent->replace_with($indented);
				}
			}
					
			# insert indented copy
			my $child = $indented_clone;
			my $top_indent;
			for (1 .. $tabs) {
				$top_indent = HTML::Element->new('ol');
				$top_indent->push_content($child);
				$child = $top_indent;
			}
			
			$indented->replace_with($top_indent);
		}
	}
}

# add chapter numbers to '#*' titles, add TOC to the end
sub add_chapter_numbers {
	my($tree) = @_;
	my $ids = [];

	my @headers = $tree->look_down(sub { $_[0]->tag =~ /^h\d$/ });
	for my $header (@headers) {
		my($level, $href_name, $title, $title_element);
		
		# search for all headers, add chapter number
		$header->tag =~ /^h(\d+)/ and $level = 0+$1;
		defined $level or next;
		
		my @content = $header->content_list;
		for my $content (@content) {
			if ($content->tag eq 'a') {
				$href_name = $content->attr('name');
			}
			elsif ($content->tag eq 'span') {
				$title_element = $content;
				$title = $content->as_trimmed_text;
			}
		}
		defined($level) && defined($title) or next;
		
		$title = chapter_title($level, $title, $ids);
		$title_element->delete_content;
		$title_element->push_content($title);
		
		# search for all <a href> pointing to this chaper, replace title
		for my $ref ($tree->look_down(_tag => 'a', href => '#'.$href_name)) {
			$ref->delete_content;
			$ref->push_content($title);
		}
	}
}

sub chapter_title {
	my($level, $title, $ids) = @_;
	
	$title =~ s/^\s*(\d+\.)*\s*//;
	$title =~ s/\s+$//;
	
	if ($level > scalar(@$ids) + 1) {				# one level jumped
		die "level too deep at @$ids";
	}
	elsif ($level == scalar(@$ids) + 1) {			# one sub-level
		push @$ids, 1;
	}
	elsif ($level == scalar(@$ids)) {				# same sub-level
		@$ids or die;
		$ids->[-1]++;
	}
	else {								
		while ($level < scalar(@$ids)) {			# drop all extra levels
			pop @$ids;
		}
		@$ids or die;
		$ids->[-1]++;
	}
	
	$title = join(".", @$ids).". ".$title;

	return $title;
}


# my HTML to TEXT formatter
package MyFormatter;

use Modern::Perl;
use base 'HTML::FormatText';
use HTML::FormatText::WithLinks::AndTables;

sub parse {
    my($self, $html) = @_;

    return undef unless defined $html;
    return '' if $html eq '';

    my $tree = HTML::TreeBuilder->new->parse( $html );
    return $self->_format_tables( $tree ); # we work our magic...
}

sub _format_tables { 
	HTML::FormatText::WithLinks::AndTables::_format_tables(@_); 
}

