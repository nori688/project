# ---- Stage 1: build Flutter web app ----
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Cache pub dependencies first
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the project and build web release
COPY . .
RUN flutter build web --release

# ---- Stage 2: serve with nginx ----
FROM nginx:1.27-alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
