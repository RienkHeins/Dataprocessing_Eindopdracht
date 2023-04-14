rule parse_genome_annotation:
    input:
        REFDB + config["refgff3"]
    output:
        REFDB + config["newgff3"]
    threads:
        config["threads"]
    message:
        "Parsing genome annotation file to be used for differing expression"
    log:
        "logs/expression/" + config["newgff3"] + "_.log"
    script:
        "../scripts/ParseGenomeAnnotation.py"

rule differential_expression:
    input:
        gff=REFDB + config["newgff3"],
        bed="decompiling/{sample}.bed"
    output:
        "results/{sample}.cov"
    threads:
        config["threads"]
    message:
        "Using gff file for differential expression on BED files"
    log:
        "logs/expression/{sample}.log"
    shell:
        "bedtools coverage -a {input.gff} -b {input.bed} -s > {output} > {log} 2>&1"

rule create_DESeq_data:
    input:
        expand("results/{sample}.cov",sample=SAMPLES)
    output:
        "results/DESeq_Input.txt"
    threads:
        config["threads"]
    message:
        "Creating DESeq dataset with differential expression data"
    log:
        "logs/differential_expression/DESeq_Input.log"
    script:
        "../scripts/FormatDESeqInput.py"