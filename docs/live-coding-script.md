# Сценарий live coding для преподавателя

## Часть 1. Терминал

Показать:

```bash
pwd
ls
cd cmd
cd ..
cat README.md
```

Объяснить, что терминал показывает не «магический текст», а результат команд.

## Часть 2. Запуск Go

```bash
go version
go run ./cmd/app
go test ./...
```

Объяснить:

- `go version` проверяет установку Go;
- `go run` компилирует и запускает программу;
- `go test` запускает тесты.

## Часть 3. Git workflow

```bash
git status
git checkout -b lesson-01-demo
# меняем код
git add .
git commit -m "change greeting message"
git push origin lesson-01-demo
```

После этого открыть GitHub и показать Pull Request.
