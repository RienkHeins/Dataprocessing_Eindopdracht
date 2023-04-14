rule install_packages:
    input:
        "results/DESeq_Input.txt"
    message:
        "Installing required R packages"
    threads:
        config["threads"]
    log:
        "logs/visualizing/install_packages.log"
    shell:
        "Rscript workflow/scripts/InstallPackages.R > {log}"

rule create_images:
    input:
        install_check = "logs/visualizing/install_packages.log",
        design = DATADIR + "Design_sheet.txt",
        data = "results/DESeq_Input.txt"
    output:
        "results/images/PCA.pdf",
        "results/images/Dendrogram_and_heatmap.pdf"
    threads:
        config["threads"]
    message:
        "Creating PCA, dendrogram and heatmap from DESeq dataset"
    log:
        "logs/visualizing/images.log"
    params:
        "results/images/"
    shell:
        "Rscript workflow/scripts/RunDESeq.R {input.data} {input.design} {params} {log}"
