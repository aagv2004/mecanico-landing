# Etapa 1: Construcción (Builder)
FROM node:20-alpine AS builder

WORKDIR /app

# Copiamos solo lo necesario para instalar dependencias primero (cache layer)
COPY package*.json ./
RUN npm ci

# Copiamos el resto del código
COPY . .

# Construimos la aplicación
RUN npm run build

# Etapa 2: Servidor (Runner)
FROM nginx:alpine

# Copiamos la configuración por defecto de nginx (opcional, usamos la default por ahora)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiamos los archivos construidos de la etapa anterior
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
