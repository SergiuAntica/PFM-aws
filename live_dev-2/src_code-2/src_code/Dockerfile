# Primer Stage
FROM python:3.9 as builder
WORKDIR /app
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt


# Segundo Stage
FROM python:3.9
WORKDIR /app
COPY --from=builder /app/venv ./venv
COPY main.py .
ENV PATH="/app/venv/bin:$PATH"
EXPOSE 80
CMD ["python", "/app/main.py"]