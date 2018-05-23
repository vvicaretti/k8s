### Use local kubectl:
```
$ vagrant ssh k8s-master -- "sudo cat /etc/kubernetes/admin.conf" > admin.conf
$ kubectl --kubeconfig ./admin.conf get nodes
```
