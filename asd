import csv
import difflib
from pytrie import SortedStringTrie

# Read the first CSV file
with open('file1.csv', 'r') as file1:
    reader1 = csv.DictReader(file1)
    data1 = list(reader1)

# Read the second CSV file
with open('file2.csv', 'r') as file2:
    reader2 = csv.DictReader(file2)
    data2 = list(reader2)

# Extract the description fields from each file
descriptions1 = [row['Description'].lower() for row in data1]
descriptions2 = [row['description'].lower() for row in data2]

# Build an indexing structure using Trie
trie = SortedStringTrie.fromkeys(descriptions2)

# Find the most similar descriptions using the Trie indexing structure
similarities = []
for desc1, row1 in zip(descriptions1, data1):
    matches = trie.get(desc1)
    if matches:
        desc2 = matches[0]
        similarity = difflib.SequenceMatcher(None, desc1, desc2).ratio()
        similarities.append((row1, similarity))

# Sort the similarities in descending order
similarities.sort(key=lambda x: x[1], reverse=True)

# Write the final result to a new CSV file
with open('output.csv', 'w', newline='') as output_file:
    fieldnames = ['Description', 'Summary', 'TypeId', 'Severity', 'CvssVectorString', 'Similarity',
                  'name', 'description', 'plugin_id', 'risk_factor', 'cvss3_vector']
    writer = csv.DictWriter(output_file, fieldnames=fieldnames)
    writer.writeheader()

    for row1, similarity in similarities:
        for row2 in data2:
            if row2['description'].lower() == trie.get(row1['Description'].lower())[0]:
                row = {**row1, **row2, 'Similarity': similarity}
                writer.writerow(row)
                break
