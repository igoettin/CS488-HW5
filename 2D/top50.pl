#############
#top50.pl
#############
#
#Perl script that counts how many genes are: 
#1. shared between S2N_ALL_out.txt and T_value_ALL_out.txt
#2. shared between S2N_AML_out.txt and T_value_AML_out.txt
#The results of the counts are then printed to the terminal.
#
#This script requires S2N_ALL_out.txt, S2N_AML_out.txt, T_value_ALL_out.txt, and T_value_AML_out.txt
#These files are generated from step 2A of this homework. 
#It is assumed these files are already sorted in descending order. 
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
    #for each gene in the S2N files
    for(my $i = 0; $i <= 50; $i++){
        #Skip the header row.
        if($i == 0){
            <$S2N_ALL_read>;
            <$T_value_ALL_read>;
            <$S2N_AML_read>;
            <$T_value_AML_read>;
        }
        else {
            #Read a gene from S2N files
            my @S2N_ALL_arr = (split(/,/,<$S2N_ALL_read>));
            my @S2N_AML_arr = (split(/,/,<$S2N_AML_read>));
            #for each gene in the T-value files
            for(my $j = 1; $j <= 50; $j++){
                #Read a gene from T-value files
                my @T_value_AML_arr = (split(/,/,<$T_value_AML_read>));
                my @T_value_ALL_arr = (split(/,/,<$T_value_ALL_read>));
                #If there is a match, increment the count
                if($S2N_ALL_arr[0] eq $T_value_ALL_arr[0]){$ALL_count++;}
                if($S2N_AML_arr[0] eq $T_value_AML_arr[0]){$AML_count++;}
            }
            #reset the T values back to the start of the file
            seek($T_value_ALL_read,0,0);
            seek($T_value_AML_read,0,0);
            #skip over the header row again
            <$T_value_ALL_read>;
            <$T_value_AML_read>;
        }
    }
    close($S2N_ALL_read);
    close($T_value_ALL_read);
    close($S2N_AML_read);
    close($T_value_AML_read);
    print "The number of top 50 common samples for ALL is: ".$ALL_count."\n";
    print "The number of top 50 common samples for AML is: ".$AML_count."\n";
}

top50("S2N_ALL_out.txt","T_value_ALL_out.txt","S2N_AML_out.txt","T_value_AML_out.txt");
