import os, shutil

path =  r'D:/Desktop/Python Practice/'

print(os.listdir(path))

print(os.path.exists(path))

folder_names = ['csv files', 'image files', 'text files']

for loop in range(0, len(folder_names)):
    if not os.path.exists(path + '/' + folder_names[loop]):
        os.mkdir(path + '/' + folder_names[loop])
        
file_name = os.listdir(path)

for file in file_name:
    if '.csv' in file and not os.path.exists(path + 'csv files/' + file):
        shutil.move(path + file, path + 'csv files/' + file)
        
for file in file_name:
    if '.txt' in file and not os.path.exists(path + 'text files/' + file):
        shutil.move(path + file, path + 'text files/' + file)
        
for file in file_name:
    if '.png' in file and not os.path.exists(path + 'image files/' + file):
        shutil.move(path + file, path + 'image files/' + file)