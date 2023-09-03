# php-server
A simple PHP web server with GD in Docker with support for PHP secrets.

## Usage
Docker commands:
- To build: `npm run build`
- To start: `npm run start`
- To stop: `npm run stop`

Docker compose commands:
- To build: `npm run build:compose`
- To start: `npm run start:compose`
- To stop: `npm run stop:compose`

Notes:
- The build process will copy the secrets files from the `.env` directory to the `/opt/.secrets` directory inside the image. If you update the secrets files, you will need to rebuild the image.
- The build process runs two build arguments in order to get the **UID** and **GID** from the directory you are building it from, which is presumably the direcctory you cloned this repo into. The purpose of this is to change the internal **www-data** user's **UID** and **GID** to match that of the directory. This allows the PHP server to be able to write files to the `/var/www/html` directory that is volume mounted from the host and is where you will put the web files for the server to serve.
    - The build arguments are: `--build-arg UID=$(stat -c %u .) --build-arg GID=$(stat -c %g .)`
