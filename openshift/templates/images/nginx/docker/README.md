This docker build is new and is preserved here:
* So customizations can be made for our platform, if need be, and then preserved.
  * It makes the nginx-alpine container work in openshift properly.
    * It is simply customizing the upstream nginx-alpine container, not creating an independent fork, because if we can't trust that container, the world is probably doomed.
