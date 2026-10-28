# Evidence log

Terminal output captured while building Capstone 1. Screenshots are in [`screenshots/`](screenshots/).

## Environment rebuilt from code (27 Oct 2026, after a full `terraform destroy`)

```
aws_eks_cluster.main: Creation complete after 9m20s [id=capstone-eks]
aws_eks_node_group.main: Creation complete after 1m20s [id=capstone-eks:capstone-nodes]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

cluster_name = "capstone-eks"
kubeconfig_command = "aws eks update-kubeconfig --region us-west-2 --name capstone-eks"
```

## Nodes ready

```
$ kubectl get nodes
NAME                                         STATUS   ROLES    AGE     VERSION
ip-172-31-24-2.us-west-2.compute.internal    Ready    <none>   2m37s   v1.37.1-eks-39aca56
ip-172-31-59-20.us-west-2.compute.internal   Ready    <none>   2m36s   v1.37.1-eks-39aca56
```

## Helm install

```
$ helm install voting ./helm/voting-app --set image.tag=$(git rev-parse HEAD)
NAME: voting
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
```

## App running on EKS

```
$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
db-cdc95cd47-s8s5p        1/1     Running   0          71s
redis-56df5d468c-hz928    1/1     Running   0          71s
result-7f884d6b4d-qvms9   1/1     Running   0          71s
vote-7b4df478bb-qwfxt     1/1     Running   0          71s
worker-6f648fb96f-rd6mm   1/1     Running   0          71s
```

## Free-tier node failure (root cause found in the Auto Scaling Group log)

```
$ aws autoscaling describe-scaling-activities --region us-west-2 --max-items 5
"status": "Failed",
"why": "Could not launch On-Demand Instances. InvalidParameterCombination - The specified instance type is not eligible for Free Tier. ..."
```

Fixed by switching the node group from `t3.medium` to `m7i-flex.large`.

## Screenshots

| File | Shows |
|---|---|
| `01-compose-all-services-up.png` | All five services running locally with Docker Compose |
| `02-debug-iptables-legacy-forward-drop.png` | Root cause of "Waiting for db": legacy FORWARD policy DROP, only `docker0` allowed |
| `03-debug-fixed-worker-connected-to-db.png` | After the fix: port 5432 open, worker connected to db and redis |
| `04-vote-image-runs-as-appuser.png` | Hardened vote image runs as non-root `appuser` |
| `05-worker-image-runs-as-appuser.png` | Hardened worker image runs as non-root `appuser` |
| `06-ci-trivy-action-version-not-found.png` | First pipeline failure: Trivy action tag did not exist |
| `07-ci-vote-passes-result-worker-blocked.png` | Trivy blocks result and worker (end-of-life base images) |
| `08-trivy-critical-system-drawing-common.png` | CRITICAL CVE-2021-24112 in a transitive NuGet dependency |
| `09-trivy-debian-11-end-of-life.png` | .NET 7 runtime image on unsupported Debian 11 |
| `10-upgraded-pinned-dotnet8-node22.png` | Upgraded and digest-pinned .NET 8 and Node 22 base images |
| `11-worker-on-dotnet8-connected.png` | Worker on .NET 8 still connects to Redis |
| `12-ci-unknown-blob-on-push.png` | Registry `unknown blob` error, fixed by pushing with Buildx |
| `13-helm-install-pods-running-on-eks.png` | `helm install` revision 1, all five pods Running on EKS |
| `14-vote-page-served-by-eks-pod.png` | Vote page via port-forward; the container ID matches the EKS pod name |
| `15-result-page-on-eks.png` | Result page counting votes on EKS |
| `16-bad-release-errimagepull.png` | Bad release on purpose: new pods `ErrImagePull`, old pods keep serving |
| `17-helm-rollback-history.png` | `helm rollback voting 1`: pods healthy, history shows revision 3 "Rollback to 1" |

## Bad release and rollback (28 Oct 2026)

```
$ helm upgrade voting ./helm/voting-app --set image.tag=broken-on-purpose
REVISION: 2

$ kubectl get pods
result-7d7644bf9d-6vkc7   0/1     ErrImagePull   0          5s
result-7f884d6b4d-l2d7g   1/1     Running        0          4m25s
vote-6ff7bfc85d-b8zp2     0/1     ErrImagePull   0          4s
vote-7b4df478bb-ds8jz     1/1     Running        0          4m26s
worker-7d874ffccc-f2892   0/1     ErrImagePull   0          3s
worker-6f648fb96f-rgf2f   1/1     Running        0          4m26s

$ helm rollback voting 1
Rollback was a success! Happy Helming!

$ helm history voting
REVISION  STATUS      DESCRIPTION
1         superseded  Install complete
2         superseded  Upgrade complete
3         deployed    Rollback to 1
```

The rolling update kept the old pods serving while the broken ones failed, so the app stayed up during the bad release.
