#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process Export_nodes {
    publishDir "${params.sanityCheckDir}", 
    mode: "${params.publishMode}"

    memory '2 GB'
    input:
        path(network)
    output:
        path "nodes.txt"
    script:
    """
    export_nodes.py "$network"
    """
}

process Generate_random_network {
    publishDir "${params.sanityCheckDir}/random_networks_wo_semsim/", 
    mode: "${params.publishMode}"

    memory '2 GB'
    input:
        tuple val(ind), path(network)
    output:
        path "${ind}.txt"
    script:
    """
    generate_random_net.py "$ind" "$network"
    """
}

// All possible nodes combinations, N*N
process Nodes_combination {
    publishDir "${params.sanityCheckDir}/nodes_combinations/", 
    mode: "${params.publishMode}"

    memory '8 GB'
    input:
        tuple val(i_node), path(all_nodes)
    output:
        path "$i_node"
    script:
    """
    nodes_combinations.py "$i_node" "$all_nodes"
    """
}

// All interacting node pairs in reference/randomized networks, subset of N*N
process Node_pairs {
    publishDir "${params.sanityCheckDir}", 
    mode: "${params.publishMode}"
    
    memory '96 GB'
    input:
        path(network)
        path(random_networks)
    output:
        path("edge_pairs.txt")
    script:
    """
    node_pairs.py "$network"
    """
}

process Generate_raw_network {
    publishDir "${params.supportDataDir}/networks",
    mode: "${params.publishMode}",
    pattern: "empirical.txt",
    map: {filename -> "${params.semsim_type}_raw.txt"}


    memory '32 GB'
    input:
        path(semsim_minimum)
        path(edge_pairs_sem_sim)
        path(network)
        path(random_networks)
    output:
        path("raw/*.txt")

    script:
    """
    generate_raw_net.py "$semsim_minimum" "$edge_pairs_sem_sim" "$network"
    """
}


process Laplacian_normalization {
    publishDir "${params.supportDataDir}/networks/${params.semsim_type}_random",
    mode: "${params.publishMode}"
    
    memory '8 GB'
    input:
        path(raw_network)
    output:
        path("./laplacian/*.txt")
    script:
    """
    normalization.py "$raw_network"
    """
}