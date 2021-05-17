#!/usr/bin/env python3
import subprocess
import json;
import csv;


def print_apps(output_json):
    apps_json = output_json['resources']
    spaces_json = output_json['included']['spaces']
    orgs_json = output_json['included']['organizations']
    org_index = {}
    space_index = {}

    for  org in orgs_json:
        org_index[org['guid']]={
            'guid' : org['guid'],
            'name' : org['name']
        }

    for  space in spaces_json:
        guid = space['guid']
        org_guid =space['relationships']['organization']['data']['guid'];
        org = org_index[org_guid]['name'];
        space_index[guid]={
            'guid' : guid,
            'name' : space['name'],
            'org_guid': org_guid,
            'org' : org
        }

    for app_json in apps_json:
        space_guid = app_json['relationships']['space']['data']['guid']
        app = ",".join([
            app_json['guid'],
            app_json['name'],
            space_index[space_guid]['name'],
            space_index[space_guid]['guid'],
            space_index[space_guid]['org'],
            space_index[space_guid]['org_guid']
        ])
        print(app)




total_pages = 1
page = 1
page_size = 100

while(page <= total_pages):
    cmd = f"cf curl '/v3/apps?include=space,space.organization&per_page={page_size}&page={page}'"    
    output_json = json.loads(subprocess.check_output(cmd, shell=True))
    total_pages = output_json['pagination']['total_pages']    
    print_apps(output_json)
    page += 1 
    



