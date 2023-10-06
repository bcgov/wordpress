This docker build is from https://github.com/jbergstroem/mariadb-alpine and is preserved here:
* In case that repository ever disappears. 
* So the Dockerfile is always a known commodity. 
  * If we were to use the original directly, we don't have to worry about the original changing, for reasons of:
    * Compatibility
    * Security
  * Customizations can be made for our platform, if need be, and then preserved.
* The mariadb packages for specific versions of Alpine can be found here: https://pkgs.alpinelinux.org/packages?name=mariadb&branch=v3.15