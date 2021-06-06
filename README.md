# ExoC

Use get_BAF.sh to get B-allele frequency (alternative allele frequency) from .bam file

You need to have gatk and picard.jar file in the working directory to launch this script. 
Beside this .bam file should be sorted and named like 'sample.bam.sorted'

Usage:
bash get_BAF.sh N chr1 ... chrN,
where N is the number of cores to use,
chr1 ... chrN is the list of chromosomes, for which BAF would be counted

This scripts gets two files for each chromosome:
1. tsv file with headers and 6 columns: CONTIG, POSITION,	REF_COUNT, ALT_COUNT, REF_NUCLEOTIDE,	ALT_NUCLEOTIDE
2. bedGraph with 4 columns: contig, pos, pos+1, B-allelic frequency (ratio of ALT_COUNT to REF_COUNT+ALT_COUNT).

In regards to bedGraph file, positions are omitted in two cases:
1. Coverage is equal to zero
2. There's allele that is supported by only one read
Example: position with 3 reference allele counts would be written, position with 3 reference and 1 alternative counts would be omitted


   





