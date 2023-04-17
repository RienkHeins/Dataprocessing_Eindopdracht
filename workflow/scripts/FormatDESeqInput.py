# !/usr/bin/env python3

import sys

sys.stderr = open(snakemake.log[0], 'w')


def read_coverage(infile):
    """
    Gets coverage files and extracts gene coverage data for the DESeq
    data set
    :param infile: .cov coverage file
    :return: temp_dic: dictionary containing coverage statistics
    """
    try:
        temp_dic = {}
        with open(infile) as temp:
            for line in temp:
                coverage = line.split('\t')
                temp_dic[coverage[8]] = coverage[9]

    except FileNotFoundError:
        print ('No such file or directory:  ' +infile)
        sys.exit(2)

    return temp_dic


def write_coverage(outfile, coverages, order):
    """
    Gets coverage statistics and writes them to a DESeq2 dataset file.
    :param outfile: DESeq2 input dataset txt file
    :param coverages: Dictionary containing coverage statistics
    :param order: Order of input files
    """
    CDSs = list(coverages[order[0]].keys())
    CDSs.sort()
    try:
        with open(outfile, 'w') as temp:
            temp.write('\t'.join(['GI', ] + [sample.split('/')[-1][:-4] for sample in order]))
            temp.write('\n')
            for CDS in CDSs:
                temp.write(CDS)
                for sample in order:
                    temp.write('\t' + coverages[sample][CDS])
                temp.write('\n')

    except FileNotFoundError:
        print('No such file or directory: ' + outfile)
        sys.exit(2)

    return 0


def main(input, output):
    coverages = {}
    for sample in input:
        coverages[sample] = read_coverage(sample)
    write_coverage(output, coverages, input)

    return 0


if __name__ == '__main__':
    samples = snakemake.input
    DESeq_set = snakemake.output[0]
    sys.exit(main(samples, DESeq_set))
