# Access a secret from the running application

To use the secret we created in the last lab, we'll mount it into the pods running our application and change the application to surface the value. In a real application, we'd not surface the value of a secret in the user interface, but this is for demonstration purposes only.

## Access a secret in the application

In your application repository, add another path to your simple http server application code that reads a file and make sure to import `io/ioutil`.

The code will now look like this:

``` Go

package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, GitOps!")
    })
    http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, User!")
    })
    http.HandleFunc("/sauce", func(w http.ResponseWriter, r *http.Request) {
        fileContent, err := ioutil.ReadFile("./application-secret/sauce")
        var secretSauce = "unknown"
        if err == nil {
            secretSauce = string(fileContent)
        }
        fmt.Fprint(w, "The secret sauce is: ", secretSauce)
    })

    http.ListenAndServe(":8080", nil)
}
```

Coomit this code and push it to your remote repository.

## Mount the secret in your deployment

In your infrastructure repository, we'll mount the secret we've created to enable the application to see it as a file on the filesystem of the container.

We do this by changing the container spec in the deployment manifest.

Edit `yaml-manifests/simple-http-server-deployment.yaml` to include a volume and a volumeMount.

It will now look like this

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-http-server-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: simple-http-server
  template:
    metadata:
      labels:
        app: simple-http-server
    spec:
      containers:
      - name: simple-http-server
        image: ghcr.io/raelyard/simple-http-server:4319974167
        ports:
        - containerPort: 8080
        volumeMounts:
        - mountPath: "/app/application-secret/"
          name: application-secret
          readOnly: true
      volumes:
        - name: application-secret
          secret:
            secretName: application-secret
```

Commit this updated YAML document, push it, and refresh the application in your browser in ArgoCD.

If you request the new path, you should see the secret value in action.

```
curl http://localhost:8080/simple-http-server/sauce
The secret sauce is: teriyaki
```
