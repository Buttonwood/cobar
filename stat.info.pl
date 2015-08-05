use Data::Dumper;
my %log;
while(<>){
        chomp;
        my @tmp = split(/;/,$_);
        if($#tmp == 1){
                $log{$tmp[1]}{"log"}++;
        }
        if($#tmp >= 2){
                my $txt = join(" ",(split(/\s+/,$tmp[2]))[0,1]);
                $log{$tmp[1]}{$txt}++;
        }
}

#print Dumper(\%log);

foreach my $x (keys %log){
        foreach my $y (keys %{$log{$x}}){
                print $log{$x}{$y}.";$x;$y;\n";
        }
}
