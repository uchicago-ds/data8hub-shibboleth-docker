# jhub-data8-shibboleth-docker
Docker image for Jupyterhub with Data8 and Shibboleth compatibility

Hosted at Dockerhub: https://cloud.docker.com/u/uchicagods/repository/docker/uchicagods/jhub-data8-shibboleth

Built based off of the Berkeley Docker image: https://github.com/berkeley-dsep-infra/datahub

Many unnecessary things are removed, and the [jhub_shibboleth_auth](https://github.com/gesiscss/jhub_shibboleth_auth) requirement is added. Otherwise, it's basically the same.

If you want to change it, and re-deploy to Dockerhub, consult the sharing part of [this guide](https://hackernoon.com/publish-your-docker-image-to-docker-hub-10b826793faf).
