#!/usr/bin/perlextidenovo.pl lines 1-36/36 (END)
use warnings;
use strict;

##usage: ./fasta_rename_nextdenovo.pl <fasta_file> <new_fasta>

##Written by Merce Montoliu-Nerin

##It will fix the fasta headers from the output fasta files of the Nextdenovo assembler (Version 2.5.0), to contain only the contig name
##Example:
##>ctg000000 type:s:linear length:i:1983515 node:i:215
##changes to:
##>ctg000000


open(FASTA, "<$ARGV[0]") || die("Usage: ./fasta_rename_nextdenovo.pl <fasta_file> <new_fasta>\n$!,aborted"); #Open original fasta, assembled by nextdenovo

open(OUTPUT, ">$ARGV[1]") || die("Usage: ./fasta_rename_nextdenovo.pl <fasta_file> <new_fasta>\n$!,aborted"); #File to output fasta with new shorter headers, suggestion nameofyourfasta_renamed.fasta

while (my $line = <FASTA>){
        chomp $line;
		{
                if ($line =~ /^(>ctg\d+)\ type.+\ length.+\ node.+/)                                          
			{
                        print OUTPUT "$1\n";
                        }
                 else
                        {
                        print OUTPUT "$line\n";
                        } 
		}
}

exit;

