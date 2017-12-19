# reper - find, classify and quantify repeats without a genome assembly


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
Or you can take a look at the [Tutorial](https://github.com/nterhoeven/reper/wiki/Tutorial) and lear how to analyze the
repeat content of the sugar beet using reper.


## How can I contribute?
Contribution to reper is always appreciated. Please submit any bugs, feature requests and similar via the github issue tracker.
If you want to contribute code, feel free to fork this repository and/or open a pull request.

## License and Citation
reper is placed under the MIT License. If you use reper in your research, please cite the
[publication in JOSS]()

