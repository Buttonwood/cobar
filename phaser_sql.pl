# perl  phaser_sql.pl slow-query.log >slow-query.log.csv

use POSIX;

$/="# Query_time:";
my $tbl = "%########%";
<>;
while(<>){
        next if /^s*$/;
        chomp;
        &get_sql($_);
}

sub get_sql{
        my $tmp = shift;
        my @arr = map{/^#|^--/ ? () : $_ } (split(/\n/,$tmp));
        for(my $i=0;$i<=$#arr;$i++){
                if($arr[$i] =~ /\s+(\d+\.\d+)\s+Lock_time:/){
                        #$qtime = $1;
                        print "$1$tbl";
                }
                if($arr[$i] =~ /^SET timestamp=(\d+);/){
                        &get_time($arr[$i]);
                        my $j = $i+1;
                        my $sql = ($j < $#arr) ? join(" ",@arr[$j .. $#arr]) : $arr[$j];
                        $sql = lc($sql);
                        $sql =~ s/\s+/ /g;
                        $sql =~ s/^\s+|\s+$//g;
                        $sql =~ s/\s+;/;/g;
                        print "$sql\n";
                        last;
                 }
        }
}

sub get_time{
        my $tmp  = shift;
        my @bbb  = split(/=|;/,$tmp);
        my $time = strftime("%Y-%m-%d %H:%M:%S",localtime($bbb[1]));
        print "$time$tbl$bbb[1]$tbl";
        #return  "$time#$bbb[1]#";
}

