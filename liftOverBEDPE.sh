#!/bin/sh
#convert bedpe files to a different genome build

for arg in "$@"
do
index=$(echo $arg | cut -f1 -d=)
val=$(echo $arg | cut -f2 -d=)
case $index in
input) input=$val;;

chain) chain=$val;;

*)
esac
done

if [ -f $chain ]; then
   FROM=${chain%To*}
   FROM=${FROM##*/}
   TO=${chain##*To}
   TO=${TO%.over.chain}
   echo "This script converts the input file $input from genome $FROM to $TO"
else
   echo "Chain file does not exist."
   exit 1
fi

echo "===================================================="
  
if [ -x "$(command -v liftOver)" ]; then
   echo "1) Adding a unique ID to each row in the input file $input"
else
   echo "Error: liftOver does not exist or cannot be executed."
   exit 1
fi

`awk 'BEGIN {FS=OFS="\t"} {print $0,NR}' $input > input_NR.txt`

echo "Done!"
echo "===================================================="
echo "2) Split the input files into two BED files"

`awk 'BEGIN {FS=OFS="\t"} {print $1,$2,$3,$NF}' input_NR.txt > input_1st.txt`

`cut -f4- input_NR.txt > input_2nd.txt`
echo "Done!"

echo "===================================================="
echo "3) Converting from $FROM to $TO"

`liftOver -bedPlus=3 input_1st.txt $chain input_1st.bed tmp.txt`
`liftOver -bedPlus=3 input_2nd.txt $chain input_2nd.bed tmp.txt`

echo "===================================================="
echo "4) Merging back"

COL=$(awk -F'\t' 'NR == 1 {print NF}' input_2nd.bed)
`join -1 4 -2 $COL -t $'\t' input_1st.bed input_2nd.bed > tmp.bedpe`

STEM=${input%.bedpe}
`cut -f2- tmp.bedpe > "$STEM"_"$TO".bedpe`

echo "===================================================="
echo "Clearing up..."
rm input_NR.txt
rm input_1st.txt
rm input_2nd.txt
rm input_1st.bed
rm input_2nd.bed
rm tmp.txt
rm tmp.bedpe

echo "Done! The output file is "$STEM"_"$TO".bedpe"

