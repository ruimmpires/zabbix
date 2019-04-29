#README
# This script will transform to csv all json files in this folder, which starts with what you type.
# The input and output folders are the same in which you run the script
import pandas, os, json
from pandas.io.json import json_normalize #package for flattening json in pandas df
def pause():
    programPause = input("Press the <ENTER> key to continue...")

#inspiration
#    https://stackoverflow.com/questions/30539679/python-read-several-json-files-from-a-folder
#    https://stackoverflow.com/questions/16736080/change-the-file-extension-for-files-in-a-folder
#    https://medium.com/datadriveninvestor/python-reading-and-writing-data-from-files-d3b70441416e
#    https://stackoverflow.com/questions/11552320/correct-way-to-pause-python-program



#FINDS ALL JSON FILES RestQuery_Template*.json in the current folder and prints out the list of files (json_files)
#path_to_json = '/home/rpires/NOKIA/RS/Zabbix/'
path_to_json = os.getcwd() #current folder
filenamekey = input("This script will transform to csv all json files in this folder, which starts with: ")
print ("The output csv is prepared for nested json files looking for 'result' and  organized per 'hostid','itemid','key_','lastvalue','name','snmp_oid'")
print ("The output folder is the same as the current: ",path_to_json)
json_files = [pos_json for pos_json in os.listdir(path_to_json) if (pos_json.endswith('.json') and pos_json.startswith(filenamekey))]
print("List of JSON files:\n", json_files,"\n")
pause ()

# we need both the json and an index number so use enumerate()
for index, df in enumerate(json_files):
    print ("Processing file",os.path.join(path_to_json, df),"...")
    with open(os.path.join(path_to_json, df)) as json_file:
        json_text = json.load(json_file)
        #print("Top 5 rows before normalization\n", json_text.head(5))
        # NORMALIZATION OR FLATENNING THE JSON
        df_normalized = json_normalize(json_text['result'])
        print("Top 5 rows after normalization\n", df_normalized.head(5))
        # TRANSFORM JSON TO CSV
        newname = df.replace('.json', '_result.csv')
        #print ("newname: ",newname)
        print("Normalized CSV saved at: ", os.path.join(path_to_json, newname))
        df_normalized.to_csv(os.path.join(path_to_json, newname), index=False)

#json_data = pandas.df_normalized(columns=['hostid','itemid','key_','lastvalue','name','snmp_oid'])