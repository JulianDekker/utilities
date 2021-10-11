import sys
import pandas as pd
import os

if __name__ == "__main__":
    pd.set_option('display.max_rows', 1000)
    infile = ''
    seperator = ','
    for i, arg in enumerate(sys.argv):
        if '-help' in arg or '-h' in arg:
            print('''
                Usage: python check-matrix-dtype.py -in=<matrix file> -sep=''
            ''')
            exit
        if '-in' in arg:
            infile = arg.split('=')[1]
        if '-sep' in arg:
            seperator = arg.split('=')[1]
    if not infile:
        exit('no file input')
    
    matrix = pd.read_csv(os.path.join(os.getcwd(), infile), sep=seperator)
    print(matrix.dtypes)
