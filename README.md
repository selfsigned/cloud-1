# CLOUD-1

Wordpress app deployment using AWS + Packer + Ansible following 42's [guidelines]("https://cdn.intra.42.fr/pdf/pdf/73997/en.subject.pdf").
Said guidelines force the use of `docker-compose`.

*TODO infastructure diagram*

## Getting-started

1) Export your AWS credentials

```shell
$ export AWS_ACCESS_KEY=<Your access key here> AWS_SECRET_ACCESS_KEY=<Your secret access key here>
```

2) Put your local variables in *.auto.tf files, for example:

```shell
$ cat cloud1.auto.tfvars
domain = "cloud1sucks.quest" # Domain for our site
```

3) Replace the bucket-id in `main.tf` to something unique or remove the section entirely to use a local state file (not recommended).

4) Build the AMI using `Packer`

```shell
$ packer build aws_wp.pkr.hcl
```

5) Apply the `terraform` resources, the website should now be reachable at the ALB, and at the domain if the DNS server is set properly.

```shell
$ terraform init
[...]
$ terraform apply
[...]
```

6) Once Wordpress is up and you are logged as admin with your credentials change the Wordpress and Site address to HTTPS in `/wp-admin/options-general.php`