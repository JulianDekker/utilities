#!/bin/bash

echo $1 > $1.samples;
zcat $1 | head -n 20 | grep "#CHROM" | awk '{for (i=10; i<=NF; i++) print $i}' >> $1.samples;
