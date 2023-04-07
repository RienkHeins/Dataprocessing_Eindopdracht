#!/usr/bin/env python3

import sys

sys.stderr = open(snakemake.log[0], 'w')


def Parse_input(infile):
    try:
        temp = open(infile, 'r')
        temp2 = temp.readline()
        while temp2[0] == '#':
            temp2 = temp.readline()
        temp3 = [temp2] + temp.readlines()
        temp.close()
        temp4 = []
        for i in temp3:
            temp4.append(i.split('\t'))
        accession = temp4[0][0]

    except FileNotFoundError:
        print('No such file or directory: ' + infile)
        sys.exit(2)
    return temp4, accession


def Sweep_and_output(input_list, accession, output_file):
    in_count = len(input_list)
    out_count = 0
    output = open(output_file, 'w')
    for i in input_list:
        try:
            if i[2] == 'CDS':
                start, end, strand = i[3], i[4], i[6]
                ID = Get_ID(i[8])
                output.write('\t'.join([accession, 'RefSeq', 'CDS', start, end, '.', strand, '.', ID]) + '\n')
                out_count += 1
        except IndexError:
            pass
    print('Read %s lines from GFF3' % in_count)
    print('%s CDSs remained' % out_count)
    output.close()
    return 0


def Get_ID(attribute):
    attributes = attribute.split(';')
    attributes_dic = {}
    for i in attributes:
        attributes_dic[i.split('=')[0]] = i.split('=')[1]
    return attributes_dic['locus_tag']


def main():
    input = snakemake.input[0]
    output = snakemake.output[0]
    input_list, accession = Parse_input(input)
    Sweep_and_output(input_list, accession, output)
    return 0


if __name__ == '__main__':
    sys.exit(main())