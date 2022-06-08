# Networking 
There are two networking labels that can be applied, keys `net-tcp-3306`, and `net-tcp-9000`, each with two possible values, `server` or `client`.

Containers with label `net-tcp-3306=client` are permitted to talk to containers with `net-tcp-3306=server` on the port named in the label.

The same logic applies to the `9000` label.
No other container-to-container communications are permitted.

To make label-based container intercommunication permissions apply, run the following commands on the command line:

## Variables
```bash
export OC_DEPLOY_PROJECT="dev" #(dev|test|prod);
```

## MariaDB Networking
* To setup networking so containers have access to db
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -f openshift/templates/networking/allow-tcp-port-3306.yaml | oc apply -f -`

## PHP Networking
* To setup networking so containers have access to php-fpm.
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -f openshift/templates/networking/allow-tcp-port-9000.yaml | oc apply -f -`

## Nginx
* To permit the outside world to reach the nginx container on a fundamental network-permissions level, run the following command on the command line.
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -f openshift/templates/networking/allow-from-openshift-ingress.yaml | oc apply -f -`