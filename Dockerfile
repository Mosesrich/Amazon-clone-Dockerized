FROM node:lts-buster-slim as base
ARG NODE_ENV=productions
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package.json .
COPY yarn.lock .

RUN yarn install 

# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app .

# Copy the files from the previous stage
COPY --from=base . . 

CMD ["yarn", "start"]
