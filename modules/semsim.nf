#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process Fetch_obo {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"

    output:
        path "go.obo"

    script:
    """
    wget -O "go.obo" https://purl.obolibrary.org/obo/go.obo
    """
}

process Fetch_uniprot {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"

    output:
        path "goa_uniprot_all.gaf.gz"

    script:
    """
    wget -O goa_uniprot_all.gaf.gz https://ftp.ebi.ac.uk/pub/databases/GO/goa/UNIPROT/goa_uniprot_all.gaf.gz
    """
}

process Unzip_goa {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"

    input:
        path gz_file
    output:
        path "${gz_file.baseName}"
    script:
    """
    decompress.py "$gz_file"
    """
}

// process Unzip_goa {
//     memory '8 GB'

//     publishDir "${params.semsimDir}", mode: "${params.publishMode}"

//     input:
//         path gz_file
//     output:
//         path "${gz_file.baseName}"
//     script:
//     """
//     gzip -d --force "$gz_file"
//     """
// }

process GO_term_parser {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"

    input:
        tuple val(species_ID), 
              val(species),
              path(gaf)

    output:
        tuple val(species_ID),
              val(species),
              path("gaf_${species}.gaf")

    script:
    """
    go_term_parser.py "$gaf" "$species_ID" "$species"
    """
}