#!/usr/bin/env perl
use strict;
use warnings;

$/ = ""; # Set input separator to be blank to split on paragraphs
my $line;
my $balanced = qr/(\{(?:[^{}"]++|"(?:\\"|[^"])*"|(?-1))*+\})/;
while ($line = <>) {
    if ($line =~ /^[\d:.]+ <\d+\.\d+\.\d+> [^\(]*\(/) {
        $line .= <> until $line =~
            /[\d:.]+ <\d+\.\d+\.\d+> [^\(]*\(($balanced)/;
        print $1 . ".\n\n";
    }
}
