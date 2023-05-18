import os

# Определите путь к каталогу, который вы хотите просканировать
directory_path = os.getcwd()  # текущий рабочий каталог

# Определите путь к файлу, в который вы хотите записать всё содержимое
output_file_path = os.path.join(directory_path, 'full_code.dart')

# Откройте файл для записи
with open(output_file_path, 'w') as output_file:
    # Используйте os.walk для обхода всех файлов в каталоге и подкаталогах
    for root, dirs, files in os.walk(directory_path):
        for file_name in files:
            # Проверьте, что файл имеет расширение .dart
            if file_name.endswith('.dart'):
                file_path = os.path.join(root, file_name)
                # Откройте каждый файл и прочитайте его содержимое
                with open(file_path, 'r') as input_file:
                    file_content = input_file.read()
                    # Запишите содержимое файла в выходной файл
                    output_file.write(file_content + '\n\n')

print(f'All .dart files in {directory_path} have been concatenated into {output_file_path}')

