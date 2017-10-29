#############
#top50.pl
#############
#
#
#
use strict;
use warnings;
sub top50{
    my($S2N_ALL,$T_value_ALL,$S2N_AML,$T_value_AML) = @_;
    open(my $S2N_ALL_read, "<", $S2N_ALL);
    open(my $T_value_ALL_read, "<", $T_value_ALL);
    open(my $S2N_AML_read, "<", $S2N_AML);
    open(my $T_value_AML_read, "<", $T_value_AML);
    my($ALL_count, $AML_count) = (0,0);
    for(my $i = 0; $i <= 51; $i++){
        if($i == 0){
            <$S2N_ALL_read>;
            <$T_value_ALL_read>;
            <$S2N_AML_read>;
            <$T_value_AML_read>;
        }
        else {
            my @S2N_ALL_arr = (split(/,/,<$S2N_ALL_read>));
            my @S2N_AML_arr = (split(/,/,<$S2N_AML_read>));
            for(my $j = 1; $j <= 51; $j++){
                my @T_value_AML_arr = (split(/,/,<$T_value_AML_read>));
                my @T_value_ALL_arr = (split(/,/,<$T_value_ALL_read>));
                print $S2N_ALL_arr[0] . " , " . $T_value_ALL_arr[0]. "\n";
                if($S2N_ALL_arr[0] eq $T_value_ALL_arr[0]){$ALL_count++;}
                if($S2N_AML_arr[0] eq $T_value_AML_arr[0]){$AML_count++;}
            }
            seek($T_value_ALL_read,0,0);
            seek($T_value_AML_read,0,0);
            <$T_value_ALL_read>;
            <$T_value_AML_read>;
        }
    }
    print "The number of top 50 common samples for ALL is: ".$ALL_count."\n";
    print "The number of top 50 common samples for AML is: ".$AML_count."\n";
}

top50("S2N_ALL_out.txt","T_value_ALL_out.txt","S2N_AML_out.txt","T_value_AML_out.txt");
