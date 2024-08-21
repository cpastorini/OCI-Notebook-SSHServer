
# SSH Data Science Notebook Session

## Table of Contents
  - [Introduction](#introduction)
  - [Prerequisite](#prerequisite)
  - [Step-by-Step Guide](#step-by-step-guide)
    - [Runtime Configuration](#runtime-configuration)
    - [Run the Script](#run-the-script)
    - [VSCode Configuration](#vscode-configuration)


## Introduction
Enabling the SSH tunnel to OCI Data Science notebooks provides the ability to do remote debugging and coding using tools like VSCode Remote-SSH or PyCharm's equivalent feature. Additionally, you can connect to the instance for manual debugging.

## Prerequisite
- Create a [Notebook Session](https://docs.oracle.com/en-us/iaas/data-science/using/manage-notebook-sessions.htm) in OCI Data Science Service using your own [VCN](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/VCNs.htm) and [Private Subnet](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/privateaccess.htm).
- Use a Public Git Repository as url in Runtime Configuration

## Step-by-Step Guide
This guide outlines the steps required to enable SSH tunneling.

### Runtime Configuration
You can either clone this repository or configure it as  `Runtime Configuration` during creation.

You can use up to 3 public Git repositories for the notebook session. The notebook must have public internet access to connect.

![Runtime Configuration Section](https://LIKN TO BE UPDATE/RuntimeConfig.png)


### Run the Script
You will have a `Repos` folder inside your NotebookSession, with following files:
- install_start_ssh.sh
- nb_ip.py
- ssh_script_state.txt

You need to open a new Terminal and run the install_start_ssh.sh Script:

`sh install_start_ssh.sh`


If the script runs successfully you will see something like:
```bash
Prima esecuzione dello script. Eseguo operazioni di setup iniziale...
Updated cuda.repo successfully.
Updated yum.oracle.com_repo_OracleLinux_OL7_developer_EPEL_x86_64.repo successfully.
Repository URLs updated successfully.
Loaded plugins: ovl
cuda                                                                                                                                                                                                                                              | 3.0 kB  00:00:00     
https://artifactory.oci.oraclecorp.com/ol7-yum/repodata/repomd.xml: [Errno 14] curl#6 - "Could not resolve host: artifactory.oci.oraclecorp.com; Unknown error"
Trying other mirror.
yum.oracle.com_repo_OracleLinux_OL7_developer_EPEL_x86_64                                                                                                                                                                                         | 3.6 kB  00:00:00     
Package openssh-server-7.4p1-23.0.3.el7_9.x86_64 already installed and latest version
Nothing to do
Generating public/private rsa key pair.
/home/datascience/.ssh/ssh_host_rsa_key already exists.
Overwrite (y/n)? y
Your identification has been saved in /home/datascience/.ssh/ssh_host_rsa_key.
Your public key has been saved in /home/datascience/.ssh/ssh_host_rsa_key.pub.
The key fingerprint is:
SHA256:cm2jWY8sCq7+fRBE/xeJSxba3fe2DcEyyncmOq+do+g datascience@3cdcf6744449
The key's randomart image is:
+---[RSA 4096]----+
|     ..   .      |
|      .. o + +   |
|     .  o = * + .|
|      .  * o + o.|
|      ..S X + + o|
|      .o * B + oo|
|    .  .+ = .  ..|
|   . o ..o +..   |
| .ooo ooE oo+.   |
+----[SHA256]-----+
-----BEGIN RSA PRIVATE KEY-----
<keycontent>
-----END RSA PRIVATE KEY-----
Run the OpenSSH Server on Port: 12345
Wait...
Setup iniziale completato.
L'indirizzo IP privato del notebook è: 10.29.63.153
Per connettersi usare la chiave, la porta e l'indirizzo ip mostrati sopra
ssh -i <key_name>.key datascience@10.29.63.153 -p  12345
File di stato aggiornato a First_Run=False.
```

Per connettersi sarà quindi necessario utilizzare la chiave mostrata a schermo e salvata nel file ssh_host_rsa_key:

`ssh -i <key_name>.key datascience@yourIP -p  yourPort`
### VSCode Configuration
To use the VSCode Remote SSH feature, add the localhost configuration to your local machine's SSH config file:

```bash
vi ~/.ssh/config
```

For Windows you can edit the following file:
```bash
C:\Users\<user>\.ssh
```


Add the following entry:

```bash
Host notebookname
    HostName <notebookPrivateIP>
    User datascience
    Port 12345
    IdentityFile <path to your notebook RSA key on your machine>/<key_name>.key
```

Open VSCode and use the Remote-SSH: Connect to Host feature to select localhost from the list, bringing you directly into the notebook.
