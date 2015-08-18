while(<>){
        if(/^s*$/){
                next;
        }elsif(/^(\d+:\d+:\d+,\d+)/){
                print "##########$_";
        }else{
                print "$_";
        }
}


=pod
while(<>){
        if(/^(\d+:\d+:\d+,\d+)/){
                print "##$_";
        }else{
                print "$_";
        }
}
=cut
