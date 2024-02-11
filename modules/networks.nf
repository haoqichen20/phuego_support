#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process Generate_random_network {
    conda "/hps/software/users/petsalaki/users/hchen/miniconda3/envs/calci"

    publishDir "${params.semsimDir}", mode: "${params.publishMode}", pattern: "nodes.txt"
    publishDir "${params.randomNetDir}", mode: "${params.publishMode}", pattern: "${ind}.txt"

    input:
        tuple val(ind), path(network)
    output:
        path "nodes.txt", optional: true
        path "${ind}.txt"
    script:
        """
        generate_random_net.py "$ind" "$network"
        """
}

// All possible nodes combinations, N*N
process Nodes_combination {
    conda "/hps/software/users/petsalaki/users/hchen/miniconda3/envs/calci"

    publishDir "${params.nodeCombiDir}", mode: "${params.publishMode}"

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
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"
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