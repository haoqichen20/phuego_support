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

process Generate_xml {
    publishDir "${params.AvsAxmlDir}", mode: "${params.publishMode}", pattern: "*.xml"
    memory '1 GB'
    input:
        tuple val(i_node),
              path(i_node_combi),
              path(xml_template)
    output:
        tuple val(i_node),
              path(i_node_combi),
              path("${i_node}_all.xml")
    script:
    """
    generate_xml.py "$i_node" "$i_node_combi" "$xml_template"
    """
}

process Allvsall_semsim {
    publishDir "${params.AvsAsemsimDir}", mode: "${params.publishMode}"
    memory '12 GB'

    input:
        tuple val(i_node),
              path(i_node_combi),
              path(i_node_vs_all_xml),
              val(species_ID),
              val(species),
              path(gaf_species),
              path(go_obo)
    output:
        tuple val(i_node),
              path("${i_node}.txt")
              
    script:
    """
    java -jar -Xms12288m -Xmx32768m ./app/sml-toolkit-0.9.4c.jar -t sm -xmlconf "$i_node_vs_all_xml"
    """
}

process GOterm_zscore {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"

    input:
        tuple val(i_node),
              path(i_node_semsim)
    output:
        path("semsim.txt")
    script:
    """
    go_term_zscore.py
    """
}

process Edgepairs_xml {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}", pattern: "*.xml"

    input:
        path(edge_pairs)
        path(xml_template)
    output:
        tuple path(edge_pairs),
              path("sml_semsim_edge_pairs.xml")
    script:
    """
    generate_xml_edge_pairs.py "$edge_pairs" "$xml_template"
    """
}

process Edgepairs_semsim {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"
    memory '32 GB'

    input:
        tuple path(edge_pairs),
              path(edgepairs_xml),
              val(species_ID),
              val(species),
              path(gaf_species),
              path(go_obo)
    output:
              path("edge_pairs_sem_sim.txt")
              
    script:
    """
    java -jar -Xms12288m -Xmx32768m ./app/sml-toolkit-0.9.4c.jar -t sm -xmlconf "$edgepairs_xml"
    """
}

process Calculate_min {
    publishDir "${params.semsimDir}", mode: "${params.publishMode}"
    memory '1 GB'

    input:
        path(edge_pairs_sem_sim)
    output:
        path("minimum.txt")
    script:
    """
    calculate_min.py "$edge_pairs_sem_sim"
    """
}