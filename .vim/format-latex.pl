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
sub breakLine {
    if ($nesting == 0) {
        # break the buffered into multiple lines for each sentence
        while ($buf =~ /
            (.*?[\p{Letter}]+[\.\?!])
            \s+
            ([\p{Uppercase Letter}\p{Hangul_Syllables}])
            /gx) {
            # each sentence ends with a period, and begins with an upper case
            print $1, "\n";
            substr($buf, 0, length($&)) = "$2";
        }
    }
    print $buf, "\n" if $buf ne "";
    $buf = "";
}
for my $line (<>) {
    chomp $line;
    if ($line =~ /^\s*%.*/) {
        passthru($line);
    } elsif ($line =~ /^(.*?)\s*(\\(begin|end|item|\[|\]|\$\$|part|chapter|((sub|)sub|)section|paragraph|label).*)$/) {
        buffer($1);
        breakLine();
        buffer($2);
        if ($3 eq "begin" or $3 eq "[") {
            $nesting++;
        } elsif ($3 eq "end" or $3 eq "]") {
            $nesting--;
            $nesting = 0 if $nesting lt 0; # could be formatting in the middle of things
        }
        breakLine();
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
breakLine();
