"""
Snakemake rule for data trimming with trimmomatic
"""

DATADIR = config["datadir"]

rule data_trimming:
    input:
        files=DATADIR + "{sample}.fastq.gz",
        annotation = config["trimmomatic"]["adapter"]
    output:
        "Trimmed/trimmed_{sample}.fastq.gz"
    threads: config["threads"]
    params:
        jar=config["trimmomatic"]["jar"],
        phred=config["trimmomatic"]["phred"],
        minlen=config["trimmomatic"]["minlen"],
        maxmismatch=config["trimmomatic"]["maxmismatch"],
        pairend=config["trimmomatic"]["pairend"],
        minscore=config["trimmomatic"]["minscore"],
        slidwindow=config["trimmomatic"]["slidwindow"],
        minqual=config["trimmomatic"]["minqual"]
    message: "Removing low quality reads and adapter sequence with trimmomatic"
    log:
        "logs/trimmomatic/{sample}_trimmed.log"
    shell:
        "java -jar {params.jar} \
        SE {params.phred} {input.files} {output} \
        ILLUMINACLIP:{input.annotation}:{params.maxmismatch}:{params.pairend}:{params.minscore} \
        SLIDINGWINDOW:{params.slidwindow}:{params.minqual} \
        MINLEN:{params.minlen} -threads {threads} 2> {log}"
