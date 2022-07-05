rem [32m Building Docker container and importing to WSL [0m
docker build --build-arg USER=%USERNAME% -t viur-env -f resources\Dockerfile .
docker run --name viur-env viur-env
docker export --output="viur-env.tar.gz" viur-env
docker container rm viur-env
docker rmi viur-env

rem [32m Setting the WSL version to 2 and importing the new distro [0m
wsl --set-default-version 2
wsl --import viur-env .\installDir .\viur-env.tar.gz
wsl --set-default viur-env

rem [32m Cleaning up build files [0m
del viur-env.tar.gz