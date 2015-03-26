#!/usr/bin/perl -w
# format-latex.pl -- a filter LaTeX format program to keep a sentence per line
# Usage:
#   From Vim, :set formatprg=/path/to/format-latex.pl and use `gq'
#   From Emacs, See: http://stackoverflow.com/questions/206806/filtering-text-through-a-shell-command-in-emacs
#   From Sublime, See: https://github.com/technocoreai/SublimeExternalCommand#readme
# 
# See-Also: http://stackoverflow.com/questions/5706820/using-vim-isnt-there-a-more-efficient-way-to-format-latex-paragraphs-according
# 
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
    $sentence =~ s/^\s+|\s+$//g;
    return $sentence;
}
sub breakLine {
    # preserve end-of-line comments
    $buf =~ s/^(.*?)(%.*)$/$1/;
    my $comment = $2 || "";
    if ($nesting == 0) {
        # break the buffered into multiple lines for each sentence
        while ($buf =~ /
                # Now, we try to recognize the end of a sentence scanning through the buffer considering the special cases first.
                (
                    # Sentences may appear between parentheses.
                    \s*\(\s* .*? [\.\?!] \s*\)
                |
                    # Most sentences simply end with a period, question mark, or an exclamation.
                    # Other punctuations can also end a sentence, but we need to look at what follows a little more carefully.
                    .*? [\.\?!:;]
                )
                # We assume there's always a punctuation followed by white spaces between two sentences.
                # Otherwise, we can't even distinguish punctuations at the end of a sentence from those appearing in the middle of ordinary words or terms.
                (\s+)
                (\S)
            /gx) {
            my $tail = $1; # end of the first sentence
            my $restpos = pos($buf) - length($3); # beginning position of the next sentence
            my $headlen = length($2);
            ## Check if we're breaking the line too soon, and look beyond for another sentence boundary if needed.
            # Try not to mistake etc., i.e., e.g., or et al. as the end of sentence.
            if ($tail =~ /(?: etc | i\.e | e\.g | et\s+al )\.$/x) {
                #print STDERR "% incomplete sentence=[$tail]\n% as it ends with=[$&]\n"; # XXX for debugging
                next;
            }
            # Don't treat numbered list items ending with period as an end of sentence, e.g.: "1. Blah blah. 2. Foo bar."
            elsif (substr($buf, 0, $restpos - $headlen) =~ /^\s*\d+\.$/) {
                print STDERR "% incomplete sentence=[$tail]\n% as it just began with a number=[$&]\n"; # XXX for debugging
                next;
            }
            # Try not to recognize colon or semicolon as end of sentence, unless the next sentence begins with the following cases:
            elsif ($tail =~ /[:;]$/ and substr($buf, $restpos) !~ /^\s*(:?
                    # an uppercase letter.
                    [\p{Uppercase Letter}]
                |
                    # a fully composed Korean letter.
                    [\p{Hangul_Syllables}]
                |
                    # sentences surrounded by parentheses.
                    \( .+? \)
                )/x) {
                #print STDERR "% incomplete sentence=[$tail]\n% as next will start with=[", substr($buf, $restpos, 1), "]\n"; # XXX for debugging
                next;
            }
            ## Okay, a sentence was found from the buffer, output it and throw it away.
            my $sentence = substr($buf, 0, $restpos - $headlen);
            print sentence($sentence), "\n";
            #print STDERR "% sentence=[$sentence]\n% rest=[", substr($buf, $restpos, 20), "...]\n"; # XXX for debugging
            substr($buf, 0, $restpos) = "";
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
