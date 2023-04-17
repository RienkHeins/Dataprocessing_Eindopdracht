rule decompile_bam:
    input:
        "mapped/{sample}.sam"
    output:
        "decompiling/{sample}.bam"
    log:
        "logs/decompiling/{sample}_decompiling_bam.log"
    threads:
        config["threads"]
    message:
        "Started decompiling mapping data, converting SAM files to BAM"
    shell:
        "samtools view -bS {input} > {output} 2> {log}"

rule sort:
    input:
        "decompiling/{sample}.bam"
    output:
        "decompiling/{sample}_sorted.bam"
    log:
        "logs/decompiling/{sample}_sorting.log"
    threads:
        config["threads"]
    message:
        "Sorting bam files with samtools"
    shell:
        "samtools sort -o {output} {input} 2> {log}"

rule bedtools:
    input:
        "decompiling/{sample}_sorted.bam"
    output:
        "decompiling/{sample}.bed"
    message:
        "Converting BAM files to BED files with BEDTools"
    log: "logs/bedtools/{sample}.log"
    threads:
        config["threads"]
    shell:
        "bedtools bamtobed -i {input} > {output} 2> {log}"