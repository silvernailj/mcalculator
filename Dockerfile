#TITLE:  WASM Windows Calc
#VERSION: 0.0.1
#DATE: 6.27.2023
#TO BUILD  docker build -t mcalculator .
#TO RUN    docker run -p 80:80 mcalculator

# Use a suitable base image
FROM ubuntu:latest as builder

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    make \
    emscripten \
    build-essential \
    llvm \
    clang \
    zlib1g-dev

# Clone the repository
RUN git clone https://github.com/muzam1l/mcalculator.git

# Build the WebAssembly calculator
WORKDIR /mcalculator/engine
RUN emcmake cmake . 
RUN emmake make

# Set up a web server
FROM nginx:alpine
COPY --from=builder /mcalculator/engine/engine.wasm /mcalculator/server/public/js/engine.wasm
COPY --from=builder /mcalculator/engine/engine.js /mcalculator/server/public/js/engine.js
COPY --from=builder /mcalculator/server/public/index.html /usr/share/nginx/html/index.html
COPY --from=builder /mcalculator/server/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

#TO BUILD  docker build -t mcalculator .
#TO RUN    docker run -p 80:80 mcalculator

