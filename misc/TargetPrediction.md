# miRNA Target Prediction

## UTR regions
Old vectorbase version

We decided to use the 3'UTR from vectorbase based on the older reference genome and annotations (Johannesburg) because the newest reference genome on NCBI does not have annotated 3'UTR 
```
wget https://vectorbase.org/common/downloads/Current_Release/CquinquefasciatusJohannesburg/fasta/data/VectorBase-55_CquinquefasciatusJohannesburg_Genome.fasta

wget https://vectorbase.org/common/downloads/Current_Release/CquinquefasciatusJohannesburg/gff/data/VectorBase-55_CquinquefasciatusJohannesburg.gff
```

## Parse out the UTR regions from gff file and get fasta specific to those UTR
Put all the annotated 3'UTR into a UTR-specific gff
```
grep "three_prime_UTR" VectorBase-55_CquinquefasciatusJohannesburg.gff > three_prime_UTR.gff
```

Convert the gff file into a bed file. I already have bedops downloaded from a previous project (https://bedops.readthedocs.io/en/latest/content/reference/file-management/conversion/gff2bed.html)

In order to run this you must set the path to find it (I did this from $HOME) `export PATH=$PATH:$PWD/bin/bedops/bin`

```
/home/sm3679/bin/bedops/bin/gff2bed < /home/sm3679/culex_smallRNA/culexJ_genome/three_prime_UTR.gff > /home/sm3679/culex_smallRNA/culexJ_genome/three_prime_UTR.bed
```

Run bedtools_getfasta with the new bed file and complete fasta


# RNAhybrid
I used RNAcalibrate to come up with CERTAIN values for each of the miRNA. I then put those in as a flag within the RNAhybrid script for each miRNA run with parameters (binding required in miRNA positions 2–7, p-value < 0.1, maximum target sequence length 100000, energy cutoff −20).

I now have output files for each miRNA. I think I'm going to get gene lists from each output and then combine and work with them in R.

So I think I'm going to pull out all the relevant information for each of the RNAhybrid lists. This creats a four column table with the utr_gene, miRNA, mfe, and p-value.

```
tr ':' '\t' < RNAhybrid_output_Cpp-miR-92a_supercont3.722.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-92a_supercont3.722.txt

tr ':' '\t' < RNAhybrid_output_Cpp-miR-1891_supercont3.829.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-1891_supercont3.829.txt
tr ':' '\t' < RNAhybrid_output_Cpp-miR-283_supercont3.57.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-283_supercont3.57.txt
tr ':' '\t' < RNAhybrid_output_Cpp-miR-2941-3p-1_supercont3.5.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-2941-3p-1_supercont3.5.txt
tr ':' '\t' < RNAhybrid_output_Cpp-miR-2952-3p_supercont3.5.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-2952-3p_supercont3.5.txt
tr ':' '\t' < RNAhybrid_output_Cpp-novel-miR1_supercont3.64.txt | awk '{ print $1, $5, $7, $8}' > Cpp-novel-miR1_supercont3.64.txt
tr ':' '\t' < RNAhybrid_output_Cpp-miR-92a_supercont3.722.txt | awk '{ print $1, $5, $7, $8}' > Cpp-miR-92a_supercont3.722.txt
tr ':' '\t' < RNAhybrid_output_Cpp-novel-miR4_supercont3.153.txt | awk '{ print $1, $5, $7, $8}' > Cpp-novel-miR4_supercont3.153.txt
tr ':' '\t' < RNAhybrid_output_cqu-miR-8-5p_MIMAT0014408.txt | awk '{ print $1, $5, $7, $8}' > cqu-miR-8-5p_MIMAT0014408.txt

cat Cpp-miR-1891_supercont3.829.txt Cpp-miR-283_supercont3.57.txt Cpp-miR-2941-3p-1_supercont3.5.txt Cpp-miR-2952-3p_supercont3.5.txt Cpp-miR-92a_supercont3.722.txt Cpp-novel-miR1_supercont3.64.txt Cpp-novel-miR4_supercont3.153.txt cqu-miR-8-5p_MIMAT0014408.txt >> RNAhybrid_compactResults.txt
```


# miRanda

I could not access the site to download the miranda software. I guess the authors have taken it down/stopped maintaining the servers. However, I was fortunate in that we have miRanda downloaded from a previous student in the lab.

I ran miRanda with default settings except that I specified an energy threshold of -10 (I will subset the result to a better/lower threshold of -20 which was we also used for RNAhybrid but I figured more data was better than less when first generating the results.)

The parameters for the run are:
- Gap Open Penalty:	-9.000000
- Gap Extend Penalty:	-4.000000
- Score Threshold:	140.000000
- Energy Threshold:	-10.000000 kcal/mol
- Scaling Parameter:	4.000000

The output for the run (which was done for each miRNA individually) is a long txt file with lots of excess text that make it hard to read. I plan to generate tables by pulling the summary result lines from the files (conveniently, those lines start with ">>")

```
grep ">>" cqu-miR-8-5p_MIMAT0014408.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_cqu-miR-8-5p_MIMAT0014408.txt

grep ">>" Cpp-miR-1891_supercont3.829.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-miR-1891_supercont3.829.txt
grep ">>" Cpp-miR-283_supercont3.57.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-miR-283_supercont3.57.txt
grep ">>" Cpp-miR-2941-3p-1_supercont3.5.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-miR-2941-3p-1_supercont3.5.txt
grep ">>" Cpp-miR-2952-3p_supercont3.5.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-miR-2952-3p_supercont3.5.txt
grep ">>" Cpp-miR-92a_supercont3.722.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-miR-92a_supercont3.722.txt
grep ">>" Cpp-novel-miR1_supercont3.64.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-novel-miR1_supercont3.64.txt
grep ">>" Cpp-novel-miR4_supercont3.153.txt | awk '$4<-20' | tr ':' '\t' | sed 's/>>//g' | awk '{ print $2, $1, $6}' > compact_Cpp-novel-miR4_supercont3.153.txt
```
Print all the summary result lines (they start with ">>") `grep ">>" file`
Get rows with energy value less than -20 `awk '$4<-20'` Web [link](https://unix.stackexchange.com/questions/356080/get-all-rows-having-a-column-value-greater-than-a-threshold) for getting all the rows with a threshold value (i.e. how we'll select the energy value of -20)
Separate the position information from the utr gene name (the position numbers extraneous and unwieldy and so I'm separating them from the gene name info to cut out that as a clomn later) `tr ':' '\t'`
Get rid of the ">>" at the beginning of the line (in front of the miRNA) `sed 's/>>//g'`
Print the columns utr_gene, miRNA, and free energy `awk '{ print $2, $1, $6}'`

```
cat compact_Cpp-miR-1891_supercont3.829.txt compact_Cpp-miR-283_supercont3.57.txt compact_Cpp-miR-2941-3p-1_supercont3.5.txt compact_Cpp-miR-2952-3p_supercont3.5.txt compact_Cpp-miR-92a_supercont3.722.txt compact_Cpp-novel-miR1_supercont3.64.txt compact_Cpp-novel-miR4_supercont3.153.txt compact_cqu-miR-8-5p_MIMAT0014408.txt >> miranda_compactResults.txt
```

`wc -l miranda_compactResults.txt` 57 genes total are targets from miranda. But now we need to take a consensus with the RNAhybrid results


# Getting the consensus between RNAhybrid and miRanda
I have two full output files:
- RNAhybrid has four columns: utr_gene, miRNA, free_energy, and p-value
- miRanda has three columns: utr_gene, miRNA, and free energy

I need to take only the utr_gene and miRNA combos that match between the two full lists (full meaning all the individual results concatonated together)

```
awk 'FNR==NR{a[$1,$2];next} (($1,$2) in a)' miRanda_outputs/miranda_compactResults.txt RNAhybrid_outputs/RNAhybrid_compactResults.txt > combined_miranda_RNAhybrid.txt
```

There are only 32 common results between miranda (57 predicted target genes) and RNAhybrid (375 predicted target genes)
```
sed -e 's/utr_\(.*\)-R.*/\1/' combined_miranda_RNAhybrid.txt > combined_UTRgenes_miranda_RNAhybrid.txt
```
This sed command gets rid of the "utr_" before the CpipJ ID and everything after the "-R" in each line so we are left solely with the CpipJ ID on each line, no other info

Using this combined gene list, I should be able to re-run the GO and KEGG enrichment analyses


## GO enrichment
Once I have the targets, I did GO enrichment

I used the GO annotation file (.gaf) from vectorbase (https://vectorbase.org/vectorbase/app/downloads/Current_Release/CquinquefasciatusJohannesburg/gaf/) (gaf v 2.1) which has the genes and the GO annotations. I needed to put it in the right format for TopGO so I'm copying over the code I used to do that here.


#### Converting gaf to usable file for TopGO
This code coverts the vectorbase gaf file into a list of GO terms and the associated genes (one GO term per line and all genes as second column) as a specific format necessitated by TopGO

```
wget https://vectorbase.org/vectorbase/app/downloads/release-51/CquinquefasciatusJohannesburg/gaf/VectorBase-51_CquinquefasciatusJohannesburg_GO.gaf
```
So this did not actually get the gaf... I'm not sure how vectorbase stores stuff. Anyways, I ended up just selecting all the text on the webpage this link opens up (can't get a download file) with cmd+a and then putting it in atom text editor, then saving it (all 12.6M). I'm going to move this file up to the hpc for storage, and I'll move the manipulated file back to my machine
```
gcloud compute scp /Users/sarah/OneDrive/Documents/Mosquito/culex_biting/Culex_GO_Vectorbase.gaf bananas-controller:/home/sm3679/culex_biting/culex_genome/
```
Print only columns 2 and 4 since these are the locus-tags and the GO terms. Then pipe to another awk which will only print unique rows based on both columns.
```
awk '{print $2"\t"$4}' Culex_GO_Vectorbase.gaf | awk -F"\t" '!seen[$1, $2]++' | awk -F'\t' -v OFS=', ' '{x=$1;$1="";a[x]=a[x]$0}END{for(x in a)print x,a[x]}' | sed -e "s/, , /\t/g" > Culex_GO_annotations.txt
```
`awk '{print $2"\t"$4}'` print only columns 2 and 4 since these are the locus-tags and the GO terms \
`awk -F"\t" '!seen[$1, $2]++'` keep only unique rows that haven't been seen based on both columns \
`awk -F'\t' -v OFS=', ' '{x=$1;$1="";a[x]=a[x]$0}END{for(x in a)print x,a[x]}'` This awk looks through all the rows and finds all the rows with the same field 1, then it prints all the field 2 as a new field within one row with the matching field 1 \
`sed -e "s/, , /\t/g"` Since the last awk command had a coma and space as a separator, I replaced double instances of this with a tab (this is convenient since it occurs between what I want as column 1 [locus-tag] and column 2 [list of GO terms separated by comma and space])

I then bring down this file to my local machine
```
gcloud compute scp bananas-controller:/home/sm3679/culex_biting/culex_genome/Culex_GO_annotations.txt /Users/sarah/OneDrive/Documents/Mosquito/culex_biting/downstream_analysis/misc
```

I then ran TopGO which is an R script. There are no significantly enriched GO terms since none had at least 5 target predicted genes in the category.

## KEGG enrichment 
Some of the code I used to run things (such as append the Culex IDs) I put in a file called Misc_Code.R 

I decided to try to use KOBAS for KEGG enrichment. It needs Uniprot IDs. I got these by going to the Uniprot ID mapping (https://www.uniprot.org/uploadlists/) and gave it my Culex IDs to convert to Uniprot entries. I needed to make my Culex IDs recognizable to it by adding "VectorBase:" to the beginning of the ID (e.g. VectorBase:CPIJ000123) and then choosing the input as VEuPathDB. I converted the IDs to UniProtKB and then chose the "Entry" column (e.g. B0VZ26). Those "Entry"s I was able to upload to the KOBAS enrichment site (http://kobas.cbi.pku.edu.cn/genelist/) choosing Culex quinquefasciatus and UniProtKB AC.

KOBAS 3.0 citation: Dechao Bu, Haitao Luo, et al., KOBAS-i: intelligent prioritization and exploratory visualization of biological functions for gene enrichment analysis, Nucleic Acids Research, Volume 49, Issue W1, 2 July 2021, Pages W317–W325.

IMPORTANT: With the combined list of predicted targets, there are no enriched KEGG pathways.
