# Stage 1: Build the application
FROM node:lts-buster-slim AS builder

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Copy the package.json and yarn.lock files to install dependencies
COPY package.json .
COPY yarn.lock .

RUN yarn install

# Copy the entire project
COPY . .

# Build the application (if there is a build step, otherwise this step can be omitted)
RUN yarn build

# Stage 2: Use a distroless image to run the application
FROM gcr.io/distroless/nodejs:16

# Set the working directory in the distroless image
WORKDIR /usr/src/app

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app /usr/src/app

# Expose the application port (if needed)
EXPOSE 3000

# Command to run the application
CMD ["yarn", "start"]
