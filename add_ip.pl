my %pip;
my %eip;
open(IN,"<ip.csv");
while(<IN>){
        chomp;
        my @arr = split /;/;
        $pip{$arr[0]}  = $arr[-1];
        $eip{$arr[-1]} = $arr[1];
}

#use Data::Dumper;
#print  Dumper(\%hash);
while(<>){
        chomp;
        my @arr = split /;/;
        if(exists $pip{$arr[1]}){
                my $name = $pip{$arr[1]};
                my $ip   = "*";
                if(exists $eip{$name}){
                        $ip = $eip{$name} ? $eip{$name} : $ip;
                }
                $arr[1] .= "|$ip|$name";
        }
        print join(";",@arr);
        print ";\n";
}
