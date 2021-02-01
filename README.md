# liftOverBEDPE
A bash script for converting bedpe files between different genomes builds using NCBI's liftOver tool.

Pre-requisites:

1) liftOver from NCBI has been installed and added to the PATH variable;
2) The liftOver chain file exists (chain files can be downloaded from: https://hgdownload.soe.ucsc.edu/downloads.html)

Usage:

You only need to provide two arguments to the liftOverBEDPE.sh script:

1) input=input.bedpe
2) chain=chain (eg: hg19ToHg38.over.chain)

To evoke liftOverBEDPE.sh, either execute `chmod +x liftOverBEDPE.sh` first, or type `bash liftOverBEDPE.sh input=[input].bedpe chain=[chain]` for each liftOver job.

