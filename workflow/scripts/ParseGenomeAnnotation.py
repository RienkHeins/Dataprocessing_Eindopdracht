#!/usr/bin/env python3

import sys

sys.stderr = open(snakemake.log[0], 'w')


def Parse_input(infile):
    """
    Takes the input gff3 file and saves the relevant information
    to turn the file to a readable CDS annotation.
    :param infile: Non-converted gff3 file
    :return: temp4: relevant information for new gff3 file.
    accession: header information original file.
    """
    try:
        temp = open(infile, 'r')
        temp2 = temp.readline()
        while temp2[0] == '#':
            temp2 = temp.readline()
        temp3 = [temp2] + temp.readlines()
        temp.close()
        temp4 = []
        for line in temp3:
            temp4.append(line.split('\t'))
        accession = temp4[0][0]

    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)
    return temp4, accession


def Sweep_and_output(input_list, accession, output_file):
    """
    Uses old gff3 information and CDS relevant information to create
    a readable CDS gff3 file.
    :param input_list: List of lines with old gff3 information
    :param accession: Header info original gff3 file
    :param output_file: Name of the output file
    """
    in_count = len(input_list)
    out_count = 0
    output = open(output_file, 'w')
    for line in input_list:
        try:
            if line[2] == 'CDS':
                start, end, strand = line[3], line[4], line[6]
                ID = Get_ID(line[8])
                output.write('\t'.join([accession, 'RefSeq', 'CDS', start, end, '.', strand, '.', ID]) + '\n')
                out_count += 1
        except IndexError:
            pass
    print('Read %s lines from GFF3' % in_count)
    print('%s CDSs remained' % out_count)
    output.close()
    return 0


def Get_ID(ID_info):
    """
    Gets the line ID from the inputted gff3 line
    :param ID_info: ID attribute
    :return: ID from extracted attribute
    """
    attributes = ID_info.split(';')
    attributes_dic = {}
    for attribute in attributes:
        attributes_dic[attribute.split('=')[0]] = attribute.split('=')[1]
    return attributes_dic['locus_tag']


def main(input, output):
    input_list, accession = Parse_input(input)
    Sweep_and_output(input_list, accession, output)
    return 0


if __name__ == '__main__':
    genome_annotation = snakemake.input[0]
    parsed_annotation = snakemake.output[0]
    sys.exit(main(genome_annotation, parsed_annotation))
