This playbook will help us to automate our manual tasks or preq for ocp + ocs installation eg. subscription manager, yum, docker configration and password less ssh authentication.

Edit the __hosts.ini__ file and add the hostnames or ip addresses in the file.
<br />
Edit the credentials for subscription manager.
<br />
Edit the vm_password for password less ssh authentication.
<br />
Change the repos and packages according to requirement.
<br />

```
# cd ocs/ansible/ocp-preq
# vim hosts.ini
# ansible-playbook config.yml -i hosts.ini
```
