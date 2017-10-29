perl compute_gene_statistics.pl;
(head -n 1 S2N_AML_out.txt && tail -n +2 S2N_AML_out.txt | sort -t , -k 2 -n -r) > S2N_AML_sorted.txt;
mv S2N_AML_sorted.txt S2N_AML_out.txt;
(head -n 1 S2N_ALL_out.txt && tail -n +2 S2N_ALL_out.txt | sort -t , -k 2 -n -r) > S2N_ALL_sorted.txt;
mv S2N_ALL_sorted.txt S2N_ALL_out.txt;
(head -n 1 T_value_ALL_out.txt && tail -n +2 T_value_ALL_out.txt | sort -t , -k 2 -n -r) > T_value_ALL_sorted.txt;
mv T_value_ALL_sorted.txt T_value_ALL_out.txt;
(head -n 1 T_value_AML_out.txt && tail -n +2 T_value_AML_out.txt | sort -t , -k 2 -n -r) > T_value_AML_sorted.txt;
mv T_value_AML_sorted.txt T_value_AML_out.txt;
