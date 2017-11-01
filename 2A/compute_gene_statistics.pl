###################
#compute_gene_statistics.pl
###################
#
#Perl script that computes gene statistics for ALL_AML_gr.thr.train.csv. 
#These statistics include average expression for ALL & AML, standard deviation for ALL & AML, 
#signal to noise ratio for ALL & AML, T-value for ALL & AML.
#
#This script requires the ALL_AML_gr.thr.train.csv file generated from step 1.F of the homework.
#
use strict;
use warnings;
#Function to compute the average expression
sub average{
    my($Sum_val,$N) = @_;
    return $Sum_val/$N;
}
#Function to compute the standard deviation
sub standard_deviation{
    my($N,$Sum_val,$Sum_sq) = @_;
    return sqrt(($N*$Sum_sq - $Sum_val*$Sum_val)/($N*($N-1)));
}
#Function to compute the signal to noise ratio
sub signal_to_noise{
    my($Avg1,$Avg2,$Stdev1,$Stdev2) = @_;
    return ($Avg1 - $Avg2)/($Stdev1 + $Stdev2);
}
#Function to compute the T-value
sub T_value{
    my($Avg1,$Avg2,$Stdev1,$Stdev2,$N1,$N2) = @_;
    return ($Avg1 - $Avg2) / sqrt($Stdev1 * $Stdev1/$N1 + $Stdev2 * $Stdev2/$N2);
}
#Function that prints a line to the file depending on the mode and what params are given
sub print_result{
    my($gene_name,$Avg1,$Avg2,$Stdev1,$Stdev2,$S2N_ALL,$T_value_ALL,$S2N_AML,$T_value_AML,$mode) = @_;
    my $result_string = "";
    #Print to the output file depending on what mode is used.
    if($mode eq "S2N_ALL"){$result_string = $gene_name.",".$S2N_ALL."\n";}
    elsif($mode eq "S2N_AML"){$result_string = $gene_name.",".$S2N_AML."\n";}
    elsif($mode eq "T_value_ALL"){$result_string = $gene_name.",".$T_value_ALL."\n";}
    elsif($mode eq "T_value_AML"){$result_string = $gene_name.",".$T_value_AML."\n";}
    else{$result_string = $gene_name.",".$Avg1.",".$Avg2.",".$Stdev1.",".$Stdev2.",".$S2N_ALL.",".$T_value_ALL.",".$S2N_AML.",".$T_value_AML."\n";}
    return $result_string;
}
#
#Function that calculates the gene stats and outputs to a file depending on the mode given.
#mode can be: S2N_ALL, S2N_AML, T_value_AML, T_value_ALL, or default.
#
#S2N_ALL prints only the S2N ratio for ALL along with the gene name.
#S2N_AML prints only the S2N ratio for AML along with the gene name.
#T_value_ALL prints only the T-value for ALL along with the gene name.
#T_value_AML prints only the T-value for AML along with the gene name.
#default prints all statistics including averages, standard deviations, s2n ratios, and t-values.
#
sub calculate_stats{
    my($input_filename, $output_filename, $mode) = @_;    
    open(my $read_file, "<", $input_filename);
    open(my $write_file, ">", $output_filename);
    my $skip_ID_row = 1;
    while(my $row = <$read_file>){
        if($skip_ID_row){
            $skip_ID_row = 0;
            #Print header depending on the mode.
            if($mode eq "S2N_ALL"){print $write_file "Gene_Name,S2N_ALL\n";}
            elsif($mode eq "S2N_AML"){print $write_file "Gene_Name,S2N_AML\n";}
            elsif($mode eq "T_value_ALL"){print $write_file "Gene_Name,T_value_ALL\n";}
            elsif($mode eq "T_value_AML"){print $write_file "Gene_Name,T_value_AML\n";}
            else{print $write_file "Gene_Name,Avg_ALL,Avg_AML,Stdev_ALL,Stdev_AML,S2N_ALL,T_val_ALL,S2N_AML,T_val_AML\n";}
        }
        else{
            my @row_array = (split(/,/,$row));
            my $gene_name = $row_array[0];
            my($N1, $Sum_val_1, $Sum_sq_1) = (27,0,0);
            for(my $i = 1; $i <= $N1; $i++){
                   $Sum_val_1 += $row_array[$i];
                   $Sum_sq_1 += ($row_array[$i] * $row_array[$i]);
            }
            #Calculate avg and stdev for ALL
            my $Avg1 = average($Sum_val_1,$N1);
            my $Stdev1 = standard_deviation($N1,$Sum_val_1,$Sum_sq_1);
            my($N2, $Sum_val_2, $Sum_sq_2) = (38,0,0);
            for(my $i = 28; $i <= $N2; $i++){
                $Sum_val_2 += $row_array[$i];
                $Sum_sq_2 += ($row_array[$i] * $row_array[$i]);
            }
            #Calculate avg and stdev for AML
            my $Avg2 = average($Sum_val_2,$N2);
            my $Stdev2 = standard_deviation($N2,$Sum_val_2,$Sum_sq_2);
            #Calculate S2N and T-Value for ALL
            my $S2N_ALL = signal_to_noise($Avg1,$Avg2,$Stdev1,$Stdev2);
            my $T_value_ALL = T_value($Avg1,$Avg2,$Stdev1,$Stdev2,$N1,$N2);
            #Calculate S2N and T-Value for AML
            my $S2N_AML = signal_to_noise($Avg2,$Avg1,$Stdev2,$Stdev1);
            my $T_value_AML = T_value($Avg2,$Avg1,$Stdev2,$Stdev1,$N2,$N1);
            my $result_string = print_result($gene_name,$Avg1,$Avg2,$Stdev1,$Stdev2,$S2N_ALL,$T_value_ALL,$S2N_AML,$T_value_AML,$mode); 
            print $write_file $result_string;
        }
    }
    close($read_file);
    close($write_file);
}

calculate_stats("ALL_AML_gr.thr.train.csv","stats.txt","default");
calculate_stats("ALL_AML_gr.thr.train.csv","S2N_ALL_out.txt","S2N_ALL");
calculate_stats("ALL_AML_gr.thr.train.csv","S2N_AML_out.txt","S2N_AML");
calculate_stats("ALL_AML_gr.thr.train.csv","T_value_ALL_out.txt","T_value_ALL");
calculate_stats("ALL_AML_gr.thr.train.csv","T_value_AML_out.txt","T_value_AML");

