use List::Util qw/sum/;

my $gap = 2;
my %data;
while(<>){
        chomp;
        my @t = split(";");
        my @a = split(/\s+|\:/,$t[1]);
        my $n = int($a[1] / $gap) * $gap;
        my $time = ($n < 10) ? "0$n:00:00" : "$n:00:00";
        push(@{$data{$a[0]}{$time}},$t[0]);
  }

use Data::Dumper;
#print Dumper(\%data);
#=pod
foreach my $key (sort(keys %data)){
        #print "$key;";
        #foreach ('00:00:00','06:00:00','12:00:00','18:00:00'){
        foreach (1 .. 24/$gap){
                my $n = ($_ - 1)*$gap;
                my $time = ($n < 10) ? "0$n:00:00" : "$n:00:00";
                if(exists $data{$key}{$time}){
                        my $CNT = $data{$key}{$time};
                        if(scalar(@$CNT) > 0){
                                printf "$key $time;%d;%0.4f;\n",scalar(@$CNT),sum(@$CNT)/scalar(@$CNT);
                        }
                }
        }
}
#=cut
