#!/bin/bash
docker run --rm -v $(pwd):/data configure-refseq
docker run --rm -v $(pwd):/data configure-REdat
