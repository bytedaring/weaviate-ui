FROM node:18 AS builder
WORKDIR /app
COPY ./frontend .

RUN yarn
RUN yarn build

FROM python:3.11-slim-buster
WORKDIR /app

COPY --from=builder /app/dist /app/static

COPY . .

RUN pip install poetry -i https://pypi.tuna.tsinghua.edu.cn/simple
COPY poetry.lock pyproject.toml ./
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi
COPY . .
CMD ["uvicorn", "weaviate_ui.main:app", "--host", "0.0.0.0", "--port", "7777"]

