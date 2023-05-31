import json
import csv
import difflib

# Load data from the first JSON file
with open('tenable.json', 'r') as file:
    tenable_data = json.load(file)

# Load data from the second JSON file
with open('invicti.json', 'r') as file:
    invicti_data = json.load(file)

# Extract the relevant fields for comparison
tenable_fields = ['name', 'description', 'plugin_id', 'risk_factor', 'cvss3_vector']
invicti_fields = ['Description', 'Summary', 'TypeId', 'Severity', 'CvssVectorString']

# Create dictionaries for quick access to data
tenable_dict = {item['name'].lower(): item for item in tenable_data}
invicti_dict = {item['Description'].lower(): item for item in invicti_data}

# Find the most similar data based on the fields
similarities = []
for tenable_name in tenable_dict:
    matches = difflib.get_close_matches(tenable_name, invicti_dict.keys(), n=1)
    if matches:
        invicti_description = matches[0]
        similarity = difflib.SequenceMatcher(None, tenable_name, invicti_description).ratio()
        similarities.append((tenable_dict[tenable_name], invicti_dict[invicti_description], similarity))

# Sort the similarities in descending order
similarities.sort(key=lambda x: x[2], reverse=True)

# Save the output in CSV format
with open('output.csv', 'w', newline='') as file:
    fieldnames = tenable_fields + invicti_fields + ['similarity']
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()

    for tenable_item, invicti_item, similarity in similarities:
        row = {**tenable_item, **invicti_item, 'similarity': similarity}
        writer.writerow(row)
