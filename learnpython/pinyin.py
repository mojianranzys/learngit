#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import argparse
import csv
import pandas as pd
from xpinyin import Pinyin
pin = Pinyin()

#data_dir = "/haplox/users/zhaoys/Script/pinyin_test/"
sheet = '/haplox/runPipelineInfo/190407_A00250_0120_BHJWVLDSXX/sequence_190407_A00250_0120_BHJWVLDSXX.csv'
csv_df = open(sheet,"rt")
with open(csv_df) as f:
    for line in f.readlines():
        print(line)
            