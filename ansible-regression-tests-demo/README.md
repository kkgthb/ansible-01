```sh
ansible-playbook --limit localhost --connection=local ./ansible-regression-tests-demo/tasks/verify.yml
```

I don't yet understand how to hook it up to `.main.yml`