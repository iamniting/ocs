This playbook will help us to automate our manual tasks or preq for ocp + ocs installation eg. subscription manager, yum, docker configration and password less ssh authentication

Edit the _hosts.ini_ file and add the hostnames or ip addresses in the file.
Edit the credentials for subscription manager
Edit the vm_password for password less ssh authentication
Change the repos and packages according to requirement

```
# cd ocs/ansible/ocp-preq
# vim hosts.ini
# ansible-playbook config.yml -i hosts.ini
```
