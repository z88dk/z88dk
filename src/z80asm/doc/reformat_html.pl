#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Convert z80asm manual from the format exported by Google Docs HTML
# format to CVS-friendly HTML (Google exports one single text line for 
# the whole document) and to .txt format

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
my $tree = MyParser->new_from_content($html_ori);

# beautify HTML - only write if changed to avoid make to call again
my $html = $tree->as_HTML(undef, "  ", {});

if ($html ne $html_ori) {
	say "Write $html_file";
	copy($html_file, "$html_file.bak");
	write_file($html_file, $html);
}

# generate TXT - always create file, to keep make happy
my $text_file = $html_file; 
$text_file =~ s/\.html?$/.txt/ or die "$html_file not HTML\n";
my $text_ori = read_file($text_file);

my $formatter = MyFormatter->new(leftmargin => 0, rightmargin => 80);
my $text = $formatter->format($tree);
$text = encode("iso-8859-1", $text);

if ($text ne $text_ori) {
	say "Write $text_file";
	copy($text_file, "$text_file.bak");
}
write_file($text_file, $text);

#------------------------------------------------------------------------------
# my HTML parser
package MyParser;

use Modern::Perl;
use base 'HTML::TreeBuilder';
use Text::Wrap;

sub new_from_content {
	my($class, $text) = @_;
	
	my $tree = $class->SUPER::new_from_content($text);

	my %left_margin = $tree->_get_left_margin;
	$tree->_insert_indent(%left_margin);
	$tree->_add_chapter_numbers;
	$tree->_separate_tags_text;

	return $tree;
}

# Get list of styles with corresponding margin sizes
sub _get_left_margin {
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
sub _insert_indent {
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
sub _add_chapter_numbers {
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
		
		$title = _chapter_title($level, $title, $ids);
		$title_element->delete_content;
		$title_element->push_content($title);
		
		# search for all <a href> pointing to this chaper, replace title
		for my $ref ($tree->look_down(_tag => 'a', href => '#'.$href_name)) {
			$ref->delete_content;
			$ref->push_content($title);
		}
	}
}

sub _chapter_title {
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

# add a "\n" after each tag and before each closing tag to separate tags
# from text
sub _separate_tags_text {
	my($tree) = @_;

	for my $elem ($tree->look_down(sub{1})) {
		next if $elem->tag eq 'style';
		
		# split all long lines
		for my $i (0 .. scalar($elem->content_list) - 1) {
			if (! ref($elem->content->[$i])) {
				$elem->content->[$i] = Text::Wrap::wrap("", "", $elem->content->[$i]);
				$elem->content->[$i] =~ s/^(\S+) (.+) (\S+)$/$1\n$2\n$3/s;
			}
		}
	}
}

#------------------------------------------------------------------------------
# my HTML to TEXT formatter
package MyFormatter;

use Modern::Perl;
use base 'HTML::FormatText';
use Text::Table;

sub textflow {
	my($self, $text) = @_;
	
	if ($self->{'table_stack'} && @{$self->{'table_stack'}}) {
		return; # ignore text within table
	}
	else {	
		return $self->SUPER::textflow($text);
	}
}	

sub table_start {
	my($self, $node) = @_;
	
	# save current table
	push @{$self->{'table_stack'}}, [$self->{'table_header'}, $self->{'table_data'}];
	$self->{'table_header'} = [];
	$self->{'table_data'} = [];
}

sub table_end {
	my($self, $node) = @_;

	# format table
	my @header = @{$self->{'table_header'}};
	my @data = @{$self->{'table_data'}};
	
	return unless @header || @data;
	
	if (! @header) {		# use first row as header
		@header = @{shift @data};
	}
	
	# add separators
	my @sep_header = (\"|");
	while (@header) {
		push @sep_header, shift(@header), \"|";
	}
	
	my $tb = Text::Table->new(@sep_header);
	$tb->load(@data);
	$self->pre_out($tb->rule('-', '+'));
	$self->pre_out($tb->title);
	$self->pre_out($tb->rule('-', '+'));
	
	my $last_row = $tb->body_height - 1;
	for my $row (0 .. $last_row) {
		$self->pre_out($tb->body($row));
		if ($row == $last_row) {
			$self->pre_out($tb->rule('-', '+'));
		}
		else {
			$self->pre_out($tb->body_rule);
		}
	}
	
	# restore previous from stack
	my($header, $data) = @{ pop @{$self->{'table_stack'}} };
	$self->{'table_header'} = $header;
	$self->{'table_data'} = $data;
}

sub th_start {
	my($self, $node) = @_;

	push @{ $self->{'table_header'} }, $node->as_trimmed_text;
}

sub th_end {
	1;
}

sub tr_start {
	my($self, $node) = @_;

	push @{ $self->{'table_data'} }, [];
}

sub tr_end {
	1;
}

sub td_start {
	my($self, $node) = @_;

	push @{ $self->{'table_data'}[-1] }, $node->as_trimmed_text;
}

sub td_end {
	1;
}
