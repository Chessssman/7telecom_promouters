# Шаг 1: Выберите базовый образ. Мы берем официальный образ Python 3.12 (slim-версия меньше по размеру)
FROM python:3.12-slim

# Шаг 2: Установите системные зависимости, необходимые для установки Rust
# 'curl' - для скачивания, 'build-essential' - для компиляции
RUN apt-get update && apt-get install -y curl build-essential && rm -rf /var/lib/apt/lists/*

# Шаг 3: Установите Rust toolchain (cargo, rustc, rustup)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Шаг 4: Добавьте директорию с бинарниками Rust в переменную PATH
# Это нужно, чтобы pip мог найти 'cargo' и 'rustc' при установке
ENV PATH="/root/.cargo/bin:${PATH}"

# Шаг 5: Создайте рабочую директорию внутри контейнера
WORKDIR /app

# Шаг 6: Скопируйте файл с зависимостями в контейнер
COPY requirements.txt .

# Шаг 7: Установите Python-зависимости. 
# Pip теперь сможет скомпилировать pydantic-core, используя Rust
RUN pip install --no-cache-dir -r requirements.txt

# Шаг 8: Скопируйте весь остальной код вашего проекта (bot.py, promoters_report.xlsx и т.д.) в контейнер
COPY . .

# Шаг 9: Укажите команду, которая будет выполняться при запуске контейнера
CMD ["python", "main.py"]