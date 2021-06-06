sample=$1
java -jar ~/picard.jar AddOrReplaceReadGroups -I bam/$sample.bam.sorted -O bam/$sample.tagged.bam -RGID 4 -RGLB lib1 -RGPL ILLUMINA -RGPU unit1 -RGSM 41
#this command add group to bam file and allows to launch CollectAllelicCounts (names of group are arbitary)
N=1
#number of parallel threads, each thread takes ~3 cores

for contig in $2-$($#); do
        ((i=i%N)); ((i++==0)) && wait 
        echo $i
        gatk --java-options '-Xmx16g' CollectAllelicCounts -L $contig -I bam/$sample.tagged.bam -R hg19_canonic/hg19.fa -O $sample.$contig.tsv --verbosity ERROR&
        #the main command, output is tsv file with headers and 6 columns: CONTIG, POSITION,	REF_COUNT,	ALT_COUNT, REF_NUCLEOTIDE,	ALT_NUCLEOTIDE
done

wait
for contig in chr4; do
	awk '{OFS="\t"; if (($3+$4>0)&&($3!=1)&&($4!=1)) print $1,$2-1,$2,$4/($3+$4)}' $sample.$contig.tsv > $sample.$contig.bedGraph
        #output is bedGraph with 4 columns: contig, pos, pos+1, B-allelic frequency (ratio of ALT_COUNT to REF_COUNT+ALT_COUNT)
        #only positions with non-zero coverage are written, each pos has 0 or >1 coverage
done
