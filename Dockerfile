#1
# начинаем с базового образа, который содержит Java runtime
FROM openjdk:11-slim as build
# добавляем информацию о владельце
LABEL maintainer="ivvasch@gmail.com"
# тип файла
ARG JAR_FILE
# добавляем файл приложения в контейнер
COPY ${JAR_FILE} app.jar
# распаковываем jar файл
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

#2
# такая же java runtime
FROM openjdk:11-slim
#  добавляем том указывающий на /tmp
VOLUME /tmp
# Копируем неупакованное приложение в контейнер
ARG DEPENDENCY=/target/dependency
COPY --from=build $DEPENDENCY/BOOT-INF/lib /app/lib
COPY --from=build $DEPENDENCY/META-INF /app/META-INF
COPY --from=build $DEPENDENCY/BOOT-INF/classes /app

# запускаем наше приложение
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.optimagrowth.OrganizationServiceApplication"]
