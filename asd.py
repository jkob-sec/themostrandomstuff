import json
import csv
import difflib

# Load data from the first JSON file
with open('tenable.json', 'r') as file:
    tenable_data = json.load(file)

# Load data from the second JSON file
with open('invicti.json', 'r') as file:
    invicti_data = json.load(file)

# Extract the specified fields from the first JSON file
tenable_fields = ['name', 'description', 'plugin_id', 'risk_factor', 'cvss3_vector']
tenable_extracted_data = [{field: item[field] for field in tenable_fields} for item in tenable_data]

# Extract the specified fields from the second JSON file
invicti_fields = ['Description', 'Summary', 'TypeId', 'Severity', 'CvssVectorString']
invicti_extracted_data = [{field: item[field] for field in invicti_fields} for item in invicti_data]

# Calculate similarity based on the 'name' and 'Description' fields
similarities = []
for tenable_item in tenable_extracted_data:
    tenable_name = tenable_item['name'].lower()
    max_similarity = 0
    most_similar_item = None

    for invicti_item in invicti_extracted_data:
        invicti_description = invicti_item['Description'].lower()
        similarity = difflib.SequenceMatcher(None, tenable_name, invicti_description).ratio()

        if similarity > max_similarity:
            max_similarity = similarity
            most_similar_item = invicti_item

    similarities.append((tenable_item, most_similar_item, max_similarity))

# Sort the similarities in descending order based on similarity
similarities.sort(key=lambda x: x[2], reverse=True)

# Save the extracted data and similarities to a CSV file
with open('output.csv', 'w', newline='') as file:
    fieldnames = tenable_fields + invicti_fields + ['similarity']
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()

    for tenable_item, invicti_item, similarity in similarities:
        row = {**tenable_item, **invicti_item, 'similarity': similarity}
        writer.writerow(row)
