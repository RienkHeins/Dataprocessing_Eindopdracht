rule build_database:
    input:
        REFDB + config["refgenome"]
    threads:
        config["threads"]
    message:
        "Building bowtie2 reference database for mapping"
    log:
        "logs/mapping/create_database.log"
    params:
        ref= REFDB + "reference"
    shell:
        "bowtie2-build -f {input} {params.ref} > {log} 2>&1"

rule mapping:
    input:
        trimmed_files="trimmed/trimmed_{sample}.fastq.gz",
        database_check="logs/mapping/create_database.log"
    output:
        "mapped/{sample}.sam"
    threads:
        config["threads"]
    message:
        "bowtie2 has started read mapping"
    log:
        "logs/mapping/{sample}_mapping.log"
    params:
        mode = config["bowtiemode"],
        database = REFDB + "reference"
    shell:
        "bowtie2 -q -U {input.trimmed_files} -x {params.database} -S {output} {params.mode} > {log} 2>&1"