# reper - Genome-wide identification, classification and quantification of repetitive elements without an assembled genome


[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/nterhoeven/reper/)
[![Docker Build Status](https://img.shields.io/docker/build/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/nterhoeven/reper/)
[![DOI](https://zenodo.org/badge/80427752.svg)](https://zenodo.org/badge/latestdoi/80427752)
[![status](http://joss.theoj.org/papers/f0d16a43d8b031695f151ea25e0d47b0/status.svg)](http://joss.theoj.org/papers/f0d16a43d8b031695f151ea25e0d47b0)

## What is reper?
reper is a pipeline to detect repetitive sequences in genome sequencing data.
The detection is based on kmer frequencies and does not rely on a genome assembly.
This allows an analysis of repeat sequences of organisms with large and repeat rich
genomes (especially plants). For a detailed explanation of the pipeline, see the [reper wiki](https://github.com/nterhoeven/reper/wiki/How-does-reper-work%3F).


## How do I get reper?
reper is available as Docker container, Singularity image or can be installed manually.
Please visit the [reper wiki installation page](https://github.com/nterhoeven/reper/wiki/Installation) for detailed explanations.

## How do I run reper?
Running reper is very easy. You just need to adjust the config file and start reper with `reper kmerCount`.
A detailed explanation of the available commands is given in the [usage page of the reper wiki](https://github.com/nterhoeven/reper/wiki/Using-reper).
Or you can take a look at the [Tutorial](https://github.com/nterhoeven/reper/wiki/Tutorial) and learn how to analyze the
repeat content of the sugar beet using reper.


## How can I contribute?
Contribution to reper is always appreciated. Please submit any bugs, feature requests and similar via the github issue tracker.
If you want to contribute code, feel free to fork this repository and/or open a pull request.

## License and Citation
reper is placed under the MIT License. 

