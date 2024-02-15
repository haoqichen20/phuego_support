#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { Fetch_obo } from "./modules/semsim"
include { Fetch_uniprot } from "./modules/semsim"
include { Generate_random_network } from "./modules/networks"
include { Unzip_goa } from "./modules/semsim"
include { GO_term_parser } from "./modules/semsim"
include { Nodes_combination } from "./modules/networks"
include { Generate_xml } from "./modules/semsim"
include { Allvsall_semsim } from "./modules/semsim"
include { GOterm_zscore } from "./modules/semsim"
include { Node_pairs } from "./modules/networks"
include { Edgepairs_xml } from "./modules/semsim"
include { Edgepairs_semsim } from "./modules/semsim"
include { Calculate_min } from "./modules/semsim"
include { Generate_raw_network } from "./modules/networks"
include { Laplacian_normalization } from "./modules/networks"

workflow {
    // Download the go terms for sem sim and decompress.
    Fetch_obo()
    Fetch_uniprot | Unzip_goa

    // Parsing go term for specified species & ID.
    id_ch = Channel.value(params.species_ID)
    species_ch = Channel.value(params.species)
    GO_term_parser(id_ch.combine(species_ch).combine(Unzip_goa.out[0]))

    // Create the random networks
    ind_ch = Channel.from(0..999)
    network_ch = Channel.fromPath(params.network_path)
    Generate_random_network(ind_ch.combine(network_ch))

    // All possible nodes combinations.
    all_nodes_ch = Generate_random_network.out[0]
    inodes_ch = all_nodes_ch.splitCsv(sep: '\t', strip: true)
    Nodes_combination(inodes_ch.combine(all_nodes_ch))

    // All versus all semantic similarity: 
    // create xml
    xml_template_ch = Channel.fromPath(params.xml_template_path)
    Generate_xml(inodes_ch.merge(Nodes_combination.out[0])
                          .combine(xml_template_ch))
    // submit to the java toolkit.
    Allvsall_semsim(Generate_xml.out[0].combine(GO_term_parser.out[0])
                                       .combine(Fetch_obo.out[0])
    // Calculate the z_score.
    GOterm_zscore(Allvsall_semsim.out[0])

    // All existing nodes combinations in the reference and randomized networks.
    // Merge the 1000 randomized network into a list.
    Node_pairs(network_ch, Generate_random_network.out[1].collect())

    // All existing node combinations semantic similarity:
    // create xml
    Edgepairs_xml(Node_pairs.out[0], xml_template_ch)
    // submit to the java toolkit.
    Edgepairs_semsim(Edgepairs_xml.out[0].combine(GO_term_parser.out[0])
                                         .combine(Fetch_obo.out[0])
    // Calculate the minimal semsim of all edge pairs.
    Calculate_min(Edgepairs_semsim.out[0])


    // Populate the raw semantic similarity to reference and randomized networks
    Generate_raw_network(Calculate_min.out[0], Edgepairs_semsim.out[0], network_ch, Generate_random_network.out[1].collect())
    // Laplacian normalization of sematic semilarity of the reference and randomized networks
    Laplacian_normalization(Generate_random_network.out[0])
}
