This docker build is from https://github.com/docker-library/wordpress/ and is preserved here:
* So customizations can be made for our platform, if need be, and then preserved. 

This implementation is just the juicy php bits needed for WordPress to work, built in the WordPress way.
* Use it as 
  * A foundation of a WordPress runtime container that serves from a persistent volume.
  * A foundation of a WordPress build container with a toolchain to build dist assets for a runtime Nginx and WordPress suite of containers.
  * A foundation of a WordPress runtime container containing no toolchains or other attack surfaces, that includes the dist assets from the build container above.
