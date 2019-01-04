## Ansible playbooks

Edit the external_vars.yaml file for ansible variables according to your setup
```
# cd ocs/ansible
# vim external_vars.yaml
```

This playbook will help us to automate our manual tasks or preq for ocp + ocs installation
eg. subscription manager, yum, docker configration and ssh

Run the playbook
```
# ansible-playbook -i "dhcp46-111.lab.eng.blr.redhat.com, dhcp46-112.lab.eng.blr.redhat.com, dhcp46-113.lab.eng.blr.redhat.com" ocp_preq.yaml
```
