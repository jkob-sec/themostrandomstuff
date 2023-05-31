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
tenable_names = [item['name'].lower() for item in tenable_data]
invicti_descriptions = [item['Description'].lower() for item in invicti_data]

# Find the most similar data based on the fields
similarities = []
for name in tenable_names:
    matches = difflib.get_close_matches(name, invicti_descriptions, n=1)
    if matches:
        description = matches[0]
        similarity = difflib.SequenceMatcher(None, name, description).ratio()
        similarities.append((name, description, similarity))

# Sort the similarities in descending order
similarities.sort(key=lambda x: x[2], reverse=True)

# Save the output in CSV format
with open('output.csv', 'w', newline='') as file:
    fieldnames = ['name', 'description', 'similarity']
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()

    for name, description, similarity in similarities:
        writer.writerow({'name': name, 'description': description, 'similarity': similarity})
