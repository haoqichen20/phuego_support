#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { Fetch_obo } from "./modules/semsim"
include { Fetch_uniprot } from "./modules/semsim"
include { Generate_random_network } from "./modules/networks"

workflow {
    // Download the go terms for sem sim.
    Fetch_obo()
    Fetch_uniprot()

    // Create the random networks
    ind_ch = Channel.from(0..999)
    network_ch = Channel.fromPath(params.network_path)
    Generate_random_network(ind_ch.combine(network_ch))

    
}

// workflow FETCH_OBO{
//     main:
//         Fetch_obo()
// }
