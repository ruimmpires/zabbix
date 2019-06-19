#!/usr/bin/env python3
# use this script to transform all the items in a Zabbix template to a csv file
# usage: ./script input output
import pandas as pd
import itertools
from bs4 import BeautifulSoup as b
import xml.etree.ElementTree as ET
import csv
import sys

#xmlfile='MADBCA_template_v8.xml'
#csvfile='MADBCA_template_v8.csv'

xmlfile=sys.argv[1]
csvfile=sys.argv[2]

tree = ET.parse(xmlfile)
root = tree.getroot()


def cleancsv():
    open(csvfile, 'w').close()

def createcsv(path):
 with open(csvfile, "a") as fp:
    wr = csv.writer(fp, dialect='excel')
    wr.writerow(["name,type,multiplier,snmp_oid,key,delay,status,value_type,delta,formula,data_type,description"])
    for item in root.findall(path):
        name = item.find('name')
        type = item.find('type')
        multiplier = item.find('multiplier')
        snmp_oid = item.find('snmp_oid')
        key = item.find('key')
        delay = item.find('delay')
        status = item.find('status')
        value_type = item.find('value_type')
        delta = item.find('delta')
        formula = item.find('formula')
        data_type = item.find('data_type')
        description = item.find('description')
        wr.writerow([name.text,type.text,multiplier.text,snmp_oid.text,key.text,delay.text,status.text,value_type.text,delta.text,formula.text,data_type.text,description.text])

cleancsv()
createcsv('./templates/template/items/item')
createcsv('./templates/template/discovery_rules/discovery_rule/item_prototypes/item_prototype')

