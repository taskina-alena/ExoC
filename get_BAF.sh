sample=$1
java -jar ~/picard.jar AddOrReplaceReadGroups -I bam/$sample.bam.sorted -O bam/$sample.tagged.bam -RGID 4 -RGLB lib1 -RGPL ILLUMINA -RGPU unit1 -RGSM 41
#this command add group to bam file and allows to launch CollectAllelicCounts (names of group are arbitary)
N=4; 
#number of parallel threads, each thread takes ~3 cores
#was stolen from https://gist.github.com/mike-seger/cb3e05dc41f250e713ad941543a676a1
(
#for contig in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY; do
for contig in chr22; do
        ((i=i%N)); ((i++==0)) && wait 
        gatk --java-options '-Xmx16g' CollectAllelicCounts -L $contig -I bam/$sample.tagged.bam -R hg19_canonic/hg19.fa -O $sample.$contig.tsv --verbosity ERROR &
        #the main command, output is tsv file with headers and 6 columns: CONTIG, POSITION,	REF_COUNT,	ALT_COUNT, REF_NUCLEOTIDE,	ALT_NUCLEOTIDE
        awk '{OFS="\t"; if ($3+$4>0) print $1,$2,$2+1,$4/($3+$4)}' $sample.$contig.tsv > $sample.$contig.bedGraph
        #output is bedGraph with 4 columns: contig, pos, pos+1, B-allelic frequency (ratio of ALT_COUNT to REF_COUNT+ALT_COUNT)
        #only positions with non-zero coverage are written ($3+$4>0)
done
)

