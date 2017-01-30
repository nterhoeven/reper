#!/bin/bash

source repeat_pipeline.cfg

"$classifier" -consensi "$CLUSTEROUT" -engine ncbi


echo "###################################"
echo "finished classification -running quantification"
./00_run_repeat_pipeline.sh quantify
echo "running filtering against chloroplast and mitochondrion"
./00_run_repeat_pipeline.sh filtering