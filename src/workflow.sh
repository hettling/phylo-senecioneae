#!bin/bash

# copy species from 'data folder'
cp ../data/*.phy .

# insert sequences into database
smrt-utils dbinsert -a ETScorrigido.phy -p FERN -g -d "Fernanda, ETS data" -f phylip
smrt-utils dbinsert -a ITSscorrigido.phy -p FERN -g -d "Fernanda, ITS data" -f phylip
smrt-utils dbinsert -a PSBAcorrigido.phy -p FERN -g -d "Fernanda, PSBA data" -f phylip
smrt-utils dbinsert -a trnlFcorrigido.phy  -p FERN -g -d "Fernanda, trnlF data" -f phylip

# now, files with names ETScorrigido-smrt-inserted.fa have been created.
# We still have to prepend the seed gi to the file name in order for
# 'smrt orthologize to work' 
for i in $(ls *smrt-inserted*); do a=`head -1 $i | cut -d '|' -f 2`; mv $i "$a-$i"; done

# run supersmart pipeline steps for data retrieval
smrt taxize -r Senecioneae -b
smrt align

# append inserted alignments to alignmen list
ls *smrt-inserted*.fa >> aligned.txt

# orthologize and make supermatrix for all taxa
smrt orthologize
smrt bbmerge -e -1

# tree inference
smrt bbinfer -b 100 -i examl
