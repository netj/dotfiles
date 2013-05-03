#!/usr/bin/perl -w
# format-latex.pl -- a filter LaTeX format program to keep a sentence per line
# Usage: From vim, :set formatprg=/path/to/format-latex.pl and use `gq'
# 
# See-Also: http://stackoverflow.com/questions/5706820/using-vim-isnt-there-a-more-efficient-way-to-format-latex-paragraphs-according
#
# Author: Jaeho Shin <netj@cs.stanford.edu>
# Created: 2013-02-18

use strict;
use feature 'unicode_strings';

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $nesting = 0;
my $buf = "";
sub buffer {
    my $line = shift;
    $buf .= " " if $buf ne "";
    $buf .= $line;
}
sub passthru {
    my $line = shift;
    breakLine();
    print $line, "\n";
}
sub sentence {
    my $sentence = shift;
    # clean up whitespace in each sentence
    $sentence =~ s/\s+/ /g;
    return $sentence;
}
sub breakLine {
    # preserve end-of-line comments
    $buf =~ s/^(.*?)(%.*)$/$1/;
    my $comment = $2 || "";
    if ($nesting == 0) {
        # break the buffered into multiple lines for each sentence
        while ($buf =~ /
            (.*?( [\p{Letter}\$\\{}]+ | \S*\$ )[\.\?!:;])
            \s+
            ([\p{Uppercase Letter}\p{Hangul_Syllables}])
            /gx) {
            # each sentence ends with a period, and begins with an upper case
            print sentence($1), "\n";
            substr($buf, 0, length($&)) = "$3";
        }
    }
    print sentence($buf), $comment, "\n" if $buf ne "";
    $buf = "";
}
sub process {
    my $line = shift;
    if ($line =~ /^\s*%.*/) {
        passthru($line);
    } elsif ($line =~ /^(.*?)(\s*)
        \\(begin|end|item|\[|\]|\$\$
          |part|chapter|((sub|)sub|)section|paragraph
          |label)
      /x) {
        my $texCommand = $3;
        my $rest = substr $line, length($&);
        buffer($1); breakLine();
        print ((length($1) > 0 ? "" : $2) . "\\$texCommand");
        # TODO break line after begin{...} etc?
        if ($texCommand eq "begin" or $texCommand eq "[") {
            $nesting++;
        } elsif ($texCommand eq "end" or $texCommand eq "]") {
            $nesting--;
            $nesting = 0 if $nesting lt 0; # could be formatting in the middle of things
        }
        process($rest);
    } else {
        if ($line =~ /^\s*$/) {
            passthru($line);
        } elsif ($nesting gt 0) {
            passthru($line);
        } elsif ($line =~ /^(.*)%(.*)/) {
            buffer($line);
            breakLine(); # never join lines to create comments
        } else {
            buffer($line);
        }
    }
}
for my $line (<>) {
    chomp $line;
    process($line);
}
breakLine();
