# Windows Agent Tool Images for Rancher

Since Kubernetes GA has announced joining Windows nodes to a Linux-based cluster via the Windows Server version 1809, we only support Windows Server version 1809 and above in future.

## Related Images

This repo only packages [docker.io/rancher/kubelet-pause](https://hub.docker.com/r/rancher/kubelet-pause/tags), other related images info comes following:

- [docker.io/rancher/hyperkube](https://hub.docker.com/r/rancher/hyperkube/tags) is operated by [rancher/hyperkube](https://github.com/rancher/hyperkube), since v1.14.1.
- [docker.io/rancher/flannel-cni](https://hub.docker.com/r/rancher/flannel-cni/tags) is operated by [rancher/flannel-cni](https://github.com/rancher/flannel-cni), since v0.3.0.

### About Windows Server Core

Windows Server Core mode offers great advantages such as smaller hardware requirements, much smaller attack surface, and a reduction in the need for updates. **Since it has no graphical user interface, Windows Server Core mode is best managed remotely**.

Windows Server Core mode version is not an "update" or "service pack" for Windows Server 2016 and above. It's the current twice-yearly server release on the release track that is designed for customers who are moving at a “cloud cadence," such as those on rapid development cycles. **This track is ideal for modern applications and innovation scenarios such as containers and micro-services**. Each release in this track is supported for 18 months from the initial release.

For more about Semi-Annual Channel, plus tips for deciding which channel to join (or remain on) see [Semi-Annual Channel Overview](https://docs.microsoft.com/en-us/windows-server/get-started/semi-annual-channel-overview).

#### Base Container

All images build from this repositry are based on **Windows Server Core(`Semi-Annual Channel`)** container image as below:

- [mcr.microsoft.com/powershell](https://hub.docker.com/r/microsoft/powershell/tags/)

Currently, the Microsoft has released the following Core mode versions:

- [Windows Server version 1709](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1709)
- [Windows Server version 1803](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1803)
- [Windows Server version 1809](https://docs.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-1809)

#### Version Compatibility

Older containers will run the same on newer hosts with [Hyper-V isolation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/hyperv-container), and the same (older) kernel version will still be used. However, if you want to run a container based on a newer Windows build - it can only run on the newer host build. More detail about this, please check out [here](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility).

#### Editions Comparison

When you want to run some Hyper-V containers on **Windows Server 2016** and above, please make sure which edition of your Windows host. An [article](https://www.thomas-krenn.com/en/wiki/Windows_Server_2016_Editions_comparison) from Thomas Krenn can help you.


## License

- This image is released under the [MIT License](LICENSE)
