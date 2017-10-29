#################
#remove_fold_ratio_1.pl
#################
#
#Perl script that removes all genes in ALL_AML_gr.thr.train.csv that have a fold ratio of 1.
#
#This script requires the files ALL_AML_gr.thr.train.csv and genes_fold_differences.txt.
#genes_fold_differences.txt is generated from my previous Perl script, fold_diff.pl
#
use strict;
use warnings;
sub remove_fold_ratio_1{
    my($input_filename, $genes_fold_difference_filename, $output_filename) = @_;
    open(my $read_file, "<", $input_filename);
    open(my $gene_file, "<", $genes_fold_difference_filename);
    open(my $write_file, ">", $output_filename);
    my $skip_ID_row = 1;
    while(my $row = <$read_file>){
        if($skip_ID_row){
            print $write_file $row;
            $skip_ID_row = 0;
            <$gene_file>;
        }
        #Write row to output file if corresponding row in gene file has a fold ratio not equal to 1.
        elsif((split(/,/,<$gene_file>))[1] != 1){print $write_file $row;}
    }
    close($read_file);
    close($gene_file);
    close($write_file);
}

remove_fold_ratio_1("ALL_AML_gr.thr.train.csv","genes_fold_differences.txt","removed1.csv");
