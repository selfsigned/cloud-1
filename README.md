# CLOUD-1

Wordpress app deployment using AWS + Packer + Ansible following 42's [guidelines]("https://cdn.intra.42.fr/pdf/pdf/73997/en.subject.pdf").
Said guidelines restrict the use of services like amazon's convenient `RDS` and force the use of `docker-compose`, giving the project an amateur-ish flare.

*TODO infastructure diagram*

## Getting-started

1) Export your AWS credentials

```shell
$ export AWS_ACCESS_KEY=<Your access key here> AWS_SECRET_ACCESS_KEY=<Your secret access key here>
```

3) Replace the bucket-id in `main.tf` to something unique or remove the section entirely to use a local state file (not recommended).

3) TODO