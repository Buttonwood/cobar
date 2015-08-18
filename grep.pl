# perl grep.pl case.csv slow-query.log.keys.csv

use IO::File;
open(IN,"<$ARGV[0]");
my $count = 0;
my %fh;
while(<IN>){
        chomp;
        my @t = split(";");
        $count++;
        my $file = "./tmp/".$count.".csv";
        my $FH = IO::File->new(">$file");
        if (defined $FH){
                $fh{$t[-1]} = $FH;
        }
}
close IN;

open(IN,"<$ARGV[1]");
while(<IN>){
        my @t = split(";");
        if(exists $fh{$t[2]}){
                #my $tmp = $fh{$t[2]};
                #print $tmp;
                #print $fh{$t[2]} "$_";
                $fh{$t[2]}->print("$_");
        }
}
close IN;

foreach my $tfh (keys %fh){
        $fh{$tfh}->close;
}
