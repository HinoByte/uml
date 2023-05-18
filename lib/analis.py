import os

# Определите путь к каталогу, который вы хотите просканировать
directory_path = os.getcwd()  # текущий рабочий каталог

# Определите путь к файлу, в который вы хотите записать всё содержимое
output_file_path = os.path.join(directory_path, 'full_code.dart')

# Создайте множество для хранения уникальных строк import
imports = set()

# Создайте список для хранения всех остальных строк
lines = []

# Используйте os.walk для обхода всех файлов в каталоге и подкаталогах
for root, dirs, files in os.walk(directory_path):
    for file_name in files:
        # Проверьте, что файл имеет расширение .dart
        if file_name.endswith('.dart'):
            file_path = os.path.join(root, file_name)
            # Откройте каждый файл и прочитайте его содержимое
            with open(file_path, 'r') as input_file:
                for line in input_file:
                    # Если строка начинается с "import 'package", добавьте ее в множество
                    if line.startswith("import 'package"):
                        imports.add(line)
                    else:
                        # В противном случае добавьте строку в список lines
                        lines.append(line)
                # Добавьте пару переносов строки для разделения файлов
                lines.append('\n\n')

# Откройте файл для записи
with open(output_file_path, 'w') as output_file:
    # Сначала запишите все уникальные import'ы
    for import_line in imports:
        output_file.write(import_line)

    # Затем запишите все остальные строки
    for line in lines:
        output_file.write(line)

print(f'All .dart files in {directory_path} have been concatenated into {output_file_path}')

