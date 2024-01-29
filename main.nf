#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { Fetch_obo } from "./modules/semsim"
include { Fetch_uniprot } from "./modules/semsim"
include { Generate_random_network } from "./modules/networks"
include { Unzip_goa } from "./modules/semsim"
include { GO_term_parser } from "./modules/semsim"

workflow {
    // Download the go terms for sem sim.
    Fetch_obo()
    Fetch_uniprot | Unzip_goa
    id_ch = Channel.value(params.species_ID)
    species_ch = Channel.value(params.species)
    GO_term_parser(id_ch.combine(species_ch).combine(Unzip_goa.out[0]))

    // Create the random networks
    ind_ch = Channel.from(0..999)
    network_ch = Channel.fromPath(params.network_path)
    Generate_random_network(ind_ch.combine(network_ch))


}
