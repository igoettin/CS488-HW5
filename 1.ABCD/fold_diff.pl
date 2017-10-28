###############
#fold_diff.pl
###############
#
#Perl script that calculates the fold difference of each gene in the file ALL_AML_gr.thr.train.csv
#
#The results of the calculation are written to the file "genes_fold_differences.txt"
#The format of genes_fold_differences.txt is G,F where G is the gene name and F is the fold difference for that gene.
#
use strict;
use warnings;
sub calculate_fold_diff{
    my($input_filename, $output_filename, $print_stats_flag) = @_;
    open(my $read_file, "<", $input_filename);
    open(my $write_file, ">", $output_filename);
    print $write_file "Gene,Fold_Difference\n";
    my @range_counts = (0,0,0,0,0,0,0,0,0,0);
    #largest_fold_diff set to 1 so it can be increased, lowest_fold_diff set to 800 so it can be decreased.
    my($skip_ID_row,$largest_fold_diff,$lowest_fold_diff,$largest_count,$lowest_count) = (1,1,800,0,0);
    while(my $row = <$read_file>){
        if($skip_ID_row){$skip_ID_row = 0;}
        else{
            #max_value set to 20 so it can be increased, min_value set to 16000 so it can be decreased.
            my($gene_name,$max_value,$min_value,$skip_gene_name) = ("",20,16000,1);
            foreach my $element (split(/,/,$row)){
                if($skip_gene_name){
                    $gene_name = $element;
                    $skip_gene_name = 0;
                }
                else{
                    if($element < $min_value){$min_value = $element;}
                    elsif($element > $max_value){$max_value = $element;}
                }
            }
            my $fold_diff = $max_value / $min_value;
            #Check if the fold_diff is the largest or lowest seen so far
            #Reset the count if so.
            if($fold_diff > $largest_fold_diff){
                $largest_fold_diff = $fold_diff;
                $largest_count = 1;
            }
            elsif($fold_diff < $lowest_fold_diff){
                $lowest_fold_diff = $fold_diff;
                $lowest_count = 1;
            }
            #Increment the count if fold_diff is largest or lowest
            elsif($fold_diff == $largest_fold_diff){$largest_count++;}
            elsif($fold_diff == $lowest_fold_diff){$lowest_count++;}
            #Increment the range_count array depending on where fold_diff falls into the range
            if($fold_diff <= 2){$range_counts[0]++;}
            elsif($fold_diff > 2 && $fold_diff <= 4){$range_counts[1]++;}
            elsif($fold_diff > 4 && $fold_diff <= 8){$range_counts[2]++;}
            elsif($fold_diff > 8 && $fold_diff <= 16){$range_counts[3]++;}
            elsif($fold_diff > 16 && $fold_diff <= 32){$range_counts[4]++;}
            elsif($fold_diff > 32 && $fold_diff <= 64){$range_counts[5]++;}
            elsif($fold_diff > 64 && $fold_diff <= 128){$range_counts[6]++;}
            elsif($fold_diff > 128 && $fold_diff <= 256){$range_counts[7]++;}
            elsif($fold_diff > 256 && $fold_diff <= 512){$range_counts[8]++;}
            elsif($fold_diff > 512){$range_counts[9]++;}
            #Write the gene name and its corresponding fold_diff to the output file
            my $result_line = $gene_name . "," . $fold_diff . "\n";
            print $write_file $result_line;
        }
    }
    #Print the statistics for the fold differences if the flag was set.
    if($print_stats_flag == 1){
        print "Statistics generated when calculating the fold difference of genes in ".$input_filename.":\n";
        print "-----------------------------------------------------------\n";
        print "The largest fold difference is ".$largest_fold_diff." with ".$largest_count." genes having it.\n";
        print "The lowest fold difference is ".$lowest_fold_diff." with ".$lowest_count." genes having it.\n";
        print "-----------------------------------------------------------\n";
        print "Counts of fold differences that fall within each range:\n";
        print "==============================\n";
        print "Range            |       Count\n";
        print "Val <= 2         |       ".$range_counts[0]."\n";
        print "2 < Val <= 4     |       ".$range_counts[1]."\n";
        print "4 < Val <= 8     |       ".$range_counts[2]."\n";
        print "8 < Val <= 16    |       ".$range_counts[3]."\n";
        print "16 < Val <= 32   |       ".$range_counts[4]."\n";
        print "32 < Val <= 64   |       ".$range_counts[5]."\n";
        print "64 < Val <= 128  |       ".$range_counts[6]."\n";
        print "128 < Val <= 256 |       ".$range_counts[7]."\n";
        print "256 < Val <= 512 |       ".$range_counts[8]."\n";
        print "512 < Val        |       ".$range_counts[9]."\n";
    }
    close($read_file);
    close($write_file);
}

calculate_fold_diff("ALL_AML_gr.thr.train.csv","genes_fold_differences.txt",1);
